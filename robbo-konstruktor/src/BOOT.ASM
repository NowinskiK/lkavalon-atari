; BOOT.ASM - boot sectors 1-3: boot record and binary-file loader (cracked)
; $0500-$067F

         org $0500

         dta $AE,$03,$00,$05,$DD,$19                  ; 0500

* boot: read the program file from sector 4 and start it ---
BOOT
         jmp  L050B                ; 0506
         dta $4C,$05                                  ; 0509
L050B
         lda  #$53                 ; 050B
         sta  DCOMND               ; 050D
         jsr  DSKINV               ; 0510
         jmp  L05A6                ; 0513
         dta $59,$BD,$4C,$05,$49,$CD,$9D,$4C,$05,$CA,$10,$F5,$4C,$4C,$05 ; 0516
L0525
         pla                       ; 0525
         pla                       ; 0526
         cpy  #$88                 ; 0527
         beq  L052E                ; 0529
         nop                       ; 052B
         nop                       ; 052C
         nop                       ; 052D
L052E
         jmp  (RUNAD)              ; 052E

* boot: JMP (INITAD) after each segment --------------------
BOOT_INIT
         jmp  (INITAD)             ; 0531

* boot: next byte of the file ------------------------------
BOOT_GETBYTE
         ldy  BOOT_BPOS            ; 0534
         cpy  BOOT_BCNT            ; 0536
         bcc  L0543                ; 0538
         jsr  BOOT_NEXTSEC         ; 053A
         bmi  L0525                ; 053D
         ldy  #$00                 ; 053F
         ldx  #$00                 ; 0541
L0543
         lda  SEC_BUF,y            ; 0543
         iny                       ; 0546
         sty  BOOT_BPOS            ; 0547
         ldy  #$01                 ; 0549
         rts                       ; 054B
         dta $AD,$EA,$02,$29,$08,$A9,$00,$85,$41,$AA,$9D,$00,$04,$E8,$D0,$FA ; 054C
         dta $A2,$03,$A9,$DD,$8D,$0A,$03,$30,$05,$E8,$C9,$11,$B0,$39,$8E,$0B ; 055C
         dta $03,$A9,$57,$8D,$02,$03,$A9,$00,$8D,$04,$03,$A9,$04,$8D,$05,$03 ; 056C
         dta $AD,$53,$E4,$A2,$42,$A9,$52,$8D,$02,$03,$20,$53,$E4,$10,$18,$AD ; 057C
         dta $04,$03,$49,$80,$8D,$04,$03,$8C,$53,$E4,$A2,$7F,$BD,$80,$04,$C0 ; 058C
         dta $90,$F0,$07,$EA,$CA,$10,$F5,$EA,$EA,$EA  ; 059C
L05A6
         lda  #$04                 ; 05A6
         sta  DAUX1                ; 05A8
         lda  #$00                 ; 05AB
         sta  DAUX2                ; 05AD
L05B0
         lda  #$4B                 ; 05B0
         sta  INITAD               ; 05B2
         lda  #$05                 ; 05B5
         sta  INITAD+1             ; 05B7
         jsr  BOOT_GETBYTE         ; 05BA
         sta  BOOT_ADR             ; 05BD
         jsr  BOOT_GETBYTE         ; 05BF
         sta  BOOT_ADR+1           ; 05C2
         and  BOOT_ADR             ; 05C4
         cmp  #$FF                 ; 05C6
         beq  L05B0                ; 05C8
         jsr  BOOT_GETBYTE         ; 05CA
         sta  BOOT_END             ; 05CD
         jsr  BOOT_GETBYTE         ; 05CF
         sta  BOOT_END+1           ; 05D2
         ldx  #$00                 ; 05D4
         beq  L05DE                ; 05D6
L05D8
         inc  BOOT_ADR             ; 05D8
         bne  L05DE                ; 05DA
         inc  BOOT_ADR+1           ; 05DC
L05DE
         jsr  BOOT_GETBYTE         ; 05DE
         sta  (BOOT_ADR,x)         ; 05E1
         lda  BOOT_ADR+1           ; 05E3
         cmp  BOOT_END+1           ; 05E5
         bne  L05D8                ; 05E7
         lda  BOOT_ADR             ; 05E9
         cmp  BOOT_END             ; 05EB
         bne  L05D8                ; 05ED
         jsr  BOOT_INIT            ; 05EF
         jmp  L05B0                ; 05F2

* boot: read the next sector of the chain (DOS 2 link: bytes 125-127) ---
BOOT_NEXTSEC
         lda  DAUX1                ; 05F5
         ora  DAUX2                ; 05F8
         bne  L0600                ; 05FB
         ldy  #$88                 ; 05FD
         rts                       ; 05FF
L0600
         ldy  #$01                 ; 0600
         ldx  #$00                 ; 0602
         stx  DBUFLO               ; 0604
         lda  #$04                 ; 0607
         sta  DBUFHI               ; 0609
         lda  DVSTAT               ; 060C
         and  #$20                 ; 060F
         bne  L0616                ; 0611
         ldx  #$80                 ; 0613
         dey                       ; 0615
L0616
         stx  DBYTLO               ; 0616
         sty  DBYTHI               ; 0619
         lda  #$52                 ; 061C
         sta  DCOMND               ; 061E
         sta  DSTATS               ; 0621
         jsr  SIOV                 ; 0624
         bmi  L0642                ; 0627
         ldx  DBYTLO               ; 0629
         dex                       ; 062C
         lda  SEC_BUF,x            ; 062D
         sta  BOOT_BCNT            ; 0630
         sta  BOOT_BPOS            ; 0632
         lda  SEC_LINKL,x          ; 0634
         sta  DAUX1                ; 0637
         lda  SEC_LINKH,x          ; 063A
         and  #$03                 ; 063D
         sta  DAUX2                ; 063F
L0642
         rts                       ; 0642
         dta $02,$C9,$1C,$D0,$0C,$A9,$FF,$8D,$FC,$02,$A0,$80,$84,$11,$4C,$99 ; 0643
         dta $06,$AD,$A7,$06,$CD,$69,$06,$D0,$0B,$AC,$68,$06,$CC,$A6,$06,$90 ; 0653
         dta $03,$20,$99,$06,$AD,$00,$04,$A8,$C9,$1B,$D0,$18,$EE,$68,$06,$D0 ; 0663
         dta $03,$EE,$69,$06,$A2,$FF,$A5,$11,$F0,$D0,$EC,$FC,$02 ; 0673
