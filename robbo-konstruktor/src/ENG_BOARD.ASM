; ENG_BOARD.ASM - engine: board primitives - step, test, read / write a cell, score, frame wait
; $22D0-$23FC

         org $22D0


* step X one cell right; carry set if the cell is free -----
RT_
         inc  X                    ; 22D0
         jsr  TST_                 ; 22D2
         beq  L22DB                ; 22D5
         dec  X                    ; 22D7
         sec                       ; 22D9
         rts                       ; 22DA
L22DB
         dec  ADDR+1               ; 22DB
         dey                       ; 22DD
         lda  (ADDR),y             ; 22DE
         tax                       ; 22E0
         lda  #$20                 ; 22E1
         sta  (ADDR),y             ; 22E3
         iny                       ; 22E5
         inc  ADDR+1               ; 22E6
         txa                       ; 22E8
         ora  #$80                 ; 22E9
         sta  (ADDR),y             ; 22EB
         clc                       ; 22ED
         rts                       ; 22EE

* step X one cell left; carry set if the cell is free ------
LT_
         dec  X                    ; 22EF
         jsr  TST_                 ; 22F1
         beq  L22FA                ; 22F4
         inc  X                    ; 22F6
         sec                       ; 22F8
         rts                       ; 22F9
L22FA
         iny                       ; 22FA
         lda  (ADDR),y             ; 22FB
         tax                       ; 22FD
         lda  #$20                 ; 22FE
         sta  (ADDR),y             ; 2300
         dey                       ; 2302
         txa                       ; 2303
         sta  (ADDR),y             ; 2304
         clc                       ; 2306
         rts                       ; 2307

* step Y one cell down; carry set if the cell is free ------
DW_
         inc  Y                    ; 2308
         jsr  TST_                 ; 230A
         beq  L2313                ; 230D
         dec  Y                    ; 230F
         sec                       ; 2311
         rts                       ; 2312
L2313
         dec  ADDR+1               ; 2313
         ldy  #$F0                 ; 2315
         lda  (ADDR),y             ; 2317
         tax                       ; 2319
         lda  #$20                 ; 231A
         sta  (ADDR),y             ; 231C
         ldy  #$00                 ; 231E
         inc  ADDR+1               ; 2320
         txa                       ; 2322
         ora  #$80                 ; 2323
         sta  (ADDR),y             ; 2325
         clc                       ; 2327
         rts                       ; 2328

* step Y one cell up; carry set if the cell is free --------
UP_
         dec  Y                    ; 2329
         jsr  TST_                 ; 232B
         beq  L2334                ; 232E
         inc  Y                    ; 2330
         sec                       ; 2332
         rts                       ; 2333
L2334
         ldy  #$10                 ; 2334
         lda  (ADDR),y             ; 2336
         tax                       ; 2338
         lda  #$20                 ; 2339
         sta  (ADDR),y             ; 233B
         ldy  #$00                 ; 233D
         txa                       ; 233F
         sta  (ADDR),y             ; 2340
         clc                       ; 2342
         rts                       ; 2343

* step one cell in the direction LM: UP_ / DW_ / LT_ / RT_ through JMP1, carry set if blocked (Robbo FD_) ---
FD_
         lda  LM                   ; 2344
         ldx  #$FF                 ; 2346
L2348
         inx                       ; 2348
         lsr                       ; 2349
         bcs  L2348                ; 234A
         lda  $235B,x              ; 234C
         sta  $2359                ; 234F
         lda  $235F,x              ; 2352
         sta  $235A                ; 2355

* JMP to the step routine, operand from the tables $235B / $235F (Robbo JMP1, LMVT) ---
JMP1
         jmp  JMP1                 ; 2358
         dta $29,$08,$EF,$D0,$23,$23,$22,$22          ; 235B

* test the cell to the left --------------------------------
T_LT
         dec  X                    ; 2363
         jsr  TST_                 ; 2365
         inc  X                    ; 2368
         jmp  T_EX                 ; 236A

* test the cell to the right -------------------------------
T_RT
         inc  X                    ; 236D
         jsr  TST_                 ; 236F
         dec  X                    ; 2372
         jmp  T_EX                 ; 2374

* test the cell above --------------------------------------
T_UP
         dec  Y                    ; 2377
         jsr  TST_                 ; 2379
         inc  Y                    ; 237C
         jmp  T_EX                 ; 237E

* test the cell below --------------------------------------
T_DW
         inc  Y                    ; 2381
         jsr  TST_                 ; 2383
         dec  Y                    ; 2386

* properties of the tested cell from WHAT $32B1: bit 0 = a bullet destroys it, bit 1 = a bomb destroys it (Robbo T_EX) ---
T_EX
         tax                       ; 2388
         lda  $32B1,x              ; 2389
         rts                       ; 238C

* add points to the score (Robbo: "dodaj punkty") ----------
ASCO
         sed                       ; 238D
         clc                       ; 238E
         adc  SCOR+2               ; 238F
         sta  SCOR+2               ; 2391
         txa                       ; 2393
         adc  SCOR+1               ; 2394
         sta  SCOR+1               ; 2396
         lda  #$00                 ; 2398
         adc  SCOR                 ; 239A
         sta  SCOR                 ; 239C
         cld                       ; 239E
         rts                       ; 239F

* wait X frames (Robbo WAIT) -------------------------------
WAIT
         jsr  HALT                 ; 23A0
         dex                       ; 23A3
         bne  WAIT                 ; 23A4

* wait for the next frame (Robbo HALT) ---------------------
HALT
         lda  RTCLOK+2             ; 23A6
L23A8
         cmp  RTCLOK+2             ; 23A8
         beq  L23A8                ; 23AA
         rts                       ; 23AC

* read the board cell at X/Y -------------------------------
GET_
         lda  X                    ; 23AD
         ldy  Y                    ; 23AF
         ora  $23FD,y              ; 23B1
         sta  ADDR                 ; 23B4
         lda  $241D,y              ; 23B6
         sta  ADDR+1               ; 23B9
         ldy  #$00                 ; 23BB
         lda  (ADDR),y             ; 23BD
         pha                       ; 23BF
         lda  #$20                 ; 23C0
         sta  (ADDR),y             ; 23C2
         pla                       ; 23C4
         rts                       ; 23C5

* write object A to the board cell at X/Y ------------------
PUT_
         pha                       ; 23C6
         lda  X                    ; 23C7
         ldy  Y                    ; 23C9
         ora  $23FD,y              ; 23CB
         sta  ADDR                 ; 23CE
         lda  $241D,y              ; 23D0
         sta  ADDR+1               ; 23D3
         pla                       ; 23D5
         ldy  #$00                 ; 23D6
         sta  (ADDR),y             ; 23D8
         rts                       ; 23DA

* test the board cell --------------------------------------
TST_
         lda  X                    ; 23DB
         cmp  #$10                 ; 23DD
         bcs  TST_W                ; 23DF
         ldy  Y                    ; 23E1
         cpy  #$1F                 ; 23E3
         bcs  TST_W                ; 23E5
         ora  $23FD,y              ; 23E7
         sta  ADDR                 ; 23EA
         lda  $241D,y              ; 23EC
         sta  ADDR+1               ; 23EF
         ldy  #$00                 ; 23F1
         lda  (ADDR),y             ; 23F3
         and  #$7F                 ; 23F5
         cmp  #$20                 ; 23F7
         rts                       ; 23F9

* outside the board: answer $A0, a wall (Robbo TST_W) ------
TST_W
         lda  #$A0                 ; 23FA
         rts                       ; 23FC
