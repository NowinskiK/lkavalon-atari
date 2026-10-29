"""Builds the memory image at program start: boot sectors 1-3 at $0500 (the boot loader stays in memory)
plus all segments of the binary file loaded from the sector chain. The file has no INIT segments and is
not packed, so nothing has to run before RUNAD ($A810).

Usage (from robbo-konstruktor/): py -3 util/image.py <disk.atr> game.bin"""
import sys, os
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
from atr import ATR
from xex import segments

atr = ATR(sys.argv[1])
mem = bytearray(65536)
boot = b''.join(atr.sector(n) for n in (1, 2, 3))
mem[0x0500:0x0500 + len(boot)] = boot
data, _ = atr.chain(4)
for st, en, seg, _ in segments(data):
    mem[st:en + 1] = seg
    print('$%04X-$%04X' % (st, en))
open(sys.argv[2], 'wb').write(mem)
print('RUNAD $%04X -> %s' % (mem[0x2E0] | mem[0x2E1] << 8, sys.argv[2]))
