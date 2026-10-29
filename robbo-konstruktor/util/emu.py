"""Minimal 6502 emulator that runs an Atari XEX load sequence (INIT/RUN vectors)
and dumps memory once the program reaches a given stop address."""
import sys, os
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from xex import M, SZ, segments

class CPU:
    def __init__(s):
        s.m = bytearray(65536); s.a = s.x = s.y = 0; s.sp = 0xFF; s.pc = 0
        s.c = s.z = s.i = s.d = s.v = s.n = 0
        s.clock = 0; s.consol = 0; s.portb = 0xFF; s.steps = 0
        s.os = bytearray(65536)  # what lives under the ROM / hardware (RAM shadow)
        s.sio = None             # optional: function(cpu) for OS disk calls (DSKINV $E453 / SIOV $E459)
    # --- memory with simple Atari hardware stubs
    def rd(s, a):
        if a == 0x14:
            s.clock = (s.clock + 1) & 0xFF; return s.clock
        if a == 0xD01F:  # CONSOL: alternate START pressed / released
            s.consol ^= 1; return 6 if s.consol else 7
        if a == 0xD40B: return (s.steps >> 2) % 131    # VCOUNT: reaches every line value (0-130)
        if a == 0xD20A: return (s.steps * 73) & 0xFF  # RANDOM
        if a == 0xD301: return s.portb
        if 0xD000 <= a < 0xD800: return 0
        return s.m[a]
    def wr(s, a, v):
        if a == 0xD301: s.portb = v; return
        if 0xD000 <= a < 0xD800: return
        s.m[a] = v
    def push(s, v): s.m[0x100 + s.sp] = v; s.sp = (s.sp - 1) & 0xFF
    def pop(s): s.sp = (s.sp + 1) & 0xFF; return s.m[0x100 + s.sp]
    def nz(s, v): s.z = int(v == 0); s.n = v >> 7; return v
    def p(s): return s.n << 7 | s.v << 6 | 0x30 | s.d << 3 | s.i << 2 | s.z << 1 | s.c
    def setp(s, v): s.n, s.v, s.d, s.i, s.z, s.c = v >> 7 & 1, v >> 6 & 1, v >> 3 & 1, v >> 2 & 1, v >> 1 & 1, v & 1

    def addr(s, mode, pc):
        m = s.m
        b1 = m[(pc + 1) & 0xFFFF]; w = b1 | m[(pc + 2) & 0xFFFF] << 8
        if mode == 'zp': return b1
        if mode == 'zpx': return (b1 + s.x) & 0xFF
        if mode == 'zpy': return (b1 + s.y) & 0xFF
        if mode == 'abs': return w
        if mode == 'abx': return (w + s.x) & 0xFFFF
        if mode == 'aby': return (w + s.y) & 0xFFFF
        if mode == 'izx': t = (b1 + s.x) & 0xFF; return m[t] | m[(t + 1) & 0xFF] << 8
        if mode == 'izy': return ((m[b1] | m[(b1 + 1) & 0xFF] << 8) + s.y) & 0xFFFF
        if mode == 'ind': return m[w] | m[(w & 0xFF00) | ((w + 1) & 0xFF)] << 8
        raise ValueError(mode)

    def step(s):
        s.steps += 1
        pc = s.pc; o = s.m[pc]
        if o not in M: raise RuntimeError('illegal opcode %02X at %04X' % (o, pc))
        mn, mode = M[o]; n = SZ[mode]; s.pc = (pc + n) & 0xFFFF
        if mode == 'imm': val = lambda: s.m[(pc + 1) & 0xFFFF]
        elif mode == 'acc': val = lambda: s.a
        elif mode in ('imp', 'rel'): val = None
        else:
            ea = s.addr(mode, pc); val = lambda: s.rd(ea)
        def store(v):
            if mode == 'acc': s.a = v
            else: s.wr(ea, v)
        if mn == 'LDA': s.a = s.nz(val())
        elif mn == 'LDX': s.x = s.nz(val())
        elif mn == 'LDY': s.y = s.nz(val())
        elif mn == 'STA': s.wr(ea, s.a)
        elif mn == 'STX': s.wr(ea, s.x)
        elif mn == 'STY': s.wr(ea, s.y)
        elif mn in ('ADC', 'SBC'):
            v = val()
            if mn == 'SBC': v ^= 0xFF
            r = s.a + v + s.c
            s.v = int(((s.a ^ r) & (v ^ r) & 0x80) != 0); s.c = r >> 8; s.a = s.nz(r & 0xFF)
        elif mn == 'AND': s.a = s.nz(s.a & val())
        elif mn == 'ORA': s.a = s.nz(s.a | val())
        elif mn == 'EOR': s.a = s.nz(s.a ^ val())
        elif mn in ('CMP', 'CPX', 'CPY'):
            r = {'CMP': s.a, 'CPX': s.x, 'CPY': s.y}[mn] - val()
            s.c = int(r >= 0); s.nz(r & 0xFF)
        elif mn == 'BIT':
            v = val(); s.z = int((s.a & v) == 0); s.n = v >> 7; s.v = v >> 6 & 1
        elif mn in ('ASL', 'LSR', 'ROL', 'ROR'):
            v = val()
            if mn == 'ASL': s.c = v >> 7; v = (v << 1) & 0xFF
            elif mn == 'LSR': s.c = v & 1; v >>= 1
            elif mn == 'ROL': c = s.c; s.c = v >> 7; v = ((v << 1) | c) & 0xFF
            else: c = s.c; s.c = v & 1; v = (v >> 1) | (c << 7)
            store(s.nz(v))
        elif mn == 'INC': s.wr(ea, s.nz((val() + 1) & 0xFF))
        elif mn == 'DEC': s.wr(ea, s.nz((val() - 1) & 0xFF))
        elif mn == 'INX': s.x = s.nz((s.x + 1) & 0xFF)
        elif mn == 'INY': s.y = s.nz((s.y + 1) & 0xFF)
        elif mn == 'DEX': s.x = s.nz((s.x - 1) & 0xFF)
        elif mn == 'DEY': s.y = s.nz((s.y - 1) & 0xFF)
        elif mn == 'TAX': s.x = s.nz(s.a)
        elif mn == 'TAY': s.y = s.nz(s.a)
        elif mn == 'TXA': s.a = s.nz(s.x)
        elif mn == 'TYA': s.a = s.nz(s.y)
        elif mn == 'TSX': s.x = s.nz(s.sp)
        elif mn == 'TXS': s.sp = s.x
        elif mn == 'PHA': s.push(s.a)
        elif mn == 'PLA': s.a = s.nz(s.pop())
        elif mn == 'PHP': s.push(s.p())
        elif mn == 'PLP': s.setp(s.pop())
        elif mn == 'JMP': s.pc = ea
        elif mn == 'JSR':
            r = (pc + 2) & 0xFFFF; s.push(r >> 8); s.push(r & 0xFF); s.pc = ea
        elif mn == 'RTS': s.pc = ((s.pop() | s.pop() << 8) + 1) & 0xFFFF
        elif mn == 'RTI': s.setp(s.pop()); s.pc = s.pop() | s.pop() << 8
        elif mode == 'rel':
            cond = {'BPL': not s.n, 'BMI': s.n, 'BVC': not s.v, 'BVS': s.v,
                    'BCC': not s.c, 'BCS': s.c, 'BNE': not s.z, 'BEQ': s.z}[mn]
            if cond:
                d = s.m[(pc + 1) & 0xFFFF]; s.pc = (s.pc + (d - 256 if d > 127 else d)) & 0xFFFF
        elif mn == 'CLC': s.c = 0
        elif mn == 'SEC': s.c = 1
        elif mn == 'CLI': s.i = 0
        elif mn == 'SEI': s.i = 1
        elif mn == 'CLD': s.d = 0
        elif mn == 'SED': s.d = 1
        elif mn == 'CLV': s.v = 0
        elif mn == 'NOP': pass
        elif mn == 'BRK': raise RuntimeError('BRK at %04X' % pc)
        if s.d and mn in ('ADC', 'SBC'): print('warning: decimal mode at %04X' % pc)

    def call(s, addr, stop=None, limit=50_000_000):
        """Run a subroutine until it returns (or PC hits `stop`)."""
        s.sp = 0xFF; s.push(0xFF); s.push(0xFE)  # return to $FFFF sentinel
        s.pc = addr
        while s.steps < limit:
            if s.pc == stop: return 'stop'
            if s.pc == 0xFFFF and s.sp == 0xFF: return 'rts'
            if s.sio and s.pc in (0xE453, 0xE459):   # OS disk call: let the stub do the SIO request
                s.sio(s)
                s.pc = ((s.pop() | s.pop() << 8) + 1) & 0xFFFF; continue
            # calls into OS ROM while OS is enabled: treat as no-op RTS
            if s.pc >= 0xC000 and (s.portb & 1) and not (0xD000 <= s.pc < 0xD800):
                s.pc = ((s.pop() | s.pop() << 8) + 1) & 0xFFFF; continue
            s.step()
        raise RuntimeError('step limit, PC=%04X' % s.pc)

if __name__ == '__main__':
    path, stop, out = sys.argv[1], int(sys.argv[2], 16), sys.argv[3]
    cpu = CPU()
    segs = segments(open(path, 'rb').read())
    for n, (st, en, data, _) in enumerate(segs):
        cpu.m[0x2E2] = cpu.m[0x2E3] = 0
        cpu.m[st:st + len(data)] = data
        init = cpu.m[0x2E2] | cpu.m[0x2E3] << 8
        if st <= 0x2E3 and en >= 0x2E2 and init:
            r = cpu.call(init, stop)
            print('#%d INIT $%04X -> %s (steps %d)' % (n, init, r, cpu.steps))
            if r == 'stop': break
    else:
        run = cpu.m[0x2E0] | cpu.m[0x2E1] << 8
        r = cpu.call(run, stop)
        print('RUN $%04X -> %s (steps %d)' % (run, r, cpu.steps))
    open(out, 'wb').write(cpu.m)
    print('memory dumped to', out)
