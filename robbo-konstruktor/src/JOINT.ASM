; JOINT.ASM - common labels

; Atari OS and hardware

RTCLOK   equ $0012
SAVMSC   equ $0058
VDSLST   equ $0200
CDTMV3   equ $021C
VVBLKI   equ $0222
VVBLKD   equ $0224
SDMCTL   equ $022F
SDLSTL   equ $0230
SDLSTH   equ $0231
COLDST   equ $0244
GPRIOR   equ $026F
STICK0   equ $0278
STRIG0   equ $0284
COLOR0   equ $02C4
COLOR1   equ $02C5
COLOR2   equ $02C6
COLOR3   equ $02C7
COLOR4   equ $02C8
RUNAD    equ $02E0
INITAD   equ $02E2
DVSTAT   equ $02EA
CRSINH   equ $02F0
CHBAS    equ $02F4
CH       equ $02FC
DDEVIC   equ $0300
DUNIT    equ $0301
DCOMND   equ $0302
DSTATS   equ $0303
DBUFLO   equ $0304
DBUFHI   equ $0305
DTIMLO   equ $0306
DBYTLO   equ $0308
DBYTHI   equ $0309
DAUX1    equ $030A
DAUX2    equ $030B
HPOSP0   equ $D000
HPOSP1   equ $D001
HPOSP2   equ $D002
HPOSP3   equ $D003
HPOSM0   equ $D004
SIZEP0   equ $D008
SIZEM    equ $D00C
TRIG0    equ $D010
COLPM0   equ $D012
COLPF0   equ $D016
COLPF1   equ $D017
COLPF2   equ $D018
COLPF3   equ $D019
COLBK    equ $D01A
PRIOR    equ $D01B
GRACTL   equ $D01D
HITCLR   equ $D01E
CONSOL   equ $D01F
AUDF1    equ $D200
AUDC1    equ $D201
AUDCTL   equ $D208
KBCODE   equ $D209
RANDOM   equ $D20A
IRQEN    equ $D20E
SKCTL    equ $D20F
PORTA    equ $D300
PORTB    equ $D301
DMACTL   equ $D400
DLISTL   equ $D402
DLISTH   equ $D403
PMBASE   equ $D407
CHBASE   equ $D409
WSYNC    equ $D40A
VCOUNT   equ $D40B
NMIEN    equ $D40E
NMIST    equ $D40F
DSKINV   equ $E453
CIOV     equ $E456
SIOV     equ $E459
SETVBV   equ $E45C
SYSVBV   equ $E45F
XITVBV   equ $E462
WARMSV   equ $E474
COLDSV   equ $E477

; game variables outside the .ASM blocks (the others are defined where they live)

; labels not at an instruction boundary or outside the source blocks

LF556      equ $F556
