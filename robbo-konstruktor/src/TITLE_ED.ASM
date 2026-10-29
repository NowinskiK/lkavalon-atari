; TITLE_ED.ASM - title-page text editor (start / congratulation texts)
; $B189-$B3BD

         org $B189


* menu function "strona tytułowa": edit the start and congratulation texts ---
TITLE_ED_
         lda  #$1D                 ; B189
         jsr  MESSAGE              ; B18B
         jsr  ED_DLIST             ; B18E
         lda  $B187                ; B191
         sta  $B4                  ; B194
         lda  $B188                ; B196
         sta  $B5                  ; B199
LB19B
         jsr  TX_DRAW              ; B19B
         ldx  #$00                 ; B19E
         ldy  #$A9                 ; B1A0
         jsr  SET_DLIST            ; B1A2
         lda  #$40                 ; B1A5
         sta  IRQEN                ; B1A7
         jsr  LB1C3                ; B1AA
         bcc  LB19B                ; B1AD
         lda  #$00                 ; B1AF
         sta  IRQEN                ; B1B1
         lda  $B5                  ; B1B4
         sta  $B188                ; B1B6
         lda  $B4                  ; B1B9
         sta  $B187                ; B1BB
         jsr  ED_DLIST             ; B1BE
         sec                       ; B1C1
         rts                       ; B1C2
LB1C3
         lda  #$00                 ; B1C3
         sta  $B2                  ; B1C5
         lda  #$3A                 ; B1C7
         sta  $B3                  ; B1C9
         jsr  TX_SETBIT            ; B1CB
         lda  $B5                  ; B1CE
         sta  $B2                  ; B1D0
         ldy  #$00                 ; B1D2
         lda  ($B2),y              ; B1D4
         ora  #$80                 ; B1D6
         sta  ($B2),y              ; B1D8
         jsr  TX_DRAW              ; B1DA
         ldy  #$00                 ; B1DD
         lda  ($B2),y              ; B1DF
         and  #$7F                 ; B1E1
         sta  ($B2),y              ; B1E3
         jsr  GETKEY               ; B1E5
         bcs  LB1F3                ; B1E8
         cmp  #$11                 ; B1EA
         bne  LB1F3                ; B1EC
         jsr  HELP_KEY             ; B1EE
         clc                       ; B1F1
         rts                       ; B1F2
LB1F3
         jsr  INPUT                ; B1F3
         jsr  INPUT_CLR            ; B1F6
         bne  LB206                ; B1F9
         lda  TRIG0                ; B1FB
         and  $D011                ; B1FE
         and  CONSOL               ; B201
         beq  LB20B                ; B204
LB206
         jsr  KEY_EVENT            ; B206
         bcs  LB210                ; B209
LB20B
         jsr  CLICK                ; B20B
         sec                       ; B20E
         rts                       ; B20F
LB210
         ldx  CH                   ; B210
         cpx  #$FF                 ; B213
         beq  LB1C3                ; B215
         lda  #$FF                 ; B217
         sta  CH                   ; B219
         lda  $FB51,x              ; B21C
         sta  $B244                ; B21F
         lda  $B244                ; B222
         ldx  #$00                 ; B225
LB227
         cmp  $B330,x              ; B227
         bne  LB23B                ; B22A
         lda  $B331,x              ; B22C
         sta  $B239                ; B22F
         lda  $B332,x              ; B232
         sta  $B23A                ; B235
         jmp  $B238                ; B238
LB23B
         inx                       ; B23B
         inx                       ; B23C
         inx                       ; B23D
         ldy  $B330,x              ; B23E
         bne  LB227                ; B241
         lda  #$00                 ; B243
         jsr  TX_ALLOWED           ; B245
         bcc  LB24D                ; B248
         jmp  LB1C3                ; B24A
LB24D
         jsr  ATA2SCR              ; B24D
         ldy  #$00                 ; B250
         sta  ($B2),y              ; B252

* text input: cursor right ---------------------------------
TX_RIGHT
         inc  $B5                  ; B254
         jmp  LB275                ; B256

* text input: cursor left ----------------------------------
TX_LEFT
         dec  $B5                  ; B259
         jmp  LB275                ; B25B

* text input: cursor up ------------------------------------
TX_UP
         sec                       ; B25E
         lda  $B5                  ; B25F
         sbc  #$20                 ; B261
         sta  $B5                  ; B263
         bcs  LB275                ; B265
         bcc  LB272                ; B267

* text input: cursor down ----------------------------------
TX_DOWN
         clc                       ; B269
         lda  $B5                  ; B26A
         adc  #$20                 ; B26C
         sta  $B5                  ; B26E
         bcc  LB275                ; B270
LB272
         jsr  TX_FLIP              ; B272
LB275
         jsr  CLICK                ; B275
         jmp  LB1C3                ; B278

* text input: backspace ------------------------------------
TX_BACKSP
         lda  $B5                  ; B27B
         bne  LB282                ; B27D
         jmp  LB1C3                ; B27F
LB282
         dec  $B5                  ; B282
         lda  $B5                  ; B284
         sta  $B2                  ; B286
         ldy  #$00                 ; B288
         tya                       ; B28A
         sta  ($B2),y              ; B28B
         jmp  LB275                ; B28D

* text input: insert character -----------------------------
TX_INSERT
         lda  #$00                 ; B290
         sta  $B2                  ; B292
         dec  $B5                  ; B294
         ldy  $B5                  ; B296
         cpy  #$FE                 ; B298
         beq  LB2A9                ; B29A
         ldy  #$FE                 ; B29C
LB29E
         lda  ($B2),y              ; B29E
         iny                       ; B2A0
         sta  ($B2),y              ; B2A1
         dey                       ; B2A3
         dey                       ; B2A4
         cpy  $B5                  ; B2A5
         bne  LB29E                ; B2A7
LB2A9
         iny                       ; B2A9
         lda  #$00                 ; B2AA
         sta  ($B2),y              ; B2AC
         inc  $B5                  ; B2AE
         jmp  LB275                ; B2B0

* text input: delete character -----------------------------
TX_DELETE
         lda  #$00                 ; B2B3
         sta  $B2                  ; B2B5
         ldy  $B5                  ; B2B7
         iny                       ; B2B9
LB2BA
         lda  ($B2),y              ; B2BA
         dey                       ; B2BC
         sta  ($B2),y              ; B2BD
         iny                       ; B2BF
         beq  LB2C5                ; B2C0
         iny                       ; B2C2
         bne  LB2BA                ; B2C3
LB2C5
         dey                       ; B2C5
         lda  #$00                 ; B2C6
         sta  ($B2),y              ; B2C8
         jmp  LB275                ; B2CA

* text input: return ---------------------------------------
TX_RETURN
         clc                       ; B2CD
         lda  $B5                  ; B2CE
         adc  #$20                 ; B2D0
         and  #$E0                 ; B2D2
         sta  $B5                  ; B2D4
         bcc  LB2DB                ; B2D6
         jsr  TX_FLIP              ; B2D8
LB2DB
         jmp  LB275                ; B2DB

* text input: clear ----------------------------------------
TX_CLEAR
         ldy  #$00                 ; B2DE
         sty  $B2                  ; B2E0
         sty  $B5                  ; B2E2
         tya                       ; B2E4
LB2E5
         sta  ($B2),y              ; B2E5
         dey                       ; B2E7
         bne  LB2E5                ; B2E8
         jmp  LB275                ; B2EA

* text input: flip bit 0 of $B4 ----------------------------
TX_FLIP
         lda  $B4                  ; B2ED
         eor  #$01                 ; B2EF
         sta  $B4                  ; B2F1
         rts                       ; B2F3

* text input: set bit 0 of $B3 from $B4 --------------------
TX_SETBIT
         lda  $B3                  ; B2F4
         and  #$FE                 ; B2F6
         ora  $B4                  ; B2F8
         sta  $B3                  ; B2FA
         rts                       ; B2FC

* text input: is the character allowed ---------------------
TX_ALLOWED
         ldx  #$00                 ; B2FD
LB2FF
         ldy  $B4F9,x              ; B2FF
         bmi  LB30C                ; B302
         cmp  $B4F9,x              ; B304
         beq  LB32C                ; B307
         inx                       ; B309
         bpl  LB2FF                ; B30A
LB30C
         cmp  #$20                 ; B30C
         beq  LB32C                ; B30E
         cmp  #$21                 ; B310
         beq  LB32C                ; B312
         cmp  #$2C                 ; B314
         bcc  LB32E                ; B316
         cmp  #$3B                 ; B318
         bcc  LB32C                ; B31A
         cmp  #$3F                 ; B31C
         bcc  LB32E                ; B31E
         cmp  #$5B                 ; B320
         bcc  LB32C                ; B322
         cmp  #$61                 ; B324
         bcc  LB32E                ; B326
         cmp  #$7B                 ; B328
         bcs  LB32E                ; B32A
LB32C
         clc                       ; B32C
         rts                       ; B32D
LB32E
         sec                       ; B32E
         rts                       ; B32F
         dta $1E,$59,$B2,$1F,$54,$B2,$1C,$5E,$B2,$1D,$69,$B2,$7E,$7B,$B2,$FE ; B330
         dta $B3,$B2,$FF,$90,$B2,$7D,$DE,$B2,$9B,$CD,$B2,$00 ; B340

* text input: draw the text window -------------------------
TX_DRAW
         ldy  #$27                 ; B34C
LB34E
         lda  $A957,y              ; B34E
         sta  $B600,y              ; B351
         lda  $A97F,y              ; B354
         sta  $B800,y              ; B357
         dey                       ; B35A
         bpl  LB34E                ; B35B
         lda  #$60                 ; B35D
LB35F
         cmp  VCOUNT               ; B35F
         bne  LB35F                ; B362
         lda  #$00                 ; B364
         sta  $B6                  ; B366
         lda  #$3A                 ; B368
         sta  $B7                  ; B36A
         lda  #$28                 ; B36C
         sta  $B0                  ; B36E
         lda  #$B6                 ; B370
         sta  $B1                  ; B372
         ldx  #$02                 ; B374
LB376
         lda  #$00                 ; B376
         ldy  #$27                 ; B378
LB37A
         sta  ($B0),y              ; B37A
         dey                       ; B37C
         cpy  #$24                 ; B37D
         bcs  LB37A                ; B37F
         ldy  #$03                 ; B381
LB383
         sta  ($B0),y              ; B383
         dey                       ; B385
         bpl  LB383                ; B386
         clc                       ; B388
         lda  $B0                  ; B389
         adc  #$04                 ; B38B
         sta  $B0                  ; B38D
         bcc  LB393                ; B38F
         inc  $B1                  ; B391
LB393
         ldy  #$1F                 ; B393
LB395
         lda  ($B6),y              ; B395
         sta  ($B0),y              ; B397
         dey                       ; B399
         bpl  LB395                ; B39A
         clc                       ; B39C
         lda  $B0                  ; B39D
         adc  #$24                 ; B39F
         sta  $B0                  ; B3A1
         bcc  LB3A7                ; B3A3
         inc  $B1                  ; B3A5
LB3A7
         clc                       ; B3A7
         lda  $B6                  ; B3A8
         adc  #$20                 ; B3AA
         sta  $B6                  ; B3AC
         bcc  LB376                ; B3AE
         inc  $B7                  ; B3B0
         lda  #$28                 ; B3B2
         sta  $B0                  ; B3B4
         lda  #$B8                 ; B3B6
         sta  $B1                  ; B3B8
         dex                       ; B3BA
         bne  LB376                ; B3BB
         rts                       ; B3BD
