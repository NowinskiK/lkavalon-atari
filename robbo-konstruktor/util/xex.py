import sys

# 6502 opcode table: opcode -> (mnemonic, mode)
M = {}
def op(code, mn, mode): M[code] = (mn, mode)
for mn, codes in {
 'ADC':{0x69:'imm',0x65:'zp',0x75:'zpx',0x6D:'abs',0x7D:'abx',0x79:'aby',0x61:'izx',0x71:'izy'},
 'AND':{0x29:'imm',0x25:'zp',0x35:'zpx',0x2D:'abs',0x3D:'abx',0x39:'aby',0x21:'izx',0x31:'izy'},
 'ASL':{0x0A:'acc',0x06:'zp',0x16:'zpx',0x0E:'abs',0x1E:'abx'},
 'BIT':{0x24:'zp',0x2C:'abs'},
 'BPL':{0x10:'rel'},'BMI':{0x30:'rel'},'BVC':{0x50:'rel'},'BVS':{0x70:'rel'},
 'BCC':{0x90:'rel'},'BCS':{0xB0:'rel'},'BNE':{0xD0:'rel'},'BEQ':{0xF0:'rel'},
 'BRK':{0x00:'imp'},
 'CMP':{0xC9:'imm',0xC5:'zp',0xD5:'zpx',0xCD:'abs',0xDD:'abx',0xD9:'aby',0xC1:'izx',0xD1:'izy'},
 'CPX':{0xE0:'imm',0xE4:'zp',0xEC:'abs'},'CPY':{0xC0:'imm',0xC4:'zp',0xCC:'abs'},
 'DEC':{0xC6:'zp',0xD6:'zpx',0xCE:'abs',0xDE:'abx'},
 'EOR':{0x49:'imm',0x45:'zp',0x55:'zpx',0x4D:'abs',0x5D:'abx',0x59:'aby',0x41:'izx',0x51:'izy'},
 'CLC':{0x18:'imp'},'SEC':{0x38:'imp'},'CLI':{0x58:'imp'},'SEI':{0x78:'imp'},
 'CLV':{0xB8:'imp'},'CLD':{0xD8:'imp'},'SED':{0xF8:'imp'},
 'INC':{0xE6:'zp',0xF6:'zpx',0xEE:'abs',0xFE:'abx'},
 'JMP':{0x4C:'abs',0x6C:'ind'},'JSR':{0x20:'abs'},
 'LDA':{0xA9:'imm',0xA5:'zp',0xB5:'zpx',0xAD:'abs',0xBD:'abx',0xB9:'aby',0xA1:'izx',0xB1:'izy'},
 'LDX':{0xA2:'imm',0xA6:'zp',0xB6:'zpy',0xAE:'abs',0xBE:'aby'},
 'LDY':{0xA0:'imm',0xA4:'zp',0xB4:'zpx',0xAC:'abs',0xBC:'abx'},
 'LSR':{0x4A:'acc',0x46:'zp',0x56:'zpx',0x4E:'abs',0x5E:'abx'},
 'NOP':{0xEA:'imp'},
 'ORA':{0x09:'imm',0x05:'zp',0x15:'zpx',0x0D:'abs',0x1D:'abx',0x19:'aby',0x01:'izx',0x11:'izy'},
 'TAX':{0xAA:'imp'},'TXA':{0x8A:'imp'},'DEX':{0xCA:'imp'},'INX':{0xE8:'imp'},
 'TAY':{0xA8:'imp'},'TYA':{0x98:'imp'},'DEY':{0x88:'imp'},'INY':{0xC8:'imp'},
 'ROL':{0x2A:'acc',0x26:'zp',0x36:'zpx',0x2E:'abs',0x3E:'abx'},
 'ROR':{0x6A:'acc',0x66:'zp',0x76:'zpx',0x6E:'abs',0x7E:'abx'},
 'RTI':{0x40:'imp'},'RTS':{0x60:'imp'},
 'SBC':{0xE9:'imm',0xE5:'zp',0xF5:'zpx',0xED:'abs',0xFD:'abx',0xF9:'aby',0xE1:'izx',0xF1:'izy'},
 'STA':{0x85:'zp',0x95:'zpx',0x8D:'abs',0x9D:'abx',0x99:'aby',0x81:'izx',0x91:'izy'},
 'STX':{0x86:'zp',0x96:'zpy',0x8E:'abs'},'STY':{0x84:'zp',0x94:'zpx',0x8C:'abs'},
 'TXS':{0x9A:'imp'},'TSX':{0xBA:'imp'},'PHA':{0x48:'imp'},'PLA':{0x68:'imp'},
 'PHP':{0x08:'imp'},'PLP':{0x28:'imp'},
}.items():
    for c, m in codes.items(): op(c, mn, m)
SZ = {'imp':1,'acc':1,'imm':2,'zp':2,'zpx':2,'zpy':2,'izx':2,'izy':2,'rel':2,'abs':3,'abx':3,'aby':3,'ind':3}

# Common Atari OS / hardware labels
L = {0x02E0:'RUNAD',0x02E2:'INITAD',0x0230:'SDLSTL',0x0231:'SDLSTH',0x022F:'SDMCTL',0x0200:'VDSLST',
     0x0222:'VVBLKI',0x0224:'VVBLKD',0x02C4:'COLOR0',0x02C5:'COLOR1',0x02C6:'COLOR2',0x02C7:'COLOR3',
     0x02C8:'COLOR4',0x02F4:'CHBAS',0x02FC:'CH',0x0278:'STICK0',0x0284:'STRIG0',0x0244:'COLDST',
     0x026F:'GPRIOR',0x02F0:'CRSINH',0x0014:'RTCLOK+2',0x0012:'RTCLOK',0x0058:'SAVMSC',
     0xD000:'HPOSP0',0xD001:'HPOSP1',0xD002:'HPOSP2',0xD003:'HPOSP3',0xD004:'HPOSM0',
     0xD008:'SIZEP0',0xD00C:'SIZEM',0xD010:'TRIG0',0xD012:'COLPM0',0xD016:'COLPF0',0xD017:'COLPF1',
     0xD018:'COLPF2',0xD019:'COLPF3',0xD01A:'COLBK',0xD01B:'PRIOR',0xD01D:'GRACTL',0xD01E:'HITCLR',
     0xD01F:'CONSOL',0xD200:'AUDF1',0xD201:'AUDC1',0xD208:'AUDCTL',0xD209:'KBCODE',0xD20A:'RANDOM',
     0xD20E:'IRQEN',0xD20F:'SKCTL',0xD300:'PORTA',0xD301:'PORTB',0xD400:'DMACTL',0xD402:'DLISTL',
     0xD403:'DLISTH',0xD407:'PMBASE',0xD409:'CHBASE',0xD40A:'WSYNC',0xD40B:'VCOUNT',0xD40E:'NMIEN',
     0xD40F:'NMIST',0xE459:'SIOV',0xE45C:'SETVBV',0xE45F:'SYSVBV',0xE462:'XITVBV',0xE456:'CIOV',
     0xE474:'WARMSV',0xE453:'DSKINV',0x021C:'CDTMV3',0x0300:'DDEVIC',0x0301:'DUNIT',0x0302:'DCOMND',0x0303:'DSTATS',0x0304:'DBUFLO',0x0305:'DBUFHI',0x0306:'DTIMLO',0x0308:'DBYTLO',0x0309:'DBYTHI',0x030A:'DAUX1',0x030B:'DAUX2',0x02EA:'DVSTAT',0xE477:'COLDSV',
     0x0011:'BRKKEY',0x004D:'ATRACT',0x021E:'CDTMV4',0x021F:'CDTMV4+1',0x02C0:'PCOLR0',0x02C3:'PCOLR3',
     0x02D9:'KRPDEL',0x02DA:'KEYREP',0x02E3:'INITAD+1',0xD009:'SIZEP1',0xD00E:'GRAFP1',0xD011:'TRIG1',
     0xD013:'COLPM1',0xD014:'COLPM2',0xD015:'COLPM3',0xD405:'VSCROL'}

def name(a, width):
    if a in L: return L[a]
    return ('$%02X' % a) if width == 1 else ('$%04X' % a)

def dis(data, base, start=0, end=None):
    out = []
    i = start
    end = len(data) if end is None else end
    while i < end:
        b = data[i]; a = base + i
        if b not in M or i + SZ[M[b][1]] > end:
            out.append('%04X  %02X        .byte $%02X' % (a, b, b)); i += 1; continue
        mn, mode = M[b]; n = SZ[mode]; raw = data[i:i+n]
        v = raw[1] if n == 2 else (raw[1] | raw[2] << 8 if n == 3 else 0)
        o = {'imp':'','acc':'A','imm':'#$%02X' % v,'zp':name(v,1),'zpx':name(v,1)+',X','zpy':name(v,1)+',Y',
             'izx':'(%s,X)' % name(v,1),'izy':'(%s),Y' % name(v,1),
             'rel':'$%04X' % ((a + 2 + (v - 256 if v > 127 else v)) & 0xFFFF),
             'abs':name(v,2),'abx':name(v,2)+',X','aby':name(v,2)+',Y','ind':'(%s)' % name(v,2)}[mode]
        out.append('%04X  %-8s  %s %s' % (a, ' '.join('%02X' % x for x in raw), mn, o))
        i += n
    return out

def segments(buf):
    i = 0; segs = []
    while i + 4 <= len(buf):
        s = buf[i] | buf[i+1] << 8
        if s == 0xFFFF: i += 2; continue
        e = buf[i+2] | buf[i+3] << 8
        i += 4
        segs.append((s, e, buf[i:i+e-s+1], i)); i += e - s + 1
    return segs

if __name__ == '__main__':
    buf = open(sys.argv[1], 'rb').read()
    for n, (s, e, d, off) in enumerate(segments(buf)):
        note = ''
        if s == 0x02E0: note = ' RUNAD -> $%04X' % (d[0] | d[1] << 8)
        if s == 0x02E2: note = ' INITAD -> $%04X' % (d[0] | d[1] << 8)
        print('#%-2d file@%05X  $%04X-$%04X  len %5d%s' % (n, off, s, e, len(d), note))
