; ITEMS.ASM - enemy contact, energy and lives, treasures
; $9796-$99FF

         org $9796


* player contact with hazards and enemies ------------------
CONTACT
         lda  PROBE_TILE           ; 9796
         and  #$08                 ; 9799
         beq  L97A6                ; 979B
         lda  FRAME                ; 979D
         and  #$01                 ; 979F
         bne  L97A6                ; 97A1
         jsr  HIT                  ; 97A3
L97A6
         ldx  #$03                 ; 97A6
L97A8
         lda  ENEMY_X,x            ; 97A8
         sec                       ; 97AB
         sbc  #$0B                 ; 97AC
         cmp  PLAYER_X             ; 97AE
         bcs  L97D4                ; 97B1
         adc  #$0D                 ; 97B3
         cmp  PLAYER_X             ; 97B5
         bcc  L97D4                ; 97B8
         lda  ENEMY_Y,x            ; 97BA
         sec                       ; 97BD
         sbc  #$18                 ; 97BE
         cmp  PLAYER_Y             ; 97C0
         bcs  L97D4                ; 97C3
         adc  #$20                 ; 97C5
         cmp  PLAYER_Y             ; 97C7
         bcc  L97D4                ; 97CA
         lda  SWING                ; 97CC
         bne  L97D8                ; 97CF
         jsr  HIT                  ; 97D1
L97D4
         dex                       ; 97D4
         bpl  L97A8                ; 97D5
         rts                       ; 97D7
L97D8
         lda  ENEMY_FRAME,x        ; 97D8
         and  #$10                 ; 97DB
         bne  L97D4                ; 97DD
         lda  ENEMY_HITS,x         ; 97DF
         beq  L97EB                ; 97E2
         dec  ENEMY_HITS,x         ; 97E4
         dex                       ; 97E7
         bpl  L97A8                ; 97E8
         rts                       ; 97EA
L97EB
         lda  #$00                 ; 97EB
         sta  ENEMY_Y,x            ; 97ED
         stx  $97F7                ; 97F0
         lda  #$00                 ; 97F3
         clc                       ; 97F5
         adc  #$00                 ; 97F6
         tay                       ; 97F8
         lda  #$00                 ; 97F9
         sta  $C500,y              ; 97FB
         dex                       ; 97FE
         bpl  L97A8                ; 97FF
         rts                       ; 9801

* lose energy; at 0 lose a life ----------------------------
HIT
         stx  $9813                ; 9802
         lda  MUSIC_OFF            ; 9805
         bne  L9812                ; 9807
         lda  #$21                 ; 9809
         ldx  #$0C                 ; 980B
         ldy  #$16                 ; 980D
         jsr  CMC_CMD              ; 980F
L9812
         ldx  #$00                 ; 9812
         dec  ENERGY               ; 9814
         lda  ENERGY               ; 9816
         beq  L981B                ; 9818
         rts                       ; 981A
L981B
         stx  $982C                ; 981B
         lda  MUSIC_OFF            ; 981E
         bne  L982B                ; 9820
         lda  #$21                 ; 9822
         ldx  #$18                 ; 9824
         ldy  #$14                 ; 9826
         jsr  CMC_CMD              ; 9828
L982B
         ldx  #$00                 ; 982B
         dec  LIVES                ; 982D
         lda  #$60                 ; 982F
         sta  ENERGY               ; 9831
         rts                       ; 9833
         dta $00,$00,$00                              ; 9834

* draw the two food items of a cave room -------------------
FOOD_DRAW
         lda  $9834                ; 9837
         asl                       ; 983A
         asl                       ; 983B
         tay                       ; 983C
         jsr  ITEM_DRAW            ; 983D
         lda  $E0                  ; 9840
         sta  $99A4                ; 9842
         lda  $C2                  ; 9845
         sta  $99B5                ; 9847
         sta  $99B8                ; 984A
         lda  $C3                  ; 984D
         sta  $99B6                ; 984F
         clc                       ; 9852
         adc  #$02                 ; 9853
         sta  $99B9                ; 9855
         lda  $9835                ; 9858
         asl                       ; 985B
         asl                       ; 985C
         tay                       ; 985D
         jsr  ITEM_DRAW            ; 985E
         lda  $E0                  ; 9861
         sta  $99BD                ; 9863
         lda  $C2                  ; 9866
         sta  $99CE                ; 9868
         sta  $99D1                ; 986B
         lda  $C3                  ; 986E
         sta  $99CF                ; 9870
         clc                       ; 9873
         adc  #$02                 ; 9874
         sta  $99D2                ; 9876
         rts                       ; 9879
L987A
         sta  $E0                  ; 987A
         sta  $C2                  ; 987C
         lda  #$03                 ; 987E
         sta  $C3                  ; 9880
         rts                       ; 9882

* draw one food item into the screen -----------------------
ITEM_DRAW
         lda  $A4E9,y              ; 9883
         beq  L987A                ; 9886
         lda  RANDOM               ; 9888
         and  #$13                 ; 988B
         ora  $A4E9,y              ; 988D
         asl                       ; 9890
         tax                       ; 9891
         lda  $C800,x              ; 9892
         clc                       ; 9895
         adc  #$10                 ; 9896
         sta  $C4                  ; 9898
         lda  $C801,x              ; 989A
         clc                       ; 989D
         adc  #$10                 ; 989E
         sta  $C6                  ; 98A0
         lda  $C840,x              ; 98A2
         sta  $C5                  ; 98A5
         lda  $C841,x              ; 98A7
         sta  $C7                  ; 98AA
         lda  $A4EA,y              ; 98AC
         sta  $E1                  ; 98AF
         lda  $A4EB,y              ; 98B1
         sta  $E2                  ; 98B4
         lda  $A4EC,y              ; 98B6
         sta  $E0                  ; 98B9
         lda  $E1                  ; 98BB
         lsr                       ; 98BD
         lsr                       ; 98BE
         sta  $98CE                ; 98BF
         lda  $E2                  ; 98C2
         lsr                       ; 98C4
         lsr                       ; 98C5
         lsr                       ; 98C6
         lsr                       ; 98C7
         tax                       ; 98C8
         clc                       ; 98C9
         lda  $C5E0,x              ; 98CA
         adc  #$00                 ; 98CD
         sta  $C2                  ; 98CF
         lda  $C5F0,x              ; 98D1
         adc  #$BC                 ; 98D4
         sta  $C3                  ; 98D6
         ldy  #$00                 ; 98D8
         jsr  CHAR_ADDR            ; 98DA
         sty  $D0                  ; 98DD
         sta  $D1                  ; 98DF
         ldy  #$01                 ; 98E1
         jsr  CHAR_ADDR            ; 98E3
         sty  $D2                  ; 98E6
         sta  $D3                  ; 98E8
         ldy  #$00                 ; 98EA
         lda  ($C2),y              ; 98EC
         tax                       ; 98EE
         lda  $E0                  ; 98EF
         stx  $E0                  ; 98F1
         sta  ($C2),y              ; 98F3
         ora  #$01                 ; 98F5
         iny                       ; 98F7
         sta  ($C2),y              ; 98F8
         dey                       ; 98FA
         inc  $C3                  ; 98FB
         inc  $C3                  ; 98FD
         and  #$FE                 ; 98FF
         sta  ($C2),y              ; 9901
         ora  #$01                 ; 9903
         iny                       ; 9905
         sta  ($C2),y              ; 9906
         dec  $C3                  ; 9908
         dec  $C3                  ; 990A
         ldy  #$00                 ; 990C
         jsr  CHAR_ADDR            ; 990E
         sty  $C8                  ; 9911
         sty  $D4                  ; 9913
         sta  $C9                  ; 9915
         txa                       ; 9917
         ora  #$E0                 ; 9918
         sta  $D5                  ; 991A
         ldy  #$01                 ; 991C
         jsr  CHAR_ADDR            ; 991E
         sty  $CA                  ; 9921
         sty  $CE                  ; 9923
         sta  $CB                  ; 9925
         txa                       ; 9927
         ora  #$E0                 ; 9928
         sta  $CF                  ; 992A
         lda  $EF                  ; 992C
         beq  L993B                ; 992E
         ldy  #$00                 ; 9930
L9932
         lda  $C500,y              ; 9932
         sta  $84BA,y              ; 9935
         iny                       ; 9938
         bne  L9932                ; 9939
L993B
         ldy  #$00                 ; 993B
L993D
         lda  ($C6),y              ; 993D
         sta  $E1                  ; 993F
         lda  ($C4),y              ; 9941
         sta  $E2                  ; 9943
         ldx  $E1                  ; 9945
         lda  ($D2),y              ; 9947
         and  $C200,x              ; 9949
         ora  $E1                  ; 994C
         sta  ($CA),y              ; 994E
         sta  ($CE),y              ; 9950
         ldx  $E2                  ; 9952
         lda  ($D0),y              ; 9954
         and  $C200,x              ; 9956
         ora  $E2                  ; 9959
         sta  ($C8),y              ; 995B
         sta  ($D4),y              ; 995D
         iny                       ; 995F
         cpy  #$08                 ; 9960
         bne  L9967                ; 9962
         jsr  SPR_HALF2            ; 9964
L9967
         cpy  #$10                 ; 9967
         bcs  L996E                ; 9969
         jmp  L993D                ; 996B
L996E
         rts                       ; 996E

* is the player on a food item? ----------------------------
FOOD_CHECK
         lda  PLAYER_Y             ; 996F
         clc                       ; 9972
         adc  #$04                 ; 9973
         tay                       ; 9975
         lda  PLAYER_X             ; 9976
         clc                       ; 9979
         adc  #$02                 ; 997A
         jsr  MAP_TILE             ; 997C
         ldy  #$00                 ; 997F
         ldx  $9836                ; 9981
         lda  MAP_PTR              ; 9984
         clc                       ; 9986
         adc  #$28                 ; 9987
         cmp  $99B5                ; 9989
         beq  L99A3                ; 998C
         cmp  $99CE                ; 998E
         beq  L99BC                ; 9991
         clc                       ; 9993
         adc  #$01                 ; 9994
         cmp  $99B5                ; 9996
         beq  L99A3                ; 9999
         cmp  $99CE                ; 999B
         beq  L99BC                ; 999E
         ldy  #$00                 ; 99A0
         rts                       ; 99A2
L99A3
         lda  #$00                 ; 99A3
         pha                       ; 99A5
         lda  $C603,x              ; 99A6
         and  #$FD                 ; 99A9
         sta  $C603,x              ; 99AB
         pla                       ; 99AE
         jsr  FOOD1_ERASE          ; 99AF
         ora  #$01                 ; 99B2

* erase food item 1 (STA operands patched with its screen address by $9837) ---
FOOD1_ERASE
         sta  FOOD1_ERASE,y        ; 99B4
         sta  $99B7,y              ; 99B7
         iny                       ; 99BA
         rts                       ; 99BB
L99BC
         lda  #$00                 ; 99BC
         pha                       ; 99BE
         lda  $C603,x              ; 99BF
         and  #$FE                 ; 99C2
         sta  $C603,x              ; 99C4
         pla                       ; 99C7
         jsr  FOOD2_ERASE          ; 99C8
         ora  #$01                 ; 99CB

* erase food item 2 (STA operands patched by $9837) --------
FOOD2_ERASE
         sta  FOOD2_ERASE,y        ; 99CD
         sta  $99D0,y              ; 99D0
         iny                       ; 99D3
         rts                       ; 99D4

* font address of the character at ($C2),Y - uses the undocumented opcode $AB (LXA) ---
CHAR_ADDR
         lda  ($C2),y              ; 99D5
         dta $AB,$7F,$BD,$00,$C3,$A8,$BD,$80,$C3,$AA,$09,$D8,$60 ; 99D7

* pick up food: FOOD + 1 -----------------------------------
FOOD_PICK
         lda  PROBE_TILE           ; 99E4
         and  #$20                 ; 99E7
         beq  L99FF                ; 99E9
         jsr  FOOD_CHECK           ; 99EB
         beq  L99FF                ; 99EE
         inc  FOOD                 ; 99F0
         lda  MUSIC_OFF            ; 99F2
         bne  L99FF                ; 99F4
         lda  #$21                 ; 99F6
         ldx  #$24                 ; 99F8
         ldy  #$15                 ; 99FA
         jsr  CMC_CMD              ; 99FC
L99FF
         rts                       ; 99FF
