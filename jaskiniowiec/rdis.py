"""Recursive-descent disassembler over a 64K memory image -> MADS-style listing."""
import sys
sys.path.insert(0, '.')
from xex import M, SZ, L

mem = open(sys.argv[1], 'rb').read()
entries = [int(a, 16) for a in sys.argv[3:]]
code = {}            # addr -> length
labels = {}          # addr -> name
for e in entries: labels[e] = 'entry_%04X' % e
seen_vec = set()

def hw(a):
    return 0xD000 <= a < 0xD800

work = list(entries)
while work:
    pc = work.pop()
    while 0 <= pc < 0x10000 and pc not in code and not hw(pc):
        o = mem[pc]
        if o not in M: break
        mn, mode = M[o]; n = SZ[mode]
        if any((pc + k) in code for k in range(1, n)): break
        code[pc] = n
        b1 = mem[(pc + 1) & 0xFFFF]; w = b1 | mem[(pc + 2) & 0xFFFF] << 8
        if mode == 'rel':
            t = (pc + 2 + (b1 - 256 if b1 > 127 else b1)) & 0xFFFF
            labels.setdefault(t, 'L%04X' % t); work.append(t)
        if mn in ('JMP', 'JSR') and mode == 'abs':
            labels.setdefault(w, ('sub_%04X' if mn == 'JSR' else 'L%04X') % w)
            if not (w >= 0xE400 and w < 0xE480): work.append(w)
        # vector set-ups: LDA #<x / LDX #<x ... STA VDSLST/VVBLKD etc. -> follow immediate pairs
        if mn in ('LDA', 'LDX', 'LDY') and mode == 'imm':
            o2 = mem[pc + 2]
            if o2 in M and M[o2][1] == 'imm' and M[o2][0] in ('LDA', 'LDX', 'LDY'):
                cand = b1 | mem[pc + 3] << 8
                # look ahead for a store into a known vector
                for k in range(pc + 4, pc + 16):
                    if mem[k] in (0x8D, 0x8E, 0x8C) and (mem[k+1] | mem[k+2] << 8) in (0x0200, 0x0201, 0x0222, 0x0223, 0x0224, 0x0225, 0xFFFA, 0xFFFE):
                        if cand not in seen_vec:
                            seen_vec.add(cand); labels.setdefault(cand, 'irq_%04X' % cand); work.append(cand)
                        break
        if mn in ('RTS', 'RTI', 'BRK') or (mn == 'JMP'): break
        pc += n

def nm(a, w):
    if a in L: return L[a]
    if a in labels: return labels[a]
    return ('$%02X' % a) if w == 1 else ('$%04X' % a)

lo, hi = int(sys.argv[2].split('-')[0], 16), int(sys.argv[2].split('-')[1], 16)
out = []
a = lo
while a <= hi:
    if a in labels: out.append('%s' % labels[a])
    if a in code:
        n = code[a]; o = mem[a]; mn, mode = M[o]
        b1 = mem[a + 1]; w = b1 | mem[a + 2] << 8
        opnd = {'imp': '', 'acc': '', 'imm': '#$%02X' % b1, 'zp': nm(b1, 1), 'zpx': nm(b1, 1) + ',x',
                'zpy': nm(b1, 1) + ',y', 'izx': '(%s,x)' % nm(b1, 1), 'izy': '(%s),y' % nm(b1, 1),
                'rel': nm((a + 2 + (b1 - 256 if b1 > 127 else b1)) & 0xFFFF, 2),
                'abs': nm(w, 2), 'abx': nm(w, 2) + ',x', 'aby': nm(w, 2) + ',y', 'ind': '(%s)' % nm(w, 2)}[mode]
        out.append('         %-4s %-20s ; %04X' % (mn.lower(), opnd, a))
        a += n
    else:
        s = a; row = []
        while a <= hi and a not in code and (a == s or a not in labels) and len(row) < 16:
            row.append(mem[a]); a += 1
        if any(row) or True:
            out.append('         dta %-40s ; %04X' % (','.join('$%02X' % b for b in row), s))
open(sys.argv[2].replace('-', '_') + '.asm', 'w').write('\n'.join(out))
print('code bytes:', sum(code.values()), 'instructions:', len(code), 'labels:', len(labels))
ranges = []
for k in sorted(code):
    if ranges and ranges[-1][1] == k: ranges[-1][1] = k + code[k]
    else: ranges.append([k, k + code[k]])
print('code ranges:', ' '.join('$%04X-$%04X' % (x, y - 1) for x, y in ranges if y - x > 8))
