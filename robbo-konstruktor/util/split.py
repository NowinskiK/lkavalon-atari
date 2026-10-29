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
    ('HELP.DTA',    0x0C6D, 0x1DD0, 'help text: 16 pages in Polish (HELP key), packed: bit 7 = add a space'),
    ('ENGINE1.ASM', 0x1E00, 0x23FC, 'game engine: jump table $1E00, display list, DLIs'),
    ('ENGINE2.ASM', 0x243D, 0x35A3, 'game engine: object behaviour (table $31EF), VBI $2F54'),
    ('ENGINE3.ASM', 0x35C0, 0x395C, 'game engine: display list, code'),
    ('FONT3C.FNT',  0x3C00, 0x3FFF, 'font (modified Robbo F.FNT)'),
    ('D4000.DTA',   0x4000, 0x47FF, 'data'),
    ('FONT48.FNT',  0x4800, 0x4BFF, 'font (modified Robbo S.FNT)'),
    ('FONT4C.FNT',  0x4C00, 0x4FFF, 'font (modified Robbo I.FNT)'),
    ('EDIT90.ASM',  0x9000, 0x9430, 'editor code'),
    ('EDITOR.ASM',  0x94E0, 0x9F7A, 'editor: menu dispatch, cursor, commands'),
    ('TEXTS.DTA',   0x9F7B, 0xA808, 'editor tables and texts (menu table $9F8E)'),
    ('EDITOR2.ASM', 0xA810, 0xB5FF, 'editor: jump table $A810, main loop, screen, DLI, text input'),
    ('LOADSCR.DTA', 0xBC40, 0xBC67, 'loading screen line "Robbo Konstruktor (C) 1990 Avalon"'),
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
    lst = Lister(mem, code, labels, VARIABLES, POKES, COMMENTS)
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
            open(path, 'w', newline='\n').write('\n'.join(header(name, lo, hi, desc) + body) + '\n')
        elif name.endswith('.ASM'):
            body = lst.lines(lo, hi)
            open(path, 'w', newline='\n').write('\n'.join(header(name, lo, hi, desc) + body) + '\n')
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
    open(os.path.join(SRC, 'JOINT.ASM'), 'w', newline='\n').write('\n'.join(joint) + '\n')

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
    open('main.asm', 'w', newline='\n').write('\n'.join(out) + '\n')

    print('blocks:', len(BLOCKS), 'code bytes:', sum(code.values()), 'labels:', len(labels),
          'extra equ labels:', len(extra))


if __name__ == '__main__':
    main()
