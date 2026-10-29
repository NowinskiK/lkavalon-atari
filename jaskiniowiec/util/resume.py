import sys, os; sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from emu import CPU
from xex import M
cpu = CPU(); cpu.m[:] = open('mem.bin','rb').read(); cpu.portb = 0xFF
cpu.pc = 0x0480; cpu.sp = 0xFF
while True:
    op = cpu.m[cpu.pc]
    was_rti = M.get(op, ('',))[0] == 'RTI'
    cpu.step()
    if was_rti: break
print('resume PC=$%04X A=%02X X=%02X Y=%02X SP=%02X P=%02X PORTB=%02X steps=%d' % (cpu.pc, cpu.a, cpu.x, cpu.y, cpu.sp, cpu.p(), cpu.portb, cpu.steps))
open('game.bin','wb').write(cpu.m)
