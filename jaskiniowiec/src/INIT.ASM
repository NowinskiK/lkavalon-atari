; INIT.ASM - font copy, init tables, variables ($9349-$93C6), table builder
; $9215-$948E

         org $9215


* text screen set-up: music position, text font to $D800 / $E000 ---
TEXT_SETUP
         lda  #$10                 ; 9215
         jsr  CMC_CMD              ; 9217
         lda  #$00                 ; 921A
         ldx  #$18                 ; 921C
         jmp  L924E                ; 921E

* copy level font A ($0800) --------------------------------
FONT_A
         lda  #$00                 ; 9221
         ldx  #$01                 ; 9223
         jsr  CMC_CMD              ; 9225
         lda  #$00                 ; 9228
         jsr  MUSIC_TGL            ; 922A
         lda  #$00                 ; 922D
         jsr  MUSIC_TGL            ; 922F
         lda  #$00                 ; 9232
         ldx  #$08                 ; 9234
         jmp  L924E                ; 9236

* copy level font B ($1000) --------------------------------
FONT_B
         lda  #$00                 ; 9239
         ldx  #$01                 ; 923B
         jsr  CMC_CMD              ; 923D
         lda  #$00                 ; 9240
         jsr  MUSIC_TGL            ; 9242
         lda  #$00                 ; 9245
         jsr  MUSIC_TGL            ; 9247
         lda  #$00                 ; 924A
         ldx  #$10                 ; 924C
L924E
         sta  $C8                  ; 924E
         stx  $C9                  ; 9250
         lda  #$00                 ; 9252
         ldx  #$D8                 ; 9254
         sta  $CA                  ; 9256
         stx  $CB                  ; 9258
         lda  #$00                 ; 925A
         ldx  #$E0                 ; 925C
         sta  $CE                  ; 925E
         stx  $CF                  ; 9260
         ldx  #$08                 ; 9262
         ldy  #$00                 ; 9264
L9266
         lda  ($C8),y              ; 9266
         sta  ($CA),y              ; 9268
         sta  ($CE),y              ; 926A
         iny                       ; 926C
         bne  L9266                ; 926D
         inc  $C9                  ; 926F
         inc  $CB                  ; 9271
         inc  $CF                  ; 9273
         dex                       ; 9275
         bne  L9266                ; 9276
         lda  #$D8                 ; 9278
         sta  FONT_PAGE            ; 927A
         rts                       ; 927C

* apply the hardware / display init table ------------------
INIT_HW
         jsr  WAIT_VCOUNT          ; 927D
         ldy  #$00                 ; 9280
         ldx  #$00                 ; 9282
L9284
         lda  $929B,x              ; 9284
         sta  $C0                  ; 9287
         inx                       ; 9289
         lda  $929B,x              ; 928A
         sta  $C1                  ; 928D
         inx                       ; 928F
         lda  $929B,x              ; 9290
         sta  ($C0),y              ; 9293
         inx                       ; 9295
         cpx  #$51                 ; 9296
         bne  L9284                ; 9298
         rts                       ; 929A

* init table: hardware and display (address, value) --------
         dta a(MUSIC_OFF),$01                 ; 929B non-zero: music and sound effects off (OPTION toggles, $8A64)
         dta a(DLI_ROW),$00                   ; 929E map row counter of the DLI chain
         dta a(VDSLST),$74                    ; 92A1 
         dta a(VDSLST+1),$88                  ; 92A4 
         dta a(SDLSTL),$74                    ; 92A7 
         dta a(SDLSTH),$89                    ; 92AA 
         dta a(VVBLKD),$8F                    ; 92AD 
         dta a(VVBLKD+1),$8A                  ; 92B0 
         dta a(FONT_PAGE),$D8                 ; 92B3 CHBASE of the visible level font ($D8 / $E0), set by the DLIs
         dta a($02C0),$06                     ; 92B6 
         dta a($02C2),$06                     ; 92B9 
         dta a($02C1),$E8                     ; 92BC 
         dta a($02C3),$E8                     ; 92BF 
         dta a(COLOR0),$10                    ; 92C2 
         dta a(COLOR1),$24                    ; 92C5 
         dta a(COLOR2),$3A                    ; 92C8 
         dta a(COLOR4),$76                    ; 92CB 
         dta a(SDMCTL),$3E                    ; 92CE 
         dta a(GPRIOR),$21                    ; 92D1 
         dta a(PMBASE),$C8                    ; 92D4 
         dta a(GRACTL),$03                    ; 92D7 
         dta a(COL_PF),$B6                    ; 92DA playfield colours PF0-PF3 (DLI $8874); faded towards TARGET_COLS
         dta a(COL_PF+1),$F4                  ; 92DD playfield colours PF0-PF3 (DLI $8874); faded towards TARGET_COLS
         dta a(COL_PF+2),$FA                  ; 92E0 playfield colours PF0-PF3 (DLI $8874); faded towards TARGET_COLS
         dta a(COL_PF+3),$8C                  ; 92E3 playfield colours PF0-PF3 (DLI $8874); faded towards TARGET_COLS
         dta a(COL_BK),$76                    ; 92E6 background colour above the playfield (DLI $8874)
         dta a(AUDF1),$C0                     ; 92E9 

* apply the game-state init table --------------------------
INIT_GAME
         jsr  WAIT_FRAME           ; 92EC
         ldy  #$00                 ; 92EF
         ldx  #$00                 ; 92F1
L92F3
         lda  $930A,x              ; 92F3
         sta  $C0                  ; 92F6
         inx                       ; 92F8
         lda  $930A,x              ; 92F9
         sta  $C1                  ; 92FC
         inx                       ; 92FE
         lda  $930A,x              ; 92FF
         sta  ($C0),y              ; 9302
         inx                       ; 9304
         cpx  #$3F                 ; 9305
         bne  L92F3                ; 9307
         rts                       ; 9309

* init table: game state (address, value) ------------------
         dta a(COUNTER),$01                   ; 930A loop counter (screen scroll steps, $8F52)
         dta a(CAVE_FLAG),$00                 ; 930D non-zero: enter the cave room ($94F7)
         dta a(PLAYER_X),$B6                  ; 9310 player X
         dta a(PLAYER_Y),$70                  ; 9313 player Y
         dta a(RESPAWN_X),$40                 ; 9316 player X after losing a life / entering a screen
         dta a(RESPAWN_Y),$70                 ; 9319 player Y after losing a life / entering a screen
         dta a(PLAYER_FRAME),$00              ; 931C player sprite frame (from ANIM_FRAMES)
         dta a(WALK_STEP),$00                 ; 931F walk-cycle index into ANIM_FRAMES
         dta a(JUMP_STATE),$00                ; 9322 jump: 0 on ground, >0 rising, $80 falling
         dta a(JUMP_STEP),$00                 ; 9325 step in JUMP_ARC (0-11)
         dta a(PROBE_FLOOR),$00               ; 9328 tile attributes below the player ($948F)
         dta a(PROBE_TILE),$00                ; 932B tile attributes at the player: bit 3 hazard, 4 exit, 5 food
         dta a(PROBE_WALL),$00                ; 932E tile attributes beside the player
         dta a(SWING),$00                     ; 9331 club-swing timer: fire sets $0D, counts to $10
         dta a(SCREEN_COL),$00                ; 9334 map column of the visible screen
         dta a(VAR_935B),$00                  ; 9337 only reset at a new level
         dta a(ENERGY),$60                    ; 933A energy, $60 when full; 0 costs a life ($9802)
         dta a(FOOD),$00                      ; 933D food collected ("JEDZENIE"), 32 needed to finish a level
         dta a(LEVEL),$01                     ; 9340 level number 1-6
         dta a(LIVES),$03                     ; 9343 lives ("ZYCIA"), 3 at start
         dta a($9F67),$00                     ; 9346 

* colours -----------------------
TARGET_COLS      dta $00,$00,$00,$00                  ; 9349 target colours PF0-PF3 of the screen (fades $9729/$9744)

* player ------------------------
PLAYER_X         dta $B6                              ; 934D player X
PLAYER_Y         dta $70                              ; 934E player Y
RESPAWN_X        dta $40                              ; 934F player X after losing a life / entering a screen
RESPAWN_Y        dta $70                              ; 9350 player Y after losing a life / entering a screen
PLAYER_FRAME     dta $00                              ; 9351 player sprite frame (from ANIM_FRAMES)
WALK_STEP        dta $00                              ; 9352 walk-cycle index into ANIM_FRAMES
FACING           dta $00                              ; 9353 facing: 0 right, $F8 left
JUMP_STATE       dta $00                              ; 9354 jump: 0 on ground, >0 rising, $80 falling
JUMP_STEP        dta $00                              ; 9355 step in JUMP_ARC (0-11)
PROBE_FLOOR      dta $00                              ; 9356 tile attributes below the player ($948F)
PROBE_TILE       dta $00                              ; 9357 tile attributes at the player: bit 3 hazard, 4 exit, 5 food
PROBE_WALL       dta $00                              ; 9358 tile attributes beside the player
SWING            dta $00                              ; 9359 club-swing timer: fire sets $0D, counts to $10

* level -------------------------
SCREEN_COL       dta $00                              ; 935A map column of the visible screen
VAR_935B         dta $00                              ; 935B only reset at a new level
LEVEL            dta $00                              ; 935C level number 1-6

* DLI colour tables -------------
SKY_COLS         dta $76,$74,$76,$74,$74,$74,$74,$74,$72,$74,$72,$72,$00,$72,$00,$00 ; 935D background per scanline, map rows 0-1 (4 lines per half row)
STATUS_COLS      dta $94,$72,$94,$74,$86,$74,$86,$86,$86,$86,$74,$72 ; 936D status line background, 12 scanlines

* player tables -----------------
ANIM_FRAMES      dta $00,$01,$02,$01,$00,$04,$03,$04,$05,$07,$06,$07,$08,$09,$09,$0A,$0A,$0B,$0C,$0D ; 9379 state -> sprite frame; $0D-$0F = club swing
         dta $00,$00,$00,$00,$00,$00,$00,$00          ; 938D
JUMP_ARC         dta $00,$FE,$FD,$FD,$FD,$FE,$FE,$FE,$FF,$FF,$00,$01 ; 9395 Y change per jump step: 0 -2 -3 -3 -3 -2 -2 -2 -1 -1 0 +1
         dta $01,$02,$02                              ; 93A1

* sprite engine set-up ----------
SCREEN_SETUP     dta $D8,$E0,$BC,$BE,$74,$89,$D8,$89  ; 93A4 fonts $D8/$E0, screens $BC/$BE, display lists $8974/$89D8 ($7C03)
         dta $80,$80,$00,$00                          ; 93AC

* enemy state (4 each) ----------
ENEMY_SPEED      dta $FF,$FF,$01,$01                  ; 93B0 speed / direction (+1 / -1, flipped on turn)
ENEMY_ANIM       dta $00,$01,$02,$03                  ; 93B4 animation counter (0-3)
         dta $00,$01,$02                              ; 93B8
ENEMY_ANIM_FR    dta $00,$01,$02,$03                  ; 93BB frame offset per animation step
ENEMY_TYPE       dta $00,$00,$00,$00                  ; 93BF type: 0 walker, negative vertical, $40 static
ENEMY_HITS       dta $00,$00,$00,$00                  ; 93C3 hits left (3 at spawn), removed at 0

* build the bit-reverse / mirror / mask tables at $C000 (not called) ---
MAKE_TABLES
         ldx  #$00                 ; 93C7
L93C9
         txa                       ; 93C9
         ldy  #$07                 ; 93CA
L93CC
         asl                       ; 93CC
         ror  $C000,x              ; 93CD
         dey                       ; 93D0
         bpl  L93CC                ; 93D1
         inx                       ; 93D3
         bne  L93C9                ; 93D4
         ldx  #$00                 ; 93D6
L93D8
         txa                       ; 93D8
         ldy  #$03                 ; 93D9
L93DB
         asl                       ; 93DB
         rol  $C0                  ; 93DC
         asl                       ; 93DE
         ror  $C100,x              ; 93DF
         lsr  $C0                  ; 93E2
         ror  $C100,x              ; 93E4
         dey                       ; 93E7
         bpl  L93DB                ; 93E8
         inx                       ; 93EA
         bne  L93D8                ; 93EB
         ldx  #$00                 ; 93ED
L93EF
         txa                       ; 93EF
         sta  $C0                  ; 93F0
         asl                       ; 93F2
         ora  $C0                  ; 93F3
         and  #$AA                 ; 93F5
         sta  $C0                  ; 93F7
         lsr                       ; 93F9
         ora  $C0                  ; 93FA
         eor  #$FF                 ; 93FC
         sta  $C200,x              ; 93FE
         inx                       ; 9401
         bne  L93EF                ; 9402
         ldx  #$00                 ; 9404
L9406
         txa                       ; 9406
         ldy  #$00                 ; 9407
         sty  $C0                  ; 9409
         asl                       ; 940B
         asl                       ; 940C
         rol  $C0                  ; 940D
         asl                       ; 940F
         rol  $C0                  ; 9410
         sta  $C300,x              ; 9412
         lda  $C0                  ; 9415
         sta  $C380,x              ; 9417
         inx                       ; 941A
         bpl  L9406                ; 941B
         ldx  #$00                 ; 941D
         txa                       ; 941F
         sec                       ; 9420
         sbc  #$2A                 ; 9421
         sta  $C5E0                ; 9423
         txa                       ; 9426
         sbc  #$00                 ; 9427
         sta  $C5F0                ; 9429
L942C
         clc                       ; 942C
         lda  $C5E0,x              ; 942D
         adc  #$28                 ; 9430
         sta  $C5E1,x              ; 9432
         lda  $C5F0,x              ; 9435
         adc  #$00                 ; 9438
         sta  $C5F1,x              ; 943A
         inx                       ; 943D
         cpx  #$0D                 ; 943E
         bcc  L942C                ; 9440
         lda  #$00                 ; 9442
         ldx  #$20                 ; 9444
         sta  $C0                  ; 9446
         stx  $C1                  ; 9448
         ldx  #$00                 ; 944A
L944C
         lda  $C0                  ; 944C
         sta  $C800,x              ; 944E
         lda  $C1                  ; 9451
         sta  $C840,x              ; 9453
         lda  $C0                  ; 9456
         clc                       ; 9458
         adc  #$20                 ; 9459
         sta  $C0                  ; 945B
         lda  $C1                  ; 945D
         adc  #$00                 ; 945F
         sta  $C1                  ; 9461
         inx                       ; 9463
         cpx  #$40                 ; 9464
         bne  L944C                ; 9466
         lda  #$FF                 ; 9468
         ldx  #$27                 ; 946A
         sta  $C0                  ; 946C
         stx  $C1                  ; 946E
         ldx  #$00                 ; 9470
L9472
         lda  $C0                  ; 9472
         sta  $C650,x              ; 9474
         lda  $C1                  ; 9477
         sta  $C670,x              ; 9479
         lda  $C0                  ; 947C
         clc                       ; 947E
         adc  #$20                 ; 947F
         sta  $C0                  ; 9481
         lda  $C1                  ; 9483
         adc  #$00                 ; 9485
         sta  $C1                  ; 9487
         inx                       ; 9489
         cpx  #$20                 ; 948A
         bne  L9472                ; 948C
         rts                       ; 948E
