; ED_UTIL.ASM - editor helpers: display list switch, yes / no question, ATASCII to screen code, digits
; $B3BE-$B4F8

         org $B3BE


* set a display list (X/Y) and the colours -----------------
SET_DLIST_
         jsr  WAIT_VBL             ; B3BE
         stx  SDLSTL               ; B3C1
         stx  DLISTL               ; B3C4
         sty  SDLSTH               ; B3C7
         sty  DLISTH               ; B3CA
         lda  COLOR4               ; B3CD
         ldx  #$08                 ; B3D0
LB3D2
         sta  $02C0,x              ; B3D2
         sta  COLPM0,x             ; B3D5
         dex                       ; B3D8
         bpl  LB3D2                ; B3D9
         lda  #$0A                 ; B3DB
         sta  COLOR1               ; B3DD
         sta  COLPF1               ; B3E0
         lda  #$00                 ; B3E3
         sta  COLOR2               ; B3E5
         sta  COLPF2               ; B3E8
         lda  #$22                 ; B3EB
         sta  SDMCTL               ; B3ED
         sta  DMACTL               ; B3F0
         rts                       ; B3F3
         dta $00                                      ; B3F4

* yes / no choice: move the highlight in "tak nie" ---------
ASK_YESNO_
         lda  $B3F4                ; B3F5
         and  #$01                 ; B3F8
         tax                       ; B3FA
         ldy  #$28                 ; B3FB
LB3FD
         dey                       ; B3FD
LB3FE
         lda  $BCC8,y              ; B3FE
         and  #$7F                 ; B401
         beq  LB3FD                ; B403
         bne  LB408                ; B405
LB407
         dey                       ; B407
LB408
         lda  $BCC8,y              ; B408
         and  #$7F                 ; B40B
         bne  LB407                ; B40D
         dex                       ; B40F
         bpl  LB3FE                ; B410
         lda  $BCC8,y              ; B412
         bmi  LB43A                ; B415
         ldx  #$27                 ; B417
LB419
         lda  $BCC8,x              ; B419
         and  #$7F                 ; B41C
         sta  $BCC8,x              ; B41E
         dex                       ; B421
         bpl  LB419                ; B422
LB424
         lda  $BCC8,y              ; B424
         ora  #$80                 ; B427
         sta  $BCC8,y              ; B429
         iny                       ; B42C
         lda  $BCC8,y              ; B42D
         bne  LB424                ; B430
         lda  $BCC8,y              ; B432
         ora  #$80                 ; B435
         sta  $BCC8,y              ; B437
LB43A
         lda  JOY                  ; B43A
         cmp  #$FF                 ; B43D
         beq  LB459                ; B43F
         and  #$04                 ; B441
         beq  LB44C                ; B443
         lda  JOY                  ; B445
         and  #$08                 ; B448
         bne  LB455                ; B44A
LB44C
         inc  $B3F4                ; B44C
         jsr  CLICK                ; B44F
         jmp  LB459                ; B452
LB455
         lda  #$78                 ; B455
         bne  LB474                ; B457
LB459
         jsr  INPUT_CLR            ; B459
         beq  LB468                ; B45C
         jsr  KEY_EVENT            ; B45E
         bcc  LB464                ; B461
         rts                       ; B463
LB464
         lda  #$78                 ; B464
         bne  LB474                ; B466
LB468
         ldx  #$6E                 ; B468
         lda  $B3F4                ; B46A
         and  #$01                 ; B46D
         beq  LB473                ; B46F
         ldx  #$79                 ; B471
LB473
         txa                       ; B473
LB474
         pha                       ; B474
         lda  #$00                 ; B475
         sta  $B3F4                ; B477
         jsr  CLICK                ; B47A
         lda  #$00                 ; B47D
         bmi  LB49B                ; B47F
         lsr  $B48C                ; B481
         lsr  $B492                ; B484
         ldx  #$FF                 ; B487
         txa                       ; B489
LB48A
         eor  $0A00,x              ; B48A
         dex                       ; B48D
         bne  LB48A                ; B48E
         cmp  $0440                ; B490
         beq  LB49B                ; B493
         lda  START                ; B495
         sta  $ACB3                ; B498
LB49B
         sec                       ; B49B
         ror  $B47E                ; B49C
         pla                       ; B49F
         clc                       ; B4A0
         rts                       ; B4A1

* ATASCII -> screen code -----------------------------------
ATA2SCR_
         stx  $B4CB                ; B4A2
         sty  $B4C9                ; B4A5
         asl                       ; B4A8
         php                       ; B4A9
         lsr                       ; B4AA
         ldx  #$FF                 ; B4AB
LB4AD
         inx                       ; B4AD
         ldy  $B4F9,x              ; B4AE
         bmi  LB4BB                ; B4B1
         cmp  $B4F9,x              ; B4B3
         bne  LB4AD                ; B4B6
         lda  $B505,x              ; B4B8
LB4BB
         asl                       ; B4BB
         cmp  #$C0                 ; B4BC
         bcs  LB4C6                ; B4BE
         sbc  #$3E                 ; B4C0
         bcs  LB4C6                ; B4C2
         adc  #$C0                 ; B4C4
LB4C6
         plp                       ; B4C6
         ror                       ; B4C7
         ldy  #$00                 ; B4C8
         ldx  #$00                 ; B4CA
         rts                       ; B4CC

* number -> two decimal digits (screen codes) --------------
TO_DIGITS_
         sta  $B6                  ; B4CD
         lda  #$00                 ; B4CF
         sta  $B7                  ; B4D1
         ldx  #$07                 ; B4D3
         sed                       ; B4D5
LB4D6
         asl  $B6                  ; B4D6
         adc  $B7                  ; B4D8
         sta  $B7                  ; B4DA
         dex                       ; B4DC
         bpl  LB4D6                ; B4DD
         cld                       ; B4DF
         lda  $B7                  ; B4E0
         tay                       ; B4E2
         pha                       ; B4E3
         jsr  DIGIT                ; B4E4
         tax                       ; B4E7
         pla                       ; B4E8
         lsr                       ; B4E9
         lsr                       ; B4EA
         lsr                       ; B4EB
         lsr                       ; B4EC

* one digit (low nibble) -> screen code --------------------
DIGIT
         and  #$0F                 ; B4ED
         clc                       ; B4EF
         adc  #$10                 ; B4F0
         cmp  #$1A                 ; B4F2
         bcc  LB4F8                ; B4F4
         adc  #$46                 ; B4F6
LB4F8
         rts                       ; B4F8
