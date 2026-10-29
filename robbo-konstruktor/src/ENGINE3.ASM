; ENGINE3.ASM - title page of the saved Robbo game (also "test Robbo"): display list, texts, logo, planet sequence
; $35C0-$395C

         org $35C0


* title page program - start of the saved Robbo game and of "test Robbo" ($35C1 = from the Konstruktor, $35C2 = planets) ---
TP_START
         lda  TP_START             ; 35C0
         cli                       ; 35C3
         cld                       ; 35C4
         ldx  #$FF                 ; 35C5
         txs                       ; 35C7
         lda  #$3A                 ; 35C8
         jsr  TP_PAGE              ; 35CA
         jmp  TP_LOOP              ; 35CD
         dta $70,$70,$70,$70,$4A,$00,$B6,$00,$0A,$00,$0A,$00,$0A,$00,$0A,$00 ; 35D0
         dta $0A,$00,$0A,$00,$0A,$30,$70,$70,$42,$00,$3A,$10,$02,$10,$02,$10 ; 35E0
         dta $02,$10,$02,$10,$02,$10,$02,$10,$02,$70,$70,$70,$42,$03,$36,$02 ; 35F0
         dta $41,$D0,$35                              ; 3600
;   Ta gra powstała  przy pomocy
         dta d'  Ta gra powsta]a  przy pomocy  '      ; 3603
; Robbo Konstruktora  /1990 Avalon
         dta d'Robbo Konstruktora  /1990 Avalon'      ; 3623
; wciśnij klawisz BREAK aby wrócić
         dta d'wci{nij klawisz BREAK aby wr_ci['      ; 3643
;       do Robbo Konstruktora
         dta d'      do Robbo Konstruktora     '      ; 3663

* title page: start text; fire / START plays, OPTION or a pause starts the demo; then the congratulation text ---
TP_LOOP
         lda  #$3A                 ; 3683
         sta  $35EA                ; 3685
L3688
         jsr  TP_FRAME             ; 3688
         jsr  TP_KEY               ; 368B
         bcc  L3695                ; 368E
         jsr  TP_DEMO              ; 3690
         bcs  L3688                ; 3693
L3695
         jsr  TP_PLAY              ; 3695
         bcc  L369D                ; 3698
L369A
         jmp  TP_START             ; 369A
L369D
         lda  TP_DEMOFLAG          ; 369D
         bne  L369A                ; 36A0
         lda  #$3B                 ; 36A2
         jsr  TP_PAGE              ; 36A4
L36A7
         jsr  TP_FRAME             ; 36A7
         jsr  TP_KEY               ; 36AA
         bcs  L36A7                ; 36AD
         lda  #$00                 ; 36AF
         sta  TP_RNUM              ; 36B1
         sta  TP_RPOS              ; 36B4
         sta  $E9                  ; 36B7
         jmp  TP_LOOP              ; 36B9

* play the planets in the order $39E0 with ENGINE_PLAY, 8 lives; every 4th planet is the restart point; carry set = game over ---
TP_PLAY
         jsr  ENGINE_INIT          ; 36BC
         ldx  TP_RPOS              ; 36BF
         dex                       ; 36C2
         stx  $EC                  ; 36C3
         lda  TP_RNUM              ; 36C5
         sta  $EA                  ; 36C8
         lda  #$08                 ; 36CA
         sta  $EB                  ; 36CC
L36CE
         inc  $EC                  ; 36CE
         ldx  $EC                  ; 36D0
         cpx  TP_LAST              ; 36D2
         beq  L36DB                ; 36D5
         bcc  L36DB                ; 36D7
         clc                       ; 36D9
         rts                       ; 36DA
L36DB
         lda  $39E0,x              ; 36DB
         bpl  L36CE                ; 36DE
         ldx  $EC                  ; 36E0
         lda  $39E0,x              ; 36E2
         and  #$7F                 ; 36E5
         sta  $E6                  ; 36E7
         lda  #$00                 ; 36E9
         sta  $E2                  ; 36EB
         lda  #$51                 ; 36ED
         sta  $E3                  ; 36EF
         ldy  #$F0                 ; 36F1
L36F3
         lda  ($E2),y              ; 36F3
         and  #$1F                 ; 36F5
         cmp  $E6                  ; 36F7
         beq  L3707                ; 36F9
         inc  $E3                  ; 36FB
         inc  $E3                  ; 36FD
         lda  $E3                  ; 36FF
         cmp  #$94                 ; 3701
         bcc  L36F3                ; 3703
         bcs  L36CE                ; 3705
L3707
         lda  $EA                  ; 3707
         and  #$03                 ; 3709
         bne  L371C                ; 370B
         lda  TP_DEMOFLAG          ; 370D
         bne  L371C                ; 3710
         lda  $EA                  ; 3712
         sta  TP_RNUM              ; 3714
         lda  $EC                  ; 3717
         sta  TP_RPOS              ; 3719
L371C
         dec  $E3                  ; 371C
         lda  TP_DEMOFLAG          ; 371E
         clc                       ; 3721
         beq  L3725                ; 3722
         sec                       ; 3724
L3725
         lda  $E3                  ; 3725
         ldx  $EA                  ; 3727
         inx                       ; 3729
         ldy  $EB                  ; 372A
         jsr  ENGINE_PLAY          ; 372C
         dex                       ; 372F
         stx  $EA                  ; 3730
         sty  $EB                  ; 3732
         tya                       ; 3734
         cpy  #$99                 ; 3735
         bne  L36CE                ; 3737
         sec                       ; 3739
         rts                       ; 373A
         dta $00                                      ; 373B

* fire / START / SHIFT pressed: carry clear on a new press ---
TP_KEY
         lda  SKCTL                ; 373C
         lsr                       ; 373F
         lsr                       ; 3740
         lsr                       ; 3741
         and  #$01                 ; 3742
         and  CONSOL               ; 3744
         and  TRIG0                ; 3747
         and  $D011                ; 374A
         cmp  $373B                ; 374D
         sec                       ; 3750
         beq  L375A                ; 3751
         sta  $373B                ; 3753
         tax                       ; 3756
         bne  L375A                ; 3757
         clc                       ; 3759
L375A
         rts                       ; 375A

* OPTION pressed or a long pause: demo (TP_DEMOFLAG = $80), carry clear ---
TP_DEMO
         lda  CONSOL               ; 375B
         and  #$04                 ; 375E
         beq  L376F                ; 3760
         lda  $E9                  ; 3762
         cmp  #$08                 ; 3764
         bcs  L376F                ; 3766
         lda  #$00                 ; 3768
         sta  TP_DEMOFLAG          ; 376A
         sec                       ; 376D
         rts                       ; 376E
L376F
         lda  #$80                 ; 376F
         sta  TP_DEMOFLAG          ; 3771
         clc                       ; 3774
         rts                       ; 3775

* title page frame: timer, BREAK back to the Konstruktor, colour bars of the logo and the texts ---
TP_FRAME
         inc  $E8                  ; 3776
         bne  L377C                ; 3778
         inc  $E9                  ; 377A
L377C
         lsr  $4D                  ; 377C
         lda  TP_TEST              ; 377E
         beq  L378A                ; 3781
         lda  $11                  ; 3783
         bne  L378A                ; 3785
         jmp  TP_EXIT              ; 3787
L378A
         lda  $E8                  ; 378A
         bne  L3795                ; 378C
         lda  RANDOM               ; 378E
         and  #$F0                 ; 3791
         sta  $ED                  ; 3793
L3795
         ldx  #$00                 ; 3795
         lda  $E8                  ; 3797
         cmp  #$20                 ; 3799
         bne  L379F                ; 379B
         ldx  #$10                 ; 379D
L379F
         lda  $3937,x              ; 379F
         and  #$0F                 ; 37A2
         ora  $ED                  ; 37A4
         sta  $3937,x              ; 37A6
         inx                       ; 37A9
         cpx  #$10                 ; 37AA
         beq  L37B2                ; 37AC
         cpx  #$19                 ; 37AE
         bcc  L379F                ; 37B0
L37B2
         lda  #$13                 ; 37B2
L37B4
         cmp  VCOUNT               ; 37B4
         bne  L37B4                ; 37B7
         ldx  #$10                 ; 37B9
         lda  $E8                  ; 37BB
         bmi  L37D4                ; 37BD
         lda  $E8                  ; 37BF
         lsr                       ; 37C1
         lsr                       ; 37C2
         pha                       ; 37C3
         and  #$0F                 ; 37C4
         tax                       ; 37C6
         pla                       ; 37C7
         and  #$10                 ; 37C8
         bne  L37D4                ; 37CA
         stx  $E6                  ; 37CC
         sec                       ; 37CE
         lda  #$0F                 ; 37CF
         sbc  $E6                  ; 37D1
         tax                       ; 37D3
L37D4
         ldy  #$08                 ; 37D4
L37D6
         lda  $3937,x              ; 37D6
         sta  COLPF2               ; 37D9
         sta  WSYNC                ; 37DC
         sta  WSYNC                ; 37DF
         sta  WSYNC                ; 37E2
         sta  WSYNC                ; 37E5
         sta  WSYNC                ; 37E8
         inx                       ; 37EB
         dey                       ; 37EC
         bpl  L37D6                ; 37ED
         lda  #$00                 ; 37EF
         sta  COLPF2               ; 37F1
         lda  #$31                 ; 37F4
L37F6
         cmp  VCOUNT               ; 37F6
         bne  L37F6                ; 37F9
         ldy  #$08                 ; 37FB
L37FD
         ldx  #$00                 ; 37FD
L37FF
         lda  $3950,x              ; 37FF
         sta  COLPF1               ; 3802
         sta  WSYNC                ; 3805
         inx                       ; 3808
         cpx  #$0A                 ; 3809
         bcc  L37FF                ; 380B
         dey                       ; 380D
         bne  L37FD                ; 380E
         lda  #$00                 ; 3810
         sta  COLPF2               ; 3812
         rts                       ; 3815

* draw the "ROBBO" logo into the title screen $B600 (bitmap $391F, pixels doubled) ---
TP_LOGO
         lda  #$00                 ; 3816
         tay                       ; 3818
L3819
         sta  $B600,y              ; 3819
         dey                       ; 381C
         bne  L3819                ; 381D
         lda  #$04                 ; 381F
         sta  $E4                  ; 3821
L3823
         lda  $E4                  ; 3823
         tay                       ; 3825
         asl                       ; 3826
         adc  $E4                  ; 3827
         adc  #$01                 ; 3829
         sta  $E0                  ; 382B
         lda  #$B6                 ; 382D
         sta  $E1                  ; 382F
         ldx  $391A,y              ; 3831
         ldy  #$00                 ; 3834
L3836
         txa                       ; 3836
         pha                       ; 3837
         lda  $391F,x              ; 3838
         ldx  #$08                 ; 383B
L383D
         asl                       ; 383D
         php                       ; 383E
         rol  $E6                  ; 383F
         rol  $E7                  ; 3841
         plp                       ; 3843
         rol  $E6                  ; 3844
         rol  $E7                  ; 3846
         dex                       ; 3848
         bne  L383D                ; 3849
         lda  $E7                  ; 384B
         sta  ($E0),y              ; 384D
         iny                       ; 384F
         lda  $E6                  ; 3850
         sta  ($E0),y              ; 3852
         clc                       ; 3854
         tya                       ; 3855
         adc  #$0F                 ; 3856
         tay                       ; 3858
         pla                       ; 3859
         tax                       ; 385A
         inx                       ; 385B
         txa                       ; 385C
         and  #$07                 ; 385D
         bne  L3836                ; 385F
         dec  $E4                  ; 3861
         bpl  L3823                ; 3863
         lda  $E8                  ; 3865
         sta  $E6                  ; 3867
         ldx  #$08                 ; 3869
L386B
         sec                       ; 386B
         lda  $E6                  ; 386C
         sbc  #$01                 ; 386E
         and  #$F0                 ; 3870
         sta  $E6                  ; 3872
         lda  $3937,x              ; 3874
         and  #$0F                 ; 3877
         sta  $3937,x              ; 3879
         dex                       ; 387C
         bpl  L386B                ; 387D
         rts                       ; 387F

* show the title page with the text page A ($3A start / $3B congratulation) ---
TP_PAGE
         pha                       ; 3880
         lda  TP_TEST              ; 3881
         beq  L38A5                ; 3884
         lda  $11                  ; 3886
         bne  L38A5                ; 3888

* back to the Konstruktor ("BREAK aby wrocic"): texts back to normal video, JMP START ---
TP_EXIT
         lda  #$00                 ; 388A
         sta  SDMCTL               ; 388C
         sta  DMACTL               ; 388F
         jsr  TP_HALT              ; 3892
         ldy  #$00                 ; 3895
L3897
         lda  $3B00,y              ; 3897
         and  #$7F                 ; 389A
         sta  $3B00,y              ; 389C
         dey                       ; 389F
         bne  L3897                ; 38A0
         jmp  START                ; 38A2
L38A5
         jsr  TP_HALT              ; 38A5
         ldy  #$00                 ; 38A8
L38AA
         lda  $3B00,y              ; 38AA
         ora  #$80                 ; 38AD
         sta  $3B00,y              ; 38AF
         dey                       ; 38B2
         bne  L38AA                ; 38B3
         lda  #$00                 ; 38B5
         ldx  #$08                 ; 38B7
L38B9
         sta  $02C0,x              ; 38B9
         sta  COLPM0,x             ; 38BC
         dex                       ; 38BF
         bpl  L38B9                ; 38C0
         sta  SDMCTL               ; 38C2
         sta  DMACTL               ; 38C5
         sta  $ED                  ; 38C8
         sta  $E9                  ; 38CA
         lda  #$80                 ; 38CC
         sta  $E8                  ; 38CE
         lda  #$4C                 ; 38D0
         sta  CHBAS                ; 38D2
         lda  #$D0                 ; 38D5
         sta  SDLSTL               ; 38D7
         lda  #$35                 ; 38DA
         sta  SDLSTH               ; 38DC
         ldx  #$03                 ; 38DF
         ldy  #$36                 ; 38E1
         lda  TP_TEST              ; 38E3
         beq  L38EC                ; 38E6
         ldx  #$43                 ; 38E8
         ldy  #$36                 ; 38EA
L38EC
         stx  $35FD                ; 38EC
         sty  $35FE                ; 38EF
         tax                       ; 38F2
         beq  L38F7                ; 38F3
         lda  #$80                 ; 38F5
L38F7
         sta  IRQEN                ; 38F7
         beq  L3904                ; 38FA
         lda  #$00                 ; 38FC
         sta  TP_RNUM              ; 38FE
         sta  TP_RPOS              ; 3901
L3904
         jsr  TP_LOGO              ; 3904
         pla                       ; 3907
         sta  $35EA                ; 3908
         lda  #$21                 ; 390B
         sta  SDMCTL               ; 390D
         jsr  TP_KEY               ; 3910

* wait for the next frame (copy of HALT) -------------------
TP_HALT
         lda  RTCLOK+2             ; 3913
L3915
         cmp  RTCLOK+2             ; 3915
         beq  L3915                ; 3917
         rts                       ; 3919
         dta $00,$08,$10,$10,$08,$FC,$E6,$E3,$E3,$E6,$FC,$E6,$E3,$00,$3C,$76 ; 391A
         dta $E3,$E3,$E3,$E3,$7E,$E0,$FC,$E6,$E3,$E3,$E3,$E3,$FE,$04,$06,$08 ; 392A
         dta $0A,$0A,$0C,$0E,$0E,$0C,$0A,$0A,$08,$08,$06,$06,$04,$04,$06,$08 ; 393A
         dta $0A,$0C,$0E,$0C,$0A,$08,$00,$04,$06,$08,$0A,$0A,$08,$06,$04,$0E ; 394A
TP_RNUM          dta $00                              ; 395A restart point: planet number shown
TP_RPOS          dta $00                              ; 395B restart point: position in the planet order
TP_DEMOFLAG      dta $00                              ; 395C title page: $80 = demo
