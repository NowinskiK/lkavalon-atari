"""Recursive-descent disassembler over a 64K memory image -> MADS-style listing."""
import sys, os
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from xex import M, SZ, L


def hw(a):
    return 0xD000 <= a < 0xD800


VECTOR_LO = (0x0200, 0x0222, 0x0224, 0xFFFA, 0xFFFE)   # VDSLST, VVBLKI, VVBLKD, NMI, IRQ (low bytes)


SETVBV = 0xE45C


def analyze(mem, entries, nofollow=()):
    """Follow code from the entry points. Returns (code: addr -> length, labels: addr -> name).
    nofollow: addresses of JMP/JSR instructions whose operand is self-modified (target not followed).
    Their operands are treated like vectors: an immediate address written into them becomes an entry
    point, as does a VBI installed with LDY #lo / LDX #hi / JSR SETVBV."""
    vector_lo = set(VECTOR_LO) | {a + 1 for a in nofollow}
    code = {}
    labels = {}
    for e in entries: labels[e] = 'entry_%04X' % e
    seen_vec = set()
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
            if mn in ('JMP', 'JSR') and mode == 'abs' and pc not in nofollow:
                labels.setdefault(w, ('sub_%04X' if mn == 'JSR' else 'L%04X') % w)
                if not (w >= 0xE400 and w < 0xE480): work.append(w)
            # vector set-ups (LDA/LDX/LDY #... then STA/STX/STY VDSLST, VVBLKD ...): track which register
            # holds which immediate value and pair the stores to the vector's low and high byte
            if mn in ('LDA', 'LDX', 'LDY') and mode == 'imm':
                regs, lo, hi, k = {}, {}, {}, pc
                for _ in range(8):
                    if mem[k] not in M: break
                    kmn, kmode = M[mem[k]]
                    kw = mem[k + 1] | mem[k + 2] << 8
                    if kmn in ('LDA', 'LDX', 'LDY') and kmode == 'imm':
                        regs[kmn[2]] = mem[k + 1]
                    elif kmn in ('STA', 'STX', 'STY') and kmode == 'abs' and kmn[2] in regs:
                        if kw in vector_lo: lo[kw] = regs[kmn[2]]
                        if kw - 1 in vector_lo: hi[kw - 1] = regs[kmn[2]]
                    elif kmn == 'JSR' and kw == SETVBV and 'Y' in regs and 'X' in regs:
                        lo[SETVBV], hi[SETVBV] = regs['Y'], regs['X']
                        break
                    elif kmn not in ('STA', 'STX', 'STY'):
                        break
                    k += SZ[kmode]
                for v in lo:
                    if v in hi:
                        cand = lo[v] | hi[v] << 8
                        if cand not in seen_vec:
                            seen_vec.add(cand); labels.setdefault(cand, 'irq_%04X' % cand); work.append(cand)
            if mn in ('RTS', 'RTI', 'BRK') or (mn == 'JMP'): break
            pc += n
    return code, labels


VECTORS = (0x0200, 0x0222, 0x0224)   # OS vectors: the high byte is written as NAME+1


class Lister:
    """Turns an analysed image into listing lines; remembers which labels it placed and used.

    variables: list of '* group' strings and (address, size, name, comment) tuples. A variable inside a
    listed range is written in place as `NAME dta ... ; comment`; operands use NAME / NAME+n.
    pokes: {address: count} – tables of (address lo, hi, value) entries, written as `dta a(NAME),$vv`.
    comments: {address: text} – group comment `* text ---` written above that address."""

    def __init__(s, mem, code, labels, variables=(), pokes=None, comments=None):
        s.mem, s.code, s.labels = mem, code, labels
        s.placed = set()   # addresses whose label was written at its own position
        s.used = {}        # address -> name, for every label referenced in an operand
        s.vars = {}        # address -> (size, name, comment, group header or None)
        s.var_at = {}      # every byte of a variable -> (start address, offset)
        s.var_placed = set()
        group = None
        for v in variables:
            if isinstance(v, str):
                group = v; continue
            addr, size, name, comment = v
            s.vars[addr] = (size, name, comment, group); group = None
            for k in range(size): s.var_at[addr + k] = (addr, k)
        s.pokes = pokes or {}
        s.comments = comments or {}
        s.placed_comments = set()

    def nm(s, a, w):
        if a in s.var_at:
            st, k = s.var_at[a]
            return s.vars[st][1] + ('+%d' % k if k else '')
        if a in L: return L[a]
        if a - 1 in VECTORS: return L[a - 1] + '+1'
        if a in s.labels:
            s.used[a] = s.labels[a]; return s.labels[a]
        return ('$%02X' % a) if w == 1 else ('$%04X' % a)

    def poke_lines(s, a, count):
        out = []
        for i in range(count):
            p = a + i * 3
            t = s.mem[p] | s.mem[p + 1] << 8
            note = s.vars[s.var_at[t][0]][2] if t in s.var_at else ''
            out.append('         %-36s ; %04X %s' % ('dta a(%s),$%02X' % (s.nm(t, 2), s.mem[p + 2]), p, note))
        return out

    def lines(s, lo, hi):
        mem, code, labels = s.mem, s.code, s.labels
        out = []
        a = lo
        while a <= hi:
            if a in s.comments:
                s.placed_comments.add(a)
                text = '* %s ' % s.comments[a]
                out += ['', text + '-' * max(3, 60 - len(text))]
            if a in s.pokes and a not in code:
                out += s.poke_lines(a, s.pokes[a]); a += 3 * s.pokes[a]
                continue
            if a in s.vars and a not in code:
                size, name, comment, group = s.vars[a]
                if group: out += ['', group]
                body = 'dta ' + ','.join('$%02X' % b for b in mem[a:a + size])
                out.append('%-16s %-36s ; %04X %s' % (name, body, a, comment))
                s.var_placed.add(a); s.placed.add(a)
                a += size
                continue
            if a in labels:
                out.append('%s' % labels[a]); s.placed.add(a)
            if a in code:
                n = code[a]; o = mem[a]; mn, mode = M[o]
                b1 = mem[a + 1]; w = b1 | mem[a + 2] << 8
                if mode in ('abs', 'abx', 'aby') and w < 0x100:
                    # an assembler would pick zero page here: keep the absolute form as bytes
                    out.append('         %-25s ; %04X %s %s' % ('dta $%02X,a($%04X)' % (o, w), a, mn.lower(),
                                                              {'abs': '', 'abx': ',x', 'aby': ',y'}[mode]))
                    a += n
                    continue
                nm = s.nm
                opnd = {'imp': '', 'acc': '', 'imm': '#$%02X' % b1, 'zp': nm(b1, 1), 'zpx': nm(b1, 1) + ',x',
                        'zpy': nm(b1, 1) + ',y', 'izx': '(%s,x)' % nm(b1, 1), 'izy': '(%s),y' % nm(b1, 1),
                        'rel': nm((a + 2 + (b1 - 256 if b1 > 127 else b1)) & 0xFFFF, 2),
                        'abs': nm(w, 2), 'abx': nm(w, 2) + ',x', 'aby': nm(w, 2) + ',y', 'ind': '(%s)' % nm(w, 2)}[mode]
                out.append('         %-4s %-20s ; %04X' % (mn.lower(), opnd, a))
                a += n
            else:
                st = a; row = []
                while (a <= hi and a not in code and (a == st or (a not in labels and a not in s.vars
                       and a not in s.pokes and a not in s.comments)) and len(row) < 16):
                    row.append(mem[a]); a += 1
                out.append('         dta %-40s ; %04X' % (','.join('$%02X' % b for b in row), st))
        return out


def code_ranges(code):
    ranges = []
    for k in sorted(code):
        if ranges and ranges[-1][1] == k: ranges[-1][1] = k + code[k]
        else: ranges.append([k, k + code[k]])
    return ranges


if __name__ == '__main__':
    mem = open(sys.argv[1], 'rb').read()
    code, labels = analyze(mem, [int(a, 16) for a in sys.argv[3:]])
    lo, hi = int(sys.argv[2].split('-')[0], 16), int(sys.argv[2].split('-')[1], 16)
    open(sys.argv[2].replace('-', '_') + '.asm', 'w').write('\n'.join(Lister(mem, code, labels).lines(lo, hi)))
    print('code bytes:', sum(code.values()), 'instructions:', len(code), 'labels:', len(labels))
    print('code ranges:', ' '.join('$%04X-$%04X' % (x, y - 1) for x, y in code_ranges(code) if y - x > 8))
