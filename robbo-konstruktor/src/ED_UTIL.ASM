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
         sta  PCOLR0,x             ; B3D2
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
YESNO            dta $00                              ; B3F4 ASK_YESNO: bit 0 = the word highlighted ("tak" / "nie"), +1 by the stick

* yes / no choice: move the highlight in "tak nie" ---------
ASK_YESNO_
         lda  YESNO                ; B3F5
         and  #$01                 ; B3F8
         tax                       ; B3FA
         ldy  #$28                 ; B3FB
LB3FD
         dey                       ; B3FD
LB3FE
         lda  STATUS,y             ; B3FE
         and  #$7F                 ; B401
         beq  LB3FD                ; B403
         bne  LB408                ; B405
LB407
         dey                       ; B407
LB408
         lda  STATUS,y             ; B408
         and  #$7F                 ; B40B
         bne  LB407                ; B40D
         dex                       ; B40F
         bpl  LB3FE                ; B410
         lda  STATUS,y             ; B412
         bmi  LB43A                ; B415
         ldx  #$27                 ; B417
LB419
         lda  STATUS,x             ; B419
         and  #$7F                 ; B41C
         sta  STATUS,x             ; B41E
         dex                       ; B421
         bpl  LB419                ; B422
LB424
         lda  STATUS,y             ; B424
         ora  #$80                 ; B427
         sta  STATUS,y             ; B429
         iny                       ; B42C
         lda  STATUS,y             ; B42D
         bne  LB424                ; B430
         lda  STATUS,y             ; B432
         ora  #$80                 ; B435
         sta  STATUS,y             ; B437
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
         inc  YESNO                ; B44C
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
         lda  YESNO                ; B46A
         and  #$01                 ; B46D
         beq  LB473                ; B46F
         ldx  #$79                 ; B471
LB473
         txa                       ; B473
LB474
         pha                       ; B474
         lda  #$00                 ; B475
         sta  YESNO                ; B477
         jsr  CLICK                ; B47A

* copy protection 2, run at the first yes / no question (one-shot: the operand of lda #$00 gets bit 7 by ror $B47E): "eor $0A00,x" / "cmp $0440" are halved to $0500 / $0240 - the XOR of $FF and the boot loader $0501-$05FF must equal DFLAGS; else $4C (opcode of START) is written to $ACB3 ---
PROT_BOOT
         lda  #$00                 ; B47D
         bmi  LB49B                ; B47F
         lsr  PROT_EOR+2           ; B481
         lsr  PROT_CMP+2           ; B484
         ldx  #$FF                 ; B487
         txa                       ; B489
PROT_EOR
         eor  $0A00,x              ; B48A
         dex                       ; B48D
         bne  PROT_EOR             ; B48E
PROT_CMP
         cmp  $0440                ; B490
         beq  LB49B                ; B493
         lda  START                ; B495
         sta  COUNT_RTS            ; B498
LB49B
         sec                       ; B49B
         ror  PROT_BOOT+1          ; B49C
         pla                       ; B49F
         clc                       ; B4A0
         rts                       ; B4A1

* ATASCII -> screen code -----------------------------------
ATA2SCR_
         stx  A2S_X                ; B4A2
         sty  A2S_Y                ; B4A5
         asl                       ; B4A8
         php                       ; B4A9
         lsr                       ; B4AA
         ldx  #$FF                 ; B4AB
LB4AD
         inx                       ; B4AD
         ldy  CHR_FROM,x           ; B4AE
         bmi  LB4BB                ; B4B1
         cmp  CHR_FROM,x           ; B4B3
         bne  LB4AD                ; B4B6
         lda  CHR_TO,x             ; B4B8
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
A2S_Y            equ *+1                              ; B4C9 Y kept by ATA2SCR_
         ldy  #$00                 ; B4C8
A2S_X            equ *+1                              ; B4CB X kept by ATA2SCR_
         ldx  #$00                 ; B4CA
         rts                       ; B4CC

* number -> two decimal digits (screen codes) --------------
TO_DIGITS_
         sta  TMP3                 ; B4CD
         lda  #$00                 ; B4CF
         sta  TMP4                 ; B4D1
         ldx  #$07                 ; B4D3
         sed                       ; B4D5
LB4D6
         asl  TMP3                 ; B4D6
         adc  TMP4                 ; B4D8
         sta  TMP4                 ; B4DA
         dex                       ; B4DC
         bpl  LB4D6                ; B4DD
         cld                       ; B4DF
         lda  TMP4                 ; B4E0
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
