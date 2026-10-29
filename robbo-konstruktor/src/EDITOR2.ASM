; EDITOR2.ASM - editor: jump table $A810, main loop, screen, DLI, text input
; $A810-$B5FF

         org $A810

entry_A810
         jmp  LA9A7                ; A810
entry_A813
         jmp  LB00A                ; A813
entry_A816
         jmp  LB159                ; A816
entry_A819
         jmp  LB16C                ; A819
entry_A81C
         jmp  LACB6                ; A81C
entry_A81F
         jmp  LAC8B                ; A81F
entry_A822
         jmp  LB0BC                ; A822
entry_A825
         jmp  LB17F                ; A825
entry_A828
         jmp  LF556                ; A828
entry_A82B
         jmp  LB023                ; A82B
entry_A82E
         jmp  LB4CD                ; A82E
entry_A831
         jmp  LB3F5                ; A831
entry_A834
         jmp  LB4A2                ; A834
entry_A837
         jmp  LB3BE                ; A837
entry_A83A
         jmp  LB189                ; A83A
entry_A83D
         jmp  LB03B                ; A83D
         dta $00,$00,$00,$00,$00,$00,$10,$F0,$C4,$00,$B6,$C4,$00,$B6,$C4,$28 ; A840
         dta $B6,$C4,$28,$B6,$C4,$50,$B6,$C4,$50,$B6,$C4,$78,$B6,$C4,$78,$B6 ; A850
         dta $C4,$A0,$B6,$C4,$A0,$B6,$C4,$C8,$B6,$C4,$C8,$B6,$C4,$F0,$B6,$C4 ; A860
         dta $F0,$B6,$C4,$18,$B7,$C4,$18,$B7,$C4,$40,$B7,$C4,$40,$B7,$C4,$68 ; A870
         dta $B7,$C4,$68,$B7,$20,$4F,$50,$BD,$0F,$0F,$42,$00,$BC,$02,$02,$02 ; A880
         dta $02,$4F,$00,$BD,$0F,$0F,$0F,$0F,$42,$C8,$BC,$4F,$00,$BD,$0F,$0F ; A890
         dta $41,$46,$A8,$10,$F0,$C4,$00,$B8,$C4,$00,$B8,$C4,$28,$B8,$C4,$28 ; A8A0
         dta $B8,$C4,$50,$B8,$C4,$50,$B8,$C4,$78,$B8,$C4,$78,$B8,$C4,$A0,$B8 ; A8B0
         dta $C4,$A0,$B8,$C4,$C8,$B8,$C4,$C8,$B8,$C4,$F0,$B8,$C4,$F0,$B8,$C4 ; A8C0
         dta $18,$B9,$C4,$18,$B9,$C4,$40,$B9,$C4,$40,$B9,$C4,$68,$B9,$C4,$68 ; A8D0
         dta $B9,$20,$4F,$50,$BD,$0F,$0F,$42,$00,$BC,$02,$02,$02,$02,$4F,$00 ; A8E0
         dta $BD,$0F,$0F,$0F,$0F,$42,$C8,$BC,$4F,$00,$BD,$0F,$0F,$41,$A3,$A8 ; A8F0
         dta $10,$70,$4F,$50,$BD,$0F,$42,$00,$B6,$4F,$78,$BD,$0F,$0F,$42,$28 ; A900
         dta $B6,$02,$02,$02,$02,$02,$02,$02,$4F,$78,$BD,$0F,$0F,$4F,$50,$BD ; A910
         dta $0F,$42,$00,$B8,$4F,$78,$BD,$0F,$0F,$42,$28,$B8,$02,$02,$02,$02 ; A920
         dta $02,$02,$02,$4F,$00,$BD,$0F,$0F,$20,$4F,$50,$BD,$0F,$0F,$42,$00 ; A930
         dta $BC,$02,$02,$02,$02,$4F,$00,$BD,$0F,$0F,$0F,$0F,$42,$C8,$BC,$4F ; A940
         dta $00,$BD,$0F,$0F,$41,$00,$A9,$80,$80,$80,$80,$DD,$80,$80,$80,$80 ; A950
         dta $80,$80,$F4,$E5,$EB,$F3,$F4,$80,$F0,$EF,$E3,$FA,$A0,$F4,$EB,$EF ; A960
         dta $F7,$F9,$9A,$80,$80,$80,$80,$80,$80,$80,$DD,$80,$80,$80,$80,$80 ; A970
         dta $80,$80,$80,$DD,$80,$80,$80,$80,$80,$F4,$E5,$EB,$F3,$F4,$80,$E7 ; A980
         dta $F2,$E1,$F4,$F5,$EC,$E1,$E3,$F9,$EA,$EE,$F9,$9A,$80,$80,$80,$80 ; A990
         dta $80,$80,$DD,$80,$80,$80,$80              ; A9A0
LA9A7
         cli                       ; A9A7
         cld                       ; A9A8
         ldx  #$FF                 ; A9A9
         txs                       ; A9AB
         stx  CH                   ; A9AC
         stx  $A840                ; A9AF
         jsr  sub_AF3E             ; A9B2
LA9B5
         lda  CDTMV3               ; A9B5
         bne  LA9B5                ; A9B8
         lda  #$04                 ; A9BA
         sta  CDTMV3               ; A9BC
         lda  #$FF                 ; A9BF
         sta  CH                   ; A9C1
         inc  $C4                  ; A9C4
         jsr  entry_A81C           ; A9C6
         jsr  sub_94E0             ; A9C9
         jsr  sub_A9D2             ; A9CC
         jmp  LA9B5                ; A9CF
sub_A9D2
         lda  $CA                  ; A9D2
         bmi  LA9D7                ; A9D4
         rts                       ; A9D6
LA9D7
         inc  $B5BB                ; A9D7
         lda  #$00                 ; A9DA
         sta  $AB3E                ; A9DC
         ldx  $C5                  ; A9DF
         ldy  $C6                  ; A9E1
         lda  $C7                  ; A9E3
         sta  $B6                  ; A9E5
         lda  $A840                ; A9E7
         and  #$08                 ; A9EA
         bne  LAA03                ; A9EC
         cpx  #$0F                 ; A9EE
         bne  LA9F7                ; A9F0
         lda  $A843                ; A9F2
         beq  LAA03                ; A9F5
LA9F7
         inx                       ; A9F7
         cpx  #$10                 ; A9F8
         bne  LA9FD                ; A9FA
         inx                       ; A9FC
LA9FD
         cpx  #$14                 ; A9FD
         bcc  LAA03                ; A9FF
         ldx  #$00                 ; AA01
LAA03
         lda  $A840                ; AA03
         and  #$04                 ; AA06
         bne  LAA1D                ; AA08
         txa                       ; AA0A
         bne  LAA12                ; AA0B
         lda  $A843                ; AA0D
         beq  LAA1D                ; AA10
LAA12
         dex                       ; AA12
         cpx  #$10                 ; AA13
         bne  LAA18                ; AA15
         dex                       ; AA17
LAA18
         txa                       ; AA18
         bpl  LAA1D                ; AA19
         ldx  #$13                 ; AA1B
LAA1D
         lda  $A840                ; AA1D
         and  #$02                 ; AA20
         bne  LAA40                ; AA22
         iny                       ; AA24
         cpy  #$0A                 ; AA25
         bcc  LAA40                ; AA27
         dey                       ; AA29
         cpx  #$10                 ; AA2A
         bcc  LAA38                ; AA2C
         lda  #$02                 ; AA2E
         jsr  entry_A825           ; AA30
         bcs  LAA40                ; AA33
         jmp  LAB4D                ; AA35
LAA38
         lda  $C7                  ; AA38
         cmp  #$15                 ; AA3A
         bcs  LAA40                ; AA3C
         inc  $B6                  ; AA3E
LAA40
         lda  $A840                ; AA40
         and  #$01                 ; AA43
         bne  LAA55                ; AA45
         dey                       ; AA47
         bpl  LAA55                ; AA48
         iny                       ; AA4A
         cpx  #$10                 ; AA4B
         bcs  LAA55                ; AA4D
         lda  $C7                  ; AA4F
         beq  LAA55                ; AA51
         dec  $B6                  ; AA53
LAA55
         lda  $B6                  ; AA55
         cmp  $C7                  ; AA57
         bne  LAA63                ; AA59
         cpx  $C5                  ; AA5B
         bne  LAA63                ; AA5D
         cpy  $C6                  ; AA5F
         beq  LAA80                ; AA61
LAA63
         lda  #$00                 ; AA63
         sta  $B5BB                ; AA65
         stx  $C5                  ; AA68
         sty  $C6                  ; AA6A
         lda  $B6                  ; AA6C
         sta  $C7                  ; AA6E
         lda  $A843                ; AA70
         beq  LAA7B                ; AA73
         jsr  entry_A813           ; AA75
         jmp  LAA80                ; AA78
LAA7B
         lda  #$01                 ; AA7B
         sta  $AB3E                ; AA7D
LAA80
         lda  #$FF                 ; AA80
         sta  $A840                ; AA82
         jsr  entry_A82B           ; AA85
         bcs  LAA8D                ; AA88
         jmp  LAB4D                ; AA8A
LAA8D
         cmp  #$27                 ; AA8D
         beq  LAAE2                ; AA8F
         lda  $C5                  ; AA91
         cmp  #$10                 ; AA93
         bcc  LAAED                ; AA95
         lda  #$0D                 ; AA97
         sta  $CE                  ; AA99
         lda  $C6                  ; AA9B
         asl                       ; AA9D
         adc  $C6                  ; AA9E
         sta  $B6                  ; AAA0
         sec                       ; AAA2
         lda  $C5                  ; AAA3
         sbc  #$11                 ; AAA5
         clc                       ; AAA7
         adc  $B6                  ; AAA8
         pha                       ; AAAA
         tax                       ; AAAB
         lda  $B51C,x              ; AAAC
         jsr  sub_94EF             ; AAAF
         pla                       ; AAB2
         tax                       ; AAB3
         lda  $B51C,x              ; AAB4
         bmi  LAAE2                ; AAB7
         cpx  $C9                  ; AAB9
         bne  LAAD8                ; AABB
         cmp  #$00                 ; AABD
         bne  LAB2E                ; AABF
         jsr  entry_A816           ; AAC1
         bne  LAB2E                ; AAC4
         jsr  sub_AC6B             ; AAC6
         ldy  #$00                 ; AAC9
         clc                       ; AACB
         lda  ($B2),y              ; AACC
         adc  #$20                 ; AACE
         sta  ($B2),y              ; AAD0
         jsr  entry_A813           ; AAD2
         jmp  LAB2E                ; AAD5
LAAD8
         jsr  entry_A816           ; AAD8
         bne  LAB2E                ; AADB
         stx  $C9                  ; AADD
         jmp  entry_A813           ; AADF
LAAE2
         jsr  entry_A816           ; AAE2
         bne  LAB2E                ; AAE5
         inc  $B5BA                ; AAE7
         jmp  entry_A813           ; AAEA
LAAED
         lda  #$00                 ; AAED
         jsr  sub_94E9             ; AAEF
         lda  #$0E                 ; AAF2
         sta  $CE                  ; AAF4
         ldx  $C5                  ; AAF6
         clc                       ; AAF8
         lda  $C6                  ; AAF9
         adc  $C7                  ; AAFB
         tay                       ; AAFD
         jsr  sub_AC6F             ; AAFE
         ldx  $C9                  ; AB01
         lda  $B51C,x              ; AB03
         sta  $AB35                ; AB06
         ldy  #$00                 ; AB09
         lda  ($B2),y              ; AB0B
         cmp  #$41                 ; AB0D
         bcc  LAB1D                ; AB0F
         cmp  #$49                 ; AB11
         bcs  LAB1D                ; AB13
         sec                       ; AB15
         sbc  #$41                 ; AB16
         and  #$04                 ; AB18
         clc                       ; AB1A
         adc  #$41                 ; AB1B
LAB1D
         cmp  $AB35                ; AB1D
         beq  LAB3D                ; AB20
         lda  $A841                ; AB22
         cmp  #$0F                 ; AB25
         bne  LAB2F                ; AB27
         jsr  entry_A816           ; AB29
         beq  LAB34                ; AB2C
LAB2E
         rts                       ; AB2E
LAB2F
         lda  $A843                ; AB2F
         bne  LAB2E                ; AB32
LAB34
         lda  #$00                 ; AB34
         ldy  #$00                 ; AB36
         sta  ($B2),y              ; AB38
         jmp  entry_A813           ; AB3A
LAB3D
         lda  #$3D                 ; AB3D
         bne  LAB4A                ; AB3F
         jsr  entry_A816           ; AB41
         bne  LAB2E                ; AB44
         lda  #$20                 ; AB46
         sta  ($B2),y              ; AB48
LAB4A
         jmp  entry_A813           ; AB4A
LAB4D
         jsr  entry_A813           ; AB4D
         ldx  #$00                 ; AB50
         stx  $CA                  ; AB52
         stx  $B5BB                ; AB54
         dex                       ; AB57
         stx  $A840                ; AB58
         lda  $C5                  ; AB5B
         pha                       ; AB5D
         lda  $C6                  ; AB5E
         pha                       ; AB60
         lda  #$1E                 ; AB61
         sta  $C6                  ; AB63
LAB65
         lda  #$0F                 ; AB65
         sta  $C5                  ; AB67
LAB69
         jsr  sub_ABA7             ; AB69
         dec  $C5                  ; AB6C
         bpl  LAB69                ; AB6E
         dec  $C6                  ; AB70
         bpl  LAB65                ; AB72
         pla                       ; AB74
         sta  $C6                  ; AB75
         pla                       ; AB77
         sta  $C5                  ; AB78
         jsr  sub_AC15             ; AB7A
         bcc  LAB89                ; AB7D
         beq  LAB83                ; AB7F
         ora  #$80                 ; AB81
LAB83
         ldx  $CD                  ; AB83
         sta  $39A0,x              ; AB85
         rts                       ; AB88
LAB89
         pha                       ; AB89
         jsr  sub_AC6B             ; AB8A
         pla                       ; AB8D
         jsr  entry_A82E           ; AB8E
         tya                       ; AB91
         ldy  #$01                 ; AB92
         sta  ($B2),y              ; AB94
         dey                       ; AB96
         lda  ($B2),y              ; AB97
         and  #$E0                 ; AB99
         ora  $CD                  ; AB9B
         sta  ($B2),y              ; AB9D
         ldx  $CD                  ; AB9F
         lda  #$01                 ; ABA1
         sta  $39A0,x              ; ABA3
         rts                       ; ABA6
sub_ABA7
         ldx  $C5                  ; ABA7
         ldy  $C6                  ; ABA9
         jsr  sub_AC6F             ; ABAB
         ldy  #$00                 ; ABAE
         lda  ($B2),y              ; ABB0
         cmp  #$41                 ; ABB2
         bcc  LAC08                ; ABB4
         cmp  #$46                 ; ABB6
         bcs  LAC08                ; ABB8
         sec                       ; ABBA
         sbc  #$41                 ; ABBB
         and  #$04                 ; ABBD
         clc                       ; ABBF
         adc  #$41                 ; ABC0
         sta  $B4                  ; ABC2
         ldx  $C5                  ; ABC4
         ldy  $C6                  ; ABC6
         jsr  sub_AC6F             ; ABC8
         sec                       ; ABCB
         lda  $B2                  ; ABCC
         sbc  #$11                 ; ABCE
         sta  $B2                  ; ABD0
         bcs  LABD6                ; ABD2
         dec  $B3                  ; ABD4
LABD6
         ldx  #$03                 ; ABD6
LABD8
         clc                       ; ABD8
         lda  $C5                  ; ABD9
         adc  $AC0D,x              ; ABDB
         cmp  #$10                 ; ABDE
         bcs  LABF7                ; ABE0
         lda  $C6                  ; ABE2
         adc  $AC11,x              ; ABE4
         cmp  #$1F                 ; ABE7
         bcs  LABF7                ; ABE9
         ldy  $AC09,x              ; ABEB
         lda  ($B2),y              ; ABEE
         cmp  #$20                 ; ABF0
         bne  LABF7                ; ABF2
         dex                       ; ABF4
         bne  LABD8                ; ABF5
LABF7
         clc                       ; ABF7
         txa                       ; ABF8
         adc  $B4                  ; ABF9
         pha                       ; ABFB
         ldx  $C5                  ; ABFC
         ldy  $C6                  ; ABFE
         jsr  sub_AC6F             ; AC00
         pla                       ; AC03
         ldy  #$00                 ; AC04
         sta  ($B2),y              ; AC06
LAC08
         rts                       ; AC08
         dta $10,$12,$01,$21,$FF,$01,$00,$00,$00,$00,$FF,$01 ; AC09
sub_AC15
         ldx  #$00                 ; AC15
         ldy  #$00                 ; AC17
         jsr  sub_AC6F             ; AC19
         ldy  #$00                 ; AC1C
LAC1E
         lda  ($B2),y              ; AC1E
         cmp  #$20                 ; AC20
         bne  LAC38                ; AC22
         iny                       ; AC24
         bne  LAC1E                ; AC25
         inc  $B3                  ; AC27
LAC29
         lda  ($B2),y              ; AC29
         cmp  #$20                 ; AC2B
         bne  LAC38                ; AC2D
         iny                       ; AC2F
         cpy  #$F0                 ; AC30
         bcc  LAC29                ; AC32
         lda  #$00                 ; AC34
         beq  LAC68                ; AC36
LAC38
         lda  #$2A                 ; AC38
         jsr  entry_A81F           ; AC3A
         tay                       ; AC3D
         bne  LAC44                ; AC3E
         lda  #$04                 ; AC40
         bne  LAC68                ; AC42
LAC44
         lda  #$06                 ; AC44
         cpy  #$01                 ; AC46
         bne  LAC68                ; AC48
         lda  #$14                 ; AC4A
         jsr  entry_A81F           ; AC4C
         tay                       ; AC4F
         bne  LAC56                ; AC50
         lda  #$05                 ; AC52
         bne  LAC68                ; AC54
LAC56
         lda  #$07                 ; AC56
         cpy  #$01                 ; AC58
         bne  LAC68                ; AC5A
         lda  #$24                 ; AC5C
         jsr  entry_A81F           ; AC5E
         cmp  #$64                 ; AC61
         bcs  LAC66                ; AC63
         rts                       ; AC65
LAC66
         lda  #$08                 ; AC66
LAC68
         tax                       ; AC68
         sec                       ; AC69
         rts                       ; AC6A
sub_AC6B
         ldx  #$00                 ; AC6B
         ldy  #$1F                 ; AC6D
sub_AC6F
         lda  #$00                 ; AC6F
         sta  $B3                  ; AC71
         tya                       ; AC73
         asl                       ; AC74
         asl                       ; AC75
         asl                       ; AC76
         asl                       ; AC77
         rol  $B3                  ; AC78
         sta  $B2                  ; AC7A
         lda  $CD                  ; AC7C
         asl                       ; AC7E
         adc  #$50                 ; AC7F
         adc  $B3                  ; AC81
         sta  $B3                  ; AC83
         txa                       ; AC85
         adc  $B2                  ; AC86
         sta  $B2                  ; AC88
         rts                       ; AC8A
LAC8B
         sta  $B4                  ; AC8B
         lda  #$00                 ; AC8D
         sta  $B6                  ; AC8F
         lda  #$1E                 ; AC91
         sta  $B7                  ; AC93
LAC95
         ldx  #$0F                 ; AC95
LAC97
         ldy  $B7                  ; AC97
         jsr  sub_AC6F             ; AC99
         ldy  #$00                 ; AC9C
         lda  ($B2),y              ; AC9E
         cmp  $B4                  ; ACA0
         bne  LACAA                ; ACA2
         bit  $B6                  ; ACA4
         bmi  LACAA                ; ACA6
         inc  $B6                  ; ACA8
LACAA
         dex                       ; ACAA
         bpl  LAC97                ; ACAB
         dec  $B7                  ; ACAD
         bpl  LAC95                ; ACAF
         lda  $B6                  ; ACB1
         rts                       ; ACB3
         dta $03,$B0                                  ; ACB4
LACB6
         lda  $B5BA                ; ACB6
         and  #$03                 ; ACB9
         asl                       ; ACBB
         asl                       ; ACBC
         asl                       ; ACBD
         adc  #$07                 ; ACBE
         tax                       ; ACC0
         ldy  #$07                 ; ACC1
LACC3
         lda  $B53A,x              ; ACC3
         sta  $B532,y              ; ACC6
         dex                       ; ACC9
         dey                       ; ACCA
         bpl  LACC3                ; ACCB
         lda  #$00                 ; ACCD
         jsr  sub_AEB2             ; ACCF
         lda  #$1D                 ; ACD2
         sta  $B6                  ; ACD4
         lda  #$09                 ; ACD6
         sta  $B7                  ; ACD8
LACDA
         ldx  #$13                 ; ACDA
LACDC
         ldy  $B6                  ; ACDC
         lda  $B51C,y              ; ACDE
         bpl  LACE7                ; ACE1
         lda  #$39                 ; ACE3
         bne  LAD06                ; ACE5
LACE7
         cmp  #$20                 ; ACE7
         bne  LACEF                ; ACE9
         lda  #$31                 ; ACEB
         bne  LAD06                ; ACED
LACEF
         cmp  #$00                 ; ACEF
         bne  LACF9                ; ACF1
         ldy  $CD                  ; ACF3
         bpl  LACF9                ; ACF5
         lda  #$20                 ; ACF7
LACF9
         sec                       ; ACF9
         and  #$7F                 ; ACFA
         sbc  #$20                 ; ACFC
         bcs  LAD02                ; ACFE
         adc  #$60                 ; AD00
LAD02
         tay                       ; AD02
         lda  $B55A,y              ; AD03
LAD06
         ldy  $B6                  ; AD06
         cpy  $C9                  ; AD08
         bne  LAD1B                ; AD0A
         bit  $CA                  ; AD0C
         bpl  LAD1B                ; AD0E
         pha                       ; AD10
         lda  $C4                  ; AD11
         lsr                       ; AD13
         lsr                       ; AD14
         pla                       ; AD15
         bcc  LAD1B                ; AD16
         lda  $B55A                ; AD18
LAD1B
         ldy  $B7                  ; AD1B
         jsr  sub_AEDD             ; AD1D
         dec  $B6                  ; AD20
         dex                       ; AD22
         cpx  #$11                 ; AD23
         bcs  LACDC                ; AD25
         dec  $B7                  ; AD27
         bpl  LACDA                ; AD29
         lda  $B55A                ; AD2B
         ldx  #$10                 ; AD2E
         ldy  #$09                 ; AD30
         jsr  sub_AEDD             ; AD32
         ldy  #$00                 ; AD35
         lda  $B55A                ; AD37
         jsr  sub_AEDD             ; AD3A
         iny                       ; AD3D
         jsr  sub_AEDD             ; AD3E
         lda  $AF36                ; AD41
         sta  $B0                  ; AD44
         lda  $AF37                ; AD46
         sta  $B1                  ; AD49
         lda  #$00                 ; AD4B
         sta  $B6                  ; AD4D
         tay                       ; AD4F
LAD50
         clc                       ; AD50
         lda  $C7                  ; AD51
         adc  #$01                 ; AD53
         lsr                       ; AD55
         lsr                       ; AD56
         cmp  $B6                  ; AD57
         bne  LAD91                ; AD59
         clc                       ; AD5B
         lda  $C7                  ; AD5C
         adc  #$01                 ; AD5E
         cmp  #$04                 ; AD60
         bcc  LAD68                ; AD62
         and  #$03                 ; AD64
         adc  #$03                 ; AD66
LAD68
         asl                       ; AD68
         asl                       ; AD69
         tax                       ; AD6A
LAD6B
         lda  $B5E0,x              ; AD6B
         sta  ($B0),y              ; AD6E
         lda  $B55A                ; AD70
         asl                       ; AD73
         iny                       ; AD74
         sta  ($B0),y              ; AD75
         dey                       ; AD77
         clc                       ; AD78
         lda  #$28                 ; AD79
         adc  $B0                  ; AD7B
         sta  $B0                  ; AD7D
         bcc  LAD83                ; AD7F
         inc  $B1                  ; AD81
LAD83
         inc  $B6                  ; AD83
         lda  $B6                  ; AD85
         cmp  #$08                 ; AD87
         bcs  LADB6                ; AD89
         inx                       ; AD8B
         txa                       ; AD8C
         and  #$03                 ; AD8D
         bne  LAD6B                ; AD8F
LAD91
         lda  #$54                 ; AD91
         ldx  $B6                  ; AD93
         bne  LAD99                ; AD95
         lda  #$5C                 ; AD97
LAD99
         sta  ($B0),y              ; AD99
         lda  $B55A                ; AD9B
         asl                       ; AD9E
         iny                       ; AD9F
         sta  ($B0),y              ; ADA0
         dey                       ; ADA2
         clc                       ; ADA3
         lda  #$28                 ; ADA4
         adc  $B0                  ; ADA6
         sta  $B0                  ; ADA8
         bcc  LADAE                ; ADAA
         inc  $B1                  ; ADAC
LADAE
         inc  $B6                  ; ADAE
         lda  $B6                  ; ADB0
         cmp  #$08                 ; ADB2
         bcc  LAD50                ; ADB4
LADB6
         lda  #$01                 ; ADB6
         jsr  sub_AEB2             ; ADB8
         ldx  #$00                 ; ADBB
         ldy  $C7                  ; ADBD
         jsr  sub_AC6F             ; ADBF
         clc                       ; ADC2
         lda  $B2                  ; ADC3
         adc  #$9F                 ; ADC5
         sta  $B2                  ; ADC7
         lda  $B3                  ; ADC9
         adc  #$00                 ; ADCB
         sta  $B3                  ; ADCD
         lda  #$09                 ; ADCF
         sta  $B6                  ; ADD1
LADD3
         ldx  #$0F                 ; ADD3
LADD5
         ldy  #$00                 ; ADD5
         lda  $CD                  ; ADD7
         bmi  LADE7                ; ADD9
         lda  ($B2),y              ; ADDB
         sec                       ; ADDD
         and  #$7F                 ; ADDE
         sbc  #$20                 ; ADE0
         bcs  LADE6                ; ADE2
         adc  #$60                 ; ADE4
LADE6
         tay                       ; ADE6
LADE7
         lda  $B55A,y              ; ADE7
         ldy  $B6                  ; ADEA
         jsr  sub_AEDD             ; ADEC
         lda  $B2                  ; ADEF
         bne  LADF5                ; ADF1
         dec  $B3                  ; ADF3
LADF5
         dec  $B2                  ; ADF5
         dex                       ; ADF7
         bpl  LADD5                ; ADF8
         dec  $B6                  ; ADFA
         bpl  LADD3                ; ADFC
         lda  #$00                 ; ADFE
         sta  $B5                  ; AE00
         lda  $B4                  ; AE02
         asl                       ; AE04
         asl                       ; AE05
         rol  $B5                  ; AE06
         asl                       ; AE08
         rol  $B5                  ; AE09
         asl                       ; AE0B
         rol  $B5                  ; AE0C
         sta  $B4                  ; AE0E
         lda  #$40                 ; AE10
         adc  $B5                  ; AE12
         sta  $B5                  ; AE14
         lda  #$F0                 ; AE16
         sta  $B2                  ; AE18
         lda  #$43                 ; AE1A
         sta  $B3                  ; AE1C
         lda  #$60                 ; AE1E
LAE20
         cmp  VCOUNT               ; AE20
         bne  LAE20                ; AE23
         ldx  #$46                 ; AE25
         ldy  #$A8                 ; AE27
         lda  $C8                  ; AE29
         cmp  #$B6                 ; AE2B
         php                       ; AE2D
         beq  LAE34                ; AE2E
         ldx  #$A3                 ; AE30
         ldy  #$A8                 ; AE32
LAE34
         stx  SDLSTL               ; AE34
         sty  SDLSTH               ; AE37
         lda  #$22                 ; AE3A
         sta  SDMCTL               ; AE3C
         lda  #$B6                 ; AE3F
         plp                       ; AE41
         bne  LAE46                ; AE42
         lda  #$B8                 ; AE44
LAE46
         sta  $C8                  ; AE46
         lda  $C4                  ; AE48
         lsr                       ; AE4A
         and  #$03                 ; AE4B
         tax                       ; AE4D
         lda  $B5E0,x              ; AE4E
         lda  #$AA                 ; AE51
         sta  $B5BF                ; AE53
         ldy  #$00                 ; AE56
         ldx  #$00                 ; AE58
LAE5A
         lda  $B5C0,x              ; AE5A
         eor  #$FF                 ; AE5D
         and  ($B4),y              ; AE5F
         sta  ($B2),y              ; AE61
         lda  $B5C0,x              ; AE63
         and  $B5BF                ; AE66
         ora  ($B2),y              ; AE69
         sta  ($B2),y              ; AE6B
         inx                       ; AE6D
         iny                       ; AE6E
         cpy  #$10                 ; AE6F
         bcc  LAE5A                ; AE71
         ldy  #$04                 ; AE73
LAE75
         inc  $B3                  ; AE75
         inc  $B5                  ; AE77
         dey                       ; AE79
         bne  LAE75                ; AE7A
         cpx  #$1F                 ; AE7C
         bcc  LAE5A                ; AE7E
         jsr  sub_AC6B             ; AE80
         ldy  #$00                 ; AE83
         tya                       ; AE85
         ldx  $CD                  ; AE86
         bmi  LAE8C                ; AE88
         lda  ($B2),y              ; AE8A
LAE8C
         lsr                       ; AE8C
         pha                       ; AE8D
         and  #$30                 ; AE8E
         sta  $B4                  ; AE90
         sta  $B0                  ; AE92
         ldx  #$48                 ; AE94
         pla                       ; AE96
         and  #$40                 ; AE97
         beq  LAE9D                ; AE99
         inx                       ; AE9B
         inx                       ; AE9C
LAE9D
         stx  $B5                  ; AE9D
         inx                       ; AE9F
         stx  $B1                  ; AEA0
         ldy  #$0F                 ; AEA2
LAEA4
         lda  ($B4),y              ; AEA4
         sta  $43E0,y              ; AEA6
         lda  ($B0),y              ; AEA9
         sta  $47E0,y              ; AEAB
         dey                       ; AEAE
         bpl  LAEA4                ; AEAF
         rts                       ; AEB1
sub_AEB2
         sta  $B6                  ; AEB2
         lda  $C4                  ; AEB4
         and  #$04                 ; AEB6
         bne  LAEBC                ; AEB8
         sta  $B6                  ; AEBA
LAEBC
         ldy  #$2E                 ; AEBC
LAEBE
         jsr  sub_AED2             ; AEBE
         dey                       ; AEC1
         cpy  #$21                 ; AEC2
         bcs  LAEBE                ; AEC4
         ldy  #$06                 ; AEC6
         jsr  sub_AED2             ; AEC8
         ldy  #$54                 ; AECB
         jsr  sub_AED2             ; AECD
         ldy  #$0A                 ; AED0
sub_AED2
         lda  $B55A,y              ; AED2
         and  #$FE                 ; AED5
         ora  $B6                  ; AED7
         sta  $B55A,y              ; AED9
         rts                       ; AEDC
sub_AEDD
         cpy  $C6                  ; AEDD
         bne  LAEFD                ; AEDF
         cpx  $C5                  ; AEE1
         bne  LAEFD                ; AEE3
         sta  $B4                  ; AEE5
         bit  $CA                  ; AEE7
         bpl  LAEFD                ; AEE9
         sta  $AEF5                ; AEEB
         lda  $B5BB                ; AEEE
         and  #$04                 ; AEF1
         php                       ; AEF3
         lda  #$F4                 ; AEF4
         plp                       ; AEF6
         bne  LAEFD                ; AEF7
         and  #$80                 ; AEF9
         ora  #$3F                 ; AEFB
LAEFD
         pha                       ; AEFD
         lda  #$00                 ; AEFE
         sta  $B1                  ; AF00
         tya                       ; AF02
         asl                       ; AF03
         asl                       ; AF04
         asl                       ; AF05
         sta  $B0                  ; AF06
         asl                       ; AF08
         asl                       ; AF09
         rol  $B1                  ; AF0A
         adc  $B0                  ; AF0C
         sta  $B0                  ; AF0E
         bcc  LAF14                ; AF10
         inc  $B1                  ; AF12
LAF14
         txa                       ; AF14
         asl                       ; AF15
         adc  $B0                  ; AF16
         sta  $AF36                ; AF18
         ora  #$01                 ; AF1B
         sta  $AF3B                ; AF1D
         bcc  LAF24                ; AF20
         inc  $B1                  ; AF22
LAF24
         clc                       ; AF24
         lda  $B1                  ; AF25
         adc  $C8                  ; AF27
         sta  $AF37                ; AF29
         sta  $AF3C                ; AF2C
         pla                       ; AF2F
         asl                       ; AF30
         php                       ; AF31
         asl                       ; AF32
         plp                       ; AF33
         ror                       ; AF34
         sta  $AF35                ; AF35
         ora  #$01                 ; AF38
         sta  $AF3A                ; AF3A
         rts                       ; AF3D
sub_AF3E
         lda  #$00                 ; AF3E
         bne  LAF5C                ; AF40
         inc  $AF3F                ; AF42
         sta  $CA                  ; AF45
         ldx  #$D0                 ; AF47
LAF49
         sta  $00,x                ; AF49
         dex                       ; AF4B
         cpx  #$B0                 ; AF4C
         bcs  LAF49                ; AF4E
         lda  #$0C                 ; AF50
         sta  $C9                  ; AF52
         lda  #$12                 ; AF54
         sta  $C5                  ; AF56
         lda  #$09                 ; AF58
         sta  $C6                  ; AF5A
LAF5C
         lda  #$00                 ; AF5C
         sta  SDMCTL               ; AF5E
         sta  DMACTL               ; AF61
         sta  $00                  ; AF64
         jsr  sub_B003             ; AF66
         lda  #$FF                 ; AF69
         ldx  #$10                 ; AF6B
LAF6D
         sta  HPOSP0,x             ; AF6D
         dex                       ; AF70
         bpl  LAF6D                ; AF71
         jsr  sub_AC6B             ; AF73
         ldy  #$06                 ; AF76
         ldx  #$08                 ; AF78
LAF7A
         lda  #$00                 ; AF7A
         sta  AUDF1,x              ; AF7C
         lda  #$00                 ; AF7F
         beq  LAF85                ; AF81
         lda  ($B2),y              ; AF83
LAF85
         sta  $02C0,x              ; AF85
         sta  COLPM0,x             ; AF88
         dex                       ; AF8B
         bpl  LAF7A                ; AF8C
         lda  #$03                 ; AF8E
         sta  SKCTL                ; AF90
         sta  $AF80                ; AF93
         lda  #$14                 ; AF96
         sta  $02D9                ; AF98
         lda  #$03                 ; AF9B
         sta  $02DA                ; AF9D
         lda  #$5F                 ; AFA0
         sta  VDSLST               ; AFA2
         lda  #$B0                 ; AFA5
         sta  VDSLST+1             ; AFA7
         lda  #$C0                 ; AFAA
         sta  NMIEN                ; AFAC
         lda  #$4C                 ; AFAF
         sta  CHBAS                ; AFB1
         ldx  #$00                 ; AFB4
LAFB6
         lda  #$00                 ; AFB6
         sta  $BD00,x              ; AFB8
         cpx  #$28                 ; AFBB
         bcs  LAFC4                ; AFBD
         lda  #$55                 ; AFBF
         sta  $BD50,x              ; AFC1
LAFC4
         dex                       ; AFC4
         bne  LAFB6                ; AFC5
         stx  $BD00                ; AFC7
         lda  #$55                 ; AFCA
         sta  $BD50                ; AFCC
         jsr  sub_94E3             ; AFCF
         lda  #$B6                 ; AFD2
         sta  $C8                  ; AFD4
         ldx  #$02                 ; AFD6
LAFD8
         lda  $B5BC,x              ; AFD8
         sta  HPOSP0,x             ; AFDB
         dex                       ; AFDE
         bpl  LAFD8                ; AFDF
         inx                       ; AFE1
         stx  $D009                ; AFE2
         lda  #$FE                 ; AFE5
         sta  $D00E                ; AFE7
         lda  #$04                 ; AFEA
         sta  GPRIOR               ; AFEC
         lda  #$00                 ; AFEF
         sta  IRQEN                ; AFF1
         jsr  entry_A816           ; AFF4
         lda  #$01                 ; AFF7
         sta  $CE                  ; AFF9
         jsr  sub_94F5             ; AFFB
         lda  #$60                 ; AFFE
         sta  $AFF7                ; B000
sub_B003
         lda  RTCLOK+2             ; B003
LB005
         cmp  RTCLOK+2             ; B005
         beq  LB005                ; B007
         rts                       ; B009
LB00A
         lda  #$00                 ; B00A
         sta  AUDF1                ; B00C
         lda  #$64                 ; B00F
         sta  AUDC1                ; B011
         ldx  #$04                 ; B014
LB016
         ldy  #$00                 ; B016
LB018
         dey                       ; B018
         bne  LB018                ; B019
         dex                       ; B01B
         bne  LB016                ; B01C
         stx  AUDC1                ; B01E
         rts                       ; B021
         dta $00                                      ; B022
LB023
         jsr  entry_A819           ; B023
         bcc  LB02D                ; B026
LB028
         sta  $B022                ; B028
         sec                       ; B02B
         rts                       ; B02C
LB02D
         cmp  #$1C                 ; B02D
         bne  LB028                ; B02F
         cmp  $B022                ; B031
         beq  LB028                ; B034
         sta  $B022                ; B036
         clc                       ; B039
         rts                       ; B03A
LB03B
         jsr  entry_A822           ; B03B
         jsr  entry_A816           ; B03E
         beq  LB051                ; B041
         jsr  entry_A82B           ; B043
         bcc  LB055                ; B046
         lda  $A840                ; B048
         cmp  #$FF                 ; B04B
         bne  LB055                ; B04D
         sec                       ; B04F
         rts                       ; B050
LB051
         lda  #$00                 ; B051
         beq  LB057                ; B053
LB055
         lda  #$FF                 ; B055
LB057
         clc                       ; B057
         ldx  #$FF                 ; B058
         stx  $A840                ; B05A
         tax                       ; B05D
         rts                       ; B05E
irq_B05F
         cld                       ; B05F
         pha                       ; B060
         lda  VCOUNT               ; B061
         cmp  #$0C                 ; B064
         bcs  LB085                ; B066
         lda  #$00                 ; B068
         sta  $00                  ; B06A
         lda  $00                  ; B06C
         lsr                       ; B06E
         lda  #$40                 ; B06F
         bcc  LB075                ; B071
         adc  #$03                 ; B073
LB075
         sta  CHBASE               ; B075
         inc  $00                  ; B078
         lda  $02C3                ; B07A
         sta  WSYNC                ; B07D
         sta  COLBK                ; B080
         pla                       ; B083
         rti                       ; B084
LB085
         lda  $00                  ; B085
         lsr                       ; B087
         lda  #$40                 ; B088
         bcc  LB08E                ; B08A
         adc  #$03                 ; B08C
LB08E
         sta  CHBASE               ; B08E
         inc  $00                  ; B091
         lda  $00                  ; B093
         cmp  #$15                 ; B095
         bcc  LB0BA                ; B097
         lda  COLOR4               ; B099
         sta  COLBK                ; B09C
         sta  COLPM0               ; B09F
         sta  $D013                ; B0A2
         sta  $D014                ; B0A5
         lda  #$00                 ; B0A8
         sta  COLPF2               ; B0AA
         lda  #$0A                 ; B0AD
         sta  COLPF1               ; B0AF
         lda  #$4C                 ; B0B2
         sta  CHBASE               ; B0B4
         jsr  entry_A822           ; B0B7
LB0BA
         pla                       ; B0BA
         rti                       ; B0BB
LB0BC
         lsr  $4D                  ; B0BC
         jsr  entry_A819           ; B0BE
         bcs  LB0CA                ; B0C1
         sec                       ; B0C3
         sbc  #$0C                 ; B0C4
         beq  LB0CA                ; B0C6
         sbc  #$15                 ; B0C8
LB0CA
         beq  LB0CE                ; B0CA
         lda  #$01                 ; B0CC
LB0CE
         sta  $B0D8                ; B0CE
         lda  SKCTL                ; B0D1
         lsr                       ; B0D4
         lsr                       ; B0D5
         lsr                       ; B0D6
         and  #$00                 ; B0D7
         and  TRIG0                ; B0D9
         and  $D011                ; B0DC
         and  CONSOL               ; B0DF
         sta  $A843                ; B0E2
         cmp  $A845                ; B0E5
         beq  LB0ED                ; B0E8
         sta  $A844                ; B0EA
LB0ED
         lda  $A843                ; B0ED
         sta  $A845                ; B0F0
         lda  $A842                ; B0F3
         bmi  LB0FB                ; B0F6
         dec  $A842                ; B0F8
LB0FB
         txa                       ; B0FB
         pha                       ; B0FC
         ldx  #$00                 ; B0FD
         jsr  entry_A819           ; B0FF
         bcs  LB10E                ; B102
         ldx  #$04                 ; B104
LB106
         cmp  $B512,x              ; B106
         beq  LB10E                ; B109
         dex                       ; B10B
         bne  LB106                ; B10C
LB10E
         lda  $B517,x              ; B10E
         eor  #$0F                 ; B111
         sta  $B123                ; B113
         pla                       ; B116
         tax                       ; B117
         lda  PORTA                ; B118
         lsr                       ; B11B
         lsr                       ; B11C
         lsr                       ; B11D
         lsr                       ; B11E
         and  PORTA                ; B11F
         and  #$00                 ; B122
         cmp  $A841                ; B124
         bne  LB12E                ; B127
         bit  $A842                ; B129
         bpl  LB158                ; B12C
LB12E
         bit  $A840                ; B12E
         bpl  LB158                ; B131
         cmp  $A841                ; B133
         pha                       ; B136
         php                       ; B137
         lda  $B511                ; B138
         plp                       ; B13B
         beq  LB141                ; B13C
         lda  $B510                ; B13E
LB141
         sta  $A842                ; B141
         lda  $A841                ; B144
         sta  $B17E                ; B147
         pla                       ; B14A
         cmp  #$0F                 ; B14B
         beq  LB155                ; B14D
         sta  $A844                ; B14F
         sta  $A840                ; B152
LB155
         sta  $A841                ; B155
LB158
         rts                       ; B158
LB159
         lda  $A844                ; B159
         bne  LB16B                ; B15C
         lda  #$FF                 ; B15E
         sta  $A844                ; B160
         sta  $A840                ; B163
         lda  #$00                 ; B166
         sta  $B5BB                ; B168
LB16B
         rts                       ; B16B
LB16C
         lda  SKCTL                ; B16C
         and  #$04                 ; B16F
         bne  LB17A                ; B171
         lda  KBCODE               ; B173
         and  #$3F                 ; B176
         clc                       ; B178
         rts                       ; B179
LB17A
         lda  #$FF                 ; B17A
         sec                       ; B17C
         rts                       ; B17D
         dta $00                                      ; B17E
LB17F
         clc                       ; B17F
         and  $B17E                ; B180
         bne  LB186                ; B183
         sec                       ; B185
LB186
         rts                       ; B186
         dta $00,$00                                  ; B187
LB189
         lda  #$1D                 ; B189
         jsr  sub_94E9             ; B18B
         jsr  sub_94F2             ; B18E
         lda  $B187                ; B191
         sta  $B4                  ; B194
         lda  $B188                ; B196
         sta  $B5                  ; B199
LB19B
         jsr  sub_B34C             ; B19B
         ldx  #$00                 ; B19E
         ldy  #$A9                 ; B1A0
         jsr  entry_A837           ; B1A2
         lda  #$40                 ; B1A5
         sta  IRQEN                ; B1A7
         jsr  LB1C3                ; B1AA
         bcc  LB19B                ; B1AD
         lda  #$00                 ; B1AF
         sta  IRQEN                ; B1B1
         lda  $B5                  ; B1B4
         sta  $B188                ; B1B6
         lda  $B4                  ; B1B9
         sta  $B187                ; B1BB
         jsr  sub_94F2             ; B1BE
         sec                       ; B1C1
         rts                       ; B1C2
LB1C3
         lda  #$00                 ; B1C3
         sta  $B2                  ; B1C5
         lda  #$3A                 ; B1C7
         sta  $B3                  ; B1C9
         jsr  sub_B2F4             ; B1CB
         lda  $B5                  ; B1CE
         sta  $B2                  ; B1D0
         ldy  #$00                 ; B1D2
         lda  ($B2),y              ; B1D4
         ora  #$80                 ; B1D6
         sta  ($B2),y              ; B1D8
         jsr  sub_B34C             ; B1DA
         ldy  #$00                 ; B1DD
         lda  ($B2),y              ; B1DF
         and  #$7F                 ; B1E1
         sta  ($B2),y              ; B1E3
         jsr  entry_A819           ; B1E5
         bcs  LB1F3                ; B1E8
         cmp  #$11                 ; B1EA
         bne  LB1F3                ; B1EC
         jsr  sub_94F5             ; B1EE
         clc                       ; B1F1
         rts                       ; B1F2
LB1F3
         jsr  entry_A822           ; B1F3
         jsr  entry_A816           ; B1F6
         bne  LB206                ; B1F9
         lda  TRIG0                ; B1FB
         and  $D011                ; B1FE
         and  CONSOL               ; B201
         beq  LB20B                ; B204
LB206
         jsr  entry_A82B           ; B206
         bcs  LB210                ; B209
LB20B
         jsr  entry_A813           ; B20B
         sec                       ; B20E
         rts                       ; B20F
LB210
         ldx  CH                   ; B210
         cpx  #$FF                 ; B213
         beq  LB1C3                ; B215
         lda  #$FF                 ; B217
         sta  CH                   ; B219
         lda  $FB51,x              ; B21C
         sta  $B244                ; B21F
         lda  $B244                ; B222
         ldx  #$00                 ; B225
LB227
         cmp  $B330,x              ; B227
         bne  LB23B                ; B22A
         lda  $B331,x              ; B22C
         sta  $B239                ; B22F
         lda  $B332,x              ; B232
         sta  $B23A                ; B235
         jmp  $B238                ; B238
LB23B
         inx                       ; B23B
         inx                       ; B23C
         inx                       ; B23D
         ldy  $B330,x              ; B23E
         bne  LB227                ; B241
         lda  #$00                 ; B243
         jsr  sub_B2FD             ; B245
         bcc  LB24D                ; B248
         jmp  LB1C3                ; B24A
LB24D
         jsr  entry_A834           ; B24D
         ldy  #$00                 ; B250
         sta  ($B2),y              ; B252
entry_B254
         inc  $B5                  ; B254
         jmp  LB275                ; B256
entry_B259
         dec  $B5                  ; B259
         jmp  LB275                ; B25B
entry_B25E
         sec                       ; B25E
         lda  $B5                  ; B25F
         sbc  #$20                 ; B261
         sta  $B5                  ; B263
         bcs  LB275                ; B265
         bcc  LB272                ; B267
entry_B269
         clc                       ; B269
         lda  $B5                  ; B26A
         adc  #$20                 ; B26C
         sta  $B5                  ; B26E
         bcc  LB275                ; B270
LB272
         jsr  sub_B2ED             ; B272
LB275
         jsr  entry_A813           ; B275
         jmp  LB1C3                ; B278
entry_B27B
         lda  $B5                  ; B27B
         bne  LB282                ; B27D
         jmp  LB1C3                ; B27F
LB282
         dec  $B5                  ; B282
         lda  $B5                  ; B284
         sta  $B2                  ; B286
         ldy  #$00                 ; B288
         tya                       ; B28A
         sta  ($B2),y              ; B28B
         jmp  LB275                ; B28D
entry_B290
         lda  #$00                 ; B290
         sta  $B2                  ; B292
         dec  $B5                  ; B294
         ldy  $B5                  ; B296
         cpy  #$FE                 ; B298
         beq  LB2A9                ; B29A
         ldy  #$FE                 ; B29C
LB29E
         lda  ($B2),y              ; B29E
         iny                       ; B2A0
         sta  ($B2),y              ; B2A1
         dey                       ; B2A3
         dey                       ; B2A4
         cpy  $B5                  ; B2A5
         bne  LB29E                ; B2A7
LB2A9
         iny                       ; B2A9
         lda  #$00                 ; B2AA
         sta  ($B2),y              ; B2AC
         inc  $B5                  ; B2AE
         jmp  LB275                ; B2B0
entry_B2B3
         lda  #$00                 ; B2B3
         sta  $B2                  ; B2B5
         ldy  $B5                  ; B2B7
         iny                       ; B2B9
LB2BA
         lda  ($B2),y              ; B2BA
         dey                       ; B2BC
         sta  ($B2),y              ; B2BD
         iny                       ; B2BF
         beq  LB2C5                ; B2C0
         iny                       ; B2C2
         bne  LB2BA                ; B2C3
LB2C5
         dey                       ; B2C5
         lda  #$00                 ; B2C6
         sta  ($B2),y              ; B2C8
         jmp  LB275                ; B2CA
entry_B2CD
         clc                       ; B2CD
         lda  $B5                  ; B2CE
         adc  #$20                 ; B2D0
         and  #$E0                 ; B2D2
         sta  $B5                  ; B2D4
         bcc  LB2DB                ; B2D6
         jsr  sub_B2ED             ; B2D8
LB2DB
         jmp  LB275                ; B2DB
entry_B2DE
         ldy  #$00                 ; B2DE
         sty  $B2                  ; B2E0
         sty  $B5                  ; B2E2
         tya                       ; B2E4
LB2E5
         sta  ($B2),y              ; B2E5
         dey                       ; B2E7
         bne  LB2E5                ; B2E8
         jmp  LB275                ; B2EA
sub_B2ED
         lda  $B4                  ; B2ED
         eor  #$01                 ; B2EF
         sta  $B4                  ; B2F1
         rts                       ; B2F3
sub_B2F4
         lda  $B3                  ; B2F4
         and  #$FE                 ; B2F6
         ora  $B4                  ; B2F8
         sta  $B3                  ; B2FA
         rts                       ; B2FC
sub_B2FD
         ldx  #$00                 ; B2FD
LB2FF
         ldy  $B4F9,x              ; B2FF
         bmi  LB30C                ; B302
         cmp  $B4F9,x              ; B304
         beq  LB32C                ; B307
         inx                       ; B309
         bpl  LB2FF                ; B30A
LB30C
         cmp  #$20                 ; B30C
         beq  LB32C                ; B30E
         cmp  #$21                 ; B310
         beq  LB32C                ; B312
         cmp  #$2C                 ; B314
         bcc  LB32E                ; B316
         cmp  #$3B                 ; B318
         bcc  LB32C                ; B31A
         cmp  #$3F                 ; B31C
         bcc  LB32E                ; B31E
         cmp  #$5B                 ; B320
         bcc  LB32C                ; B322
         cmp  #$61                 ; B324
         bcc  LB32E                ; B326
         cmp  #$7B                 ; B328
         bcs  LB32E                ; B32A
LB32C
         clc                       ; B32C
         rts                       ; B32D
LB32E
         sec                       ; B32E
         rts                       ; B32F
         dta $1E,$59,$B2,$1F,$54,$B2,$1C,$5E,$B2,$1D,$69,$B2,$7E,$7B,$B2,$FE ; B330
         dta $B3,$B2,$FF,$90,$B2,$7D,$DE,$B2,$9B,$CD,$B2,$00 ; B340
sub_B34C
         ldy  #$27                 ; B34C
LB34E
         lda  $A957,y              ; B34E
         sta  $B600,y              ; B351
         lda  $A97F,y              ; B354
         sta  $B800,y              ; B357
         dey                       ; B35A
         bpl  LB34E                ; B35B
         lda  #$60                 ; B35D
LB35F
         cmp  VCOUNT               ; B35F
         bne  LB35F                ; B362
         lda  #$00                 ; B364
         sta  $B6                  ; B366
         lda  #$3A                 ; B368
         sta  $B7                  ; B36A
         lda  #$28                 ; B36C
         sta  $B0                  ; B36E
         lda  #$B6                 ; B370
         sta  $B1                  ; B372
         ldx  #$02                 ; B374
LB376
         lda  #$00                 ; B376
         ldy  #$27                 ; B378
LB37A
         sta  ($B0),y              ; B37A
         dey                       ; B37C
         cpy  #$24                 ; B37D
         bcs  LB37A                ; B37F
         ldy  #$03                 ; B381
LB383
         sta  ($B0),y              ; B383
         dey                       ; B385
         bpl  LB383                ; B386
         clc                       ; B388
         lda  $B0                  ; B389
         adc  #$04                 ; B38B
         sta  $B0                  ; B38D
         bcc  LB393                ; B38F
         inc  $B1                  ; B391
LB393
         ldy  #$1F                 ; B393
LB395
         lda  ($B6),y              ; B395
         sta  ($B0),y              ; B397
         dey                       ; B399
         bpl  LB395                ; B39A
         clc                       ; B39C
         lda  $B0                  ; B39D
         adc  #$24                 ; B39F
         sta  $B0                  ; B3A1
         bcc  LB3A7                ; B3A3
         inc  $B1                  ; B3A5
LB3A7
         clc                       ; B3A7
         lda  $B6                  ; B3A8
         adc  #$20                 ; B3AA
         sta  $B6                  ; B3AC
         bcc  LB376                ; B3AE
         inc  $B7                  ; B3B0
         lda  #$28                 ; B3B2
         sta  $B0                  ; B3B4
         lda  #$B8                 ; B3B6
         sta  $B1                  ; B3B8
         dex                       ; B3BA
         bne  LB376                ; B3BB
         rts                       ; B3BD
LB3BE
         jsr  sub_B003             ; B3BE
         stx  SDLSTL               ; B3C1
         stx  DLISTL               ; B3C4
         sty  SDLSTH               ; B3C7
         sty  DLISTH               ; B3CA
         lda  COLOR4               ; B3CD
         ldx  #$08                 ; B3D0
LB3D2
         sta  $02C0,x              ; B3D2
         sta  COLPM0,x             ; B3D5
         dex                       ; B3D8
         bpl  LB3D2                ; B3D9
         lda  #$0A                 ; B3DB
         sta  COLOR1               ; B3DD
         sta  COLPF1               ; B3E0
         lda  #$00                 ; B3E3
         sta  COLOR2               ; B3E5
         sta  COLPF2               ; B3E8
         lda  #$22                 ; B3EB
         sta  SDMCTL               ; B3ED
         sta  DMACTL               ; B3F0
         rts                       ; B3F3
         dta $00                                      ; B3F4
LB3F5
         lda  $B3F4                ; B3F5
         and  #$01                 ; B3F8
         tax                       ; B3FA
         ldy  #$28                 ; B3FB
LB3FD
         dey                       ; B3FD
LB3FE
         lda  $BCC8,y              ; B3FE
         and  #$7F                 ; B401
         beq  LB3FD                ; B403
         bne  LB408                ; B405
LB407
         dey                       ; B407
LB408
         lda  $BCC8,y              ; B408
         and  #$7F                 ; B40B
         bne  LB407                ; B40D
         dex                       ; B40F
         bpl  LB3FE                ; B410
         lda  $BCC8,y              ; B412
         bmi  LB43A                ; B415
         ldx  #$27                 ; B417
LB419
         lda  $BCC8,x              ; B419
         and  #$7F                 ; B41C
         sta  $BCC8,x              ; B41E
         dex                       ; B421
         bpl  LB419                ; B422
LB424
         lda  $BCC8,y              ; B424
         ora  #$80                 ; B427
         sta  $BCC8,y              ; B429
         iny                       ; B42C
         lda  $BCC8,y              ; B42D
         bne  LB424                ; B430
         lda  $BCC8,y              ; B432
         ora  #$80                 ; B435
         sta  $BCC8,y              ; B437
LB43A
         lda  $A840                ; B43A
         cmp  #$FF                 ; B43D
         beq  LB459                ; B43F
         and  #$04                 ; B441
         beq  LB44C                ; B443
         lda  $A840                ; B445
         and  #$08                 ; B448
         bne  LB455                ; B44A
LB44C
         inc  $B3F4                ; B44C
         jsr  entry_A813           ; B44F
         jmp  LB459                ; B452
LB455
         lda  #$78                 ; B455
         bne  LB474                ; B457
LB459
         jsr  entry_A816           ; B459
         beq  LB468                ; B45C
         jsr  entry_A82B           ; B45E
         bcc  LB464                ; B461
         rts                       ; B463
LB464
         lda  #$78                 ; B464
         bne  LB474                ; B466
LB468
         ldx  #$6E                 ; B468
         lda  $B3F4                ; B46A
         and  #$01                 ; B46D
         beq  LB473                ; B46F
         ldx  #$79                 ; B471
LB473
         txa                       ; B473
LB474
         pha                       ; B474
         lda  #$00                 ; B475
         sta  $B3F4                ; B477
         jsr  entry_A813           ; B47A
         lda  #$00                 ; B47D
         bmi  LB49B                ; B47F
         lsr  $B48C                ; B481
         lsr  $B492                ; B484
         ldx  #$FF                 ; B487
         txa                       ; B489
LB48A
         eor  $0A00,x              ; B48A
         dex                       ; B48D
         bne  LB48A                ; B48E
         cmp  $0440                ; B490
         beq  LB49B                ; B493
         lda  entry_A810           ; B495
         sta  $ACB3                ; B498
LB49B
         sec                       ; B49B
         ror  $B47E                ; B49C
         pla                       ; B49F
         clc                       ; B4A0
         rts                       ; B4A1
LB4A2
         stx  $B4CB                ; B4A2
         sty  $B4C9                ; B4A5
         asl                       ; B4A8
         php                       ; B4A9
         lsr                       ; B4AA
         ldx  #$FF                 ; B4AB
LB4AD
         inx                       ; B4AD
         ldy  $B4F9,x              ; B4AE
         bmi  LB4BB                ; B4B1
         cmp  $B4F9,x              ; B4B3
         bne  LB4AD                ; B4B6
         lda  $B505,x              ; B4B8
LB4BB
         asl                       ; B4BB
         cmp  #$C0                 ; B4BC
         bcs  LB4C6                ; B4BE
         sbc  #$3E                 ; B4C0
         bcs  LB4C6                ; B4C2
         adc  #$C0                 ; B4C4
LB4C6
         plp                       ; B4C6
         ror                       ; B4C7
         ldy  #$00                 ; B4C8
         ldx  #$00                 ; B4CA
         rts                       ; B4CC
LB4CD
         sta  $B6                  ; B4CD
         lda  #$00                 ; B4CF
         sta  $B7                  ; B4D1
         ldx  #$07                 ; B4D3
         sed                       ; B4D5
LB4D6
         asl  $B6                  ; B4D6
         adc  $B7                  ; B4D8
         sta  $B7                  ; B4DA
         dex                       ; B4DC
         bpl  LB4D6                ; B4DD
         cld                       ; B4DF
         lda  $B7                  ; B4E0
         tay                       ; B4E2
         pha                       ; B4E3
         jsr  sub_B4ED             ; B4E4
         tax                       ; B4E7
         pla                       ; B4E8
         lsr                       ; B4E9
         lsr                       ; B4EA
         lsr                       ; B4EB
         lsr                       ; B4EC
sub_B4ED
         and  #$0F                 ; B4ED
         clc                       ; B4EF
         adc  #$10                 ; B4F0
         cmp  #$1A                 ; B4F2
         bcc  LB4F8                ; B4F4
         adc  #$46                 ; B4F6
LB4F8
         rts                       ; B4F8
         dta $40,$2F,$2A,$01,$03,$05,$0C,$0E,$0F,$13,$1A,$A0,$2F,$3F,$00,$40 ; B4F9
         dta $5B,$5C,$5D,$5E,$5F,$7B,$7C,$10,$03,$00,$07,$06,$0E,$0F,$00,$08 ; B509
         dta $04,$01,$02,$2A,$24,$14,$23,$12,$06,$21,$25,$40,$28,$26,$29,$00 ; B519
         dta $3D,$13,$20,$41,$45,$3F,$2E,$0E,$A0,$78,$78,$78,$78,$78,$78,$78 ; B529
         dta $78,$4E,$4A,$1F,$3E,$01,$31,$32,$33,$4D,$4C,$1D,$22,$17,$34,$35 ; B539
         dta $36,$4E,$49,$1E,$3C,$04,$31,$32,$33,$4D,$4B,$1C,$5E,$18,$34,$35 ; B549
         dta $36,$3A,$24,$1B,$A7,$29,$00,$02,$00,$25,$26,$22,$00,$00,$00,$3C ; B559
         dta $00,$00,$B2,$B3,$B4,$B5,$B6,$B7,$00,$00,$00,$00,$00,$1E,$30,$18 ; B569
         dta $28,$01,$04,$04,$04,$04,$06,$06,$06,$06,$0E,$0A,$08,$0C,$90,$92 ; B579
         dta $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$15 ; B589
         dta $00,$BE,$19,$00,$00,$1F,$00,$27,$00,$00,$00,$00,$00,$00,$00,$BB ; B599
         dta $00,$00,$00,$B8,$3D,$20,$00,$00,$1C,$16,$00,$00,$00,$14,$1A,$1D ; B5A9
         dta $17,$00,$00,$10,$B0,$D1,$00,$FF,$FF,$C0,$C0,$C0,$C0,$C0,$C0,$FF ; B5B9
         dta $FF,$03,$03,$03,$03,$03,$03,$C0,$C0,$C0,$C0,$C0,$C0,$FF,$FF,$03 ; B5C9
         dta $03,$03,$03,$03,$03,$FF,$FF,$AA,$55,$AA,$55,$5F,$58,$59,$54,$5E ; B5D9
         dta $58,$58,$54,$5D,$58,$58,$5B,$58,$58,$5A,$54,$57,$58,$59,$54,$56 ; B5E9
         dta $58,$58,$54,$55,$58,$58,$5B              ; B5F9
