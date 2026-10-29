; ENG_SCRN.ASM - engine: CHNMON - BREAK test, Robbo's step, animated shapes, board to screen
; $243D-$2581

         org $243D


* redraw (Robbo CHNMON, reworked): BREAK back to the editor, FAC_STEP, ANIM, board to the screen with DRAW_ROW ---
CHNMON
         ldx  BRKKEY               ; 243D
         bmi  L2444                ; 243F
         jmp  PLAY_ABORT           ; 2441
L2444
         jsr  KEJO                 ; 2444
         jsr  FAC_STEP             ; 2447
         jsr  ANIM                 ; 244A
         lda  #$70                 ; 244D
         sta  ROW_JMP+1            ; 244F
         lda  #$24                 ; 2452
         sta  ROW_JMP+2            ; 2454
         lda  #$1E                 ; 2457
         sta  SCRA                 ; 2459
         lda  #$B6                 ; 245B
         sta  SCRA+1               ; 245D
         lda  #$00                 ; 245F
         sta  ROW_CELL+1           ; 2461
         lda  #$BE                 ; 2464
         sta  ROW_CELL+2           ; 2466
         lda  #$20                 ; 2469
         sta  ADDR                 ; 246B
ROW_JMP
         jmp  ROW_JMP              ; 246D

* CHNMON: draw one board row as 2 x 2 characters (target of the self-modified JMP $246D, waits a frame at the visible window) ---
DRAW_ROW
         clc                       ; 2470
         lda  SCRA                 ; 2471
         adc  #$BF                 ; 2473
         ldx  SCRA+1               ; 2475
         bcc  L247A                ; 2477
         inx                       ; 2479
L247A
         cmp  DLSA                 ; 247A
         txa                       ; 247D
         sbc  DLSA+1               ; 247E
         bcc  L2498                ; 2481
         lda  #$98                 ; 2483
         sta  ROW_JMP+1            ; 2485
         lda  #$24                 ; 2488
         sta  ROW_JMP+2            ; 248A
         jsr  HALT                 ; 248D
FADR_L           equ *+1                              ; 2491 Robbo's screen address for FADR (set by MFEX), low byte
         lda  #$00                 ; 2490
         sta  FADR                 ; 2492
FADR_H           equ *+1                              ; 2495 Robbo's screen address for FADR, high byte
         lda  #$00                 ; 2494
         sta  FADR+1               ; 2496
L2498
         ldx  #$0F                 ; 2498
ROW_CELL
         lda  BOARD,x              ; 249A
         and  #$7F                 ; 249D
         tay                       ; 249F
         lda  LOOK,y               ; 24A0
         ldy  #$00                 ; 24A3
         sta  (SCRA),y             ; 24A5
         ora  #$01                 ; 24A7
         iny                       ; 24A9
         sta  (SCRA),y             ; 24AA
         ora  #$20                 ; 24AC
         ldy  #$21                 ; 24AE
         sta  (SCRA),y             ; 24B0
         and  #$FE                 ; 24B2
         dey                       ; 24B4
         sta  (SCRA),y             ; 24B5
         dec  SCRA                 ; 24B7
         dec  SCRA                 ; 24B9
         dex                       ; 24BB
         bpl  ROW_CELL             ; 24BC
         inc  SCRA                 ; 24BE
         inc  SCRA                 ; 24C0
         clc                       ; 24C2
         lda  SCRA                 ; 24C3
         adc  #$5E                 ; 24C5
         sta  SCRA                 ; 24C7
         bcc  L24CD                ; 24C9
         inc  SCRA+1               ; 24CB
L24CD
         clc                       ; 24CD
         lda  ROW_CELL+1           ; 24CE
         adc  #$10                 ; 24D1
         sta  ROW_CELL+1           ; 24D3
         bcc  L24DB                ; 24D6
         inc  ROW_CELL+2           ; 24D8
L24DB
         dec  ADDR                 ; 24DB
         bne  ROW_JMP              ; 24DD
         rts                       ; 24DF

* Robbo's step, from CHNMON: direction MOVE_DIR, FAC_TURN at FX / FY ---
FAC_STEP
         lda  MOVE_IN              ; 24E0
         sta  MOVE_DIR             ; 24E3
         lda  X                    ; 24E6
         pha                       ; 24E8
         lda  Y                    ; 24E9
         pha                       ; 24EB
         lda  FX                   ; 24EC
         sta  X                    ; 24EE
         sta  X1                   ; 24F0
         lda  FY                   ; 24F2
         sta  Y                    ; 24F4
         sta  Y1                   ; 24F6
         jsr  FAC_TURN             ; 24F8
         pla                       ; 24FB
         sta  Y                    ; 24FC
         pla                       ; 24FE
         sta  X                    ; 24FF
         rts                       ; 2501
FACET            dta $00                              ; 2502 Robbo's walking phase (Robbo: CHNMON-1, "FACET")

* CHNMON (Robbo): copy the animation phase (CNTR) of the element shapes from $4800 into the board font ---
ANIM
         lda  #$00                 ; 2503
         sta  ADDR                 ; 2505
         lda  CNTR                 ; 2507
         clc                       ; 250A
         and  #$02                 ; 250B
         adc  #$48                 ; 250D
         sta  ADDR+1               ; 250F
         ldy  #$FF                 ; 2511

* animated shapes, part 1: characters $1C-$1F of the board font from the phase in $4800 / $4A00 (Robbo CM1) ---
CM1
         lda  (ADDR),y             ; 2513
         sta  FONT,y               ; 2515
         inc  ADDR+1               ; 2518
         lda  (ADDR),y             ; 251A
         sta  FONT+256,y           ; 251C
         dec  ADDR+1               ; 251F
         dey                       ; 2521
         cpy  #$DF                 ; 2522
         bne  CM1                  ; 2524
         ldx  #$AF                 ; 2526

* animated shapes, part 2: characters $0A-$15 (Robbo CM2) ---
CM2
         lda  (ADDR),y             ; 2528
         sta  FONT,x               ; 252A
         inc  ADDR+1               ; 252D
         lda  (ADDR),y             ; 252F
         sta  FONT+256,x           ; 2531
         dec  ADDR+1               ; 2534
         dey                       ; 2536
         dex                       ; 2537
         cpx  #$4F                 ; 2538
         bne  CM2                  ; 253A
         lda  FACET                ; 253C
         clc                       ; 253F
         and  #$01                 ; 2540
         asl                       ; 2542
         adc  #$48                 ; 2543
         sta  ADDR+1               ; 2545
         ldx  RUCH                 ; 2547
         beq  FA1                  ; 2549
         ldx  FAC                  ; 254B
         beq  FA1                  ; 254D
         inc  FACET                ; 254F
         ldx  #$50                 ; 2552
L2554
         lda  ENGINE_INIT,x        ; 2554
         sta  CONSOL               ; 2557
         dex                       ; 255A
         bpl  L2554                ; 255B

* Robbo's shape for the direction LM, walking phase $2502 when he moves; the footstep click on CONSOL (Robbo FA1, "-tup-") ---
FA1
         lda  LM                   ; 255D
         ldy  #$04                 ; 255F
L2561
         dey                       ; 2561
         lsr                       ; 2562
         bcs  L2561                ; 2563
         tya                       ; 2565
         asl                       ; 2566
         asl                       ; 2567
         asl                       ; 2568
         asl                       ; 2569
         adc  #$4F                 ; 256A
         tay                       ; 256C
         ldx  #$0F                 ; 256D

* copy Robbo's shape into the board font ($3EF0 / $3FF0, Robbo CM3) ---
CM3
         lda  (ADDR),y             ; 256F
         sta  FONT+$2F0,x          ; 2571
         inc  ADDR+1               ; 2574
         lda  (ADDR),y             ; 2576
         dec  ADDR+1               ; 2578
         sta  FONT+$3F0,x          ; 257A
         dey                       ; 257D
         dex                       ; 257E
         bpl  CM3                  ; 257F
         rts                       ; 2581
