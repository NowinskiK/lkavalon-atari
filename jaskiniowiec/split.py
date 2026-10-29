"""Splits the game memory image into source blocks (like misja/digi-duck):
code areas -> src/*.ASM (disassembly), data areas -> binary files with an Atari $FFFF header,
plus src/JOINT.ASM (common labels) and main.asm (links everything back together).

Usage: py -3 split.py game.bin ENTRY [ENTRY ...]
Edit BLOCKS to move boundaries or give blocks better names, then run it again."""
import sys, os
sys.path.insert(0, '.')
from xex import L
from rdis import analyze, Lister, hw

# (file, first, last, description) - .ASM files are disassembled, everything else is written as binary
BLOCKS = [
    ('SYSTEM.DTA',  0x0000, 0x04FF, 'zero page, stack, OS variables at snapshot time'),
    ('D0500.DTA',   0x0500, 0x17FF, 'data'),
    ('D1800.DTA',   0x1800, 0x24FF, 'data'),
    ('D2500.DTA',   0x2500, 0x2F7F, 'data (32-byte records)'),
    ('LEVELS.DTA',  0x2F80, 0x61FF, 'level tile maps'),
    ('TRAINER.ASM', 0x6200, 0x646F, 'CAMOsoft crack stub and trainer'),
    ('D6470.DTA',   0x6470, 0x6BFF, 'character screen'),
    ('FONT6C.FNT',  0x6C00, 0x6FFF, 'font'),
    ('D7000.DTA',   0x7000, 0x7BFF, 'data'),
    ('CODE7C.ASM',  0x7C00, 0x8DEF, 'code and tables'),
    ('MAIN.ASM',    0x8DF0, 0x9FFF, 'game entry ($8E67), NMI/IRQ/VBI handlers'),
    ('CODEA0.ASM',  0xA000, 0xBBFF, 'code, display list ($ACFC)'),
    ('START.ASM',   0xBC00, 0xBFFF, 'start stub ($BC00) and tables'),
    ('TABLES.DTA',  0xC000, 0xC9FF, 'tables (bit reverse at $C000)'),
    ('MUSIC.CMC',   0xEA00, 0xF2E0, 'CMC music module'),
    ('CMC.ASM',     0xF2E1, 0xFAD1, 'CMC music player'),
    ('VECTORS.ASM', 0xFFFA, 0xFFFF, 'NMI, RESET, IRQ vectors'),
]

SRC = 'src'


def header(name, lo, hi, desc):
    return ['; %s - %s' % (name, desc), '; $%04X-$%04X' % (lo, hi), '', '         org $%04X' % lo, '']


def main():
    mem = open(sys.argv[1], 'rb').read()
    code, labels = analyze(mem, [int(a, 16) for a in sys.argv[2:]])
    lst = Lister(mem, code, labels)
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

    # anything outside the blocks that is not zero would be lost
    covered = bytearray(65536)
    for _, lo, hi, _ in BLOCKS: covered[lo:hi + 1] = b'\1' * (hi - lo + 1)
    lost = [a for a in range(65536) if mem[a] and not covered[a] and not hw(a)]
    if lost: print('WARNING: %d non-zero bytes outside blocks, first at $%04X' % (len(lost), lost[0]))

    # labels used in operands but not written at their own address (inside an instruction or outside the blocks)
    extra = sorted(a for a in lst.used if a not in lst.placed)
    joint = ['; JOINT.ASM - common labels', '', '; Atari OS and hardware', '']
    joint += ['%-8s equ $%04X' % (n, a) for a, n in sorted(L.items(), key=lambda x: x[0]) if '+' not in n]
    if extra:
        joint += ['', '; labels not at an instruction boundary or outside the source blocks', '']
        joint += ['%-10s equ $%04X' % (lst.used[a], a) for a in extra]
    open(os.path.join(SRC, 'JOINT.ASM'), 'w', newline='\n').write('\n'.join(joint) + '\n')

    out = ['; Jaskiniowiec (1995, StanBit) - memory image of the game rebuilt from blocks',
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
