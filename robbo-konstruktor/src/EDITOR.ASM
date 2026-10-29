; EDITOR.ASM - editor: menu dispatch, cursor, commands
; $94E0-$9F7A

         org $94E0

sub_94E0
         jmp  L9541                ; 94E0
sub_94E3
         jmp  L9D78                ; 94E3
sub_94E6
         jmp  L9DBC                ; 94E6
sub_94E9
         jmp  L9D02                ; 94E9
sub_94EC
         jmp  L9BB1                ; 94EC
sub_94EF
         jmp  L9CDD                ; 94EF
sub_94F2
         jmp  L9F74                ; 94F2
sub_94F5
         jmp  L9571                ; 94F5
         dta $00,$01,$02,$04,$08,$10,$10,$70,$42,$78,$BD,$02,$42,$78,$BD,$02 ; 94F8
         dta $02,$42,$78,$BD,$02,$02,$42,$78,$BD,$02,$02,$42,$78,$BD,$02,$02 ; 9508
         dta $42,$78,$BD,$02,$02,$42,$78,$BD,$02,$02,$20,$4F,$50,$BD,$0F,$0F ; 9518
         dta $42,$00,$BC,$02,$02,$02,$02,$4F,$00,$BD,$0F,$0F,$0F,$0F,$42,$C8 ; 9528
         dta $BC,$4F,$00,$BD,$0F,$0F,$41,$FE,$94      ; 9538
L9541
         jsr  sub_94E6             ; 9541
         jsr  entry_A819           ; 9544
         bcs  L954D                ; 9547
         cmp  #$11                 ; 9549
         beq  sub_94F5             ; 954B
L954D
         lda  $CA                  ; 954D
         bmi  L9570                ; 954F
         jsr  sub_9E18             ; 9551
         jsr  $9554                ; 9554
         php                       ; 9557
         lda  #$FF                 ; 9558
         cmp  $A840                ; 955A
         beq  L9562                ; 955D
         sta  $A840                ; 955F
L9562
         plp                       ; 9562
         bcs  L9566                ; 9563
         rts                       ; 9565
L9566
         lda  #$82                 ; 9566
         sta  $9555                ; 9568
         lda  #$95                 ; 956B
         sta  $9556                ; 956D
L9570
         rts                       ; 9570
L9571
         lda  #$00                 ; 9571
         sta  $962E                ; 9573
         sta  AUDF1                ; 9576
         sta  AUDC1                ; 9579
         lda  $94F8                ; 957C
         jmp  entry_0800           ; 957F
irq_9582
         lda  #$02                 ; 9582
         sta  $CE                  ; 9584
         lda  $CB                  ; 9586
         and  #$7F                 ; 9588
         tax                       ; 958A
         ldy  $9FB6,x              ; 958B
         ldx  #$14                 ; 958E
L9590
         lda  $BC00,y              ; 9590
         ora  #$80                 ; 9593
         sta  $BC00,y              ; 9595
         iny                       ; 9598
         dex                       ; 9599
         bne  L9590                ; 959A
         lda  #$00                 ; 959C
         jsr  sub_94E9             ; 959E
         jsr  entry_A816           ; 95A1
         bne  L95C3                ; 95A4
         lda  $CB                  ; 95A6
         asl                       ; 95A8
         bcc  L95AD                ; 95A9
         adc  #$09                 ; 95AB
L95AD
         tax                       ; 95AD
         lda  $9F8E,x              ; 95AE
         sta  $9555                ; 95B1
         lda  $9F8F,x              ; 95B4
         sta  $9556                ; 95B7
         txa                       ; 95BA
         lsr                       ; 95BB
         adc  #$03                 ; 95BC
         sta  $CE                  ; 95BE
         jsr  entry_A813           ; 95C0
L95C3
         jsr  sub_95D5             ; 95C3
         bcs  L95CF                ; 95C6
         jsr  entry_A82B           ; 95C8
         bcc  L95CF                ; 95CB
         clc                       ; 95CD
         rts                       ; 95CE
L95CF
         jsr  entry_A813           ; 95CF
         jmp  L961D                ; 95D2
sub_95D5
         lda  $CB                  ; 95D5
         and  #$7F                 ; 95D7
         tax                       ; 95D9
         lda  $A840                ; 95DA
         tay                       ; 95DD
         and  #$01                 ; 95DE
         bne  L95EF                ; 95E0
         dex                       ; 95E2
         bpl  L95EF                ; 95E3
         inx                       ; 95E5
         lda  #$01                 ; 95E6
         jsr  entry_A825           ; 95E8
         bcs  L95EF                ; 95EB
         sec                       ; 95ED
         rts                       ; 95EE
L95EF
         tya                       ; 95EF
         and  #$02                 ; 95F0
         bne  L95FA                ; 95F2
         inx                       ; 95F4
         cpx  #$05                 ; 95F5
         bcc  L95FA                ; 95F7
         dex                       ; 95F9
L95FA
         txa                       ; 95FA
         pha                       ; 95FB
         ldx  $CD                  ; 95FC
         jsr  sub_9674             ; 95FE
         txa                       ; 9601
         tay                       ; 9602
         pla                       ; 9603
         tax                       ; 9604
         txa                       ; 9605
         bit  $CB                  ; 9606
         bpl  L960C                ; 9608
         ora  #$80                 ; 960A
L960C
         cmp  $CB                  ; 960C
         bne  L9614                ; 960E
         cpy  $CD                  ; 9610
         beq  L961B                ; 9612
L9614
         sta  $CB                  ; 9614
         sty  $CD                  ; 9616
         jsr  entry_A813           ; 9618
L961B
         clc                       ; 961B
         rts                       ; 961C
L961D
         jsr  sub_9E18             ; 961D
         lda  #$80                 ; 9620
         sta  $CA                  ; 9622
         sec                       ; 9624
         rts                       ; 9625
entry_9626
         lda  $CB                  ; 9626
         eor  #$80                 ; 9628
         sta  $CB                  ; 962A
         sec                       ; 962C
         rts                       ; 962D
         dta $00                                      ; 962E
L962F
         jsr  sub_94E9             ; 962F
         lda  #$0A                 ; 9632
         sta  $962E                ; 9634
         lda  #$43                 ; 9637
         sta  $9555                ; 9639
         lda  #$96                 ; 963C
         sta  $9556                ; 963E
         clc                       ; 9641
         rts                       ; 9642
irq_9643
         lda  $962E                ; 9643
         ora  #$C0                 ; 9646
         sta  AUDC1                ; 9648
         lda  #$55                 ; 964B
         sta  AUDF1                ; 964D
         lda  $962E                ; 9650
         beq  L9658                ; 9653
         dec  $962E                ; 9655
L9658
         jsr  entry_A816           ; 9658
         beq  L966B                ; 965B
         jsr  entry_A82B           ; 965D
         bcc  L966B                ; 9660
         lda  $A840                ; 9662
         cmp  #$FF                 ; 9665
         bne  L966B                ; 9667
         clc                       ; 9669
         rts                       ; 966A
L966B
         jsr  entry_A813           ; 966B
         lda  #$00                 ; 966E
         sta  $CF                  ; 9670
         sec                       ; 9672
         rts                       ; 9673
sub_9674
         lda  $A840                ; 9674
         and  #$04                 ; 9677
         bne  L9680                ; 9679
         dex                       ; 967B
         bpl  L9680                ; 967C
         ldx  #$1F                 ; 967E
L9680
         lda  $A840                ; 9680
         and  #$08                 ; 9683
         bne  L968E                ; 9685
         inx                       ; 9687
         cpx  #$20                 ; 9688
         bcc  L968E                ; 968A
         ldx  #$00                 ; 968C
L968E
         rts                       ; 968E
entry_968F
         lda  $A317                ; 968F
         cmp  #$02                 ; 9692
         bne  L96C2                ; 9694
         ldy  #$FF                 ; 9696
L9698
         iny                       ; 9698
         lda  $BCC8,y              ; 9699
         beq  L9698                ; 969C
         tya                       ; 969E
         pha                       ; 969F
         ldx  #$06                 ; 96A0
L96A2
         lda  $BCC8,y              ; 96A2
         and  #$7F                 ; 96A5
         sta  $BCC8,y              ; 96A7
         iny                       ; 96AA
         dex                       ; 96AB
         bne  L96A2                ; 96AC
         clc                       ; 96AE
         pla                       ; 96AF
         adc  $9F8C                ; 96B0
         tay                       ; 96B3
         lda  $C4                  ; 96B4
         and  #$02                 ; 96B6
         beq  L96BC                ; 96B8
         lda  #$80                 ; 96BA
L96BC
         ora  $BCC8,y              ; 96BC
         sta  $BCC8,y              ; 96BF
L96C2
         lda  $9F8D                ; 96C2
         bne  L9719                ; 96C5
         lda  #$02                 ; 96C7
         jsr  sub_94E9             ; 96C9
         jsr  entry_A82B           ; 96CC
         bcc  L96DE                ; 96CF
         lda  $A840                ; 96D1
         tax                       ; 96D4
         and  #$01                 ; 96D5
         beq  L96DE                ; 96D7
         txa                       ; 96D9
         and  #$02                 ; 96DA
         bne  L96E3                ; 96DC
L96DE
         jsr  entry_A813           ; 96DE
         sec                       ; 96E1
         rts                       ; 96E2
L96E3
         jsr  entry_A816           ; 96E3
         bne  L96F0                ; 96E6
         jsr  entry_A813           ; 96E8
         inc  $9F8D                ; 96EB
         clc                       ; 96EE
         rts                       ; 96EF
L96F0
         ldx  $9F8C                ; 96F0
         lda  $A840                ; 96F3
         pha                       ; 96F6
         and  #$04                 ; 96F7
         bne  L9700                ; 96F9
         dex                       ; 96FB
         bpl  L9700                ; 96FC
         ldx  #$05                 ; 96FE
L9700
         pla                       ; 9700
         and  #$08                 ; 9701
         bne  L970C                ; 9703
         inx                       ; 9705
         cpx  #$06                 ; 9706
         bcc  L970C                ; 9708
         ldx  #$00                 ; 970A
L970C
         cpx  $9F8C                ; 970C
         beq  L9717                ; 970F
         stx  $9F8C                ; 9711
         jsr  entry_A813           ; 9714
L9717
         clc                       ; 9717
         rts                       ; 9718
L9719
         lda  #$03                 ; 9719
         jsr  sub_94E9             ; 971B
         ldx  $9F8C                ; 971E
         lda  $9F7D,x              ; 9721
         tay                       ; 9724
         pha                       ; 9725
         and  #$0F                 ; 9726
         sta  $B6                  ; 9728
         pla                       ; 972A
         and  #$F0                 ; 972B
         sta  $B7                  ; 972D
         lda  $A840                ; 972F
         and  #$04                 ; 9732
         bne  L9740                ; 9734
         sec                       ; 9736
         lda  $B6                  ; 9737
         sbc  #$02                 ; 9739
         and  #$0F                 ; 973B
         ora  $B7                  ; 973D
         tay                       ; 973F
L9740
         lda  $A840                ; 9740
         and  #$08                 ; 9743
         bne  L9751                ; 9745
         clc                       ; 9747
         lda  $B6                  ; 9748
         adc  #$02                 ; 974A
         and  #$0F                 ; 974C
         ora  $B7                  ; 974E
         tay                       ; 9750
L9751
         lda  $A840                ; 9751
         and  #$02                 ; 9754
         bne  L9762                ; 9756
         sec                       ; 9758
         lda  $B7                  ; 9759
         sbc  #$10                 ; 975B
         and  #$F0                 ; 975D
         ora  $B6                  ; 975F
         tay                       ; 9761
L9762
         lda  $A840                ; 9762
         and  #$01                 ; 9765
         bne  L9773                ; 9767
         clc                       ; 9769
         lda  $B7                  ; 976A
         adc  #$10                 ; 976C
         and  #$F0                 ; 976E
         ora  $B6                  ; 9770
         tay                       ; 9772
L9773
         tya                       ; 9773
         cmp  $9F7D,x              ; 9774
         beq  L977F                ; 9777
         sta  $9F7D,x              ; 9779
         jsr  entry_A813           ; 977C
L977F
         jsr  sub_9E04             ; 977F
         jsr  entry_A816           ; 9782
         bne  L978D                ; 9785
         jsr  entry_A813           ; 9787
         dec  $9F8D                ; 978A
L978D
         jsr  entry_A82B           ; 978D
         bcc  L9794                ; 9790
         clc                       ; 9792
         rts                       ; 9793
L9794
         lda  #$00                 ; 9794
         sta  $9F8D                ; 9796
         jsr  entry_A813           ; 9799
         sec                       ; 979C
         rts                       ; 979D
entry_979E
         ldx  $CD                  ; 979E
         lda  $39A0,x              ; 97A0
         bne  L97A7                ; 97A3
         lda  #$8B                 ; 97A5
L97A7
         bpl  L97AE                ; 97A7
         and  #$7F                 ; 97A9
         jmp  L962F                ; 97AB
L97AE
         lda  #$80                 ; 97AE
         sta  $35C1                ; 97B0
         sta  IRQEN                ; 97B3
         jsr  entry_1E00           ; 97B6
         lda  $CD                  ; 97B9
         asl                       ; 97BB
         adc  #$50                 ; 97BC
         ldx  $CD                  ; 97BE
         inx                       ; 97C0
         ldy  #$FF                 ; 97C1
         jsr  entry_1E03           ; 97C3
         jmp  entry_A810           ; 97C6
entry_97C9
         lda  #$09                 ; 97C9
         jsr  sub_94E9             ; 97CB
         jsr  entry_A831           ; 97CE
         bcc  L97D5                ; 97D1
         clc                       ; 97D3
         rts                       ; 97D4
L97D5
         cmp  #$79                 ; 97D5
         beq  sub_97DB             ; 97D7
         sec                       ; 97D9
         rts                       ; 97DA
sub_97DB
         lda  $CD                  ; 97DB
         asl                       ; 97DD
         adc  #$50                 ; 97DE
         sta  $B3                  ; 97E0
         adc  #$01                 ; 97E2
         sta  $B1                  ; 97E4
         lda  #$00                 ; 97E6
         sta  $B2                  ; 97E8
         sta  $B0                  ; 97EA
         ldy  #$00                 ; 97EC
         lda  #$20                 ; 97EE
L97F0
         sta  ($B2),y              ; 97F0
         cpy  #$F0                 ; 97F2
         bcs  L97F8                ; 97F4
         sta  ($B0),y              ; 97F6
L97F8
         dey                       ; 97F8
         bne  L97F0                ; 97F9
         ldx  #$07                 ; 97FB
         ldy  #$F7                 ; 97FD
L97FF
         lda  $9F83,x              ; 97FF
         sta  ($B0),y              ; 9802
         dey                       ; 9804
         dex                       ; 9805
         bpl  L97FF                ; 9806
         ldx  $CD                  ; 9808
         lda  #$00                 ; 980A
         sta  $39A0,x              ; 980C
         sec                       ; 980F
         rts                       ; 9810
         dta $00,$00,$00                              ; 9811
entry_9814
         lda  $CF                  ; 9814
         bne  L9836                ; 9816
         lda  $CD                  ; 9818
         sta  $998A                ; 981A
         ldx  $9874                ; 981D
         bmi  L9827                ; 9820
         sta  $9812                ; 9822
         bpl  L9836                ; 9825
L9827
         ldx  $9812                ; 9827
         lda  $39C0,x              ; 982A
         bmi  L9836                ; 982D
         lda  #$01                 ; 982F
         sta  $9874                ; 9831
         bne  entry_9814           ; 9834
L9836
         inc  $9811                ; 9836
         ldx  #$1F                 ; 9839
L983B
         lda  #$59                 ; 983B
         ldy  $39A0,x              ; 983D
         bpl  L9846                ; 9840
         lda  #$5B                 ; 9842
         bne  L984A                ; 9844
L9846
         beq  L984A                ; 9846
         lda  #$5A                 ; 9848
L984A
         sta  $A116,x              ; 984A
         lda  #$00                 ; 984D
         lda  $39C0,x              ; 984F
         bpl  L9866                ; 9852
         and  #$7F                 ; 9854
         tay                       ; 9856
         lda  $39A0,y              ; 9857
         beq  L9866                ; 985A
         bpl  L9862                ; 985C
         lda  #$5B                 ; 985E
         bne  L986D                ; 9860
L9862
         lda  #$5A                 ; 9862
         bne  L986D                ; 9864
L9866
         lda  #$00                 ; 9866
         sta  $39C0,x              ; 9868
         lda  #$59                 ; 986B
L986D
         sta  $A13E,x              ; 986D
         dex                       ; 9870
         bpl  L983B                ; 9871
         ldx  #$01                 ; 9873
         bmi  L98E2                ; 9875
         ldx  $9812                ; 9877
         lda  $9811                ; 987A
         and  #$04                 ; 987D
         bne  L9884                ; 987F
         sta  $A116,x              ; 9881
L9884
         stx  $CD                  ; 9884
         inx                       ; 9886
         txa                       ; 9887
         jsr  entry_A82E           ; 9888
         sta  $A112                ; 988B
         stx  $A113                ; 988E
         lda  $CF                  ; 9891
         beq  L98AB                ; 9893
         ldy  #$7E                 ; 9895
         ldx  #$1F                 ; 9897
L9899
         lda  $39C0,x              ; 9899
         eor  #$80                 ; 989C
         bmi  L98A8                ; 989E
         cmp  $CD                  ; 98A0
         bne  L98A8                ; 98A2
         tya                       ; 98A4
         sta  $BCA7,x              ; 98A5
L98A8
         dex                       ; 98A8
         bpl  L9899                ; 98A9
L98AB
         jsr  sub_999E             ; 98AB
         lda  #$0C                 ; 98AE
         jsr  sub_94E9             ; 98B0
         lda  $A840                ; 98B3
         pha                       ; 98B6
         and  #$02                 ; 98B7
         bne  L98C2                ; 98B9
         sec                       ; 98BB
         ror  $9874                ; 98BC
         jsr  entry_A813           ; 98BF
L98C2
         pla                       ; 98C2
         and  #$01                 ; 98C3
         bne  L98D1                ; 98C5
         lda  #$01                 ; 98C7
         jsr  entry_A825           ; 98C9
         bcs  L98D1                ; 98CC
         jmp  L9985                ; 98CE
L98D1
         jsr  entry_A816           ; 98D1
         bne  L98DF                ; 98D4
         lda  $9812                ; 98D6
         sta  $9813                ; 98D9
         jsr  entry_A813           ; 98DC
L98DF
         jmp  L9964                ; 98DF
L98E2
         lda  $CF                  ; 98E2
         beq  L9902                ; 98E4
         ldx  $9812                ; 98E6
         lda  $9811                ; 98E9
         and  #$04                 ; 98EC
         bne  L98F3                ; 98EE
         sta  $A13E,x              ; 98F0
L98F3
         lda  $39C0,x              ; 98F3
         eor  #$80                 ; 98F6
         sta  $CD                  ; 98F8
         bmi  L9902                ; 98FA
         tay                       ; 98FC
         lda  #$7F                 ; 98FD
         sta  $BC2F,y              ; 98FF
L9902
         jsr  sub_999E             ; 9902
         ldy  #$00                 ; 9905
         ldx  #$00                 ; 9907
L9909
         cpx  $9812                ; 9909
         bcs  L9917                ; 990C
         lda  $39C0,x              ; 990E
         bpl  L9914                ; 9911
         iny                       ; 9913
L9914
         inx                       ; 9914
         bpl  L9909                ; 9915
L9917
         iny                       ; 9917
         tya                       ; 9918
         jsr  entry_A82E           ; 9919
         bit  $CD                  ; 991C
         bpl  L9923                ; 991E
         lda  #$0D                 ; 9920
         tax                       ; 9922
L9923
         sta  $A13A                ; 9923
         stx  $A13B                ; 9926
         lda  #$0D                 ; 9929
         jsr  sub_94E9             ; 992B
         lda  $A840                ; 992E
         pha                       ; 9931
         and  #$01                 ; 9932
         bne  L993E                ; 9934
         lda  #$01                 ; 9936
         sta  $9874                ; 9938
         jsr  entry_A813           ; 993B
L993E
         pla                       ; 993E
         and  #$02                 ; 993F
         bne  L994A                ; 9941
         lda  #$02                 ; 9943
         jsr  entry_A825           ; 9945
         bcc  L9985                ; 9948
L994A
         jsr  entry_A816           ; 994A
         bne  L9964                ; 994D
         lda  $9813                ; 994F
         eor  #$80                 ; 9952
         ldx  $9812                ; 9954
         cmp  $39C0,x              ; 9957
         bne  L995E                ; 995A
         lda  #$00                 ; 995C
L995E
         sta  $39C0,x              ; 995E
         jsr  entry_A813           ; 9961
L9964
         lda  #$01                 ; 9964
         sta  $CF                  ; 9966
         ldx  $9812                ; 9968
         jsr  sub_9674             ; 996B
         cpx  $9812                ; 996E
         beq  L997E                ; 9971
         stx  $9812                ; 9973
         lda  #$00                 ; 9976
         sta  $9811                ; 9978
         jsr  entry_A813           ; 997B
L997E
         jsr  entry_A82B           ; 997E
         bcc  L9985                ; 9981
         clc                       ; 9983
         rts                       ; 9984
L9985
         lda  #$00                 ; 9985
         sta  $CF                  ; 9987
         lda  #$00                 ; 9989
         bit  $CD                  ; 998B
         bpl  L9991                ; 998D
         sta  $CD                  ; 998F
L9991
         jsr  entry_A813           ; 9991
         sec                       ; 9994
         rts                       ; 9995
         dta $00,$59,$5A,$5B,$41,$42,$43,$44          ; 9996
sub_999E
         ldx  $9813                ; 999E
         lda  $A116,x              ; 99A1
         ldy  #$03                 ; 99A4
L99A6
         cmp  $9996,y              ; 99A6
         beq  L99AE                ; 99A9
         dey                       ; 99AB
         bpl  L99A6                ; 99AC
L99AE
         lda  $999A,y              ; 99AE
         sta  $A116,x              ; 99B1
         rts                       ; 99B4
entry_99B5
         lda  $94F8                ; 99B5
         bpl  L99DC                ; 99B8
         lda  #$0A                 ; 99BA
         jsr  sub_94E9             ; 99BC
         jsr  entry_A831           ; 99BF
         bcc  L99C6                ; 99C2
         clc                       ; 99C4
         rts                       ; 99C5
L99C6
         cmp  #$78                 ; 99C6
         bne  L99CC                ; 99C8
         sec                       ; 99CA
         rts                       ; 99CB
L99CC
         ldx  #$72                 ; 99CC
         cmp  #$6E                 ; 99CE
         beq  L99D4                ; 99D0
         ldx  #$77                 ; 99D2
L99D4
         txa                       ; 99D4
         ldx  #$01                 ; 99D5
         jmp  L9BF2                ; 99D7
         dta $00,$00                                  ; 99DA
L99DC
         lda  $CF                  ; 99DC
         beq  L9A10                ; 99DE
         lda  #$00                 ; 99E0
         ldx  $99DA                ; 99E2
L99E5
         clc                       ; 99E5
         adc  #$28                 ; 99E6
         dex                       ; 99E8
         bpl  L99E5                ; 99E9
         tay                       ; 99EB
         ldx  #$09                 ; 99EC
L99EE
         lda  $BC00,y              ; 99EE
         ora  #$80                 ; 99F1
         sta  $BC00,y              ; 99F3
         iny                       ; 99F6
         dex                       ; 99F7
         bne  L99EE                ; 99F8
         lda  $99DB                ; 99FA
         asl                       ; 99FD
         adc  $99DB                ; 99FE
         tay                       ; 9A01
         ldx  #$02                 ; 9A02
L9A04
         lda  $BCAC,y              ; 9A04
         ora  #$80                 ; 9A07
         sta  $BCAC,y              ; 9A09
         iny                       ; 9A0C
         dex                       ; 9A0D
         bne  L9A04                ; 9A0E
L9A10
         ldx  #$04                 ; 9A10
L9A12
         stx  $B6                  ; 9A12
         txa                       ; 9A14
         tay                       ; 9A15
         asl                       ; 9A16
         adc  $B6                  ; 9A17
         adc  #$5C                 ; 9A19
         tax                       ; 9A1B
         lda  $94F8                ; 9A1C
         and  $94F9,y              ; 9A1F
         bne  L9A34                ; 9A22
         lda  #$60                 ; 9A24
         sta  $A15F,x              ; 9A26
         sta  $A160,x              ; 9A29
         sta  $A187,x              ; 9A2C
         sta  $A188,x              ; 9A2F
         bne  L9A48                ; 9A32
L9A34
         lda  #$45                 ; 9A34
         sta  $A15F,x              ; 9A36
         lda  #$46                 ; 9A39
         sta  $A160,x              ; 9A3B
         lda  #$47                 ; 9A3E
         sta  $A187,x              ; 9A40
         lda  #$48                 ; 9A43
         sta  $A188,x              ; 9A45
L9A48
         ldx  $B6                  ; 9A48
         dex                       ; 9A4A
         bpl  L9A12                ; 9A4B
         lda  #$00                 ; 9A4D
         beq  L9A61                ; 9A4F
         jsr  irq_9643             ; 9A51
         bcs  L9A57                ; 9A54
         rts                       ; 9A56
L9A57
         lda  #$02                 ; 9A57
         sta  $CF                  ; 9A59
         dec  $9A4E                ; 9A5B
         jmp  sub_9B0B             ; 9A5E
L9A61
         jmp  irq_9A64             ; 9A61
irq_9A64
         lda  #$02                 ; 9A64
         sta  $CF                  ; 9A66
         sta  $9ABA                ; 9A68
         lda  #$0F                 ; 9A6B
         jsr  sub_94E9             ; 9A6D
         ldx  $99DA                ; 9A70
         lda  $A840                ; 9A73
         pha                       ; 9A76
         and  #$01                 ; 9A77
         bne  L9A7C                ; 9A79
         dex                       ; 9A7B
L9A7C
         pla                       ; 9A7C
         and  #$02                 ; 9A7D
         bne  L9A82                ; 9A7F
         inx                       ; 9A81
L9A82
         txa                       ; 9A82
         and  #$03                 ; 9A83
         cmp  $99DA                ; 9A85
         sta  $99DA                ; 9A88
         beq  L9A95                ; 9A8B
         lda  #$00                 ; 9A8D
         sta  $9ABA                ; 9A8F
         jsr  entry_A813           ; 9A92
L9A95
         ldx  $99DB                ; 9A95
         lda  $A840                ; 9A98
         pha                       ; 9A9B
         and  #$04                 ; 9A9C
         bne  L9AA5                ; 9A9E
         dex                       ; 9AA0
         bpl  L9AA5                ; 9AA1
         ldx  #$04                 ; 9AA3
L9AA5
         pla                       ; 9AA5
         and  #$08                 ; 9AA6
         bne  L9AB1                ; 9AA8
         inx                       ; 9AAA
         cpx  #$05                 ; 9AAB
         bcc  L9AB1                ; 9AAD
         ldx  #$00                 ; 9AAF
L9AB1
         cpx  $99DB                ; 9AB1
         stx  $99DB                ; 9AB4
         beq  L9AC0                ; 9AB7
         lda  #$B9                 ; 9AB9
         beq  L9AC0                ; 9ABB
         jsr  entry_A813           ; 9ABD
L9AC0
         jsr  entry_A82B           ; 9AC0
         bcc  entry_9B02           ; 9AC3
         jsr  entry_A816           ; 9AC5
         beq  L9ACC                ; 9AC8
         clc                       ; 9ACA
         rts                       ; 9ACB
L9ACC
         lda  $99DA                ; 9ACC
         tay                       ; 9ACF
         beq  L9AE3                ; 9AD0
         cmp  #$02                 ; 9AD2
         beq  L9AE3                ; 9AD4
         ldx  $99DB                ; 9AD6
         lda  $94F9,x              ; 9AD9
         and  $94F8                ; 9ADC
         bne  L9AE3                ; 9ADF
         clc                       ; 9AE1
         rts                       ; 9AE2
L9AE3
         tya                       ; 9AE3
         asl                       ; 9AE4
         tax                       ; 9AE5
         lda  $9AFA,x              ; 9AE6
         sta  $9A62                ; 9AE9
         lda  $9AFB,x              ; 9AEC
         sta  $9A63                ; 9AEF
         txa                       ; 9AF2
         beq  L9AF8                ; 9AF3
         jsr  entry_A813           ; 9AF5
L9AF8
         clc                       ; 9AF8
         rts                       ; 9AF9
         dta $02,$9B,$1A,$9B,$23,$9B,$2C,$9B          ; 9AFA
entry_9B02
         jsr  sub_9B0B             ; 9B02
         lda  #$00                 ; 9B05
         sta  $CF                  ; 9B07
         sec                       ; 9B09
         rts                       ; 9B0A
sub_9B0B
         jsr  entry_A813           ; 9B0B
sub_9B0E
         lda  #$64                 ; 9B0E
         sta  $9A62                ; 9B10
         lda  #$9A                 ; 9B13
         sta  $9A63                ; 9B15
         clc                       ; 9B18
         rts                       ; 9B19
entry_9B1A
         ldx  #$07                 ; 9B1A
         jsr  sub_9BBF             ; 9B1C
         lda  #$72                 ; 9B1F
         bne  L9B33                ; 9B21
entry_9B23
         ldx  #$0F                 ; 9B23
         jsr  sub_9BBF             ; 9B25
         lda  #$77                 ; 9B28
         bne  L9B33                ; 9B2A
entry_9B2C
         ldx  #$17                 ; 9B2C
         jsr  sub_9BBF             ; 9B2E
         lda  #$65                 ; 9B31
L9B33
         ldx  $99DB                ; 9B33
         inx                       ; 9B36
         jsr  sub_9B79             ; 9B37
         php                       ; 9B3A
         jsr  sub_9B0E             ; 9B3B
         plp                       ; 9B3E
         bmi  L9B43                ; 9B3F
         clc                       ; 9B41
         rts                       ; 9B42
L9B43
         jsr  sub_9B53             ; 9B43
         jsr  sub_94E9             ; 9B46
         lda  #$0A                 ; 9B49
         sta  $962E                ; 9B4B
         inc  $9A4E                ; 9B4E
         clc                       ; 9B51
         rts                       ; 9B52
sub_9B53
         tya                       ; 9B53
         ldx  #$FF                 ; 9B54
L9B56
         inx                       ; 9B56
         ldy  $A7F8,x              ; 9B57
         beq  L9B61                ; 9B5A
         cmp  $A7F8,x              ; 9B5C
         bne  L9B56                ; 9B5F
L9B61
         tay                       ; 9B61
         lda  $A7FE,x              ; 9B62
         pha                       ; 9B65
         tya                       ; 9B66
         jsr  entry_A82E           ; 9B67
         clc                       ; 9B6A
         adc  #$A0                 ; 9B6B
         sta  $A65E                ; 9B6D
         clc                       ; 9B70
         txa                       ; 9B71
         adc  #$A0                 ; 9B72
         sta  $A65F                ; 9B74
         pla                       ; 9B77
         rts                       ; 9B78
sub_9B79
         pha                       ; 9B79
         txa                       ; 9B7A
         pha                       ; 9B7B
         jsr  sub_94F2             ; 9B7C
         lda  #$80                 ; 9B7F
         sta  IRQEN                ; 9B81
         pla                       ; 9B84
         tax                       ; 9B85
         pla                       ; 9B86
         sta  $9BB0                ; 9B87
         jsr  sub_9000             ; 9B8A
         ldx  $94F8                ; 9B8D
         bmi  L9B95                ; 9B90
         sta  $94F8                ; 9B92
L9B95
         ldx  #$00                 ; 9B95
         stx  IRQEN                ; 9B97
         tya                       ; 9B9A
         pha                       ; 9B9B
         lda  $9003                ; 9B9C
         beq  L9BAD                ; 9B9F
         tya                       ; 9BA1
         bpl  L9BAA                ; 9BA2
         jsr  sub_9EFC             ; 9BA4
         jmp  L9BAD                ; 9BA7
L9BAA
         jsr  sub_9F19             ; 9BAA
L9BAD
         pla                       ; 9BAD
         tay                       ; 9BAE
         rts                       ; 9BAF
         dta $00                                      ; 9BB0
L9BB1
         ldx  #$1B                 ; 9BB1
         lda  $9BB0                ; 9BB3
         cmp  #$72                 ; 9BB6
         beq  L9BBB                ; 9BB8
         inx                       ; 9BBA
L9BBB
         txa                       ; 9BBB
         jmp  sub_94E9             ; 9BBC
sub_9BBF
         ldy  #$07                 ; 9BBF
L9BC1
         lda  $A7D8,x              ; 9BC1
         sta  $A50F,y              ; 9BC4
         dex                       ; 9BC7
         dey                       ; 9BC8
         bpl  L9BC1                ; 9BC9
         clc                       ; 9BCB
         lda  $99DB                ; 9BCC
         adc  #$31                 ; 9BCF
         sta  $A521                ; 9BD1
         lda  #$10                 ; 9BD4
         jsr  sub_94E9             ; 9BD6
         jsr  entry_A831           ; 9BD9
         bcc  L9BE2                ; 9BDC
         pla                       ; 9BDE
         pla                       ; 9BDF
         clc                       ; 9BE0
L9BE1
         rts                       ; 9BE1
L9BE2
         cmp  #$79                 ; 9BE2
         beq  L9BE1                ; 9BE4
         pla                       ; 9BE6
         pla                       ; 9BE7
         jmp  sub_9B0E             ; 9BE8
entry_9BEB
         jsr  sub_9C4B             ; 9BEB
         lda  #$77                 ; 9BEE
         ldx  #$00                 ; 9BF0
L9BF2
         ldy  #$06                 ; 9BF2
         sty  $9555                ; 9BF4
         ldy  #$9C                 ; 9BF7
         sty  $9556                ; 9BF9
         sta  $9C04                ; 9BFC
         stx  $9C05                ; 9BFF
         clc                       ; 9C02
         rts                       ; 9C03
         dta $00,$00                                  ; 9C04
irq_9C06
         lda  #$03                 ; 9C06
         ldx  $94F8                ; 9C08
         bpl  L9C0F                ; 9C0B
         lda  #$04                 ; 9C0D
L9C0F
         sta  $CF                  ; 9C0F
         jsr  sub_9E18             ; 9C11
         lda  #$00                 ; 9C14
         sta  $CF                  ; 9C16
         lda  #$01                 ; 9C18
         jsr  sub_94E9             ; 9C1A
         jsr  entry_A83D           ; 9C1D
         bcc  L9C24                ; 9C20
         clc                       ; 9C22
         rts                       ; 9C23
L9C24
         beq  L9C2B                ; 9C24
         jsr  entry_A813           ; 9C26
         sec                       ; 9C29
         rts                       ; 9C2A
L9C2B
         ldx  $9C05                ; 9C2B
         lda  $9C04                ; 9C2E
         jsr  sub_9B79             ; 9C31
         bmi  L9C38                ; 9C34
         sec                       ; 9C36
         rts                       ; 9C37
L9C38
         jsr  sub_9B53             ; 9C38
         jmp  L962F                ; 9C3B
entry_9C3E
         jsr  sub_9C4B             ; 9C3E
         lda  #$80                 ; 9C41
         sta  $35C1                ; 9C43
         sta  $11                  ; 9C46
         jmp  L35C0                ; 9C48
sub_9C4B
         ldx  #$1F                 ; 9C4B
         lda  #$00                 ; 9C4D
L9C4F
         ora  $39A0,x              ; 9C4F
         dex                       ; 9C52
         bpl  L9C4F                ; 9C53
         tax                       ; 9C55
         bne  L9C5F                ; 9C56
         pla                       ; 9C58
         pla                       ; 9C59
         lda  #$13                 ; 9C5A
         jmp  L962F                ; 9C5C
L9C5F
         ldx  #$1F                 ; 9C5F
         lda  #$00                 ; 9C61
L9C63
         ora  $39C0,x              ; 9C63
         dex                       ; 9C66
         bpl  L9C63                ; 9C67
         tax                       ; 9C69
         bpl  L9CC6                ; 9C6A
         lda  #$12                 ; 9C6C
         jsr  sub_94E9             ; 9C6E
         jsr  entry_A831           ; 9C71
         bcc  L9C7A                ; 9C74
         pla                       ; 9C76
         pla                       ; 9C77
         clc                       ; 9C78
         rts                       ; 9C79
L9C7A
         cmp  #$78                 ; 9C7A
         bne  L9C82                ; 9C7C
         pla                       ; 9C7E
         pla                       ; 9C7F
         sec                       ; 9C80
         rts                       ; 9C81
L9C82
         cmp  #$79                 ; 9C82
         bne  L9CC6                ; 9C84
         ldx  #$00                 ; 9C86
L9C88
         lda  $39C0,x              ; 9C88
         sta  $39E0,x              ; 9C8B
         bpl  L9C9D                ; 9C8E
         and  #$7F                 ; 9C90
         tay                       ; 9C92
         lda  $39A0,y              ; 9C93
         bmi  L9CA3                ; 9C96
         bne  L9C9D                ; 9C98
         sta  $39E0,x              ; 9C9A
L9C9D
         inx                       ; 9C9D
         cpx  #$20                 ; 9C9E
         bcc  L9C88                ; 9CA0
         rts                       ; 9CA2
L9CA3
         pla                       ; 9CA3
         pla                       ; 9CA4
         sty  $CD                  ; 9CA5
         lda  $39A0,y              ; 9CA7
         and  #$7F                 ; 9CAA
         jsr  sub_9D57             ; 9CAC
         ldy  #$FF                 ; 9CAF
L9CB1
         iny                       ; 9CB1
         lda  ($B2),y              ; 9CB2
         sta  $A595,y              ; 9CB4
         bne  L9CB1                ; 9CB7
         tya                       ; 9CB9
L9CBA
         iny                       ; 9CBA
         sta  ($B2),y              ; 9CBB
         cpy  #$1E                 ; 9CBD
         bcc  L9CBA                ; 9CBF
         lda  #$14                 ; 9CC1
         jmp  L962F                ; 9CC3
L9CC6
         ldx  #$00                 ; 9CC6
L9CC8
         txa                       ; 9CC8
         tay                       ; 9CC9
         lda  $39A0,x              ; 9CCA
         bmi  L9CA3                ; 9CCD
         beq  L9CD4                ; 9CCF
         tya                       ; 9CD1
         ora  #$80                 ; 9CD2
L9CD4
         sta  $39E0,x              ; 9CD4
         inx                       ; 9CD7
         cpx  #$20                 ; 9CD8
         bcc  L9CC8                ; 9CDA
         rts                       ; 9CDC
L9CDD
         ldy  #$FF                 ; 9CDD
         cmp  $A7D6                ; 9CDF
         beq  L9CE7                ; 9CE2
         sty  $A317                ; 9CE4
L9CE7
         sta  $A7D6                ; 9CE7
         clc                       ; 9CEA
         txa                       ; 9CEB
         adc  #$1E                 ; 9CEC
         cmp  #$2A                 ; 9CEE
         bne  L9CFC                ; 9CF0
         lda  $9F7F,x              ; 9CF2
         beq  L9CFA                ; 9CF5
         jsr  sub_97DB             ; 9CF7
L9CFA
         lda  #$2A                 ; 9CFA
L9CFC
         cmp  #$39                 ; 9CFC
         bcc  L9D02                ; 9CFE
         lda  #$39                 ; 9D00
L9D02
         cmp  $A317                ; 9D02
         beq  L9D56                ; 9D05
         sta  $A317                ; 9D07
         jsr  sub_9D57             ; 9D0A
         ldy  #$FF                 ; 9D0D
L9D0F
         iny                       ; 9D0F
         lda  ($B2),y              ; 9D10
         bne  L9D0F                ; 9D12
         dey                       ; 9D14
         sty  $B6                  ; 9D15
         sec                       ; 9D17
         lda  #$27                 ; 9D18
         sbc  $B6                  ; 9D1A
         lsr                       ; 9D1C
         sta  $B6                  ; 9D1D
         sec                       ; 9D1F
         lda  #$27                 ; 9D20
         sbc  $B6                  ; 9D22
         tax                       ; 9D24
         stx  $B6                  ; 9D25
L9D27
         lda  ($B2),y              ; 9D27
         cmp  #$61                 ; 9D29
         bcc  L9D31                ; 9D2B
         cmp  #$7B                 ; 9D2D
         bcc  L9D34                ; 9D2F
L9D31
         jsr  entry_A834           ; 9D31
L9D34
         sta  $BCC8,x              ; 9D34
         dex                       ; 9D37
         dey                       ; 9D38
         bpl  L9D27                ; 9D39
         txa                       ; 9D3B
         bmi  L9D46                ; 9D3C
         lda  #$00                 ; 9D3E
L9D40
         sta  $BCC8,x              ; 9D40
         dex                       ; 9D43
         bpl  L9D40                ; 9D44
L9D46
         lda  #$00                 ; 9D46
         ldx  #$27                 ; 9D48
         cpx  $B6                  ; 9D4A
         beq  L9D56                ; 9D4C
L9D4E
         sta  $BCC8,x              ; 9D4E
         dex                       ; 9D51
         cpx  $B6                  ; 9D52
         bne  L9D4E                ; 9D54
L9D56
         rts                       ; 9D56
sub_9D57
         ldx  #$18                 ; 9D57
         stx  $B2                  ; 9D59
         ldx  #$A3                 ; 9D5B
         stx  $B3                  ; 9D5D
         tax                       ; 9D5F
         beq  L9D77                ; 9D60
L9D62
         ldy  #$FF                 ; 9D62
L9D64
         iny                       ; 9D64
         lda  ($B2),y              ; 9D65
         bne  L9D64                ; 9D67
         clc                       ; 9D69
         iny                       ; 9D6A
         tya                       ; 9D6B
         adc  $B2                  ; 9D6C
         sta  $B2                  ; 9D6E
         bcc  L9D74                ; 9D70
         inc  $B3                  ; 9D72
L9D74
         dex                       ; 9D74
         bne  L9D62                ; 9D75
L9D77
         rts                       ; 9D77
L9D78
         lda  #$00                 ; 9D78
         bne  L9D97                ; 9D7A
         inc  $9D79                ; 9D7C
         jsr  sub_9EFC             ; 9D7F
         lda  #$64                 ; 9D82
         jsr  sub_9000             ; 9D84
         sta  $94F8                ; 9D87
         bpl  L9D97                ; 9D8A
         ldx  #$07                 ; 9D8C
L9D8E
         lda  $A7F0,x              ; 9D8E
         sta  $A03D,x              ; 9D91
         dex                       ; 9D94
         bpl  L9D8E                ; 9D95
L9D97
         lda  #$82                 ; 9D97
         sta  $9555                ; 9D99
         lda  #$95                 ; 9D9C
         sta  $9556                ; 9D9E
         ldx  #$00                 ; 9DA1
         stx  $BC00                ; 9DA3
         stx  $CF                  ; 9DA6
         stx  $35C1                ; 9DA8
         dex                       ; 9DAB
         stx  $A317                ; 9DAC
         lda  #$1F                 ; 9DAF
         sta  $35C2                ; 9DB1
         lda  #$00                 ; 9DB4
         jsr  sub_94E9             ; 9DB6
         jmp  sub_9E18             ; 9DB9
L9DBC
         ldx  #$07                 ; 9DBC
         lda  $CD                  ; 9DBE
         bmi  L9DD3                ; 9DC0
         asl                       ; 9DC2
         adc  #$51                 ; 9DC3
         sta  $9DCA                ; 9DC5
L9DC8
         lda  $51F0,x              ; 9DC8
         sta  $9F7B,x              ; 9DCB
         dex                       ; 9DCE
         bpl  L9DC8                ; 9DCF
         bmi  L9DDC                ; 9DD1
L9DD3
         lda  $9F83,x              ; 9DD3
         sta  $9F7B,x              ; 9DD6
         dex                       ; 9DD9
         bpl  L9DD3                ; 9DDA
L9DDC
         lda  VCOUNT               ; 9DDC
         bpl  L9DDC                ; 9DDF
         ldx  #$04                 ; 9DE1
L9DE3
         lda  $9F7D,x              ; 9DE3
         sta  COLOR0,x             ; 9DE6
         sta  COLPF0,x             ; 9DE9
         dex                       ; 9DEC
         bpl  L9DE3                ; 9DED
         lda  COLOR4               ; 9DEF
         ldx  #$02                 ; 9DF2
L9DF4
         sta  $02C0,x              ; 9DF4
         sta  COLPM0,x             ; 9DF7
         dex                       ; 9DFA
         bpl  L9DF4                ; 9DFB
         lda  $9F82                ; 9DFD
         sta  $02C3                ; 9E00
         rts                       ; 9E03
sub_9E04
         lda  $CD                  ; 9E04
         asl                       ; 9E06
         adc  #$51                 ; 9E07
         sta  $9E13                ; 9E09
         ldx  #$07                 ; 9E0C
L9E0E
         lda  $9F7B,x              ; 9E0E
         sta  $51F0,x              ; 9E11
         dex                       ; 9E14
         bpl  L9E0E                ; 9E15
         rts                       ; 9E17
sub_9E18
         ldx  $CF                  ; 9E18
         beq  L9E7D                ; 9E1A
         dex                       ; 9E1C
         beq  L9E5D                ; 9E1D
         dex                       ; 9E1F
         beq  L9E4B                ; 9E20
         lda  #$27                 ; 9E22
         ldy  #$A2                 ; 9E24
         dex                       ; 9E26
         beq  L9E2D                ; 9E27
         lda  #$9F                 ; 9E29
         ldy  #$A2                 ; 9E2B
L9E2D
         sta  $9E36                ; 9E2D
         sty  $9E37                ; 9E30
         ldx  #$77                 ; 9E33
L9E35
         lda  L9E35,x              ; 9E35
         sta  $BC28,x              ; 9E38
         cpx  #$28                 ; 9E3B
         bcs  L9E47                ; 9E3D
         lda  #$00                 ; 9E3F
         sta  $BC00,x              ; 9E41
         sta  $BCA0,x              ; 9E44
L9E47
         dex                       ; 9E47
         bpl  L9E35                ; 9E48
         rts                       ; 9E4A
L9E4B
         ldx  #$C7                 ; 9E4B
L9E4D
         lda  $A15F,x              ; 9E4D
         sta  $BC00,x              ; 9E50
         dex                       ; 9E53
         bne  L9E4D                ; 9E54
         lda  $A15F                ; 9E56
         sta  $BC00                ; 9E59
         rts                       ; 9E5C
L9E5D
         ldx  #$27                 ; 9E5D
L9E5F
         lda  $A0E7,x              ; 9E5F
         sta  $BC00,x              ; 9E62
         lda  $A10F,x              ; 9E65
         sta  $BC50,x              ; 9E68
         lda  $A137,x              ; 9E6B
         sta  $BC78,x              ; 9E6E
         lda  #$00                 ; 9E71
         sta  $BC28,x              ; 9E73
         sta  $BCA0,x              ; 9E76
         dex                       ; 9E79
         bpl  L9E5F                ; 9E7A
         rts                       ; 9E7C
L9E7D
         ldy  $CD                  ; 9E7D
         iny                       ; 9E7F
         tya                       ; 9E80
         jsr  entry_A82E           ; 9E81
         tya                       ; 9E84
         ldy  #$0B                 ; 9E85
         jsr  DSPB                 ; 9E87
         lda  #$00                 ; 9E8A
         ldx  $CB                  ; 9E8C
         bpl  L9E92                ; 9E8E
         lda  #$14                 ; 9E90
L9E92
         clc                       ; 9E92
         adc  #$5B                 ; 9E93
         sta  $9EAF                ; 9E95
         ldx  #$A0                 ; 9E98
         bcc  L9E9D                ; 9E9A
         inx                       ; 9E9C
L9E9D
         stx  $9EB0                ; 9E9D
         lda  #$D3                 ; 9EA0
         sta  $9EB5                ; 9EA2
         lda  #$A0                 ; 9EA5
         sta  $9EB6                ; 9EA7
         ldx  #$C7                 ; 9EAA
L9EAC
         ldy  #$13                 ; 9EAC
L9EAE
         lda  L9EAE,y              ; 9EAE
         sta  $BC00,x              ; 9EB1
         lda  $9EB4,y              ; 9EB4
         sta  $BBEC,x              ; 9EB7
         dex                       ; 9EBA
         dey                       ; 9EBB
         bpl  L9EAE                ; 9EBC
         sec                       ; 9EBE
         lda  $9EAF                ; 9EBF
         sbc  #$28                 ; 9EC2
         sta  $9EAF                ; 9EC4
         bcs  L9ECC                ; 9EC7
         dec  $9EB0                ; 9EC9
L9ECC
         sec                       ; 9ECC
         lda  $9EB5                ; 9ECD
         sbc  #$14                 ; 9ED0
         sta  $9EB5                ; 9ED2
         bcs  L9EDA                ; 9ED5
         dec  $9EB6                ; 9ED7
L9EDA
         sec                       ; 9EDA
         txa                       ; 9EDB
         sbc  #$14                 ; 9EDC
         tax                       ; 9EDE
         bcs  L9EAC                ; 9EDF
         rts                       ; 9EE1

* display a byte as two digits (Robbo: "display byte") -----
DSPB
         pha                       ; 9EE2
         jsr  DSPD                 ; 9EE3
         pla                       ; 9EE6
         lsr                       ; 9EE7
         lsr                       ; 9EE8
         lsr                       ; 9EE9
         lsr                       ; 9EEA

* display digits -------------------------------------------
DSPD
         and  #$0F                 ; 9EEB
         tax                       ; 9EED
         lda  $9FA2,x              ; 9EEE
         sta  $A083,y              ; 9EF1
         lda  $9FAC,x              ; 9EF4
         sta  $A097,y              ; 9EF7
         dey                       ; 9EFA
         rts                       ; 9EFB
sub_9EFC
         lda  CONSOL               ; 9EFC
         lsr                       ; 9EFF
         bcs  L9F03                ; 9F00
         rts                       ; 9F02
L9F03
         ldy  #$00                 ; 9F03
         tya                       ; 9F05
L9F06
         sta  $3B00,y              ; 9F06
         sta  $3A00,y              ; 9F09
         cpy  #$20                 ; 9F0C
         bcs  L9F16                ; 9F0E
         sta  $39A0,y              ; 9F10
         sta  $39C0,y              ; 9F13
L9F16
         dey                       ; 9F16
         bne  L9F06                ; 9F17
sub_9F19
         lda  #$1F                 ; 9F19
         sta  $B6                  ; 9F1B
L9F1D
         ldx  $B6                  ; 9F1D
         lda  $39A0,x              ; 9F1F
         bne  L9F49                ; 9F22
         txa                       ; 9F24
         asl                       ; 9F25
         adc  #$50                 ; 9F26
         sta  $B3                  ; 9F28
         lda  #$20                 ; 9F2A
         ldy  #$00                 ; 9F2C
         sty  $B2                  ; 9F2E
L9F30
         sta  ($B2),y              ; 9F30
         dey                       ; 9F32
         bne  L9F30                ; 9F33
         inc  $B3                  ; 9F35
L9F37
         sta  ($B2),y              ; 9F37
         dey                       ; 9F39
         bne  L9F37                ; 9F3A
         ldy  #$F7                 ; 9F3C
         ldx  #$07                 ; 9F3E
L9F40
         lda  $9F83,x              ; 9F40
         sta  ($B2),y              ; 9F43
         dey                       ; 9F45
         dex                       ; 9F46
         bpl  L9F40                ; 9F47
L9F49
         dec  $B6                  ; 9F49
         bpl  L9F1D                ; 9F4B
         lda  $A804                ; 9F4D
         bmi  L9F6E                ; 9F50
         lda  $A7D6                ; 9F52
         sec                       ; 9F55
         rol                       ; 9F56
         sta  $B0                  ; 9F57
         sta  $B2                  ; 9F59
         asl                       ; 9F5B
         asl                       ; 9F5C
         sec                       ; 9F5D
         rol                       ; 9F5E
         asl                       ; 9F5F
         sta  $B3                  ; 9F60
         eor  $B3                  ; 9F62
         sta  $B1                  ; 9F64
         tay                       ; 9F66
         lda  ($B0),y              ; 9F67
         eor  ($B2),y              ; 9F69
         sta  $9F8B                ; 9F6B
L9F6E
         lda  #$60                 ; 9F6E
         sta  $9F4D                ; 9F70
         rts                       ; 9F73
L9F74
         ldx  #$FE                 ; 9F74
         ldy  #$94                 ; 9F76
         jmp  entry_A837           ; 9F78
