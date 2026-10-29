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
    ('RUNAD.DTA',    0x02E0, 0x02E1, 'RUNAD = $A810'),
    ('HOOK.ASM',     0x0480, 0x0482, 'restart hook: JMP $A810'),
    ('BOOT.ASM',     0x0500, 0x067F, 'boot sectors 1-3: boot record and binary-file loader (cracked)'),
    # help
    ('HELPVIEW.ASM', 0x0800, 0x0C6C, 'help viewer: screen (display list, credits panel), paging, line unpacking'),
    ('HELPTEXT.ASM', 0x0C6D, 0x1DD0, 'help text: 16 pages in Polish (HELP key), one screen line per dta: bit 7 = last character of the line'),
    # game engine (Robbo's, reworked)
    ('ENG_PLAY.ASM', 0x1E00, 0x22CF, 'engine: jump table, display list, info-line texts, DLIs, set-up, play loop, planet start (Robbo R1)'),
    ('ENG_BOARD.ASM', 0x22D0, 0x23FC, 'engine: board primitives - step, test, read / write a cell, score, frame wait'),
    ('ENG_SCRN.ASM', 0x243D, 0x2581, "engine: CHNMON - BREAK test, Robbo's step, animated shapes, board to screen"),
    ('ENG_ROBBO.ASM', 0x2582, 0x28EB, 'engine: Robbo - creatures and magnets next to him, move, shoot, push, door / screw / exit'),
    ('ENG_OBJ.ASM',  0x28EC, 0x2F52, 'engine: object behaviours (table $31EF) - teleports, surprise, boxes, bomb, magnets, guns, bullets, creatures, bats, eyes, capsule'),
    ('ENG_VBI.ASM',  0x2F53, 0x3141, 'engine: VBI CVBL - info line, scrolling; input KEJO'),
    ('ENG_TAB.ASM',  0x3142, 0x3333, 'engine: input variables, shape table, NEXT, object table $31EF, WHAT'),
    ('ENG_SND.ASM',  0x3334, 0x35A3, 'engine: sound effects and their data'),
    ('TITLEPG.ASM',  0x35C0, 0x395C, 'title page of the saved Robbo game (also "test Robbo"): display list, texts, logo, planet sequence'),
    # fonts
    ('GAME.FNT',     0x3C00, 0x3FFF, 'play-screen font (modified Robbo F.FNT; animated characters copied in by ANIM)'),
    ('BOARD_T.FNT',  0x4000, 0x43FF, 'editor board font, top halves of the 2 x 2 cells (CHBASE $40)'),
    ('BOARD_B.FNT',  0x4400, 0x47FF, 'editor board font, bottom halves (CHBASE $44)'),
    ('SHAPES.FNT',   0x4800, 0x4BFF, 'element shapes, two animation phases (modified Robbo S.FNT; source for ANIM)'),
    ('INFO.FNT',     0x4C00, 0x4FFF, 'info-line, help and title font with icons and (c) (modified Robbo I.FNT)'),
    # editor
    ('DISKIO.ASM',   0x9000, 0x9430, 'tape / disk: planet sets in 5 slots, format, saving the stand-alone game'),
    ('ED_MENU.ASM',  0x94E0, 0x9CDC, 'editor: services jump table, main menu and its 10 functions, disk sub-menu'),
    ('ED_SERV.ASM',  0x9CDD, 0x9F7A, 'editor services: messages, set-up, colours, lower panel, digits, planet tables, display list'),
    ('ED_TEXTS.ASM', 0x9F7B, 0xA808, 'editor tables (header buffer, menu table $9F8E) and texts: screens, messages, element names'),
    ('ED_MAIN.ASM',  0xA810, 0xAF3D, 'editor: jump table $A810, input variables, display lists, start, main loop, board editing, planet test, redraw'),
    ('ED_SCRN.ASM',  0xAF3E, 0xB188, 'editor: screen set-up, frame wait, click, keys, DLI, joystick / keyboard input'),
    ('TITLE_ED.ASM', 0xB189, 0xB3BD, 'title-page text editor (start / congratulation texts)'),
    ('ED_UTIL.ASM',  0xB3BE, 0xB4F8, 'editor helpers: display list switch, yes / no question, ATASCII to screen code, digits'),
    ('PALETTE.ASM',  0xB4F9, 0xB5FF, 'tables: character codes $B4F9, palette codes $B51C, element glyphs $B55A'),
    ('LOADSCR.ASM',  0xBC40, 0xBC67, 'loading screen line "Robbo Konstruktor (C) 1990 Avalon"'),
]

# fixed entry points (the dispatch-table entries are added by entries())
ENTRIES = [0x0480, 0x0506, 0x0800, 0x1E00, 0x1E03] + list(range(0xA810, 0xA840, 3)) + \
          [0x979E, 0x97C9, 0x968F, 0x99B5, 0x9626, 0x9814, 0x9C3E, 0x9BEB] + \
          [0x0BD0, 0x0BF7, 0x0C4E, 0x3120] + \
          [0x93AF]   # menu table $9F8E; help scroll steps (jsr patched at $0BB1); unused; boot of the saved game

# JMP/JSR instructions with self-modified operands (dispatch slots, wait loops) - not followed;
# immediate addresses written into their operands become entry points (rdis.analyze)
NOFOLLOW = {
    0x9554,   # menu dispatch: jsr (handler from $9F8E)
    0x2148,   # engine: jsr (object behaviour from $31EF)
    0x9028,   # editor sub-commands: jmp (from $902F)
    0x9A61,   # editor sub-menu: jmp (from $9AFA)
    0xB238,   # text input: jmp (key handler from $B330)
    0x246D,   # engine: jmp to itself until patched
    0x0BB1,   # help scroll: jsr (line step $0BD0 / $0BF7, set by HLP_PREV / HLP_NEXT)
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
# data written as strings: first -> (last, format); 'help' = ATASCII, bit 7 = end of a screen line, $00 nn = page
# marker, Polish letters as CONTROL codes; 'screen' = ANTIC screen codes (dta d'...')
TEXTS = {
    0x083E: (0x0865, 'screen-pl'),  # help screen, bottom panel (40 characters per line): title with icons
    0x0866: (0x088D, 'screen-pl'),  #   author
    0x088E: (0x08B5, 'screen-pl'),  #   empty line
    0x08B6: (0x08DD, 'screen-pl'),  #   copyright, Laboratorium Komputerowe
    0x08DE: (0x0905, 'screen-pl'),  #   Avalon
    0x0906: (0x0908, 'screen-pl'),  #   key hints (the arrows $0909-$090A are the variable HLP_ARROWS)
    0x090B: (0x092D, 'screen-pl'),
    0x0C7B: (0x1DD0, 'help'),       # help pages 0-15 (after the preamble $0C6D-$0C7A)
    0x9FBB: (0xA082, 'screen-pl'),  # editor screens: main menu (two columns of 20: basic / additional functions)
    0xA083: (0xA0AA, 'screen-pl'),  #   planet number line
    0xA0AB: (0xA0E6, 'screen-pl'),  #   title
    0xA0E7: (0xA15E, 'screen-pl'),  #   planet legend
    0xA15F: (0xA226, 'screen-pl'),  #   disk panel
    0xA227: (0xA29E, 'screen-pl'),  #   save hints, disk
    0xA29F: (0xA316, 'screen-pl'),  #   save hints, tape
    0x1E8E: (0x1EDD, 'screen-pl'),  # engine info-line texts: BREAK back to the Konstruktor / end of the demo
    0x3603: (0x3622, 'screen-pl'),  # title page bottom lines (narrow, 32 characters), saved game: line 1
    0x3623: (0x3642, 'screen-pl'),  #   line 2
    0x3643: (0x3662, 'screen-pl'),  # title page bottom lines, "test Robbo" from the Konstruktor: line 1
    0x3663: (0x3682, 'screen-pl'),  #   line 2
    0x9043: (0x904A, 'strings'),    # disk slot signatures: used (inverse) / erased
    0x904B: (0x9052, 'strings'),    # ($9053 is the variable IO_USED)
    0xA957: (0xA97E, 'screen-pl'),  # title-page editor: header line of the start text (copied at $B34E)
    0xA97F: (0xA9A6, 'screen-pl'),  #   header line of the congratulation text
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
    (0x0086, 2, 'FADR', 'screen address of Robbo, the scroll follows it (Robbo FADR)'),
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
    '* zero page - sound (Robbo layout, names from robbo/d1/R1.ASM SOUND_) ---',
    (0x00F0, 4, '_PNTR', 'position in the sound of each channel'),
    (0x00F4, 8, '_ADDR', 'address of the sound of each channel (2 bytes per channel)'),
    (0x00FC, 2, '_SCRA', 'sound pointer'),
    (0x00FE, 2, '_HLP', 'temporary: AUDF / AUDC value'),
    '* zero page - editor temporaries: each routine uses them in its own way ---',
    (0x00B0, 2, 'PTR1', 'pointer: target (help screen line, board cell for PUT_CELL, display)'),
    (0x00B2, 2, 'PTR2', 'pointer: source (help text, message, board cell from CELL_ADDR, title text)'),
    (0x00B4, 1, 'TMP1', 'temporary (element code; title editor: page 0 / 1)'),
    (0x00B5, 1, 'TMP2', 'temporary (title editor: cursor position in the line)'),
    (0x00B6, 1, 'TMP3', 'temporary / counter (help: lines, digits: tens)'),
    (0x00B7, 1, 'TMP4', 'temporary / counter (help: lines, digits: units)'),
    '* zero page - tape / disk ------',
    (0x00B8, 2, 'IO_PTR', 'address of the next byte of a segment (IO_DIR: slot bit mask)'),
    (0x00BA, 2, 'IO_END', 'last address of the segment'),
    (0x00BF, 1, 'IO_POS', 'next byte in the sector buffer IO_BUF'),
    '* zero page - title page -------',
    (0x00E0, 2, 'TP_SCR', 'logo: screen address of the letter column'),
    (0x00E2, 2, 'TP_HDR', 'planet being searched / played: its data page (header at +$F0 of the second page)'),
    (0x00E4, 1, 'TP_LETTER', 'logo: letter 4..0 of "ROBBO"'),
    (0x00E6, 2, 'TP_TMP', 'temporary: planet code, logo pixels doubled, colour offset'),
    (0x00E8, 2, 'TP_TIMER', 'frame counter (demo after 8 x 256 frames)'),
    (0x00EA, 1, 'TP_NUM', 'planet number shown'),
    (0x00EB, 1, 'TP_LIVES', 'lives left (8 at the start)'),
    (0x00EC, 1, 'TP_POS', 'position in PLAY_ORDER'),
    (0x00ED, 1, 'TP_HUE', 'random hue of the logo colour bars (every 256 frames)'),
    '* title page data --------------',
    (0x35EA, 1, 'TP_DL_TXT', 'display list: high byte of the text page ($3A / $3B, set by TP_PAGE)'),
    (0x35FD, 2, 'TP_DL_LINE', 'display list: address of the narrow line ($3603 / $3643)'),
    (0x373B, 1, 'TP_KEYLAST', 'previous state of fire / START / SHIFT'),
    (0x391A, 5, 'TP_LOGOIDX', 'letters of "ROBBO": offset of each letter in TP_LOGOBMP'),
    (0x391F, 24, 'TP_LOGOBMP', 'bitmaps of R, O, B (8 bytes each)'),
    (0x3937, 25, 'TP_LOGOCOL', 'colour bars of the logo (low nibble = luminance, high = TP_HUE)'),
    (0x3950, 10, 'TP_TEXTCOL', 'colour bar of the text lines'),
    (0x39E0, 32, 'PLAY_ORDER', 'planets of the saved game / test Robbo in play order (copied from ORDER), bit 7 = play'),
    (0x3A00, 256, 'TP_TEXT_A', 'title page text A: start'),
    (0x3B00, 256, 'TP_TEXT_B', 'title page text B: congratulations at the end'),
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
    '* help viewer ------------------',
    (0x0909, 2, 'HLP_ARROWS', 'arrows <- -> in the key hint line: 0 = no previous / next page'),
    (0x0956, 40, 'HLP_LINEBUF', 'frame line under the help page, also the line buffer of the scroll'),
    (0x09B4, 1, 'HLP_FIRST', 'first call (start-up page): no click; ASL clears it'),
    (0x0BDF, 2, 'HLP_SRC', 'source line of HLP_STEP_R'),
    (0x0BB2, 2, 'HLP_STEP', 'line step of the scroll: HLP_STEP_R (previous page) / HLP_STEP_L (next page)'),
    (0x0C6D, 8, 'HLP_SAVE', 'PTR1 ... TMP4 saved while the help is shown'),
    (0x0C75, 1, 'HLP_TAPE', 'DISK_SLOTS on entry: negative = no disk, the text shows the tape variants'),
    (0x0C76, 1, 'HLP_INV', 'inverse mask of the characters ($14 in the text toggles it)'),
    (0x0C77, 2, 'HLP_TOP', 'address of the text of the page shown'),
    '* editor state in the text block ---',
    (0x9F7B, 8, 'HDR_BUF', 'header of the current planet (bytes 2-6 COLOR0-4, 7 PCOLR3); initial bytes spell "kolory" - not a text'),
    (0xA317, 1, 'CUR_MSG', 'number of the message in the status line'),
    (0xA7D6, 1, 'CUR_ELEM', 'palette entry whose name is shown'),
    '* input ------------------------',
    (0xA840, 1, 'JOY', 'input bits: stick, fire'),
    (0xA841, 1, 'JOY_LAST', 'previous stick value'),
    (0xA842, 1, 'JOY_RPT', 'auto-repeat counter'),
    (0xA843, 1, 'TRIG_ST', 'fire / console keys'),
    (0xA844, 1, 'EVENT', 'input event flag'),
    (0xA845, 1, 'TRIG_LAST', 'previous fire / console keys'),
    '* engine variables (Konstruktor) ---',
    (0x00A9, 1, 'PNUM', 'planet number shown in the info line'),
    (0x210A, 1, 'CNTR', 'animation counter (Robbo CNTR)'),
    (0x26CF, 1, 'STRC', 'delay between Robbo\'s shots (Robbo STRC)'),
    (0x26C7, 8, 'KIET', 'bullet start for each shot direction: PP1U, PP1D, PP1L, PP1R (Robbo KIET)'),
    (0x28EC, 1, 'TELE_CODE', 'teleport Robbo is entering (TELE_IN)'),
    (0x2F53, 1, 'BDEC', 'planet number in BCD (Robbo BDEC)'),
    (0x3142, 1, 'MOVE_DIR', 'Robbo\'s direction this step (stick bits, $0F = none, $FF = start)'),
    (0x3143, 1, 'MOVE_IN', 'direction read by KEJO'),
    (0x3145, 1, 'FIRE', 'fire, 0 = pressed'),
    (0x3146, 1, 'INPUT_NEW', 'set when the input changed'),
    (0x3147, 1, 'FIRE_LAST', 'previous FIRE'),
    (0x3154, 1, 'ESC_KEY', 'ESC pressed - Robbo gives up'),
    (0x1E0B, 1, 'PLAY_NUM', 'X on entry (number shown), kept over TSX'),
    (0x1E13, 2, 'DLSA', 'display list: address of the board window, moved by the scroll (Robbo DLSA)'),
    (0x1E2F, 2, 'DL_BREAK', 'display list: JMP over or to the line "BREAK: powrot do Robbo Konstruktora"'),
    (0x1E35, 2, 'DL_DEMO', 'display list: JMP over or to the line of the demo'),
    (0x1E3E, 40, 'INFO_TOP', 'info line, upper half of the 2 x 2 digits (Robbo DSPB)'),
    (0x1E66, 40, 'INFO_BOT', 'info line, lower half'),
    (0x207D, 1, 'PLAY_TRY', 'Y on entry: $FF = one try (game over after the first life)'),
    (0x2243, 4, 'WALL_CHR', 'wall characters drawn for the 4 wall cells'),
    (0x235B, 8, 'LMVT', 'UP_ / DW_ / LT_ / RT_ for JMP1: low bytes, then high bytes (Robbo LMVT)'),
    (0x2491, 1, 'FADR_L', 'Robbo\'s screen address for FADR (set by MFEX), low byte'),
    (0x2495, 1, 'FADR_H', 'Robbo\'s screen address for FADR, high byte'),
    (0x2502, 1, 'FACET', 'Robbo\'s walking phase (Robbo: CHNMON-1, "FACET")'),
    (0x28BE, 4, 'TBEZ_GUN', 'gun for each direction (Robbo: the bytes before TBEZ, read as TBEZ-4,x)'),
    (0x28F9, 4, 'TELP_OFS', 'teleport exit: cell offset for each direction'),
    (0x296B, 16, 'TMVS', 'directions to try when leaving a teleport (Robbo TMVS)'),
    (0x29D3, 32, 'NSPS', 'what a surprise turns into (Robbo NSPS)'),
    (0x2A93, 9, 'WBPO', 'bomb: offsets of the 3 x 3 cells (Robbo WBPO)'),
    (0x2A9C, 9, 'WBPX', 'bomb: X step of each cell, for the board edge'),
    (0x2AA5, 9, 'WBPY', 'bomb: Y step of each cell, for the board edge'),
    (0x2AAE, 9, 'WBPF', 'bomb: explosion phase put into each cell (Robbo WBPO+9)'),
    (0x2D78, 8, 'RDZP', 'eyes: routines for each direction, minus 1 for RTS (Robbo RDZP)'),
    (0x309B, 1, 'DSPB_X', 'X kept by INFO_DIGIT'),
    (0x309E, 10, 'DIGIT_T', 'digits 0-9: character of the upper half'),
    (0x30A8, 10, 'DIGIT_B', 'digits 0-9: character of the lower half'),
    (0x30CF, 1, 'KEY_FIRE', 'RETURN held: 0 (fire), else 1; ANDed with SHIFT and both triggers'),
    (0x3114, 1, 'KEY_DIR', 'stick bits of the cursor key (KEJO_DIRS), ANDed with both sticks'),
    (0x314A, 5, 'KEJO_KEYS', 'key codes of the cursor keys -> <- up down (entries 1-4)'),
    (0x314F, 5, 'KEJO_DIRS', 'stick bits for no key and for KEJO_KEYS 1-4'),
    (0x3155, 128, 'LOOK', 'element -> first of its 2 x 2 characters (Robbo LOOK)'),
    (0x31D5, 26, 'NEXT', 'animation: next element for the codes "a"-"z" (Robbo NEXT)'),
    (0x31EF, 2, 'PROC', 'behaviour routine of each element, 2 bytes each (Robbo PROC)'),
    (0x32B1, 128, 'WHAT', 'element properties (Robbo WHAT)'),
    (0x3331, 1, 'PLAY_SP', 'stack pointer of the caller of ENGINE_PLAY'),
    (0x3332, 2, 'OLD_VBI', 'VVBLKD of the editor, restored by PLAY_EXIT'),
    (0xBE00, 0x1F0, 'BOARD', 'the planet being played: 16 x 31 cells (TSTTAB rows)'),
    (0xBFF0, 8, 'BOARD_HDR', 'its header: wall type, screws, COLOR0-4, PCOLR3'),
    (0x23FD, 64, 'TSTTAB', 'address of each board row: 32 low bytes, then 32 high bytes (Robbo tsttab)'),
    (0x3C00, 1024, 'FONT', 'board font (Robbo FONT)'),
    (0x35C1, 1, 'TP_TEST', 'title page started from the Konstruktor ("test Robbo"): BREAK returns'),
    (0x35C2, 1, 'TP_LAST', 'last planet number of the game'),
    (0x395A, 1, 'TP_RNUM', 'restart point: planet number shown'),
    (0x395B, 1, 'TP_RPOS', 'restart point: position in the planet order'),
    (0x395C, 1, 'TP_DEMOFLAG', 'title page: $80 = demo'),
    '* copy protection --------------',
    (0x9F8B, 1, 'PROT_SUM', 'SERIN XOR DOSINI+1 at start-up: 0 on the original disk (SERIN = $19, the boot record init $19DD high byte)'),
    '* OS (XL/XE ROM) ---------------',
    (0xF556, 1, 'OS_BELL', 'XL/XE OS: buzzer - the key click ($F983) 33 times; not an entry in OS-B or AltirraOS'),
    (0xFB51, 1, 'OS_KEYTAB', 'XL/XE OS: key code -> ATASCII table (KEYDEF points here); not in OS-B or AltirraOS'),
    '* boot loader (sectors 1-3) ----',
    (0x0043, 2, 'BOOT_ADR', 'address the next byte of the segment goes to'),
    (0x0045, 2, 'BOOT_END', 'last address of the segment'),
    (0x0047, 1, 'BOOT_BCNT', 'data bytes in the sector (DOS 2 byte 127)'),
    (0x0048, 1, 'BOOT_BPOS', 'next byte in the sector buffer'),
    (0x03FE, 1, 'SEC_LINKH', 'SEC_LINKH,x with X = 127: sector byte 125, file number and next sector high bits'),
    (0x03FF, 1, 'SEC_LINKL', 'SEC_LINKL,x with X = 127: sector byte 126, next sector low byte'),
    (0x0400, 1, 'SEC_BUF', 'sector buffer (DBUF, 128 bytes), a DOS 2 sector: 125 data bytes and the link'),
    '* screen memory ----------------',
    (0xB600, 1, 'SCREEN', 'screen: editor screen A (board window 10 x 40), title logo, help page'),
    (0xB800, 1, 'SCREEN_B', 'editor screen B (drawn while A is shown, then swapped)'),
    (0xBBEC, 1, 'PANEL_LH', 'PANEL_TXT-20: PANEL_LH,x is the left half of the row whose right half is PANEL_TXT,x'),
    (0xBC00, 200, 'PANEL_TXT', 'lower panel, 5 text lines of 40 characters'),
    (0xBCC8, 40, 'STATUS', 'status line: messages, "tak nie" question'),
    (0xBD00, 1, 'GR_BLANK', 'empty graphics lines (mode F, $BD00-$BDFF without GR_LINE)'),
    (0xBD50, 40, 'GR_LINE', 'dotted line ($55) between the parts of the screen'),
    (0x43E0, 32, 'BOARD_T_7C', 'characters $7C-$7F of the upper board font: the wall of the planet (by its header), the selected element in the cursor frame'),
    (0x47E0, 32, 'BOARD_B_7C', 'the same in the lower board font'),
    '* planets ----------------------',
    (0x39A0, 32, 'PLANET_STATE', 'status of the 32 planets: 0 empty, bit 7 = bad (low bits = error message), else good'),
    (0x94F8, 1, 'DISK_SLOTS', 'directory result: used slots, negative = no disk'),
    (0x39C0, 32, 'ORDER', 'planet order set in "kolejnosc planet": planet number, bit 7 = in the game'),
    (0x51F0, 8, 'PLANET_HDR', 'header of planet 0 (colours); the operand high byte is patched for planet n: +n x $200'),
    '* editor screen and input ------',
    (0x0000, 1, 'DLI_ROW', 'line counter of ED_DLI: odd / even rows use the lower / upper board font'),
    (0xAF80, 1, 'ED_ONCE', 'ED_SETUP: 0 = first call (clear the zero page), then 3'),
    (0xB022, 1, 'KEY_LAST', 'last key code seen by KEY_EVENT_'),
    (0xB0D8, 1, 'IN_FIRE', 'RETURN or SPACE held: 0 (fire), else 1; ANDed with SHIFT, triggers, console keys'),
    (0xB123, 1, 'IN_DIR', 'stick bits of the cursor key (IN_DIRS), ANDed with both sticks'),
    (0xB17E, 1, 'JOY_PREV', 'stick bits before the last change (DIR_TEST_)'),
    (0xB510, 1, 'RPT_FIRST', 'auto-repeat: frames before the first repeat'),
    (0xB511, 1, 'RPT_NEXT', 'auto-repeat: frames between repeats'),
    (0xB512, 5, 'IN_KEYS', 'key codes of the cursor keys -> <- up down (entries 1-4)'),
    (0xB517, 5, 'IN_DIRS', 'direction bits for no key and for IN_KEYS 1-4 (inverted into IN_DIR)'),
    (0xB3F4, 1, 'YESNO', 'ASK_YESNO: bit 0 = the word highlighted ("tak" / "nie"), +1 by the stick'),
    (0xB4CB, 1, 'A2S_X', 'X kept by ATA2SCR_'),
    (0xB4C9, 1, 'A2S_Y', 'Y kept by ATA2SCR_'),
    '* palette and characters -------',
    (0xB4F9, 12, 'CHR_FROM', 'ATASCII codes with a glyph of their own (Polish letters, @ / *); $A0 ends'),
    (0xB505, 11, 'CHR_TO', 'their screen codes in the font $4C00'),
    (0xB51C, 30, 'PAL_CODES', 'the palette, entries 0-29: element codes (Robbo level characters); 22-29 from PAL_SETS'),
    (0xB53A, 32, 'PAL_SETS', 'palette entries 22-29: 4 sets of 8 (guns, bats, teleports), chosen by entry 21'),
    (0xB55A, 96, 'GLYPHS', 'element code - $20 -> glyph g: a cell is drawn as characters 2g, 2g+1 / 2g+$40...'),
    (0xB5BA, 1, 'PAL_SET', 'palette set shown in entries 22-29 (bits 0-1), +1 by entry 21'),
    (0xB5BB, 1, 'BLINK_CNT', 'cursor blink counter: 0 after a move, bit 2 = phase'),
    (0xB5BC, 3, 'PM_HPOS', 'start positions of players 0-2'),
    (0xB5BF, 1, 'FRAME_COL', 'colour bits of the cursor frame ($AA)'),
    (0xB5C0, 32, 'FRAME_MASK', 'cursor frame around the selected element (characters $7E-$7F, both fonts)'),
    (0xB5E0, 32, 'STRIP_CHR', 'scroll bar beside the board: 8 x 4 characters'),
    '* title page editor ------------',
    (0xA957, 40, 'TX_HEAD_A', 'header line of the start text'),
    (0xA97F, 40, 'TX_HEAD_B', 'header line of the congratulation text'),
    (0xB187, 1, 'TX_PAGESAV', 'page edited (0 = start $3A00, 1 = congratulation $3B00), kept between calls'),
    (0xB188, 1, 'TX_POSSAV', 'cursor position in the page, kept between calls'),
    (0xB244, 1, 'TX_CHAR', 'ATASCII of the key pressed'),
    (0xB330, 28, 'TX_KEYS', 'keys of the title editor: ATASCII, handler address; 0 ends'),
    '* editor texts and tables ------',
    (0x9F83, 8, 'COLS_DEF', 'header of a new planet: wall type, screws, COLOR0-4, PCOLR3'),
    (0x9FA2, 10, 'DIGITS_T', 'digits 0-9 of the panel: character of the upper half'),
    (0x9FAC, 10, 'DIGITS_B', 'digits 0-9 of the panel: character of the lower half'),
    (0x9FBB, 200, 'MENU_TXT', 'main menu: rows of 20 + 20 characters (MENU_TXT+130 = "dyskowe")'),
    (0xA083, 40, 'NUM_TXT', 'planet number line: the two numbers at +11 and +31'),
    (0xA0AB, 60, 'TITLE_TXT', 'title column: "Robbo Konstruktor", "(c)1990 by Avalon"'),
    (0xA0E7, 120, 'LEGEND_TXT', 'planet legend, 3 lines'),
    (0xA15F, 200, 'DISK_TXT', 'disk panel, 5 lines'),
    (0xA227, 120, 'SAVE_DISK', 'hints for "zapisz Robbo", disk'),
    (0xA29F, 120, 'SAVE_TAPE', 'hints for "zapisz Robbo", tape'),
    (0xA7D8, 32, 'DEV_WORDS', 'tape / disk words, 8 characters each (DEV_WORDS+24 = " kasetowe")'),
    (0xA804, 5, 'ROBBO_TXT', '"Robbo"'),
    (0xAC09, 4, 'AV_OFS', 'AUTO_VARIANT: neighbour cells from PTR2-17: left, right, above, below'),
    (0xAC0D, 4, 'AV_DX', 'their X step'),
    (0xAC11, 4, 'AV_DY', 'their Y step'),
    '* menu functions ---------------',
    (0x94F9, 5, 'SET_BIT', 'bit of sets 1-5 in DISK_SLOTS'),
    (0x962E, 1, 'BEEP', 'error tone: volume, counted down by DISK_WAIT'),
    (0x9811, 1, 'ORD_BLINK', 'kolejnosc planet: frame counter, bit 2 = blink phase'),
    (0x9812, 1, 'ORD_POS', 'kolejnosc planet: the planet / position under the cursor'),
    (0x9813, 1, 'ORD_MARK', 'kolejnosc planet: the planet picked to be placed'),
    (0x9874, 1, 'ORD_COL', 'kolejnosc planet: bit 7 = cursor in the planet row, else in the order row'),
    (0x998A, 1, 'ORD_PLANET', 'PLANET on entry'),
    (0x9996, 4, 'TOG_FROM', 'ORDER_TOGGLE: marks of the legend ($59 empty, $5A good, $5B bad)'),
    (0x999A, 4, 'TOG_TO', 'the same marks highlighted'),
    (0x99DA, 1, 'DSK_FUNC', 'disk sub-menu: function (0 menu, 1 load, 2 save, 3 erase)'),
    (0x99DB, 1, 'DSK_SET', 'disk sub-menu: set 0-4'),
    (0x9A4E, 1, 'DSK_WAIT', 'disk sub-menu: 0 = choose, else show the result and wait'),
    (0x9ABA, 1, 'DSK_SAME', 'disk sub-menu: 0 after the function changed'),
    (0x9AFA, 8, 'DSK_JUMPS', 'disk sub-menu: DISK_BACK, DISK_LOAD, DISK_SAVE, DISK_ERASE'),
    (0x9BB0, 1, 'LAST_CMD', 'letter of the last tape / disk command'),
    (0x9C04, 1, 'SG_CMD', 'command letter for SAVEGAME_GO ("w" zapisz Robbo, tape: "r" / "w")'),
    (0x9C05, 1, 'SG_SLOT', 'slot for SAVEGAME_GO'),
    (0x9F8C, 1, 'COL_REG', 'zmiana kolorow: colour chosen, 0-5 = COLOR0-4, PCOLR3'),
    (0x9F8D, 1, 'COL_EDIT', 'zmiana kolorow: 0 = choosing the colour, else changing it'),
    (0x9F8E, 20, 'MENU_JUMPS', 'the 10 menu functions, basic page then additional page'),
    (0x9FB6, 5, 'MENU_ROWS', 'offset of each menu row in PANEL_TXT'),
    (0xA50F, 8, 'ASK_WORD', '" wczytac" / " zapisac" / "skasowac" from DEV_WORDS'),
    (0xA521, 1, 'ASK_NUM', 'number of the set, ATASCII'),
    (0xA595, 29, 'MSG_LIST', 'message filled by the code'),
    (0xA65E, 2, 'ERR_DIGITS', 'error number - 100, two digits'),
    (0xA7F8, 6, 'ERR_CODES', 'tape / disk results with a message of their own; 0 ends'),
    (0xA7FE, 6, 'ERR_MSGS', 'their messages; the last: "blad numer ..."'),
    '* tape / disk ------------------',
    (0x9003, 1, 'IO_LOADED', '$FF after a set was read (IO_READ), 0 at each command'),
    (0x902B, 4, 'IO_LETTERS', 'command letters: r(ead) w(rite) e(rase) d(irectory)'),
    (0x902F, 8, 'IO_JUMPS', 'IO_READ, IO_WRITE, IO_ERASE, IO_DIR'),
    (0x9037, 12, 'SLOT_SEC', 'header sector of slots 0-5: 4, 256, 388, 520, 652, 784'),
    (0x9043, 8, 'SIG_USED', 'slot header of a used slot'),
    (0x904B, 8, 'SIG_FREE', 'slot header of an erased slot'),
    (0x9053, 1, 'IO_USED', 'bit mask of the used slots (IO_DIR), returned in A'),
    (0x9054, 6, 'SLOT_BIT', 'bit of slots 1-5 in IO_USED'),
    (0x91B3, 12, 'IO_RANGES', 'segments a set may load (IO_CHECK): $39A0-$39E0, $3A00-$3C00, $5000-$9000'),
    (0x92E1, 10, 'LIST_SET', 'segments of a planet set: planet tables $39A0-$39DF, title texts $3A00-$3BFF; 0 ends'),
    (0x92EB, 10, 'LIST_GAME', 'segments of the stand-alone game: engine $1E00-$3FFF, fonts $4800-$4FFF; 0 ends'),
    (0x93A9, 6, 'GB_HDR', 'boot record of the saved game: flags, 3 sectors, load $93A9, init TP_START'),
    (0x93B0, 1, 'GB_SECTOR', 'first data sector (IO_WRITE: the header sector of slot 0)'),
    (0x9430, 1, 'IO_SLOT', 'slot (X of IO_CMD): 1-5 planet sets, 0 = the stand-alone game'),
    (0x9431, 128, 'IO_BUF', 'sector buffer of the tape / disk routines'),
]

COMMENTS = {
    0x2092: 'next cave (Robbo: "nxtcv")',   # Robbo $1E5F
    0x2344: 'step one cell in the direction LM: UP_ / DW_ / LT_ / RT_ through JMP1, carry set if blocked (Robbo FD_)',   # Robbo $2124
    0x2363: 'test the cell to the left',   # Robbo $2143
    0x236D: 'test the cell to the right',   # Robbo $214D
    0x238D: 'add points to the score (Robbo: "dodaj punkty")',   # Robbo $256C
    0x23FA: 'outside the board: answer $A0, a wall (Robbo TST_W)',   # Robbo $2C6E
    0x2513: 'animated shapes, part 1: characters $1C-$1F of the board font from the phase in $4800 / $4A00 (Robbo CM1)',   # Robbo $2055
    0x2528: 'animated shapes, part 2: characters $0A-$15 (Robbo CM2)',   # Robbo $206A
    0x255D: 'Robbo\'s shape for the direction LM, walking phase $2502 when he moves; the footstep click on CONSOL (Robbo FA1, "-tup-")',   # Robbo $209F
    0x256F: "copy Robbo's shape into the board font ($3EF0 / $3FF0, Robbo CM3)",   # Robbo $20B1
    0x26A1: 'shot direction number from the bits of LM, start the bullet through KIET / SJMP (Robbo KIES)',   # Robbo $21FC
    0x26D0: 'Robbo moves in the direction (stick; random in the demo): LT_ / RT_ / UP_ / DW_, blocked -> PHAJ (Robbo MFC1)',   # Robbo $2250
    0x276E: 'push an object (Robbo: "pchaj?")',   # Robbo $231F
    0x27EE: 'take the object (GET_) and step in the direction LM, then MFEX (Robbo FGET)',   # Robbo $23F6
    0x27FF: 'door: opens with a key, KEYS (Robbo: "drzwi?")',   # Robbo $2407
    0x2825: 'screw / treasure (Robbo: "skarb?")',   # Robbo $242D
    0x2858: 'exit (Robbo: "wyjscie?")',   # Robbo $2460
    0x28C2: 'test: sliding box',   # Robbo $24CA
    0x293B: 'teleport exit: try the directions in turn (table TMVS $296B) for a free cell (Robbo WYCP)',   # Robbo $239D
    0x2957: 'Robbo leaves the teleport: put him at the new cell, the teleport back, TELE = 1 (Robbo WYSE)',   # Robbo $23B9
    0x297B: 'surprise box: random object (RND)',   # Robbo $24F4
    0x2996: '"super!" - a rare surprise (Robbo: "super!"): over the whole board magnets vanish, doors, eyes and creatures explode (Robbo SUP1)',   # Robbo $250F
    0x29BA: 'put an explosion $E1; at the end +500 points, sound $0D (Robbo SUP2)',   # Robbo $2533
    0x29F3: 'sliding box (bezwladna skrzynia) moving left until blocked (Robbo: "bezw skrzynie")',   # Robbo $257F
    0x29FE: 'sliding box (bezwladna skrzynia) moving right until blocked (Robbo: "bezw skrzynie")',   # Robbo $258A
    0x2A09: 'sliding box (bezwladna skrzynia) moving up until blocked (Robbo: "bezw skrzynie")',   # Robbo $2595
    0x2A14: 'sliding box (bezwladna skrzynia) moving down until blocked (Robbo: "bezw skrzynie")',   # Robbo $25A0
    0x2A19: 'sliding box: cannot move',   # Robbo $25A5
    0x2A24: 'sliding box: common part',   # Robbo $25B0
    0x2A29: 'random return (Robbo: "losowy powrot")',   # Robbo $25B5
    0x2A6E: 'blow up one of the 3 x 3 cells: a bomb $40 becomes a lit bomb $E0 (chain reaction), the others an explosion phase from WBPO (Robbo BOM0)',   # Robbo $25E5
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
    0x2D54: 'rotating gun turns to the previous direction, codes $2C-$2F (Robbo RDZL)',   # Robbo $28D7
    0x2D5F: 'rotating gun fires in its direction, 1 turn in 8 (table RDZP, Robbo RDZ1)',   # Robbo $28E2
    0x2D80: 'moving small gun, left (Robbo: "mov dziala")',   # Robbo $2903
    0x2D93: 'moving small gun, right',   # Robbo $2916
    0x2DA3: 'moving small gun: common part',   # Robbo $2926
    0x2DA6: 'barrier (Robbo: "zapora"), code $11: moves the block $0F one cell right along the row up to the end $05, then again from the start (interpretation)',   # Robbo $2929
    0x2EEE: "eyes in Robbo's row or column: step towards him (Robbo LEX)",   # Robbo $2AE0
    0x2EF4: 'eyes: now and then a step in a random direction (table TMVS, Robbo SKAC)',   # Robbo $2AE6
    0x300D: 'scroll the cave view',   # Robbo $2E14
    0x3029: 'scroll up',   # Robbo $2E30
    0x304D: 'scroll down',   # Robbo $2E54
    0x305A: 'scroll: load a screen line',   # Robbo $2E61
    0x3334: 'start a sound effect (A = effect)',   # Robbo $307A
    0x3367: 'reset the sound: SKCTL = 3, all voices off (Robbo PSST)',   # Robbo $30AD
    0x3370: 'clear the voice pointers and registers (loop of PSST, Robbo RESE)',   # Robbo $30B6
    0x3379: 'sound effects: VBI part',   # Robbo $30BF
    0x3384: 'sound VBI: for each of the 4 voices play the effect (SOPL) or silence it (Robbo SO1)',   # Robbo $30CA
    0x338E: 'silence the voice (Robbo SO2)',   # Robbo $30D4
    0x3394: 'next voice (Robbo SO3)',   # Robbo $30DA
    0x339A: 'sound effects: play',   # Robbo $30E0
    0x9EE2: 'display a byte as two digits (Robbo: "display byte")',   # Robbo $2E86
    0x22D0: 'step X one cell right; carry set if the cell is free',   # Robbo $20C4 (name from call sites)
    0x22EF: 'step X one cell left; carry set if the cell is free',   # Robbo $20DD (name from call sites)
    0x2308: 'step Y one cell down; carry set if the cell is free',   # Robbo $20F4 (name from call sites)
    0x2329: 'step Y one cell up; carry set if the cell is free',   # Robbo $210D (name from call sites)
    0x2358: 'JMP to the step routine, operand from the tables $235B / $235F (Robbo JMP1, LMVT)',   # Robbo $2138 (name from call sites)
    0x2377: 'test the cell above',   # Robbo $2157 (name from call sites)
    0x2381: 'test the cell below',   # Robbo $2161 (name from call sites)
    0x2388: 'properties of the tested cell from WHAT $32B1: bit 0 = a bullet destroys it, bit 1 = a bomb destroys it (Robbo T_EX)',   # Robbo $2168 (name from call sites)
    0x23AD: 'read the board cell at X/Y',   # Robbo $2BD0 (name from call sites)
    0x23C6: 'write object A to the board cell at X/Y',   # Robbo $2C0B (name from call sites)
    0x23DB: 'test the board cell',   # Robbo $2C51 (name from call sites)
    0x243D: 'redraw (Robbo CHNMON, reworked): BREAK back to the editor, FAC_STEP, ANIM, board to the screen with DRAW_ROW',   # Robbo $2042 (name from call sites)
    0x2731: 'Robbo stops (RUCH = 0), then MFEX (Robbo MFX1)',   # Robbo $22B4 (name from call sites)
    0x2735: "Robbo at X / Y: put him, his screen address is the scroll target ($2491 / $2495), FX / FY; the creature and magnet tests of Robbo's MFEX moved to TFAC / MGNL (Robbo MFEX)",   # Robbo $22B8 (name from call sites)
    0x2A8E: 'a bullet hit a bomb: put a lit bomb $60 (Robbo WYBO)',   # Robbo $2603 (name from call sites)
    0x2B13: 'small gun bullet: hit something',   # Robbo $2696 (name from call sites)
    0x2B59: 'small gun (dzialko) fires up',   # Robbo $26DC (name from call sites)
    0x2BCD: 'laser: hit something',   # Robbo $2750 (name from call sites)
    0x2FF6: 'end of the VBI',   # Robbo $2DFD (name from call sites)
    0x9EEB: 'display digits',   # Robbo $2E8F (name from call sites)
    0x0800: 'HELP: show the help text, page by page (entered from HELP_KEY)',
    0x0803: 'help screen display list: frame $092E, help page $B600 (17 lines), frame $0956, panel $083E (5 lines) and $0906 between graphics lines $BD00 / $BD50',
    0x083E: 'help screen bottom panel (credits) and key hints - screen codes',
    0x092E: 'frame lines around the help page (frame characters of the font)',
    0x0A3F: 'help: draw one page (16 lines) from the text pointer HLP_TOP',
    0x0A7A: 'help: format one line - frame characters, $14 toggles inverse, inverse digits = indentation',
    0x0B16: 'help: copy the help screen buffer',
    0x09A6: 'help: save PTR1 ... TMP4, find page HELP_PAGE, show it; the stick turns pages, fire leaves',
    0x0B3C: 'help: previous page (only if not at the start: left arrow in HLP_ARROWS)',
    0x0B62: 'help: next page (only if more text: right arrow in HLP_ARROWS+1)',
    0x0BB1: 'help: scroll animation',
    0x0BC5: 'help: clear the line buffer HLP_LINEBUF',
    0x0BD0: 'help scroll step back: the new page slides in from the right over the old one, from column TMP3',
    0x0BF7: 'help scroll step forward: the old page moves right, the new one shows from the left up to column TMP4',
    0x0C1C: 'help: pointers to the screen buffers',
    0x0C2D: 'help: pointers to the screen and the text position',
    0x0C40: 'help: wait for the next frame',
    0x0C47: 'help: advance the text pointer',
    0x0C4E: 'help: advance the screen pointer - not called',
    0x0C55: 'help: next screen line (+40)',
    0x0C61: 'help: next source line (+40)',
    0x9000: 'tape/disk: command letter in A (r, w, e, d - IO_LETTERS), X = slot; dispatch via IO_JUMPS',
    0x905A: 'directory: read the 5 slot headers, bit mask of used slots',
    0x9086: 'header sector of slot IO_SLOT -> DAUX (SLOT_SEC: sectors 4, 256, 388, 520, 652, 784)',
    0x909C: 'erase a slot: header " unused "',
    0x90DC: 'mark a slot used: header " RKdata "',
    0x9102: 'read a planet set from a slot',
    0x9135: 'load the planets of a set',
    0x917A: 'check the loaded set ("ten zestaw planet jest zniszczony")',
    0x91BF: 'write a planet set to a slot; slot 0: the stand-alone game ("zapisz Robbo")',
    0x9207: 'save the segments of LIST_SET (slot 0: LIST_GAME), then the used planets: $5000 + n * $200, $1F8 bytes each',
    0x9276: 'write a memory range as a byte stream',
    0x92B1: 'stand-alone game: format the disk, write its boot loader GB_HDR ... $942F to sectors 1-3',
    0x92F5: 'read one byte through the sector buffer IO_BUF',
    0x9314: 'write one byte through the sector buffer IO_BUF',
    0x9338: 'read a sector into IO_BUF (SIO R)',
    0x933C: 'write a sector from IO_BUF (SIO P)',
    0x9353: 'read a slot header and check it',
    0x9388: 'format the disk (SIO command $22)',
    0x928D: 'write the bytes IO_PTR ... IO_END (without the segment header)',
    0x93AF: 'boot of the saved stand-alone game (OS: load address + 6): segments from sector GB_SECTOR, after the 8-byte slot header; RTS at start 0, then the OS runs TP_START',
    0x93FD: 'boot of the saved game: next byte of the data sectors (own copy of IO_GETBYTE, DSKINV)',
    0x94E0: 'editor services: jump table (frame, init, colours, message, ...)',
    0x9541: 'one editor frame: colours, input, run the current command',
    0x962F: 'show message A with the error tone, then wait for fire (DISK_WAIT runs as the next command)',
    0x9BF2: 'run SAVEGAME_GO as the next command, with A = command letter, X = slot',
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
    0xB05F: 'editor DLI: board rows alternate the fonts $4000 / $4400 (DLI_ROW), panel colours and font $4C00 below',
    0xAFF7: 'first call only: help page 1 (the title page of the manual); then RTS is written over the LDA',
    0xB1C3: 'title editor: one key; the cursor is the character in inverse; carry set = leave',
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
    0xB2F4: 'text input: page TMP1 into bit 0 of PTR2+1 ($3A00 / $3B00)',
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
    0x9F4D: 'copy protection, run once at the end of the first PLANETS_FILL (then patched to RTS): PROT_SUM = SERIN XOR DOSINI+1, pointers disguised as arithmetic on CUR_ELEM ($000D, $D20D); skipped if $A804 is negative',
    0xB47D: 'copy protection 2, run at the first yes / no question (one-shot: the operand of lda #$00 gets bit 7 by ror $B47E): "eor $0A00,x" / "cmp $0440" are halved to $0500 / $0240 - the XOR of $FF and the boot loader $0501-$05FF must equal DFLAGS; else $4C (opcode of START) is written to $ACB3',
    0xACB3: 'copy protection 2 lock: this RTS becomes JMP $B003 (WAIT_VBL) when PROT_BOOT fails - the count is then RTCLOK+2 and PLANET_TEST reports "za duzo robocikow!"',
    0x9CF2: 'copy protection check: X = 12 ("murek") makes HDR_BUF+4,x read PROT_SUM ($9F8B); not 0 -> the planet is cleared',
    0xA828: 'module service BELL: the OS buzzer (OS_BELL, XL/XE ROM); not called by Konstruktor itself',
    0x1EDE: 'DLI 1 (Robbo DLI1): players to the planet colour PCOLR3, chains to DLI2',
    0x1EFD: 'DLI 2 (Robbo DLI2): info line at VCOUNT $60 - font $4C00, colours from COLOR4, chains to DLI3',
    0x1F3C: 'DLI 3 (Robbo DLI, 3rd case): info text colour cycles with RTCLOK',
    0x1F46: 'ENGINE_INIT: clear score / keys / ammunition, board row tables $23FD/$241D (board $BE00), display list, DLI1',
    0x1FC8: 'ENGINE_PLAY: own VBI (CVBL), clear the board, then the play loop (Robbo PCLO); a lost life restarts the planet',
    0x202C: 'leave the game (BREAK or the end): Y = $99, back to the caller of ENGINE_PLAY',
    0x2034: "restore the caller's VBI, silence, players off; return X = planet number, Y = lives",
    0x20C4: 'Robbo destroyed - the planet explodes (Robbo: "wybu komnate"): every cell except walls / empty becomes an explosion',
    0x20FC: 'run the board for $30 frames (Robbo WHIL)',
    0x210B: 'one turn of the board (Robbo: "chng cave"): call the behaviour of each cell from PROC, next animation phase',
    0x219F: 'start a planet (Robbo PLA1): info-line texts by mode, header to BOARD_HDR, screws, colours, players, TELE / KEYS / NABO',
    0x2247: 'enter a planet (Robbo: "wejscie"): wall shapes into the font by the header, draw the board column by column',
    0x23A0: 'wait X frames (Robbo WAIT)',
    0x23A6: 'wait for the next frame (Robbo HALT)',
    0x2470: 'CHNMON: draw one board row as 2 x 2 characters (target of the self-modified JMP $246D, waits a frame at the visible window)',
    0x24E0: "Robbo's step, from CHNMON: direction MOVE_DIR, FAC_TURN at FX / FY",
    0x2503: 'CHNMON (Robbo): copy the animation phase (CNTR) of the element shapes from $4800 into the board font',
    0x2582: 'is a creature next to Robbo (Robbo: "czy obok jest fac?"), tested from Robbo\'s side; carry clear = Robbo destroyed',
    0x25B7: 'kill (Robbo: ZABJ "zabij"): if X is eyes $26 or a creature $41-$4E, put an explosion at Robbo',
    0x25D1: "magnet in Robbo's row (Robbo MGNL, tested from Robbo's side): magnet $29 to the right / $28 to the left pulls Robbo",
    0x263D: "Robbo's turn: TFAC, FAC_MOVE, TFAC again",
    0x2648: "Robbo moves or shoots (body of Robbo's MFAC): fire + direction shoots (ammunition), else MFC1",
    0x26B9: 'JSR to the bullet start for the direction (operand from KIET, Robbo SJMP)',
    0x2615: 'Robbo appears (Robbo: "pojawiaj"), code $1B: FAC = 1, then WFA1',
    0x2619: "Robbo appears: when the scroll is done, sound $0B, Robbo's appearing shape $6A",
    0x2630: 'Robbo $2A (Robbo: "ruch"): only notes FX / FY, FAC = 1 - the move itself is FAC_STEP, from CHNMON',
    0x28ED: 'Robbo entering a teleport, code $39 (Konstruktor): FAC = 1, TELE = the teleport, put the teleport back',
    0x28FD: 'teleport $30-$38 (Robbo: "wyj z telepor"): if it is TELE, Robbo comes out next to it',
    0x2AC7: 'Robbo pulled left by a magnet (Robbo: "przyciagania faca")',
    0x2AE1: 'Robbo pulled right by a magnet',
    0x2AED: 'small gun firing left (Robbo DZ1L)',
    0x2B33: 'small gun firing right (Robbo DZ1R)',
    0x2B7F: 'small gun firing down (Robbo DZ1D)',
    0x2DE2: 'left-hand creature, moving left (Robbo: "stworki leworecz")',
    0x2DF7: 'left-hand creature, moving right',
    0x2E0C: 'left-hand creature, moving up',
    0x2E21: 'left-hand creature, moving down',
    0x2E36: 'right-hand creature, moving left (Robbo: "praworeczne")',
    0x2E4B: 'right-hand creature, moving right',
    0x2E60: 'right-hand creature, moving up',
    0x2E75: 'right-hand creature, moving down',
    0x2E8A: 'creature going left and right (Robbo: "lewo-prawo"), moving left',
    0x2E95: 'creature going left and right, moving right',
    0x2EA0: 'creature going up and down (Robbo: "gora-dol"), moving up',
    0x2EAB: 'creature going up and down, moving down',
    0x2EB6: 'shooting bat flying left (Robbo: "toperze pif-pafy"), shoots down at random',
    0x2EC0: 'shooting bat flying right',
    0x2ED5: 'eyes - follow Robbo (Robbo: "sledz")',
    0x2F19: 'capsule, closed: when all screws are collected, flash and open it (Robbo WYZA)',
    0x2F43: 'capsule, open: blinks $15 / $16 (Robbo WYOT)',
    0x2A33: 'bomb, code $60 (Robbo: "bomba"): explodes the 3 x 3 cells around it that may be destroyed (table $32B1, Robbo WHAT)',
    0x2F54: 'VBI (Robbo CVBL): sound, info line (planet, ammunition, keys, lives, screws, score), DLI1, scrolling',
    0x307F: 'show a BCD byte in the info line at Y (Robbo DSPB)',
    0x3088: 'show a digit in the info line at Y, top and bottom half (Robbo DSPD)',
    0x30B2: 'read the input (Robbo: "key to joy"): fire = triggers, SHIFT, RETURN; ESC; stick = both joysticks AND cursor keys',
    0x3120: 'no input pending (INPUT_NEW = 0): set INPUT_NEW and MOVE_DIR to $FF, A = 0 - not called',
    0x3130: 'key pressed: carry clear, A = key code; none: carry set, A = $FF',
    0x35C0: 'title page program - start of the saved Robbo game and of "test Robbo" ($35C1 = from the Konstruktor, $35C2 = planets)',
    0x3683: 'title page: start text; fire / START plays, OPTION or a pause starts the demo; then the congratulation text',
    0x36BC: 'play the planets in the order $39E0 with ENGINE_PLAY, 8 lives; every 4th planet is the restart point; carry set = game over',
    0x373C: 'fire / START / SHIFT pressed: carry clear on a new press',
    0x375B: 'OPTION pressed or a long pause: demo (TP_DEMOFLAG = $80), carry clear',
    0x3776: 'title page frame: timer, BREAK back to the Konstruktor, colour bars of the logo and the texts',
    0x3816: 'draw the "ROBBO" logo into the title screen $B600 (bitmap $391F, pixels doubled)',
    0x3880: 'show the title page with the text page A ($3A start / $3B congratulation)',
    0x388A: 'back to the Konstruktor ("BREAK aby wrocic"): texts back to normal video, JMP START',
    0x3913: 'wait for the next frame (copy of HALT)',
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
    0x0BD0: 'HLP_STEP_R',
    0x0BF7: 'HLP_STEP_L',
    0x0C1C: 'HLP_PTRSCR',
    0x0C2D: 'HLP_PTRTXT',
    0x0C40: 'HLP_WAIT',
    0x0C47: 'HLP_INCTXT',
    0x0C4E: 'HLP_INCSCR',
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
    0x9028: 'IO_GO',
    0x921F: 'SS_POS',
    0x9223: 'SS_LIST',
    0x9260: 'SS_PLANET',
    0x9286: 'PR_IDX',
    0x928D: 'IO_PUTDATA',
    0x913F: 'LS_IDX',
    0x93AF: 'GB_BOOT',
    0x93C9: 'GB_IDX',
    0x93FD: 'GB_GETBYTE',
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
    0x9554: 'MENU_CALL',
    0x246D: 'ROW_JMP',
    0x249A: 'ROW_CELL',
    0x932A: 'PB_BYTE',
    0x9E35: 'PNL_HINT',
    0x9EAE: 'PNL_RIGHT',
    0xAB34: 'PUT_ELEM',
    0xAB3D: 'ED_ERASE',
    0x961D: 'MENU_LEAVE',
    0x962F: 'MSG_WAIT',
    0x9964: 'ORD_MOVE',
    0x9985: 'ORD_LEAVE',
    0x9A61: 'DSK_GO',
    0x9BF2: 'SG_SET',
    0x9DC8: 'HDR_LOAD',
    0x9E11: 'HDR_STORE',
    0x9EB4: 'PNL_LEFT',
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
    0xA828: 'BELL',
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
    0xAEF4: 'PC_CURSOR',
    0xAF35: 'PC_STA1',
    0xAF3A: 'PC_STA2',
    0xAF3E: 'ED_SETUP',
    0xB003: 'WAIT_VBL',
    0xB05F: 'ED_DLI',
    0xAFF7: 'ED_FIRSTHELP',
    0xB1C3: 'TX_KEY',
    0xB238: 'TX_GO',
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
    0x9F4D: 'PROT_KEY',
    0xB47D: 'PROT_BOOT',
    0xB48A: 'PROT_EOR',
    0xB490: 'PROT_CMP',
    0xACB3: 'COUNT_RTS',
    0x1EDE: 'DLI1',
    0x1EFD: 'DLI2',
    0x1F3C: 'DLI3',
    0x1F46: 'ENGINE_INIT_',
    0x1FC8: 'ENGINE_PLAY_',
    0x202C: 'PLAY_ABORT',
    0x2034: 'PLAY_EXIT',
    0x20C4: 'WYBC',
    0x20FC: 'WHIL',
    0x210B: 'CHNGCV',
    0x2148: 'CALL',
    0x219F: 'PLA1',
    0x2247: 'ENTCV',
    0x23A0: 'WAIT',
    0x23A6: 'HALT',
    0x2470: 'DRAW_ROW',
    0x24E0: 'FAC_STEP',
    0x2503: 'ANIM',
    0x2582: 'TFAC',
    0x25B7: 'ZABJ',
    0x25D1: 'MGNL',
    0x263D: 'FAC_TURN',
    0x2648: 'FAC_MOVE',
    0x26B9: 'SJMP',
    0x2615: 'WFAC',
    0x2619: 'WFA1',
    0x2630: 'MFAC',
    0x28ED: 'TELE_IN',
    0x28FD: 'TELP',
    0x2AC7: 'MGFL',
    0x2AE1: 'MGFR',
    0x2AED: 'DZ1L',
    0x2B33: 'DZ1R',
    0x2B7F: 'DZ1D',
    0x2DE2: 'STWA',
    0x2DF7: 'STWB',
    0x2E0C: 'STWC',
    0x2E21: 'STWD',
    0x2E36: 'STWE',
    0x2E4B: 'STWF',
    0x2E60: 'STWG',
    0x2E75: 'STWH',
    0x2E8A: 'STWI',
    0x2E95: 'STWJ',
    0x2EA0: 'STWK',
    0x2EAB: 'STWL',
    0x2EB6: 'TOPL',
    0x2EC0: 'TOPR',
    0x2ED5: 'LEDZ',
    0x2F19: 'WYZA',
    0x2F43: 'WYOT',
    0x2A33: 'BOMB',
    0x2F54: 'CVBL',
    0x307F: 'INFO_BYTE',
    0x3088: 'INFO_DIGIT',
    0x30B2: 'KEJO',
    0x3120: 'INPUT_FORCE',
    0x3130: 'GET_KEY',
    0x35C0: 'TP_START',
    0x3683: 'TP_LOOP',
    0x36BC: 'TP_PLAY',
    0x373C: 'TP_KEY',
    0x375B: 'TP_DEMO',
    0x3776: 'TP_FRAME',
    0x3816: 'TP_LOGO',
    0x3880: 'TP_PAGE',
    0x388A: 'TP_EXIT',
    0x3913: 'TP_HALT',
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
