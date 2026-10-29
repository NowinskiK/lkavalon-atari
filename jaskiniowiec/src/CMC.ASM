; CMC.ASM - CMC music player
; $F2E1-$FAD1

         org $F2E1


* CMC music player: init (+0), command (+3), play (+6) -----
entry_F2E1
         jmp  LFA3B                ; F2E1
entry_F2E4
         jmp  LF344                ; F2E4
entry_F2E7
         jmp  LF59C                ; F2E7
         dta $00,$00,$00,$08,$03,$4C,$C6,$5F,$C2,$07,$00,$C0,$A0,$00,$18,$71 ; F2EA
         dta $47,$FF,$00,$19,$71,$47,$FF,$70,$47,$08,$01,$23,$80,$80,$A0,$FF ; F2FA
         dta $FF,$FF,$00,$00,$00,$10,$C3,$A5,$0C,$45,$45,$00,$30,$00,$40,$00 ; F30A
         dta $C0,$00,$00,$00,$01,$06,$02,$05,$03,$10,$09,$08,$00,$00,$01,$0B ; F31A
         dta $06,$80,$80,$80,$80,$00,$FF,$00,$40,$1B,$2B,$08,$08,$00,$84,$14 ; F32A
         dta $84,$00,$86,$F0,$88,$60,$85,$85,$85,$00  ; F33A
LF344
         sta  $F332                ; F344
         stx  $F333                ; F347
         sty  $F334                ; F34A
         and  #$70                 ; F34D
         lsr                       ; F34F
         lsr                       ; F350
         lsr                       ; F351
         tax                       ; F352
         lda  $F375,x              ; F353
         sta  $F373                ; F356
         lda  $F376,x              ; F359
         sta  $F374                ; F35C
         lda  #$03                 ; F35F
         sta  $D21F                ; F361
         lda  #$01                 ; F364
         sta  $F343                ; F366
         ldy  $F334                ; F369
         ldx  $F333                ; F36C
         lda  $F332                ; F36F
         jmp  L5968                ; F372
         dta $85,$F3,$B0,$F3,$73,$F4,$0F,$F4,$49,$F4,$64,$F4,$6F,$F4,$16,$F4 ; F375
         dta $AD,$3B,$F3,$85,$FC,$AD,$3C,$F3,$85,$FD,$A0,$00,$8A,$F0,$1C,$B1 ; F385
         dta $FC,$C9,$8F,$F0,$04,$C9,$EF,$D0,$0C,$CA,$D0,$09,$C8,$C0,$54,$B0 ; F395
         dta $09,$98,$AA,$10,$06,$C8,$C0,$54,$90,$E5,$60,$8E,$EE,$F2,$A9,$00 ; F3A5
         dta $A2,$02,$9D,$22,$F3,$9D,$25,$F3,$9D,$2B,$F3,$CA,$10,$F4,$8D,$ED ; F3B5
         dta $F2,$8D,$2E,$F3,$A0,$FF,$8C,$30,$F3,$AD,$37,$F3,$85,$FC,$AD,$38 ; F3C5
         dta $F3,$85,$FD,$A0,$13,$B1,$FC,$AA,$AD,$3B,$F3,$85,$FC,$AD,$3C,$F3 ; F3D5
         dta $85,$FD,$AC,$EE,$F2,$B1,$FC,$C9,$CF,$D0,$0D,$98,$18,$69,$55,$A8 ; F3E5
         dta $B1,$FC,$30,$0F,$AA,$4C,$08,$F4,$C9,$8F,$F0,$07,$C9,$EF,$F0,$03 ; F3F5
         dta $88,$10,$E2,$8E,$35,$F3,$8E,$36,$F3,$60,$8E,$35,$F3,$8E,$36,$F3 ; F405
         dta $60,$8E,$37,$F3,$86,$FC,$8C,$38,$F3,$84,$FD,$18,$8A,$69,$14,$8D ; F415
         dta $39,$F3,$98,$69,$00,$8D,$3A,$F3,$18,$8A,$69,$00,$8D,$3B,$F3,$98 ; F425
         dta $69,$02,$8D,$3C,$F3,$A0,$13,$B1,$FC,$8D,$35,$F3,$8D,$36,$F3,$A2 ; F435
         dta $03,$8E,$1F,$D2,$A9,$00,$8D,$43,$F3,$A0,$08,$A9,$00,$99,$00,$D2 ; F445
         dta $C0,$03,$B0,$08,$99,$EA,$F2,$A9,$FF,$99,$09,$F3,$88,$10,$EC,$A9 ; F455
         dta $80,$A2,$03,$9D,$2B,$F3,$CA,$10,$FA,$60,$A9,$00,$F0,$F3,$AD,$32 ; F465
         dta $F3,$29,$03,$AA,$A9,$80,$9D,$2B,$F3,$AC,$34,$F3,$AD,$33,$F3 ; F475
sub_F484
         sta  $F332                ; F484
         sty  $F334                ; F487
         lda  #$00                 ; F48A
         sta  $F312,x              ; F48C
         sta  $F309,x              ; F48F
         sta  $F30C,x              ; F492
         tya                       ; F495
         asl                       ; F496
         asl                       ; F497
         asl                       ; F498
         sta  $FE                  ; F499
         clc                       ; F49B
         lda  $F337                ; F49C
         adc  #$30                 ; F49F
         pha                       ; F4A1
         lda  $F338                ; F4A2
         adc  #$01                 ; F4A5
         tay                       ; F4A7
         pla                       ; F4A8
         clc                       ; F4A9
         adc  $FE                  ; F4AA
         sta  $F33D,x              ; F4AC
         tya                       ; F4AF
         adc  #$00                 ; F4B0
         sta  $F340,x              ; F4B2
         clc                       ; F4B5
         lda  $F337                ; F4B6
         adc  #$94                 ; F4B9
         sta  $FC                  ; F4BB
         lda  $F338                ; F4BD
         adc  #$00                 ; F4C0
         sta  $FD                  ; F4C2
         lda  $F334                ; F4C4
         asl                       ; F4C7
         adc  $F334                ; F4C8
         asl                       ; F4CB
         tay                       ; F4CC
         sty  $F334                ; F4CD
         iny                       ; F4D0
         iny                       ; F4D1
         iny                       ; F4D2
         iny                       ; F4D3
         iny                       ; F4D4
         lda  ($FC),y              ; F4D5
         sta  $F31B,x              ; F4D7
         dey                       ; F4DA
         lda  ($FC),y              ; F4DB
         sta  $F318,x              ; F4DD
         dey                       ; F4E0
         lda  ($FC),y              ; F4E1
         sta  $F315,x              ; F4E3
         dey                       ; F4E6
         dey                       ; F4E7
         lda  ($FC),y              ; F4E8
         sta  $F30F,x              ; F4EA
         ldy  #$00                 ; F4ED
         and  #$07                 ; F4EF
         cmp  #$03                 ; F4F1
         bne  LF4F7                ; F4F3
         ldy  #$02                 ; F4F5
LF4F7
         cmp  #$07                 ; F4F7
         bne  LF4FD                ; F4F9
         ldy  #$04                 ; F4FB
LF4FD
         lda  $F596,y              ; F4FD
         sta  $FE                  ; F500
         lda  $F597,y              ; F502
         sta  $FF                  ; F505
         ldy  $F334                ; F507
         iny                       ; F50A
         iny                       ; F50B
         lda  ($FC),y              ; F50C
         lsr                       ; F50E
         lsr                       ; F50F
         lsr                       ; F510
         lsr                       ; F511
         clc                       ; F512
         adc  $F332                ; F513
         sta  $F332                ; F516
         sta  $F58D                ; F519
         tay                       ; F51C
         lda  $F30F,x              ; F51D
         and  #$07                 ; F520
         cmp  #$07                 ; F522
         bne  LF535                ; F524
         tya                       ; F526
         asl                       ; F527
         tay                       ; F528
         lda  ($FE),y              ; F529
         sta  $F2FD,x              ; F52B
         iny                       ; F52E
         sty  $F332                ; F52F
         jmp  LF54A                ; F532
LF535
         lda  ($FE),y              ; F535
         sta  $F2FD,x              ; F537
         ldy  $F334                ; F53A
         iny                       ; F53D
         iny                       ; F53E
         lda  ($FC),y              ; F53F
         and  #$0F                 ; F541
         clc                       ; F543
         adc  $F332                ; F544
         sta  $F332                ; F547
LF54A
         ldy  $F332                ; F54A
         lda  $F30F,x              ; F54D
         and  #$07                 ; F550
         cmp  #$05                 ; F552
         php                       ; F554
         lda  ($FE),y              ; F555
         plp                       ; F557
         beq  LF562                ; F558
         cmp  $F2FD,x              ; F55A
         bne  LF562                ; F55D
         sec                       ; F55F
         sbc  #$01                 ; F560
LF562
         sta  $F300,x              ; F562
         ldy  $F334                ; F565
         lda  ($FC),y              ; F568
         pha                       ; F56A
         and  #$03                 ; F56B
         tay                       ; F56D
         lda  $FA25,y              ; F56E
         sta  $F306,x              ; F571
         pla                       ; F574
         lsr                       ; F575
         lsr                       ; F576
         lsr                       ; F577
         lsr                       ; F578
         ldy  #$3E                 ; F579
         cmp  #$0F                 ; F57B
         beq  LF58F                ; F57D
         ldy  #$37                 ; F57F
         cmp  #$0E                 ; F581
         beq  LF58F                ; F583
         ldy  #$30                 ; F585
         cmp  #$0D                 ; F587
         beq  LF58F                ; F589
         clc                       ; F58B
         adc  #$32                 ; F58C
         tay                       ; F58E
LF58F
         lda  $F925,y              ; F58F
         sta  $F303,x              ; F592
         rts                       ; F595
         dta $25,$F9,$66,$F9,$A7,$F9                  ; F596
LF59C
         cld                       ; F59C
         lda  $FC                  ; F59D
         pha                       ; F59F
         lda  $FD                  ; F5A0
         pha                       ; F5A2
         lda  $FE                  ; F5A3
         pha                       ; F5A5
         lda  $FF                  ; F5A6
         pha                       ; F5A8
         lda  $F343                ; F5A9
         bne  LF5B1                ; F5AC
         jmp  LF904                ; F5AE
LF5B1
         lda  $F32E                ; F5B1
         beq  LF5B9                ; F5B4
         jmp  LF759                ; F5B6
LF5B9
         lda  $F335                ; F5B9
         cmp  $F336                ; F5BC
         beq  LF5C4                ; F5BF
         jmp  LF746                ; F5C1
LF5C4
         lda  $F2ED                ; F5C4
         beq  LF5CC                ; F5C7
         jmp  LF66C                ; F5C9
LF5CC
         ldx  #$02                 ; F5CC
         lda  #$00                 ; F5CE
LF5D0
         ldy  $F32B,x              ; F5D0
         bmi  LF5D8                ; F5D3
         sta  $F32B,x              ; F5D5
LF5D8
         sta  $F322,x              ; F5D8
         dex                       ; F5DB
         bpl  LF5D0                ; F5DC
         lda  $F33B                ; F5DE
         sta  $FC                  ; F5E1
         lda  $F33C                ; F5E3
         sta  $FD                  ; F5E6
         ldy  $F2EE                ; F5E8
         sty  $F66F                ; F5EB
LF5EE
         cpy  $F330                ; F5EE
         bne  LF60C                ; F5F1
         lda  $F331                ; F5F3
         beq  LF60C                ; F5F6
         lda  $F2EE                ; F5F8
         ldy  $F32F                ; F5FB
         sty  $F2EE                ; F5FE
         dec  $F331                ; F601
         bne  LF5EE                ; F604
         sta  $F2EE                ; F606
         tay                       ; F609
         bpl  LF5EE                ; F60A
LF60C
         ldx  #$00                 ; F60C
LF60E
         lda  ($FC),y              ; F60E
         cmp  #$FE                 ; F610
         beq  LF623                ; F612
         sta  $F31F,x              ; F614
         clc                       ; F617
         tya                       ; F618
         adc  #$55                 ; F619
         tay                       ; F61B
         inx                       ; F61C
         cpx  #$03                 ; F61D
         bcc  LF60E                ; F61F
         bcs  LF632                ; F621
LF623
         ldy  $F2EE                ; F623
         iny                       ; F626
         cpy  $F66F                ; F627
         beq  LF663                ; F62A
         sty  $F2EE                ; F62C
         jmp  LF5EE                ; F62F
LF632
         ldy  $F2EE                ; F632
         lda  ($FC),y              ; F635
         bpl  LF66C                ; F637
         cmp  #$FF                 ; F639
         beq  LF66C                ; F63B
         lsr                       ; F63D
         lsr                       ; F63E
         lsr                       ; F63F
         and  #$0E                 ; F640
         tax                       ; F642
         lda  $F670,x              ; F643
         sta  $F655                ; F646
         lda  $F671,x              ; F649
         sta  $F656                ; F64C
         lda  $F320                ; F64F
         sta  $FE                  ; F652
         jsr  sub_5B73             ; F654
         sty  $F2EE                ; F657
         cpy  #$55                 ; F65A
         bcs  LF663                ; F65C
         cpy  $F66F                ; F65E
         bne  LF5EE                ; F661
LF663
         ldy  $F66F                ; F663
         sty  $F2EE                ; F666
         jmp  LF904                ; F669
LF66C
         jmp  LF6D6                ; F66C
         dta $03,$7E,$F6,$84,$F6,$8A,$F6,$94,$F6,$9E,$F6,$AA,$F6,$C7,$F6,$20 ; F66F
         dta $64,$F4,$A0,$FF,$60,$A5,$FE,$30,$F9,$A8,$60,$A5,$FE,$30,$F3,$38 ; F67F
         dta $98,$E5,$FE,$A8,$60,$A5,$FE,$30,$E9,$18,$98,$65,$FE,$A8,$60,$A5 ; F68F
         dta $FE,$30,$DF,$8D,$35,$F3,$8D,$36,$F3,$C8,$60,$A5,$FE,$30,$D3,$AD ; F69F
         dta $21,$F3,$30,$CE,$C8,$8C,$2F,$F3,$18,$98,$65,$FE,$8D,$30,$F3,$AD ; F6AF
         dta $21,$F3,$8D,$31,$F3,$C0,$54,$60,$88,$30,$0A,$B1,$FC,$C9,$8F,$F0 ; F6BF
         dta $04,$C9,$EF,$D0,$F3,$C8,$60              ; F6CF
LF6D6
         ldx  #$02                 ; F6D6
LF6D8
         lda  $F325,x              ; F6D8
         beq  LF6E2                ; F6DB
         dec  $F325,x              ; F6DD
         bpl  LF739                ; F6E0
LF6E2
         lda  $F32B,x              ; F6E2
         bne  LF739                ; F6E5
         ldy  $F31F,x              ; F6E7
         cmp  #$40                 ; F6EA
         bcs  LF739                ; F6EC
         lda  $F339                ; F6EE
         sta  $FC                  ; F6F1
         lda  $F33A                ; F6F3
         sta  $FD                  ; F6F6
         lda  ($FC),y              ; F6F8
         sta  $FE                  ; F6FA
         clc                       ; F6FC
         tya                       ; F6FD
         adc  #$40                 ; F6FE
         tay                       ; F700
         lda  ($FC),y              ; F701
         sta  $FF                  ; F703
LF705
         ldy  $F322,x              ; F705
         lda  ($FE),y              ; F708
         and  #$C0                 ; F70A
         bne  LF71A                ; F70C
         lda  ($FE),y              ; F70E
         and  #$3F                 ; F710
         sta  $F328,x              ; F712
         inc  $F322,x              ; F715
         bpl  LF705                ; F718
LF71A
         cmp  #$40                 ; F71A
         bne  LF72B                ; F71C
         lda  ($FE),y              ; F71E
         and  #$3F                 ; F720
         ldy  $F328,x              ; F722
         jsr  sub_F484             ; F725
         jmp  LF736                ; F728
LF72B
         cmp  #$80                 ; F72B
         bne  LF739                ; F72D
         lda  ($FE),y              ; F72F
         and  #$3F                 ; F731
         sta  $F325,x              ; F733
LF736
         inc  $F322,x              ; F736
LF739
         dex                       ; F739
         bpl  LF6D8                ; F73A
         ldx  $F2ED                ; F73C
         inx                       ; F73F
         txa                       ; F740
         and  #$3F                 ; F741
         sta  $F2ED                ; F743
LF746
         dec  $F336                ; F746
         bne  LF759                ; F749
         lda  $F335                ; F74B
         sta  $F336                ; F74E
         lda  $F2ED                ; F751
         bne  LF759                ; F754
         inc  $F2EE                ; F756
LF759
         ldy  $F300                ; F759
         lda  $F30F                ; F75C
         and  #$07                 ; F75F
         cmp  #$05                 ; F761
         beq  LF769                ; F763
         cmp  #$06                 ; F765
         bne  LF76A                ; F767
LF769
         dey                       ; F769
LF76A
         sty  $F2FB                ; F76A
         ldy  #$00                 ; F76D
         cmp  #$05                 ; F76F
         beq  LF777                ; F771
         cmp  #$06                 ; F773
         bne  LF779                ; F775
LF777
         ldy  #$02                 ; F777
LF779
         cmp  #$07                 ; F779
         bne  LF77F                ; F77B
         ldy  #$28                 ; F77D
LF77F
         sty  $F2FC                ; F77F
         ldx  #$02                 ; F782
LF784
         lda  $F30F,x              ; F784
         and  #$E0                 ; F787
         sta  $F2F4,x              ; F789
         lda  $F33D,x              ; F78C
         sta  $FC                  ; F78F
         lda  $F340,x              ; F791
         sta  $FD                  ; F794
         lda  $F309,x              ; F796
         cmp  #$FF                 ; F799
         beq  LF7D4                ; F79B
         cmp  #$0F                 ; F79D
         bne  LF7C2                ; F79F
         lda  $F30C,x              ; F7A1
         beq  LF7D4                ; F7A4
         dec  $F30C,x              ; F7A6
         lda  $F30C,x              ; F7A9
         bne  LF7D4                ; F7AC
         ldy  $F2EA,x              ; F7AE
         beq  LF7B4                ; F7B1
         dey                       ; F7B3
LF7B4
         tya                       ; F7B4
         sta  $F2EA,x              ; F7B5
         lda  $F315,x              ; F7B8
         sta  $F30C,x              ; F7BB
         dey                       ; F7BE
         jmp  LF7D4                ; F7BF
LF7C2
         lda  $F309,x              ; F7C2
         lsr                       ; F7C5
         tay                       ; F7C6
         lda  ($FC),y              ; F7C7
         bcc  LF7CF                ; F7C9
         lsr                       ; F7CB
         lsr                       ; F7CC
         lsr                       ; F7CD
         lsr                       ; F7CE
LF7CF
         and  #$0F                 ; F7CF
         sta  $F2EA,x              ; F7D1
LF7D4
         ldy  $F2FD,x              ; F7D4
         lda  $F30F,x              ; F7D7
         and  #$07                 ; F7DA
         cmp  #$01                 ; F7DC
         bne  LF7FF                ; F7DE
         dey                       ; F7E0
         tya                       ; F7E1
         iny                       ; F7E2
         cmp  $F300,x              ; F7E3
         php                       ; F7E6
         lda  #$01                 ; F7E7
         plp                       ; F7E9
         bne  LF7EE                ; F7EA
         asl                       ; F7EC
         asl                       ; F7ED
LF7EE
         and  $F312,x              ; F7EE
         beq  LF7FF                ; F7F1
         ldy  $F300,x              ; F7F3
         cpy  #$FF                 ; F7F6
         bne  LF7FF                ; F7F8
         lda  #$00                 ; F7FA
         sta  $F2EA,x              ; F7FC
LF7FF
         tya                       ; F7FF
         sta  $F2F8,x              ; F800
         lda  #$01                 ; F803
         sta  $F31E                ; F805
         lda  $F309,x              ; F808
         cmp  #$0F                 ; F80B
         beq  LF847                ; F80D
         and  #$07                 ; F80F
         tay                       ; F811
         lda  $FA31,y              ; F812
         sta  $FE                  ; F815
         lda  $F309,x              ; F817
         and  #$08                 ; F81A
         php                       ; F81C
         txa                       ; F81D
         plp                       ; F81E
         clc                       ; F81F
         beq  LF824                ; F820
         adc  #$03                 ; F822
LF824
         tay                       ; F824
         lda  $F318,y              ; F825
         and  $FE                  ; F828
         beq  LF847                ; F82A
         lda  $F303,x              ; F82C
         sta  $F2F8,x              ; F82F
         stx  $F31E                ; F832
         dex                       ; F835
         bpl  LF840                ; F836
         sta  $F2FB                ; F838
         lda  #$00                 ; F83B
         sta  $F2FC                ; F83D
LF840
         inx                       ; F840
         lda  $F306,x              ; F841
         sta  $F2F4,x              ; F844
LF847
         lda  $F309,x              ; F847
         and  #$0F                 ; F84A
         cmp  #$0F                 ; F84C
         beq  LF862                ; F84E
         inc  $F309,x              ; F850
         lda  $F309,x              ; F853
         and  #$0F                 ; F856
         cmp  #$0F                 ; F858
         bne  LF862                ; F85A
         lda  $F315,x              ; F85C
         sta  $F30C,x              ; F85F
LF862
         lda  $F32B,x              ; F862
         bpl  LF871                ; F865
         lda  $F2EA,x              ; F867
         bne  LF871                ; F86A
         lda  #$40                 ; F86C
         sta  $F32B,x              ; F86E
LF871
         inc  $F312,x              ; F871
         ldy  #$00                 ; F874
         lda  $F30F,x              ; F876
         lsr                       ; F879
         lsr                       ; F87A
         lsr                       ; F87B
         lsr                       ; F87C
         bcc  LF880                ; F87D
         dey                       ; F87F
LF880
         lsr                       ; F880
         bcc  LF884                ; F881
         iny                       ; F883
LF884
         clc                       ; F884
         tya                       ; F885
         adc  $F2FD,x              ; F886
         sta  $F2FD,x              ; F889
         lda  $F300,x              ; F88C
         cmp  #$FF                 ; F88F
         bne  LF895                ; F891
         ldy  #$00                 ; F893
LF895
         clc                       ; F895
         tya                       ; F896
         adc  $F300,x              ; F897
         sta  $F300,x              ; F89A
         dex                       ; F89D
         bmi  LF8A3                ; F89E
         jmp  LF784                ; F8A0
LF8A3
         lda  $F2F4                ; F8A3
         sta  $F2F7                ; F8A6
         lda  $F30F                ; F8A9
         and  #$07                 ; F8AC
         ldy  #$03                 ; F8AE
         ldx  $F31E                ; F8B0
         beq  LF8CD                ; F8B3
         cmp  #$04                 ; F8B5
         bne  LF8BB                ; F8B7
         ldy  #$07                 ; F8B9
LF8BB
         cmp  #$05                 ; F8BB
         bne  LF8C1                ; F8BD
         ldy  #$0B                 ; F8BF
LF8C1
         cmp  #$06                 ; F8C1
         bne  LF8C7                ; F8C3
         ldy  #$0F                 ; F8C5
LF8C7
         cmp  #$07                 ; F8C7
         bne  LF8CD                ; F8C9
         ldy  #$13                 ; F8CB
LF8CD
         tya                       ; F8CD
         pha                       ; F8CE
         lda  $F911,y              ; F8CF
         php                       ; F8D2
         and  #$7F                 ; F8D3
         tax                       ; F8D5
         tya                       ; F8D6
         and  #$03                 ; F8D7
         asl                       ; F8D9
         tay                       ; F8DA
         lda  $F2F8,x              ; F8DB
         sta  AUDF1,y              ; F8DE
         lda  $F2EA,x              ; F8E1
         cpx  #$03                 ; F8E4
         bne  LF8EB                ; F8E6
         lda  $F2EA                ; F8E8
LF8EB
         ora  $F2F4,x              ; F8EB
         plp                       ; F8EE
         bpl  LF8F3                ; F8EF
         lda  #$00                 ; F8F1
LF8F3
         sta  AUDC1,y              ; F8F3
         pla                       ; F8F6
         tay                       ; F8F7
         dey                       ; F8F8
         and  #$03                 ; F8F9
         bne  LF8CD                ; F8FB
         lda  $F2FC                ; F8FD
         sta  AUDCTL               ; F900
         clc                       ; F903
LF904
         pla                       ; F904
         sta  $FF                  ; F905
         pla                       ; F907
         sta  $FE                  ; F908
         pla                       ; F90A
         sta  $FD                  ; F90B
         pla                       ; F90D
         sta  $FC                  ; F90E
         rts                       ; F910
         dta $00,$01,$02,$83,$00,$01,$02,$03,$01,$00,$02,$83,$01,$00,$02,$03 ; F911
         dta $01,$02,$80,$03,$FF,$F1,$E4,$D7,$CB,$C0,$B5,$AA,$A1,$98,$8F,$87 ; F921
         dta $7F,$78,$72,$6B,$65,$5F,$5A,$55,$50,$4B,$47,$43,$3F,$3C,$38,$35 ; F931
         dta $32,$2F,$2C,$2A,$27,$25,$23,$21,$1F,$1D,$1C,$1A,$18,$17,$16,$14 ; F941
         dta $13,$12,$11,$10,$0F,$0E,$0D,$0C,$0B,$0A,$09,$08,$07,$06,$05,$04 ; F951
         dta $03,$02,$01,$00,$00,$00,$00,$00,$00,$F2,$E9,$DA,$CE,$BF,$B6,$AA ; F961
         dta $A1,$98,$8F,$89,$80,$7A,$71,$6B,$65,$5F,$5C,$56,$50,$4D,$47,$44 ; F971
         dta $41,$3E,$38,$35,$88,$7F,$79,$73,$6C,$67,$60,$5A,$55,$51,$4C,$48 ; F981
         dta $43,$3F,$3D,$39,$34,$33,$30,$2D,$2A,$28,$25,$24,$21,$1F,$1E,$05 ; F991
         dta $04,$03,$02,$01,$00,$00,$38,$0B,$8C,$0A,$00,$0A,$6A,$09,$E8,$08 ; F9A1
         dta $6A,$08,$EF,$07,$80,$07,$08,$07,$AE,$06,$46,$06,$E6,$05,$95,$05 ; F9B1
         dta $41,$05,$F6,$04,$B0,$04,$6E,$04,$30,$04,$F6,$03,$BB,$03,$84,$03 ; F9C1
         dta $52,$03,$22,$03,$F4,$02,$C8,$02,$A0,$02,$7A,$02,$55,$02,$34,$02 ; F9D1
         dta $14,$02,$F5,$01,$D8,$01,$BD,$01,$A4,$01,$8D,$01,$77,$01,$60,$01 ; F9E1
         dta $4E,$01,$38,$01,$27,$01,$15,$01,$06,$01,$F7,$00,$E8,$00,$DB,$00 ; F9F1
         dta $CF,$00,$C3,$00,$B8,$00,$AC,$00,$A2,$00,$9A,$00,$90,$00,$88,$00 ; FA01
         dta $7F,$00,$78,$00,$70,$00,$6A,$00,$64,$00,$5E,$00,$57,$00,$52,$00 ; FA11
         dta $32,$00,$0A,$00,$80,$A0,$20,$40,$00,$01,$35,$3F,$00,$80,$80,$A0 ; FA21
         dta $80,$40,$20,$10,$08,$04,$02,$01,$98,$FA  ; FA31
LFA3B
         pla                       ; FA3B
         tax                       ; FA3C
         beq  LFA81                ; FA3D
         cmp  #$02                 ; FA3F
         beq  LFA49                ; FA41
LFA43
         pla                       ; FA43
         pla                       ; FA44
         dex                       ; FA45
         bne  LFA43                ; FA46
         rts                       ; FA48
LFA49
         lda  RTCLOK+2             ; FA49
LFA4B
         cmp  RTCLOK+2             ; FA4B
         beq  LFA4B                ; FA4D
         lda  VVBLKD               ; FA4F
         sta  $FAA1                ; FA52
         lda  VVBLKD+1             ; FA55
         sta  $FAA2                ; FA58
         lda  $FA39                ; FA5B
         sta  VVBLKD               ; FA5E
         lda  $FA3A                ; FA61
         sta  VVBLKD+1             ; FA64
         pla                       ; FA67
         pla                       ; FA68
         beq  LFA6E                ; FA69
         sec                       ; FA6B
         sbc  #$01                 ; FA6C
LFA6E
         sta  $FA7D                ; FA6E
         pla                       ; FA71
         tay                       ; FA72
         pla                       ; FA73
         tax                       ; FA74
         lda  #$70                 ; FA75
         jsr  LF344                ; FA77
         lda  #$00                 ; FA7A
         ldx  #$9B                 ; FA7C
         jmp  LF344                ; FA7E
LFA81
         lda  RTCLOK+2             ; FA81
LFA83
         cmp  RTCLOK+2             ; FA83
         beq  LFA83                ; FA85
         lda  $FAA1                ; FA87
         sta  VVBLKD               ; FA8A
         lda  $FAA2                ; FA8D
         sta  VVBLKD+1             ; FA90
         lda  #$40                 ; FA93
         jmp  LF344                ; FA95
         dta $20,$9C,$F5,$90,$03,$20,$87,$FA,$4C,$BF,$5F,$A0,$00,$B9,$F4,$BE ; FA98
         dta $99,$00,$F4,$C8,$D0,$F7,$EE,$AA,$C5,$EE,$AD,$C5,$AD,$AA,$C5,$C9 ; FAA8
         dta $BE,$D0,$EA,$B9,$E4,$C4,$99,$E1,$F9,$C8,$D0,$F7,$EE,$C0,$C5,$EE ; FAB8
         dta $C3,$C5,$AD,$C0,$C5,$C9,$C6,$D0,$EA,$60  ; FAC8
