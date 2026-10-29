"""Finds texts still hidden in data bytes: scans the `dta $xx,...  ; ADDR` lines of a game's .ASM sources and
reports runs of bytes that read as words in ATASCII or ANTIC screen code (normal or inverse, Polish letters on
the CONTROL codes or on the glyphs of Robbo's fonts). Candidates must be checked by a person: each becomes a
dta c'...' / d'...' string (TEXTS in split.py) or is noted in NOTES.md as not a text.

Ranges already checked and found not to be texts are listed in <game>/findtext-ignore.txt (next to src/), one per
line: `29D3-29F2  reason`; they are not reported again. A clean result ends with "0 candidate(s)".

Usage (from the repository root):
  py -3 util/findtext.py robbo-konstruktor/src [min_letters]"""
import sys, os, re

DTA = re.compile(r'^\s+dta\s+((?:\$[0-9A-F]{2},?)+)\s*;\s*([0-9A-F]{4})\b', re.I)
POLISH_ATASCII = set(b'\x01\x03\x05\x0c\x0e\x0f\x13\x1a')        # CONTROL + a c e l n o s z
POLISH_GLYPHS = set(b'@\\[]_{^|')                                  # screen-code texts in Robbo's fonts


def data_runs(folder):
    """Contiguous runs of data bytes: {start address: bytes}."""
    runs, cur, nxt = {}, None, None
    for name in sorted(os.listdir(folder)):
        if not name.upper().endswith('.ASM'): continue
        for line in open(os.path.join(folder, name), encoding='utf-8', errors='replace'):
            m = DTA.match(line)
            if not m: continue
            a, data = int(m.group(2), 16), bytes(int(x, 16) for x in re.findall(r'\$([0-9A-F]{2})', m.group(1), re.I))
            if cur is not None and a == nxt: runs[cur] += data
            else: cur = a; runs[cur] = bytearray(data)
            nxt = a + len(data)
    return runs


def as_atascii(b):
    c = b & 0x7F
    if c in POLISH_ATASCII: return '~'          # Polish letter
    return chr(c) if 0x20 <= c < 0x7B else None


def as_screen(b):
    c = b & 0x7F
    a = c + 0x20 if c < 0x40 else (c - 0x40 if c < 0x60 else c)
    if a in POLISH_GLYPHS: return '~'
    return chr(a) if 0x20 <= a < 0x7B else None


def candidates(start, data, decode, min_letters):
    out, i = [], 0
    while i < len(data):
        j, text = i, ''
        while j < len(data) and decode(data[j]) is not None:
            text += decode(data[j]); j += 1
        # judge sentence-like pieces: letters, spaces and light punctuation, starting with a letter
        for m in re.finditer(r"[A-Za-z~][A-Za-z~0-9 .,:;!?'()-]*", text):
            piece = m.group().rstrip()
            # word-like: lower case, Capitalised or capitals, with a vowel, not one letter repeated
            words = [w for w in re.findall(r'[A-Za-z~]+', piece)
                     if len(w) >= 3 and re.fullmatch(r'[A-Z]*[a-z~]+|[A-Z~]+', w)
                     and re.search(r'[aeiouyAEIOUY]', w) and len(set(w.lower())) > 2 and w.count('~') * 3 <= len(w)]
            good = sum(len(w) for w in words)
            if good >= min_letters and good >= 0.6 * len(piece.replace(' ', '')):
                out.append((start + i + m.start(), piece))
        i = j + 1
    return out


def main():
    args = sys.argv[1:]
    folder, min_letters = args[0], int(args[1]) if len(args) > 1 else 5
    ignore = []
    listed = os.path.join(os.path.dirname(os.path.abspath(folder)), 'findtext-ignore.txt')
    if os.path.exists(listed):
        for line in open(listed, encoding='utf-8'):
            m = re.match(r'\s*([0-9A-F]{4})-([0-9A-F]{4})\b', line, re.I)
            if m: ignore.append((int(m.group(1), 16), int(m.group(2), 16)))
    found = []
    for start, data in data_runs(folder).items():
        for coding, dec in (('ATASCII', as_atascii), ('screen ', as_screen)):
            found += [(a, coding, t) for a, t in candidates(start, data, dec, min_letters)]
    found = [f for f in sorted(found) if not any(lo <= f[0] <= hi for lo, hi in ignore)]
    for a, coding, t in found:
        print('$%04X  %s  %s' % (a, coding, t[:100]))
    print('%d candidate(s) in data bytes of %s' % (len(found), folder))


if __name__ == '__main__':
    main()
