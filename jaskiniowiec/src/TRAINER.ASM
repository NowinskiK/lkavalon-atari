; TRAINER.ASM - CAMOsoft crack stub and trainer, over level 2 map rows 0-2
; $6200-$646F

         org $6200


* crack stub: DOSINI = trainer, warm start -----------------
         dta $A9,$02,$85,$09,$A9,$00,$8D,$44,$02,$A2,$14,$A0,$62,$86,$02,$84 ; 6200
         dta $03,$4C,$74,$E4                          ; 6210

* CAMOsoft trainer: "Unlimited lives ? [Y/N]" --------------
entry_6214
         ldx  #$85                 ; 6214
         ldy  #$63                 ; 6216
         stx  SDLSTL               ; 6218
         sty  SDLSTH               ; 621B
         ldx  #$DF                 ; 621E
         ldy  #$62                 ; 6220
         stx  VDSLST               ; 6222
         sty  VDSLST+1             ; 6225
         lda  #$21                 ; 6228
         sta  SDMCTL               ; 622A
         lda  #$C0                 ; 622D
         sta  NMIEN                ; 622F
         lda  #$E0                 ; 6232
         sta  CHBAS                ; 6234
         lda  #$00                 ; 6237
         sta  COLOR2               ; 6239
         sta  COLOR4               ; 623C
         ldx  #$18                 ; 623F
         ldy  #$64                 ; 6241
         stx  $C0                  ; 6243
         sty  $C1                  ; 6245
         jsr  sub_62B9             ; 6247
L624A
         jsr  sub_629B             ; 624A
         lda  #$FF                 ; 624D
         sta  CH                   ; 624F
L6252
         lda  CH                   ; 6252
         cmp  #$FF                 ; 6255
         beq  L6252                ; 6257
         cmp  #$2B                 ; 6259
         beq  L627E                ; 625B
         cmp  #$2D                 ; 625D
         beq  L627E                ; 625F
L6261
         inc  $645A                ; 6261
         lda  $645A                ; 6264
         cmp  #$01                 ; 6267
         bne  L624A                ; 6269
         jsr  sub_62C5             ; 626B
         lda  #$40                 ; 626E
         sta  NMIEN                ; 6270
         lda  #$22                 ; 6273
         sta  SDMCTL               ; 6275
         inc  COLDST               ; 6278
         jmp  LBC00                ; 627B
L627E
         lda  $645A                ; 627E
         asl                       ; 6281
         tay                       ; 6282
         lda  $63C2,y              ; 6283
         sta  RUNAD                ; 6286
         lda  $63C3,y              ; 6289
         sta  $02E1                ; 628C
         jsr  sub_6295             ; 628F
         jmp  L6261                ; 6292
sub_6295
         jmp  (RUNAD)              ; 6295
         dta $4C,$F8,$F2                              ; 6298
sub_629B
         lda  RANDOM               ; 629B
         and  #$F0                 ; 629E
         sta  $6459                ; 62A0
         lda  $C0                  ; 62A3
         clc                       ; 62A5
         adc  #$20                 ; 62A6
         sta  $C0                  ; 62A8
         bcc  L62AE                ; 62AA
         inc  $C1                  ; 62AC
L62AE
         ldy  #$1F                 ; 62AE
L62B0
         lda  ($C0),y              ; 62B0
         sta  $6418,y              ; 62B2
         dey                       ; 62B5
         bpl  L62B0                ; 62B6
         rts                       ; 62B8
sub_62B9
         dec  $6458                ; 62B9
         jsr  sub_62D3             ; 62BC
         lda  $6458                ; 62BF
         bne  sub_62B9             ; 62C2
         rts                       ; 62C4
sub_62C5
         inc  $6458                ; 62C5
         jsr  sub_62D3             ; 62C8
         lda  $6458                ; 62CB
         cmp  #$10                 ; 62CE
         bne  sub_62C5             ; 62D0
         rts                       ; 62D2
sub_62D3
         ldx  #$02                 ; 62D3
L62D5
         lda  RTCLOK+2             ; 62D5
L62D7
         cmp  RTCLOK+2             ; 62D7
         beq  L62D7                ; 62D9
         dex                       ; 62DB
         bne  L62D5                ; 62DC
         rts                       ; 62DE

* trainer DLIs ---------------------------------------------
entry_62DF
         pha                       ; 62DF
         txa                       ; 62E0
         pha                       ; 62E1
         tya                       ; 62E2
         pha                       ; 62E3
         ldy  #$00                 ; 62E4
L62E6
         lda  $639A,y              ; 62E6
         sec                       ; 62E9
         sbc  $6458                ; 62EA
         bpl  L62F1                ; 62ED
         lda  #$00                 ; 62EF
L62F1
         sta  COLPF1               ; 62F1
         sta  WSYNC                ; 62F4
         iny                       ; 62F7
         cpy  #$08                 ; 62F8
         bne  L62E6                ; 62FA
         ldx  #$09                 ; 62FC
         ldy  #$63                 ; 62FE
         stx  VDSLST               ; 6300
         sty  VDSLST+1             ; 6303
         jmp  XITVBV               ; 6306
irq_6309
         pha                       ; 6309
         txa                       ; 630A
         pha                       ; 630B
         tya                       ; 630C
         pha                       ; 630D
         lda  #$22                 ; 630E
         sta  DMACTL               ; 6310
         ldy  #$00                 ; 6313
L6315
         lda  $63A2,y              ; 6315
         sec                       ; 6318
         sbc  $6458                ; 6319
         bpl  L6322                ; 631C
         lda  #$00                 ; 631E
         beq  L6325                ; 6320
L6322
         clc                       ; 6322
         adc  #$B0                 ; 6323
L6325
         sta  WSYNC                ; 6325
         sta  COLPF0               ; 6328
         iny                       ; 632B
         cpy  #$10                 ; 632C
         bne  L6315                ; 632E
         lda  #$21                 ; 6330
         sta  DMACTL               ; 6332
         ldx  #$42                 ; 6335
         ldy  #$63                 ; 6337
         stx  VDSLST               ; 6339
         sty  VDSLST+1             ; 633C
         jmp  XITVBV               ; 633F
irq_6342
         pha                       ; 6342
         txa                       ; 6343
         pha                       ; 6344
         tya                       ; 6345
         pha                       ; 6346
         ldy  #$00                 ; 6347
         sty  COLPF1               ; 6349
L634C
         lda  $63B2,y              ; 634C
         clc                       ; 634F
         adc  $6459                ; 6350
         sta  WSYNC                ; 6353
         sta  COLPF2               ; 6356
         sta  COLBK                ; 6359
         iny                       ; 635C
         cpy  #$11                 ; 635D
         bne  L634C                ; 635F
         lda  #$00                 ; 6361
         sta  COLPF2               ; 6363
         sta  COLBK                ; 6366
         ldx  #$DF                 ; 6369
         ldy  #$62                 ; 636B
         stx  VDSLST               ; 636D
         sty  VDSLST+1             ; 6370
         jmp  XITVBV               ; 6373

* trainer patch: NOP the two DEC LIVES ($8C4E, $982D) ------
         dta $A9,$EA,$8D,$4E,$8C,$8D,$4F,$8C,$8D,$2D,$98,$8D,$2E,$98,$60 ; 6376
irq_6385
         bvs  L63F7                ; 6385
         bvs  L63F9                ; 6387
         dta $80,$42,$C4,$63,$00,$02,$20,$80,$07,$70,$70,$80,$30,$02,$41,$85 ; 6389
         dta $63,$00,$00,$02,$04,$04,$06,$08,$0A,$00,$00,$02,$04,$08,$0A,$0A ; 6399
         dta $0C,$0C,$0A,$0A,$08,$06,$04,$02,$00,$0A,$0A,$06,$06,$06,$06,$06 ; 63A9
         dta $06,$06,$06,$06,$06,$06,$06,$04,$04,$76,$63,$00,$00,$00,$00,$00 ; 63B9
         dta $00,$00,$00,$00,$1E,$1E,$1E,$23,$21,$2D,$2F,$73,$6F,$66,$74,$1C ; 63C9
         dta $1C,$1C,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 63D9
         dta $00,$00,$00,$00,$00,$00,$00,$70,$72,$65,$73,$65,$6E,$74 ; 63E9
L63F7
         dta $73,$00                                  ; 63F7
L63F9
         brk                       ; 63F9
         dta $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$2A,$21 ; 63FA
         dta $33,$2B,$29,$2E,$29,$2F,$37,$29,$25,$23,$00,$00,$00,$00,$00,$00 ; 640A
         dta $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 641A
         dta $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 642A
         dta $00,$00,$35,$6E,$6C,$69,$6D,$69,$74,$65,$64,$00,$6C,$69,$76,$65 ; 643A
         dta $73,$00,$1F,$00,$00,$3B,$39,$0F,$2E,$3D,$00,$00,$00,$00,$0F,$00 ; 644A
         dta $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 645A
         dta $00,$00,$00,$00,$00,$00                  ; 646A
