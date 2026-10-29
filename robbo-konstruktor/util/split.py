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
    ('D0C6D.DTA',   0x0C6D, 0x1DD0, 'data (4.4 KB, text-like)'),
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


VARIABLES = []
COMMENTS = {}
NAMES = {}
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
        if a in labels: labels[a] = n
        else: print('WARNING: name %s for $%04X - no label there' % (n, a))
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
