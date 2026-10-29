; ROOMS.ASM - player map probe ($948F), cave rooms
; $948F-$96C7

         org $948F


* probe the map around the player -> PROBE_FLOOR / PROBE_TILE / PROBE_WALL ---
sub_948F
         lda  PLAYER_Y             ; 948F
         clc                       ; 9492
         adc  #$04                 ; 9493
         tay                       ; 9495
         lda  PLAYER_X             ; 9496
         clc                       ; 9499
         adc  #$04                 ; 949A
         jsr  sub_912F             ; 949C
         jsr  sub_8DF0             ; 949F
         sta  PROBE_FLOOR          ; 94A2
         ldy  #$51                 ; 94A5
         lda  (MAP_PTR),y          ; 94A7
         jsr  sub_8DF0             ; 94A9
         ora  PROBE_FLOOR          ; 94AC
         sta  PROBE_FLOOR          ; 94AF
         ldy  #$28                 ; 94B2
         lda  (MAP_PTR),y          ; 94B4
         jsr  sub_8DF0             ; 94B6
         sta  PROBE_TILE           ; 94B9
         ldy  #$29                 ; 94BC
         lda  (MAP_PTR),y          ; 94BE
         jsr  sub_8DF0             ; 94C0
         ora  PROBE_TILE           ; 94C3
         sta  PROBE_TILE           ; 94C6
         ldy  PLAYER_Y             ; 94C9
         lda  PLAYER_X             ; 94CC
         clc                       ; 94CF
         adc  #$01                 ; 94D0
         and  #$04                 ; 94D2
         beq  L94EF                ; 94D4
         lda  PLAYER_X             ; 94D6
         clc                       ; 94D9
         adc  #$04                 ; 94DA
         jsr  sub_912F             ; 94DC
         jsr  sub_8DF0             ; 94DF
         sta  PROBE_WALL           ; 94E2
         ldy  #$51                 ; 94E5
         lda  (MAP_PTR),y          ; 94E7
         jsr  sub_8DF0             ; 94E9
         ora  PROBE_WALL           ; 94EC
L94EF
         sta  PROBE_WALL           ; 94EF
         lda  #$00                 ; 94F2
         sta  COUNTER              ; 94F4
         rts                       ; 94F6

* cave room: own loop until the player walks out -----------
sub_94F7
         lda  CAVE_FLAG            ; 94F7
         bne  L94FC                ; 94F9
         rts                       ; 94FB
L94FC
         lda  PLAYER_X             ; 94FC
         sta  $959B                ; 94FF
         lda  PLAYER_Y             ; 9502
         sta  $9593                ; 9505
         lda  #$C0                 ; 9508
         sta  PLAYER_X             ; 950A
         lda  #$6E                 ; 950D
         sta  PLAYER_Y             ; 950F
         jsr  sub_96C8             ; 9512
         jsr  sub_8A4D             ; 9515
         jsr  sub_95D5             ; 9518
         jsr  sub_9615             ; 951B
         jsr  sub_9837             ; 951E
         jsr  sub_9699             ; 9521
         jsr  sub_9729             ; 9524
         lda  #$08                 ; 9527
         sta  PLAYER_X             ; 9529
         lda  #$70                 ; 952C
         sta  PLAYER_Y             ; 952E
         ldx  RTCLOK+2             ; 9531
         inx                       ; 9533
         stx  NEXT_TICK            ; 9534
L9536
         lda  #$00                 ; 9536
         sta  $4D                  ; 9538
         sta  CH                   ; 953A
L953D
         lda  RTCLOK+2             ; 953D
         cmp  NEXT_TICK            ; 953F
         bcc  L953D                ; 9541
         clc                       ; 9543
         adc  #$03                 ; 9544
         sta  NEXT_TICK            ; 9546
         jsr  sub_9027             ; 9548
         jsr  sub_8F08             ; 954B
         jsr  sub_948F             ; 954E
         jsr  sub_9796             ; 9551
         jsr  sub_8DF8             ; 9554
         jsr  sub_99E4             ; 9557
         lda  LIVES                ; 955A
         beq  L95AD                ; 955C
         lda  PLAYER_X             ; 955E
         cmp  #$05                 ; 9561
         bcc  L9569                ; 9563
         cmp  #$98                 ; 9565
         bcc  L9536                ; 9567
L9569
         lda  #$60                 ; 9569
         sta  PLAYER_Y             ; 956B
         lda  #$C0                 ; 956E
         sta  PLAYER_X             ; 9570
         jsr  sub_96C8             ; 9573
         jsr  sub_8A4D             ; 9576
         jsr  sub_8FC7             ; 9579
         jsr  sub_9744             ; 957C
         dec  $9593                ; 957F
         dec  $9593                ; 9582
         lda  #$00                 ; 9585
         sta  JUMP_STATE           ; 9587
         sta  JUMP_STEP            ; 958A
         lda  #$01                 ; 958D
         sta  PROBE_FLOOR          ; 958F
         ldy  #$00                 ; 9592
         sty  PLAYER_Y             ; 9594
         jsr  sub_8A4D             ; 9597
         ldx  #$00                 ; 959A
         stx  PLAYER_X             ; 959C
         lda  #$00                 ; 959F
         sta  CAVE_FLAG            ; 95A1
         lda  RTCLOK+2             ; 95A3
         clc                       ; 95A5
         adc  #$04                 ; 95A6
         sta  NEXT_TICK            ; 95A8
         jmp  sub_9151             ; 95AA
L95AD
         pla                       ; 95AD
         pla                       ; 95AE
         jmp  L8F02                ; 95AF
         dta $A9,$00,$85,$D0,$A9,$05,$85,$D1,$D0,$08,$A9,$00,$85,$D0,$A9,$06 ; 95B2
         dta $85,$D1,$A9,$00,$20,$80,$90,$A9,$C8,$20,$9D,$7D,$98,$30,$03,$4C ; 95C2
         dta $ED,$7E,$60                              ; 95D2

* draw the cave room screen --------------------------------
sub_95D5
         lda  #$E3                 ; 95D5
         sta  $C0                  ; 95D7
         lda  #$9F                 ; 95D9
         sta  $C1                  ; 95DB
         lda  #$BC                 ; 95DD
         sta  $9607                ; 95DF
         lda  #$BE                 ; 95E2
         sta  $960A                ; 95E4
         lda  #$00                 ; 95E7
         sta  $9606                ; 95E9
         sta  $9609                ; 95EC
         ldx  #$00                 ; 95EF
         ldy  #$00                 ; 95F1
L95F3
         lda  ($C0),y              ; 95F3
         asl                       ; 95F5
         jsr  sub_9605             ; 95F6
         clc                       ; 95F9
         adc  #$01                 ; 95FA
         jsr  sub_9605             ; 95FC
         iny                       ; 95FF
         cpy  #$C8                 ; 9600
         bne  L95F3                ; 9602
         rts                       ; 9604
sub_9605
         sta  LBC00,x              ; 9605
         sta  $BE00,x              ; 9608
         inx                       ; 960B
         bne  L9614                ; 960C
         inc  $9607                ; 960E
         inc  $960A                ; 9611
L9614
         rts                       ; 9614

* find the cave room of this screen, choose its food -------
sub_9615
         lda  #$00                 ; 9615
         ldx  #$03                 ; 9617
L9619
         sta  ENEMY_X,x            ; 9619
         sta  ENEMY_Y,x            ; 961C
         sta  ENEMY_TYPE,x         ; 961F
         dex                       ; 9622
         bpl  L9619                ; 9623
         ldx  #$FC                 ; 9625
L9627
         inx                       ; 9627
         inx                       ; 9628
         inx                       ; 9629
         inx                       ; 962A
         lda  $C600,x              ; 962B
         bne  L9631                ; 962E
         rts                       ; 9630
L9631
         cmp  SCREEN_COL           ; 9631
         bne  L9627                ; 9634
         lda  $C601,x              ; 9636
         cmp  $9593                ; 9639
         bne  L9627                ; 963C
         lda  $C602,x              ; 963E
         sec                       ; 9641
         sbc  #$0A                 ; 9642
         cmp  $959B                ; 9644
         bcs  L9627                ; 9647
         adc  #$14                 ; 9649
         cmp  $959B                ; 964B
         bcc  L9627                ; 964E
         lda  $C603,x              ; 9650
         lsr                       ; 9653
         lsr                       ; 9654
         lsr                       ; 9655
         lsr                       ; 9656
         lsr                       ; 9657
         and  #$06                 ; 9658
         tay                       ; 965A
         lda  $9FDB,y              ; 965B
         sta  $C0                  ; 965E
         lda  $9FDC,y              ; 9660
         sta  $C1                  ; 9663
         lda  $C603,x              ; 9665
         and  #$30                 ; 9668
         lsr                       ; 966A
         lsr                       ; 966B
         lsr                       ; 966C
         lsr                       ; 966D
         sta  $9834                ; 966E
         inc  $9834                ; 9671
         lda  $C603,x              ; 9674
         and  #$0C                 ; 9677
         lsr                       ; 9679
         lsr                       ; 967A
         sta  $9835                ; 967B
         inc  $9835                ; 967E
         lda  $C603,x              ; 9681
         and  #$02                 ; 9684
         bne  L968B                ; 9686
         sta  $9834                ; 9688
L968B
         lda  $C603,x              ; 968B
         and  #$01                 ; 968E
         bne  L9695                ; 9690
         sta  $9835                ; 9692
L9695
         stx  $9836                ; 9695
         rts                       ; 9698

* spawn the cave room enemies ------------------------------
sub_9699
         ldy  #$00                 ; 9699
         ldx  #$00                 ; 969B
L969D
         lda  ($C0),y              ; 969D
         beq  L96BA                ; 969F
         sta  ENEMY_FRAME,x        ; 96A1
         iny                       ; 96A4
         lda  ($C0),y              ; 96A5
         sta  ENEMY_X,x            ; 96A7
         iny                       ; 96AA
         lda  ($C0),y              ; 96AB
         sta  ENEMY_Y,x            ; 96AD
         iny                       ; 96B0
         lda  ($C0),y              ; 96B1
         sta  ENEMY_TYPE,x         ; 96B3
         iny                       ; 96B6
         inx                       ; 96B7
         bne  L969D                ; 96B8
L96BA
         ldx  #$A4                 ; 96BA
         ldy  #$93                 ; 96BC
         jsr  sub_7C03             ; 96BE
         lda  RTCLOK+2             ; 96C1
         sta  NEXT_TICK            ; 96C3
         inc  NEXT_TICK            ; 96C5
         rts                       ; 96C7
