; JOINT.ASM - common labels

; Atari OS and hardware

RTCLOK   equ $0012
SAVMSC   equ $0058
VDSLST   equ $0200
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
CRSINH   equ $02F0
CHBAS    equ $02F4
CH       equ $02FC
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
CIOV     equ $E456
SIOV     equ $E459
SETVBV   equ $E45C
SYSVBV   equ $E45F
XITVBV   equ $E462
WARMSV   equ $E474
COLDSV   equ $E477

; game variables outside the .ASM blocks (the others are defined where they live)

* zero page - display -----------
FRAME          equ $0080  ; frame counter; bit 0 selects screen/font/DL buffer ($882C)
FONT_PAGE      equ $0083  ; CHBASE of the visible level font ($D8 / $E0), set by the DLIs
SPR_LIST       equ $0084  ; +01 pointer to the sprite list of the drawn buffer ($C400 / $C480)
COL_BK         equ $0086  ; background colour above the playfield (DLI $8874)
COL_PF         equ $0087  ; +03 playfield colours PF0-PF3 (DLI $8874); faded towards TARGET_COLS
DLI_ROW        equ $00A4  ; map row counter of the DLI chain

* zero page - game --------------
MAP_PTR        equ $008B  ; +01 pointer into the level map ($912F)
COUNTER        equ $008D  ; loop counter (screen scroll steps, $8F52)
NEXT_TICK      equ $008E  ; RTCLOK value of the next game frame (main loop runs every 3rd frame)
CAVE_FLAG      equ $008F  ; non-zero: enter the cave room ($94F7)
ENERGY         equ $00A5  ; energy, $60 when full; 0 costs a life ($9802)
FOOD           equ $00A6  ; food collected ("JEDZENIE"), 32 needed to finish a level
LIVES          equ $00A7  ; lives ("ZYCIA"), 3 at start
MUSIC_OFF      equ $00A9  ; non-zero: music and sound effects off (OPTION toggles, $8A64)
PROT_FLAG      equ $00DF  ; copy-protection flag: bit 7 clear destroys $84E9 ($8820)

* status line (screen memory) ---
BAR_FOOD       equ $A0DF  ; +0F food bar, half a character per unit
LIVES_DIGIT    equ $A104  ; lives digit
BAR_ENERGY     equ $A107  ; +17 energy bar, a quarter character per unit

* text screens ------------------
DIGIT_DONE     equ $7788  ; level digit in "etap N kompletny" (next-level page 1)
DIGIT_NEXT     equ $7879  ; level digit in "powodzenia w etapie N" (next-level page 2)
