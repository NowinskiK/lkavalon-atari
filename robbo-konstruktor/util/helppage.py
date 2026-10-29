"""Shows a help page the way the program draws it: runs the program's own HLP_PAGE ($0A3F) in the emulator on a
memory image and prints the 16 lines of the help screen buffer ($B880, 40 characters each) as text.

Help text format (HLP_LINE $0A7A, NOTES.md section 24): characters are ATASCII with Polish letters on CONTROL codes;
a character with bit 7 set is the last one of its line; $A0 alone = an empty line; $B1-$B9 = 1-9 spaces; $14 toggles
inverse video; ( / ) mark tape / disk variants; a page starts with $00 nn, the last page ends with $80 $00.

Usage (from robbo-konstruktor/):
  py -3 util/helppage.py game.bin 15                 page 15 of the original
  py -3 util/helppage.py bin/nocopyprot.obx 15       page 15 of a build (segment file)"""
import sys, os
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
from emu import CPU
from xex import segments

HLP_PAGE, TEXT_PTR, BUFFER = 0x0A3F, 0x0C77, 0xB880
HELP_START, HELP_END = 0x0C7B, 0x1DD0
ATA2SCR = 0xA834                       # module service: ATASCII -> screen code (used here only to build the reverse map)
POLISH = {0x01: 'ą', 0x03: 'ć', 0x05: 'ę', 0x0C: 'ł', 0x0E: 'ń', 0x0F: 'ó', 0x13: 'ś', 0x1A: 'ż'}


def load(path):
    data = open(path, 'rb').read()
    if len(data) == 65536: return bytearray(data)
    mem = bytearray(65536)
    for st, en, seg, _ in segments(data):
        mem[st:en + 1] = seg
    return mem


def page_address(mem, page):
    """Address HLP_PAGE expects in $0C77: 2 bytes before the text (the $00 nn marker; page 0 has none)."""
    if page == 0: return HELP_START - 2
    for a in range(HELP_START, HELP_END):
        if mem[a] == 0 and mem[a + 1] == page:
            return a
    raise SystemExit('page %d not found' % page)


def reverse_map(mem):
    """screen code -> character, by running the program's own conversion on every ATASCII code."""
    rev = {}
    for c in list(POLISH) + list(range(0x20, 0x7B)):          # Polish letters first: they share glyphs with [ \ ] _
        cpu = CPU(); cpu.m[:] = mem; cpu.a = c
        cpu.call(ATA2SCR)
        rev.setdefault(cpu.a & 0x7F, POLISH.get(c, chr(c)))
    rev[0] = ' '
    return rev


def render(mem, page):
    cpu = CPU(); cpu.m[:] = mem
    a = page_address(mem, page)
    cpu.m[TEXT_PTR], cpu.m[TEXT_PTR + 1] = a & 0xFF, a >> 8
    cpu.call(HLP_PAGE)
    rev = reverse_map(mem)
    lines = []
    for row in range(16):
        b = cpu.m[BUFFER + row * 40:BUFFER + row * 40 + 40]
        lines.append(''.join(rev.get(c & 0x7F, '?') for c in b[2:39]).rstrip())
    return lines


if __name__ == '__main__':
    sys.stdout.reconfigure(encoding='utf-8')
    mem = load(sys.argv[1])
    for n, line in enumerate(render(mem, int(sys.argv[2]))):
        print('%2d |%-37s|' % (n + 1, line))
