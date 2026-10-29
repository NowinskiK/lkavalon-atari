; MAIN.ASM - game entry ($8E67), NMI/IRQ/VBI handlers
; $8DF0-$9FFF

         org $8DF0

sub_8DF0
         and  #$7F                 ; 8DF0
         lsr                       ; 8DF2
         tax                       ; 8DF3
         lda  $7000,x              ; 8DF4
         rts                       ; 8DF7
sub_8DF8
         lda  $A6                  ; 8DF8
         lsr                       ; 8DFA
         sta  $C0                  ; 8DFB
         ldy  #$0F                 ; 8DFD
L8DFF
         lda  #$7E                 ; 8DFF
         cpy  $C0                  ; 8E01
         bcc  L8E07                ; 8E03
         lda  #$7F                 ; 8E05
L8E07
         sta  $A0DF,y              ; 8E07
         dey                       ; 8E0A
         bpl  L8DFF                ; 8E0B
         ldy  $C0                  ; 8E0D
         lda  $A6                  ; 8E0F
         and  #$01                 ; 8E11
         beq  L8E1A                ; 8E13
         lda  #$7D                 ; 8E15
         sta  $A0DF,y              ; 8E17
L8E1A
         lda  $A5                  ; 8E1A
         lsr                       ; 8E1C
         lsr                       ; 8E1D
         sta  $C0                  ; 8E1E
         ldy  #$17                 ; 8E20
L8E22
         lda  #$7E                 ; 8E22
         cpy  $C0                  ; 8E24
         bcc  L8E2A                ; 8E26
         lda  #$7F                 ; 8E28
L8E2A
         sta  $A107,y              ; 8E2A
         dey                       ; 8E2D
         bpl  L8E22                ; 8E2E
         ldy  $C0                  ; 8E30
         lda  $A5                  ; 8E32
         and  #$02                 ; 8E34
         beq  L8E3D                ; 8E36
         lda  #$7D                 ; 8E38
         sta  $A107,y              ; 8E3A
L8E3D
         lda  $A7                  ; 8E3D
         and  #$0F                 ; 8E3F
         clc                       ; 8E41
         adc  #$10                 ; 8E42
         cmp  #$1A                 ; 8E44
         bcc  L8E4A                ; 8E46
         adc  #$06                 ; 8E48
L8E4A
         sta  $A104                ; 8E4A
         rts                       ; 8E4D
         dta $A0,$7F,$B9,$00,$05,$D9,$00,$06,$F0,$0C,$88,$B9,$00,$05,$D9,$00 ; 8E4E
         dta $06,$F0,$03,$A9,$FF,$60,$A9,$00,$60      ; 8E5E
L8E67
         nop                       ; 8E67
         lda  #$00                 ; 8E68
         sta  $9EDF                ; 8E6A
         lda  #$00                 ; 8E6D
         sta  NMIEN                ; 8E6F
         lda  #$FE                 ; 8E72
         sta  PORTB                ; 8E74
         jsr  sub_9F7E             ; 8E77
         jsr  sub_927D             ; 8E7A
         jsr  entry_9E97           ; 8E7D
L8E80
         ldx  #$01                 ; 8E80
         lda  $9E49,x              ; 8E82
         sta  $7788                ; 8E85
         inx                       ; 8E88
         lda  $9E49,x              ; 8E89
         sta  $7879                ; 8E8C
         jsr  sub_92EC             ; 8E8F
         jsr  sub_9B55             ; 8E92
         jsr  sub_9A79             ; 8E95
         jsr  sub_8DF8             ; 8E98
         jsr  sub_9A00             ; 8E9B
         jsr  sub_8FC7             ; 8E9E
         lda  #$AB                 ; 8EA1
         sta  $89D0                ; 8EA3
         sta  $8A34                ; 8EA6
         lda  #$A0                 ; 8EA9
         sta  $89D1                ; 8EAB
         sta  $8A35                ; 8EAE
         jsr  sub_9744             ; 8EB1
         jsr  sub_9151             ; 8EB4
         lda  #$40                 ; 8EB7
         sta  $934D                ; 8EB9
         lda  RTCLOK+2             ; 8EBC
         clc                       ; 8EBE
         adc  #$02                 ; 8EBF
         sta  $8E                  ; 8EC1
L8EC3
         lda  #$00                 ; 8EC3
         sta  $4D                  ; 8EC5
         sta  CH                   ; 8EC7
L8ECA
         lda  RTCLOK+2             ; 8ECA
         cmp  $8E                  ; 8ECC
         bcc  L8ECA                ; 8ECE
         clc                       ; 8ED0
         adc  #$03                 ; 8ED1
         sta  $8E                  ; 8ED3
         jsr  sub_9027             ; 8ED5
         jsr  sub_8F08             ; 8ED8
         jsr  sub_948F             ; 8EDB
         jsr  sub_9796             ; 8EDE
         jsr  sub_8DF8             ; 8EE1
         jsr  sub_94F7             ; 8EE4
         jsr  sub_9D6D             ; 8EE7
         lda  $A7                  ; 8EEA
         beq  L8F02                ; 8EEC
         lda  $934D                ; 8EEE
         cmp  #$9C                 ; 8EF1
         bcc  L8EF8                ; 8EF3
         jmp  L8F4C                ; 8EF5
L8EF8
         cmp  #$04                 ; 8EF8
         bcs  L8EFF                ; 8EFA
         jmp  L8F82                ; 8EFC
L8EFF
         jmp  L8EC3                ; 8EFF
L8F02
         jsr  sub_9B8F             ; 8F02
         jmp  L8E80                ; 8F05
sub_8F08
         lda  $A9                  ; 8F08
         beq  L8F0D                ; 8F0A
         rts                       ; 8F0C
L8F0D
         lda  $9354                ; 8F0D
         cmp  #$01                 ; 8F10
         bne  L8F24                ; 8F12
         lda  $9355                ; 8F14
         cmp  #$02                 ; 8F17
         bne  L8F24                ; 8F19
         lda  #$22                 ; 8F1B
         ldx  #$05                 ; 8F1D
         ldy  #$17                 ; 8F1F
         jmp  entry_F2E4           ; 8F21
L8F24
         lda  $9359                ; 8F24
         cmp  #$0D                 ; 8F27
         bne  L8F34                ; 8F29
         lda  #$22                 ; 8F2B
         ldx  #$05                 ; 8F2D
         ldy  #$18                 ; 8F2F
         jmp  entry_F2E4           ; 8F31
L8F34
         lda  $9351                ; 8F34
         cmp  #$02                 ; 8F37
         beq  L8F42                ; 8F39
         lda  $9351                ; 8F3B
         cmp  #$03                 ; 8F3E
         bne  L8F4B                ; 8F40
L8F42
         lda  #$22                 ; 8F42
         ldx  #$18                 ; 8F44
         ldy  #$13                 ; 8F46
         jmp  entry_F2E4           ; 8F48
L8F4B
         rts                       ; 8F4B
L8F4C
         inc  $934D                ; 8F4C
         inc  $934D                ; 8F4F
         lda  #$13                 ; 8F52
         sta  $8D                  ; 8F54
L8F56
         inc  $935A                ; 8F56
         lda  $934D                ; 8F59
         sec                       ; 8F5C
         sbc  #$08                 ; 8F5D
         sta  $934D                ; 8F5F
         jsr  sub_8FB8             ; 8F62
         jsr  sub_8FC7             ; 8F65
         dec  $8D                  ; 8F68
         bne  L8F56                ; 8F6A
         inc  $8D                  ; 8F6C
         lda  $934D                ; 8F6E
         sta  $934F                ; 8F71
         lda  $934E                ; 8F74
         sbc  #$20                 ; 8F77
         sta  $9350                ; 8F79
         jsr  sub_9151             ; 8F7C
         jmp  L8EC3                ; 8F7F
L8F82
         dec  $934D                ; 8F82
         dec  $934D                ; 8F85
         lda  #$13                 ; 8F88
         sta  $8D                  ; 8F8A
L8F8C
         dec  $935A                ; 8F8C
         lda  $934D                ; 8F8F
         clc                       ; 8F92
         adc  #$08                 ; 8F93
         sta  $934D                ; 8F95
         jsr  sub_8FB8             ; 8F98
         jsr  sub_8FC7             ; 8F9B
         dec  $8D                  ; 8F9E
         bne  L8F8C                ; 8FA0
         inc  $8D                  ; 8FA2
         lda  $934D                ; 8FA4
         sta  $934F                ; 8FA7
         lda  $934E                ; 8FAA
         sbc  #$20                 ; 8FAD
         sta  $9350                ; 8FAF
         jsr  sub_9151             ; 8FB2
         jmp  L8EC3                ; 8FB5
sub_8FB8
         lda  RTCLOK+2             ; 8FB8
L8FBA
         cmp  RTCLOK+2             ; 8FBA
         beq  L8FBA                ; 8FBC
         rts                       ; 8FBE
sub_8FBF
         lda  #$80                 ; 8FBF
L8FC1
         cmp  VCOUNT               ; 8FC1
         bne  L8FC1                ; 8FC4
         rts                       ; 8FC6
sub_8FC7
         lda  $935A                ; 8FC7
         clc                       ; 8FCA
         adc  #$00                 ; 8FCB
         sta  $C0                  ; 8FCD
         lda  #$30                 ; 8FCF
         sta  $C1                  ; 8FD1
         lda  #$00                 ; 8FD3
         sta  $8FFD                ; 8FD5
         sta  $9000                ; 8FD8
         sta  $9007                ; 8FDB
         sta  $900A                ; 8FDE
         lda  #$BC                 ; 8FE1
         sta  $8FFE                ; 8FE3
         sta  $9008                ; 8FE6
         lda  #$BE                 ; 8FE9
         sta  $9001                ; 8FEB
         sta  $900B                ; 8FEE
         lda  #$0A                 ; 8FF1
         sta  $E6                  ; 8FF3
         ldx  #$00                 ; 8FF5
L8FF7
         ldy  #$00                 ; 8FF7
L8FF9
         lda  ($C0),y              ; 8FF9
         asl                       ; 8FFB
         sta  LBC00,x              ; 8FFC
         sta  $BE00,x              ; 8FFF
         inx                       ; 9002
         clc                       ; 9003
         adc  #$01                 ; 9004
         sta  LBC00,x              ; 9006
         sta  $BE00,x              ; 9009
         inx                       ; 900C
         bne  L901B                ; 900D
         inc  $8FFE                ; 900F
         inc  $9001                ; 9012
         inc  $9008                ; 9015
         inc  $900B                ; 9018
L901B
         iny                       ; 901B
         cpy  #$14                 ; 901C
         bne  L8FF9                ; 901E
         inc  $C1                  ; 9020
         dec  $E6                  ; 9022
         bne  L8FF7                ; 9024
         rts                       ; 9026
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
sub_9215
         lda  #$10                 ; 9215
         jsr  entry_F2E4           ; 9217
         lda  #$00                 ; 921A
         ldx  #$18                 ; 921C
         jmp  L924E                ; 921E
L9221
         lda  #$00                 ; 9221
         ldx  #$01                 ; 9223
         jsr  entry_F2E4           ; 9225
         lda  #$00                 ; 9228
         jsr  sub_8A64             ; 922A
         lda  #$00                 ; 922D
         jsr  sub_8A64             ; 922F
         lda  #$00                 ; 9232
         ldx  #$08                 ; 9234
         jmp  L924E                ; 9236
L9239
         lda  #$00                 ; 9239
         ldx  #$01                 ; 923B
         jsr  entry_F2E4           ; 923D
         lda  #$00                 ; 9240
         jsr  sub_8A64             ; 9242
         lda  #$00                 ; 9245
         jsr  sub_8A64             ; 9247
         lda  #$00                 ; 924A
         ldx  #$10                 ; 924C
L924E
         sta  $C8                  ; 924E
         stx  $C9                  ; 9250
         lda  #$00                 ; 9252
         ldx  #$D8                 ; 9254
         sta  $CA                  ; 9256
         stx  $CB                  ; 9258
         lda  #$00                 ; 925A
         ldx  #$E0                 ; 925C
         sta  $CE                  ; 925E
         stx  $CF                  ; 9260
         ldx  #$08                 ; 9262
         ldy  #$00                 ; 9264
L9266
         lda  ($C8),y              ; 9266
         sta  ($CA),y              ; 9268
         sta  ($CE),y              ; 926A
         iny                       ; 926C
         bne  L9266                ; 926D
         inc  $C9                  ; 926F
         inc  $CB                  ; 9271
         inc  $CF                  ; 9273
         dex                       ; 9275
         bne  L9266                ; 9276
         lda  #$D8                 ; 9278
         sta  $83                  ; 927A
         rts                       ; 927C
sub_927D
         jsr  sub_8FBF             ; 927D
         ldy  #$00                 ; 9280
         ldx  #$00                 ; 9282
L9284
         lda  $929B,x              ; 9284
         sta  $C0                  ; 9287
         inx                       ; 9289
         lda  $929B,x              ; 928A
         sta  $C1                  ; 928D
         inx                       ; 928F
         lda  $929B,x              ; 9290
         sta  ($C0),y              ; 9293
         inx                       ; 9295
         cpx  #$51                 ; 9296
         bne  L9284                ; 9298
         rts                       ; 929A
         dta $A9,$00,$01,$A4,$00,$00,$00,$02,$74,$01,$02,$88,$30,$02,$74,$31 ; 929B
         dta $02,$89,$24,$02,$8F,$25,$02,$8A,$83,$00,$D8,$C0,$02,$06,$C2,$02 ; 92AB
         dta $06,$C1,$02,$E8,$C3,$02,$E8,$C4,$02,$10,$C5,$02,$24,$C6,$02,$3A ; 92BB
         dta $C8,$02,$76,$2F,$02,$3E,$6F,$02,$21,$07,$D4,$C8,$1D,$D0,$03,$87 ; 92CB
         dta $00,$B6,$88,$00,$F4,$89,$00,$FA,$8A,$00,$8C,$86,$00,$76,$00,$D2 ; 92DB
         dta $C0                                      ; 92EB
sub_92EC
         jsr  sub_8FB8             ; 92EC
         ldy  #$00                 ; 92EF
         ldx  #$00                 ; 92F1
L92F3
         lda  $930A,x              ; 92F3
         sta  $C0                  ; 92F6
         inx                       ; 92F8
         lda  $930A,x              ; 92F9
         sta  $C1                  ; 92FC
         inx                       ; 92FE
         lda  $930A,x              ; 92FF
         sta  ($C0),y              ; 9302
         inx                       ; 9304
         cpx  #$3F                 ; 9305
         bne  L92F3                ; 9307
         rts                       ; 9309
         dta $8D,$00,$01,$8F,$00,$00,$4D,$93,$B6,$4E,$93,$70,$4F,$93,$40,$50 ; 930A
         dta $93,$70,$51,$93,$00,$52,$93,$00,$54,$93,$00,$55,$93,$00,$56,$93 ; 931A
         dta $00,$57,$93,$00,$58,$93,$00,$59,$93,$00,$5A,$93,$00,$5B,$93,$00 ; 932A
         dta $A5,$00,$60,$A6,$00,$00,$5C,$93,$01,$A7,$00,$03,$67,$9F,$00,$00 ; 933A
         dta $00,$00,$00,$B6,$70,$40,$70,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 934A
         dta $00,$00,$00,$76,$74,$76,$74,$74,$74,$74,$74,$72,$74,$72,$72,$00 ; 935A
         dta $72,$00,$00,$94,$72,$94,$74,$86,$74,$86,$86,$86,$86,$74,$72,$00 ; 936A
         dta $01,$02,$01,$00,$04,$03,$04,$05,$07,$06,$07,$08,$09,$09,$0A,$0A ; 937A
         dta $0B,$0C,$0D,$00,$00,$00,$00,$00,$00,$00,$00,$00,$FE,$FD,$FD,$FD ; 938A
         dta $FE,$FE,$FE,$FF,$FF,$00,$01,$01,$02,$02,$D8,$E0,$BC,$BE,$74,$89 ; 939A
         dta $D8,$89,$80,$80,$00,$00,$FF,$FF,$01,$01,$00,$01,$02,$03,$00,$01 ; 93AA
         dta $02,$00,$01,$02,$03,$00,$00,$00,$00,$00,$00,$00,$00,$A2,$00,$8A ; 93BA
         dta $A0,$07,$0A,$7E,$00,$C0,$88,$10,$F9,$E8,$D0,$F3,$A2,$00,$8A,$A0 ; 93CA
         dta $03,$0A,$26,$C0,$0A,$7E,$00,$C1,$46,$C0,$7E,$00,$C1,$88,$10,$F1 ; 93DA
         dta $E8,$D0,$EB,$A2,$00,$8A,$85,$C0,$0A,$05,$C0,$29,$AA,$85,$C0,$4A ; 93EA
         dta $05,$C0,$49,$FF,$9D,$00,$C2,$E8,$D0,$EB,$A2,$00,$8A,$A0,$00,$84 ; 93FA
         dta $C0,$0A,$0A,$26,$C0,$0A,$26,$C0,$9D,$00,$C3,$A5,$C0,$9D,$80,$C3 ; 940A
         dta $E8,$10,$E9,$A2,$00,$8A,$38,$E9,$2A,$8D,$E0,$C5,$8A,$E9,$00,$8D ; 941A
         dta $F0,$C5,$18,$BD,$E0,$C5,$69,$28,$9D,$E1,$C5,$BD,$F0,$C5,$69,$00 ; 942A
         dta $9D,$F1,$C5,$E8,$E0,$0D,$90,$EA,$A9,$00,$A2,$20,$85,$C0,$86,$C1 ; 943A
         dta $A2,$00,$A5,$C0,$9D,$00,$C8,$A5,$C1,$9D,$40,$C8,$A5,$C0,$18,$69 ; 944A
         dta $20,$85,$C0,$A5,$C1,$69,$00,$85,$C1,$E8,$E0,$40,$D0,$E4,$A9,$FF ; 945A
         dta $A2,$27,$85,$C0,$86,$C1,$A2,$00,$A5,$C0,$9D,$50,$C6,$A5,$C1,$9D ; 946A
         dta $70,$C6,$A5,$C0,$18,$69,$20,$85,$C0,$A5,$C1,$69,$00,$85,$C1,$E8 ; 947A
         dta $E0,$20,$D0,$E4,$60                      ; 948A
sub_948F
         lda  $934E                ; 948F
         clc                       ; 9492
         adc  #$04                 ; 9493
         tay                       ; 9495
         lda  $934D                ; 9496
         clc                       ; 9499
         adc  #$04                 ; 949A
         jsr  sub_912F             ; 949C
         jsr  sub_8DF0             ; 949F
         sta  $9356                ; 94A2
         ldy  #$51                 ; 94A5
         lda  ($8B),y              ; 94A7
         jsr  sub_8DF0             ; 94A9
         ora  $9356                ; 94AC
         sta  $9356                ; 94AF
         ldy  #$28                 ; 94B2
         lda  ($8B),y              ; 94B4
         jsr  sub_8DF0             ; 94B6
         sta  $9357                ; 94B9
         ldy  #$29                 ; 94BC
         lda  ($8B),y              ; 94BE
         jsr  sub_8DF0             ; 94C0
         ora  $9357                ; 94C3
         sta  $9357                ; 94C6
         ldy  $934E                ; 94C9
         lda  $934D                ; 94CC
         clc                       ; 94CF
         adc  #$01                 ; 94D0
         and  #$04                 ; 94D2
         beq  L94EF                ; 94D4
         lda  $934D                ; 94D6
         clc                       ; 94D9
         adc  #$04                 ; 94DA
         jsr  sub_912F             ; 94DC
         jsr  sub_8DF0             ; 94DF
         sta  $9358                ; 94E2
         ldy  #$51                 ; 94E5
         lda  ($8B),y              ; 94E7
         jsr  sub_8DF0             ; 94E9
         ora  $9358                ; 94EC
L94EF
         sta  $9358                ; 94EF
         lda  #$00                 ; 94F2
         sta  $8D                  ; 94F4
         rts                       ; 94F6
sub_94F7
         lda  $8F                  ; 94F7
         bne  L94FC                ; 94F9
         rts                       ; 94FB
L94FC
         lda  $934D                ; 94FC
         sta  $959B                ; 94FF
         lda  $934E                ; 9502
         sta  $9593                ; 9505
         lda  #$C0                 ; 9508
         sta  $934D                ; 950A
         lda  #$6E                 ; 950D
         sta  $934E                ; 950F
         jsr  sub_96C8             ; 9512
         jsr  sub_8A4D             ; 9515
         jsr  sub_95D5             ; 9518
         jsr  sub_9615             ; 951B
         jsr  sub_9837             ; 951E
         jsr  sub_9699             ; 9521
         jsr  sub_9729             ; 9524
         lda  #$08                 ; 9527
         sta  $934D                ; 9529
         lda  #$70                 ; 952C
         sta  $934E                ; 952E
         ldx  RTCLOK+2             ; 9531
         inx                       ; 9533
         stx  $8E                  ; 9534
L9536
         lda  #$00                 ; 9536
         sta  $4D                  ; 9538
         sta  CH                   ; 953A
L953D
         lda  RTCLOK+2             ; 953D
         cmp  $8E                  ; 953F
         bcc  L953D                ; 9541
         clc                       ; 9543
         adc  #$03                 ; 9544
         sta  $8E                  ; 9546
         jsr  sub_9027             ; 9548
         jsr  sub_8F08             ; 954B
         jsr  sub_948F             ; 954E
         jsr  sub_9796             ; 9551
         jsr  sub_8DF8             ; 9554
         jsr  sub_99E4             ; 9557
         lda  $A7                  ; 955A
         beq  L95AD                ; 955C
         lda  $934D                ; 955E
         cmp  #$05                 ; 9561
         bcc  L9569                ; 9563
         cmp  #$98                 ; 9565
         bcc  L9536                ; 9567
L9569
         lda  #$60                 ; 9569
         sta  $934E                ; 956B
         lda  #$C0                 ; 956E
         sta  $934D                ; 9570
         jsr  sub_96C8             ; 9573
         jsr  sub_8A4D             ; 9576
         jsr  sub_8FC7             ; 9579
         jsr  sub_9744             ; 957C
         dec  $9593                ; 957F
         dec  $9593                ; 9582
         lda  #$00                 ; 9585
         sta  $9354                ; 9587
         sta  $9355                ; 958A
         lda  #$01                 ; 958D
         sta  $9356                ; 958F
         ldy  #$00                 ; 9592
         sty  $934E                ; 9594
         jsr  sub_8A4D             ; 9597
         ldx  #$00                 ; 959A
         stx  $934D                ; 959C
         lda  #$00                 ; 959F
         sta  $8F                  ; 95A1
         lda  RTCLOK+2             ; 95A3
         clc                       ; 95A5
         adc  #$04                 ; 95A6
         sta  $8E                  ; 95A8
         jmp  sub_9151             ; 95AA
L95AD
         pla                       ; 95AD
         pla                       ; 95AE
         jmp  L8F02                ; 95AF
         dta $A9,$00,$85,$D0,$A9,$05,$85,$D1,$D0,$08,$A9,$00,$85,$D0,$A9,$06 ; 95B2
         dta $85,$D1,$A9,$00,$20,$80,$90,$A9,$C8,$20,$9D,$7D,$98,$30,$03,$4C ; 95C2
         dta $ED,$7E,$60                              ; 95D2
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
sub_9615
         lda  #$00                 ; 9615
         ldx  #$03                 ; 9617
L9619
         sta  $7C60,x              ; 9619
         sta  $7C64,x              ; 961C
         sta  $93BF,x              ; 961F
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
         cmp  $935A                ; 9631
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
sub_9699
         ldy  #$00                 ; 9699
         ldx  #$00                 ; 969B
L969D
         lda  ($C0),y              ; 969D
         beq  L96BA                ; 969F
         sta  $7C6C,x              ; 96A1
         iny                       ; 96A4
         lda  ($C0),y              ; 96A5
         sta  $7C60,x              ; 96A7
         iny                       ; 96AA
         lda  ($C0),y              ; 96AB
         sta  $7C64,x              ; 96AD
         iny                       ; 96B0
         lda  ($C0),y              ; 96B1
         sta  $93BF,x              ; 96B3
         iny                       ; 96B6
         inx                       ; 96B7
         bne  L969D                ; 96B8
L96BA
         ldx  #$A4                 ; 96BA
         ldy  #$93                 ; 96BC
         jsr  sub_7C03             ; 96BE
         lda  RTCLOK+2             ; 96C1
         sta  $8E                  ; 96C3
         inc  $8E                  ; 96C5
         rts                       ; 96C7
sub_96C8
         ldy  #$07                 ; 96C8
L96CA
         jsr  sub_8FB8             ; 96CA
         jsr  sub_96EB             ; 96CD
         dey                       ; 96D0
         bne  L96CA                ; 96D1
         lda  #$00                 ; 96D3
         tay                       ; 96D5
L96D6
         sta  LBC00,y              ; 96D6
         sta  $BE00,y              ; 96D9
         iny                       ; 96DC
         bpl  L96D6                ; 96DD
         ldy  #$07                 ; 96DF
L96E1
         jsr  sub_8FB8             ; 96E1
         jsr  sub_96EB             ; 96E4
         dey                       ; 96E7
         bne  L96E1                ; 96E8
         rts                       ; 96EA
sub_96EB
         ldx  #$01                 ; 96EB
         dec  $87                  ; 96ED
         lda  $87                  ; 96EF
         and  #$0F                 ; 96F1
         bne  L96F7                ; 96F3
         stx  $87                  ; 96F5
L96F7
         dec  $88                  ; 96F7
         lda  $88                  ; 96F9
         and  #$0F                 ; 96FB
         bne  L9701                ; 96FD
         stx  $88                  ; 96FF
L9701
         dec  $89                  ; 9701
         lda  $89                  ; 9703
         and  #$0F                 ; 9705
         bne  L970B                ; 9707
         stx  $89                  ; 9709
L970B
         dec  $8A                  ; 970B
         lda  $8A                  ; 970D
         and  #$0F                 ; 970F
         bne  L9715                ; 9711
         stx  $8A                  ; 9713
L9715
         rts                       ; 9715
         dta $A9,$FF,$8D,$01,$D3,$A9,$00,$8D,$00,$D4,$8D,$0E,$D4,$8D,$2F,$02 ; 9716
         dta $4C,$77,$E4                              ; 9726
sub_9729
         lda  $9349                ; 9729
         and  #$F0                 ; 972C
         sta  $87                  ; 972E
         lda  $934A                ; 9730
         and  #$F0                 ; 9733
         sta  $88                  ; 9735
         lda  $934B                ; 9737
         and  #$F0                 ; 973A
         sta  $89                  ; 973C
         lda  #$20                 ; 973E
         sta  $8A                  ; 9740
         bne  L9760                ; 9742
sub_9744
         lda  $9349                ; 9744
         and  #$F0                 ; 9747
         sta  $87                  ; 9749
         lda  $934A                ; 974B
         and  #$F0                 ; 974E
         sta  $88                  ; 9750
         lda  $934B                ; 9752
         and  #$F0                 ; 9755
         sta  $89                  ; 9757
         lda  $934C                ; 9759
         and  #$F0                 ; 975C
         sta  $8A                  ; 975E
L9760
         ldy  #$0F                 ; 9760
L9762
         jsr  sub_8FB8             ; 9762
         lda  $87                  ; 9765
         cmp  $9349                ; 9767
         beq  L976E                ; 976A
         inc  $87                  ; 976C
L976E
         lda  $88                  ; 976E
         cmp  $934A                ; 9770
         beq  L9777                ; 9773
         inc  $88                  ; 9775
L9777
         lda  $89                  ; 9777
         cmp  $934B                ; 9779
         beq  L9780                ; 977C
         inc  $89                  ; 977E
L9780
         lda  $8A                  ; 9780
         and  #$0F                 ; 9782
         sta  $978D                ; 9784
         lda  $934C                ; 9787
         and  #$0F                 ; 978A
         cmp  #$00                 ; 978C
         beq  L9792                ; 978E
         inc  $8A                  ; 9790
L9792
         dey                       ; 9792
         bne  L9762                ; 9793
         rts                       ; 9795
sub_9796
         lda  $9357                ; 9796
         and  #$08                 ; 9799
         beq  L97A6                ; 979B
         lda  $80                  ; 979D
         and  #$01                 ; 979F
         bne  L97A6                ; 97A1
         jsr  sub_9802             ; 97A3
L97A6
         ldx  #$03                 ; 97A6
L97A8
         lda  $7C60,x              ; 97A8
         sec                       ; 97AB
         sbc  #$0B                 ; 97AC
         cmp  $934D                ; 97AE
         bcs  L97D4                ; 97B1
         adc  #$0D                 ; 97B3
         cmp  $934D                ; 97B5
         bcc  L97D4                ; 97B8
         lda  $7C64,x              ; 97BA
         sec                       ; 97BD
         sbc  #$18                 ; 97BE
         cmp  $934E                ; 97C0
         bcs  L97D4                ; 97C3
         adc  #$20                 ; 97C5
         cmp  $934E                ; 97C7
         bcc  L97D4                ; 97CA
         lda  $9359                ; 97CC
         bne  L97D8                ; 97CF
         jsr  sub_9802             ; 97D1
L97D4
         dex                       ; 97D4
         bpl  L97A8                ; 97D5
         rts                       ; 97D7
L97D8
         lda  $7C6C,x              ; 97D8
         and  #$10                 ; 97DB
         bne  L97D4                ; 97DD
         lda  $93C3,x              ; 97DF
         beq  L97EB                ; 97E2
         dec  $93C3,x              ; 97E4
         dex                       ; 97E7
         bpl  L97A8                ; 97E8
         rts                       ; 97EA
L97EB
         lda  #$00                 ; 97EB
         sta  $7C64,x              ; 97ED
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
sub_9802
         stx  $9813                ; 9802
         lda  $A9                  ; 9805
         bne  L9812                ; 9807
         lda  #$21                 ; 9809
         ldx  #$0C                 ; 980B
         ldy  #$16                 ; 980D
         jsr  entry_F2E4           ; 980F
L9812
         ldx  #$00                 ; 9812
         dec  $A5                  ; 9814
         lda  $A5                  ; 9816
         beq  L981B                ; 9818
         rts                       ; 981A
L981B
         stx  $982C                ; 981B
         lda  $A9                  ; 981E
         bne  L982B                ; 9820
         lda  #$21                 ; 9822
         ldx  #$18                 ; 9824
         ldy  #$14                 ; 9826
         jsr  entry_F2E4           ; 9828
L982B
         ldx  #$00                 ; 982B
         dec  $A7                  ; 982D
         lda  #$60                 ; 982F
         sta  $A5                  ; 9831
         rts                       ; 9833
         dta $00,$00,$00                              ; 9834
sub_9837
         lda  $9834                ; 9837
         asl                       ; 983A
         asl                       ; 983B
         tay                       ; 983C
         jsr  sub_9883             ; 983D
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
         jsr  sub_9883             ; 985E
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
sub_9883
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
         jsr  sub_99D5             ; 98DA
         sty  $D0                  ; 98DD
         sta  $D1                  ; 98DF
         ldy  #$01                 ; 98E1
         jsr  sub_99D5             ; 98E3
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
         jsr  sub_99D5             ; 990E
         sty  $C8                  ; 9911
         sty  $D4                  ; 9913
         sta  $C9                  ; 9915
         txa                       ; 9917
         ora  #$E0                 ; 9918
         sta  $D5                  ; 991A
         ldy  #$01                 ; 991C
         jsr  sub_99D5             ; 991E
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
         jsr  sub_7F92             ; 9964
L9967
         cpy  #$10                 ; 9967
         bcs  L996E                ; 9969
         jmp  L993D                ; 996B
L996E
         rts                       ; 996E
sub_996F
         lda  $934E                ; 996F
         clc                       ; 9972
         adc  #$04                 ; 9973
         tay                       ; 9975
         lda  $934D                ; 9976
         clc                       ; 9979
         adc  #$02                 ; 997A
         jsr  sub_912F             ; 997C
         ldy  #$00                 ; 997F
         ldx  $9836                ; 9981
         lda  $8B                  ; 9984
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
         jsr  sub_99B4             ; 99AF
         ora  #$01                 ; 99B2
sub_99B4
         sta  sub_99B4,y           ; 99B4
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
         jsr  sub_99CD             ; 99C8
         ora  #$01                 ; 99CB
sub_99CD
         sta  sub_99CD,y           ; 99CD
         sta  $99D0,y              ; 99D0
         iny                       ; 99D3
         rts                       ; 99D4
sub_99D5
         lda  ($C2),y              ; 99D5
         dta $AB,$7F,$BD,$00,$C3,$A8,$BD,$80,$C3,$AA,$09,$D8,$60 ; 99D7
sub_99E4
         lda  $9357                ; 99E4
         and  #$20                 ; 99E7
         beq  L99FF                ; 99E9
         jsr  sub_996F             ; 99EB
         beq  L99FF                ; 99EE
         inc  $A6                  ; 99F0
         lda  $A9                  ; 99F2
         bne  L99FF                ; 99F4
         lda  #$21                 ; 99F6
         ldx  #$24                 ; 99F8
         ldy  #$15                 ; 99FA
         jsr  entry_F2E4           ; 99FC
L99FF
         rts                       ; 99FF
sub_9A00
         ldy  #$00                 ; 9A00
L9A02
         lda  $A517,y              ; 9A02
         sta  $C500,y              ; 9A05
         iny                       ; 9A08
         cpy  #$D0                 ; 9A09
         bne  L9A02                ; 9A0B
         lda  #$00                 ; 9A0D
L9A0F
         sta  $C500,y              ; 9A0F
         iny                       ; 9A12
         cpy  #$E0                 ; 9A13
         bne  L9A0F                ; 9A15
         ldy  #$40                 ; 9A17
L9A19
         lda  $A9F7,y              ; 9A19
         sta  $C600,y              ; 9A1C
         dey                       ; 9A1F
         bpl  L9A19                ; 9A20
         lda  #$00                 ; 9A22
         ldx  #$30                 ; 9A24
         bne  L9A5A                ; 9A26
sub_9A28
         ldy  #$00                 ; 9A28
L9A2A
         lda  $A5E7,y              ; 9A2A
         sta  $C500,y              ; 9A2D
         iny                       ; 9A30
         cpy  #$D0                 ; 9A31
         bne  L9A2A                ; 9A33
         lda  #$00                 ; 9A35
L9A37
         sta  $C500,y              ; 9A37
         iny                       ; 9A3A
         cpy  #$E0                 ; 9A3B
         bne  L9A37                ; 9A3D
         lda  $D20D                ; 9A3F
         cmp  #$80                 ; 9A42
         beq  L9A49                ; 9A44
         nop                       ; 9A46
         nop                       ; 9A47
         nop                       ; 9A48
L9A49
         ldy  #$EA                 ; 9A49
L9A4B
         nop                       ; 9A4B
         nop                       ; 9A4C
         tax                       ; 9A4D
         sta  $C600,y              ; 9A4E
         dey                       ; 9A51
         bpl  L9A4B                ; 9A52
         lda  #$00                 ; 9A54
         ldx  #$3A                 ; 9A56
         bne  L9A5A                ; 9A58
L9A5A
         sta  $8FCC                ; 9A5A
         stx  $8FD0                ; 9A5D
         lda  #$00                 ; 9A60
         ldx  #$70                 ; 9A62
         sta  $8DF5                ; 9A64
         stx  $8DF6                ; 9A67
         jsr  sub_9A79             ; 9A6A
         lda  $9F                  ; 9A6D
         cmp  #$01                 ; 9A6F
         beq  L9A76                ; 9A71
         jsr  sub_7E1C             ; 9A73
L9A76
         jmp  L9221                ; 9A76
sub_9A79
         lda  #$B6                 ; 9A79
         sta  $9349                ; 9A7B
         lda  #$F4                 ; 9A7E
         sta  $934A                ; 9A80
         lda  #$FA                 ; 9A83
         sta  $934B                ; 9A85
         lda  #$8C                 ; 9A88
         sta  $934C                ; 9A8A
         rts                       ; 9A8D
sub_9A8E
         ldy  #$00                 ; 9A8E
L9A90
         lda  $A6B7,y              ; 9A90
         sta  $C500,y              ; 9A93
         iny                       ; 9A96
         cpy  #$D0                 ; 9A97
         bne  L9A90                ; 9A99
         lda  #$00                 ; 9A9B
L9A9D
         sta  $C500,y              ; 9A9D
         iny                       ; 9AA0
         cpy  #$E0                 ; 9AA1
         bne  L9A9D                ; 9AA3
         ldy  #$40                 ; 9AA5
L9AA7
         lda  $AA79,y              ; 9AA7
         sta  $C600,y              ; 9AAA
         dey                       ; 9AAD
         bpl  L9AA7                ; 9AAE
         lda  #$00                 ; 9AB0
         ldx  #$44                 ; 9AB2
         bne  L9A5A                ; 9AB4
sub_9AB6
         ldy  #$00                 ; 9AB6
L9AB8
         lda  $A787,y              ; 9AB8
         sta  $C500,y              ; 9ABB
         iny                       ; 9ABE
         cpy  #$D0                 ; 9ABF
         bne  L9AB8                ; 9AC1
         lda  #$00                 ; 9AC3
L9AC5
         sta  $C500,y              ; 9AC5
         iny                       ; 9AC8
         cpy  #$E0                 ; 9AC9
         bne  L9AC5                ; 9ACB
         ldy  #$40                 ; 9ACD
L9ACF
         lda  $AABA,y              ; 9ACF
         sta  $C600,y              ; 9AD2
         dey                       ; 9AD5
         bpl  L9ACF                ; 9AD6
         lda  #$00                 ; 9AD8
         ldx  #$4E                 ; 9ADA
         bne  L9B06                ; 9ADC
sub_9ADE
         ldy  #$00                 ; 9ADE
L9AE0
         lda  $A857,y              ; 9AE0
         sta  $C500,y              ; 9AE3
         iny                       ; 9AE6
         cpy  #$D0                 ; 9AE7
         bne  L9AE0                ; 9AE9
         lda  #$00                 ; 9AEB
L9AED
         sta  $C500,y              ; 9AED
         iny                       ; 9AF0
         cpy  #$E0                 ; 9AF1
         bne  L9AED                ; 9AF3
         ldy  #$40                 ; 9AF5
L9AF7
         lda  $AAFB,y              ; 9AF7
         sta  $C600,y              ; 9AFA
         dey                       ; 9AFD
         bpl  L9AF7                ; 9AFE
         lda  #$00                 ; 9B00
         ldx  #$58                 ; 9B02
         bne  L9B06                ; 9B04
L9B06
         sta  $8FCC                ; 9B06
         stx  $8FD0                ; 9B09
         lda  #$80                 ; 9B0C
         ldx  #$70                 ; 9B0E
         sta  $8DF5                ; 9B10
         stx  $8DF6                ; 9B13
         lda  #$76                 ; 9B16
         sta  $9349                ; 9B18
         lda  #$F4                 ; 9B1B
         sta  $934A                ; 9B1D
         lda  #$0C                 ; 9B20
         sta  $934B                ; 9B22
         lda  #$7E                 ; 9B25
         sta  $934C                ; 9B27
         jmp  L9239                ; 9B2A
sub_9B2D
         ldy  #$00                 ; 9B2D
L9B2F
         lda  $A927,y              ; 9B2F
         sta  $C500,y              ; 9B32
         iny                       ; 9B35
         cpy  #$D0                 ; 9B36
         bne  L9B2F                ; 9B38
         lda  #$00                 ; 9B3A
L9B3C
         sta  $C500,y              ; 9B3C
         iny                       ; 9B3F
         cpy  #$E0                 ; 9B40
         bne  L9B3C                ; 9B42
         ldy  #$40                 ; 9B44
L9B46
         lda  $AB3C,y              ; 9B46
         sta  $C600,y              ; 9B49
         dey                       ; 9B4C
         bpl  L9B46                ; 9B4D
         lda  #$00                 ; 9B4F
         ldx  #$62                 ; 9B51
         bne  L9B06                ; 9B53
sub_9B55
         jsr  sub_96C8             ; 9B55
         lda  #$B6                 ; 9B58
         sta  $8D                  ; 9B5A
         sta  $934D                ; 9B5C
         lda  #$70                 ; 9B5F
         sta  $934E                ; 9B61
         jsr  sub_8A4D             ; 9B64
         ldx  #$00                 ; 9B67
         jsr  sub_9215             ; 9B69
         lda  #$00                 ; 9B6C
         jsr  sub_9C5A             ; 9B6E
         rts                       ; 9B71
sub_9B72
         jsr  sub_96C8             ; 9B72
         lda  #$B6                 ; 9B75
         sta  $8D                  ; 9B77
         sta  $934D                ; 9B79
         lda  #$70                 ; 9B7C
         sta  $934E                ; 9B7E
         jsr  sub_8A4D             ; 9B81
         ldx  #$07                 ; 9B84
         jsr  sub_9215             ; 9B86
         lda  #$01                 ; 9B89
         jsr  sub_9C5A             ; 9B8B
         rts                       ; 9B8E
sub_9B8F
         jsr  sub_96C8             ; 9B8F
         lda  #$B6                 ; 9B92
         sta  $8D                  ; 9B94
         sta  $934D                ; 9B96
         lda  #$70                 ; 9B99
         sta  $934E                ; 9B9B
         jsr  sub_8A4D             ; 9B9E
         ldx  #$07                 ; 9BA1
         jsr  sub_9215             ; 9BA3
         lda  #$02                 ; 9BA6
         inc  $935C                ; 9BA8
         jsr  sub_9C5A             ; 9BAB
         rts                       ; 9BAE
sub_9BAF
         jsr  sub_96C8             ; 9BAF
         lda  #$B6                 ; 9BB2
         sta  $8D                  ; 9BB4
         sta  $934D                ; 9BB6
         lda  #$70                 ; 9BB9
         sta  $934E                ; 9BBB
         jsr  sub_8A4D             ; 9BBE
         lda  $9CED                ; 9BC1
         sta  $9CEB                ; 9BC4
         lda  $9CEE                ; 9BC7
         sta  $9CEC                ; 9BCA
         lda  #$01                 ; 9BCD
         sta  $935C                ; 9BCF
         ldx  #$07                 ; 9BD2
         jsr  sub_9215             ; 9BD4
         lda  #$03                 ; 9BD7
         jsr  sub_9C5A             ; 9BD9
         rts                       ; 9BDC
sub_9BDD
         lda  #$16                 ; 9BDD
         sta  $9349                ; 9BDF
         lda  #$24                 ; 9BE2
         sta  $934A                ; 9BE4
         lda  #$FA                 ; 9BE7
         sta  $934B                ; 9BE9
         lda  #$8C                 ; 9BEC
         sta  $934C                ; 9BEE
         rts                       ; 9BF1
sub_9BF2
         stx  $C0                  ; 9BF2
         sty  $C1                  ; 9BF4
         ldx  #$00                 ; 9BF6
         ldy  #$00                 ; 9BF8
L9BFA
         lda  ($C0),y              ; 9BFA
         asl                       ; 9BFC
         sta  LBC00,x              ; 9BFD
         sta  $BE00,x              ; 9C00
         inx                       ; 9C03
         clc                       ; 9C04
         adc  #$01                 ; 9C05
         sta  LBC00,x              ; 9C07
         sta  $BE00,x              ; 9C0A
         iny                       ; 9C0D
         inx                       ; 9C0E
         bne  L9BFA                ; 9C0F
L9C11
         lda  ($C0),y              ; 9C11
         asl                       ; 9C13
         sta  $BD00,x              ; 9C14
         sta  $BF00,x              ; 9C17
         inx                       ; 9C1A
         clc                       ; 9C1B
         adc  #$01                 ; 9C1C
         sta  $BD00,x              ; 9C1E
         sta  $BF00,x              ; 9C21
         inx                       ; 9C24
         iny                       ; 9C25
         cpy  #$C8                 ; 9C26
         bne  L9C11                ; 9C28
         rts                       ; 9C2A
         dta $AD,$84,$02,$29,$01,$D0,$F9,$AD,$84,$02,$29,$01,$F0,$F9,$60,$4A ; 9C2B
         dta $9C,$02,$00,$4E,$9C,$02,$00,$52,$9C,$01,$00,$54,$9C,$03,$00,$C0 ; 9C3B
         dta $74,$88,$75,$18,$77,$E0,$77,$50,$76,$A8,$78,$70,$79,$38,$7A ; 9C4B
sub_9C5A
         asl                       ; 9C5A
         asl                       ; 9C5B
         tax                       ; 9C5C
         lda  $9C3A,x              ; 9C5D
         sta  $C2                  ; 9C60
         lda  $9C3B,x              ; 9C62
         sta  $C3                  ; 9C65
         lda  $9C3C,x              ; 9C67
         sta  $E8                  ; 9C6A
         jsr  sub_8FB8             ; 9C6C
         lda  #$00                 ; 9C6F
         sta  $13                  ; 9C71
         sta  RTCLOK+2             ; 9C73
         sta  $9CCD                ; 9C75
         sta  $E5                  ; 9C78
L9C7A
         lda  $E5                  ; 9C7A
         asl                       ; 9C7C
         tay                       ; 9C7D
         lda  ($C2),y              ; 9C7E
         sta  $C0                  ; 9C80
         iny                       ; 9C82
         lda  ($C2),y              ; 9C83
         tay                       ; 9C85
         ldx  $C0                  ; 9C86
         jsr  sub_9BF2             ; 9C88
         jsr  sub_9BDD             ; 9C8B
         jsr  sub_9744             ; 9C8E
L9C91
         lda  STRIG0               ; 9C91
         and  #$01                 ; 9C94
         bne  L9C99                ; 9C96
         rts                       ; 9C98
L9C99
         lda  $13                  ; 9C99
         cmp  #$01                 ; 9C9B
         bne  L9C91                ; 9C9D
         lda  $935C                ; 9C9F
         cmp  #$01                 ; 9CA2
         bne  L9CA9                ; 9CA4
         jsr  sub_9CCC             ; 9CA6
L9CA9
         lda  STRIG0               ; 9CA9
         and  #$01                 ; 9CAC
         bne  L9CB1                ; 9CAE
         rts                       ; 9CB0
L9CB1
         lda  $13                  ; 9CB1
         cmp  #$02                 ; 9CB3
         bne  L9CA9                ; 9CB5
         lda  #$00                 ; 9CB7
         sta  $13                  ; 9CB9
         jsr  sub_96C8             ; 9CBB
         inc  $E5                  ; 9CBE
         lda  $E5                  ; 9CC0
         cmp  $E8                  ; 9CC2
         bne  L9C7A                ; 9CC4
         lda  #$00                 ; 9CC6
         sta  $E5                  ; 9CC8
         beq  L9C7A                ; 9CCA
sub_9CCC
         lda  #$00                 ; 9CCC
         asl                       ; 9CCE
         tax                       ; 9CCF
         lda  $9CEB,x              ; 9CD0
         sta  $89D0                ; 9CD3
         sta  $8A34                ; 9CD6
         lda  $9CEC,x              ; 9CD9
         sta  $89D1                ; 9CDC
         sta  $8A35                ; 9CDF
         lda  $9CCD                ; 9CE2
         and  #$07                 ; 9CE5
         sta  $9CCD                ; 9CE7
         rts                       ; 9CEA
         dta $29,$A1,$A1,$A1,$19,$A2,$91,$A2,$09,$A3,$81,$A3,$F9,$A3,$71,$A4 ; 9CEB
irq_9CFB
         lda  #$00                 ; 9CFB
         beq  L9D33                ; 9CFD
         ldx  #$FF                 ; 9CFF
         dex                       ; 9D01
         stx  $9D00                ; 9D02
         beq  L9D08                ; 9D05
         rts                       ; 9D07
L9D08
         ldx  #$00                 ; 9D08
         lda  #$00                 ; 9D0A
         sta  $B473,x              ; 9D0C
         sta  $B49B,x              ; 9D0F
         sta  $B4C3,x              ; 9D12
         lda  #$01                 ; 9D15
         sta  $9D00                ; 9D17
         inx                       ; 9D1A
         stx  $9D09                ; 9D1B
         cpx  #$28                 ; 9D1E
         beq  L9D23                ; 9D20
         rts                       ; 9D22
L9D23
         lda  #$00                 ; 9D23
         sta  $9D09                ; 9D25
         lda  #$FF                 ; 9D28
         sta  $9D00                ; 9D2A
         lda  #$00                 ; 9D2D
         sta  $9CFC                ; 9D2F
         rts                       ; 9D32
L9D33
         lda  RTCLOK+2             ; 9D33
         and  #$03                 ; 9D35
         beq  L9D3A                ; 9D37
         rts                       ; 9D39
L9D3A
         ldx  #$00                 ; 9D3A
         lda  $A1A1,x              ; 9D3C
         sta  $B473,x              ; 9D3F
         inx                       ; 9D42
         cpx  #$78                 ; 9D43
         bne  L9D69                ; 9D45
         lda  #$02                 ; 9D47
         asl                       ; 9D49
         tay                       ; 9D4A
         lda  $9CEB,y              ; 9D4B
         sta  $9D3D                ; 9D4E
         lda  $9CEC,y              ; 9D51
         sta  $9D3E                ; 9D54
         ldy  $9D48                ; 9D57
         iny                       ; 9D5A
         cpy  #$08                 ; 9D5B
         bne  L9D61                ; 9D5D
         ldy  #$01                 ; 9D5F
L9D61
         sty  $9D48                ; 9D61
         sty  $9CFC                ; 9D64
         ldx  #$00                 ; 9D67
L9D69
         stx  $9D3B                ; 9D69
         rts                       ; 9D6C
sub_9D6D
         lda  $9357                ; 9D6D
         and  #$10                 ; 9D70
         bne  L9D75                ; 9D72
         rts                       ; 9D74
L9D75
         lda  $A6                  ; 9D75
         cmp  #$20                 ; 9D77
         beq  L9D7C                ; 9D79
         rts                       ; 9D7B
L9D7C
         inc  $935C                ; 9D7C
         lda  $935C                ; 9D7F
         cmp  #$07                 ; 9D82
         bne  L9D89                ; 9D84
         jmp  L9E43                ; 9D86
L9D89
         jsr  sub_9B72             ; 9D89
         jsr  sub_96C8             ; 9D8C
         lda  #$B6                 ; 9D8F
         sta  $8D                  ; 9D91
         sta  $934D                ; 9D93
         lda  #$70                 ; 9D96
         sta  $934E                ; 9D98
         jsr  sub_8A4D             ; 9D9B
         lda  #$40                 ; 9D9E
         sta  $934F                ; 9DA0
         lda  #$70                 ; 9DA3
         sta  $9350                ; 9DA5
         lda  #$00                 ; 9DA8
         sta  $9351                ; 9DAA
         sta  $9352                ; 9DAD
         sta  $9353                ; 9DB0
         sta  $9354                ; 9DB3
         sta  $9355                ; 9DB6
         sta  $9356                ; 9DB9
         sta  $9357                ; 9DBC
         sta  $9358                ; 9DBF
         sta  $9359                ; 9DC2
         sta  $935A                ; 9DC5
         sta  $935B                ; 9DC8
         sta  $A6                  ; 9DCB
         sta  $8F                  ; 9DCD
         lda  #$60                 ; 9DCF
         sta  $A5                  ; 9DD1
         inc  $A7                  ; 9DD3
         jsr  sub_8DF8             ; 9DD5
         ldx  $935C                ; 9DD8
         lda  $9E49,x              ; 9DDB
         sta  $7788                ; 9DDE
         inx                       ; 9DE1
         lda  $9E49,x              ; 9DE2
         sta  $7879                ; 9DE5
         lda  $935C                ; 9DE8
         cmp  #$02                 ; 9DEB
         bne  L9DF5                ; 9DED
         jsr  sub_9B2D             ; 9DEF
         jmp  L9E1D                ; 9DF2
L9DF5
         cmp  #$03                 ; 9DF5
         bne  L9DFF                ; 9DF7
         jsr  sub_9A28             ; 9DF9
         jmp  L9E1D                ; 9DFC
L9DFF
         cmp  #$04                 ; 9DFF
         bne  L9E09                ; 9E01
         jsr  sub_9AB6             ; 9E03
         jmp  L9E1D                ; 9E06
L9E09
         cmp  #$05                 ; 9E09
         bne  L9E13                ; 9E0B
         jsr  sub_9A8E             ; 9E0D
         jmp  L9E1D                ; 9E10
L9E13
         cmp  #$06                 ; 9E13
         bne  L9E1D                ; 9E15
         jsr  sub_9ADE             ; 9E17
         jmp  L9E1D                ; 9E1A
L9E1D
         jsr  sub_8FC7             ; 9E1D
         lda  #$AB                 ; 9E20
         sta  $89D0                ; 9E22
         sta  $8A34                ; 9E25
         lda  #$A0                 ; 9E28
         sta  $89D1                ; 9E2A
         sta  $8A35                ; 9E2D
         jsr  sub_9151             ; 9E30
         jsr  sub_9744             ; 9E33
         lda  #$40                 ; 9E36
         sta  $934D                ; 9E38
         lda  RTCLOK+2             ; 9E3B
         clc                       ; 9E3D
         adc  #$02                 ; 9E3E
         sta  $8E                  ; 9E40
         rts                       ; 9E42
L9E43
         jsr  sub_9BAF             ; 9E43
         jmp  LAEF0                ; 9E46
         dta $00,$74,$77,$7E,$6A,$76,$6B,$7F,$6D,$75,$20,$BF,$8F,$78,$A9,$00 ; 9E49
         dta $8D,$00,$D4,$8D,$0E,$D4,$A9,$FE,$8D,$01,$D3,$A2,$AE,$A0,$9E,$8E ; 9E59
         dta $FA,$FF,$8C,$FB,$FF,$A2,$C7,$A0,$9E,$8E,$FC,$FF,$8C,$FD,$FF,$8E ; 9E69
         dta $00,$02,$8C,$01,$02,$A2,$C8,$A0,$9E,$8E,$FE,$FF,$8C,$FF,$FF,$A2 ; 9E79
         dta $96,$A0,$9E,$8E,$24,$02,$8C,$25,$02,$58,$20,$A6,$C5 ; 9E89
irq_9E96
         rts                       ; 9E96
entry_9E97
         jsr  sub_8FBF             ; 9E97
         lda  #$C0                 ; 9E9A
         sta  NMIEN                ; 9E9C
         ldx  #$00                 ; 9E9F
         ldy  #$EA                 ; 9EA1
         lda  #$70                 ; 9EA3
         jsr  entry_F2E4           ; 9EA5
         lda  #$00                 ; 9EA8
         sta  $9F6C                ; 9EAA
         rts                       ; 9EAD
entry_9EAE
         cld                       ; 9EAE
         bit  NMIST                ; 9EAF
         bpl  L9EB7                ; 9EB2
         jmp  (VDSLST)             ; 9EB4
L9EB7
         pha                       ; 9EB7
         txa                       ; 9EB8
         pha                       ; 9EB9
         tya                       ; 9EBA
         pha                       ; 9EBB
         sta  NMIST                ; 9EBC
         jsr  entry_9ED6           ; 9EBF
         pla                       ; 9EC2
         tay                       ; 9EC3
         pla                       ; 9EC4
         tax                       ; 9EC5
         pla                       ; 9EC6
         rti                       ; 9EC7
entry_9EC8
         pha                       ; 9EC8
         lda  IRQEN                ; 9EC9
         lda  #$00                 ; 9ECC
         sta  IRQEN                ; 9ECE
         sta  IRQEN                ; 9ED1
         pla                       ; 9ED4
         rti                       ; 9ED5
entry_9ED6
         lda  #$FF                 ; 9ED6
         sta  PORTB                ; 9ED8
         lda  $D20D                ; 9EDB
         cmp  #$00                 ; 9EDE
         beq  L9EE5                ; 9EE0
         nop                       ; 9EE2
         nop                       ; 9EE3
         nop                       ; 9EE4
L9EE5
         lda  $C001                ; 9EE5
         cmp  #$51                 ; 9EE8
         bne  L9EEF                ; 9EEA
         nop                       ; 9EEC
         nop                       ; 9EED
         nop                       ; 9EEE
L9EEF
         lda  $C002                ; 9EEF
         cmp  #$4D                 ; 9EF2
         bne  L9EF9                ; 9EF4
         nop                       ; 9EF6
         nop                       ; 9EF7
         nop                       ; 9EF8
L9EF9
         lda  #$FE                 ; 9EF9
         sta  PORTB                ; 9EFB
         inc  RTCLOK+2             ; 9EFE
         bne  L9F04                ; 9F00
         inc  $13                  ; 9F02
L9F04
         ldx  #$08                 ; 9F04
L9F06
         lda  $02C0,x              ; 9F06
         sta  COLPM0,x             ; 9F09
         dex                       ; 9F0C
         bpl  L9F06                ; 9F0D
         lda  SDLSTL               ; 9F0F
         ldx  SDLSTH               ; 9F12
         sta  DLISTL               ; 9F15
         stx  DLISTH               ; 9F18
         lda  SDMCTL               ; 9F1B
         sta  DMACTL               ; 9F1E
         lda  GPRIOR               ; 9F21
         sta  PRIOR                ; 9F24
         lda  CHBAS                ; 9F27
         sta  CHBASE               ; 9F2A
         lda  PORTA                ; 9F2D
         and  #$0F                 ; 9F30
         sta  STICK0               ; 9F32
         lda  TRIG0                ; 9F35
         sta  STRIG0               ; 9F38
         lda  SKCTL                ; 9F3B
         cmp  #$F3                 ; 9F3E
         bne  L9F6B                ; 9F40
         lda  KBCODE               ; 9F42
         cmp  #$00                 ; 9F45
         beq  L9F6B                ; 9F47
         sta  $9F46                ; 9F49
         ldx  #$00                 ; 9F4C
         cmp  $9F75,x              ; 9F4E
         bne  L9F66                ; 9F51
         inx                       ; 9F53
         stx  $9F4D                ; 9F54
         cpx  #$08                 ; 9F57
         bne  L9F6B                ; 9F59
         lda  #$08                 ; 9F5B
         sta  $A7                  ; 9F5D
         lda  #$14                 ; 9F5F
         sta  $9F67                ; 9F61
         bne  L9F6B                ; 9F64
L9F66
         ldx  #$00                 ; 9F66
         stx  $9F4D                ; 9F68
L9F6B
         lda  #$01                 ; 9F6B
         bne  L9F72                ; 9F6D
         jsr  entry_F2E7           ; 9F6F
L9F72
         jmp  (VVBLKD)             ; 9F72
         dta $4A,$4D,$6A,$68,$6E,$7E,$57,$6B,$4D      ; 9F75
sub_9F7E
         ldx  #$00                 ; 9F7E
         txa                       ; 9F80
L9F81
         sta  LBC00,x              ; 9F81
         sta  $BCC8,x              ; 9F84
         sta  $BE00,x              ; 9F87
         sta  $BEC8,x              ; 9F8A
         sta  $D800,x              ; 9F8D
         sta  $E000,x              ; 9F90
         inx                       ; 9F93
         bne  L9F81                ; 9F94
         rts                       ; 9F96
         dta $1C,$20,$80,$40,$1C,$80,$80,$40,$14,$45,$64,$80,$14,$52,$68,$80 ; 9F97
         dta $00,$18,$20,$80,$40,$1C,$60,$80,$40,$14,$45,$64,$80,$14,$72,$6C ; 9FA7
         dta $80,$00,$1C,$40,$80,$40,$18,$80,$80,$40,$14,$55,$64,$80,$14,$62 ; 9FB7
         dta $68,$80,$00,$18,$40,$80,$40,$18,$60,$80,$40,$14,$55,$64,$80,$14 ; 9FC7
         dta $72,$68,$80,$00,$97,$9F,$A8,$9F,$B9,$9F,$CA,$9F,$00,$00,$00,$00 ; 9FD7
         dta $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9FE7
         dta $00,$00,$00,$00,$00,$00,$00,$00,$00      ; 9FF7
