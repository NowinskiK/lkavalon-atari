"""Minimal 6502 assembler for the subset of MADS syntax that split.py writes
(org, equ, opt, icl, ins, dta bytes / a(), labels, instructions). Used to check the
split without MADS. Usage: py -3 util/asm.py main.asm out.obx"""
import sys, os, re
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from xex import M, segments

OP = {(mn, mode): o for o, (mn, mode) in M.items()}


QUOTES = ("'", '"')


def strip_comment(line):
    """Cut a ';' comment, but not inside quotes."""
    q = None
    for i, ch in enumerate(line):
        if q:
            if ch == q: q = None
        elif ch in QUOTES: q = ch
        elif ch == ';': return line[:i]
    return line


def split_items(arg):
    """Split dta arguments at commas outside quotes and parentheses."""
    items, cur, q, depth = [], '', None, 0
    for ch in arg:
        if q:
            cur += ch
            if ch == q: q = None
        elif ch in QUOTES: q = ch; cur += ch
        elif ch == '(': depth += 1; cur += ch
        elif ch == ')': depth -= 1; cur += ch
        elif ch == ',' and depth == 0: items.append(cur.strip()); cur = ''
        else: cur += ch
    if cur.strip(): items.append(cur.strip())
    return items


def to_internal(c):
    """ATASCII -> ANTIC screen code (7 bits)."""
    return c + 0x40 if c < 0x20 else (c - 0x20 if c < 0x60 else c)


class Asm:
    def __init__(s, root):
        s.root = root; s.sym = {}

    def val(s, e, strict):
        v = 0
        for sign, t in re.findall(r'([+-]?)\s*([^+-]+)', e.strip()):
            t = t.strip()
            if t.startswith('$'): x = int(t[1:], 16)
            elif t.isdigit(): x = int(t)
            elif t == '*': x = s.pc                     # current address (NAME equ *+1)
            elif t.upper() in s.sym: x = s.sym[t.upper()]
            elif strict: raise ValueError('undefined label %s' % t)
            else: return None
            v += -x if sign == '-' else x
        return v & 0xFFFF

    def lines(s, path):
        for n, line in enumerate(open(os.path.join(s.root, path), encoding='utf-8'), 1):
            line = strip_comment(line).rstrip()
            if not line.strip() or line.lstrip().startswith('*'): continue
            label = None
            if not line[0].isspace():
                label, _, line = line.partition(' ') if ' ' in line else (line, '', '')
            parts = line.split(None, 1)
            yield path, n, label, parts[0].lower() if parts else '', parts[1].strip() if len(parts) > 1 else ''

    def run(s, path, strict):
        s.segs = []; s.pc = 0; s.changed = False; s.new_seg = True
        s.file(path, strict)
        return s.segs

    def emit(s, data):
        if s.segs and s.segs[-1][0] + len(s.segs[-1][1]) == s.pc and not s.new_seg:
            s.segs[-1][1].extend(data)
        else:
            s.segs.append([s.pc, bytearray(data)])
        s.new_seg = False
        s.pc += len(data)

    def file(s, path, strict):
        for f, n, label, mn, arg in s.lines(path):
            try:
                if mn == 'equ' or mn == '=':
                    s.define(label, s.val(arg, strict)); continue
                if label: s.define(label, s.pc)
                if not mn or mn == 'opt': continue
                if mn == 'org': s.pc = s.val(arg, True); s.new_seg = True
                elif mn == 'icl': s.file(arg.strip('"\''), strict)
                elif mn == 'ins':
                    for st, en, data, _ in segments(open(os.path.join(s.root, arg.strip('"\'')), 'rb').read()):
                        s.pc = st; s.new_seg = True; s.emit(data)
                elif mn == 'dta':
                    out = []
                    for item in split_items(arg):
                        m = re.fullmatch(r'a\((.*)\)', item, re.I)
                        t = re.fullmatch(r"""([cd])(?P<q>["'])(.*)(?P=q)(\*?)""", item, re.I | re.S)
                        if m:
                            v = s.val(m.group(1), strict) or 0; out += [v & 0xFF, v >> 8]
                        elif t:                                   # c'...' ATASCII / d'...' screen codes, * = inverse
                            for ch in t.group(3):
                                b = ord(ch)
                                if t.group(1).lower() == 'd': b = to_internal(b)
                                out.append(b | (0x80 if t.group(4) else 0))
                        else:
                            out.append((s.val(item, strict) or 0) & 0xFF)
                    s.emit(out)
                else:
                    s.emit(s.instr(mn, arg, strict))
            except Exception as e:
                raise SystemExit('%s:%d: %s' % (f, n, e))

    def define(s, name, v):
        if v is None: return
        if s.sym.get(name.upper()) != v: s.changed = True
        s.sym[name.upper()] = v

    def instr(s, mn, arg, strict):
        mn = mn.upper()
        if not arg:
            mode = 'acc' if (mn, 'acc') in OP else 'imp'; return [OP[mn, mode]]
        if arg.startswith('#'):
            v = s.val(arg[1:], strict) or 0; return [OP[mn, 'imm'], v & 0xFF]
        for pat, mode in ((r'\((.+),x\)', 'izx'), (r'\((.+)\),y', 'izy'), (r'\((.+)\)', 'ind')):
            m = re.fullmatch(pat, arg, re.I)
            if m:
                v = s.val(m.group(1), strict) or 0
                return [OP[mn, mode], v & 0xFF] if mode != 'ind' else [OP[mn, mode], v & 0xFF, v >> 8]
        m = re.fullmatch(r'(.+),([xy])', arg, re.I)
        expr, idx = (m.group(1), m.group(2).lower()) if m else (arg, '')
        v = s.val(expr, strict)
        if (mn, 'rel') in OP:
            d = ((v or s.pc + 2) - (s.pc + 2))
            if strict and not -128 <= d <= 127: raise ValueError('branch out of range')
            return [OP[mn, 'rel'], d & 0xFF]
        zp, ab = ('zp' + idx, 'ab' + idx) if idx else ('zp', 'abs')
        if v is not None and v < 0x100 and (mn, zp) in OP: return [OP[mn, zp], v]
        v = v or 0
        return [OP[mn, ab], v & 0xFF, v >> 8]


def assemble(path):
    a = Asm(os.path.dirname(os.path.abspath(path)))
    name = os.path.basename(path)
    for _ in range(10):
        a.run(name, False)
        if not a.changed: break
    return a.run(name, True)


if __name__ == '__main__':
    out = bytearray()
    for st, data in assemble(sys.argv[1]):
        out += bytes([0xFF, 0xFF, st & 0xFF, st >> 8, (st + len(data) - 1) & 0xFF, (st + len(data) - 1) >> 8]) + data
    open(sys.argv[2], 'wb').write(out)
    print('%s: %d bytes' % (sys.argv[2], len(out)))
