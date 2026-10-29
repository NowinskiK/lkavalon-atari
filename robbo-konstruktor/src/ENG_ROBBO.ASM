; ENG_ROBBO.ASM - engine: Robbo - creatures and magnets next to him, move, shoot, push, door / screw / exit
; $2582-$28EB

         org $2582


* is a creature next to Robbo (Robbo: "czy obok jest fac?"), tested from Robbo's side; carry clear = Robbo destroyed ---
TFAC
         lda  FX                   ; 2582
         sta  X                    ; 2584
         lda  FY                   ; 2586
         sta  Y                    ; 2588
         jsr  TST_                 ; 258A
         cmp  #$2A                 ; 258D
         beq  L2593                ; 258F
         sec                       ; 2591
         rts                       ; 2592
L2593
         jsr  T_RT                 ; 2593
         jsr  ZABJ                 ; 2596
         bcc  L25B6                ; 2599
         jsr  T_LT                 ; 259B
         jsr  ZABJ                 ; 259E
         bcc  L25B6                ; 25A1
         jsr  T_UP                 ; 25A3
         jsr  ZABJ                 ; 25A6
         bcc  L25B6                ; 25A9
         jsr  T_DW                 ; 25AB
         jsr  ZABJ                 ; 25AE
         bcc  L25B6                ; 25B1
         jsr  MGNL                 ; 25B3
L25B6
         rts                       ; 25B6

* kill (Robbo: ZABJ "zabij"): if X is eyes $26 or a creature $41-$4E, put an explosion at Robbo ---
ZABJ
         cpx  #$26                 ; 25B7
         beq  L25C5                ; 25B9
         cpx  #$41                 ; 25BB
         bcc  L25C3                ; 25BD
         cpx  #$4F                 ; 25BF
         bcc  L25C5                ; 25C1
L25C3
         sec                       ; 25C3
         rts                       ; 25C4
L25C5
         lda  #$0A                 ; 25C5
         jsr  SOUND_               ; 25C7
         lda  #$61                 ; 25CA
         jsr  PUT_                 ; 25CC
         clc                       ; 25CF
         rts                       ; 25D0

* magnet in Robbo's row (Robbo MGNL, tested from Robbo's side): magnet $29 to the right / $28 to the left pulls Robbo ---
MGNL
         jsr  TST_                 ; 25D1
         ldx  X                    ; 25D4
L25D6
         iny                       ; 25D6
         inx                       ; 25D7
         cpx  #$10                 ; 25D8
         bcs  L25FB                ; 25DA
         lda  (ADDR),y             ; 25DC
         cmp  #$20                 ; 25DE
         beq  L25D6                ; 25E0
         ldx  #$0C                 ; 25E2
         ldy  #$0B                 ; 25E4
         cmp  #$29                 ; 25E6
         bne  L25FB                ; 25E8
L25EA
         sty  LM                   ; 25EA
         txa                       ; 25EC
         jsr  PUT_                 ; 25ED
         lda  #$0E                 ; 25F0
         jsr  SOUND_               ; 25F2
         lda  #$01                 ; 25F5
         sta  FAC                  ; 25F7
         clc                       ; 25F9
         rts                       ; 25FA
L25FB
         dec  ADDR+1               ; 25FB
         ldy  #$00                 ; 25FD
         ldx  X                    ; 25FF
L2601
         dey                       ; 2601
         dex                       ; 2602
         bmi  L2613                ; 2603
         lda  (ADDR),y             ; 2605
         cmp  #$20                 ; 2607
         beq  L2601                ; 2609
         ldx  #$0B                 ; 260B
         ldy  #$07                 ; 260D
         cmp  #$28                 ; 260F
         beq  L25EA                ; 2611
L2613
         sec                       ; 2613
         rts                       ; 2614

* Robbo appears (Robbo: "pojawiaj"), code $1B: FAC = 1, then WFA1 ---
WFAC
         lda  #$01                 ; 2615
         sta  FAC                  ; 2617

* Robbo appears: when the scroll is done, sound $0B, Robbo's appearing shape $6A ---
WFA1
         lda  VSF                  ; 2619
         beq  L261E                ; 261B
         rts                       ; 261D
L261E
         jsr  HALT                 ; 261E
         lda  VSF                  ; 2621
         beq  L2626                ; 2623
         rts                       ; 2625
L2626
         lda  #$0B                 ; 2626
         jsr  SOUND_               ; 2628
         lda  #$6A                 ; 262B
         jmp  PUT_                 ; 262D

* Robbo $2A (Robbo: "ruch"): only notes FX / FY, FAC = 1 - the move itself is FAC_STEP, from CHNMON ---
MFAC
         lda  X                    ; 2630
         sta  FX                   ; 2632
         lda  Y                    ; 2634
         sta  FY                   ; 2636
         lda  #$01                 ; 2638
         sta  FAC                  ; 263A
         rts                       ; 263C

* Robbo's turn: TFAC, FAC_MOVE, TFAC again -----------------
FAC_TURN
         jsr  TFAC                 ; 263D
         bcc  L2645                ; 2640
         jsr  FAC_MOVE             ; 2642
L2645
         jmp  TFAC                 ; 2645

* Robbo moves or shoots (body of Robbo's MFAC): fire + direction shoots (ammunition), else MFC1 ---
FAC_MOVE
         jsr  TST_                 ; 2648
         cmp  #$2A                 ; 264B
         beq  L2650                ; 264D
         rts                       ; 264F
L2650
         dec  STRC                 ; 2650
         bpl  L2658                ; 2653
         inc  STRC                 ; 2655
L2658
         lda  DEMO                 ; 2658
         beq  L2663                ; 265A
         lda  RANDOM               ; 265C
         and  #$0F                 ; 265F
         beq  L266B                ; 2661
L2663
         lda  FIRE                 ; 2663
         beq  L266B                ; 2666
         jmp  MFC1                 ; 2668
L266B
         lda  #$00                 ; 266B
         sta  RUCH                 ; 266D
         lda  STRC                 ; 266F
         beq  L2675                ; 2672
         rts                       ; 2674
L2675
         lda  DEMO                 ; 2675
         beq  L267D                ; 2677
         lda  LM                   ; 2679
         bpl  L2685                ; 267B
L267D
         lda  MOVE_DIR             ; 267D
         cmp  #$0F                 ; 2680
         bne  L2685                ; 2682
         rts                       ; 2684
L2685
         sta  LM                   ; 2685
         ldx  NABO                 ; 2687
         bne  L268F                ; 2689
         inc  $2502                ; 268B
         rts                       ; 268E
L268F
         pha                       ; 268F
         sed                       ; 2690
         sec                       ; 2691
         lda  NABO                 ; 2692
         sbc  #$01                 ; 2694
         sta  NABO                 ; 2696
         cld                       ; 2698
         pla                       ; 2699
         ldx  #$05                 ; 269A
         stx  STRC                 ; 269C
         ldx  #$FF                 ; 269F

* shot direction number from the bits of LM, start the bullet through KIET / SJMP (Robbo KIES) ---
KIES
         inx                       ; 26A1
         lsr                       ; 26A2
         bcs  KIES                 ; 26A3
         cpx  #$04                 ; 26A5
         bcc  L26AA                ; 26A7
         rts                       ; 26A9
L26AA
         txa                       ; 26AA
         asl                       ; 26AB
         tax                       ; 26AC
         lda  KIET,x               ; 26AD
         sta  $26BA                ; 26B0
         lda  KIET+1,x             ; 26B3
         sta  $26BB                ; 26B6

* JSR to the bullet start for the direction (operand from KIET, Robbo SJMP) ---
SJMP
         jsr  SJMP                 ; 26B9
         jsr  TST_                 ; 26BC
         jsr  PUT_                 ; 26BF
         lda  #$01                 ; 26C2
         jmp  SOUND_               ; 26C4
KIET             dta $6D,$2B,$93,$2B,$01,$2B,$47,$2B  ; 26C7 bullet start for each shot direction: PP1U, PP1D, PP1L, PP1R (Robbo KIET)
STRC             dta $00                              ; 26CF delay between Robbo's shots (Robbo STRC)

* Robbo moves in the direction (stick; random in the demo): LT_ / RT_ / UP_ / DW_, blocked -> PHAJ (Robbo MFC1) ---
MFC1
         ldx  DEMO                 ; 26D0
         beq  L26EE                ; 26D2
         lda  RUCH                 ; 26D4
         beq  L26DF                ; 26D6
         lda  RANDOM               ; 26D8
         and  #$0F                 ; 26DB
         bne  L26EA                ; 26DD
L26DF
         lda  RANDOM               ; 26DF
         and  #$03                 ; 26E2
         tax                       ; 26E4
         lda  $296B,x              ; 26E5
         bpl  L26F1                ; 26E8
L26EA
         lda  LM                   ; 26EA
         bpl  L26F1                ; 26EC
L26EE
         lda  MOVE_DIR             ; 26EE
L26F1
         cmp  #$0F                 ; 26F1
         beq  L26F7                ; 26F3
         sta  LM                   ; 26F5
L26F7
         ldx  #$01                 ; 26F7
         stx  RUCH                 ; 26F9
         lsr                       ; 26FB
         bcc  L271D                ; 26FC
         lsr                       ; 26FE
         bcc  L2727                ; 26FF
         lsr                       ; 2701
         bcc  L2709                ; 2702
         lsr                       ; 2704
         bcc  L2713                ; 2705
         bcs  MFX1                 ; 2707
L2709
         jsr  LT_                  ; 2709
         bcc  MFEX                 ; 270C
         dec  X                    ; 270E
         jmp  PHAJ                 ; 2710
L2713
         jsr  RT_                  ; 2713
         bcc  MFEX                 ; 2716
         inc  X                    ; 2718
         jmp  PHAJ                 ; 271A
L271D
         jsr  UP_                  ; 271D
         bcc  MFEX                 ; 2720
         dec  Y                    ; 2722
         jmp  PHAJ                 ; 2724
L2727
         jsr  DW_                  ; 2727
         bcc  MFEX                 ; 272A
         inc  Y                    ; 272C
         jmp  PHAJ                 ; 272E

* Robbo stops (RUCH = 0), then MFEX (Robbo MFX1) -----------
MFX1
         lda  #$00                 ; 2731
         sta  RUCH                 ; 2733

* Robbo at X / Y: put him, his screen address is the scroll target ($2491 / $2495), FX / FY; the creature and magnet tests of Robbo's MFEX moved to TFAC / MGNL (Robbo MFEX) ---
MFEX
         jsr  TST_                 ; 2735
         jsr  PUT_                 ; 2738
         lda  #$00                 ; 273B
         sta  SCRA+1               ; 273D
         lda  Y                    ; 273F
         asl                       ; 2741
         asl                       ; 2742
         asl                       ; 2743
         asl                       ; 2744
         rol  SCRA+1               ; 2745
         asl                       ; 2747
         rol  SCRA+1               ; 2748
         asl                       ; 274A
         rol  SCRA+1               ; 274B
         asl  X                    ; 274D
         adc  X                    ; 274F
         sta  SCRA                 ; 2751
         lsr  X                    ; 2753
         lda  SCRA+1               ; 2755
         adc  #$B6                 ; 2757
         sta  SCRA+1               ; 2759
         lda  SCRA                 ; 275B
         sta  $2491                ; 275D
         lda  SCRA+1               ; 2760
         sta  $2495                ; 2762
         lda  X                    ; 2765
         sta  FX                   ; 2767
         lda  Y                    ; 2769
         sta  FY                   ; 276B
         rts                       ; 276D

* push an object (Robbo: "pchaj?") -------------------------
PHAJ
         cmp  #$0E                 ; 276E
         beq  L2786                ; 2770
         cmp  #$0D                 ; 2772
         beq  L2786                ; 2774
         cmp  #$3F                 ; 2776
         beq  L2786                ; 2778
         cmp  #$23                 ; 277A
         beq  L2786                ; 277C
         cmp  #$14                 ; 277E
         beq  L2786                ; 2780
         cmp  #$40                 ; 2782
         bne  L27AA                ; 2784
L2786
         jsr  FD_                  ; 2786
         ldx  #$00                 ; 2789
         bcs  L279A                ; 278B
         jsr  TST_                 ; 278D
         jsr  PUT_                 ; 2790
         lda  #$08                 ; 2793
         jsr  SOUND_               ; 2795
         ldx  #$01                 ; 2798
L279A
         stx  RUCH                 ; 279A
         lda  X1                   ; 279C
         sta  X                    ; 279E
         lda  Y1                   ; 27A0
         sta  Y                    ; 27A2
         jsr  FD_                  ; 27A4
         jmp  MFEX                 ; 27A7
L27AA
         cmp  #$30                 ; 27AA
         bcs  L27B1                ; 27AC
         jmp  L27D3                ; 27AE
L27B1
         cmp  #$3A                 ; 27B1
         bcs  L27D3                ; 27B3
         sta  TELE_CODE            ; 27B5
         lda  #$39                 ; 27B8
         jsr  PUT_                 ; 27BA
         lda  X1                   ; 27BD
         sta  X                    ; 27BF
         lda  Y1                   ; 27C1
         sta  Y                    ; 27C3
         lda  #$03                 ; 27C5
         jsr  SOUND_               ; 27C7
         lda  #$00                 ; 27CA
         sta  RUCH                 ; 27CC
         lda  #$64                 ; 27CE
         jmp  PUT_                 ; 27D0
L27D3
         cmp  #$3D                 ; 27D3
         bne  TDOR                 ; 27D5
         sed                       ; 27D7
         clc                       ; 27D8
         lda  KEYS                 ; 27D9
         adc  #$01                 ; 27DB
         cld                       ; 27DD
         bcs  TDOR                 ; 27DE
         sta  KEYS                 ; 27E0
         ldx  #$00                 ; 27E2
         lda  #$75                 ; 27E4
         jsr  ASCO                 ; 27E6
         lda  #$09                 ; 27E9
         jsr  SOUND_               ; 27EB

* take the object (GET_) and step in the direction LM, then MFEX (Robbo FGET) ---
FGET
         jsr  GET_                 ; 27EE
L27F1
         lda  X1                   ; 27F1
         sta  X                    ; 27F3
         lda  Y1                   ; 27F5
         sta  Y                    ; 27F7
         jsr  FD_                  ; 27F9
         jmp  MFEX                 ; 27FC

* door: opens with a key, KEYS (Robbo: "drzwi?") -----------
TDOR
         ldx  KEYS                 ; 27FF
         beq  TSKA                 ; 2801
         cmp  #$7C                 ; 2803
         beq  L280B                ; 2805
         cmp  #$12                 ; 2807
         bne  TSKA                 ; 2809
L280B
         sed                       ; 280B
         sec                       ; 280C
         lda  KEYS                 ; 280D
         sbc  #$01                 ; 280F
         sta  KEYS                 ; 2811
         cld                       ; 2813
         ldx  #$01                 ; 2814
         lda  #$00                 ; 2816
         jsr  ASCO                 ; 2818
         lda  #$06                 ; 281B
         jsr  SOUND_               ; 281D
         lda  #$7A                 ; 2820
         jmp  PUT_                 ; 2822

* screw / treasure (Robbo: "skarb?") -----------------------
TSKA
         cmp  #$24                 ; 2825
         bne  TWYJ                 ; 2827
         lda  CONSOL               ; 2829
         bne  L2836                ; 282C
         lda  #$0D                 ; 282E
         jsr  SOUND_               ; 2830
         jmp  NXCV                 ; 2833
L2836
         lda  ZEBR                 ; 2836
         bne  L2840                ; 2838
         ldx  #$02                 ; 283A
         lda  #$50                 ; 283C
         bne  L284D                ; 283E
L2840
         sed                       ; 2840
         sec                       ; 2841
         lda  ZEBR                 ; 2842
         sbc  #$01                 ; 2844
         sta  ZEBR                 ; 2846
         cld                       ; 2848
         ldx  #$01                 ; 2849
         lda  #$00                 ; 284B
L284D
         jsr  ASCO                 ; 284D
         lda  #$04                 ; 2850
         jsr  SOUND_               ; 2852
         jmp  FGET                 ; 2855

* exit (Robbo: "wyjscie?") ---------------------------------
TWYJ
         cmp  #$15                 ; 2858
         beq  L2860                ; 285A
         cmp  #$16                 ; 285C
         bne  L287E                ; 285E
L2860
         lda  X1                   ; 2860
         sta  X                    ; 2862
         lda  Y1                   ; 2864
         sta  Y                    ; 2866
         lda  #$20                 ; 2868
         jsr  PUT_                 ; 286A
         ldx  #$10                 ; 286D
         lda  #$00                 ; 286F
         jsr  ASCO                 ; 2871
         lda  #$0C                 ; 2874
         jsr  SOUND_               ; 2876
         lda  #$80                 ; 2879
         sta  FAC                  ; 287B
         rts                       ; 287D
L287E
         cmp  #$21                 ; 287E
         bne  L289C                ; 2880
         sed                       ; 2882
         clc                       ; 2883
         lda  #$09                 ; 2884
         adc  NABO                 ; 2886
         cld                       ; 2888
         bcs  L289C                ; 2889
         sta  NABO                 ; 288B
         ldx  #$00                 ; 288D
         lda  #$50                 ; 288F
         jsr  ASCO                 ; 2891
         lda  #$07                 ; 2894
         jsr  SOUND_               ; 2896
         jmp  FGET                 ; 2899
L289C
         cmp  #$2B                 ; 289C
         bne  TBEZ                 ; 289E
         sed                       ; 28A0
         clc                       ; 28A1
         lda  #$01                 ; 28A2
         adc  LIVS                 ; 28A4
         cld                       ; 28A6
         bcs  TBEZ                 ; 28A7
         sta  LIVS                 ; 28A9
         lda  CNUM                 ; 28AB
         sta  LSTE                 ; 28AD
         ldx  #$02                 ; 28AF
         lda  #$00                 ; 28B1
         jsr  ASCO                 ; 28B3
         lda  #$05                 ; 28B6
         jsr  SOUND_               ; 28B8
         jmp  FGET                 ; 28BB
         dta $09,$0A,$07,$08                          ; 28BE

* test: sliding box ----------------------------------------
TBEZ
         cmp  #$06                 ; 28C2
         bne  L28E1                ; 28C4
         jsr  FD_                  ; 28C6
         bcs  L28E1                ; 28C9
         ldx  #$FF                 ; 28CB
         lda  LM                   ; 28CD
L28CF
         inx                       ; 28CF
         lsr                       ; 28D0
         bcs  L28CF                ; 28D1
         lda  $28BE,x              ; 28D3
         jsr  PUT_                 ; 28D6
         lda  #$08                 ; 28D9
         jsr  SOUND_               ; 28DB
         jmp  L27F1                ; 28DE
L28E1
         lda  FX                   ; 28E1
         sta  X                    ; 28E3
         lda  FY                   ; 28E5
         sta  Y                    ; 28E7
         jmp  MFX1                 ; 28E9
