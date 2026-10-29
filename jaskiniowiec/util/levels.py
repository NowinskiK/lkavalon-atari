"""Renders the 6 level maps and the title logo from game.bin to PNG files.

Usage (from jaskiniowiec/): py -3 util/levels.py game.bin img/levels [palette.act]

How the game displays a level (see NOTES.md sections 11-13):
- map: 10 rows x 256 tiles; tile byte b -> characters 2b and 2b+1 side by side ($8FC7);
- a tile is 2x2 characters: each map row is shown twice, the DLIs switch CHBASE between
  the font (top halves, first 1 KB) and font + $400 (bottom halves);
- ANTIC mode 4: 2 bits per pixel, value 3 uses PF3 instead of PF2 when character bit 7 is set;
- background: DLI colour table $935D for map rows 0-1 (first 4 scanlines of each half), black below.
A mode-4 pixel is drawn 2x1 (its aspect on screen). Colours: util/palette/XFormer.act."""
import sys, os, zlib, struct

HERE = os.path.dirname(os.path.abspath(__file__))
PALETTE = os.path.join(HERE, '..', '..', 'util', 'palette', 'XFormer.act')

FONT_A = (0x0800, (0xB6, 0xF4, 0xFA, 0x8C))   # $9221, colours $9A79
FONT_B = (0x1000, (0x76, 0xF4, 0x0C, 0x7E))   # $9239, colours $9B16
# level number -> map address (order from $935C and the level loaders)
LEVELS = {1: (0x3000, FONT_A), 2: (0x6200, FONT_B), 3: (0x3A00, FONT_A),
          4: (0x4E00, FONT_B), 5: (0x4400, FONT_A), 6: (0x5800, FONT_B)}
TRAINER = (0x6200, 0x646F)                    # over level 2 rows 0-2, zeroed before the game starts


def write_png(path, rows):
    w, h = len(rows[0]) // 3, len(rows)
    def chunk(t, d): return struct.pack('>I', len(d)) + t + d + struct.pack('>I', zlib.crc32(t + d) & 0xFFFFFFFF)
    raw = b''.join(b'\0' + bytes(r) for r in rows)
    open(path, 'wb').write(b'\x89PNG\r\n\x1a\n' + chunk(b'IHDR', struct.pack('>IIBBBBB', w, h, 8, 2, 0, 0, 0))
                           + chunk(b'IDAT', zlib.compress(raw, 9)) + chunk(b'IEND', b''))


def render_level(mem, rgb, mapb, font, pf):
    grad = mem[0x935D:0x936D]
    rows = []
    for my in range(10):
        for half in (0, 1):
            for line in range(8):
                bk = grad[my * 8 + half * 4 + min(line, 3)] if my < 2 else 0x00
                row = bytearray()
                for mx in range(256):
                    b = mem[mapb + my * 256 + mx]
                    for ch in ((b << 1) & 0xFF, ((b << 1) + 1) & 0xFF):
                        bits = mem[font + half * 0x400 + (ch & 0x7F) * 8 + line]
                        for p in range(4):
                            v = (bits >> (6 - 2 * p)) & 3
                            row += rgb[(bk, pf[0], pf[1], pf[3] if ch & 0x80 else pf[2])[v]] * 2
                rows.append(row)
    return rows


def render_logo(mem, rgb):
    cols = (0x76, 0x10, 0x24, 0x3A)            # COLOR4, COLOR0-2 from the init table ($929B)
    rows = []
    for y in range(28):                        # mode E, 40 bytes per line at $7100
        row = bytearray()
        for x in range(40):
            b = mem[0x7100 + y * 40 + x]
            for p in range(4):
                row += rgb[cols[(b >> (6 - 2 * p)) & 3]] * 2
        rows.append(row)
    return rows


def main():
    mem = bytearray(open(sys.argv[1], 'rb').read())
    out = sys.argv[2]
    pal = open(sys.argv[3] if len(sys.argv) > 3 else PALETTE, 'rb').read()
    rgb = [pal[c * 3:c * 3 + 3] for c in range(256)]
    mem[TRAINER[0]:TRAINER[1] + 1] = bytes(TRAINER[1] - TRAINER[0] + 1)
    os.makedirs(out, exist_ok=True)
    for lv, (mapb, (font, pf)) in LEVELS.items():
        write_png(os.path.join(out, 'level%d.png' % lv), render_level(mem, rgb, mapb, font, pf))
        print('level %d: map $%04X, font $%04X -> level%d.png' % (lv, mapb, font, lv))
    write_png(os.path.join(out, 'logo.png'), render_logo(mem, rgb))
    print('logo: $7100 -> logo.png')


if __name__ == '__main__':
    main()
