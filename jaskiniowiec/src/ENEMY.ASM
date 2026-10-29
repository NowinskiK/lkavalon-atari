; ENEMY.ASM - enemies: movement and spawning
; $9027-$9214

         org $9027


* move the 4 enemies, then draw sprites and swap buffers ---
ENEMIES
         ldx  #$04                 ; 9027
L9029
         dex                       ; 9029
         bmi  L907D                ; 902A
         stx  $C1                  ; 902C
         lda  ENEMY_TYPE,x         ; 902E
         bne  L9039                ; 9031
         jsr  EN_WALK              ; 9033
         jmp  L9055                ; 9036
L9039
         bpl  L9048                ; 9039
         lda  PROT_FLAG            ; 903B
         bmi  L9042                ; 903D
         jsr  TRAP_SHAPE           ; 903F
L9042
         jsr  EN_VERT              ; 9042
         jmp  L9055                ; 9045
L9048
         cmp  #$40                 ; 9048
         bne  L9052                ; 904A
         jsr  EN_STATIC            ; 904C
         jmp  L9055                ; 904F
L9052
         jsr  EN_FLY               ; 9052
L9055
         lda  FONT_PAGE            ; 9055
         cmp  #$E0                 ; 9057
         bne  L9029                ; 9059
         ldx  $C1                  ; 905B
         lda  ENEMY_ANIM,x         ; 905D
         clc                       ; 9060
         adc  #$01                 ; 9061
         and  #$03                 ; 9063
         sta  ENEMY_ANIM,x         ; 9065
         tay                       ; 9068
         lda  ENEMY_FRAME,x        ; 9069
         and  #$FC                 ; 906C
         sta  ENEMY_FRAME,x        ; 906E
         lda  ENEMY_ANIM_FR,y      ; 9071
         ora  ENEMY_FRAME,x        ; 9074
         sta  ENEMY_FRAME,x        ; 9077
         jmp  L9029                ; 907A
L907D
         jmp  SPR_FRAME            ; 907D
         dta $8D,$0B,$03,$A9,$31,$8D,$00,$03,$A9,$07,$8D,$06,$03,$A9,$52,$8D ; 9080
         dta $02,$03,$A9,$80,$8D,$08,$03,$A9,$00,$8D,$09,$03,$60 ; 9090

* enemy: walker (turns at walls and edges) -----------------
EN_WALK
         lda  ENEMY_X,x            ; 909D
         sec                       ; 90A0
         sbc  ENEMY_SPEED,x        ; 90A1
         sta  ENEMY_X,x            ; 90A4
         lda  FONT_PAGE            ; 90A7
         cmp  #$E0                 ; 90A9
         beq  L90AE                ; 90AB
         rts                       ; 90AD
L90AE
         lda  ENEMY_X,x            ; 90AE
         cmp  #$06                 ; 90B1
         beq  L90D2                ; 90B3
         cmp  #$A2                 ; 90B5
         bcs  L90D2                ; 90B7
         ldy  ENEMY_Y,x            ; 90B9
         jsr  MAP_TILE             ; 90BC
         jsr  TILE_ATTR            ; 90BF
         and  #$01                 ; 90C2
         beq  L90D2                ; 90C4
         ldy  #$51                 ; 90C6
         lda  (MAP_PTR),y          ; 90C8
         jsr  TILE_ATTR            ; 90CA
         and  #$01                 ; 90CD
         beq  L90D2                ; 90CF
         rts                       ; 90D1
L90D2
         ldx  $C1                  ; 90D2
         lda  ENEMY_SPEED,x        ; 90D4
         eor  #$FE                 ; 90D7
         sta  ENEMY_SPEED,x        ; 90D9
         lda  ENEMY_FLAGS,x        ; 90DC
         eor  #$80                 ; 90DF
         sta  ENEMY_FLAGS,x        ; 90E1
         rts                       ; 90E4

* enemy: flyer (horizontal) --------------------------------
EN_FLY
         lda  ENEMY_X,x            ; 90E5
         sec                       ; 90E8
         sbc  ENEMY_SPEED,x        ; 90E9
         sta  ENEMY_X,x            ; 90EC
         lda  FONT_PAGE            ; 90EF
         cmp  #$E0                 ; 90F1
         beq  L90F6                ; 90F3
         rts                       ; 90F5
L90F6
         lda  ENEMY_X,x            ; 90F6
         cmp  #$02                 ; 90F9
         beq  L90D2                ; 90FB
         cmp  #$A8                 ; 90FD
         bcs  L90D2                ; 90FF
         rts                       ; 9101

* enemy: vertical ------------------------------------------
EN_VERT
         lda  ENEMY_Y,x            ; 9102
         sec                       ; 9105
         sbc  ENEMY_SPEED,x        ; 9106
         sta  ENEMY_Y,x            ; 9109
         lda  FONT_PAGE            ; 910C
         cmp  #$E0                 ; 910E
         beq  L9113                ; 9110
         rts                       ; 9112
L9113
         lda  ENEMY_Y,x            ; 9113
         and  #$0F                 ; 9116
         beq  L9123                ; 9118
         cmp  #$02                 ; 911A
         bcc  L9123                ; 911C
         cmp  #$0E                 ; 911E
         bcs  L9123                ; 9120
         rts                       ; 9122
L9123
         ldx  $C1                  ; 9123
         lda  ENEMY_SPEED,x        ; 9125
         eor  #$FE                 ; 9128
         sta  ENEMY_SPEED,x        ; 912A
         rts                       ; 912D

* enemy: static (does nothing) -----------------------------
EN_STATIC
         rts                       ; 912E

* map pointer / tile under X (A) and Y ---------------------
MAP_TILE
         clc                       ; 912F
         adc  #$01                 ; 9130
         lsr                       ; 9132
         lsr                       ; 9133
         sta  $9142                ; 9134
         tya                       ; 9137
         lsr                       ; 9138
         lsr                       ; 9139
         lsr                       ; 913A
         lsr                       ; 913B
         tax                       ; 913C
         clc                       ; 913D
         lda  $C5E0,x              ; 913E
         adc  #$00                 ; 9141
         sta  MAP_PTR              ; 9143
         lda  $C5F0,x              ; 9145
         adc  $82                  ; 9148
         sta  MAP_PTR+1            ; 914A
         ldy  #$50                 ; 914C
         lda  (MAP_PTR),y          ; 914E
         rts                       ; 9150

* spawn the enemies of the current screen ------------------
EN_SPAWN
         ldx  #$03                 ; 9151
L9153
         ldy  #$80                 ; 9153
         lda  ENEMY_SPEED,x        ; 9155
         bmi  L915C                ; 9158
         ldy  #$00                 ; 915A
L915C
         tya                       ; 915C
         sta  ENEMY_FLAGS,x        ; 915D
         dex                       ; 9160
         bpl  L9153                ; 9161
         lda  #$00                 ; 9163
         ldx  #$03                 ; 9165
L9167
         sta  ENEMY_X,x            ; 9167
         sta  ENEMY_Y,x            ; 916A
         dex                       ; 916D
         bpl  L9167                ; 916E
         ldx  #$0C                 ; 9170
L9172
         lda  $A4FD,x              ; 9172
         cmp  SCREEN_COL           ; 9175
         beq  L917D                ; 9178
         dex                       ; 917A
         bne  L9172                ; 917B
L917D
         ldy  $A50A,x              ; 917D
         sty  $97F4                ; 9180
         lda  $C500,y              ; 9183
         sta  ENEMY_Y              ; 9186
         iny                       ; 9189
         lda  $C500,y              ; 918A
         sta  ENEMY_Y+1            ; 918D
         iny                       ; 9190
         lda  $C500,y              ; 9191
         sta  ENEMY_Y+2            ; 9194
         iny                       ; 9197
         lda  $C500,y              ; 9198
         sta  ENEMY_Y+3            ; 919B
         iny                       ; 919E
         lda  $C500,y              ; 919F
         sta  ENEMY_X              ; 91A2
         iny                       ; 91A5
         lda  $C500,y              ; 91A6
         sta  ENEMY_X+1            ; 91A9
         iny                       ; 91AC
         lda  $C500,y              ; 91AD
         sta  ENEMY_X+2            ; 91B0
         iny                       ; 91B3
         lda  $C500,y              ; 91B4
         sta  ENEMY_X+3            ; 91B7
         iny                       ; 91BA
         lda  $C500,y              ; 91BB
         sta  ENEMY_FRAME          ; 91BE
         iny                       ; 91C1
         lda  $C500,y              ; 91C2
         sta  ENEMY_FRAME+1        ; 91C5
         iny                       ; 91C8
         lda  $C500,y              ; 91C9
         sta  ENEMY_FRAME+2        ; 91CC
         iny                       ; 91CF
         lda  $C500,y              ; 91D0
         sta  ENEMY_FRAME+3        ; 91D3
         iny                       ; 91D6
         lda  $C500,y              ; 91D7
         sta  ENEMY_TYPE           ; 91DA
         iny                       ; 91DD
         lda  $C500,y              ; 91DE
         sta  ENEMY_TYPE+1         ; 91E1
         iny                       ; 91E4
         lda  $C500,y              ; 91E5
         sta  ENEMY_TYPE+2         ; 91E8
         iny                       ; 91EB
         lda  $C500,y              ; 91EC
         sta  ENEMY_TYPE+3         ; 91EF
         ldx  #$A4                 ; 91F2
         ldy  #$93                 ; 91F4
         jsr  SPR_INIT             ; 91F6
         lda  RTCLOK+2             ; 91F9
         sta  NEXT_TICK            ; 91FB
         inc  NEXT_TICK            ; 91FD
         lda  #$03                 ; 91FF
         sta  ENEMY_HITS           ; 9201
         sta  ENEMY_HITS+1         ; 9204
         sta  ENEMY_HITS+2         ; 9207
         sta  ENEMY_HITS+3         ; 920A
         lda  $53                  ; 920D
         bmi  L9214                ; 920F
         nop                       ; 9211
         nop                       ; 9212
         nop                       ; 9213
L9214
         rts                       ; 9214
