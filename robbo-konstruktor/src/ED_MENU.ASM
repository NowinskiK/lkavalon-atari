; ED_MENU.ASM - editor: services jump table, main menu and its 10 functions, disk sub-menu
; $94E0-$9CDC

         org $94E0


* editor services: jump table (frame, init, colours, message, ...) ---
ED_FRAME
         jmp  ED_FRAME_            ; 94E0
ED_INIT
         jmp  ED_INIT_             ; 94E3
ED_COLORS
         jmp  ED_COLORS_           ; 94E6
MESSAGE
         jmp  MESSAGE_             ; 94E9
IO_MSG
         jmp  IO_MSG_              ; 94EC
ELEM_MSG
         jmp  ELEM_MSG_            ; 94EF
ED_DLIST
         jmp  ED_DLIST_            ; 94F2
HELP_KEY
         jmp  HELP_KEY_            ; 94F5
DISK_SLOTS       dta $00                              ; 94F8 directory result: used slots, negative = no disk

* menu functions ---------------
SET_BIT          dta $01,$02,$04,$08,$10              ; 94F9 bit of sets 1-5 in DISK_SLOTS
         dta $10,$70,$42,$78,$BD,$02,$42,$78,$BD,$02,$02,$42,$78,$BD,$02,$02 ; 94FE
         dta $42,$78,$BD,$02,$02,$42,$78,$BD,$02,$02,$42,$78,$BD,$02,$02,$42 ; 950E
         dta $78,$BD,$02,$02,$20,$4F,$50,$BD,$0F,$0F,$42,$00,$BC,$02,$02,$02 ; 951E
         dta $02,$4F,$00,$BD,$0F,$0F,$0F,$0F,$42,$C8,$BC,$4F,$00,$BD,$0F,$0F ; 952E
         dta $41,$FE,$94                              ; 953E

* one editor frame: colours, input, run the current command ---
ED_FRAME_
         jsr  ED_COLORS            ; 9541
         jsr  GETKEY               ; 9544
         bcs  L954D                ; 9547
         cmp  #$11                 ; 9549
         beq  HELP_KEY             ; 954B
L954D
         lda  ED_FLAGS             ; 954D
         bmi  L9570                ; 954F
         jsr  PANEL                ; 9551
MENU_CALL
         jsr  MENU_CALL            ; 9554
         php                       ; 9557
         lda  #$FF                 ; 9558
         cmp  JOY                  ; 955A
         beq  L9562                ; 955D
         sta  JOY                  ; 955F
L9562
         plp                       ; 9562
         bcs  L9566                ; 9563
         rts                       ; 9565
L9566
         lda  #$82                 ; 9566
         sta  MENU_CALL+1          ; 9568
         lda  #$95                 ; 956B
         sta  MENU_CALL+2          ; 956D
L9570
         rts                       ; 9570

* HELP key: sound off, show the help (page HELP_PAGE) ------
HELP_KEY_
         lda  #$00                 ; 9571
         sta  BEEP                 ; 9573
         sta  AUDF1                ; 9576
         sta  AUDC1                ; 9579
         lda  DISK_SLOTS           ; 957C
         jmp  HELP                 ; 957F

* main menu: highlight the row, choose function row + 5 * page, help page = index / 2 + 3 ---
MENU
         lda  #$02                 ; 9582
         sta  HELP_PAGE            ; 9584
         lda  MENU_POS             ; 9586
         and  #$7F                 ; 9588
         tax                       ; 958A
         ldy  MENU_ROWS,x          ; 958B
         ldx  #$14                 ; 958E
L9590
         lda  PANEL_TXT,y          ; 9590
         ora  #$80                 ; 9593
         sta  PANEL_TXT,y          ; 9595
         iny                       ; 9598
         dex                       ; 9599
         bne  L9590                ; 959A
         lda  #$00                 ; 959C
         jsr  MESSAGE              ; 959E
         jsr  INPUT_CLR            ; 95A1
         bne  L95C3                ; 95A4
         lda  MENU_POS             ; 95A6
         asl                       ; 95A8
         bcc  L95AD                ; 95A9
         adc  #$09                 ; 95AB
L95AD
         tax                       ; 95AD
         lda  MENU_JUMPS,x         ; 95AE
         sta  MENU_CALL+1          ; 95B1
         lda  MENU_JUMPS+1,x       ; 95B4
         sta  MENU_CALL+2          ; 95B7
         txa                       ; 95BA
         lsr                       ; 95BB
         adc  #$03                 ; 95BC
         sta  HELP_PAGE            ; 95BE
         jsr  CLICK                ; 95C0
L95C3
         jsr  MENU_MOVE            ; 95C3
         bcs  L95CF                ; 95C6
         jsr  KEY_EVENT            ; 95C8
         bcc  L95CF                ; 95CB
         clc                       ; 95CD
         rts                       ; 95CE
L95CF
         jsr  CLICK                ; 95CF
         jmp  MENU_LEAVE           ; 95D2

* main menu: move the selection ----------------------------
MENU_MOVE
         lda  MENU_POS             ; 95D5
         and  #$7F                 ; 95D7
         tax                       ; 95D9
         lda  JOY                  ; 95DA
         tay                       ; 95DD
         and  #$01                 ; 95DE
         bne  L95EF                ; 95E0
         dex                       ; 95E2
         bpl  L95EF                ; 95E3
         inx                       ; 95E5
         lda  #$01                 ; 95E6
         jsr  DIR_TEST             ; 95E8
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
         ldx  PLANET               ; 95FC
         jsr  PLANET_STEP          ; 95FE
         txa                       ; 9601
         tay                       ; 9602
         pla                       ; 9603
         tax                       ; 9604
         txa                       ; 9605
         bit  MENU_POS             ; 9606
         bpl  L960C                ; 9608
         ora  #$80                 ; 960A
L960C
         cmp  MENU_POS             ; 960C
         bne  L9614                ; 960E
         cpy  PLANET               ; 9610
         beq  L961B                ; 9612
L9614
         sta  MENU_POS             ; 9614
         sty  PLANET               ; 9616
         jsr  CLICK                ; 9618
L961B
         clc                       ; 961B
         rts                       ; 961C
MENU_LEAVE
         jsr  PANEL                ; 961D
         lda  #$80                 ; 9620
         sta  ED_FLAGS             ; 9622
         sec                       ; 9624
         rts                       ; 9625

* menu function "funkcje dodatkowe / podstawowe": switch the menu page ---
M_PAGE
         lda  MENU_POS             ; 9626
         eor  #$80                 ; 9628
         sta  MENU_POS             ; 962A
         sec                       ; 962C
         rts                       ; 962D
BEEP             dta $00                              ; 962E error tone: volume, counted down by DISK_WAIT

* show message A with the error tone, then wait for fire (DISK_WAIT runs as the next command) ---
MSG_WAIT
         jsr  MESSAGE              ; 962F
         lda  #$0A                 ; 9632
         sta  BEEP                 ; 9634
         lda  #$43                 ; 9637
         sta  MENU_CALL+1          ; 9639
         lda  #$96                 ; 963C
         sta  MENU_CALL+2          ; 963E
         clc                       ; 9641
         rts                       ; 9642

* disk operations: wait state ------------------------------
DISK_WAIT
         lda  BEEP                 ; 9643
         ora  #$C0                 ; 9646
         sta  AUDC1                ; 9648
         lda  #$55                 ; 964B
         sta  AUDF1                ; 964D
         lda  BEEP                 ; 9650
         beq  L9658                ; 9653
         dec  BEEP                 ; 9655
L9658
         jsr  INPUT_CLR            ; 9658
         beq  L966B                ; 965B
         jsr  KEY_EVENT            ; 965D
         bcc  L966B                ; 9660
         lda  JOY                  ; 9662
         cmp  #$FF                 ; 9665
         bne  L966B                ; 9667
         clc                       ; 9669
         rts                       ; 966A
L966B
         jsr  CLICK                ; 966B
         lda  #$00                 ; 966E
         sta  PANEL_ST             ; 9670
         sec                       ; 9672
         rts                       ; 9673

* planet number -1 / +1 with the joystick, 0-31 wrapping ---
PLANET_STEP
         lda  JOY                  ; 9674
         and  #$04                 ; 9677
         bne  L9680                ; 9679
         dex                       ; 967B
         bpl  L9680                ; 967C
         ldx  #$1F                 ; 967E
L9680
         lda  JOY                  ; 9680
         and  #$08                 ; 9683
         bne  L968E                ; 9685
         inx                       ; 9687
         cpx  #$20                 ; 9688
         bcc  L968E                ; 968A
         ldx  #$00                 ; 968C
L968E
         rts                       ; 968E

* menu function "zmiana kolorów" ---------------------------
M_COLORS
         lda  CUR_MSG              ; 968F
         cmp  #$02                 ; 9692
         bne  L96C2                ; 9694
         ldy  #$FF                 ; 9696
L9698
         iny                       ; 9698
         lda  STATUS,y             ; 9699
         beq  L9698                ; 969C
         tya                       ; 969E
         pha                       ; 969F
         ldx  #$06                 ; 96A0
L96A2
         lda  STATUS,y             ; 96A2
         and  #$7F                 ; 96A5
         sta  STATUS,y             ; 96A7
         iny                       ; 96AA
         dex                       ; 96AB
         bne  L96A2                ; 96AC
         clc                       ; 96AE
         pla                       ; 96AF
         adc  COL_REG              ; 96B0
         tay                       ; 96B3
         lda  FRAMES               ; 96B4
         and  #$02                 ; 96B6
         beq  L96BC                ; 96B8
         lda  #$80                 ; 96BA
L96BC
         ora  STATUS,y             ; 96BC
         sta  STATUS,y             ; 96BF
L96C2
         lda  COL_EDIT             ; 96C2
         bne  L9719                ; 96C5
         lda  #$02                 ; 96C7
         jsr  MESSAGE              ; 96C9
         jsr  KEY_EVENT            ; 96CC
         bcc  L96DE                ; 96CF
         lda  JOY                  ; 96D1
         tax                       ; 96D4
         and  #$01                 ; 96D5
         beq  L96DE                ; 96D7
         txa                       ; 96D9
         and  #$02                 ; 96DA
         bne  L96E3                ; 96DC
L96DE
         jsr  CLICK                ; 96DE
         sec                       ; 96E1
         rts                       ; 96E2
L96E3
         jsr  INPUT_CLR            ; 96E3
         bne  L96F0                ; 96E6
         jsr  CLICK                ; 96E8
         inc  COL_EDIT             ; 96EB
         clc                       ; 96EE
         rts                       ; 96EF
L96F0
         ldx  COL_REG              ; 96F0
         lda  JOY                  ; 96F3
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
         cpx  COL_REG              ; 970C
         beq  L9717                ; 970F
         stx  COL_REG              ; 9711
         jsr  CLICK                ; 9714
L9717
         clc                       ; 9717
         rts                       ; 9718
L9719
         lda  #$03                 ; 9719
         jsr  MESSAGE              ; 971B
         ldx  COL_REG              ; 971E
         lda  HDR_BUF+2,x          ; 9721
         tay                       ; 9724
         pha                       ; 9725
         and  #$0F                 ; 9726
         sta  TMP3                 ; 9728
         pla                       ; 972A
         and  #$F0                 ; 972B
         sta  TMP4                 ; 972D
         lda  JOY                  ; 972F
         and  #$04                 ; 9732
         bne  L9740                ; 9734
         sec                       ; 9736
         lda  TMP3                 ; 9737
         sbc  #$02                 ; 9739
         and  #$0F                 ; 973B
         ora  TMP4                 ; 973D
         tay                       ; 973F
L9740
         lda  JOY                  ; 9740
         and  #$08                 ; 9743
         bne  L9751                ; 9745
         clc                       ; 9747
         lda  TMP3                 ; 9748
         adc  #$02                 ; 974A
         and  #$0F                 ; 974C
         ora  TMP4                 ; 974E
         tay                       ; 9750
L9751
         lda  JOY                  ; 9751
         and  #$02                 ; 9754
         bne  L9762                ; 9756
         sec                       ; 9758
         lda  TMP4                 ; 9759
         sbc  #$10                 ; 975B
         and  #$F0                 ; 975D
         ora  TMP3                 ; 975F
         tay                       ; 9761
L9762
         lda  JOY                  ; 9762
         and  #$01                 ; 9765
         bne  L9773                ; 9767
         clc                       ; 9769
         lda  TMP4                 ; 976A
         adc  #$10                 ; 976C
         and  #$F0                 ; 976E
         ora  TMP3                 ; 9770
         tay                       ; 9772
L9773
         tya                       ; 9773
         cmp  HDR_BUF+2,x          ; 9774
         beq  L977F                ; 9777
         sta  HDR_BUF+2,x          ; 9779
         jsr  CLICK                ; 977C
L977F
         jsr  COLS_DEFAULT         ; 977F
         jsr  INPUT_CLR            ; 9782
         bne  L978D                ; 9785
         jsr  CLICK                ; 9787
         dec  COL_EDIT             ; 978A
L978D
         jsr  KEY_EVENT            ; 978D
         bcc  L9794                ; 9790
         clc                       ; 9792
         rts                       ; 9793
L9794
         lda  #$00                 ; 9794
         sta  COL_EDIT             ; 9796
         jsr  CLICK                ; 9799
         sec                       ; 979C
         rts                       ; 979D

* menu function "test planety": run the engine on the planet ---
M_TEST
         ldx  PLANET               ; 979E
         lda  PLANET_STATE,x       ; 97A0
         bne  L97A7                ; 97A3
         lda  #$8B                 ; 97A5
L97A7
         bpl  L97AE                ; 97A7
         and  #$7F                 ; 97A9
         jmp  MSG_WAIT             ; 97AB
L97AE
         lda  #$80                 ; 97AE
         sta  TP_TEST              ; 97B0
         sta  IRQEN                ; 97B3
         jsr  ENGINE_INIT          ; 97B6
         lda  PLANET               ; 97B9
         asl                       ; 97BB
         adc  #$50                 ; 97BC
         ldx  PLANET               ; 97BE
         inx                       ; 97C0
         ldy  #$FF                 ; 97C1
         jsr  ENGINE_PLAY          ; 97C3
         jmp  START                ; 97C6

* menu function "czyść planetę": ask, then clear -----------
M_CLEAR
         lda  #$09                 ; 97C9
         jsr  MESSAGE              ; 97CB
         jsr  ASK_YESNO            ; 97CE
         bcc  L97D5                ; 97D1
         clc                       ; 97D3
         rts                       ; 97D4
L97D5
         cmp  #$79                 ; 97D5
         beq  PLANET_CLR           ; 97D7
         sec                       ; 97D9
         rts                       ; 97DA

* clear the current planet: cells $20, default header, status empty ---
PLANET_CLR
         lda  PLANET               ; 97DB
         asl                       ; 97DD
         adc  #$50                 ; 97DE
         sta  PTR2+1               ; 97E0
         adc  #$01                 ; 97E2
         sta  PTR1+1               ; 97E4
         lda  #$00                 ; 97E6
         sta  PTR2                 ; 97E8
         sta  PTR1                 ; 97EA
         ldy  #$00                 ; 97EC
         lda  #$20                 ; 97EE
L97F0
         sta  (PTR2),y             ; 97F0
         cpy  #$F0                 ; 97F2
         bcs  L97F8                ; 97F4
         sta  (PTR1),y             ; 97F6
L97F8
         dey                       ; 97F8
         bne  L97F0                ; 97F9
         ldx  #$07                 ; 97FB
         ldy  #$F7                 ; 97FD
L97FF
         lda  COLS_DEF,x           ; 97FF
         sta  (PTR1),y             ; 9802
         dey                       ; 9804
         dex                       ; 9805
         bpl  L97FF                ; 9806
         ldx  PLANET               ; 9808
         lda  #$00                 ; 980A
         sta  PLANET_STATE,x       ; 980C
         sec                       ; 980F
         rts                       ; 9810
ORD_BLINK        dta $00                              ; 9811 kolejnosc planet: frame counter, bit 2 = blink phase
ORD_POS          dta $00                              ; 9812 kolejnosc planet: the planet / position under the cursor
ORD_MARK         dta $00                              ; 9813 kolejnosc planet: the planet picked to be placed

* menu function "kolejność planet" -------------------------
M_ORDER
         lda  PANEL_ST             ; 9814
         bne  L9836                ; 9816
         lda  PLANET               ; 9818
         sta  ORD_PLANET           ; 981A
         ldx  ORD_COL              ; 981D
         bmi  L9827                ; 9820
         sta  ORD_POS              ; 9822
         bpl  L9836                ; 9825
L9827
         ldx  ORD_POS              ; 9827
         lda  ORDER,x              ; 982A
         bmi  L9836                ; 982D
         lda  #$01                 ; 982F
         sta  ORD_COL              ; 9831
         bne  M_ORDER              ; 9834
L9836
         inc  ORD_BLINK            ; 9836
         ldx  #$1F                 ; 9839
L983B
         lda  #$59                 ; 983B
         ldy  PLANET_STATE,x       ; 983D
         bpl  L9846                ; 9840
         lda  #$5B                 ; 9842
         bne  L984A                ; 9844
L9846
         beq  L984A                ; 9846
         lda  #$5A                 ; 9848
L984A
         sta  LEGEND_TXT+47,x      ; 984A
         lda  #$00                 ; 984D
         lda  ORDER,x              ; 984F
         bpl  L9866                ; 9852
         and  #$7F                 ; 9854
         tay                       ; 9856
         lda  PLANET_STATE,y       ; 9857
         beq  L9866                ; 985A
         bpl  L9862                ; 985C
         lda  #$5B                 ; 985E
         bne  L986D                ; 9860
L9862
         lda  #$5A                 ; 9862
         bne  L986D                ; 9864
L9866
         lda  #$00                 ; 9866
         sta  ORDER,x              ; 9868
         lda  #$59                 ; 986B
L986D
         sta  LEGEND_TXT+87,x      ; 986D
         dex                       ; 9870
         bpl  L983B                ; 9871
ORD_COL          equ *+1                              ; 9874 kolejnosc planet: bit 7 = cursor in the planet row, else in the order row
         ldx  #$01                 ; 9873
         bmi  L98E2                ; 9875
         ldx  ORD_POS              ; 9877
         lda  ORD_BLINK            ; 987A
         and  #$04                 ; 987D
         bne  L9884                ; 987F
         sta  LEGEND_TXT+47,x      ; 9881
L9884
         stx  PLANET               ; 9884
         inx                       ; 9886
         txa                       ; 9887
         jsr  TO_DIGITS            ; 9888
         sta  LEGEND_TXT+43        ; 988B
         stx  LEGEND_TXT+44        ; 988E
         lda  PANEL_ST             ; 9891
         beq  L98AB                ; 9893
         ldy  #$7E                 ; 9895
         ldx  #$1F                 ; 9897
L9899
         lda  ORDER,x              ; 9899
         eor  #$80                 ; 989C
         bmi  L98A8                ; 989E
         cmp  PLANET               ; 98A0
         bne  L98A8                ; 98A2
         tya                       ; 98A4
         sta  PANEL_TXT+167,x      ; 98A5
L98A8
         dex                       ; 98A8
         bpl  L9899                ; 98A9
L98AB
         jsr  ORDER_TOGGLE         ; 98AB
         lda  #$0C                 ; 98AE
         jsr  MESSAGE              ; 98B0
         lda  JOY                  ; 98B3
         pha                       ; 98B6
         and  #$02                 ; 98B7
         bne  L98C2                ; 98B9
         sec                       ; 98BB
         ror  ORD_COL              ; 98BC
         jsr  CLICK                ; 98BF
L98C2
         pla                       ; 98C2
         and  #$01                 ; 98C3
         bne  L98D1                ; 98C5
         lda  #$01                 ; 98C7
         jsr  DIR_TEST             ; 98C9
         bcs  L98D1                ; 98CC
         jmp  ORD_LEAVE            ; 98CE
L98D1
         jsr  INPUT_CLR            ; 98D1
         bne  L98DF                ; 98D4
         lda  ORD_POS              ; 98D6
         sta  ORD_MARK             ; 98D9
         jsr  CLICK                ; 98DC
L98DF
         jmp  ORD_MOVE             ; 98DF
L98E2
         lda  PANEL_ST             ; 98E2
         beq  L9902                ; 98E4
         ldx  ORD_POS              ; 98E6
         lda  ORD_BLINK            ; 98E9
         and  #$04                 ; 98EC
         bne  L98F3                ; 98EE
         sta  LEGEND_TXT+87,x      ; 98F0
L98F3
         lda  ORDER,x              ; 98F3
         eor  #$80                 ; 98F6
         sta  PLANET               ; 98F8
         bmi  L9902                ; 98FA
         tay                       ; 98FC
         lda  #$7F                 ; 98FD
         sta  PANEL_TXT+47,y       ; 98FF
L9902
         jsr  ORDER_TOGGLE         ; 9902
         ldy  #$00                 ; 9905
         ldx  #$00                 ; 9907
L9909
         cpx  ORD_POS              ; 9909
         bcs  L9917                ; 990C
         lda  ORDER,x              ; 990E
         bpl  L9914                ; 9911
         iny                       ; 9913
L9914
         inx                       ; 9914
         bpl  L9909                ; 9915
L9917
         iny                       ; 9917
         tya                       ; 9918
         jsr  TO_DIGITS            ; 9919
         bit  PLANET               ; 991C
         bpl  L9923                ; 991E
         lda  #$0D                 ; 9920
         tax                       ; 9922
L9923
         sta  LEGEND_TXT+83        ; 9923
         stx  LEGEND_TXT+84        ; 9926
         lda  #$0D                 ; 9929
         jsr  MESSAGE              ; 992B
         lda  JOY                  ; 992E
         pha                       ; 9931
         and  #$01                 ; 9932
         bne  L993E                ; 9934
         lda  #$01                 ; 9936
         sta  ORD_COL              ; 9938
         jsr  CLICK                ; 993B
L993E
         pla                       ; 993E
         and  #$02                 ; 993F
         bne  L994A                ; 9941
         lda  #$02                 ; 9943
         jsr  DIR_TEST             ; 9945
         bcc  ORD_LEAVE            ; 9948
L994A
         jsr  INPUT_CLR            ; 994A
         bne  ORD_MOVE             ; 994D
         lda  ORD_MARK             ; 994F
         eor  #$80                 ; 9952
         ldx  ORD_POS              ; 9954
         cmp  ORDER,x              ; 9957
         bne  L995E                ; 995A
         lda  #$00                 ; 995C
L995E
         sta  ORDER,x              ; 995E
         jsr  CLICK                ; 9961
ORD_MOVE
         lda  #$01                 ; 9964
         sta  PANEL_ST             ; 9966
         ldx  ORD_POS              ; 9968
         jsr  PLANET_STEP          ; 996B
         cpx  ORD_POS              ; 996E
         beq  L997E                ; 9971
         stx  ORD_POS              ; 9973
         lda  #$00                 ; 9976
         sta  ORD_BLINK            ; 9978
         jsr  CLICK                ; 997B
L997E
         jsr  KEY_EVENT            ; 997E
         bcc  ORD_LEAVE            ; 9981
         clc                       ; 9983
         rts                       ; 9984
ORD_LEAVE
         lda  #$00                 ; 9985
         sta  PANEL_ST             ; 9987
ORD_PLANET       equ *+1                              ; 998A PLANET on entry
         lda  #$00                 ; 9989
         bit  PLANET               ; 998B
         bpl  L9991                ; 998D
         sta  PLANET               ; 998F
L9991
         jsr  CLICK                ; 9991
         sec                       ; 9994
         rts                       ; 9995
TOG_FROM         dta $00,$59,$5A,$5B                  ; 9996 ORDER_TOGGLE: marks of the legend ($59 empty, $5A good, $5B bad)
TOG_TO           dta $41,$42,$43,$44                  ; 999A the same marks highlighted

* planet order: cycle the mark of a planet -----------------
ORDER_TOGGLE
         ldx  ORD_MARK             ; 999E
         lda  LEGEND_TXT+47,x      ; 99A1
         ldy  #$03                 ; 99A4
L99A6
         cmp  TOG_FROM,y           ; 99A6
         beq  L99AE                ; 99A9
         dey                       ; 99AB
         bpl  L99A6                ; 99AC
L99AE
         lda  TOG_TO,y             ; 99AE
         sta  LEGEND_TXT+47,x      ; 99B1
         rts                       ; 99B4

* menu function "operacje dyskowe / kasetowe" --------------
M_DISK
         lda  DISK_SLOTS           ; 99B5
         bpl  L99DC                ; 99B8
         lda  #$0A                 ; 99BA
         jsr  MESSAGE              ; 99BC
         jsr  ASK_YESNO            ; 99BF
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
         jmp  SG_SET               ; 99D7
DSK_FUNC         dta $00                              ; 99DA disk sub-menu: function (0 menu, 1 load, 2 save, 3 erase)
DSK_SET          dta $00                              ; 99DB disk sub-menu: set 0-4
L99DC
         lda  PANEL_ST             ; 99DC
         beq  L9A10                ; 99DE
         lda  #$00                 ; 99E0
         ldx  DSK_FUNC             ; 99E2
L99E5
         clc                       ; 99E5
         adc  #$28                 ; 99E6
         dex                       ; 99E8
         bpl  L99E5                ; 99E9
         tay                       ; 99EB
         ldx  #$09                 ; 99EC
L99EE
         lda  PANEL_TXT,y          ; 99EE
         ora  #$80                 ; 99F1
         sta  PANEL_TXT,y          ; 99F3
         iny                       ; 99F6
         dex                       ; 99F7
         bne  L99EE                ; 99F8
         lda  DSK_SET              ; 99FA
         asl                       ; 99FD
         adc  DSK_SET              ; 99FE
         tay                       ; 9A01
         ldx  #$02                 ; 9A02
L9A04
         lda  PANEL_TXT+172,y      ; 9A04
         ora  #$80                 ; 9A07
         sta  PANEL_TXT+172,y      ; 9A09
         iny                       ; 9A0C
         dex                       ; 9A0D
         bne  L9A04                ; 9A0E
L9A10
         ldx  #$04                 ; 9A10
L9A12
         stx  TMP3                 ; 9A12
         txa                       ; 9A14
         tay                       ; 9A15
         asl                       ; 9A16
         adc  TMP3                 ; 9A17
         adc  #$5C                 ; 9A19
         tax                       ; 9A1B
         lda  DISK_SLOTS           ; 9A1C
         and  SET_BIT,y            ; 9A1F
         bne  L9A34                ; 9A22
         lda  #$60                 ; 9A24
         sta  DISK_TXT,x           ; 9A26
         sta  DISK_TXT+1,x         ; 9A29
         sta  DISK_TXT+40,x        ; 9A2C
         sta  DISK_TXT+41,x        ; 9A2F
         bne  L9A48                ; 9A32
L9A34
         lda  #$45                 ; 9A34
         sta  DISK_TXT,x           ; 9A36
         lda  #$46                 ; 9A39
         sta  DISK_TXT+1,x         ; 9A3B
         lda  #$47                 ; 9A3E
         sta  DISK_TXT+40,x        ; 9A40
         lda  #$48                 ; 9A43
         sta  DISK_TXT+41,x        ; 9A45
L9A48
         ldx  TMP3                 ; 9A48
         dex                       ; 9A4A
         bpl  L9A12                ; 9A4B
DSK_WAIT         equ *+1                              ; 9A4E disk sub-menu: 0 = choose, else show the result and wait
         lda  #$00                 ; 9A4D
         beq  DSK_GO               ; 9A4F
         jsr  DISK_WAIT            ; 9A51
         bcs  L9A57                ; 9A54
         rts                       ; 9A56
L9A57
         lda  #$02                 ; 9A57
         sta  PANEL_ST             ; 9A59
         dec  DSK_WAIT             ; 9A5B
         jmp  DISK_RESETC          ; 9A5E
DSK_GO
         jmp  DISK_MENU            ; 9A61

* disk operations: sub-menu (table $9AFA) ------------------
DISK_MENU
         lda  #$02                 ; 9A64
         sta  PANEL_ST             ; 9A66
         sta  DSK_SAME             ; 9A68
         lda  #$0F                 ; 9A6B
         jsr  MESSAGE              ; 9A6D
         ldx  DSK_FUNC             ; 9A70
         lda  JOY                  ; 9A73
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
         cmp  DSK_FUNC             ; 9A85
         sta  DSK_FUNC             ; 9A88
         beq  L9A95                ; 9A8B
         lda  #$00                 ; 9A8D
         sta  DSK_SAME             ; 9A8F
         jsr  CLICK                ; 9A92
L9A95
         ldx  DSK_SET              ; 9A95
         lda  JOY                  ; 9A98
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
         cpx  DSK_SET              ; 9AB1
         stx  DSK_SET              ; 9AB4
         beq  L9AC0                ; 9AB7
DSK_SAME         equ *+1                              ; 9ABA disk sub-menu: 0 after the function changed
         lda  #$B9                 ; 9AB9
         beq  L9AC0                ; 9ABB
         jsr  CLICK                ; 9ABD
L9AC0
         jsr  KEY_EVENT            ; 9AC0
         bcc  DISK_BACK            ; 9AC3
         jsr  INPUT_CLR            ; 9AC5
         beq  L9ACC                ; 9AC8
         clc                       ; 9ACA
         rts                       ; 9ACB
L9ACC
         lda  DSK_FUNC             ; 9ACC
         tay                       ; 9ACF
         beq  L9AE3                ; 9AD0
         cmp  #$02                 ; 9AD2
         beq  L9AE3                ; 9AD4
         ldx  DSK_SET              ; 9AD6
         lda  SET_BIT,x            ; 9AD9
         and  DISK_SLOTS           ; 9ADC
         bne  L9AE3                ; 9ADF
         clc                       ; 9AE1
         rts                       ; 9AE2
L9AE3
         tya                       ; 9AE3
         asl                       ; 9AE4
         tax                       ; 9AE5
         lda  DSK_JUMPS,x          ; 9AE6
         sta  DSK_GO+1             ; 9AE9
         lda  DSK_JUMPS+1,x        ; 9AEC
         sta  DSK_GO+2             ; 9AEF
         txa                       ; 9AF2
         beq  L9AF8                ; 9AF3
         jsr  CLICK                ; 9AF5
L9AF8
         clc                       ; 9AF8
         rts                       ; 9AF9
DSK_JUMPS        dta $02,$9B,$1A,$9B,$23,$9B,$2C,$9B  ; 9AFA disk sub-menu: DISK_BACK, DISK_LOAD, DISK_SAVE, DISK_ERASE

* disk sub-menu: back to the menu --------------------------
DISK_BACK
         jsr  DISK_RESETC          ; 9B02
         lda  #$00                 ; 9B05
         sta  PANEL_ST             ; 9B07
         sec                       ; 9B09
         rts                       ; 9B0A

* disk sub-menu: click and reset ---------------------------
DISK_RESETC
         jsr  CLICK                ; 9B0B

* disk sub-menu: reset the dispatch to DISK_MENU -----------
DISK_RESET
         lda  #$64                 ; 9B0E
         sta  DSK_GO+1             ; 9B10
         lda  #$9A                 ; 9B13
         sta  DSK_GO+2             ; 9B15
         clc                       ; 9B18
         rts                       ; 9B19

* disk sub-menu: load a set --------------------------------
DISK_LOAD
         ldx  #$07                 ; 9B1A
         jsr  ASK_SET              ; 9B1C
         lda  #$72                 ; 9B1F
         bne  L9B33                ; 9B21

* disk sub-menu: save a set --------------------------------
DISK_SAVE
         ldx  #$0F                 ; 9B23
         jsr  ASK_SET              ; 9B25
         lda  #$77                 ; 9B28
         bne  L9B33                ; 9B2A

* disk sub-menu: erase a set -------------------------------
DISK_ERASE
         ldx  #$17                 ; 9B2C
         jsr  ASK_SET              ; 9B2E
         lda  #$65                 ; 9B31
L9B33
         ldx  DSK_SET              ; 9B33
         inx                       ; 9B36
         jsr  IO_DO                ; 9B37
         php                       ; 9B3A
         jsr  DISK_RESET           ; 9B3B
         plp                       ; 9B3E
         bmi  L9B43                ; 9B3F
         clc                       ; 9B41
         rts                       ; 9B42
L9B43
         jsr  IO_ERRMSG            ; 9B43
         jsr  MESSAGE              ; 9B46
         lda  #$0A                 ; 9B49
         sta  BEEP                 ; 9B4B
         inc  DSK_WAIT             ; 9B4E
         clc                       ; 9B51
         rts                       ; 9B52

* tape/disk error -> message ("błąd numer ..." digits) -----
IO_ERRMSG
         tya                       ; 9B53
         ldx  #$FF                 ; 9B54
L9B56
         inx                       ; 9B56
         ldy  ERR_CODES,x          ; 9B57
         beq  L9B61                ; 9B5A
         cmp  ERR_CODES,x          ; 9B5C
         bne  L9B56                ; 9B5F
L9B61
         tay                       ; 9B61
         lda  ERR_MSGS,x           ; 9B62
         pha                       ; 9B65
         tya                       ; 9B66
         jsr  TO_DIGITS            ; 9B67
         clc                       ; 9B6A
         adc  #$A0                 ; 9B6B
         sta  ERR_DIGITS           ; 9B6D
         clc                       ; 9B70
         txa                       ; 9B71
         adc  #$A0                 ; 9B72
         sta  ERR_DIGITS+1         ; 9B74
         pla                       ; 9B77
         rts                       ; 9B78

* do a tape/disk command (A = letter) with IRQs off --------
IO_DO
         pha                       ; 9B79
         txa                       ; 9B7A
         pha                       ; 9B7B
         jsr  ED_DLIST             ; 9B7C
         lda  #$80                 ; 9B7F
         sta  IRQEN                ; 9B81
         pla                       ; 9B84
         tax                       ; 9B85
         pla                       ; 9B86
         sta  LAST_CMD             ; 9B87
         jsr  IO_CMD               ; 9B8A
         ldx  DISK_SLOTS           ; 9B8D
         bmi  L9B95                ; 9B90
         sta  DISK_SLOTS           ; 9B92
L9B95
         ldx  #$00                 ; 9B95
         stx  IRQEN                ; 9B97
         tya                       ; 9B9A
         pha                       ; 9B9B
         lda  IO_LOADED            ; 9B9C
         beq  L9BAD                ; 9B9F
         tya                       ; 9BA1
         bpl  L9BAA                ; 9BA2
         jsr  PLANETS_INIT         ; 9BA4
         jmp  L9BAD                ; 9BA7
L9BAA
         jsr  PLANETS_FILL         ; 9BAA
L9BAD
         pla                       ; 9BAD
         tay                       ; 9BAE
         rts                       ; 9BAF
LAST_CMD         dta $00                              ; 9BB0 letter of the last tape / disk command

* message for the last tape/disk operation -----------------
IO_MSG_
         ldx  #$1B                 ; 9BB1
         lda  LAST_CMD             ; 9BB3
         cmp  #$72                 ; 9BB6
         beq  L9BBB                ; 9BB8
         inx                       ; 9BBA
L9BBB
         txa                       ; 9BBB
         jmp  MESSAGE              ; 9BBC

* ask "wczytać/zapisać/skasować zestaw 0n? tak nie" --------
ASK_SET
         ldy  #$07                 ; 9BBF
L9BC1
         lda  DEV_WORDS,x          ; 9BC1
         sta  ASK_WORD,y           ; 9BC4
         dex                       ; 9BC7
         dey                       ; 9BC8
         bpl  L9BC1                ; 9BC9
         clc                       ; 9BCB
         lda  DSK_SET              ; 9BCC
         adc  #$31                 ; 9BCF
         sta  ASK_NUM              ; 9BD1
         lda  #$10                 ; 9BD4
         jsr  MESSAGE              ; 9BD6
         jsr  ASK_YESNO            ; 9BD9
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
         jmp  DISK_RESET           ; 9BE8

* menu function "zapisz Robbo": prepare, next command SAVEGAME_GO ---
M_SAVEGAME
         jsr  ALL_EMPTY            ; 9BEB
         lda  #$77                 ; 9BEE
         ldx  #$00                 ; 9BF0

* run SAVEGAME_GO as the next command, with A = command letter, X = slot ---
SG_SET
         ldy  #$06                 ; 9BF2
         sty  MENU_CALL+1          ; 9BF4
         ldy  #$9C                 ; 9BF7
         sty  MENU_CALL+2          ; 9BF9
         sta  SG_CMD               ; 9BFC
         stx  SG_SLOT              ; 9BFF
         clc                       ; 9C02
         rts                       ; 9C03
SG_CMD           dta $00                              ; 9C04 command letter for SAVEGAME_GO ("w" zapisz Robbo, tape: "r" / "w")
SG_SLOT          dta $00                              ; 9C05 slot for SAVEGAME_GO

* zapisz Robbo: save the game ------------------------------
SAVEGAME_GO
         lda  #$03                 ; 9C06
         ldx  DISK_SLOTS           ; 9C08
         bpl  L9C0F                ; 9C0B
         lda  #$04                 ; 9C0D
L9C0F
         sta  PANEL_ST             ; 9C0F
         jsr  PANEL                ; 9C11
         lda  #$00                 ; 9C14
         sta  PANEL_ST             ; 9C16
         lda  #$01                 ; 9C18
         jsr  MESSAGE              ; 9C1A
         jsr  WAIT_KEY             ; 9C1D
         bcc  L9C24                ; 9C20
         clc                       ; 9C22
         rts                       ; 9C23
L9C24
         beq  L9C2B                ; 9C24
         jsr  CLICK                ; 9C26
         sec                       ; 9C29
         rts                       ; 9C2A
L9C2B
         ldx  SG_SLOT              ; 9C2B
         lda  SG_CMD               ; 9C2E
         jsr  IO_DO                ; 9C31
         bmi  L9C38                ; 9C34
         sec                       ; 9C36
         rts                       ; 9C37
L9C38
         jsr  IO_ERRMSG            ; 9C38
         jmp  MSG_WAIT             ; 9C3B

* menu function "test Robbo": test the whole game ----------
M_TESTALL
         jsr  ALL_EMPTY            ; 9C3E
         lda  #$80                 ; 9C41
         sta  TP_TEST              ; 9C43
         sta  BRKKEY               ; 9C46
         jmp  TP_START             ; 9C48

* all planets empty? -> message "wszystkie planety są puste!" ---
ALL_EMPTY
         ldx  #$1F                 ; 9C4B
         lda  #$00                 ; 9C4D
L9C4F
         ora  PLANET_STATE,x       ; 9C4F
         dex                       ; 9C52
         bpl  L9C4F                ; 9C53
         tax                       ; 9C55
         bne  L9C5F                ; 9C56
         pla                       ; 9C58
         pla                       ; 9C59
         lda  #$13                 ; 9C5A
         jmp  MSG_WAIT             ; 9C5C
L9C5F
         ldx  #$1F                 ; 9C5F
         lda  #$00                 ; 9C61
L9C63
         ora  ORDER,x              ; 9C63
         dex                       ; 9C66
         bpl  L9C63                ; 9C67
         tax                       ; 9C69
         bpl  L9CC6                ; 9C6A
         lda  #$12                 ; 9C6C
         jsr  MESSAGE              ; 9C6E
         jsr  ASK_YESNO            ; 9C71
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
         lda  ORDER,x              ; 9C88
         sta  PLAY_ORDER,x         ; 9C8B
         bpl  L9C9D                ; 9C8E
         and  #$7F                 ; 9C90
         tay                       ; 9C92
         lda  PLANET_STATE,y       ; 9C93
         bmi  L9CA3                ; 9C96
         bne  L9C9D                ; 9C98
         sta  PLAY_ORDER,x         ; 9C9A
L9C9D
         inx                       ; 9C9D
         cpx  #$20                 ; 9C9E
         bcc  L9C88                ; 9CA0
         rts                       ; 9CA2
L9CA3
         pla                       ; 9CA3
         pla                       ; 9CA4
         sty  PLANET               ; 9CA5
         lda  PLANET_STATE,y       ; 9CA7
         and  #$7F                 ; 9CAA
         jsr  MSG_ADDR             ; 9CAC
         ldy  #$FF                 ; 9CAF
L9CB1
         iny                       ; 9CB1
         lda  (PTR2),y             ; 9CB2
         sta  MSG_LIST,y           ; 9CB4
         bne  L9CB1                ; 9CB7
         tya                       ; 9CB9
L9CBA
         iny                       ; 9CBA
         sta  (PTR2),y             ; 9CBB
         cpy  #$1E                 ; 9CBD
         bcc  L9CBA                ; 9CBF
         lda  #$14                 ; 9CC1
         jmp  MSG_WAIT             ; 9CC3
L9CC6
         ldx  #$00                 ; 9CC6
L9CC8
         txa                       ; 9CC8
         tay                       ; 9CC9
         lda  PLANET_STATE,x       ; 9CCA
         bmi  L9CA3                ; 9CCD
         beq  L9CD4                ; 9CCF
         tya                       ; 9CD1
         ora  #$80                 ; 9CD2
L9CD4
         sta  PLAY_ORDER,x         ; 9CD4
         inx                       ; 9CD7
         cpx  #$20                 ; 9CD8
         bcc  L9CC8                ; 9CDA
         rts                       ; 9CDC
