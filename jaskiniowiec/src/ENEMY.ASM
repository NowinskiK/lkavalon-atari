; ENEMY.ASM - enemies: movement and spawning
; $9027-$9214

         org $9027

sub_9027
         ldx  #$04                 ; 9027
L9029
         dex                       ; 9029
         bmi  L907D                ; 902A
         stx  $C1                  ; 902C
         lda  $93BF,x              ; 902E
         bne  L9039                ; 9031
         jsr  sub_909D             ; 9033
         jmp  L9055                ; 9036
L9039
         bpl  L9048                ; 9039
         lda  $DF                  ; 903B
         bmi  L9042                ; 903D
         jsr  sub_8820             ; 903F
L9042
         jsr  sub_9102             ; 9042
         jmp  L9055                ; 9045
L9048
         cmp  #$40                 ; 9048
         bne  L9052                ; 904A
         jsr  sub_912E             ; 904C
         jmp  L9055                ; 904F
L9052
         jsr  sub_90E5             ; 9052
L9055
         lda  $83                  ; 9055
         cmp  #$E0                 ; 9057
         bne  L9029                ; 9059
         ldx  $C1                  ; 905B
         lda  $93B4,x              ; 905D
         clc                       ; 9060
         adc  #$01                 ; 9061
         and  #$03                 ; 9063
         sta  $93B4,x              ; 9065
         tay                       ; 9068
         lda  $7C6C,x              ; 9069
         and  #$FC                 ; 906C
         sta  $7C6C,x              ; 906E
         lda  $93BB,y              ; 9071
         ora  $7C6C,x              ; 9074
         sta  $7C6C,x              ; 9077
         jmp  L9029                ; 907A
L907D
         jmp  L7C7B                ; 907D
         dta $8D,$0B,$03,$A9,$31,$8D,$00,$03,$A9,$07,$8D,$06,$03,$A9,$52,$8D ; 9080
         dta $02,$03,$A9,$80,$8D,$08,$03,$A9,$00,$8D,$09,$03,$60 ; 9090
sub_909D
         lda  $7C60,x              ; 909D
         sec                       ; 90A0
         sbc  $93B0,x              ; 90A1
         sta  $7C60,x              ; 90A4
         lda  $83                  ; 90A7
         cmp  #$E0                 ; 90A9
         beq  L90AE                ; 90AB
         rts                       ; 90AD
L90AE
         lda  $7C60,x              ; 90AE
         cmp  #$06                 ; 90B1
         beq  L90D2                ; 90B3
         cmp  #$A2                 ; 90B5
         bcs  L90D2                ; 90B7
         ldy  $7C64,x              ; 90B9
         jsr  sub_912F             ; 90BC
         jsr  sub_8DF0             ; 90BF
         and  #$01                 ; 90C2
         beq  L90D2                ; 90C4
         ldy  #$51                 ; 90C6
         lda  ($8B),y              ; 90C8
         jsr  sub_8DF0             ; 90CA
         and  #$01                 ; 90CD
         beq  L90D2                ; 90CF
         rts                       ; 90D1
L90D2
         ldx  $C1                  ; 90D2
         lda  $93B0,x              ; 90D4
         eor  #$FE                 ; 90D7
         sta  $93B0,x              ; 90D9
         lda  $7C68,x              ; 90DC
         eor  #$80                 ; 90DF
         sta  $7C68,x              ; 90E1
         rts                       ; 90E4
sub_90E5
         lda  $7C60,x              ; 90E5
         sec                       ; 90E8
         sbc  $93B0,x              ; 90E9
         sta  $7C60,x              ; 90EC
         lda  $83                  ; 90EF
         cmp  #$E0                 ; 90F1
         beq  L90F6                ; 90F3
         rts                       ; 90F5
L90F6
         lda  $7C60,x              ; 90F6
         cmp  #$02                 ; 90F9
         beq  L90D2                ; 90FB
         cmp  #$A8                 ; 90FD
         bcs  L90D2                ; 90FF
         rts                       ; 9101
sub_9102
         lda  $7C64,x              ; 9102
         sec                       ; 9105
         sbc  $93B0,x              ; 9106
         sta  $7C64,x              ; 9109
         lda  $83                  ; 910C
         cmp  #$E0                 ; 910E
         beq  L9113                ; 9110
         rts                       ; 9112
L9113
         lda  $7C64,x              ; 9113
         and  #$0F                 ; 9116
         beq  L9123                ; 9118
         cmp  #$02                 ; 911A
         bcc  L9123                ; 911C
         cmp  #$0E                 ; 911E
         bcs  L9123                ; 9120
         rts                       ; 9122
L9123
         ldx  $C1                  ; 9123
         lda  $93B0,x              ; 9125
         eor  #$FE                 ; 9128
         sta  $93B0,x              ; 912A
         rts                       ; 912D
sub_912E
         rts                       ; 912E
sub_912F
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
         sta  $8B                  ; 9143
         lda  $C5F0,x              ; 9145
         adc  $82                  ; 9148
         sta  $8C                  ; 914A
         ldy  #$50                 ; 914C
         lda  ($8B),y              ; 914E
         rts                       ; 9150
sub_9151
         ldx  #$03                 ; 9151
L9153
         ldy  #$80                 ; 9153
         lda  $93B0,x              ; 9155
         bmi  L915C                ; 9158
         ldy  #$00                 ; 915A
L915C
         tya                       ; 915C
         sta  $7C68,x              ; 915D
         dex                       ; 9160
         bpl  L9153                ; 9161
         lda  #$00                 ; 9163
         ldx  #$03                 ; 9165
L9167
         sta  $7C60,x              ; 9167
         sta  $7C64,x              ; 916A
         dex                       ; 916D
         bpl  L9167                ; 916E
         ldx  #$0C                 ; 9170
L9172
         lda  $A4FD,x              ; 9172
         cmp  $935A                ; 9175
         beq  L917D                ; 9178
         dex                       ; 917A
         bne  L9172                ; 917B
L917D
         ldy  $A50A,x              ; 917D
         sty  $97F4                ; 9180
         lda  $C500,y              ; 9183
         sta  $7C64                ; 9186
         iny                       ; 9189
         lda  $C500,y              ; 918A
         sta  $7C65                ; 918D
         iny                       ; 9190
         lda  $C500,y              ; 9191
         sta  $7C66                ; 9194
         iny                       ; 9197
         lda  $C500,y              ; 9198
         sta  $7C67                ; 919B
         iny                       ; 919E
         lda  $C500,y              ; 919F
         sta  $7C60                ; 91A2
         iny                       ; 91A5
         lda  $C500,y              ; 91A6
         sta  $7C61                ; 91A9
         iny                       ; 91AC
         lda  $C500,y              ; 91AD
         sta  $7C62                ; 91B0
         iny                       ; 91B3
         lda  $C500,y              ; 91B4
         sta  $7C63                ; 91B7
         iny                       ; 91BA
         lda  $C500,y              ; 91BB
         sta  $7C6C                ; 91BE
         iny                       ; 91C1
         lda  $C500,y              ; 91C2
         sta  $7C6D                ; 91C5
         iny                       ; 91C8
         lda  $C500,y              ; 91C9
         sta  $7C6E                ; 91CC
         iny                       ; 91CF
         lda  $C500,y              ; 91D0
         sta  $7C6F                ; 91D3
         iny                       ; 91D6
         lda  $C500,y              ; 91D7
         sta  $93BF                ; 91DA
         iny                       ; 91DD
         lda  $C500,y              ; 91DE
         sta  $93C0                ; 91E1
         iny                       ; 91E4
         lda  $C500,y              ; 91E5
         sta  $93C1                ; 91E8
         iny                       ; 91EB
         lda  $C500,y              ; 91EC
         sta  $93C2                ; 91EF
         ldx  #$A4                 ; 91F2
         ldy  #$93                 ; 91F4
         jsr  sub_7C03             ; 91F6
         lda  RTCLOK+2             ; 91F9
         sta  $8E                  ; 91FB
         inc  $8E                  ; 91FD
         lda  #$03                 ; 91FF
         sta  $93C3                ; 9201
         sta  $93C4                ; 9204
         sta  $93C5                ; 9207
         sta  $93C6                ; 920A
         lda  $53                  ; 920D
         bmi  L9214                ; 920F
         nop                       ; 9211
         nop                       ; 9212
         nop                       ; 9213
L9214
         rts                       ; 9214
