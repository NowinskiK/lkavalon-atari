"""ATR disk image reader: header, boot record, used sectors, and DOS 2-style sector chains.

Usage (from robbo-konstruktor/):
  py -3 util/atr.py <disk.atr>                      info: header, boot record, used sector runs
  py -3 util/atr.py <disk.atr> chain <first> <out>  follow a sector chain from <first>, write its data to <out>

Sector chain format (DOS 2, 128-byte sectors): bytes 0-124 data, byte 125 = file number << 2 | next sector
bits 8-9, byte 126 = next sector bits 0-7, byte 127 = number of data bytes. Next sector 0 = end of file."""
import sys, struct


class ATR:
    def __init__(s, path):
        d = open(path, 'rb').read()
        magic, par, s.ssize, parh = struct.unpack('<HHHB', d[:7])
        assert magic == 0x0296, 'not an ATR image'
        s.size = (par | parh << 16) * 16
        s.data = d[16:16 + s.size]
        s.count = s.size // s.ssize

    def sector(s, n):
        return s.data[(n - 1) * s.ssize:n * s.ssize]

    def used_runs(s):
        runs, cur = [], None
        for n in range(1, s.count + 1):
            u = any(s.sector(n))
            if u and cur is None: cur = n
            if not u and cur is not None: runs.append((cur, n - 1)); cur = None
        if cur is not None: runs.append((cur, s.count))
        return runs

    def chain(s, first):
        """Follow a DOS 2-style chain; returns (data, list of sectors)."""
        out, secs, n = bytearray(), [], first
        while n:
            assert n not in secs, 'loop in sector chain at %d' % n
            b = s.sector(n)
            secs.append(n)
            out += b[:b[127]]
            n = (b[125] & 3) << 8 | b[126]
        return bytes(out), secs


def runs_text(secs):
    runs = []
    for n in secs:
        if runs and runs[-1][1] == n - 1: runs[-1][1] = n
        else: runs.append([n, n])
    return ' '.join('%d-%d' % (a, b) if a != b else '%d' % a for a, b in runs)


if __name__ == '__main__':
    atr = ATR(sys.argv[1])
    if len(sys.argv) == 2:
        b = atr.sector(1)
        print('sectors %d x %d bytes' % (atr.count, atr.ssize))
        print('boot record: flags $%02X, %d sectors, load $%04X, init $%04X'
              % (b[0], b[1], b[2] | b[3] << 8, b[4] | b[5] << 8))
        print('used sectors:', ' '.join('%d-%d' % r if r[0] != r[1] else '%d' % r[0] for r in atr.used_runs()))
    elif sys.argv[2] == 'chain':
        data, secs = atr.chain(int(sys.argv[3]))
        open(sys.argv[4], 'wb').write(data)
        print('chain from %d: %d sectors (%s), %d bytes -> %s'
              % (int(sys.argv[3]), len(secs), runs_text(secs), len(data), sys.argv[4]))
