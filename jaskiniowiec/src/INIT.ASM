; INIT.ASM - font copy, init tables, variables ($9349-$93C6), table builder
; $9215-$948E

         org $9215

sub_9215
         lda  #$10                 ; 9215
         jsr  entry_F2E4           ; 9217
         lda  #$00                 ; 921A
         ldx  #$18                 ; 921C
         jmp  L924E                ; 921E
L9221
         lda  #$00                 ; 9221
         ldx  #$01                 ; 9223
         jsr  entry_F2E4           ; 9225
         lda  #$00                 ; 9228
         jsr  sub_8A64             ; 922A
         lda  #$00                 ; 922D
         jsr  sub_8A64             ; 922F
         lda  #$00                 ; 9232
         ldx  #$08                 ; 9234
         jmp  L924E                ; 9236
L9239
         lda  #$00                 ; 9239
         ldx  #$01                 ; 923B
         jsr  entry_F2E4           ; 923D
         lda  #$00                 ; 9240
         jsr  sub_8A64             ; 9242
         lda  #$00                 ; 9245
         jsr  sub_8A64             ; 9247
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
         sta  $83                  ; 927A
         rts                       ; 927C
sub_927D
         jsr  sub_8FBF             ; 927D
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
         dta $A9,$00,$01,$A4,$00,$00,$00,$02,$74,$01,$02,$88,$30,$02,$74,$31 ; 929B
         dta $02,$89,$24,$02,$8F,$25,$02,$8A,$83,$00,$D8,$C0,$02,$06,$C2,$02 ; 92AB
         dta $06,$C1,$02,$E8,$C3,$02,$E8,$C4,$02,$10,$C5,$02,$24,$C6,$02,$3A ; 92BB
         dta $C8,$02,$76,$2F,$02,$3E,$6F,$02,$21,$07,$D4,$C8,$1D,$D0,$03,$87 ; 92CB
         dta $00,$B6,$88,$00,$F4,$89,$00,$FA,$8A,$00,$8C,$86,$00,$76,$00,$D2 ; 92DB
         dta $C0                                      ; 92EB
sub_92EC
         jsr  sub_8FB8             ; 92EC
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
         dta $8D,$00,$01,$8F,$00,$00,$4D,$93,$B6,$4E,$93,$70,$4F,$93,$40,$50 ; 930A
         dta $93,$70,$51,$93,$00,$52,$93,$00,$54,$93,$00,$55,$93,$00,$56,$93 ; 931A
         dta $00,$57,$93,$00,$58,$93,$00,$59,$93,$00,$5A,$93,$00,$5B,$93,$00 ; 932A
         dta $A5,$00,$60,$A6,$00,$00,$5C,$93,$01,$A7,$00,$03,$67,$9F,$00,$00 ; 933A
         dta $00,$00,$00,$B6,$70,$40,$70,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 934A
         dta $00,$00,$00,$76,$74,$76,$74,$74,$74,$74,$74,$72,$74,$72,$72,$00 ; 935A
         dta $72,$00,$00,$94,$72,$94,$74,$86,$74,$86,$86,$86,$86,$74,$72,$00 ; 936A
         dta $01,$02,$01,$00,$04,$03,$04,$05,$07,$06,$07,$08,$09,$09,$0A,$0A ; 937A
         dta $0B,$0C,$0D,$00,$00,$00,$00,$00,$00,$00,$00,$00,$FE,$FD,$FD,$FD ; 938A
         dta $FE,$FE,$FE,$FF,$FF,$00,$01,$01,$02,$02,$D8,$E0,$BC,$BE,$74,$89 ; 939A
         dta $D8,$89,$80,$80,$00,$00,$FF,$FF,$01,$01,$00,$01,$02,$03,$00,$01 ; 93AA
         dta $02,$00,$01,$02,$03,$00,$00,$00,$00,$00,$00,$00,$00 ; 93BA
entry_93C7
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
