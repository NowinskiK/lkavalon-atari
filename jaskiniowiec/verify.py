"""Loads a segment file (MADS or asm.py output) into an empty 64K memory and compares it with game.bin.
Usage: py -3 verify.py bin/game.obx [game.bin]"""
import sys
sys.path.insert(0, '.')
from xex import segments

mem = bytearray(65536)
for st, en, data, _ in segments(open(sys.argv[1], 'rb').read()):
    mem[st:en + 1] = data
ref = open(sys.argv[2] if len(sys.argv) > 2 else 'game.bin', 'rb').read()
diff = [a for a in range(65536) if mem[a] != ref[a]]
if diff:
    print('DIFFERENT: %d bytes, first at $%04X (built $%02X, expected $%02X)' % (len(diff), diff[0], mem[diff[0]], ref[diff[0]]))
    sys.exit(1)
print('OK: %s matches game.bin byte for byte' % sys.argv[1])
