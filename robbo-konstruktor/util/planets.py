"""Loads the planet sets saved on the disk by running Robbo Konstruktor's own loader (IO_CMD with 'r') in the
emulator; OS disk calls are served from the ATR image. Writes each loaded set as a memory dump.

Usage (from robbo-konstruktor/): py -3 util/planets.py <disk.atr> game.bin <out_dir>
Output: <out_dir>/set<N>.bin (64 KB memory after loading slot N) and a summary on stdout."""
import sys, os
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
from atr import ATR
from emu import CPU

IO_CMD = 0x9000
PLANET_STATE = 0x39A0
PLANETS = 0x5000


def sio_from(atr, log):
    def sio(cpu):
        m = cpu.m
        cmd, sec = m[0x302], m[0x30A] | m[0x30B] << 8
        buf = m[0x304] | m[0x305] << 8
        log.append((chr(cmd), sec))
        if cmd == 0x52 and 1 <= sec <= atr.count:            # 'R' read sector
            m[buf:buf + atr.ssize] = atr.sector(sec)
        m[0x303] = 1                                           # DSTATS = OK
        cpu.y = 1; cpu.n = 0; cpu.z = 0
    return sio


def load_slot(atr, image, slot):
    cpu = CPU()
    cpu.m[:] = image
    cpu.portb = 0xFF
    cpu.m[PLANET_STATE:PLANET_STATE + 32] = bytes(32)
    log = []
    cpu.sio = sio_from(atr, log)
    cpu.a, cpu.x = ord('r'), slot
    result = cpu.call(IO_CMD, limit=20_000_000)
    return cpu, log, result


if __name__ == '__main__':
    atr = ATR(sys.argv[1])
    image = open(sys.argv[2], 'rb').read()
    out = sys.argv[3]
    os.makedirs(out, exist_ok=True)
    for slot in range(1, 6):
        cpu, log, result = load_slot(atr, image, slot)
        state = cpu.m[PLANET_STATE:PLANET_STATE + 32]
        used = [n for n in range(32) if state[n]]
        reads = sorted({s for c, s in log if c == 'R'})
        print('slot %d: %s, %d steps, sectors read %s, planets used: %s'
              % (slot, result, cpu.steps, reads, ' '.join('%d(%02X)' % (n, state[n]) for n in used) or '-'))
        open(os.path.join(out, 'set%d.bin' % slot), 'wb').write(cpu.m)
