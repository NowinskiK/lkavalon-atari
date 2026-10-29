; ENGINE2.ASM - game engine: object behaviour (table $31EF), VBI $2F54
; $243D-$35A3

         org $243D

sub_243D
         ldx  $11                  ; 243D
         bmi  L2444                ; 243F
         jmp  L202C                ; 2441
L2444
         jsr  sub_30B2             ; 2444
         jsr  sub_24E0             ; 2447
         jsr  sub_2503             ; 244A
         lda  #$70                 ; 244D
         sta  $246E                ; 244F
         lda  #$24                 ; 2452
         sta  $246F                ; 2454
         lda  #$1E                 ; 2457
         sta  $82                  ; 2459
         lda  #$B6                 ; 245B
         sta  $83                  ; 245D
         lda  #$00                 ; 245F
         sta  $249B                ; 2461
         lda  #$BE                 ; 2464
         sta  $249C                ; 2466
         lda  #$20                 ; 2469
         sta  $80                  ; 246B
L246D
         jmp  L246D                ; 246D
irq_2470
         clc                       ; 2470
         lda  $82                  ; 2471
         adc  #$BF                 ; 2473
         ldx  $83                  ; 2475
         bcc  L247A                ; 2477
         inx                       ; 2479
L247A
         cmp  $1E13                ; 247A
         txa                       ; 247D
         sbc  $1E14                ; 247E
         bcc  L2498                ; 2481
         lda  #$98                 ; 2483
         sta  $246E                ; 2485
         lda  #$24                 ; 2488
         sta  $246F                ; 248A
         jsr  sub_23A6             ; 248D
         lda  #$00                 ; 2490
         sta  $86                  ; 2492
         lda  #$00                 ; 2494
         sta  $87                  ; 2496
L2498
         ldx  #$0F                 ; 2498
L249A
         lda  $BE00,x              ; 249A
         and  #$7F                 ; 249D
         tay                       ; 249F
         lda  $3155,y              ; 24A0
         ldy  #$00                 ; 24A3
         sta  ($82),y              ; 24A5
         ora  #$01                 ; 24A7
         iny                       ; 24A9
         sta  ($82),y              ; 24AA
         ora  #$20                 ; 24AC
         ldy  #$21                 ; 24AE
         sta  ($82),y              ; 24B0
         and  #$FE                 ; 24B2
         dey                       ; 24B4
         sta  ($82),y              ; 24B5
         dec  $82                  ; 24B7
         dec  $82                  ; 24B9
         dex                       ; 24BB
         bpl  L249A                ; 24BC
         inc  $82                  ; 24BE
         inc  $82                  ; 24C0
         clc                       ; 24C2
         lda  $82                  ; 24C3
         adc  #$5E                 ; 24C5
         sta  $82                  ; 24C7
         bcc  L24CD                ; 24C9
         inc  $83                  ; 24CB
L24CD
         clc                       ; 24CD
         lda  $249B                ; 24CE
         adc  #$10                 ; 24D1
         sta  $249B                ; 24D3
         bcc  L24DB                ; 24D6
         inc  $249C                ; 24D8
L24DB
         dec  $80                  ; 24DB
         bne  L246D                ; 24DD
         rts                       ; 24DF
sub_24E0
         lda  $3143                ; 24E0
         sta  $3142                ; 24E3
         lda  $92                  ; 24E6
         pha                       ; 24E8
         lda  $93                  ; 24E9
         pha                       ; 24EB
         lda  $96                  ; 24EC
         sta  $92                  ; 24EE
         sta  $94                  ; 24F0
         lda  $97                  ; 24F2
         sta  $93                  ; 24F4
         sta  $95                  ; 24F6
         jsr  sub_263D             ; 24F8
         pla                       ; 24FB
         sta  $93                  ; 24FC
         pla                       ; 24FE
         sta  $92                  ; 24FF
         rts                       ; 2501
         dta $00                                      ; 2502
sub_2503
         lda  #$00                 ; 2503
         sta  $80                  ; 2505
         lda  $210A                ; 2507
         clc                       ; 250A
         and  #$02                 ; 250B
         adc  #$48                 ; 250D
         sta  $81                  ; 250F
         ldy  #$FF                 ; 2511
L2513
         lda  ($80),y              ; 2513
         sta  $3C00,y              ; 2515
         inc  $81                  ; 2518
         lda  ($80),y              ; 251A
         sta  $3D00,y              ; 251C
         dec  $81                  ; 251F
         dey                       ; 2521
         cpy  #$DF                 ; 2522
         bne  L2513                ; 2524
         ldx  #$AF                 ; 2526
L2528
         lda  ($80),y              ; 2528
         sta  $3C00,x              ; 252A
         inc  $81                  ; 252D
         lda  ($80),y              ; 252F
         sta  $3D00,x              ; 2531
         dec  $81                  ; 2534
         dey                       ; 2536
         dex                       ; 2537
         cpx  #$4F                 ; 2538
         bne  L2528                ; 253A
         lda  $2502                ; 253C
         clc                       ; 253F
         and  #$01                 ; 2540
         asl                       ; 2542
         adc  #$48                 ; 2543
         sta  $81                  ; 2545
         ldx  $A8                  ; 2547
         beq  L255D                ; 2549
         ldx  $9C                  ; 254B
         beq  L255D                ; 254D
         inc  $2502                ; 254F
         ldx  #$50                 ; 2552
L2554
         lda  entry_1E00,x         ; 2554
         sta  CONSOL               ; 2557
         dex                       ; 255A
         bpl  L2554                ; 255B
L255D
         lda  $98                  ; 255D
         ldy  #$04                 ; 255F
L2561
         dey                       ; 2561
         lsr                       ; 2562
         bcs  L2561                ; 2563
         tya                       ; 2565
         asl                       ; 2566
         asl                       ; 2567
         asl                       ; 2568
         asl                       ; 2569
         adc  #$4F                 ; 256A
         tay                       ; 256C
         ldx  #$0F                 ; 256D
L256F
         lda  ($80),y              ; 256F
         sta  $3EF0,x              ; 2571
         inc  $81                  ; 2574
         lda  ($80),y              ; 2576
         dec  $81                  ; 2578
         sta  $3FF0,x              ; 257A
         dey                       ; 257D
         dex                       ; 257E
         bpl  L256F                ; 257F
         rts                       ; 2581
sub_2582
         lda  $96                  ; 2582
         sta  $92                  ; 2584
         lda  $97                  ; 2586
         sta  $93                  ; 2588
         jsr  sub_23DB             ; 258A
         cmp  #$2A                 ; 258D
         beq  L2593                ; 258F
         sec                       ; 2591
         rts                       ; 2592
L2593
         jsr  sub_236D             ; 2593
         jsr  sub_25B7             ; 2596
         bcc  L25B6                ; 2599
         jsr  sub_2363             ; 259B
         jsr  sub_25B7             ; 259E
         bcc  L25B6                ; 25A1
         jsr  sub_2377             ; 25A3
         jsr  sub_25B7             ; 25A6
         bcc  L25B6                ; 25A9
         jsr  sub_2381             ; 25AB
         jsr  sub_25B7             ; 25AE
         bcc  L25B6                ; 25B1
         jsr  sub_25D1             ; 25B3
L25B6
         rts                       ; 25B6
sub_25B7
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
         jsr  sub_3334             ; 25C7
         lda  #$61                 ; 25CA
         jsr  L23C6                ; 25CC
         clc                       ; 25CF
         rts                       ; 25D0
sub_25D1
         jsr  sub_23DB             ; 25D1
         ldx  $92                  ; 25D4
L25D6
         iny                       ; 25D6
         inx                       ; 25D7
         cpx  #$10                 ; 25D8
         bcs  L25FB                ; 25DA
         lda  ($80),y              ; 25DC
         cmp  #$20                 ; 25DE
         beq  L25D6                ; 25E0
         ldx  #$0C                 ; 25E2
         ldy  #$0B                 ; 25E4
         cmp  #$29                 ; 25E6
         bne  L25FB                ; 25E8
L25EA
         sty  $98                  ; 25EA
         txa                       ; 25EC
         jsr  L23C6                ; 25ED
         lda  #$0E                 ; 25F0
         jsr  sub_3334             ; 25F2
         lda  #$01                 ; 25F5
         sta  $9C                  ; 25F7
         clc                       ; 25F9
         rts                       ; 25FA
L25FB
         dec  $81                  ; 25FB
         ldy  #$00                 ; 25FD
         ldx  $92                  ; 25FF
L2601
         dey                       ; 2601
         dex                       ; 2602
         bmi  L2613                ; 2603
         lda  ($80),y              ; 2605
         cmp  #$20                 ; 2607
         beq  L2601                ; 2609
         ldx  #$0B                 ; 260B
         ldy  #$07                 ; 260D
         cmp  #$28                 ; 260F
         beq  L25EA                ; 2611
L2613
         sec                       ; 2613
         rts                       ; 2614
entry_2615
         lda  #$01                 ; 2615
         sta  $9C                  ; 2617
         lda  $99                  ; 2619
         beq  L261E                ; 261B
         rts                       ; 261D
L261E
         jsr  sub_23A6             ; 261E
         lda  $99                  ; 2621
         beq  L2626                ; 2623
         rts                       ; 2625
L2626
         lda  #$0B                 ; 2626
         jsr  sub_3334             ; 2628
         lda  #$6A                 ; 262B
         jmp  L23C6                ; 262D
entry_2630
         lda  $92                  ; 2630
         sta  $96                  ; 2632
         lda  $93                  ; 2634
         sta  $97                  ; 2636
         lda  #$01                 ; 2638
         sta  $9C                  ; 263A
         rts                       ; 263C
sub_263D
         jsr  sub_2582             ; 263D
         bcc  L2645                ; 2640
         jsr  sub_2648             ; 2642
L2645
         jmp  sub_2582             ; 2645
sub_2648
         jsr  sub_23DB             ; 2648
         cmp  #$2A                 ; 264B
         beq  L2650                ; 264D
         rts                       ; 264F
L2650
         dec  $26CF                ; 2650
         bpl  L2658                ; 2653
         inc  $26CF                ; 2655
L2658
         lda  $A3                  ; 2658
         beq  L2663                ; 265A
         lda  RANDOM               ; 265C
         and  #$0F                 ; 265F
         beq  L266B                ; 2661
L2663
         lda  $3145                ; 2663
         beq  L266B                ; 2666
         jmp  L26D0                ; 2668
L266B
         lda  #$00                 ; 266B
         sta  $A8                  ; 266D
         lda  $26CF                ; 266F
         beq  L2675                ; 2672
         rts                       ; 2674
L2675
         lda  $A3                  ; 2675
         beq  L267D                ; 2677
         lda  $98                  ; 2679
         bpl  L2685                ; 267B
L267D
         lda  $3142                ; 267D
         cmp  #$0F                 ; 2680
         bne  L2685                ; 2682
         rts                       ; 2684
L2685
         sta  $98                  ; 2685
         ldx  $A2                  ; 2687
         bne  L268F                ; 2689
         inc  $2502                ; 268B
         rts                       ; 268E
L268F
         pha                       ; 268F
         sed                       ; 2690
         sec                       ; 2691
         lda  $A2                  ; 2692
         sbc  #$01                 ; 2694
         sta  $A2                  ; 2696
         cld                       ; 2698
         pla                       ; 2699
         ldx  #$05                 ; 269A
         stx  $26CF                ; 269C
         ldx  #$FF                 ; 269F
L26A1
         inx                       ; 26A1
         lsr                       ; 26A2
         bcs  L26A1                ; 26A3
         cpx  #$04                 ; 26A5
         bcc  L26AA                ; 26A7
         rts                       ; 26A9
L26AA
         txa                       ; 26AA
         asl                       ; 26AB
         tax                       ; 26AC
         lda  $26C7,x              ; 26AD
         sta  $26BA                ; 26B0
         lda  $26C8,x              ; 26B3
         sta  $26BB                ; 26B6
sub_26B9
         jsr  sub_26B9             ; 26B9
         jsr  sub_23DB             ; 26BC
         jsr  L23C6                ; 26BF
         lda  #$01                 ; 26C2
         jmp  sub_3334             ; 26C4
         dta $6D,$2B,$93,$2B,$01,$2B,$47,$2B,$00      ; 26C7
L26D0
         ldx  $A3                  ; 26D0
         beq  L26EE                ; 26D2
         lda  $A8                  ; 26D4
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
         lda  $98                  ; 26EA
         bpl  L26F1                ; 26EC
L26EE
         lda  $3142                ; 26EE
L26F1
         cmp  #$0F                 ; 26F1
         beq  L26F7                ; 26F3
         sta  $98                  ; 26F5
L26F7
         ldx  #$01                 ; 26F7
         stx  $A8                  ; 26F9
         lsr                       ; 26FB
         bcc  L271D                ; 26FC
         lsr                       ; 26FE
         bcc  L2727                ; 26FF
         lsr                       ; 2701
         bcc  L2709                ; 2702
         lsr                       ; 2704
         bcc  L2713                ; 2705
         bcs  sub_2731             ; 2707
L2709
         jsr  sub_22EF             ; 2709
         bcc  L2735                ; 270C
         dec  $92                  ; 270E
         jmp  L276E                ; 2710
L2713
         jsr  sub_22D0             ; 2713
         bcc  L2735                ; 2716
         inc  $92                  ; 2718
         jmp  L276E                ; 271A
L271D
         jsr  sub_2329             ; 271D
         bcc  L2735                ; 2720
         dec  $93                  ; 2722
         jmp  L276E                ; 2724
L2727
         jsr  sub_2308             ; 2727
         bcc  L2735                ; 272A
         inc  $93                  ; 272C
         jmp  L276E                ; 272E
sub_2731
         lda  #$00                 ; 2731
         sta  $A8                  ; 2733
L2735
         jsr  sub_23DB             ; 2735
         jsr  L23C6                ; 2738
         lda  #$00                 ; 273B
         sta  $83                  ; 273D
         lda  $93                  ; 273F
         asl                       ; 2741
         asl                       ; 2742
         asl                       ; 2743
         asl                       ; 2744
         rol  $83                  ; 2745
         asl                       ; 2747
         rol  $83                  ; 2748
         asl                       ; 274A
         rol  $83                  ; 274B
         asl  $92                  ; 274D
         adc  $92                  ; 274F
         sta  $82                  ; 2751
         lsr  $92                  ; 2753
         lda  $83                  ; 2755
         adc  #$B6                 ; 2757
         sta  $83                  ; 2759
         lda  $82                  ; 275B
         sta  $2491                ; 275D
         lda  $83                  ; 2760
         sta  $2495                ; 2762
         lda  $92                  ; 2765
         sta  $96                  ; 2767
         lda  $93                  ; 2769
         sta  $97                  ; 276B
         rts                       ; 276D
L276E
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
         jsr  sub_2344             ; 2786
         ldx  #$00                 ; 2789
         bcs  L279A                ; 278B
         jsr  sub_23DB             ; 278D
         jsr  L23C6                ; 2790
         lda  #$08                 ; 2793
         jsr  sub_3334             ; 2795
         ldx  #$01                 ; 2798
L279A
         stx  $A8                  ; 279A
         lda  $94                  ; 279C
         sta  $92                  ; 279E
         lda  $95                  ; 27A0
         sta  $93                  ; 27A2
         jsr  sub_2344             ; 27A4
         jmp  L2735                ; 27A7
L27AA
         cmp  #$30                 ; 27AA
         bcs  L27B1                ; 27AC
         jmp  L27D3                ; 27AE
L27B1
         cmp  #$3A                 ; 27B1
         bcs  L27D3                ; 27B3
         sta  $28EC                ; 27B5
         lda  #$39                 ; 27B8
         jsr  L23C6                ; 27BA
         lda  $94                  ; 27BD
         sta  $92                  ; 27BF
         lda  $95                  ; 27C1
         sta  $93                  ; 27C3
         lda  #$03                 ; 27C5
         jsr  sub_3334             ; 27C7
         lda  #$00                 ; 27CA
         sta  $A8                  ; 27CC
         lda  #$64                 ; 27CE
         jmp  L23C6                ; 27D0
L27D3
         cmp  #$3D                 ; 27D3
         bne  L27FF                ; 27D5
         sed                       ; 27D7
         clc                       ; 27D8
         lda  $9E                  ; 27D9
         adc  #$01                 ; 27DB
         cld                       ; 27DD
         bcs  L27FF                ; 27DE
         sta  $9E                  ; 27E0
         ldx  #$00                 ; 27E2
         lda  #$75                 ; 27E4
         jsr  sub_238D             ; 27E6
         lda  #$09                 ; 27E9
         jsr  sub_3334             ; 27EB
L27EE
         jsr  sub_23AD             ; 27EE
L27F1
         lda  $94                  ; 27F1
         sta  $92                  ; 27F3
         lda  $95                  ; 27F5
         sta  $93                  ; 27F7
         jsr  sub_2344             ; 27F9
         jmp  L2735                ; 27FC
L27FF
         ldx  $9E                  ; 27FF
         beq  L2825                ; 2801
         cmp  #$7C                 ; 2803
         beq  L280B                ; 2805
         cmp  #$12                 ; 2807
         bne  L2825                ; 2809
L280B
         sed                       ; 280B
         sec                       ; 280C
         lda  $9E                  ; 280D
         sbc  #$01                 ; 280F
         sta  $9E                  ; 2811
         cld                       ; 2813
         ldx  #$01                 ; 2814
         lda  #$00                 ; 2816
         jsr  sub_238D             ; 2818
         lda  #$06                 ; 281B
         jsr  sub_3334             ; 281D
         lda  #$7A                 ; 2820
         jmp  L23C6                ; 2822
L2825
         cmp  #$24                 ; 2825
         bne  L2858                ; 2827
         lda  CONSOL               ; 2829
         bne  L2836                ; 282C
         lda  #$0D                 ; 282E
         jsr  sub_3334             ; 2830
         jmp  L2092                ; 2833
L2836
         lda  $A0                  ; 2836
         bne  L2840                ; 2838
         ldx  #$02                 ; 283A
         lda  #$50                 ; 283C
         bne  L284D                ; 283E
L2840
         sed                       ; 2840
         sec                       ; 2841
         lda  $A0                  ; 2842
         sbc  #$01                 ; 2844
         sta  $A0                  ; 2846
         cld                       ; 2848
         ldx  #$01                 ; 2849
         lda  #$00                 ; 284B
L284D
         jsr  sub_238D             ; 284D
         lda  #$04                 ; 2850
         jsr  sub_3334             ; 2852
         jmp  L27EE                ; 2855
L2858
         cmp  #$15                 ; 2858
         beq  L2860                ; 285A
         cmp  #$16                 ; 285C
         bne  L287E                ; 285E
L2860
         lda  $94                  ; 2860
         sta  $92                  ; 2862
         lda  $95                  ; 2864
         sta  $93                  ; 2866
         lda  #$20                 ; 2868
         jsr  L23C6                ; 286A
         ldx  #$10                 ; 286D
         lda  #$00                 ; 286F
         jsr  sub_238D             ; 2871
         lda  #$0C                 ; 2874
         jsr  sub_3334             ; 2876
         lda  #$80                 ; 2879
         sta  $9C                  ; 287B
         rts                       ; 287D
L287E
         cmp  #$21                 ; 287E
         bne  L289C                ; 2880
         sed                       ; 2882
         clc                       ; 2883
         lda  #$09                 ; 2884
         adc  $A2                  ; 2886
         cld                       ; 2888
         bcs  L289C                ; 2889
         sta  $A2                  ; 288B
         ldx  #$00                 ; 288D
         lda  #$50                 ; 288F
         jsr  sub_238D             ; 2891
         lda  #$07                 ; 2894
         jsr  sub_3334             ; 2896
         jmp  L27EE                ; 2899
L289C
         cmp  #$2B                 ; 289C
         bne  L28C2                ; 289E
         sed                       ; 28A0
         clc                       ; 28A1
         lda  #$01                 ; 28A2
         adc  $9F                  ; 28A4
         cld                       ; 28A6
         bcs  L28C2                ; 28A7
         sta  $9F                  ; 28A9
         lda  $9D                  ; 28AB
         sta  $A1                  ; 28AD
         ldx  #$02                 ; 28AF
         lda  #$00                 ; 28B1
         jsr  sub_238D             ; 28B3
         lda  #$05                 ; 28B6
         jsr  sub_3334             ; 28B8
         jmp  L27EE                ; 28BB
         dta $09,$0A,$07,$08                          ; 28BE
L28C2
         cmp  #$06                 ; 28C2
         bne  L28E1                ; 28C4
         jsr  sub_2344             ; 28C6
         bcs  L28E1                ; 28C9
         ldx  #$FF                 ; 28CB
         lda  $98                  ; 28CD
L28CF
         inx                       ; 28CF
         lsr                       ; 28D0
         bcs  L28CF                ; 28D1
         lda  $28BE,x              ; 28D3
         jsr  L23C6                ; 28D6
         lda  #$08                 ; 28D9
         jsr  sub_3334             ; 28DB
         jmp  L27F1                ; 28DE
L28E1
         lda  $96                  ; 28E1
         sta  $92                  ; 28E3
         lda  $97                  ; 28E5
         sta  $93                  ; 28E7
         jmp  sub_2731             ; 28E9
         dta $00                                      ; 28EC
entry_28ED
         lda  #$01                 ; 28ED
         sta  $9C                  ; 28EF
         lda  $28EC                ; 28F1
         sta  $9B                  ; 28F4
         jmp  L23C6                ; 28F6
         dta $00,$0F,$11,$20                          ; 28F9
entry_28FD
         jsr  sub_23DB             ; 28FD
         cmp  $9B                  ; 2900
         beq  L2905                ; 2902
         rts                       ; 2904
L2905
         lda  #$01                 ; 2905
         sta  $9C                  ; 2907
         sec                       ; 2909
         lda  $80                  ; 290A
         sbc  #$10                 ; 290C
         sta  $80                  ; 290E
         bcs  L2914                ; 2910
         dec  $81                  ; 2912
L2914
         ldx  #$03                 ; 2914
L2916
         ldy  $28F9,x              ; 2916
         lda  ($80),y              ; 2919
         cmp  #$20                 ; 291B
         beq  L2923                ; 291D
         dex                       ; 291F
         bpl  L2916                ; 2920
         rts                       ; 2922
L2923
         lda  #$69                 ; 2923
         jsr  L23C6                ; 2925
         jsr  sub_2344             ; 2928
         bcc  L2957                ; 292B
         lda  $98                  ; 292D
         pha                       ; 292F
         ldy  #$00                 ; 2930
L2932
         iny                       ; 2932
         lsr                       ; 2933
         bcs  L2932                ; 2934
         tya                       ; 2936
         asl                       ; 2937
         asl                       ; 2938
         tay                       ; 2939
         dey                       ; 293A
L293B
         tya                       ; 293B
         pha                       ; 293C
         lda  $296B,y              ; 293D
         sta  $98                  ; 2940
         jsr  sub_2344             ; 2942
         pla                       ; 2945
         tay                       ; 2946
         bcc  L2954                ; 2947
         dey                       ; 2949
         bpl  L293B                ; 294A
         pla                       ; 294C
         sta  $98                  ; 294D
         lda  $9B                  ; 294F
         jmp  L23C6                ; 2951
L2954
         pla                       ; 2954
         sta  $98                  ; 2955
L2957
         jsr  sub_2731             ; 2957
         lda  $94                  ; 295A
         sta  $92                  ; 295C
         lda  $95                  ; 295E
         sta  $93                  ; 2960
         lda  $9B                  ; 2962
         ldx  #$01                 ; 2964
         stx  $9B                  ; 2966
         jmp  L23C6                ; 2968
         dta $0D,$0B,$07,$0E,$0E,$07,$0B,$0D,$07,$0E,$0D,$0B,$0B,$0D,$0E,$07 ; 296B
entry_297B
         lda  RANDOM               ; 297B
         and  #$1F                 ; 297E
         tax                       ; 2980
         lda  $29D3,x              ; 2981
         beq  L2989                ; 2984
         jmp  L23C6                ; 2986
L2989
         lda  #$2B                 ; 2989
         jsr  L23C6                ; 298B
         lda  #$1E                 ; 298E
         sta  $93                  ; 2990
L2992
         lda  #$0F                 ; 2992
         sta  $92                  ; 2994
L2996
         jsr  sub_23DB             ; 2996
         and  #$7F                 ; 2999
         tax                       ; 299B
         lda  #$A0                 ; 299C
         cpx  #$28                 ; 299E
         beq  L29BC                ; 29A0
         cpx  #$29                 ; 29A2
         beq  L29BC                ; 29A4
         cpx  #$7C                 ; 29A6
         beq  L29BA                ; 29A8
         cpx  #$12                 ; 29AA
         beq  L29BA                ; 29AC
         cpx  #$26                 ; 29AE
         beq  L29BA                ; 29B0
         cpx  #$41                 ; 29B2
         bcc  L29BF                ; 29B4
         cpx  #$4F                 ; 29B6
         bcs  L29BF                ; 29B8
L29BA
         lda  #$E1                 ; 29BA
L29BC
         jsr  L23C6                ; 29BC
L29BF
         dec  $92                  ; 29BF
         bpl  L2996                ; 29C1
         dec  $93                  ; 29C3
         bpl  L2992                ; 29C5
         ldx  #$05                 ; 29C7
         lda  #$00                 ; 29C9
         jsr  sub_238D             ; 29CB
         lda  #$0D                 ; 29CE
         jmp  sub_3334             ; 29D0
         dta $00,$00,$3F,$3F,$21,$21,$21,$21,$3D,$3D,$3D,$24,$24,$24,$24,$24 ; 29D3
         dta $26,$26,$40,$2B,$2B,$2B,$2B,$2B,$63,$63,$15,$2C,$2E,$2D,$2F,$23 ; 29E3
entry_29F3
         jsr  sub_22EF             ; 29F3
         bcc  L2A19                ; 29F6
         jsr  sub_2A24             ; 29F8
         jmp  L2B01                ; 29FB
entry_29FE
         jsr  sub_22D0             ; 29FE
         bcc  L2A19                ; 2A01
         jsr  sub_2A24             ; 2A03
         jmp  L2B47                ; 2A06
entry_2A09
         jsr  sub_2329             ; 2A09
         bcc  L2A19                ; 2A0C
         jsr  sub_2A24             ; 2A0E
         jmp  L2B6D                ; 2A11
entry_2A14
         jsr  sub_2308             ; 2A14
         bcs  L2A1E                ; 2A17
L2A19
         lda  #$08                 ; 2A19
         jmp  sub_3334             ; 2A1B
L2A1E
         jsr  sub_2A24             ; 2A1E
         jmp  L2B93                ; 2A21
sub_2A24
         lda  #$06                 ; 2A24
         jmp  L23C6                ; 2A26
sub_2A29
         lda  RANDOM               ; 2A29
         cmp  #$12                 ; 2A2C
         bcc  L2A32                ; 2A2E
         pla                       ; 2A30
         pla                       ; 2A31
L2A32
         rts                       ; 2A32
entry_2A33
         lda  #$00                 ; 2A33
         jsr  sub_3334             ; 2A35
         jsr  sub_23DB             ; 2A38
         sec                       ; 2A3B
         lda  $80                  ; 2A3C
         sbc  #$11                 ; 2A3E
         sta  $80                  ; 2A40
         bcs  L2A46                ; 2A42
         dec  $81                  ; 2A44
L2A46
         ldx  #$08                 ; 2A46
L2A48
         clc                       ; 2A48
         lda  $92                  ; 2A49
         adc  $2A9C,x              ; 2A4B
         cmp  #$10                 ; 2A4E
         bcs  L2A88                ; 2A50
         lda  $93                  ; 2A52
         adc  $2AA5,x              ; 2A54
         cmp  #$1F                 ; 2A57
         bcs  L2A88                ; 2A59
         ldy  $2A93,x              ; 2A5B
         lda  ($80),y              ; 2A5E
         and  #$7F                 ; 2A60
         tay                       ; 2A62
         cpx  #$04                 ; 2A63
         beq  L2A6E                ; 2A65
         lda  $32B1,y              ; 2A67
         and  #$02                 ; 2A6A
         beq  L2A88                ; 2A6C
L2A6E
         tya                       ; 2A6E
         pha                       ; 2A6F
         lda  $2A93,x              ; 2A70
         tay                       ; 2A73
         pla                       ; 2A74
         cmp  #$40                 ; 2A75
         bne  L2A7D                ; 2A77
         lda  #$E0                 ; 2A79
         bne  L2A86                ; 2A7B
L2A7D
         clc                       ; 2A7D
         lda  RANDOM               ; 2A7E
         and  #$01                 ; 2A81
         adc  $2AAE,x              ; 2A83
L2A86
         sta  ($80),y              ; 2A86
L2A88
         dex                       ; 2A88
         bpl  L2A48                ; 2A89
         jmp  sub_23DB             ; 2A8B
L2A8E
         lda  #$60                 ; 2A8E
         jmp  L23C6                ; 2A90
         dta $00,$01,$02,$10,$11,$12,$20,$21,$22,$FF,$00,$01,$FF,$00,$01,$FF ; 2A93
         dta $00,$01,$FF,$FF,$FF,$00,$00,$00,$01,$01,$01,$61,$62,$61,$62,$63 ; 2AA3
         dta $62,$61,$62,$61                          ; 2AB3
sub_2AB7
         tax                       ; 2AB7
         lda  #$20                 ; 2AB8
         cpx  #$5D                 ; 2ABA
         beq  L2AC0                ; 2ABC
         cpx  #$5B                 ; 2ABE
L2AC0
         beq  L2AC4                ; 2AC0
         lda  #$66                 ; 2AC2
L2AC4
         jmp  L23C6                ; 2AC4
entry_2AC7
         lda  #$01                 ; 2AC7
         sta  $9C                  ; 2AC9
         sta  $A8                  ; 2ACB
         jsr  sub_22EF             ; 2ACD
         bcs  L2AD3                ; 2AD0
         rts                       ; 2AD2
L2AD3
         lda  #$76                 ; 2AD3
         jsr  L23C6                ; 2AD5
         lda  #$00                 ; 2AD8
         sta  $9C                  ; 2ADA
         lda  #$0A                 ; 2ADC
         jmp  sub_3334             ; 2ADE
entry_2AE1
         lda  #$01                 ; 2AE1
         sta  $9C                  ; 2AE3
         sta  $A8                  ; 2AE5
         jsr  sub_22D0             ; 2AE7
         bcs  L2AD3                ; 2AEA
         rts                       ; 2AEC
entry_2AED
         jsr  sub_2A29             ; 2AED
         lda  #$01                 ; 2AF0
         jsr  sub_3334             ; 2AF2
         jmp  L2B01                ; 2AF5
entry_2AF8
         jsr  sub_22EF             ; 2AF8
         bcs  L2AFE                ; 2AFB
         rts                       ; 2AFD
L2AFE
         jsr  sub_2AB7             ; 2AFE
L2B01
         jsr  sub_2363             ; 2B01
         dec  $92                  ; 2B04
         cpx  #$20                 ; 2B06
         beq  L2B0E                ; 2B08
         cpx  #$5D                 ; 2B0A
         bne  L2B13                ; 2B0C
L2B0E
         lda  #$4F                 ; 2B0E
         jmp  L23C6                ; 2B10
L2B13
         lsr                       ; 2B13
         bcs  L2B1B                ; 2B14
         lda  #$02                 ; 2B16
         jmp  sub_3334             ; 2B18
L2B1B
         cpx  #$40                 ; 2B1B
         bne  L2B22                ; 2B1D
         jmp  L2A8E                ; 2B1F
L2B22
         cpx  #$3F                 ; 2B22
         bne  L2B29                ; 2B24
         jmp  L2D29                ; 2B26
L2B29
         lda  #$0A                 ; 2B29
         jsr  sub_3334             ; 2B2B
         lda  #$61                 ; 2B2E
         jmp  L23C6                ; 2B30
entry_2B33
         jsr  sub_2A29             ; 2B33
         lda  #$01                 ; 2B36
         jsr  sub_3334             ; 2B38
         jmp  L2B47                ; 2B3B
entry_2B3E
         jsr  sub_22D0             ; 2B3E
         bcs  L2B44                ; 2B41
         rts                       ; 2B43
L2B44
         jsr  sub_2AB7             ; 2B44
L2B47
         jsr  sub_236D             ; 2B47
         inc  $92                  ; 2B4A
         cpx  #$20                 ; 2B4C
         beq  L2B54                ; 2B4E
         cpx  #$5D                 ; 2B50
         bne  L2B13                ; 2B52
L2B54
         lda  #$D0                 ; 2B54
         jmp  L23C6                ; 2B56
entry_2B59
         jsr  sub_2A29             ; 2B59
         lda  #$01                 ; 2B5C
         jsr  sub_3334             ; 2B5E
         jmp  L2B6D                ; 2B61
entry_2B64
         jsr  sub_2329             ; 2B64
         bcs  L2B6A                ; 2B67
         rts                       ; 2B69
L2B6A
         jsr  sub_2AB7             ; 2B6A
L2B6D
         jsr  sub_2377             ; 2B6D
         dec  $93                  ; 2B70
         cpx  #$20                 ; 2B72
         beq  L2B7A                ; 2B74
         cpx  #$5B                 ; 2B76
         bne  L2B13                ; 2B78
L2B7A
         lda  #$51                 ; 2B7A
         jmp  L23C6                ; 2B7C
entry_2B7F
         jsr  sub_2A29             ; 2B7F
         lda  #$01                 ; 2B82
         jsr  sub_3334             ; 2B84
         jmp  L2B93                ; 2B87
entry_2B8A
         jsr  sub_2308             ; 2B8A
         bcs  L2B90                ; 2B8D
         rts                       ; 2B8F
L2B90
         jsr  sub_2AB7             ; 2B90
L2B93
         jsr  sub_2381             ; 2B93
         inc  $93                  ; 2B96
         cpx  #$20                 ; 2B98
         beq  L2BA3                ; 2B9A
         cpx  #$5B                 ; 2B9C
         beq  L2BA3                ; 2B9E
         jmp  L2B13                ; 2BA0
L2BA3
         lda  #$D2                 ; 2BA3
         jmp  L23C6                ; 2BA5
entry_2BA8
         jsr  sub_2A29             ; 2BA8
         jmp  L2BBF                ; 2BAB
entry_2BAE
         jsr  sub_22EF             ; 2BAE
         bcs  L2BBA                ; 2BB1
         inc  $92                  ; 2BB3
         lda  #$5D                 ; 2BB5
         jmp  L23C6                ; 2BB7
L2BBA
         lda  #$50                 ; 2BBA
         jsr  L23C6                ; 2BBC
L2BBF
         jsr  sub_2363             ; 2BBF
         dec  $92                  ; 2BC2
         cpx  #$20                 ; 2BC4
         bne  L2BCD                ; 2BC6
         lda  #$53                 ; 2BC8
         jmp  L23C6                ; 2BCA
L2BCD
         lsr                       ; 2BCD
         bcs  L2BD5                ; 2BCE
         lda  #$02                 ; 2BD0
         jmp  sub_3334             ; 2BD2
L2BD5
         cpx  #$40                 ; 2BD5
         bne  L2BDC                ; 2BD7
         jmp  L2A8E                ; 2BD9
L2BDC
         cpx  #$3F                 ; 2BDC
         bne  L2BE3                ; 2BDE
         jmp  L2D29                ; 2BE0
L2BE3
         lda  #$0A                 ; 2BE3
         jsr  sub_3334             ; 2BE5
         lda  #$61                 ; 2BE8
         jmp  L23C6                ; 2BEA
entry_2BED
         jsr  sub_2A29             ; 2BED
         jmp  L2C04                ; 2BF0
entry_2BF3
         jsr  sub_22D0             ; 2BF3
         bcs  L2BFF                ; 2BF6
         dec  $92                  ; 2BF8
         lda  #$5D                 ; 2BFA
         jmp  L23C6                ; 2BFC
L2BFF
         lda  #$4F                 ; 2BFF
         jsr  L23C6                ; 2C01
L2C04
         jsr  sub_236D             ; 2C04
         inc  $92                  ; 2C07
         cpx  #$20                 ; 2C09
         bne  L2BCD                ; 2C0B
         lda  #$D4                 ; 2C0D
         jmp  L23C6                ; 2C0F
entry_2C12
         jsr  sub_2A29             ; 2C12
         jmp  L2C29                ; 2C15
entry_2C18
         jsr  sub_2329             ; 2C18
         bcs  L2C24                ; 2C1B
         inc  $93                  ; 2C1D
         lda  #$5B                 ; 2C1F
         jmp  L23C6                ; 2C21
L2C24
         lda  #$52                 ; 2C24
         jsr  L23C6                ; 2C26
L2C29
         jsr  sub_2377             ; 2C29
         dec  $93                  ; 2C2C
         cpx  #$20                 ; 2C2E
         bne  L2BCD                ; 2C30
         lda  #$55                 ; 2C32
         jmp  L23C6                ; 2C34
entry_2C37
         jsr  sub_2A29             ; 2C37
         jmp  L2C4E                ; 2C3A
entry_2C3D
         jsr  sub_2308             ; 2C3D
         bcs  L2C49                ; 2C40
         dec  $93                  ; 2C42
         lda  #$5B                 ; 2C44
         jmp  L23C6                ; 2C46
L2C49
         lda  #$51                 ; 2C49
         jsr  L23C6                ; 2C4B
L2C4E
         jsr  sub_2381             ; 2C4E
         inc  $93                  ; 2C51
         cpx  #$20                 ; 2C53
         beq  L2C5A                ; 2C55
         jmp  L2BCD                ; 2C57
L2C5A
         lda  #$D6                 ; 2C5A
         jmp  L23C6                ; 2C5C
entry_2C5F
         jsr  sub_2A29             ; 2C5F
         jmp  L2C79                ; 2C62
entry_2C65
         jsr  sub_22EF             ; 2C65
         bcs  L2C74                ; 2C68
         jsr  sub_2D1B             ; 2C6A
         inc  $92                  ; 2C6D
         lda  #$62                 ; 2C6F
         jmp  L23C6                ; 2C71
L2C74
         lda  #$62                 ; 2C74
         jsr  L23C6                ; 2C76
L2C79
         jsr  sub_2363             ; 2C79
         dec  $92                  ; 2C7C
         cpx  #$20                 ; 2C7E
         beq  L2C86                ; 2C80
         lsr                       ; 2C82
         bcs  L2C86                ; 2C83
         rts                       ; 2C85
L2C86
         jsr  sub_2D1B             ; 2C86
         lda  #$57                 ; 2C89
         jmp  L23C6                ; 2C8B
entry_2C8E
         jsr  sub_2A29             ; 2C8E
         jmp  L2CA8                ; 2C91
entry_2C94
         jsr  sub_22D0             ; 2C94
         bcs  L2CA3                ; 2C97
         jsr  sub_2D1B             ; 2C99
         dec  $92                  ; 2C9C
         lda  #$62                 ; 2C9E
         jmp  L23C6                ; 2CA0
L2CA3
         lda  #$62                 ; 2CA3
         jsr  L23C6                ; 2CA5
L2CA8
         jsr  sub_236D             ; 2CA8
         inc  $92                  ; 2CAB
         cpx  #$20                 ; 2CAD
         beq  L2CB5                ; 2CAF
         lsr                       ; 2CB1
         bcs  L2CB5                ; 2CB2
         rts                       ; 2CB4
L2CB5
         jsr  sub_2D1B             ; 2CB5
         lda  #$D8                 ; 2CB8
         jmp  L23C6                ; 2CBA
entry_2CBD
         jsr  sub_2A29             ; 2CBD
         jmp  L2CD7                ; 2CC0
entry_2CC3
         jsr  sub_2329             ; 2CC3
         bcs  L2CD2                ; 2CC6
         jsr  sub_2D1B             ; 2CC8
         inc  $93                  ; 2CCB
         lda  #$62                 ; 2CCD
         jmp  L23C6                ; 2CCF
L2CD2
         lda  #$62                 ; 2CD2
         jsr  L23C6                ; 2CD4
L2CD7
         jsr  sub_2377             ; 2CD7
         dec  $93                  ; 2CDA
         cpx  #$20                 ; 2CDC
         beq  L2CE4                ; 2CDE
         lsr                       ; 2CE0
         bcs  L2CE4                ; 2CE1
         rts                       ; 2CE3
L2CE4
         jsr  sub_2D1B             ; 2CE4
         lda  #$59                 ; 2CE7
         jmp  L23C6                ; 2CE9
entry_2CEC
         jsr  sub_2A29             ; 2CEC
         jmp  L2D06                ; 2CEF
entry_2CF2
         jsr  sub_2308             ; 2CF2
         bcs  L2D01                ; 2CF5
         jsr  sub_2D1B             ; 2CF7
         dec  $93                  ; 2CFA
         lda  #$62                 ; 2CFC
         jmp  L23C6                ; 2CFE
L2D01
         lda  #$62                 ; 2D01
         jsr  L23C6                ; 2D03
L2D06
         jsr  sub_2381             ; 2D06
         inc  $93                  ; 2D09
         cpx  #$20                 ; 2D0B
         beq  L2D13                ; 2D0D
         lsr                       ; 2D0F
         bcs  L2D13                ; 2D10
         rts                       ; 2D12
L2D13
         jsr  sub_2D1B             ; 2D13
         lda  #$DA                 ; 2D16
         jmp  L23C6                ; 2D18
sub_2D1B
         cpx  #$3F                 ; 2D1B
         beq  L2D29                ; 2D1D
         cpx  #$40                 ; 2D1F
         bne  L2D28                ; 2D21
         pla                       ; 2D23
         pla                       ; 2D24
         jmp  L2A8E                ; 2D25
L2D28
         rts                       ; 2D28
L2D29
         lda  #$0A                 ; 2D29
         jsr  sub_3334             ; 2D2B
         lda  #$6E                 ; 2D2E
         jmp  L23C6                ; 2D30
entry_2D33
         lda  $210A                ; 2D33
         and  #$03                 ; 2D36
         bne  L2D5F                ; 2D38
         lda  RANDOM               ; 2D3A
         and  #$03                 ; 2D3D
         bne  L2D5F                ; 2D3F
         jsr  sub_23AD             ; 2D41
         lsr  RANDOM               ; 2D44
         bcs  L2D54                ; 2D47
         adc  #$01                 ; 2D49
         cmp  #$30                 ; 2D4B
         bcc  L2D51                ; 2D4D
         lda  #$2C                 ; 2D4F
L2D51
         jmp  L23C6                ; 2D51
L2D54
         sbc  #$01                 ; 2D54
         cmp  #$2C                 ; 2D56
         bcs  L2D5C                ; 2D58
         lda  #$2F                 ; 2D5A
L2D5C
         jmp  L23C6                ; 2D5C
L2D5F
         lda  RANDOM               ; 2D5F
         and  #$07                 ; 2D62
         beq  L2D67                ; 2D64
         rts                       ; 2D66
L2D67
         jsr  sub_23DB             ; 2D67
         sec                       ; 2D6A
         sbc  #$2C                 ; 2D6B
         asl                       ; 2D6D
         tax                       ; 2D6E
         lda  $2D79,x              ; 2D6F
         pha                       ; 2D72
         lda  $2D78,x              ; 2D73
         pha                       ; 2D76
         rts                       ; 2D77
         dta $46,$2B,$92,$2B,$00,$2B,$6C,$2B          ; 2D78
entry_2D80
         lda  $210A                ; 2D80
         lsr                       ; 2D83
         bcc  L2DA3                ; 2D84
         jsr  sub_22EF             ; 2D86
         bcc  L2DA3                ; 2D89
         lda  #$0D                 ; 2D8B
         jsr  L23C6                ; 2D8D
         jmp  L2DA3                ; 2D90
entry_2D93
         lda  $210A                ; 2D93
         lsr                       ; 2D96
         bcc  L2DA3                ; 2D97
         jsr  sub_22D0             ; 2D99
         bcc  L2DA3                ; 2D9C
         lda  #$0E                 ; 2D9E
         jsr  L23C6                ; 2DA0
L2DA3
         jmp  entry_2B59           ; 2DA3
entry_2DA6
         jsr  sub_23DB             ; 2DA6
         ldy  #$01                 ; 2DA9
         lda  ($80),y              ; 2DAB
         cmp  #$0F                 ; 2DAD
         beq  L2DB3                ; 2DAF
         lda  #$20                 ; 2DB1
L2DB3
         pha                       ; 2DB3
         jsr  sub_23DB             ; 2DB4
L2DB7
         iny                       ; 2DB7
         inc  $92                  ; 2DB8
         lda  ($80),y              ; 2DBA
         cmp  #$0F                 ; 2DBC
         bne  L2DD0                ; 2DBE
         dec  $92                  ; 2DC0
         dey                       ; 2DC2
         beq  L2DC9                ; 2DC3
         lda  #$0F                 ; 2DC5
         sta  ($80),y              ; 2DC7
L2DC9
         iny                       ; 2DC9
         inc  $92                  ; 2DCA
         lda  #$20                 ; 2DCC
         sta  ($80),y              ; 2DCE
L2DD0
         lda  ($80),y              ; 2DD0
         cmp  #$05                 ; 2DD2
         bne  L2DB7                ; 2DD4
         pla                       ; 2DD6
         dey                       ; 2DD7
         dec  $92                  ; 2DD8
         cmp  #$0F                 ; 2DDA
         beq  L2DDF                ; 2DDC
         rts                       ; 2DDE
L2DDF
         sta  ($80),y              ; 2DDF
         rts                       ; 2DE1
entry_2DE2
         jsr  sub_22EF             ; 2DE2
         bcs  L2DEC                ; 2DE5
         lda  #$44                 ; 2DE7
         jmp  L23C6                ; 2DE9
L2DEC
         jsr  sub_2329             ; 2DEC
         bcs  L2DF2                ; 2DEF
         rts                       ; 2DF1
L2DF2
         lda  #$43                 ; 2DF2
         jmp  L23C6                ; 2DF4
entry_2DF7
         jsr  sub_22D0             ; 2DF7
         bcs  L2E01                ; 2DFA
         lda  #$C3                 ; 2DFC
         jmp  L23C6                ; 2DFE
L2E01
         jsr  sub_2308             ; 2E01
         bcs  L2E07                ; 2E04
         rts                       ; 2E06
L2E07
         lda  #$44                 ; 2E07
         jmp  L23C6                ; 2E09
entry_2E0C
         jsr  sub_2329             ; 2E0C
         bcs  L2E16                ; 2E0F
         lda  #$41                 ; 2E11
         jmp  L23C6                ; 2E13
L2E16
         jsr  sub_22D0             ; 2E16
         bcs  L2E1C                ; 2E19
         rts                       ; 2E1B
L2E1C
         lda  #$42                 ; 2E1C
         jmp  L23C6                ; 2E1E
entry_2E21
         jsr  sub_2308             ; 2E21
         bcs  L2E2B                ; 2E24
         lda  #$C2                 ; 2E26
         jmp  L23C6                ; 2E28
L2E2B
         jsr  sub_22EF             ; 2E2B
         bcs  L2E31                ; 2E2E
         rts                       ; 2E30
L2E31
         lda  #$41                 ; 2E31
         jmp  L23C6                ; 2E33
entry_2E36
         jsr  sub_22EF             ; 2E36
         bcs  L2E40                ; 2E39
         lda  #$47                 ; 2E3B
         jmp  L23C6                ; 2E3D
L2E40
         jsr  sub_2308             ; 2E40
         bcs  L2E46                ; 2E43
         rts                       ; 2E45
L2E46
         lda  #$48                 ; 2E46
         jmp  L23C6                ; 2E48
entry_2E4B
         jsr  sub_22D0             ; 2E4B
         bcs  L2E55                ; 2E4E
         lda  #$C8                 ; 2E50
         jmp  L23C6                ; 2E52
L2E55
         jsr  sub_2329             ; 2E55
         bcs  L2E5B                ; 2E58
         rts                       ; 2E5A
L2E5B
         lda  #$C7                 ; 2E5B
         jmp  L23C6                ; 2E5D
entry_2E60
         jsr  sub_2329             ; 2E60
         bcs  L2E6A                ; 2E63
         lda  #$46                 ; 2E65
         jmp  L23C6                ; 2E67
L2E6A
         jsr  sub_22EF             ; 2E6A
         bcs  L2E70                ; 2E6D
         rts                       ; 2E6F
L2E70
         lda  #$45                 ; 2E70
         jmp  L23C6                ; 2E72
entry_2E75
         jsr  sub_2308             ; 2E75
         bcs  L2E7F                ; 2E78
         lda  #$C5                 ; 2E7A
         jmp  L23C6                ; 2E7C
L2E7F
         jsr  sub_22D0             ; 2E7F
         bcs  L2E85                ; 2E82
         rts                       ; 2E84
L2E85
         lda  #$46                 ; 2E85
         jmp  L23C6                ; 2E87
entry_2E8A
         jsr  sub_22EF             ; 2E8A
         bcs  L2E90                ; 2E8D
         rts                       ; 2E8F
L2E90
         lda  #$CA                 ; 2E90
         jmp  L23C6                ; 2E92
entry_2E95
         jsr  sub_22D0             ; 2E95
         bcs  L2E9B                ; 2E98
         rts                       ; 2E9A
L2E9B
         lda  #$C9                 ; 2E9B
         jmp  L23C6                ; 2E9D
entry_2EA0
         jsr  sub_2329             ; 2EA0
         bcs  L2EA6                ; 2EA3
         rts                       ; 2EA5
L2EA6
         lda  #$CC                 ; 2EA6
         jmp  L23C6                ; 2EA8
entry_2EAB
         jsr  sub_2308             ; 2EAB
         bcs  L2EB1                ; 2EAE
         rts                       ; 2EB0
L2EB1
         lda  #$CB                 ; 2EB1
         jmp  L23C6                ; 2EB3
entry_2EB6
         jsr  sub_22EF             ; 2EB6
         bcc  L2ECA                ; 2EB9
         lda  #$4E                 ; 2EBB
         jmp  L23C6                ; 2EBD
entry_2EC0
         jsr  sub_22D0             ; 2EC0
         bcc  L2ECA                ; 2EC3
         lda  #$4D                 ; 2EC5
         jsr  L23C6                ; 2EC7
L2ECA
         lda  RANDOM               ; 2ECA
         and  #$07                 ; 2ECD
         beq  L2ED2                ; 2ECF
         rts                       ; 2ED1
L2ED2
         jmp  L2B93                ; 2ED2
entry_2ED5
         lsr  RANDOM               ; 2ED5
         bcs  L2EF4                ; 2ED8
         lda  $93                  ; 2EDA
         cmp  $97                  ; 2EDC
         beq  L2EEE                ; 2EDE
         bcc  L2EE8                ; 2EE0
         jsr  sub_2329             ; 2EE2
         bcs  L2EEE                ; 2EE5
         rts                       ; 2EE7
L2EE8
         jsr  sub_2308             ; 2EE8
         bcs  L2EEE                ; 2EEB
         rts                       ; 2EED
L2EEE
         lda  $92                  ; 2EEE
         cmp  $96                  ; 2EF0
         bne  L2F11                ; 2EF2
L2EF4
         lda  RANDOM               ; 2EF4
         and  #$20                 ; 2EF7
         beq  L2EFC                ; 2EF9
         rts                       ; 2EFB
L2EFC
         lda  RANDOM               ; 2EFC
         and  #$03                 ; 2EFF
         tax                       ; 2F01
         lda  $98                  ; 2F02
         pha                       ; 2F04
         lda  $296B,x              ; 2F05
         sta  $98                  ; 2F08
         jsr  sub_2344             ; 2F0A
         pla                       ; 2F0D
         sta  $98                  ; 2F0E
         rts                       ; 2F10
L2F11
         bcs  L2F16                ; 2F11
         jmp  sub_22D0             ; 2F13
L2F16
         jmp  sub_22EF             ; 2F16
entry_2F19
         lda  $A0                  ; 2F19
         beq  L2F1E                ; 2F1B
L2F1D
         rts                       ; 2F1D
L2F1E
         ldx  $9B                  ; 2F1E
         dex                       ; 2F20
         beq  L2F1D                ; 2F21
         lda  #$0D                 ; 2F23
         jsr  sub_3334             ; 2F25
         lda  $02C3                ; 2F28
         pha                       ; 2F2B
         lda  #$0F                 ; 2F2C
         sta  $02C3                ; 2F2E
         jsr  sub_23A6             ; 2F31
         jsr  sub_23A6             ; 2F34
         jsr  sub_23A6             ; 2F37
         pla                       ; 2F3A
         sta  $02C3                ; 2F3B
         lda  #$15                 ; 2F3E
         jmp  L23C6                ; 2F40
entry_2F43
         lda  $210A                ; 2F43
         and  #$03                 ; 2F46
         beq  L2F4B                ; 2F48
         rts                       ; 2F4A
L2F4B
         jsr  sub_23DB             ; 2F4B
         eor  #$03                 ; 2F4E
         jmp  L23C6                ; 2F50
         dta $00                                      ; 2F53
irq_2F54
         jsr  sub_3379             ; 2F54
         lda  $A9                  ; 2F57
         pha                       ; 2F59
         lda  #$00                 ; 2F5A
         sta  $2F53                ; 2F5C
         ldx  #$07                 ; 2F5F
         sed                       ; 2F61
L2F62
         asl  $A9                  ; 2F62
         adc  $2F53                ; 2F64
         sta  $2F53                ; 2F67
         dex                       ; 2F6A
         bpl  L2F62                ; 2F6B
         cld                       ; 2F6D
         ldy  #$25                 ; 2F6E
         jsr  sub_307F             ; 2F70
         pla                       ; 2F73
         sta  $A9                  ; 2F74
         ldy  #$1F                 ; 2F76
         lda  $A2                  ; 2F78
         jsr  sub_307F             ; 2F7A
         ldy  #$19                 ; 2F7D
         lda  $9E                  ; 2F7F
         jsr  sub_307F             ; 2F81
         ldy  #$13                 ; 2F84
         lda  $9F                  ; 2F86
         jsr  sub_307F             ; 2F88
         ldy  #$0D                 ; 2F8B
         lda  $A0                  ; 2F8D
         jsr  sub_307F             ; 2F8F
         ldx  #$02                 ; 2F92
         ldy  #$07                 ; 2F94
L2F96
         lda  $A4,x                ; 2F96
         jsr  sub_307F             ; 2F98
         dex                       ; 2F9B
         bpl  L2F96                ; 2F9C
         lda  COLOR4               ; 2F9E
         sta  COLPM0               ; 2FA1
         sta  $D013                ; 2FA4
         sta  $D014                ; 2FA7
         sta  $D015                ; 2FAA
         lda  #$DE                 ; 2FAD
         sta  VDSLST               ; 2FAF
         lda  #$1E                 ; 2FB2
         sta  VDSLST+1             ; 2FB4
         lda  $99                  ; 2FB7
         bne  L300D                ; 2FB9
         clc                       ; 2FBB
         lda  $1E13                ; 2FBC
         adc  #$7F                 ; 2FBF
         tax                       ; 2FC1
         lda  $1E14                ; 2FC2
         adc  #$00                 ; 2FC5
         cpx  $86                  ; 2FC7
         sbc  $87                  ; 2FC9
         bcc  L2FE4                ; 2FCB
         lda  $1E13                ; 2FCD
         cmp  #$01                 ; 2FD0
         lda  $1E14                ; 2FD2
         sbc  #$B6                 ; 2FD5
         bcc  L2FF6                ; 2FD7
         lda  #$0E                 ; 2FD9
         sta  $9A                  ; 2FDB
         lda  #$82                 ; 2FDD
         sta  $99                  ; 2FDF
         jmp  L300D                ; 2FE1
L2FE4
         clc                       ; 2FE4
         lda  $1E13                ; 2FE5
         adc  #$FF                 ; 2FE8
         tax                       ; 2FEA
         lda  $1E14                ; 2FEB
         adc  #$01                 ; 2FEE
         cpx  $86                  ; 2FF0
         sbc  $87                  ; 2FF2
         bcc  L2FF9                ; 2FF4
L2FF6
         jmp  XITVBV               ; 2FF6
L2FF9
         lda  $1E13                ; 2FF9
         cmp  #$40                 ; 2FFC
         lda  $1E14                ; 2FFE
         sbc  #$BB                 ; 3001
         bcs  L2FF6                ; 3003
         lda  #$02                 ; 3005
         sta  $9A                  ; 3007
         lda  #$42                 ; 3009
         sta  $99                  ; 300B
L300D
         bit  $99                  ; 300D
         bpl  L304D                ; 300F
         lda  $9A                  ; 3011
         bne  L3029                ; 3013
         sta  $D405                ; 3015
         lda  #$0E                 ; 3018
         sta  $9A                  ; 301A
         lda  $99                  ; 301C
         dec  $99                  ; 301E
         and  #$0F                 ; 3020
         bne  L3026                ; 3022
         sta  $99                  ; 3024
L3026
         jmp  L2FF6                ; 3026
L3029
         dec  $9A                  ; 3029
         dec  $9A                  ; 302B
         and  #$07                 ; 302D
         sta  $D405                ; 302F
         cmp  #$06                 ; 3032
         bne  L2FF6                ; 3034
         sec                       ; 3036
         lda  $1E13                ; 3037
         sbc  #$20                 ; 303A
         sta  $1E13                ; 303C
         bcs  L3044                ; 303F
         dec  $1E14                ; 3041
L3044
         lda  #$06                 ; 3044
         sta  $D405                ; 3046
         lda  $9A                  ; 3049
         bne  L2FF6                ; 304B
L304D
         lda  $9A                  ; 304D
         inc  $9A                  ; 304F
         inc  $9A                  ; 3051
         and  #$07                 ; 3053
         sta  $D405                ; 3055
         bne  L2FF6                ; 3058
         clc                       ; 305A
         lda  $1E13                ; 305B
         adc  #$20                 ; 305E
         sta  $1E13                ; 3060
         bcc  L3068                ; 3063
         inc  $1E14                ; 3065
L3068
         lda  $9A                  ; 3068
         cmp  #$10                 ; 306A
         bcc  L2FF6                ; 306C
         lda  $99                  ; 306E
         dec  $99                  ; 3070
         and  #$0F                 ; 3072
         bne  L3078                ; 3074
         sta  $99                  ; 3076
L3078
         lda  #$02                 ; 3078
         sta  $9A                  ; 307A
         jmp  L2FF6                ; 307C
sub_307F
         pha                       ; 307F
         jsr  sub_3088             ; 3080
         pla                       ; 3083
         lsr                       ; 3084
         lsr                       ; 3085
         lsr                       ; 3086
         lsr                       ; 3087
sub_3088
         stx  $309B                ; 3088
         and  #$0F                 ; 308B
         tax                       ; 308D
         lda  $309E,x              ; 308E
         sta  $1E3E,y              ; 3091
         lda  $30A8,x              ; 3094
         sta  $1E66,y              ; 3097
         ldx  #$9A                 ; 309A
         dey                       ; 309C
         rts                       ; 309D
         dta $06,$03,$07,$07,$08,$09,$09,$0A,$0B,$0B,$02,$03,$04,$05,$03,$05 ; 309E
         dta $02,$03,$02,$05                          ; 30AE
sub_30B2
         lda  SKCTL                ; 30B2
         and  #$04                 ; 30B5
         bne  L30C1                ; 30B7
         lda  KBCODE               ; 30B9
         and  #$3F                 ; 30BC
         sec                       ; 30BE
         sbc  #$0C                 ; 30BF
L30C1
         beq  L30C5                ; 30C1
         lda  #$01                 ; 30C3
L30C5
         sta  $30CF                ; 30C5
         lda  SKCTL                ; 30C8
         lsr                       ; 30CB
         lsr                       ; 30CC
         lsr                       ; 30CD
         and  #$00                 ; 30CE
         and  TRIG0                ; 30D0
         and  $D011                ; 30D3
         sta  $3145                ; 30D6
         cmp  $3147                ; 30D9
         beq  L30E1                ; 30DC
         sta  $3146                ; 30DE
L30E1
         lda  $3145                ; 30E1
         sta  $3147                ; 30E4
         txa                       ; 30E7
         pha                       ; 30E8
         ldx  #$00                 ; 30E9
         jsr  sub_3130             ; 30EB
         bcs  L3101                ; 30EE
         cmp  #$1C                 ; 30F0
         bne  L30F7                ; 30F2
         sta  $3154                ; 30F4
L30F7
         ldx  #$04                 ; 30F7
L30F9
         cmp  $314A,x              ; 30F9
         beq  L3101                ; 30FC
         dex                       ; 30FE
         bne  L30F9                ; 30FF
L3101
         lda  $314F,x              ; 3101
         sta  $3114                ; 3104
         pla                       ; 3107
         tax                       ; 3108
         lda  PORTA                ; 3109
         lsr                       ; 310C
         lsr                       ; 310D
         lsr                       ; 310E
         lsr                       ; 310F
         and  PORTA                ; 3110
         and  #$00                 ; 3113
         sta  $3143                ; 3115
         cmp  #$0F                 ; 3118
         beq  L311F                ; 311A
         sta  $3146                ; 311C
L311F
         rts                       ; 311F
         dta $AD,$46,$31,$D0,$0A,$A9,$FF,$8D,$46,$31,$8D,$42,$31,$A9,$00,$60 ; 3120
sub_3130
         lda  SKCTL                ; 3130
         and  #$04                 ; 3133
         bne  L313E                ; 3135
         lda  KBCODE               ; 3137
         and  #$3F                 ; 313A
         clc                       ; 313C
         rts                       ; 313D
L313E
         lda  #$FF                 ; 313E
         sec                       ; 3140
         rts                       ; 3141
         dta $00,$00,$00,$00,$00,$00,$07,$00,$00,$07,$06,$0E,$0F,$0F,$07,$0B ; 3142
         dta $0E,$0D,$00,$80,$46,$00,$00,$48,$80,$4E,$4E,$4E,$4E,$4E,$5E,$5E ; 3152
         dta $CA,$CA,$9E,$00,$80,$C4,$42,$1A,$1A,$9A,$4C,$4A,$00,$00,$1A,$4A ; 3162
         dta $4C,$48,$46,$40,$56,$4C,$CE,$5A,$50,$14,$00,$16,$18,$5E,$54,$46 ; 3172
         dta $4C,$48,$4A,$9C,$9C,$9C,$9C,$9C,$9C,$9C,$9C,$9C,$9C,$40,$00,$48 ; 3182
         dta $5C,$46,$52,$58,$0E,$0E,$0E,$0E,$10,$10,$10,$10,$12,$12,$12,$12 ; 3192
         dta $92,$92,$0C,$0C,$0A,$0A,$0C,$0C,$0A,$0A,$02,$02,$02,$02,$0A,$00 ; 31A2
         dta $0C,$4A,$00,$58,$02,$04,$06,$08,$06,$04,$02,$00,$40,$02,$04,$06 ; 31B2
         dta $5E,$40,$02,$04,$06,$08,$06,$04,$02,$5E,$5E,$00,$00,$C4,$00,$C4 ; 31C2
         dta $00,$00,$00,$62,$63,$64,$65,$66,$67,$20,$00,$6A,$6B,$6C,$6D,$2A ; 31D2
         dta $6F,$70,$71,$72,$73,$74,$75,$3A,$77,$61,$00,$00,$20,$00,$00,$8E ; 31E2
         dta $2C,$00,$00,$00,$00,$5F,$2C,$00,$00,$00,$00,$F3,$29,$FE,$29,$09 ; 31F2
         dta $2A,$14,$2A,$C7,$2A,$E1,$2A,$93,$2D,$80,$2D,$00,$00,$00,$00,$A6 ; 3202
         dta $2D,$00,$00,$00,$00,$19,$2F,$43,$2F,$43,$2F,$EC,$2C,$BD,$2C,$00 ; 3212
         dta $00,$00,$00,$15,$26,$59,$2B,$7F,$2B,$ED,$2A,$33,$2B,$00,$00,$00 ; 3222
         dta $00,$37,$2C,$00,$00,$00,$00,$00,$00,$D5,$2E,$37,$2C,$00,$00,$00 ; 3232
         dta $00,$30,$26,$00,$00,$33,$2D,$33,$2D,$33,$2D,$33,$2D,$FD,$28,$FD ; 3242
         dta $28,$FD,$28,$FD,$28,$FD,$28,$FD,$28,$FD,$28,$FD,$28,$FD,$28,$ED ; 3252
         dta $28,$7B,$29,$00,$00,$A8,$2B,$00,$00,$ED,$2B,$00,$00,$00,$00,$E2 ; 3262
         dta $2D,$F7,$2D,$0C,$2E,$21,$2E,$36,$2E,$4B,$2E,$60,$2E,$75,$2E,$8A ; 3272
         dta $2E,$95,$2E,$A0,$2E,$AB,$2E,$B6,$2E,$C0,$2E,$F8,$2A,$3E,$2B,$64 ; 3282
         dta $2B,$8A,$2B,$AE,$2B,$F3,$2B,$18,$2C,$3D,$2C,$65,$2C,$94,$2C,$C3 ; 3292
         dta $2C,$F2,$2C,$00,$00,$00,$00,$00,$00,$12,$2C,$00,$00,$33,$2A,$00 ; 32A2
         dta $02,$00,$00,$02,$00,$02,$02,$02,$02,$02,$00,$00,$02,$02,$03,$00 ; 32B2
         dta $00,$02,$00,$00,$00,$00,$02,$02,$00,$00,$00,$02,$02,$02,$02,$03 ; 32C2
         dta $03,$02,$02,$02,$03,$03,$00,$00,$00,$03,$03,$02,$02,$02,$02,$02 ; 32D2
         dta $02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$00,$02,$02,$02,$03,$03 ; 32E2
         dta $03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$00,$00 ; 32F2
         dta $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$00,$00 ; 3302
         dta $02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02 ; 3312
         dta $02,$02,$02,$02,$02,$00,$00,$00,$00,$00,$00,$02,$00,$00,$00,$00 ; 3322
         dta $00,$00                                  ; 3332
sub_3334
         tax                       ; 3334
         bmi  L3367                ; 3335
         lda  #$00                 ; 3337
         sta  $FD                  ; 3339
         txa                       ; 333B
         asl                       ; 333C
         asl                       ; 333D
         asl                       ; 333E
         rol  $FD                  ; 333F
         asl                       ; 3341
         rol  $FD                  ; 3342
         asl                       ; 3344
         rol  $FD                  ; 3345
         adc  #$C4                 ; 3347
         sta  $FC                  ; 3349
         lda  $FD                  ; 334B
         adc  #$33                 ; 334D
         sta  $FD                  ; 334F
         cpx  #$03                 ; 3351
         bcc  L3357                ; 3353
         ldx  #$03                 ; 3355
L3357
         lda  #$10                 ; 3357
         sta  $F0,x                ; 3359
         txa                       ; 335B
         asl                       ; 335C
         tax                       ; 335D
         lda  $FC                  ; 335E
         sta  $F4,x                ; 3360
         lda  $FD                  ; 3362
         sta  $F5,x                ; 3364
         rts                       ; 3366
L3367
         lda  #$03                 ; 3367
         sta  SKCTL                ; 3369
         lda  #$00                 ; 336C
         ldx  #$08                 ; 336E
L3370
         sta  $F0,x                ; 3370
         sta  AUDF1,x              ; 3372
         dex                       ; 3375
         bpl  L3370                ; 3376
         rts                       ; 3378
sub_3379
         lda  RTCLOK+2             ; 3379
         and  #$03                 ; 337B
         beq  L3380                ; 337D
         rts                       ; 337F
L3380
         ldx  #$03                 ; 3380
         ldy  #$06                 ; 3382
L3384
         lda  $F0,x                ; 3384
         beq  L338E                ; 3386
         jsr  sub_339A             ; 3388
         jmp  L3394                ; 338B
L338E
         sta  AUDF1,y              ; 338E
         sta  AUDC1,y              ; 3391
L3394
         dey                       ; 3394
         dey                       ; 3395
         dex                       ; 3396
         bpl  L3384                ; 3397
         rts                       ; 3399
sub_339A
         tya                       ; 339A
         pha                       ; 339B
         dta $B9,a($00F4)          ; 339C lda ,y
         sta  $FC                  ; 339F
         dta $B9,a($00F5)          ; 33A1 lda ,y
         sta  $FD                  ; 33A4
         ldy  $F0,x                ; 33A6
         dey                       ; 33A8
         sty  $F0,x                ; 33A9
         tya                       ; 33AB
         asl                       ; 33AC
         tay                       ; 33AD
         lda  ($FC),y              ; 33AE
         sta  $FE                  ; 33B0
         iny                       ; 33B2
         lda  ($FC),y              ; 33B3
         sta  $FF                  ; 33B5
         pla                       ; 33B7
         tay                       ; 33B8
         lda  $FF                  ; 33B9
         sta  AUDF1,y              ; 33BB
         lda  $FE                  ; 33BE
         sta  AUDC1,y              ; 33C0
         rts                       ; 33C3
         dta $00,$00,$00,$00,$00,$00,$00,$00,$81,$22,$81,$22,$82,$22,$83,$22 ; 33C4
         dta $83,$22,$84,$22,$85,$22,$85,$22,$86,$22,$87,$22,$88,$22,$86,$22 ; 33D4
         dta $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 33E4
         dta $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$81,$03,$82,$02,$83,$01 ; 33F4
         dta $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 3404
         dta $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$81,$01 ; 3414
         dta $00,$00,$A1,$60,$A1,$40,$A1,$20,$A2,$61,$A2,$42,$A2,$23,$A2,$64 ; 3424
         dta $A3,$45,$A3,$26,$A3,$67,$A3,$48,$A4,$29,$A4,$6A,$A4,$4B,$A4,$2C ; 3434
         dta $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 3444
         dta $00,$00,$00,$00,$00,$00,$00,$00,$A1,$2B,$A2,$2A,$A3,$2B,$A4,$2A ; 3454
         dta $A1,$45,$A2,$44,$A3,$45,$A6,$44,$A3,$51,$A6,$50,$A1,$45,$A2,$44 ; 3464
         dta $A3,$45,$A6,$44,$A3,$8A,$A6,$88,$A3,$8A,$A6,$88,$A3,$8A,$A6,$88 ; 3474
         dta $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$88,$C1,$94,$03,$A9 ; 3484
         dta $C4,$92,$C5,$B0,$C6,$AD,$C7,$BE,$C8,$CE,$C8,$D4,$C7,$E8,$08,$F8 ; 3494
         dta $00,$00,$C1,$01,$00,$00,$C1,$01,$00,$00,$C2,$01,$00,$00,$C3,$01 ; 34A4
         dta $00,$00,$C4,$01,$00,$00,$C3,$01,$00,$00,$C2,$01,$00,$00,$C1,$01 ; 34B4
         dta $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 34C4
         dta $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$82,$02,$80,$01,$81 ; 34D4
         dta $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 34E4
         dta $00,$00,$00,$00,$A1,$11,$A2,$12,$A3,$13,$A4,$14,$A5,$15,$A6,$16 ; 34F4
         dta $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 3504
         dta $00,$00,$81,$05,$82,$05,$83,$05,$84,$05,$84,$06,$83,$06,$82,$06 ; 3514
         dta $A1,$0A,$A2,$0A,$A4,$0A,$A6,$0A,$A8,$0A,$00,$00,$00,$00,$00,$00 ; 3524
         dta $00,$00,$87,$08,$86,$10,$85,$20,$84,$30,$83,$40,$82,$50,$81,$60 ; 3534
         dta $00,$00,$A1,$10,$A1,$10,$A2,$10,$A3,$10,$A4,$10,$A1,$10,$A2,$10 ; 3544
         dta $A3,$10,$A4,$10,$A5,$10,$A2,$10,$A3,$10,$A5,$10,$A7,$10,$A8,$10 ; 3554
         dta $01,$18,$01,$08,$02,$18,$02,$08,$03,$18,$03,$08,$04,$18,$04,$08 ; 3564
         dta $05,$18,$05,$08,$06,$18,$06,$08,$08,$18,$08,$08,$0A,$18,$0A,$08 ; 3574
         dta $08,$10,$08,$00,$07,$00,$07,$00,$06,$10,$06,$00,$05,$00,$05,$00 ; 3584
         dta $04,$10,$04,$00,$03,$00,$03,$00,$02,$10,$02,$00,$01,$00,$01,$00 ; 3594
