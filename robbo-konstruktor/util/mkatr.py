"""Writes a build back into a copy of the original disk, so it can be booted in an emulator.

The build (bin/game.obx) is a memory image in segments, not a loadable file. This tool takes the original disk,
replaces the boot sectors 1-3 with the build's $0500-$067F and the data of every segment of the program file
(sector chain from 4) with the build's bytes at the same addresses. Headers, sector links and all other sectors
(the saved planet sets) stay as they are, so a byte-exact build gives a disk whose data equals the original.
The copy is made writable (the original image is marked write-protected in its ATR header, byte 15 = $01; a
working copy must accept saved planet sets). Saving also needs an XL/XE OS in the emulator: under the 400/800
OS-B the program's "P" write command is sent as a read and fails with error 139 (NOTES.md section 26). If the copy already exists, it is updated in place: only the boot
sectors and the program file are rewritten, so planet sets saved on it survive a rebuild; delete it to start again
from the original. The segment layout must not change: code that grows past a segment end needs a new file layout.

Usage (from robbo-konstruktor/):
  py -3 util/mkatr.py bin/game.obx "bin/Robbo Konstruktor (1990)(L.K. Avalon)(PL).atr" bin/build.atr"""
import sys, os
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
from atr import ATR
from xex import segments

obx, src, out = sys.argv[1:4]
mem = bytearray(65536)
for st, en, data, _ in segments(open(obx, 'rb').read()):
    mem[st:en + 1] = data

atr = ATR(src)
# an existing copy is updated in place, so planet sets saved on it survive a rebuild (delete it to start afresh)
keep = os.path.exists(out) and os.path.getsize(out) == os.path.getsize(src)
disk = bytearray(open(out if keep else src, 'rb').read())
sec = lambda n: 16 + (n - 1) * atr.ssize            # offset of sector n in the .atr file

# boot sectors 1-3 are loaded at $0500
for i, n in enumerate((1, 2, 3)):
    disk[sec(n):sec(n) + atr.ssize] = mem[0x0500 + i * atr.ssize:0x0500 + (i + 1) * atr.ssize]

# the program file: patch the segment data, then put it back along the same sector chain
data, secs = atr.chain(4)
new = bytearray(data)
for st, en, seg, off in segments(data):
    new[off:off + en - st + 1] = mem[st:en + 1]
pos = 0
for n in secs:
    count = atr.sector(n)[127]
    disk[sec(n):sec(n) + count] = new[pos:pos + count]
    pos += count
assert pos == len(new)

# the original image is marked write-protected (ATR header byte 15 = $01, Atari800's "writeprotect"); the copy is
# meant to be used, saving planet sets included, so it is made writable
protected = disk[15]
disk[15] = 0

open(out, 'wb').write(disk)
same = disk[16:] == open(src, 'rb').read()[16:]
print('%s: %d sectors of the program file written%s%s%s' % (out, len(secs) + 3,
      ' into the existing copy (other sectors, e.g. saved planet sets, kept)' if keep else '',
      ', data identical to the original' if same else '',
      ', write protection removed (header byte 15 was $%02X)' % protected if protected else ''))
