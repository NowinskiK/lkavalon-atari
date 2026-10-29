; ENDING.ASM - ending sequence, its DLI and display list ($ACFC)
; $AB7D-$B4ED

         org $AB7D

sub_AB7D
         ldx  #$00                 ; AB7D
LAB7F
         txa                       ; AB7F
         and  #$C0                 ; AB80
         lsr                       ; AB82
         lsr                       ; AB83
         lsr                       ; AB84
         lsr                       ; AB85
         sta  $B7                  ; AB86
         txa                       ; AB88
         and  #$0C                 ; AB89
         lsr                       ; AB8B
         lsr                       ; AB8C
         ora  $B7                  ; AB8D
         tay                       ; AB8F
         lda  $ABCA,y              ; AB90
         tay                       ; AB93
         asl                       ; AB94
         asl                       ; AB95
         asl                       ; AB96
         asl                       ; AB97
         and  #$C0                 ; AB98
         sta  $B8                  ; AB9A
         tya                       ; AB9C
         asl                       ; AB9D
         asl                       ; AB9E
         and  #$0C                 ; AB9F
         ora  $B8                  ; ABA1
         sta  $B8                  ; ABA3
         txa                       ; ABA5
         and  #$30                 ; ABA6
         lsr                       ; ABA8
         lsr                       ; ABA9
         sta  $B7                  ; ABAA
         txa                       ; ABAC
         and  #$03                 ; ABAD
         ora  $B7                  ; ABAF
         tay                       ; ABB1
         lda  $ABCA,y              ; ABB2
         tay                       ; ABB5
         asl                       ; ABB6
         asl                       ; ABB7
         and  #$30                 ; ABB8
         sta  $B7                  ; ABBA
         tya                       ; ABBC
         and  #$03                 ; ABBD
         ora  $B7                  ; ABBF
         ora  $B8                  ; ABC1
         sta  $2C00,x              ; ABC3
         inx                       ; ABC6
         bne  LAB7F                ; ABC7
         rts                       ; ABC9
         dta $04,$01,$02,$03,$05,$09,$05,$07,$08,$0A,$0E,$0B,$0C,$0D,$0F,$00 ; ABCA
irq_ABDA
         pha                       ; ABDA
         sta  WSYNC                ; ABDB
         lda  $B4                  ; ABDE
         and  #$01                 ; ABE0
         bne  LABFC                ; ABE2
         lda  $B0                  ; ABE4
         sta  COLBK                ; ABE6
         lda  $B1                  ; ABE9
         sta  COLPF0               ; ABEB
         lda  $B2                  ; ABEE
         sta  COLPF1               ; ABF0
         lda  $B3                  ; ABF3
         sta  COLPF2               ; ABF5
         inc  $B4                  ; ABF8
         pla                       ; ABFA
         rti                       ; ABFB
LABFC
         lda  #$74                 ; ABFC
         sta  COLBK                ; ABFE
         sta  COLPF2               ; AC01
         lda  #$0E                 ; AC04
         sta  COLPF1               ; AC06
         inc  $B4                  ; AC09
         txa                       ; AC0B
         pha                       ; AC0C
         tya                       ; AC0D
         pha                       ; AC0E
         lda  RTCLOK+2             ; AC0F
         lsr                       ; AC11
         ldx  #$28                 ; AC12
         ldy  #$AC                 ; AC14
         bcc  LAC1C                ; AC16
         ldx  #$FC                 ; AC18
         ldy  #$AC                 ; AC1A
LAC1C
         stx  SDLSTL               ; AC1C
         sty  SDLSTH               ; AC1F
         pla                       ; AC22
         tay                       ; AC23
         pla                       ; AC24
         tax                       ; AC25
         pla                       ; AC26
         rti                       ; AC27
         dta $70,$4E,$00,$71,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E ; AC28
         dta $0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$20,$CE,$D8,$29,$4E ; AC38
         dta $10,$10,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E ; AC48
         dta $0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E ; AC58
         dta $0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E ; AC68
         dta $0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E ; AC78
         dta $0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E ; AC88
         dta $0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E ; AC98
         dta $0E,$0E,$0E,$0E,$0E,$0E,$0E,$4E,$00,$20,$0E,$0E,$0E,$0E,$0E,$0E ; ACA8
         dta $0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E ; ACB8
         dta $0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E ; ACC8
         dta $0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E ; ACD8
         dta $0E,$0E,$0E,$0E,$0E,$0E,$0E,$8E,$0E,$10,$42,$73,$B4,$10,$02,$10 ; ACE8
         dta $02,$41,$28,$AC,$70,$4E,$00,$71,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E ; ACF8
         dta $0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$20 ; AD08
         dta $CE,$D8,$49,$4E,$10,$30,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E ; AD18
         dta $0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E ; AD28
         dta $0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E ; AD38
         dta $0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E ; AD48
         dta $0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E ; AD58
         dta $0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E ; AD68
         dta $0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$4E,$00,$40,$0E,$0E ; AD78
         dta $0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E ; AD88
         dta $0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E ; AD98
         dta $0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E ; ADA8
         dta $0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$8E,$0E,$10,$42,$73 ; ADB8
         dta $B4,$10,$02,$10,$02,$41,$FC,$AC,$26,$27,$28,$29,$2A,$2B,$2C,$2D ; ADC8
         dta $2E,$2F,$30,$31,$31,$32,$33,$34,$35,$36,$37,$38,$38,$39,$3A,$3B ; ADD8
         dta $3B,$3C,$3D,$3E,$3E,$3F,$40,$41,$41,$42,$42,$43,$44,$44,$45,$45 ; ADE8
         dta $46,$46,$47,$47,$48,$48,$49,$49,$49,$4A,$4A,$4A,$4A,$4B,$4B,$4B ; ADF8
         dta $4B,$4C,$4C,$4C,$4C,$4C,$4C,$4C,$4C,$4C,$4C,$4C,$4C,$4C,$4C,$4B ; AE08
         dta $4B,$4B,$4B,$4A,$4A,$4A,$4A,$49,$49,$49,$48,$48,$47,$47,$46,$46 ; AE18
         dta $45,$45,$44,$44,$43,$42,$42,$41,$41,$40,$3F,$3E,$3E,$3D,$3C,$3B ; AE28
         dta $3B,$3A,$39,$38,$38,$37,$36,$35,$34,$33,$32,$31,$31,$30,$2F,$2E ; AE38
         dta $2D,$2C,$2B,$2A,$29,$28,$27,$26,$26,$25,$24,$23,$22,$21,$20,$1F ; AE48
         dta $1E,$1D,$1C,$1B,$1B,$1A,$19,$18,$17,$16,$15,$14,$14,$13,$12,$11 ; AE58
         dta $11,$10,$0F,$0E,$0E,$0D,$0C,$0B,$0B,$0A,$0A,$09,$08,$08,$07,$07 ; AE68
         dta $06,$06,$05,$05,$04,$04,$03,$03,$03,$02,$02,$02,$02,$01,$01,$01 ; AE78
         dta $01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01 ; AE88
         dta $01,$01,$01,$02,$02,$02,$02,$03,$03,$03,$04,$04,$05,$05,$06,$06 ; AE98
         dta $07,$07,$08,$08,$09,$0A,$0A,$0B,$0B,$0C,$0D,$0E,$0E,$0F,$10,$11 ; AEA8
         dta $11,$12,$13,$14,$14,$15,$16,$17,$18,$19,$1A,$1B,$1B,$1C,$1D,$1E ; AEB8
         dta $1F,$20,$21,$22,$23,$24,$25,$26,$00,$00,$00,$00,$00,$00,$00,$00 ; AEC8
         dta $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AED8
         dta $00,$00,$00,$00,$00,$00,$00,$00          ; AEE8
LAEF0
         jsr  sub_B24C             ; AEF0
         lda  #$40                 ; AEF3
         sta  NMIEN                ; AEF5
         lda  #$00                 ; AEF8
         sta  SDMCTL               ; AEFA
         sta  DMACTL               ; AEFD
         ldx  #$96                 ; AF00
         ldy  #$9E                 ; AF02
         stx  VVBLKD               ; AF04
         sty  $0225                ; AF07
         jsr  sub_B2B9             ; AF0A
         jsr  sub_B24C             ; AF0D
         jsr  sub_B253             ; AF10
         jsr  sub_B269             ; AF13
         jsr  sub_AB7D             ; AF16
         jsr  sub_AFEE             ; AF19
         jsr  sub_B311             ; AF1C
         jsr  sub_B30B             ; AF1F
LAF22
         jsr  sub_B389             ; AF22
         jsr  sub_B3B4             ; AF25
         jsr  sub_B24C             ; AF28
         lda  $13                  ; AF2B
         bne  LAF32                ; AF2D
         jsr  sub_AF6A             ; AF2F
LAF32
         lda  SKCTL                ; AF32
         and  #$04                 ; AF35
         bne  LAF22                ; AF37
         lda  #$00                 ; AF39
         sta  $13                  ; AF3B
         beq  LAF22                ; AF3D
sub_AF3F
         ldx  #$0F                 ; AF3F
         inc  $B1                  ; AF41
         lda  $B1                  ; AF43
         and  #$0F                 ; AF45
         bne  LAF4B                ; AF47
         stx  $B1                  ; AF49
LAF4B
         inc  $B2                  ; AF4B
         lda  $B2                  ; AF4D
         and  #$0F                 ; AF4F
         bne  LAF55                ; AF51
         stx  $B2                  ; AF53
LAF55
         inc  $B3                  ; AF55
         lda  $B3                  ; AF57
         and  #$0F                 ; AF59
         bne  LAF5F                ; AF5B
         stx  $B3                  ; AF5D
LAF5F
         inc  $B0                  ; AF5F
         lda  $B0                  ; AF61
         and  #$0F                 ; AF63
         bne  LAF69                ; AF65
         stx  $B0                  ; AF67
LAF69
         rts                       ; AF69
sub_AF6A
         jsr  sub_AF3F             ; AF6A
         jsr  sub_AF3F             ; AF6D
         ldx  $B3                  ; AF70
         inx                       ; AF72
         and  #$0F                 ; AF73
         beq  LAF78                ; AF75
         rts                       ; AF77
LAF78
         lda  $ABD9                ; AF78
         eor  #$0F                 ; AF7B
         sta  $ABD9                ; AF7D
         jsr  sub_B2B9             ; AF80
         jsr  sub_AB7D             ; AF83
         lda  $D2CA                ; AF86
         and  #$0F                 ; AF89
         ldx  $D2AA                ; AF8B
         bmi  LAF92                ; AF8E
         eor  #$FF                 ; AF90
LAF92
         sta  $BC                  ; AF92
         lda  $D28A                ; AF94
         and  #$1F                 ; AF97
         ldx  $D2AA                ; AF99
         bmi  LAFA0                ; AF9C
         eor  #$FF                 ; AF9E
LAFA0
         sta  $BD                  ; AFA0
         lda  $D24A                ; AFA2
         and  #$3F                 ; AFA5
         ldx  $D2AA                ; AFA7
         bmi  LAFAE                ; AFAA
         eor  #$FF                 ; AFAC
LAFAE
         sta  $BE                  ; AFAE
         lda  RANDOM               ; AFB0
         and  #$7F                 ; AFB3
         ldx  $D2AA                ; AFB5
         bmi  LAFBC                ; AFB8
         eor  #$FF                 ; AFBA
LAFBC
         sta  $BF                  ; AFBC
         lda  $D2CA                ; AFBE
         and  #$F0                 ; AFC1
         ora  #$0F                 ; AFC3
         sta  $B0                  ; AFC5
         lda  $D24A                ; AFC7
         and  #$F0                 ; AFCA
         tax                       ; AFCC
         clc                       ; AFCD
         adc  #$06                 ; AFCE
         sta  $B1                  ; AFD0
         txa                       ; AFD2
         clc                       ; AFD3
         adc  #$2A                 ; AFD4
         sta  $B2                  ; AFD6
         txa                       ; AFD8
         clc                       ; AFD9
         adc  #$4E                 ; AFDA
         sta  $B3                  ; AFDC
LAFDE
         jsr  sub_B24C             ; AFDE
         dec  $B0                  ; AFE1
         lda  $B0                  ; AFE3
         and  #$0F                 ; AFE5
         cmp  #$02                 ; AFE7
         bne  LAFDE                ; AFE9
         jmp  sub_B311             ; AFEB
sub_AFEE
         ldx  #$00                 ; AFEE
         stx  $2D00                ; AFF0
         stx  $2E00                ; AFF3
         inx                       ; AFF6
LAFF7
         lda  $2CFF,x              ; AFF7
         clc                       ; AFFA
         adc  #$28                 ; AFFB
         sta  $2D00,x              ; AFFD
         lda  $2DFF,x              ; B000
         adc  #$00                 ; B003
         sta  $2E00,x              ; B005
         inx                       ; B008
         cpx  #$A0                 ; B009
         bne  LAFF7                ; B00B
         rts                       ; B00D
sub_B00E
         lda  #$00                 ; B00E
         sta  $C1                  ; B010
         sta  $C3                  ; B012
         lda  $BA                  ; B014
         and  #$03                 ; B016
         asl                       ; B018
         tax                       ; B019
         lda  $B3DB,x              ; B01A
         sta  $C4                  ; B01D
         lda  $B3DC,x              ; B01F
         sta  $C5                  ; B022
         lda  $BB                  ; B024
         and  #$01                 ; B026
         tay                       ; B028
         lda  $BA                  ; B029
         lsr                       ; B02B
         lsr                       ; B02C
         clc                       ; B02D
         adc  #$10                 ; B02E
         sta  $C0                  ; B030
         ldx  $BB                  ; B032
         lda  $2D00,x              ; B034
         clc                       ; B037
         adc  $C0                  ; B038
         sta  $C0                  ; B03A
         sta  $C2                  ; B03C
         bcc  LB044                ; B03E
         inc  $C1                  ; B040
         inc  $C3                  ; B042
LB044
         lda  $2E00,x              ; B044
         tax                       ; B047
         clc                       ; B048
         adc  $B267,y              ; B049
         adc  $C1                  ; B04C
         sta  $C1                  ; B04E
         tya                       ; B050
         eor  #$01                 ; B051
         tay                       ; B053
         txa                       ; B054
         clc                       ; B055
         adc  $B267,y              ; B056
         adc  $C3                  ; B059
         sta  $C3                  ; B05B
         ldy  #$00                 ; B05D
         lda  ($C4),y              ; B05F
         sta  $B5                  ; B061
         jsr  sub_B1C6             ; B063
         ldy  #$01                 ; B066
         lda  ($C4),y              ; B068
         sta  $B5                  ; B06A
         jsr  sub_B1C6             ; B06C
         ldy  #$02                 ; B06F
         lda  ($C4),y              ; B071
         sta  $B5                  ; B073
         jsr  sub_B1C6             ; B075
         jsr  sub_B229             ; B078
         ldy  #$00                 ; B07B
         lda  ($C4),y              ; B07D
         sta  $B5                  ; B07F
         jsr  sub_B1C6             ; B081
         ldy  #$01                 ; B084
         lda  ($C4),y              ; B086
         sta  $B5                  ; B088
         jsr  sub_B1C6             ; B08A
         ldy  #$02                 ; B08D
         lda  ($C4),y              ; B08F
         sta  $B5                  ; B091
         jsr  sub_B1C6             ; B093
         jsr  sub_B229             ; B096
         ldy  #$00                 ; B099
         lda  ($C4),y              ; B09B
         sta  $B5                  ; B09D
         jsr  sub_B1C6             ; B09F
         ldy  #$01                 ; B0A2
         lda  ($C4),y              ; B0A4
         sta  $B5                  ; B0A6
         jsr  sub_B1C6             ; B0A8
         ldy  #$02                 ; B0AB
         lda  ($C4),y              ; B0AD
         sta  $B5                  ; B0AF
         jsr  sub_B1C6             ; B0B1
         jsr  sub_B229             ; B0B4
         ldy  #$00                 ; B0B7
         lda  ($C4),y              ; B0B9
         sta  $B5                  ; B0BB
         jsr  sub_B1C6             ; B0BD
         ldy  #$01                 ; B0C0
         lda  ($C4),y              ; B0C2
         sta  $B5                  ; B0C4
         jsr  sub_B1C6             ; B0C6
         ldy  #$02                 ; B0C9
         lda  ($C4),y              ; B0CB
         sta  $B5                  ; B0CD
         jsr  sub_B1C6             ; B0CF
         jsr  sub_B229             ; B0D2
         ldy  #$00                 ; B0D5
         lda  ($C4),y              ; B0D7
         sta  $B5                  ; B0D9
         jsr  sub_B1C6             ; B0DB
         ldy  #$01                 ; B0DE
         lda  ($C4),y              ; B0E0
         sta  $B5                  ; B0E2
         jsr  sub_B1C6             ; B0E4
         ldy  #$02                 ; B0E7
         lda  ($C4),y              ; B0E9
         sta  $B5                  ; B0EB
         jsr  sub_B1C6             ; B0ED
         jsr  sub_B229             ; B0F0
         ldy  #$00                 ; B0F3
         lda  ($C4),y              ; B0F5
         sta  $B5                  ; B0F7
         jsr  sub_B1C6             ; B0F9
         ldy  #$01                 ; B0FC
         lda  ($C4),y              ; B0FE
         sta  $B5                  ; B100
         jsr  sub_B1C6             ; B102
         ldy  #$02                 ; B105
         lda  ($C4),y              ; B107
         sta  $B5                  ; B109
         jsr  sub_B1C6             ; B10B
         jsr  sub_B229             ; B10E
         ldy  #$00                 ; B111
         lda  ($C4),y              ; B113
         sta  $B5                  ; B115
         jsr  sub_B1C6             ; B117
         ldy  #$01                 ; B11A
         lda  ($C4),y              ; B11C
         sta  $B5                  ; B11E
         jsr  sub_B1C6             ; B120
         ldy  #$02                 ; B123
         lda  ($C4),y              ; B125
         sta  $B5                  ; B127
         jsr  sub_B1C6             ; B129
         jsr  sub_B229             ; B12C
         ldy  #$00                 ; B12F
         lda  ($C4),y              ; B131
         sta  $B5                  ; B133
         jsr  sub_B1C6             ; B135
         ldy  #$01                 ; B138
         lda  ($C4),y              ; B13A
         sta  $B5                  ; B13C
         jsr  sub_B1C6             ; B13E
         ldy  #$02                 ; B141
         lda  ($C4),y              ; B143
         sta  $B5                  ; B145
         jsr  sub_B1C6             ; B147
         jsr  sub_B229             ; B14A
         ldy  #$00                 ; B14D
         lda  ($C4),y              ; B14F
         sta  $B5                  ; B151
         jsr  sub_B1C6             ; B153
         ldy  #$01                 ; B156
         lda  ($C4),y              ; B158
         sta  $B5                  ; B15A
         jsr  sub_B1C6             ; B15C
         ldy  #$02                 ; B15F
         lda  ($C4),y              ; B161
         sta  $B5                  ; B163
         jsr  sub_B1C6             ; B165
         jsr  sub_B229             ; B168
         ldy  #$00                 ; B16B
         lda  ($C4),y              ; B16D
         sta  $B5                  ; B16F
         jsr  sub_B1C6             ; B171
         ldy  #$01                 ; B174
         lda  ($C4),y              ; B176
         sta  $B5                  ; B178
         jsr  sub_B1C6             ; B17A
         ldy  #$02                 ; B17D
         lda  ($C4),y              ; B17F
         sta  $B5                  ; B181
         jsr  sub_B1C6             ; B183
         jsr  sub_B229             ; B186
         ldy  #$00                 ; B189
         lda  ($C4),y              ; B18B
         sta  $B5                  ; B18D
         jsr  sub_B1C6             ; B18F
         ldy  #$01                 ; B192
         lda  ($C4),y              ; B194
         sta  $B5                  ; B196
         jsr  sub_B1C6             ; B198
         ldy  #$02                 ; B19B
         lda  ($C4),y              ; B19D
         sta  $B5                  ; B19F
         jsr  sub_B1C6             ; B1A1
         jsr  sub_B229             ; B1A4
         ldy  #$00                 ; B1A7
         lda  ($C4),y              ; B1A9
         sta  $B5                  ; B1AB
         jsr  sub_B1C6             ; B1AD
         ldy  #$01                 ; B1B0
         lda  ($C4),y              ; B1B2
         sta  $B5                  ; B1B4
         jsr  sub_B1C6             ; B1B6
         ldy  #$02                 ; B1B9
         lda  ($C4),y              ; B1BB
         sta  $B5                  ; B1BD
         jsr  sub_B1C6             ; B1BF
         jsr  sub_B229             ; B1C2
         rts                       ; B1C5
sub_B1C6
         lda  $B5                  ; B1C6
         eor  #$FF                 ; B1C8
         sta  $B6                  ; B1CA
         lda  ($C0),y              ; B1CC
         asl                       ; B1CE
         asl                       ; B1CF
         asl                       ; B1D0
         asl                       ; B1D1
         sta  $B7                  ; B1D2
         lda  ($C2),y              ; B1D4
         and  #$0F                 ; B1D6
         ora  $B7                  ; B1D8
         tax                       ; B1DA
         lda  $2C00,x              ; B1DB
         sta  $B7                  ; B1DE
         lda  ($C0),y              ; B1E0
         and  #$F0                 ; B1E2
         sta  $B8                  ; B1E4
         lda  ($C2),y              ; B1E6
         lsr                       ; B1E8
         lsr                       ; B1E9
         lsr                       ; B1EA
         lsr                       ; B1EB
         ora  $B8                  ; B1EC
         tax                       ; B1EE
         lda  $2C00,x              ; B1EF
         sta  $B8                  ; B1F2
         lda  $B8                  ; B1F4
         and  #$F0                 ; B1F6
         sta  $B9                  ; B1F8
         lda  $B7                  ; B1FA
         lsr                       ; B1FC
         lsr                       ; B1FD
         lsr                       ; B1FE
         lsr                       ; B1FF
         ora  $B9                  ; B200
         and  $B5                  ; B202
         sta  $B9                  ; B204
         lda  ($C0),y              ; B206
         and  $B6                  ; B208
         ora  $B9                  ; B20A
         sta  ($C0),y              ; B20C
         lda  $B8                  ; B20E
         asl                       ; B210
         asl                       ; B211
         asl                       ; B212
         asl                       ; B213
         sta  $B9                  ; B214
         lda  $B7                  ; B216
         and  #$0F                 ; B218
         ora  $B9                  ; B21A
         and  $B5                  ; B21C
         sta  $B9                  ; B21E
         lda  ($C2),y              ; B220
         and  $B6                  ; B222
         ora  $B9                  ; B224
         sta  ($C2),y              ; B226
         rts                       ; B228
sub_B229
         ldx  $C1                  ; B229
         lda  $C3                  ; B22B
         stx  $C3                  ; B22D
         sta  $C1                  ; B22F
         lda  $C0                  ; B231
         clc                       ; B233
         adc  #$28                 ; B234
         sta  $C0                  ; B236
         sta  $C2                  ; B238
         bcc  LB240                ; B23A
         inc  $C1                  ; B23C
         inc  $C3                  ; B23E
LB240
         lda  $C4                  ; B240
         clc                       ; B242
         adc  #$03                 ; B243
         sta  $C4                  ; B245
         bcc  LB24B                ; B247
         inc  $C5                  ; B249
LB24B
         rts                       ; B24B
sub_B24C
         lda  RTCLOK+2             ; B24C
LB24E
         cmp  RTCLOK+2             ; B24E
         beq  LB24E                ; B250
         rts                       ; B252
sub_B253
         lda  RTCLOK+2             ; B253
         lsr                       ; B255
         ldx  #$28                 ; B256
         ldy  #$AC                 ; B258
         bcc  LB260                ; B25A
         ldx  #$FC                 ; B25C
         ldy  #$AC                 ; B25E
LB260
         stx  SDLSTL               ; B260
         sty  SDLSTH               ; B263
         rts                       ; B266
         dta $10,$30                                  ; B267
sub_B269
         lda  #$76                 ; B269
         ldx  #$7A                 ; B26B
         ldy  #$7E                 ; B26D
         sta  $B1                  ; B26F
         stx  $B2                  ; B271
         sty  $B3                  ; B273
         lda  #$74                 ; B275
         sta  COLOR4               ; B277
         lda  #$C2                 ; B27A
         sta  $B0                  ; B27C
         lda  #$00                 ; B27E
         sta  $B4                  ; B280
         jsr  sub_B24C             ; B282
         lda  #$22                 ; B285
         sta  SDMCTL               ; B287
         lda  #$DA                 ; B28A
         ldx  #$AB                 ; B28C
         ldy  #$C0                 ; B28E
         sta  VDSLST               ; B290
         stx  $0201                ; B293
         sty  NMIEN                ; B296
         ldx  #$FB                 ; B299
         ldy  #$9C                 ; B29B
         stx  VVBLKD               ; B29D
         sty  $0225                ; B2A0
         lda  #$6C                 ; B2A3
         sta  CHBAS                ; B2A5
         lda  #$05                 ; B2A8
         sta  $BC                  ; B2AA
         lda  #$0A                 ; B2AC
         sta  $BD                  ; B2AE
         lda  #$0F                 ; B2B0
         sta  $BE                  ; B2B2
         lda  #$14                 ; B2B4
         sta  $BF                  ; B2B6
         rts                       ; B2B8
sub_B2B9
         lda  #$00                 ; B2B9
         ldy  #$10                 ; B2BB
         sty  $C1                  ; B2BD
         ldy  #$30                 ; B2BF
         sty  $C3                  ; B2C1
         ldy  #$00                 ; B2C3
         sty  $C0                  ; B2C5
         sty  $C2                  ; B2C7
         ldx  #$19                 ; B2C9
LB2CB
         sta  ($C0),y              ; B2CB
         sta  ($C2),y              ; B2CD
         iny                       ; B2CF
         bne  LB2CB                ; B2D0
         inc  $C1                  ; B2D2
         inc  $C3                  ; B2D4
         dex                       ; B2D6
         bne  LB2CB                ; B2D7
         ldy  #$00                 ; B2D9
LB2DB
         sta  ($C0),y              ; B2DB
         sta  ($C2),y              ; B2DD
         iny                       ; B2DF
         cpy  #$00                 ; B2E0
         bne  LB2DB                ; B2E2
         rts                       ; B2E4
         dta $A0,$27,$A2,$03,$8A,$09,$00,$99,$D8,$29,$99,$D8,$49,$8D,$11,$B3 ; B2E5
         dta $AD,$0B,$D4,$D0,$FB,$AD,$0B,$D4,$F0,$FB,$8A,$0A,$0A,$AA,$D0,$0B ; B2F5
         dta $8D,$11,$B3,$88,$10,$02                  ; B305
sub_B30B
         lda  #$D8                 ; B30B
         sta  $B2E1                ; B30D
         rts                       ; B310
sub_B311
         lda  $AED0                ; B311
         clc                       ; B314
         adc  $BC                  ; B315
         sta  $AED1                ; B317
         clc                       ; B31A
         adc  $BC                  ; B31B
         sta  $AED2                ; B31D
         clc                       ; B320
         adc  $BC                  ; B321
         sta  $AED3                ; B323
         clc                       ; B326
         adc  $BC                  ; B327
         sta  $AED4                ; B329
         lda  $AED8                ; B32C
         clc                       ; B32F
         adc  $BD                  ; B330
         sta  $AED9                ; B332
         clc                       ; B335
         adc  $BD                  ; B336
         sta  $AEDA                ; B338
         clc                       ; B33B
         adc  $BD                  ; B33C
         sta  $AEDB                ; B33E
         clc                       ; B341
         adc  $BD                  ; B342
         sta  $AEDC                ; B344
         lda  $AEE0                ; B347
         clc                       ; B34A
         adc  $BE                  ; B34B
         sta  $AEE1                ; B34D
         clc                       ; B350
         adc  $BE                  ; B351
         sta  $AEE2                ; B353
         clc                       ; B356
         adc  $BE                  ; B357
         sta  $AEE3                ; B359
         clc                       ; B35C
         adc  $BE                  ; B35D
         sta  $AEE4                ; B35F
         lda  $AEE8                ; B362
         clc                       ; B365
         adc  $BF                  ; B366
         sta  $AEE9                ; B368
         clc                       ; B36B
         adc  $BF                  ; B36C
         sta  $AEEA                ; B36E
         clc                       ; B371
         adc  $BF                  ; B372
         sta  $AEEB                ; B374
         clc                       ; B377
         adc  $BF                  ; B378
         sta  $AEEC                ; B37A
         ldy  #$FE                 ; B37D
         lda  $ABD9                ; B37F
         beq  LB386                ; B382
         ldy  #$FC                 ; B384
LB386
         sty  $13                  ; B386
         rts                       ; B388
sub_B389
         ldy  #$04                 ; B389
LB38B
         ldx  $AEE0,y              ; B38B
         lda  $ADD0,x              ; B38E
         ldx  $AEE8,y              ; B391
         clc                       ; B394
         adc  $ADD0,x              ; B395
         sta  $BB                  ; B398
         ldx  $AED0,y              ; B39A
         lda  $ADD0,x              ; B39D
         ldx  $AED8,y              ; B3A0
         clc                       ; B3A3
         adc  $ADD0,x              ; B3A4
         sta  $BA                  ; B3A7
         sty  $C6                  ; B3A9
         jsr  sub_B00E             ; B3AB
         ldy  $C6                  ; B3AE
         dey                       ; B3B0
         bpl  LB38B                ; B3B1
         rts                       ; B3B3
sub_B3B4
         ldy  #$04                 ; B3B4
LB3B6
         lda  $AED0,y              ; B3B6
         clc                       ; B3B9
         adc  #$03                 ; B3BA
         sta  $AED0,y              ; B3BC
         lda  $AED8,y              ; B3BF
         adc  #$FC                 ; B3C2
         sta  $AED8,y              ; B3C4
         lda  $AEE0,y              ; B3C7
         adc  #$03                 ; B3CA
         sta  $AEE0,y              ; B3CC
         lda  $AEE8,y              ; B3CF
         adc  #$FB                 ; B3D2
         sta  $AEE8,y              ; B3D4
         dey                       ; B3D7
         bpl  LB3B6                ; B3D8
         rts                       ; B3DA
         dta $E3,$B3,$07,$B4,$2B,$B4,$4F,$B4,$0F,$C0,$00,$3F,$F0,$00,$3F,$F0 ; B3DB
         dta $00,$FF,$FC,$00,$FF,$FC,$00,$FF,$FC,$00,$FF,$FC,$00,$FF,$FC,$00 ; B3EB
         dta $FF,$FC,$00,$3F,$F0,$00,$3F,$F0,$00,$0F,$C0,$00,$03,$F0,$00,$0F ; B3FB
         dta $FC,$00,$0F,$FC,$00,$3F,$FF,$00,$3F,$FF,$00,$3F,$FF,$00,$3F,$FF ; B40B
         dta $00,$3F,$FF,$00,$3F,$FF,$00,$0F,$FC,$00,$0F,$FC,$00,$03,$F0,$00 ; B41B
         dta $00,$FC,$00,$03,$FF,$00,$03,$FF,$00,$0F,$FF,$C0,$0F,$FF,$C0,$0F ; B42B
         dta $FF,$C0,$0F,$FF,$C0,$0F,$FF,$C0,$0F,$FF,$C0,$03,$FF,$00,$03,$FF ; B43B
         dta $00,$00,$FC,$00,$00,$3F,$00,$00,$FF,$C0,$00,$FF,$C0,$03,$FF,$F0 ; B44B
         dta $03,$FF,$F0,$03,$FF,$F0,$03,$FF,$F0,$03,$FF,$F0,$03,$FF,$F0,$00 ; B45B
         dta $FF,$C0,$00,$FF,$C0,$00,$3F,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B46B
         dta $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B47B
         dta $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B48B
         dta $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B49B
         dta $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B4AB
         dta $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B4BB
         dta $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B4CB
         dta $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B4DB
         dta $00,$00,$00                              ; B4EB
