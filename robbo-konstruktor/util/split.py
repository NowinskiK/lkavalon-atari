"""Splits the Robbo Konstruktor memory image into source blocks (like the other games in this repo):
code areas -> src/*.ASM (disassembly), data areas -> binary files with an Atari $FFFF header,
plus src/JOINT.ASM (common labels) and main.asm (links everything back together).

Usage (from robbo-konstruktor/): py -3 util/split.py game.bin [EXTRA_ENTRY ...]
Entry points come from ENTRIES and the dispatch tables (see entries()); edit the tables, then run it again."""
import sys, os
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from xex import L
from rdis import analyze, Lister, hw

# (file, first, last, description) - .ASM files are disassembled, everything else is written as binary
BLOCKS = [
    ('RUNAD.DTA',   0x02E0, 0x02E1, 'RUNAD = $A810'),
    ('HOOK.ASM',    0x0480, 0x0482, 'restart hook: JMP $A810'),
    ('BOOT.ASM',    0x0500, 0x067F, 'boot sectors 1-3: boot record and binary-file loader (cracked)'),
    ('EDIT08.ASM',  0x0800, 0x0C6C, 'code: JMP $09A6 at $0800, tables, routines'),
    ('HELP.ASM',    0x0C6D, 0x1DD0, 'help text: 16 pages in Polish (HELP key), packed: bit 7 = add a space'),
    ('ENGINE1.ASM', 0x1E00, 0x23FC, 'game engine: jump table $1E00, display list, DLIs'),
    ('ENGINE2.ASM', 0x243D, 0x35A3, 'game engine: object behaviour (table $31EF), VBI $2F54'),
    ('ENGINE3.ASM', 0x35C0, 0x395C, 'game engine: display list, code'),
    ('FONT3C.FNT',  0x3C00, 0x3FFF, 'font (modified Robbo F.FNT)'),
    ('D4000.DTA',   0x4000, 0x47FF, 'data'),
    ('FONT48.FNT',  0x4800, 0x4BFF, 'font (modified Robbo S.FNT)'),
    ('FONT4C.FNT',  0x4C00, 0x4FFF, 'font (modified Robbo I.FNT)'),
    ('EDIT90.ASM',  0x9000, 0x9430, 'editor code'),
    ('EDITOR.ASM',  0x94E0, 0x9F7A, 'editor: menu dispatch, cursor, commands'),
    ('TEXTS.ASM',   0x9F7B, 0xA808, 'editor tables (menu table $9F8E) and texts: screens, messages, element names'),
    ('EDITOR2.ASM', 0xA810, 0xB5FF, 'editor: jump table $A810, main loop, screen, DLI, text input'),
    ('LOADSCR.ASM', 0xBC40, 0xBC67, 'loading screen line "Robbo Konstruktor (C) 1990 Avalon"'),
]

# fixed entry points (the dispatch-table entries are added by entries())
ENTRIES = [0x0480, 0x0506, 0x0800, 0x1E00, 0x1E03] + list(range(0xA810, 0xA840, 3)) + \
          [0x979E, 0x97C9, 0x968F, 0x99B5, 0x9626, 0x9814, 0x9C3E, 0x9BEB]   # menu table $9F8E

# JMP/JSR instructions with self-modified operands (dispatch slots, wait loops) - not followed;
# immediate addresses written into their operands become entry points (rdis.analyze)
NOFOLLOW = {
    0x9554,   # menu dispatch: jsr (handler from $9F8E)
    0x2148,   # engine: jsr (object behaviour from $31EF)
    0x9028,   # editor sub-commands: jmp (from $902F)
    0x9A61,   # editor sub-menu: jmp (from $9AFA)
    0xB238,   # text input: jmp (key handler from $B330)
    0x246D,   # engine: jmp to itself until patched
}


def entries(mem):
    """ENTRIES plus the handlers listed in the dispatch tables."""
    w = lambda a: mem[a] | mem[a + 1] << 8
    e = list(ENTRIES)
    e += [w(0x31EF + y) for y in range(0, 0xC2, 2) if w(0x31EF + y)]   # 97 object behaviours
    e += [w(0x902F + 2 * i) for i in range(4)] + [w(0x9AFA + 2 * i) for i in range(4)]
    k = 0xB330
    while mem[k]:
        e.append(w(k + 1)); k += 3                                      # key handlers
    return e


# Variables, names and comments taken from the original Robbo sources where the engine code matches them
# (instruction-shape match, NOTES.md section 5); the rest is added as it is understood.
# data written as strings: first -> (last, format); 'help' = ATASCII, bit 7 = a space follows, $00 nn = page
# marker, Polish letters as CONTROL codes; 'screen' = ANTIC screen codes (dta d'...')
TEXTS = {
    0x0C7B: (0x1DD0, 'help'),       # help pages 0-15 (after the preamble $0C6D-$0C7A)
    0x9FBB: (0xA316, 'screen-pl'),  # editor screens: main menu, title, planet legend, disk panel, save hints
    0xA318: (0xA7D5, 'strings'),    # editor messages, errors, element names ($A317 is a variable)
    0xA7D8: (0xA7F7, 'strings'),    # tape/disk labels, 8 characters each (read with lda $A7D8,x)
    0xA804: (0xA808, 'strings'),    # "Robbo"
    0xBC40: (0xBC67, 'screen'),     # loading screen line, inverse video
}

VARIABLES = [
    '* zero page - engine (Robbo layout, names from robbo/d1/R1.ASM) ---',
    (0x0080, 2, 'ADDR', 'pointer'),
    (0x0082, 2, 'SCRA', 'screen address'),
    (0x0084, 2, 'CHAD', 'pointer (Robbo CHAD)'),
    (0x0086, 2, 'FADR', 'pointer (Robbo FADR)'),
    (0x0092, 1, 'X', 'current cell X'),
    (0x0093, 1, 'Y', 'current cell Y'),
    (0x0094, 1, 'X1', 'cell X (second)'),
    (0x0095, 1, 'Y1', 'cell Y (second)'),
    (0x0096, 1, 'FX', 'Robbo FX'),
    (0x0097, 1, 'FY', 'Robbo FY'),
    (0x0098, 1, 'LM', 'Robbo LM'),
    (0x0099, 1, 'VSF', 'vertical scroll, fine'),
    (0x009A, 1, 'VSC', 'vertical scroll, coarse'),
    (0x009B, 1, 'TELE', 'teleport (Robbo TELE)'),
    (0x009C, 1, 'FAC', 'Robbo FAC (facing / state)'),
    (0x009D, 1, 'CNUM', 'cave number'),
    (0x009E, 1, 'KEYS', 'keys collected'),
    (0x009F, 1, 'LIVS', 'lives'),
    (0x00A0, 1, 'ZEBR', 'collected ("zebrane") - screws'),
    (0x00A1, 1, 'LSTE', 'Robbo LSTE'),
    (0x00A2, 1, 'NABO', 'ammunition ("naboje")'),
    (0x00A3, 1, 'DEMO', 'demo mode flag'),
    (0x00A4, 3, 'SCOR', 'score, BCD'),
    (0x00A7, 1, 'HLP', 'temporary (Robbo HLP)'),
    (0x00A8, 1, 'RUCH', 'move ("ruch")'),
    (0x00AA, 1, 'TOLE', 'Robbo TOLE'),
    '* zero page - editor -----------',
    (0x00C4, 1, 'FRAMES', 'editor frame counter (main loop)'),
    (0x00C5, 1, 'CUR_X', 'cursor column (0-15 board, 17-19 palette)'),
    (0x00C6, 1, 'CUR_Y', 'cursor row (0-9)'),
    (0x00C7, 1, 'WIN_TOP', 'first board row shown in the 10-row window'),
    (0x00C8, 1, 'SCR_PAGE', 'screen buffer being drawn ($B6 / $B8)'),
    (0x00C9, 1, 'PAL_SEL', 'selected palette row'),
    (0x00CA, 1, 'ED_FLAGS', 'editor flags (bit 7 tested by the cursor and the redraw)'),
    (0x00CB, 1, 'MENU_POS', 'main menu: row, bit 7 = page (basic / additional functions)'),
    (0x00CD, 1, 'PLANET', 'current planet (0-31), bit 7 = none'),
    (0x00CE, 1, 'HELP_PAGE', 'help page shown by the HELP key (2 = menu, 3-12 = functions)'),
    (0x00CF, 1, 'PANEL_ST', 'lower screen panel state (PANEL)'),
    '* editor state in the text block ---',
    (0xA317, 1, 'CUR_MSG', 'number of the message in the status line'),
    (0xA7D6, 1, 'CUR_ELEM', 'palette entry whose name is shown'),
    '* input ------------------------',
    (0xA840, 1, 'JOY', 'input bits: stick, fire'),
    (0xA841, 1, 'JOY_LAST', 'previous stick value'),
    (0xA842, 1, 'JOY_RPT', 'auto-repeat counter'),
    (0xA843, 1, 'TRIG_ST', 'fire / console keys'),
    (0xA844, 1, 'EVENT', 'input event flag'),
    (0xA845, 1, 'TRIG_LAST', 'previous fire / console keys'),
    '* planets ----------------------',
    (0x39A0, 32, 'PLANET_STATE', 'status of the 32 planets: 0 empty, bit 7 = bad (low bits = error message), else good'),
    (0x94F8, 1, 'DISK_SLOTS', 'directory result: used slots, negative = no disk'),
]

COMMENTS = {
    0x2092: 'next cave (Robbo: "nxtcv")',   # Robbo $1E5F
    0x2344: 'Robbo routine FD_, not analysed yet',   # Robbo $2124
    0x2363: 'test the cell to the left',   # Robbo $2143
    0x236D: 'test the cell to the right',   # Robbo $214D
    0x238D: 'add points to the score (Robbo: "dodaj punkty")',   # Robbo $256C
    0x23FA: 'Robbo routine TST_W, not analysed yet',   # Robbo $2C6E
    0x2513: 'Robbo routine CM1, not analysed yet',   # Robbo $2055
    0x2528: 'Robbo routine CM2, not analysed yet',   # Robbo $206A
    0x255D: 'Robbo routine FA1, not analysed yet',   # Robbo $209F
    0x256F: 'Robbo routine CM3, not analysed yet',   # Robbo $20B1
    0x2619: 'Robbo appears (Robbo: "pojawiaj")',   # Robbo $2182
    0x26A1: 'Robbo routine KIES, not analysed yet',   # Robbo $21FC
    0x26D0: 'Robbo routine MFC1, not analysed yet',   # Robbo $2250
    0x276E: 'push an object (Robbo: "pchaj?")',   # Robbo $231F
    0x27EE: 'Robbo routine FGET, not analysed yet',   # Robbo $23F6
    0x27FF: 'door: opens with a key, KEYS (Robbo: "drzwi?")',   # Robbo $2407
    0x2825: 'screw / treasure (Robbo: "skarb?")',   # Robbo $242D
    0x2858: 'exit (Robbo: "wyjscie?")',   # Robbo $2460
    0x28C2: 'test: sliding box',   # Robbo $24CA
    0x293B: 'Robbo routine WYCP, not analysed yet',   # Robbo $239D
    0x2957: 'Robbo routine WYSE, not analysed yet',   # Robbo $23B9
    0x297B: 'surprise box: random object (RND)',   # Robbo $24F4
    0x2996: 'Robbo routine SUP1, not analysed yet',   # Robbo $250F
    0x29BA: 'Robbo routine SUP2, not analysed yet',   # Robbo $2533
    0x29F3: 'sliding box (bezwladna skrzynia) moving left until blocked (Robbo: "bezw skrzynie")',   # Robbo $257F
    0x29FE: 'sliding box (bezwladna skrzynia) moving right until blocked (Robbo: "bezw skrzynie")',   # Robbo $258A
    0x2A09: 'sliding box (bezwladna skrzynia) moving up until blocked (Robbo: "bezw skrzynie")',   # Robbo $2595
    0x2A14: 'sliding box (bezwladna skrzynia) moving down until blocked (Robbo: "bezw skrzynie")',   # Robbo $25A0
    0x2A19: 'sliding box: cannot move',   # Robbo $25A5
    0x2A24: 'sliding box: common part',   # Robbo $25B0
    0x2A29: 'random return (Robbo: "losowy powrot")',   # Robbo $25B5
    0x2A6E: 'Robbo routine BOM0, not analysed yet',   # Robbo $25E5
    0x2AB7: 'put an explosion or empty space (Robbo: "put wyb|spc")',   # Robbo $261A
    0x2AD3: 'pulled in by a magnet: Robbo destroyed, sound $0A',   # Robbo $2658
    0x2AF8: 'small gun bullet (pocisk) moving left',   # Robbo $267B
    0x2B01: 'small gun bullet position (pozycja pocisku): next cell left, hit tests',   # Robbo $2684
    0x2B3E: 'small gun bullet (pocisk) moving right',   # Robbo $26C1
    0x2B47: 'small gun bullet position (pozycja pocisku): next cell right, hit tests',   # Robbo $26CA
    0x2B64: 'small gun bullet (pocisk) moving up',   # Robbo $26E7
    0x2B6D: 'small gun bullet position (pozycja pocisku): next cell up, hit tests',   # Robbo $26F0
    0x2B8A: 'small gun bullet (pocisk) moving down',   # Robbo $270D
    0x2B93: 'small gun bullet position (pozycja pocisku): next cell down, hit tests',   # Robbo $2716
    0x2BA8: 'laser fires left',   # Robbo $272B
    0x2BAE: 'laser bullet (pocisk) moving left',   # Robbo $2731
    0x2BBF: 'laser bullet position (pozycja pocisku): next cell left, hit tests',   # Robbo $2742
    0x2BED: 'laser fires right',   # Robbo $2770
    0x2BF3: 'laser bullet (pocisk) moving right',   # Robbo $2776
    0x2C04: 'laser bullet position (pozycja pocisku): next cell right, hit tests',   # Robbo $2787
    0x2C12: 'laser fires up',   # Robbo $2795
    0x2C18: 'laser bullet (pocisk) moving up',   # Robbo $279B
    0x2C29: 'laser bullet position (pozycja pocisku): next cell up, hit tests',   # Robbo $27AC
    0x2C37: 'laser fires down',   # Robbo $27BA
    0x2C3D: 'laser bullet (pocisk) moving down',   # Robbo $27C0
    0x2C4E: 'laser bullet position (pozycja pocisku): next cell down, hit tests',   # Robbo $27D1
    0x2C5F: 'blaster fires left',   # Robbo $27E2
    0x2C65: 'blaster bullet (pocisk) moving left',   # Robbo $27E8
    0x2C79: 'blaster bullet position (pozycja pocisku): next cell left, hit tests',   # Robbo $27FC
    0x2C8E: 'blaster fires right',   # Robbo $2811
    0x2C94: 'blaster bullet (pocisk) moving right',   # Robbo $2817
    0x2CA8: 'blaster bullet position (pozycja pocisku): next cell right, hit tests',   # Robbo $282B
    0x2CBD: 'blaster fires up',   # Robbo $2840
    0x2CC3: 'blaster bullet (pocisk) moving up',   # Robbo $2846
    0x2CD7: 'blaster bullet position (pozycja pocisku): next cell up, hit tests',   # Robbo $285A
    0x2CEC: 'blaster fires down',   # Robbo $286F
    0x2CF2: 'blaster bullet (pocisk) moving down',   # Robbo $2875
    0x2D06: 'blaster bullet position (pozycja pocisku): next cell down, hit tests',   # Robbo $2889
    0x2D1B: 'blaster: test for a bomb (Robbo: "dz3 test bomba")',   # Robbo $289E
    0x2D29: 'put a surprise box (Robbo: "put niespodzianka")',   # Robbo $28AC
    0x2D33: 'rotating small gun (Robbo: "ruch dzialo")',   # Robbo $28B6
    0x2D54: 'Robbo routine RDZL, not analysed yet',   # Robbo $28D7
    0x2D5F: 'Robbo routine RDZ1, not analysed yet',   # Robbo $28E2
    0x2D80: 'moving small gun, left (Robbo: "mov dziala")',   # Robbo $2903
    0x2D93: 'moving small gun, right',   # Robbo $2916
    0x2DA3: 'moving small gun: common part',   # Robbo $2926
    0x2DA6: 'Robbo routine ZAPO, not analysed yet',   # Robbo $2929
    0x2EEE: 'Robbo routine LEX, not analysed yet',   # Robbo $2AE0
    0x2EF4: 'Robbo routine SKAC, not analysed yet',   # Robbo $2AE6
    0x300D: 'scroll the cave view',   # Robbo $2E14
    0x3029: 'scroll up',   # Robbo $2E30
    0x304D: 'scroll down',   # Robbo $2E54
    0x305A: 'scroll: load a screen line',   # Robbo $2E61
    0x3334: 'start a sound effect (A = effect)',   # Robbo $307A
    0x3367: 'Robbo routine PSST, not analysed yet',   # Robbo $30AD
    0x3370: 'Robbo routine RESE, not analysed yet',   # Robbo $30B6
    0x3379: 'sound effects: VBI part',   # Robbo $30BF
    0x3384: 'Robbo routine SO1, not analysed yet',   # Robbo $30CA
    0x338E: 'Robbo routine SO2, not analysed yet',   # Robbo $30D4
    0x3394: 'Robbo routine SO3, not analysed yet',   # Robbo $30DA
    0x339A: 'sound effects: play',   # Robbo $30E0
    0x9EE2: 'display a byte as two digits (Robbo: "display byte")',   # Robbo $2E86
    0x22D0: 'step X one cell right; carry set if the cell is free',   # Robbo $20C4 (name from call sites)
    0x22EF: 'step X one cell left; carry set if the cell is free',   # Robbo $20DD (name from call sites)
    0x2308: 'step Y one cell down; carry set if the cell is free',   # Robbo $20F4 (name from call sites)
    0x2329: 'step Y one cell up; carry set if the cell is free',   # Robbo $210D (name from call sites)
    0x2358: 'Robbo routine JMP1, not analysed yet',   # Robbo $2138 (name from call sites)
    0x2377: 'test the cell above',   # Robbo $2157 (name from call sites)
    0x2381: 'test the cell below',   # Robbo $2161 (name from call sites)
    0x2388: 'Robbo routine T_EX, not analysed yet',   # Robbo $2168 (name from call sites)
    0x23AD: 'read the board cell at X/Y',   # Robbo $2BD0 (name from call sites)
    0x23C6: 'write object A to the board cell at X/Y',   # Robbo $2C0B (name from call sites)
    0x23DB: 'test the board cell',   # Robbo $2C51 (name from call sites)
    0x243D: 'Robbo routine CHNMON, not analysed yet',   # Robbo $2042 (name from call sites)
    0x2731: 'Robbo routine MFX1, not analysed yet',   # Robbo $22B4 (name from call sites)
    0x2735: 'Robbo routine MFEX, not analysed yet',   # Robbo $22B8 (name from call sites)
    0x2A8E: 'Robbo routine WYBO, not analysed yet',   # Robbo $2603 (name from call sites)
    0x2B13: 'small gun bullet: hit something',   # Robbo $2696 (name from call sites)
    0x2B59: 'small gun (dzialko) fires up',   # Robbo $26DC (name from call sites)
    0x2BCD: 'laser: hit something',   # Robbo $2750 (name from call sites)
    0x2FF6: 'end of the VBI',   # Robbo $2DFD (name from call sites)
    0x9EEB: 'display digits',   # Robbo $2E8F (name from call sites)
    0x0800: 'HELP: show the help text, page by page (entered from HELP_KEY)',
    0x0A3F: 'help: draw one page (16 lines) from the text pointer $0C77',
    0x0A7A: 'help: format one line - frame characters, $14 toggles inverse, inverse digits = indentation',
    0x0B16: 'help: copy the help screen buffer',
    0x0B3C: 'help: previous page (only if not at the start, marker $0909)',
    0x0B62: 'help: next page (only if more text, marker $090A)',
    0x0BB1: 'help: scroll animation',
    0x0BC5: 'help: clear the line buffer $0956',
    0x0C1C: 'help: pointers to the screen buffers',
    0x0C2D: 'help: pointers to the screen and the text position',
    0x0C40: 'help: wait for the next frame',
    0x0C47: 'help: advance the text pointer',
    0x0C55: 'help: next screen line (+40)',
    0x0C61: 'help: next source line (+40)',
    0x9000: 'tape/disk: command letter in A (r, w, e, d - table $902B), dispatch via $902F',
    0x905A: 'directory: read the 5 slot headers, bit mask of used slots',
    0x9086: 'header sector of slot $9430 -> DAUX (table $9037: sectors 4, 256, 388, 520, 652, 784)',
    0x909C: 'erase a slot: header " unused "',
    0x90DC: 'mark a slot used: header " RKdata "',
    0x9102: 'read a planet set from a slot',
    0x9135: 'load the planets of a set',
    0x917A: 'check the loaded set ("ten zestaw planet jest zniszczony")',
    0x91BF: 'write a planet set to a slot',
    0x9207: 'save the planets: $5000 + n * $200, $1F7 bytes each, those used in $39A0',
    0x9276: 'write a memory range as a byte stream',
    0x92B1: 'save a stand-alone Robbo game: format the disk, write the game',
    0x92F5: 'read one byte through the sector buffer $9431',
    0x9314: 'write one byte through the sector buffer $9431',
    0x9338: 'read a sector into $9431 (SIO R)',
    0x933C: 'write a sector from $9431 (SIO P)',
    0x9353: 'read a slot header and check it',
    0x9388: 'format the disk (SIO command $22)',
    0x94E0: 'editor services: jump table (frame, init, colours, message, ...)',
    0x9541: 'one editor frame: colours, input, run the current command',
    0x9D78: 'editor init: disk directory, "kasetowe" in the menu if there is no disk, start the menu',
    0x9DBC: 'colours of the current planet (header) or the defaults $9F83',
    0x9D02: 'show message A centred in the status line $BCC8 (number kept in CUR_MSG)',
    0x9BB1: 'message for the last tape/disk operation',
    0x9CDD: 'show the name of palette entry X (message X + $1E, kept in CUR_ELEM)',
    0x9F74: 'editor display list $94FE',
    0x9571: 'HELP key: sound off, show the help (page HELP_PAGE)',
    0x9582: 'main menu: highlight the row, choose function row + 5 * page, help page = index / 2 + 3',
    0x95D5: 'main menu: move the selection',
    0x9626: 'menu function "funkcje dodatkowe / podstawowe": switch the menu page',
    0x979E: 'menu function "test planety": run the engine on the planet',
    0x97C9: 'menu function "czyść planetę": ask, then clear',
    0x968F: 'menu function "zmiana kolorów"',
    0x99B5: 'menu function "operacje dyskowe / kasetowe"',
    0x9814: 'menu function "kolejność planet"',
    0x9C3E: 'menu function "test Robbo": test the whole game',
    0x9BEB: 'menu function "zapisz Robbo": prepare, next command SAVEGAME_GO',
    0x9C06: 'zapisz Robbo: save the game',
    0x9643: 'disk operations: wait state',
    0x9A64: 'disk operations: sub-menu (table $9AFA)',
    0x9B02: 'disk sub-menu: back to the menu',
    0x9B1A: 'disk sub-menu: load a set',
    0x9B23: 'disk sub-menu: save a set',
    0x9B2C: 'disk sub-menu: erase a set',
    0x9B0B: 'disk sub-menu: click and reset',
    0x9B0E: 'disk sub-menu: reset the dispatch to DISK_MENU',
    0x9B53: 'tape/disk error -> message ("błąd numer ..." digits)',
    0x9B79: 'do a tape/disk command (A = letter) with IRQs off',
    0x9BBF: 'ask "wczytać/zapisać/skasować zestaw 0n? tak nie"',
    0x9C4B: 'all planets empty? -> message "wszystkie planety są puste!"',
    0x97DB: 'clear the current planet: cells $20, default header, status empty',
    0x9674: 'planet number -1 / +1 with the joystick, 0-31 wrapping',
    0x999E: 'planet order: cycle the mark of a planet',
    0x9D57: 'address of message A (skips A strings from $A318)',
    0x9E04: 'default colours into the planet header',
    0x9E18: 'draw the lower screen panel for state PANEL_ST',
    0x9EFC: 'initialise the planet tables (skipped while START is held)',
    0x9F19: 'fill the empty planets with blank cells and the default header',
    0xA810: 'module interface: jump table (start, sounds, input, redraw, messages, ...)',
    0xA9A7: 'start: stack, init, then the main loop',
    0xA9B5: 'editor main loop: every 4 frames (CDTMV3) - redraw, frame, cursor',
    0xB00A: 'click sound',
    0xB159: 'clear the input event',
    0xB16C: 'read a key: KBCODE, carry clear if a key is pressed',
    0xACB6: 'redraw: palette, board window, planet strip, element preview; swap display lists',
    0xAC8B: 'count the cells holding element A on the current planet',
    0xB0BC: 'read joystick, fire, console keys and keyboard into JOY',
    0xB17F: 'test direction bits',
    0xB023: 'key event',
    0xB4CD: 'number -> two decimal digits (screen codes)',
    0xB3F5: 'yes / no choice: move the highlight in "tak nie"',
    0xB4A2: 'ATASCII -> screen code',
    0xB3BE: 'set a display list (X/Y) and the colours',
    0xB189: 'menu function "strona tytułowa": edit the start and congratulation texts',
    0xB03B: 'wait for a key or fire',
    0xA9D2: 'board editor: cursor, palette, put elements',
    0xABA7: 'choose the variant ($41-$45) of an element from its free neighbours',
    0xAC15: 'test a planet: empty, Robbo ($2A) exactly 1, capsule ($14) exactly 1, screws ($24) < 100',
    0xAC6B: 'address of the planet header (row 31)',
    0xAC6F: 'cell address: $5000 + planet * $200 + row * 16 + column',
    0xAEB2: 'blinking: toggle bit 0 of the selected glyphs every 4 frames',
    0xAED2: 'blinking: one glyph',
    0xAEDD: 'draw one board cell into the screen',
    0xAF3E: 'editor set-up (zero page cleared once, screen, colours, DLI, font $4C00)',
    0xB003: 'wait for the next frame',
    0xB05F: 'editor DLI',
    0xB254: 'text input: cursor right',
    0xB259: 'text input: cursor left',
    0xB25E: 'text input: cursor up',
    0xB269: 'text input: cursor down',
    0xB27B: 'text input: backspace',
    0xB2B3: 'text input: delete character',
    0xB290: 'text input: insert character',
    0xB2DE: 'text input: clear',
    0xB2CD: 'text input: return',
    0xB2ED: 'text input: flip bit 0 of $B4',
    0xB2F4: 'text input: set bit 0 of $B3 from $B4',
    0xB2FD: 'text input: is the character allowed',
    0xB34C: 'text input: draw the text window',
    0x0480: 'restart hook: JMP START',
    0xB4ED: 'one digit (low nibble) -> screen code',
    0x1E00: 'engine set-up: screen, display list $1E0F, DLI $1EDE, font $3C00, score / keys / ammunition cleared',
    0x1E03: 'play a planet: A = data page ($50 + 2n), X = number shown, Y = lives, carry = demo; own VBI, returns to the editor',
    0x0506: 'boot: read the program file from sector 4 and start it',
    0x0531: 'boot: JMP (INITAD) after each segment',
    0x0534: 'boot: next byte of the file',
    0x05F5: 'boot: read the next sector of the chain (DOS 2 link: bytes 125-127)',
}

NAMES = {
    0x2092: 'NXCV',
    0x2344: 'FD_',
    0x2363: 'T_LT',
    0x236D: 'T_RT',
    0x238D: 'ASCO',
    0x23FA: 'TST_W',
    0x2513: 'CM1',
    0x2528: 'CM2',
    0x255D: 'FA1',
    0x256F: 'CM3',
    0x2619: 'WFAC',
    0x26A1: 'KIES',
    0x26D0: 'MFC1',
    0x276E: 'PHAJ',
    0x27EE: 'FGET',
    0x27FF: 'TDOR',
    0x2825: 'TSKA',
    0x2858: 'TWYJ',
    0x28C2: 'TBEZ',
    0x293B: 'WYCP',
    0x2957: 'WYSE',
    0x297B: 'NIES',
    0x2996: 'SUP1',
    0x29BA: 'SUP2',
    0x29F3: 'BEZL',
    0x29FE: 'BEZR',
    0x2A09: 'BEZU',
    0x2A14: 'BEZD',
    0x2A19: 'BEZX',
    0x2A24: 'BEZS',
    0x2A29: 'RNDR',
    0x2A6E: 'BOM0',
    0x2AB7: 'PUTW',
    0x2AD3: 'PRZY',
    0x2AF8: 'PO1L',
    0x2B01: 'PP1L',
    0x2B3E: 'PO1R',
    0x2B47: 'PP1R',
    0x2B64: 'PO1U',
    0x2B6D: 'PP1U',
    0x2B8A: 'PO1D',
    0x2B93: 'PP1D',
    0x2BA8: 'DZ2L',
    0x2BAE: 'PO2L',
    0x2BBF: 'PP2L',
    0x2BED: 'DZ2R',
    0x2BF3: 'PO2R',
    0x2C04: 'PP2R',
    0x2C12: 'DZ2U',
    0x2C18: 'PO2U',
    0x2C29: 'PP2U',
    0x2C37: 'DZ2D',
    0x2C3D: 'PO2D',
    0x2C4E: 'PP2D',
    0x2C5F: 'DZ3L',
    0x2C65: 'PO3L',
    0x2C79: 'PP3L',
    0x2C8E: 'DZ3R',
    0x2C94: 'PO3R',
    0x2CA8: 'PP3R',
    0x2CBD: 'DZ3U',
    0x2CC3: 'PO3U',
    0x2CD7: 'PP3U',
    0x2CEC: 'DZ3D',
    0x2CF2: 'PO3D',
    0x2D06: 'PP3D',
    0x2D1B: 'D3TB',
    0x2D29: 'PUNIES',
    0x2D33: 'DZRU',
    0x2D54: 'RDZL',
    0x2D5F: 'RDZ1',
    0x2D80: 'MODL',
    0x2D93: 'MODR',
    0x2DA3: 'MOD1',
    0x2DA6: 'ZAPO',
    0x2EEE: 'LEX',
    0x2EF4: 'SKAC',
    0x300D: 'SCRL',
    0x3029: 'SCU1',
    0x304D: 'SCDW',
    0x305A: 'LDW',
    0x3334: 'SOUND_',
    0x3367: 'PSST',
    0x3370: 'RESE',
    0x3379: 'SOUNDV',
    0x3384: 'SO1',
    0x338E: 'SO2',
    0x3394: 'SO3',
    0x339A: 'SOPL',
    0x9EE2: 'DSPB',
    0x22D0: 'RT_',
    0x22EF: 'LT_',
    0x2308: 'DW_',
    0x2329: 'UP_',
    0x2358: 'JMP1',
    0x2377: 'T_UP',
    0x2381: 'T_DW',
    0x2388: 'T_EX',
    0x23AD: 'GET_',
    0x23C6: 'PUT_',
    0x23DB: 'TST_',
    0x243D: 'CHNMON',
    0x2731: 'MFX1',
    0x2735: 'MFEX',
    0x2A8E: 'WYBO',
    0x2B13: 'PPP1',
    0x2B59: 'DZ1U',
    0x2BCD: 'PPP2',
    0x2FF6: 'EXTV',
    0x9EEB: 'DSPD',
    0x0800: 'HELP',
    0x09A6: 'HELP_',
    0x0A3F: 'HLP_PAGE',
    0x0A7A: 'HLP_LINE',
    0x0B16: 'HLP_COPY',
    0x0B3C: 'HLP_PREV',
    0x0B62: 'HLP_NEXT',
    0x0BB1: 'HLP_SCROLL',
    0x0BC5: 'HLP_CLRBUF',
    0x0C1C: 'HLP_PTRSCR',
    0x0C2D: 'HLP_PTRTXT',
    0x0C40: 'HLP_WAIT',
    0x0C47: 'HLP_INCTXT',
    0x0C55: 'HLP_NEXTLN',
    0x0C61: 'HLP_NEXTSRC',
    0x9000: 'IO_CMD',
    0x905A: 'IO_DIR',
    0x9086: 'IO_SLOTSEC',
    0x909C: 'IO_ERASE',
    0x90DC: 'IO_MARK',
    0x9102: 'IO_READ',
    0x9135: 'IO_LOADSET',
    0x917A: 'IO_CHECK',
    0x91BF: 'IO_WRITE',
    0x9207: 'IO_SAVESET',
    0x9276: 'IO_PUTRANGE',
    0x92B1: 'IO_SAVEGAME',
    0x92F5: 'IO_GETBYTE',
    0x9314: 'IO_PUTBYTE',
    0x9338: 'IO_RDSEC',
    0x933C: 'IO_WRSEC',
    0x9353: 'IO_CHKSLOT',
    0x9388: 'IO_FORMAT',
    0x94E0: 'ED_FRAME',
    0x9541: 'ED_FRAME_',
    0x94E3: 'ED_INIT',
    0x9D78: 'ED_INIT_',
    0x94E6: 'ED_COLORS',
    0x9DBC: 'ED_COLORS_',
    0x94E9: 'MESSAGE',
    0x9D02: 'MESSAGE_',
    0x94EC: 'IO_MSG',
    0x9BB1: 'IO_MSG_',
    0x94EF: 'ELEM_MSG',
    0x9CDD: 'ELEM_MSG_',
    0x94F2: 'ED_DLIST',
    0x9F74: 'ED_DLIST_',
    0x94F5: 'HELP_KEY',
    0x9571: 'HELP_KEY_',
    0x9582: 'MENU',
    0x95D5: 'MENU_MOVE',
    0x9626: 'M_PAGE',
    0x979E: 'M_TEST',
    0x97C9: 'M_CLEAR',
    0x968F: 'M_COLORS',
    0x99B5: 'M_DISK',
    0x9814: 'M_ORDER',
    0x9C3E: 'M_TESTALL',
    0x9BEB: 'M_SAVEGAME',
    0x9C06: 'SAVEGAME_GO',
    0x9643: 'DISK_WAIT',
    0x9A64: 'DISK_MENU',
    0x9B02: 'DISK_BACK',
    0x9B1A: 'DISK_LOAD',
    0x9B23: 'DISK_SAVE',
    0x9B2C: 'DISK_ERASE',
    0x9B0B: 'DISK_RESETC',
    0x9B0E: 'DISK_RESET',
    0x9B53: 'IO_ERRMSG',
    0x9B79: 'IO_DO',
    0x9BBF: 'ASK_SET',
    0x9C4B: 'ALL_EMPTY',
    0x97DB: 'PLANET_CLR',
    0x9674: 'PLANET_STEP',
    0x999E: 'ORDER_TOGGLE',
    0x9D57: 'MSG_ADDR',
    0x9E04: 'COLS_DEFAULT',
    0x9E18: 'PANEL',
    0x9EFC: 'PLANETS_INIT',
    0x9F19: 'PLANETS_FILL',
    0xA810: 'START',
    0xA9A7: 'START_',
    0xA813: 'CLICK',
    0xB00A: 'CLICK_',
    0xA816: 'INPUT_CLR',
    0xB159: 'INPUT_CLR_',
    0xA819: 'GETKEY',
    0xB16C: 'GETKEY_',
    0xA81C: 'REDRAW',
    0xACB6: 'REDRAW_',
    0xA81F: 'COUNT_ELEM',
    0xAC8B: 'COUNT_ELEM_',
    0xA822: 'INPUT',
    0xB0BC: 'INPUT_',
    0xA825: 'DIR_TEST',
    0xB17F: 'DIR_TEST_',
    0xA828: 'J_F556',
    0xA82B: 'KEY_EVENT',
    0xB023: 'KEY_EVENT_',
    0xA82E: 'TO_DIGITS',
    0xB4CD: 'TO_DIGITS_',
    0xA831: 'ASK_YESNO',
    0xB3F5: 'ASK_YESNO_',
    0xA834: 'ATA2SCR',
    0xB4A2: 'ATA2SCR_',
    0xA837: 'SET_DLIST',
    0xB3BE: 'SET_DLIST_',
    0xA83A: 'TITLE_ED',
    0xB189: 'TITLE_ED_',
    0xA83D: 'WAIT_KEY',
    0xB03B: 'WAIT_KEY_',
    0xA9B5: 'MAIN_LOOP',
    0xA9D2: 'EDIT',
    0xABA7: 'AUTO_VARIANT',
    0xAC15: 'PLANET_TEST',
    0xAC6B: 'CELL_HEADER',
    0xAC6F: 'CELL_ADDR',
    0xAEB2: 'BLINK',
    0xAED2: 'BLINK_ONE',
    0xAEDD: 'PUT_CELL',
    0xAF3E: 'ED_SETUP',
    0xB003: 'WAIT_VBL',
    0xB05F: 'ED_DLI',
    0xB254: 'TX_RIGHT',
    0xB259: 'TX_LEFT',
    0xB25E: 'TX_UP',
    0xB269: 'TX_DOWN',
    0xB27B: 'TX_BACKSP',
    0xB2B3: 'TX_DELETE',
    0xB290: 'TX_INSERT',
    0xB2DE: 'TX_CLEAR',
    0xB2CD: 'TX_RETURN',
    0xB2ED: 'TX_FLIP',
    0xB2F4: 'TX_SETBIT',
    0xB2FD: 'TX_ALLOWED',
    0xB34C: 'TX_DRAW',
    0x0480: 'RESTART',
    0xB4ED: 'DIGIT',
    0x1E00: 'ENGINE_INIT',
    0x1E03: 'ENGINE_PLAY',
    0x0506: 'BOOT',
    0x0531: 'BOOT_INIT',
    0x0534: 'BOOT_GETBYTE',
    0x05F5: 'BOOT_NEXTSEC',
}
POKES = {}

SRC = 'src'


def header(name, lo, hi, desc):
    return ['; %s - %s' % (name, desc), '; $%04X-$%04X' % (lo, hi), '', '         org $%04X' % lo, '']


def main():
    mem = open(sys.argv[1], 'rb').read()
    code, labels = analyze(mem, entries(mem) + [int(a, 16) for a in sys.argv[2:]], NOFOLLOW)
    taken = {v[2].upper() for v in VARIABLES if not isinstance(v, str)} | {n.upper() for n in L.values()}
    assert len(set(NAMES.values())) == len(NAMES), 'duplicate routine names'
    for a, n in NAMES.items():
        assert n.upper() not in taken, '%s clashes with a variable or OS name' % n
        if a in labels or a in code: labels[a] = n          # also names a fall-through entry
        else: print('WARNING: name %s for $%04X - not an instruction start' % (n, a))
    lst = Lister(mem, code, labels, VARIABLES, POKES, COMMENTS, TEXTS)
    os.makedirs(SRC, exist_ok=True)

    prev = -1
    for name, lo, hi, desc in BLOCKS:
        assert lo > prev, '%s overlaps the previous block' % name
        assert not any(hw(a) for a in (lo, hi)), '%s touches I/O' % name
        for a, n in code.items():
            assert not (a < lo <= a + n - 1 or a <= hi < a + n - 1), \
                'instruction at $%04X crosses the boundary of %s' % (a, name)
        prev = hi
        path = os.path.join(SRC, name)
        if name == 'VECTORS.ASM':
            vec = [mem[a] | mem[a + 1] << 8 for a in (0xFFFA, 0xFFFC, 0xFFFE)]
            body = ['         dta %-40s ; %s' % ('a(%s)' % lst.nm(v, 2), n) for v, n in zip(vec, ('NMI', 'RESET', 'IRQ'))]
            open(path, 'w', encoding='utf-8', newline='\n').write('\n'.join(header(name, lo, hi, desc) + body) + '\n')
        elif name.endswith('.ASM'):
            body = lst.lines(lo, hi)
            open(path, 'w', encoding='utf-8', newline='\n').write('\n'.join(header(name, lo, hi, desc) + body) + '\n')
        else:
            open(path, 'wb').write(bytes([0xFF, 0xFF, lo & 0xFF, lo >> 8, hi & 0xFF, hi >> 8]) + mem[lo:hi + 1])

    lost_comments = sorted(set(COMMENTS) - lst.placed_comments)
    if lost_comments:
        print('WARNING: comments not placed (inside an instruction or a binary block):',
              ' '.join('$%04X' % a for a in lost_comments))

    # anything outside the blocks that is not zero would be lost
    covered = bytearray(65536)
    for _, lo, hi, _ in BLOCKS: covered[lo:hi + 1] = b'\1' * (hi - lo + 1)
    lost = [a for a in range(65536) if mem[a] and not covered[a] and not hw(a)]
    if lost: print('WARNING: %d non-zero bytes outside blocks, first at $%04X' % (len(lost), lost[0]))

    # labels used in operands but not written at their own address (inside an instruction or outside the blocks)
    extra = sorted(a for a in lst.used if a not in lst.placed)
    joint = ['; JOINT.ASM - common labels', '', '; Atari OS and hardware', '']
    joint += ['%-8s equ $%04X' % (n, a) for a, n in sorted(L.items(), key=lambda x: x[0]) if '+' not in n]
    joint += ['', '; game variables outside the .ASM blocks (the others are defined where they live)']
    group = None
    for v in VARIABLES:
        if isinstance(v, str):
            group = v; continue
        addr, size, name, comment = v
        if addr in lst.var_placed: continue
        if group: joint += ['', group]; group = None
        size_note = '+%02X ' % (size - 1) if size > 1 else ''
        joint.append('%-14s equ $%04X  ; %s%s' % (name, addr, size_note, comment))
    if extra:
        joint += ['', '; labels not at an instruction boundary or outside the source blocks', '']
        joint += ['%-10s equ $%04X' % (lst.used[a], a) for a in extra]
    open(os.path.join(SRC, 'JOINT.ASM'), 'w', encoding='utf-8', newline='\n').write('\n'.join(joint) + '\n')

    out = ['; Robbo Konstruktor (1990, L.K. Avalon) - memory image of the program rebuilt from blocks',
           '; Output is a segment file matching game.bin, not a runnable executable.', '',
           '         icl "src/JOINT.ASM"', '']
    h = None
    for name, lo, hi, desc in BLOCKS:
        want = 'h+' if name.endswith('.ASM') else 'h-'
        if want != h:
            out += ['', '         opt %s' % want]; h = want
        line = ('icl' if name.endswith('.ASM') else 'ins') + ' "%s/%s"' % (SRC, name)
        out.append('         %-26s ; $%04X-$%04X %s' % (line, lo, hi, desc))
    open('main.asm', 'w', encoding='utf-8', newline='\n').write('\n'.join(out) + '\n')

    print('blocks:', len(BLOCKS), 'code bytes:', sum(code.values()), 'labels:', len(labels),
          'extra equ labels:', len(extra))


if __name__ == '__main__':
    main()
