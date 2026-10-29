"""Renders Robbo Konstruktor graphics the way the editor draws them (NOTES.md sections 10-12):
a cell holding element code c uses glyph g = $B55A[(c & $7F) - $20 (wrapping)]; it is drawn as 2 x 2 characters
2g, 2g+1 in ANTIC mode 4 - top line from the font at $4000, bottom line from $4400 (the editor DLI switches CHBASE
$40 / $44); a character with bit 7 uses PF3 instead of PF2. Colours from the planet header (bytes 2-6 = PF0-PF3,
background), RGB from util/palette/XFormer.act.

Usage (from robbo-konstruktor/):
  py -3 util/render.py palette game.bin out.png              all palette entries with code and name
  py -3 util/render.py planet <memory.bin> <n> out.png       planet n from a memory image (e.g. util/planets.py)"""
import sys, os, zlib, struct
HERE = os.path.dirname(os.path.abspath(__file__))
PALETTE = os.path.join(HERE, '..', '..', 'util', 'palette', 'XFormer.act')
GLYPHS, FONT_TOP, FONT_BOTTOM, PAL_CODES = 0xB55A, 0x4000, 0x4400, 0xB51C
NAMES_MSG = 0xA318          # messages; element names start at message $1E


def write_png(path, rows):
    w, h = len(rows[0]) // 3, len(rows)
    def chunk(t, d): return struct.pack('>I', len(d)) + t + d + struct.pack('>I', zlib.crc32(t + d) & 0xFFFFFFFF)
    raw = b''.join(b'\0' + bytes(r) for r in rows)
    open(path, 'wb').write(b'\x89PNG\r\n\x1a\n' + chunk(b'IHDR', struct.pack('>IIBBBBB', w, h, 8, 2, 0, 0, 0))
                           + chunk(b'IDAT', zlib.compress(raw, 9)) + chunk(b'IEND', b''))


def glyph(mem, code):
    i = (code & 0x7F) - 0x20
    return mem[GLYPHS + (i + 0x60 if i < 0 else i)]


def cell_rows(mem, code, cols, rgb, sx=2):
    """16 pixel rows of one cell (8 mode-4 pixels wide, each sx output pixels)."""
    g = glyph(mem, code)
    c0 = ((g << 1) & 0x7F) | (g & 0x80)
    out = []
    for font in (FONT_TOP, FONT_BOTTOM):
        for line in range(8):
            row = bytearray()
            for ch in (c0, c0 | 1):
                bits = mem[font + (ch & 0x7F) * 8 + line]
                for p in range(4):
                    v = (bits >> (6 - 2 * p)) & 3
                    c = (cols[4], cols[0], cols[1], cols[3] if ch & 0x80 else cols[2])[v]
                    row += rgb[c] * sx
            out.append(row)
    return out


def colours(header):
    return header[2:7]          # PF0, PF1, PF2, PF3, background


def load_rgb():
    pal = open(PALETTE, 'rb').read()
    return [pal[c * 3:c * 3 + 3] for c in range(256)]


def render_planet(mem, n, path):
    base = 0x5000 + n * 0x200
    cols, rgb = colours(mem[base + 0x1F0:base + 0x1F8]), load_rgb()
    rows = []
    for r in range(31):
        cells = [cell_rows(mem, mem[base + r * 16 + c], cols, rgb) for c in range(16)]
        rows += [b''.join(cell[i] for cell in cells) for i in range(16)]
    write_png(path, rows)


def element_names(mem):
    names, a = [], NAMES_MSG
    for _ in range(0x1E + 28):
        s = a
        while mem[a]: a += 1
        names.append(bytes(mem[s:a])); a += 1
    return names[0x1E:]


def render_palette(mem, path):
    """One row per palette entry: the cell, scaled x2, on the default colours. Names go to stdout."""
    cols, rgb = mem[0x9F83 + 2:0x9F83 + 7], load_rgb()
    rows = []
    for i in range(32):
        cell = cell_rows(mem, mem[PAL_CODES + i], cols, rgb, sx=4)
        for line in cell:
            rows += [line + rgb[cols[4]] * 8] * 2      # double height to keep the aspect
        rows += [rgb[0x0E] * (len(cell[0]) // 3 + 8)] * 2   # separator
    write_png(path, rows)


if __name__ == '__main__':
    sys.stdout.reconfigure(encoding='utf-8')          # element names contain Polish letters
    mode = sys.argv[1]
    mem = open(sys.argv[2], 'rb').read()
    if mode == 'palette':
        render_palette(mem, sys.argv[3])
        pl = {1: 'ą', 3: 'ć', 5: 'ę', 0x0C: 'ł', 0x0E: 'ń', 0x0F: 'ó', 0x13: 'ś', 0x1A: 'ż'}
        names = element_names(mem)
        for i in range(32):
            code = mem[PAL_CODES + i]
            nm = ''.join(pl.get(b & 0x7F, chr(b & 0x7F)) for b in names[min(i, 27)])
            print('%2d  code $%02X  glyph $%02X  %s' % (i, code, glyph(mem, code), nm))
    else:
        render_planet(mem, int(sys.argv[3]), sys.argv[4])
