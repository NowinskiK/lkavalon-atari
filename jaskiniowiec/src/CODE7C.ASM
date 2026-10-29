; CODE7C.ASM - code and tables
; $7C00-$8DEF

         org $7C00

         dta $4C,$7B,$7C                              ; 7C00
sub_7C03
         stx  $C0                  ; 7C03
         sty  $C1                  ; 7C05
         ldy  #$00                 ; 7C07
         lda  ($C0),y              ; 7C09
         sta  $8858                ; 7C0B
         sta  $886A                ; 7C0E
         iny                       ; 7C11
         lda  ($C0),y              ; 7C12
         sta  $8854                ; 7C14
         sta  $886E                ; 7C17
         iny                       ; 7C1A
         lda  ($C0),y              ; 7C1B
         sta  $8850                ; 7C1D
         iny                       ; 7C20
         lda  ($C0),y              ; 7C21
         sta  $884C                ; 7C23
         iny                       ; 7C26
         lda  ($C0),y              ; 7C27
         sta  $8833                ; 7C29
         iny                       ; 7C2C
         lda  ($C0),y              ; 7C2D
         sta  $8835                ; 7C2F
         iny                       ; 7C32
         lda  ($C0),y              ; 7C33
         sta  $883C                ; 7C35
         iny                       ; 7C38
         lda  ($C0),y              ; 7C39
         sta  $883E                ; 7C3B
         ldy  #$7F                 ; 7C3E
         lda  #$00                 ; 7C40
L7C42
         sta  $C400,y              ; 7C42
         sta  $C480,y              ; 7C45
         dey                       ; 7C48
         bpl  L7C42                ; 7C49
         ldx  $AA                  ; 7C4B
         dex                       ; 7C4D
         bne  L7C53                ; 7C4E
         jmp  L882C                ; 7C50
L7C53
         ldy  #$00                 ; 7C53
         lda  #$00                 ; 7C55
L7C57
         sta  L8E80,y              ; 7C57
         iny                       ; 7C5A
         bne  L7C57                ; 7C5B
         jmp  L882C                ; 7C5D
         dta $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 7C60
         dta $04,$08,$A0,$A4,$A8,$60,$40,$00,$10,$30,$70 ; 7C70
L7C7B
         jsr  sub_7C84             ; 7C7B
         jsr  L882C                ; 7C7E
         jmp  L87CC                ; 7C81
sub_7C84
         lda  #$FF                 ; 7C84
         sta  $E0                  ; 7C86
         lda  #$00                 ; 7C88
         sta  $E4                  ; 7C8A
L7C8C
         inc  $E0                  ; 7C8C
         ldx  $E0                  ; 7C8E
         cpx  #$04                 ; 7C90
         bcc  L7C95                ; 7C92
         rts                       ; 7C94
L7C95
         txa                       ; 7C95
         clc                       ; 7C96
         adc  #$70                 ; 7C97
         tay                       ; 7C99
         lda  $7C64,x              ; 7C9A
         sta  ($84),y              ; 7C9D
         beq  L7C8C                ; 7C9F
         sta  $E2                  ; 7CA1
         lda  $7C60,x              ; 7CA3
         sta  $E1                  ; 7CA6
         lda  $7C68,x              ; 7CA8
         sta  $E3                  ; 7CAB
         lda  $7C6C,x              ; 7CAD
         asl                       ; 7CB0
         tay                       ; 7CB1
         lda  $C800,y              ; 7CB2
         sta  $C4                  ; 7CB5
         lda  $C801,y              ; 7CB7
         sta  $C6                  ; 7CBA
         lda  $C840,y              ; 7CBC
         sta  $C5                  ; 7CBF
         lda  $C841,y              ; 7CC1
         sta  $C7                  ; 7CC4
         lda  #$20                 ; 7CC6
         cpy  #$20                 ; 7CC8
         bcc  L7CCE                ; 7CCA
         lda  #$10                 ; 7CCC
L7CCE
         sta  $7EB7                ; 7CCE
         inx                       ; 7CD1
         txa                       ; 7CD2
         asl                       ; 7CD3
         asl                       ; 7CD4
         asl                       ; 7CD5
         sta  $E5                  ; 7CD6
         bit  $E3                  ; 7CD8
         bmi  L7CDE                ; 7CDA
         bpl  L7CEC                ; 7CDC
L7CDE
         bvc  L7CE6                ; 7CDE
         jsr  sub_7FE1             ; 7CE0
         jmp  L7CF7                ; 7CE3
L7CE6
         jsr  sub_8243             ; 7CE6
         jmp  L7CF7                ; 7CE9
L7CEC
         bvc  L7CF4                ; 7CEC
         jsr  sub_84E9             ; 7CEE
         jmp  L7CF7                ; 7CF1
L7CF4
         jsr  sub_864B             ; 7CF4
L7CF7
         lda  $E1                  ; 7CF7
         and  #$03                 ; 7CF9
         tay                       ; 7CFB
         asl                       ; 7CFC
         tax                       ; 7CFD
         lda  $7F86,x              ; 7CFE
         sta  $7EC9                ; 7D01
         lda  $7F87,x              ; 7D04
         sta  $7ECA                ; 7D07
         lda  $7F82,y              ; 7D0A
         sta  $7EDF                ; 7D0D
         eor  #$FF                 ; 7D10
         sta  $7EE5                ; 7D12
         lda  #$FF                 ; 7D15
         sta  $E7                  ; 7D17
         lda  $E3                  ; 7D19
         and  #$01                 ; 7D1B
         asl                       ; 7D1D
         tax                       ; 7D1E
         lda  $7F8E,x              ; 7D1F
         sta  $7EEB                ; 7D22
         lda  $7F8F,x              ; 7D25
         sta  $7EEC                ; 7D28
         jsr  sub_7DF0             ; 7D2B
         jsr  sub_7E26             ; 7D2E
         jsr  sub_7E5B             ; 7D31
         sta  $E9                  ; 7D34
         jsr  sub_7E66             ; 7D36
         jsr  sub_7E8C             ; 7D39
         lda  $E2                  ; 7D3C
         cmp  #$10                 ; 7D3E
         bcs  L7D54                ; 7D40
         ldy  $E5                  ; 7D42
         lda  #$02                 ; 7D44
         sta  ($84),y              ; 7D46
         iny                       ; 7D48
         sta  ($84),y              ; 7D49
         iny                       ; 7D4B
         sta  ($84),y              ; 7D4C
         iny                       ; 7D4E
         sty  $E5                  ; 7D4F
         jmp  L7D61                ; 7D51
L7D54
         lda  #$D0                 ; 7D54
         ldx  #$06                 ; 7D56
         cmp  $E2                  ; 7D58
         beq  L7D8E                ; 7D5A
         bcc  L7D8E                ; 7D5C
         jsr  sub_7DB2             ; 7D5E
L7D61
         clc                       ; 7D61
         lda  $C2                  ; 7D62
         adc  #$28                 ; 7D64
         sta  $C2                  ; 7D66
         bcc  L7D6C                ; 7D68
         inc  $C3                  ; 7D6A
L7D6C
         jsr  sub_7E26             ; 7D6C
         clc                       ; 7D6F
         lda  $E9                  ; 7D70
         adc  #$03                 ; 7D72
         sta  $E9                  ; 7D74
         jsr  sub_7E66             ; 7D76
         ldy  #$00                 ; 7D79
         jsr  sub_7EB0             ; 7D7B
         lda  #$C0                 ; 7D7E
         ldx  #$03                 ; 7D80
         cmp  $E2                  ; 7D82
         beq  L7D8E                ; 7D84
         bcc  L7D8E                ; 7D86
         jsr  sub_7DB2             ; 7D88
         jmp  L7C8C                ; 7D8B
L7D8E
         ldy  $E5                  ; 7D8E
         lda  #$02                 ; 7D90
L7D92
         sta  ($84),y              ; 7D92
         iny                       ; 7D94
         dex                       ; 7D95
         bne  L7D92                ; 7D96
         sty  $E5                  ; 7D98
         jmp  L7C8C                ; 7D9A
         dta $8D,$0A,$03,$A5,$D0,$8D,$04,$03,$A5,$D1,$8D,$05,$03,$A9,$40,$8D ; 7D9D
         dta $03,$03,$4C,$59,$E4                      ; 7DAD
sub_7DB2
         lda  $E1                  ; 7DB2
         ldx  #$FF                 ; 7DB4
L7DB6
         inx                       ; 7DB6
         cpx  #$05                 ; 7DB7
         beq  L7DC0                ; 7DB9
         cmp  $7C70,x              ; 7DBB
         bcs  L7DB6                ; 7DBE
L7DC0
         lda  $7C75,x              ; 7DC0
         sta  $E4                  ; 7DC3
         ldy  #$00                 ; 7DC5
         ldx  $E9                  ; 7DC7
L7DC9
         lda  ($C2),y              ; 7DC9
         sty  $C0                  ; 7DCB
         ldy  $E5                  ; 7DCD
         asl  $E4                  ; 7DCF
         php                       ; 7DD1
         bpl  L7DD6                ; 7DD2
         lda  #$02                 ; 7DD4
L7DD6
         sta  ($84),y              ; 7DD6
         and  #$80                 ; 7DD8
         sta  $7DE3                ; 7DDA
         inc  $E5                  ; 7DDD
         ldy  $C0                  ; 7DDF
         txa                       ; 7DE1
         ora  #$00                 ; 7DE2
         plp                       ; 7DE4
         bmi  L7DE9                ; 7DE5
         sta  ($C2),y              ; 7DE7
L7DE9
         inx                       ; 7DE9
         iny                       ; 7DEA
         cpy  #$03                 ; 7DEB
         bcc  L7DC9                ; 7DED
         rts                       ; 7DEF
sub_7DF0
         lda  $E1                  ; 7DF0
         lsr                       ; 7DF2
         lsr                       ; 7DF3
         sta  $C0                  ; 7DF4
         lda  $E2                  ; 7DF6
         lsr                       ; 7DF8
         lsr                       ; 7DF9
         lsr                       ; 7DFA
         lsr                       ; 7DFB
         tax                       ; 7DFC
         clc                       ; 7DFD
         lda  $C5E0,x              ; 7DFE
         adc  $C0                  ; 7E01
         sta  $C2                  ; 7E03
         lda  $C5F0,x              ; 7E05
         adc  $82                  ; 7E08
         sta  $C3                  ; 7E0A
         ldy  $E0                  ; 7E0C
         lda  $C2                  ; 7E0E
         sta  ($84),y              ; 7E10
         tya                       ; 7E12
         clc                       ; 7E13
         adc  #$04                 ; 7E14
         tay                       ; 7E16
         lda  $C3                  ; 7E17
         sta  ($84),y              ; 7E19
         rts                       ; 7E1B
sub_7E1C
         ldx  #$00                 ; 7E1C
         txa                       ; 7E1E
L7E1F
         sta  L8E80,x              ; 7E1F
         inx                       ; 7E22
         bne  L7E1F                ; 7E23
         rts                       ; 7E25
sub_7E26
         ldy  #$00                 ; 7E26
         lda  ($C2),y              ; 7E28
         dta $AB,$7F,$BD,$00,$C3,$85,$D0,$BD,$80,$C3,$05,$81,$85,$D1,$C8,$B1 ; 7E2A
         dta $C2,$AB,$7F,$BD,$00,$C3,$85,$D2,$BD,$80,$C3,$05,$81,$85,$D3,$C8 ; 7E3A
         dta $B1,$C2,$AB,$7F,$BD,$00,$C3,$85,$D4,$BD,$80,$C3,$05,$81,$85,$D5 ; 7E4A
         dta $60                                      ; 7E5A
sub_7E5B
         lda  $E0                  ; 7E5B
         asl                       ; 7E5D
         sta  $C0                  ; 7E5E
         asl                       ; 7E60
         adc  $C0                  ; 7E61
         adc  #$02                 ; 7E63
         rts                       ; 7E65
sub_7E66
         tax                       ; 7E66
         lda  $C300,x              ; 7E67
         sta  $C8                  ; 7E6A
         lda  $C301,x              ; 7E6C
         sta  $CA                  ; 7E6F
         lda  $C302,x              ; 7E71
         sta  $CE                  ; 7E74
         lda  $C380,x              ; 7E76
         ora  $81                  ; 7E79
         sta  $C9                  ; 7E7B
         lda  $C381,x              ; 7E7D
         ora  $81                  ; 7E80
         sta  $CB                  ; 7E82
         lda  $C382,x              ; 7E84
         ora  $81                  ; 7E87
         sta  $CF                  ; 7E89
         rts                       ; 7E8B
sub_7E8C
         lda  $E2                  ; 7E8C
         and  #$0F                 ; 7E8E
         sta  $E6                  ; 7E90
         ldy  #$00                 ; 7E92
         cpy  $E6                  ; 7E94
         bcs  sub_7EB0             ; 7E96
L7E98
         lda  ($D0),y              ; 7E98
         sta  ($C8),y              ; 7E9A
         lda  ($D2),y              ; 7E9C
         sta  ($CA),y              ; 7E9E
         lda  ($D4),y              ; 7EA0
         sta  ($CE),y              ; 7EA2
         iny                       ; 7EA4
         cpy  #$08                 ; 7EA5
         bne  L7EAC                ; 7EA7
         jsr  sub_7F92             ; 7EA9
L7EAC
         cpy  $E6                  ; 7EAC
         bcc  L7E98                ; 7EAE
sub_7EB0
         sty  $E6                  ; 7EB0
         inc  $E7                  ; 7EB2
         ldy  $E7                  ; 7EB4
         cpy  #$20                 ; 7EB6
         bcc  L7EBD                ; 7EB8
         jmp  L7F67                ; 7EBA
L7EBD
         lda  $C880,y              ; 7EBD
         tax                       ; 7EC0
         lda  $C8A0,y              ; 7EC1
         sta  $C1                  ; 7EC4
         lsr                       ; 7EC6
         txa                       ; 7EC7
         jmp  L7ECB                ; 7EC8
L7ECB
         ror                       ; 7ECB
         ror  $C1                  ; 7ECC
         ror                       ; 7ECE
         ror  $C1                  ; 7ECF
         ror                       ; 7ED1
         ror  $C1                  ; 7ED2
         ror                       ; 7ED4
         ror  $C1                  ; 7ED5
         ror                       ; 7ED7
         ror  $C1                  ; 7ED8
         ror                       ; 7EDA
         ror  $C1                  ; 7EDB
         tax                       ; 7EDD
         and  #$00                 ; 7EDE
         sta  $C0                  ; 7EE0
         txa                       ; 7EE2
         ror                       ; 7EE3
         and  #$00                 ; 7EE4
         sta  $E8                  ; 7EE6
         ldy  $E6                  ; 7EE8
         jmp  L7EED                ; 7EEA
L7EED
         lda  #$04                 ; 7EED
         sta  $D1                  ; 7EEF
         lda  #$00                 ; 7EF1
         sta  $D0                  ; 7EF3
         tay                       ; 7EF5
L7EF6
         sta  ($D0),y              ; 7EF6
         iny                       ; 7EF8
         bne  L7EF6                ; 7EF9
         inc  $D1                  ; 7EFB
         bne  L7EF6                ; 7EFD
L7EFF
         jmp  L7EFF                ; 7EFF
         dta $A6,$E8,$B1,$D4,$3D,$00,$C2,$05,$E8,$91,$CE,$A6,$C1,$B1,$D2,$3D ; 7F02
         dta $00,$C2,$05,$C1,$91,$CA,$A6,$C0,$B1,$D0,$3D,$00,$C2,$05,$C0,$91 ; 7F12
         dta $C8,$C8,$C0,$08,$D0,$03,$20,$92,$7F,$C0,$10,$B0,$03,$4C,$B0,$7E ; 7F22
         dta $60,$B1,$D4,$AA,$A5,$E8,$3D,$00,$C2,$11,$D4,$91,$CE,$B1,$D2,$AA ; 7F32
         dta $A5,$C1,$3D,$00,$C2,$11,$D2,$91,$CA,$B1,$D0,$AA,$A5,$C0,$3D,$00 ; 7F42
         dta $C2,$11,$D0,$91,$C8,$C8,$C0,$08,$D0,$03,$20,$92,$7F,$C0,$10,$B0 ; 7F52
         dta $03,$4C,$B0,$7E,$60                      ; 7F62
L7F67
         ldy  $E6                  ; 7F67
L7F69
         lda  ($D0),y              ; 7F69
         sta  ($C8),y              ; 7F6B
         lda  ($D2),y              ; 7F6D
         sta  ($CA),y              ; 7F6F
         lda  ($D4),y              ; 7F71
         sta  ($CE),y              ; 7F73
         iny                       ; 7F75
         cpy  #$08                 ; 7F76
         bne  L7F7D                ; 7F78
         jsr  sub_7F92             ; 7F7A
L7F7D
         cpy  #$10                 ; 7F7D
         bcc  L7F69                ; 7F7F
         rts                       ; 7F81
         dta $FF,$3F,$0F,$03,$DE,$7E,$D7,$7E,$D1,$7E,$CB,$7E,$02,$7F,$33,$7F ; 7F82
sub_7F92
         clc                       ; 7F92
         lda  $D0                  ; 7F93
         adc  #$F8                 ; 7F95
         sta  $D0                  ; 7F97
         lda  $D1                  ; 7F99
         adc  #$03                 ; 7F9B
         sta  $D1                  ; 7F9D
         clc                       ; 7F9F
         lda  $D2                  ; 7FA0
         adc  #$F8                 ; 7FA2
         sta  $D2                  ; 7FA4
         lda  $D3                  ; 7FA6
         adc  #$03                 ; 7FA8
         sta  $D3                  ; 7FAA
         clc                       ; 7FAC
         lda  $D4                  ; 7FAD
         adc  #$F8                 ; 7FAF
         sta  $D4                  ; 7FB1
         lda  $D5                  ; 7FB3
         adc  #$03                 ; 7FB5
         sta  $D5                  ; 7FB7
         clc                       ; 7FB9
         lda  $C8                  ; 7FBA
         adc  #$F8                 ; 7FBC
         sta  $C8                  ; 7FBE
         lda  $C9                  ; 7FC0
         adc  #$03                 ; 7FC2
         sta  $C9                  ; 7FC4
         clc                       ; 7FC6
         lda  $CA                  ; 7FC7
         adc  #$F8                 ; 7FC9
         sta  $CA                  ; 7FCB
         lda  $CB                  ; 7FCD
         adc  #$03                 ; 7FCF
         sta  $CB                  ; 7FD1
         clc                       ; 7FD3
         lda  $CE                  ; 7FD4
         adc  #$F8                 ; 7FD6
         sta  $CE                  ; 7FD8
         lda  $CF                  ; 7FDA
         adc  #$03                 ; 7FDC
         sta  $CF                  ; 7FDE
         rts                       ; 7FE0
sub_7FE1
         ldy  #$00                 ; 7FE1
         lda  ($C4),y              ; 7FE3
         tax                       ; 7FE5
         lda  $C100,x              ; 7FE6
         sta  $C8BF                ; 7FE9
         lda  ($C6),y              ; 7FEC
         tax                       ; 7FEE
         lda  $C100,x              ; 7FEF
         sta  $C89F                ; 7FF2
         iny                       ; 7FF5
         lda  ($C4),y              ; 7FF6
         tax                       ; 7FF8
         lda  $C100,x              ; 7FF9
         sta  $C8BE                ; 7FFC
         lda  ($C6),y              ; 7FFF
         tax                       ; 8001
         lda  $C100,x              ; 8002
         sta  $C89E                ; 8005
         iny                       ; 8008
         lda  ($C4),y              ; 8009
         tax                       ; 800B
         lda  $C100,x              ; 800C
         sta  $C8BD                ; 800F
         lda  ($C6),y              ; 8012
         tax                       ; 8014
         lda  $C100,x              ; 8015
         sta  $C89D                ; 8018
         iny                       ; 801B
         lda  ($C4),y              ; 801C
         tax                       ; 801E
         lda  $C100,x              ; 801F
         sta  $C8BC                ; 8022
         lda  ($C6),y              ; 8025
         tax                       ; 8027
         lda  $C100,x              ; 8028
         sta  $C89C                ; 802B
         iny                       ; 802E
         lda  ($C4),y              ; 802F
         tax                       ; 8031
         lda  $C100,x              ; 8032
         sta  $C8BB                ; 8035
         lda  ($C6),y              ; 8038
         tax                       ; 803A
         lda  $C100,x              ; 803B
         sta  $C89B                ; 803E
         iny                       ; 8041
         lda  ($C4),y              ; 8042
         tax                       ; 8044
         lda  $C100,x              ; 8045
         sta  $C8BA                ; 8048
         lda  ($C6),y              ; 804B
         tax                       ; 804D
         lda  $C100,x              ; 804E
         sta  $C89A                ; 8051
         iny                       ; 8054
         lda  ($C4),y              ; 8055
         tax                       ; 8057
         lda  $C100,x              ; 8058
         sta  $C8B9                ; 805B
         lda  ($C6),y              ; 805E
         tax                       ; 8060
         lda  $C100,x              ; 8061
         sta  $C899                ; 8064
         iny                       ; 8067
         lda  ($C4),y              ; 8068
         tax                       ; 806A
         lda  $C100,x              ; 806B
         sta  $C8B8                ; 806E
         lda  ($C6),y              ; 8071
         tax                       ; 8073
         lda  $C100,x              ; 8074
         sta  $C898                ; 8077
         iny                       ; 807A
         lda  ($C4),y              ; 807B
         tax                       ; 807D
         lda  $C100,x              ; 807E
         sta  $C8B7                ; 8081
         lda  ($C6),y              ; 8084
         tax                       ; 8086
         lda  $C100,x              ; 8087
         sta  $C897                ; 808A
         iny                       ; 808D
         lda  ($C4),y              ; 808E
         tax                       ; 8090
         lda  $C100,x              ; 8091
         sta  $C8B6                ; 8094
         lda  ($C6),y              ; 8097
         tax                       ; 8099
         lda  $C100,x              ; 809A
         sta  $C896                ; 809D
         iny                       ; 80A0
         lda  ($C4),y              ; 80A1
         tax                       ; 80A3
         lda  $C100,x              ; 80A4
         sta  $C8B5                ; 80A7
         lda  ($C6),y              ; 80AA
         tax                       ; 80AC
         lda  $C100,x              ; 80AD
         sta  $C895                ; 80B0
         iny                       ; 80B3
         lda  ($C4),y              ; 80B4
         tax                       ; 80B6
         lda  $C100,x              ; 80B7
         sta  $C8B4                ; 80BA
         lda  ($C6),y              ; 80BD
         tax                       ; 80BF
         lda  $C100,x              ; 80C0
         sta  $C894                ; 80C3
         iny                       ; 80C6
         lda  ($C4),y              ; 80C7
         tax                       ; 80C9
         lda  $C100,x              ; 80CA
         sta  $C8B3                ; 80CD
         lda  ($C6),y              ; 80D0
         tax                       ; 80D2
         lda  $C100,x              ; 80D3
         sta  $C893                ; 80D6
         iny                       ; 80D9
         lda  ($C4),y              ; 80DA
         tax                       ; 80DC
         lda  $C100,x              ; 80DD
         sta  $C8B2                ; 80E0
         lda  ($C6),y              ; 80E3
         tax                       ; 80E5
         lda  $C100,x              ; 80E6
         sta  $C892                ; 80E9
         iny                       ; 80EC
         lda  ($C4),y              ; 80ED
         tax                       ; 80EF
         lda  $C100,x              ; 80F0
         sta  $C8B1                ; 80F3
         lda  ($C6),y              ; 80F6
         tax                       ; 80F8
         lda  $C100,x              ; 80F9
         sta  $C891                ; 80FC
         iny                       ; 80FF
         lda  ($C4),y              ; 8100
         tax                       ; 8102
         lda  $C100,x              ; 8103
         sta  $C8B0                ; 8106
         lda  ($C6),y              ; 8109
         tax                       ; 810B
         lda  $C100,x              ; 810C
         sta  $C890                ; 810F
         iny                       ; 8112
         lda  ($C4),y              ; 8113
         tax                       ; 8115
         lda  $C100,x              ; 8116
         sta  $C8AF                ; 8119
         lda  ($C6),y              ; 811C
         tax                       ; 811E
         lda  $C100,x              ; 811F
         sta  $C88F                ; 8122
         iny                       ; 8125
         lda  ($C4),y              ; 8126
         tax                       ; 8128
         lda  $C100,x              ; 8129
         sta  $C8AE                ; 812C
         lda  ($C6),y              ; 812F
         tax                       ; 8131
         lda  $C100,x              ; 8132
         sta  $C88E                ; 8135
         iny                       ; 8138
         lda  ($C4),y              ; 8139
         tax                       ; 813B
         lda  $C100,x              ; 813C
         sta  $C8AD                ; 813F
         lda  ($C6),y              ; 8142
         tax                       ; 8144
         lda  $C100,x              ; 8145
         sta  $C88D                ; 8148
         iny                       ; 814B
         lda  ($C4),y              ; 814C
         tax                       ; 814E
         lda  $C100,x              ; 814F
         sta  $C8AC                ; 8152
         lda  ($C6),y              ; 8155
         tax                       ; 8157
         lda  $C100,x              ; 8158
         sta  $C88C                ; 815B
         iny                       ; 815E
         lda  ($C4),y              ; 815F
         tax                       ; 8161
         lda  $C100,x              ; 8162
         sta  $C8AB                ; 8165
         lda  ($C6),y              ; 8168
         tax                       ; 816A
         lda  $C100,x              ; 816B
         sta  $C88B                ; 816E
         iny                       ; 8171
         lda  ($C4),y              ; 8172
         tax                       ; 8174
         lda  $C100,x              ; 8175
         sta  $C8AA                ; 8178
         lda  ($C6),y              ; 817B
         tax                       ; 817D
         lda  $C100,x              ; 817E
         sta  $C88A                ; 8181
         iny                       ; 8184
         lda  ($C4),y              ; 8185
         tax                       ; 8187
         lda  $C100,x              ; 8188
         sta  $C8A9                ; 818B
         lda  ($C6),y              ; 818E
         tax                       ; 8190
         lda  $C100,x              ; 8191
         sta  $C889                ; 8194
         iny                       ; 8197
         lda  ($C4),y              ; 8198
         tax                       ; 819A
         lda  $C100,x              ; 819B
         sta  $C8A8                ; 819E
         lda  ($C6),y              ; 81A1
         tax                       ; 81A3
         lda  $C100,x              ; 81A4
         sta  $C888                ; 81A7
         iny                       ; 81AA
         lda  ($C4),y              ; 81AB
         tax                       ; 81AD
         lda  $C100,x              ; 81AE
         sta  $C8A7                ; 81B1
         lda  ($C6),y              ; 81B4
         tax                       ; 81B6
         lda  $C100,x              ; 81B7
         sta  $C887                ; 81BA
         iny                       ; 81BD
         lda  ($C4),y              ; 81BE
         tax                       ; 81C0
         lda  $C100,x              ; 81C1
         sta  $C8A6                ; 81C4
         lda  ($C6),y              ; 81C7
         tax                       ; 81C9
         lda  $C100,x              ; 81CA
         sta  $C886                ; 81CD
         iny                       ; 81D0
         lda  ($C4),y              ; 81D1
         tax                       ; 81D3
         lda  $C100,x              ; 81D4
         sta  $C8A5                ; 81D7
         lda  ($C6),y              ; 81DA
         tax                       ; 81DC
         lda  $C100,x              ; 81DD
         sta  $C885                ; 81E0
         iny                       ; 81E3
         lda  ($C4),y              ; 81E4
         tax                       ; 81E6
         lda  $C100,x              ; 81E7
         sta  $C8A4                ; 81EA
         lda  ($C6),y              ; 81ED
         tax                       ; 81EF
         lda  $C100,x              ; 81F0
         sta  $C884                ; 81F3
         iny                       ; 81F6
         lda  ($C4),y              ; 81F7
         tax                       ; 81F9
         lda  $C100,x              ; 81FA
         sta  $C8A3                ; 81FD
         lda  ($C6),y              ; 8200
         tax                       ; 8202
         lda  $C100,x              ; 8203
         sta  $C883                ; 8206
         iny                       ; 8209
         lda  ($C4),y              ; 820A
         tax                       ; 820C
         lda  $C100,x              ; 820D
         sta  $C8A2                ; 8210
         lda  ($C6),y              ; 8213
         tax                       ; 8215
         lda  $C100,x              ; 8216
         sta  $C882                ; 8219
         iny                       ; 821C
         lda  ($C4),y              ; 821D
         tax                       ; 821F
         lda  $C100,x              ; 8220
         sta  $C8A1                ; 8223
         lda  ($C6),y              ; 8226
         tax                       ; 8228
         lda  $C100,x              ; 8229
         sta  $C881                ; 822C
         iny                       ; 822F
         lda  ($C4),y              ; 8230
         tax                       ; 8232
         lda  $C100,x              ; 8233
         sta  $C8A0                ; 8236
         lda  ($C6),y              ; 8239
         tax                       ; 823B
         lda  $C100,x              ; 823C
         sta  $C880                ; 823F
         rts                       ; 8242
sub_8243
         ldy  #$00                 ; 8243
         lda  ($C4),y              ; 8245
         tax                       ; 8247
         lda  $C100,x              ; 8248
         sta  $C8A0                ; 824B
         lda  ($C6),y              ; 824E
         tax                       ; 8250
         lda  $C100,x              ; 8251
         sta  $C880                ; 8254
         iny                       ; 8257
         lda  ($C4),y              ; 8258
         tax                       ; 825A
         lda  $C100,x              ; 825B
         sta  $C8A1                ; 825E
         lda  ($C6),y              ; 8261
         tax                       ; 8263
         lda  $C100,x              ; 8264
         sta  $C881                ; 8267
         iny                       ; 826A
         lda  ($C4),y              ; 826B
         tax                       ; 826D
         lda  $C100,x              ; 826E
         sta  $C8A2                ; 8271
         lda  ($C6),y              ; 8274
         tax                       ; 8276
         lda  $C100,x              ; 8277
         sta  $C882                ; 827A
         iny                       ; 827D
         lda  ($C4),y              ; 827E
         tax                       ; 8280
         lda  $C100,x              ; 8281
         sta  $C8A3                ; 8284
         lda  ($C6),y              ; 8287
         tax                       ; 8289
         lda  $C100,x              ; 828A
         sta  $C883                ; 828D
         iny                       ; 8290
         lda  ($C4),y              ; 8291
         tax                       ; 8293
         lda  $C100,x              ; 8294
         sta  $C8A4                ; 8297
         lda  ($C6),y              ; 829A
         tax                       ; 829C
         lda  $C100,x              ; 829D
         sta  $C884                ; 82A0
         iny                       ; 82A3
         lda  ($C4),y              ; 82A4
         tax                       ; 82A6
         lda  $C100,x              ; 82A7
         sta  $C8A5                ; 82AA
         lda  ($C6),y              ; 82AD
         tax                       ; 82AF
         lda  $C100,x              ; 82B0
         sta  $C885                ; 82B3
         iny                       ; 82B6
         lda  ($C4),y              ; 82B7
         tax                       ; 82B9
         lda  $C100,x              ; 82BA
         sta  $C8A6                ; 82BD
         lda  ($C6),y              ; 82C0
         tax                       ; 82C2
         lda  $C100,x              ; 82C3
         sta  $C886                ; 82C6
         iny                       ; 82C9
         lda  ($C4),y              ; 82CA
         tax                       ; 82CC
         lda  $C100,x              ; 82CD
         sta  $C8A7                ; 82D0
         lda  ($C6),y              ; 82D3
         tax                       ; 82D5
         lda  $C100,x              ; 82D6
         sta  $C887                ; 82D9
         iny                       ; 82DC
         lda  ($C4),y              ; 82DD
         tax                       ; 82DF
         lda  $C100,x              ; 82E0
         sta  $C8A8                ; 82E3
         lda  ($C6),y              ; 82E6
         tax                       ; 82E8
         lda  $C100,x              ; 82E9
         sta  $C888                ; 82EC
         iny                       ; 82EF
         lda  ($C4),y              ; 82F0
         tax                       ; 82F2
         lda  $C100,x              ; 82F3
         sta  $C8A9                ; 82F6
         lda  ($C6),y              ; 82F9
         tax                       ; 82FB
         lda  $C100,x              ; 82FC
         sta  $C889                ; 82FF
         iny                       ; 8302
         lda  ($C4),y              ; 8303
         tax                       ; 8305
         lda  $C100,x              ; 8306
         sta  $C8AA                ; 8309
         lda  ($C6),y              ; 830C
         tax                       ; 830E
         lda  $C100,x              ; 830F
         sta  $C88A                ; 8312
         iny                       ; 8315
         lda  ($C4),y              ; 8316
         tax                       ; 8318
         lda  $C100,x              ; 8319
         sta  $C8AB                ; 831C
         lda  ($C6),y              ; 831F
         tax                       ; 8321
         lda  $C100,x              ; 8322
         sta  $C88B                ; 8325
         iny                       ; 8328
         lda  ($C4),y              ; 8329
         tax                       ; 832B
         lda  $C100,x              ; 832C
         sta  $C8AC                ; 832F
         lda  ($C6),y              ; 8332
         tax                       ; 8334
         lda  $C100,x              ; 8335
         sta  $C88C                ; 8338
         iny                       ; 833B
         lda  ($C4),y              ; 833C
         tax                       ; 833E
         lda  $C100,x              ; 833F
         sta  $C8AD                ; 8342
         lda  ($C6),y              ; 8345
         tax                       ; 8347
         lda  $C100,x              ; 8348
         sta  $C88D                ; 834B
         iny                       ; 834E
         lda  ($C4),y              ; 834F
         tax                       ; 8351
         lda  $C100,x              ; 8352
         sta  $C8AE                ; 8355
         lda  ($C6),y              ; 8358
         tax                       ; 835A
         lda  $C100,x              ; 835B
         sta  $C88E                ; 835E
         iny                       ; 8361
         lda  ($C4),y              ; 8362
         tax                       ; 8364
         lda  $C100,x              ; 8365
         sta  $C8AF                ; 8368
         lda  ($C6),y              ; 836B
         tax                       ; 836D
         lda  $C100,x              ; 836E
         sta  $C88F                ; 8371
         iny                       ; 8374
         lda  ($C4),y              ; 8375
         tax                       ; 8377
         lda  $C100,x              ; 8378
         sta  $C8B0                ; 837B
         lda  ($C6),y              ; 837E
         tax                       ; 8380
         lda  $C100,x              ; 8381
         sta  $C890                ; 8384
         iny                       ; 8387
         lda  ($C4),y              ; 8388
         tax                       ; 838A
         lda  $C100,x              ; 838B
         sta  $C8B1                ; 838E
         lda  ($C6),y              ; 8391
         tax                       ; 8393
         lda  $C100,x              ; 8394
         sta  $C891                ; 8397
         iny                       ; 839A
         lda  ($C4),y              ; 839B
         tax                       ; 839D
         lda  $C100,x              ; 839E
         sta  $C8B2                ; 83A1
         lda  ($C6),y              ; 83A4
         tax                       ; 83A6
         lda  $C100,x              ; 83A7
         sta  $C892                ; 83AA
         iny                       ; 83AD
         lda  ($C4),y              ; 83AE
         tax                       ; 83B0
         lda  $C100,x              ; 83B1
         sta  $C8B3                ; 83B4
         lda  ($C6),y              ; 83B7
         tax                       ; 83B9
         lda  $C100,x              ; 83BA
         sta  $C893                ; 83BD
         iny                       ; 83C0
         lda  ($C4),y              ; 83C1
         tax                       ; 83C3
         lda  $C100,x              ; 83C4
         sta  $C8B4                ; 83C7
         lda  ($C6),y              ; 83CA
         tax                       ; 83CC
         lda  $C100,x              ; 83CD
         sta  $C894                ; 83D0
         iny                       ; 83D3
         lda  ($C4),y              ; 83D4
         tax                       ; 83D6
         lda  $C100,x              ; 83D7
         sta  $C8B5                ; 83DA
         lda  ($C6),y              ; 83DD
         tax                       ; 83DF
         lda  $C100,x              ; 83E0
         sta  $C895                ; 83E3
         iny                       ; 83E6
         lda  ($C4),y              ; 83E7
         tax                       ; 83E9
         lda  $C100,x              ; 83EA
         sta  $C8B6                ; 83ED
         lda  ($C6),y              ; 83F0
         tax                       ; 83F2
         lda  $C100,x              ; 83F3
         sta  $C896                ; 83F6
         iny                       ; 83F9
         lda  ($C4),y              ; 83FA
         tax                       ; 83FC
         lda  $C100,x              ; 83FD
         sta  $C8B7                ; 8400
         lda  ($C6),y              ; 8403
         tax                       ; 8405
         lda  $C100,x              ; 8406
         sta  $C897                ; 8409
         iny                       ; 840C
         lda  ($C4),y              ; 840D
         tax                       ; 840F
         lda  $C100,x              ; 8410
         sta  $C8B8                ; 8413
         lda  ($C6),y              ; 8416
         tax                       ; 8418
         lda  $C100,x              ; 8419
         sta  $C898                ; 841C
         iny                       ; 841F
         lda  ($C4),y              ; 8420
         tax                       ; 8422
         lda  $C100,x              ; 8423
         sta  $C8B9                ; 8426
         lda  ($C6),y              ; 8429
         tax                       ; 842B
         lda  $C100,x              ; 842C
         sta  $C899                ; 842F
         iny                       ; 8432
         lda  ($C4),y              ; 8433
         tax                       ; 8435
         lda  $C100,x              ; 8436
         sta  $C8BA                ; 8439
         lda  ($C6),y              ; 843C
         tax                       ; 843E
         lda  $C100,x              ; 843F
         sta  $C89A                ; 8442
         iny                       ; 8445
         lda  ($C4),y              ; 8446
         tax                       ; 8448
         lda  $C100,x              ; 8449
         sta  $C8BB                ; 844C
         lda  ($C6),y              ; 844F
         tax                       ; 8451
         lda  $C100,x              ; 8452
         sta  $C89B                ; 8455
         iny                       ; 8458
         lda  ($C4),y              ; 8459
         tax                       ; 845B
         lda  $C100,x              ; 845C
         sta  $C8BC                ; 845F
         lda  ($C6),y              ; 8462
         tax                       ; 8464
         lda  $C100,x              ; 8465
         sta  $C89C                ; 8468
         iny                       ; 846B
         lda  ($C4),y              ; 846C
         tax                       ; 846E
         lda  $C100,x              ; 846F
         sta  $C8BD                ; 8472
         lda  ($C6),y              ; 8475
         tax                       ; 8477
         lda  $C100,x              ; 8478
         sta  $C89D                ; 847B
         iny                       ; 847E
         lda  ($C4),y              ; 847F
         tax                       ; 8481
         lda  $C100,x              ; 8482
         sta  $C8BE                ; 8485
         lda  ($C6),y              ; 8488
         tax                       ; 848A
         lda  $C100,x              ; 848B
         sta  $C89E                ; 848E
         iny                       ; 8491
         lda  ($C4),y              ; 8492
         tax                       ; 8494
         lda  $C100,x              ; 8495
         sta  $C8BF                ; 8498
         lda  ($C6),y              ; 849B
         tax                       ; 849D
         lda  $C100,x              ; 849E
         sta  $C89F                ; 84A1
         rts                       ; 84A4
         dta $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 84A5
         dta $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 84B5
         dta $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 84C5
         dta $00,$00,$91,$C0,$88,$10,$FB,$A9,$FF,$8D,$01,$D3,$A9,$40,$8D,$0E ; 84D5
         dta $D4,$4C,$13,$8D                          ; 84E5
sub_84E9
         ldy  #$00                 ; 84E9
         lda  ($C4),y              ; 84EB
         sta  $C89F                ; 84ED
         lda  ($C6),y              ; 84F0
         sta  $C8BF                ; 84F2
         iny                       ; 84F5
         lda  ($C4),y              ; 84F6
         sta  $C89E                ; 84F8
         lda  ($C6),y              ; 84FB
         sta  $C8BE                ; 84FD
         iny                       ; 8500
         lda  ($C4),y              ; 8501
         sta  $C89D                ; 8503
         lda  ($C6),y              ; 8506
         sta  $C8BD                ; 8508
         iny                       ; 850B
         lda  ($C4),y              ; 850C
         sta  $C89C                ; 850E
         lda  ($C6),y              ; 8511
         sta  $C8BC                ; 8513
         iny                       ; 8516
         lda  ($C4),y              ; 8517
         sta  $C89B                ; 8519
         lda  ($C6),y              ; 851C
         sta  $C8BB                ; 851E
         iny                       ; 8521
         lda  ($C4),y              ; 8522
         sta  $C89A                ; 8524
         lda  ($C6),y              ; 8527
         sta  $C8BA                ; 8529
         iny                       ; 852C
         lda  ($C4),y              ; 852D
         sta  $C899                ; 852F
         lda  ($C6),y              ; 8532
         sta  $C8B9                ; 8534
         iny                       ; 8537
         lda  ($C4),y              ; 8538
         sta  $C898                ; 853A
         lda  ($C6),y              ; 853D
         sta  $C8B8                ; 853F
         iny                       ; 8542
         lda  ($C4),y              ; 8543
         sta  $C897                ; 8545
         lda  ($C6),y              ; 8548
         sta  $C8B7                ; 854A
         iny                       ; 854D
         lda  ($C4),y              ; 854E
         sta  $C896                ; 8550
         lda  ($C6),y              ; 8553
         sta  $C8B6                ; 8555
         iny                       ; 8558
         lda  ($C4),y              ; 8559
         sta  $C895                ; 855B
         lda  ($C6),y              ; 855E
         sta  $C8B5                ; 8560
         iny                       ; 8563
         lda  ($C4),y              ; 8564
         sta  $C894                ; 8566
         lda  ($C6),y              ; 8569
         sta  $C8B4                ; 856B
         iny                       ; 856E
         lda  ($C4),y              ; 856F
         sta  $C893                ; 8571
         lda  ($C6),y              ; 8574
         sta  $C8B3                ; 8576
         iny                       ; 8579
         lda  ($C4),y              ; 857A
         sta  $C892                ; 857C
         lda  ($C6),y              ; 857F
         sta  $C8B2                ; 8581
         iny                       ; 8584
         lda  ($C4),y              ; 8585
         sta  $C891                ; 8587
         lda  ($C6),y              ; 858A
         sta  $C8B1                ; 858C
         iny                       ; 858F
         lda  ($C4),y              ; 8590
         sta  $C890                ; 8592
         lda  ($C6),y              ; 8595
         sta  $C8B0                ; 8597
         iny                       ; 859A
         lda  ($C4),y              ; 859B
         sta  $C88F                ; 859D
         lda  ($C6),y              ; 85A0
         sta  $C8AF                ; 85A2
         iny                       ; 85A5
         lda  ($C4),y              ; 85A6
         sta  $C88E                ; 85A8
         lda  ($C6),y              ; 85AB
         sta  $C8AE                ; 85AD
         iny                       ; 85B0
         lda  ($C4),y              ; 85B1
         sta  $C88D                ; 85B3
         lda  ($C6),y              ; 85B6
         sta  $C8AD                ; 85B8
         iny                       ; 85BB
         lda  ($C4),y              ; 85BC
         sta  $C88C                ; 85BE
         lda  ($C6),y              ; 85C1
         sta  $C8AC                ; 85C3
         iny                       ; 85C6
         lda  ($C4),y              ; 85C7
         sta  $C88B                ; 85C9
         lda  ($C6),y              ; 85CC
         sta  $C8AB                ; 85CE
         iny                       ; 85D1
         lda  ($C4),y              ; 85D2
         sta  $C88A                ; 85D4
         lda  ($C6),y              ; 85D7
         sta  $C8AA                ; 85D9
         iny                       ; 85DC
         lda  ($C4),y              ; 85DD
         sta  $C889                ; 85DF
         lda  ($C6),y              ; 85E2
         sta  $C8A9                ; 85E4
         iny                       ; 85E7
         lda  ($C4),y              ; 85E8
         sta  $C888                ; 85EA
         lda  ($C6),y              ; 85ED
         sta  $C8A8                ; 85EF
         iny                       ; 85F2
         lda  ($C4),y              ; 85F3
         sta  $C887                ; 85F5
         lda  ($C6),y              ; 85F8
         sta  $C8A7                ; 85FA
         iny                       ; 85FD
         lda  ($C4),y              ; 85FE
         sta  $C886                ; 8600
         lda  ($C6),y              ; 8603
         sta  $C8A6                ; 8605
         iny                       ; 8608
         lda  ($C4),y              ; 8609
         sta  $C885                ; 860B
         lda  ($C6),y              ; 860E
         sta  $C8A5                ; 8610
         iny                       ; 8613
         lda  ($C4),y              ; 8614
         sta  $C884                ; 8616
         lda  ($C6),y              ; 8619
         sta  $C8A4                ; 861B
         iny                       ; 861E
         lda  ($C4),y              ; 861F
         sta  $C883                ; 8621
         lda  ($C6),y              ; 8624
         sta  $C8A3                ; 8626
         iny                       ; 8629
         lda  ($C4),y              ; 862A
         sta  $C882                ; 862C
         lda  ($C6),y              ; 862F
         sta  $C8A2                ; 8631
         iny                       ; 8634
         lda  ($C4),y              ; 8635
         sta  $C881                ; 8637
         lda  ($C6),y              ; 863A
         sta  $C8A1                ; 863C
         iny                       ; 863F
         lda  ($C4),y              ; 8640
         sta  $C880                ; 8642
         lda  ($C6),y              ; 8645
         sta  $C8A0                ; 8647
         rts                       ; 864A
sub_864B
         ldy  #$00                 ; 864B
         lda  ($C4),y              ; 864D
         sta  $C880                ; 864F
         lda  ($C6),y              ; 8652
         sta  $C8A0                ; 8654
         iny                       ; 8657
         lda  ($C4),y              ; 8658
         sta  $C881                ; 865A
         lda  ($C6),y              ; 865D
         sta  $C8A1                ; 865F
         iny                       ; 8662
         lda  ($C4),y              ; 8663
         sta  $C882                ; 8665
         lda  ($C6),y              ; 8668
         sta  $C8A2                ; 866A
         iny                       ; 866D
         lda  ($C4),y              ; 866E
         sta  $C883                ; 8670
         lda  ($C6),y              ; 8673
         sta  $C8A3                ; 8675
         iny                       ; 8678
         lda  ($C4),y              ; 8679
         sta  $C884                ; 867B
         lda  ($C6),y              ; 867E
         sta  $C8A4                ; 8680
         iny                       ; 8683
         lda  ($C4),y              ; 8684
         sta  $C885                ; 8686
         lda  ($C6),y              ; 8689
         sta  $C8A5                ; 868B
         iny                       ; 868E
         lda  ($C4),y              ; 868F
         sta  $C886                ; 8691
         lda  ($C6),y              ; 8694
         sta  $C8A6                ; 8696
         iny                       ; 8699
         lda  ($C4),y              ; 869A
         sta  $C887                ; 869C
         lda  ($C6),y              ; 869F
         sta  $C8A7                ; 86A1
         iny                       ; 86A4
         lda  ($C4),y              ; 86A5
         sta  $C888                ; 86A7
         lda  ($C6),y              ; 86AA
         sta  $C8A8                ; 86AC
         iny                       ; 86AF
         lda  ($C4),y              ; 86B0
         sta  $C889                ; 86B2
         lda  ($C6),y              ; 86B5
         sta  $C8A9                ; 86B7
         iny                       ; 86BA
         lda  ($C4),y              ; 86BB
         sta  $C88A                ; 86BD
         lda  ($C6),y              ; 86C0
         sta  $C8AA                ; 86C2
         iny                       ; 86C5
         lda  ($C4),y              ; 86C6
         sta  $C88B                ; 86C8
         lda  ($C6),y              ; 86CB
         sta  $C8AB                ; 86CD
         iny                       ; 86D0
         lda  ($C4),y              ; 86D1
         sta  $C88C                ; 86D3
         lda  ($C6),y              ; 86D6
         sta  $C8AC                ; 86D8
         iny                       ; 86DB
         lda  ($C4),y              ; 86DC
         sta  $C88D                ; 86DE
         lda  ($C6),y              ; 86E1
         sta  $C8AD                ; 86E3
         iny                       ; 86E6
         lda  ($C4),y              ; 86E7
         sta  $C88E                ; 86E9
         lda  ($C6),y              ; 86EC
         sta  $C8AE                ; 86EE
         iny                       ; 86F1
         lda  ($C4),y              ; 86F2
         sta  $C88F                ; 86F4
         lda  ($C6),y              ; 86F7
         sta  $C8AF                ; 86F9
         iny                       ; 86FC
         lda  ($C4),y              ; 86FD
         sta  $C890                ; 86FF
         lda  ($C6),y              ; 8702
         sta  $C8B0                ; 8704
         iny                       ; 8707
         lda  ($C4),y              ; 8708
         sta  $C891                ; 870A
         lda  ($C6),y              ; 870D
         sta  $C8B1                ; 870F
         iny                       ; 8712
         lda  ($C4),y              ; 8713
         sta  $C892                ; 8715
         lda  ($C6),y              ; 8718
         sta  $C8B2                ; 871A
         iny                       ; 871D
         lda  ($C4),y              ; 871E
         sta  $C893                ; 8720
         lda  ($C6),y              ; 8723
         sta  $C8B3                ; 8725
         iny                       ; 8728
         lda  ($C4),y              ; 8729
         sta  $C894                ; 872B
         lda  ($C6),y              ; 872E
         sta  $C8B4                ; 8730
         iny                       ; 8733
         lda  ($C4),y              ; 8734
         sta  $C895                ; 8736
         lda  ($C6),y              ; 8739
         sta  $C8B5                ; 873B
         iny                       ; 873E
         lda  ($C4),y              ; 873F
         sta  $C896                ; 8741
         lda  ($C6),y              ; 8744
         sta  $C8B6                ; 8746
         iny                       ; 8749
         lda  ($C4),y              ; 874A
         sta  $C897                ; 874C
         lda  ($C6),y              ; 874F
         sta  $C8B7                ; 8751
         iny                       ; 8754
         lda  ($C4),y              ; 8755
         sta  $C898                ; 8757
         lda  ($C6),y              ; 875A
         sta  $C8B8                ; 875C
         iny                       ; 875F
         lda  ($C4),y              ; 8760
         sta  $C899                ; 8762
         lda  ($C6),y              ; 8765
         sta  $C8B9                ; 8767
         iny                       ; 876A
         lda  ($C4),y              ; 876B
         sta  $C89A                ; 876D
         lda  ($C6),y              ; 8770
         sta  $C8BA                ; 8772
         iny                       ; 8775
         lda  ($C4),y              ; 8776
         sta  $C89B                ; 8778
         lda  ($C6),y              ; 877B
         sta  $C8BB                ; 877D
         iny                       ; 8780
         lda  ($C4),y              ; 8781
         sta  $C89C                ; 8783
         lda  ($C6),y              ; 8786
         sta  $C8BC                ; 8788
         iny                       ; 878B
         lda  ($C4),y              ; 878C
         sta  $C89D                ; 878E
         lda  ($C6),y              ; 8791
         sta  $C8BD                ; 8793
         iny                       ; 8796
         lda  ($C4),y              ; 8797
         sta  $C89E                ; 8799
         lda  ($C6),y              ; 879C
         sta  $C8BE                ; 879E
         iny                       ; 87A1
         lda  ($C4),y              ; 87A2
         sta  $C89F                ; 87A4
         lda  ($C6),y              ; 87A7
         sta  $C8BF                ; 87A9
         rts                       ; 87AC
         dta $A9,$00,$85,$D0,$85,$D2,$A9,$05,$85,$D1,$A9,$06,$85,$D3,$A0,$7D ; 87AD
         dta $B1,$D0,$D1,$D2,$D0,$06,$88,$10,$F7,$A9,$FF,$60,$A9,$00,$60 ; 87BD
L87CC
         ldy  #$03                 ; 87CC
         sty  $E6                  ; 87CE
L87D0
         lda  ($84),y              ; 87D0
         sta  $C0                  ; 87D2
         tya                       ; 87D4
         clc                       ; 87D5
         adc  #$04                 ; 87D6
         tay                       ; 87D8
         lda  ($84),y              ; 87D9
         sta  $C1                  ; 87DB
         lda  $E6                  ; 87DD
         ora  #$70                 ; 87DF
         tay                       ; 87E1
         lda  ($84),y              ; 87E2
         beq  L8819                ; 87E4
         ldx  $E6                  ; 87E6
         inx                       ; 87E8
         txa                       ; 87E9
         asl                       ; 87EA
         asl                       ; 87EB
         asl                       ; 87EC
         clc                       ; 87ED
         adc  $84                  ; 87EE
         sta  $87FF                ; 87F0
         lda  $85                  ; 87F3
         adc  #$00                 ; 87F5
         sta  $8800                ; 87F7
         ldx  #$00                 ; 87FA
         ldy  #$00                 ; 87FC
L87FE
         lda  L87FE,x              ; 87FE
         cmp  #$02                 ; 8801
         beq  L8807                ; 8803
         sta  ($C0),y              ; 8805
L8807
         iny                       ; 8807
         inx                       ; 8808
         cpx  #$06                 ; 8809
         bcs  L8819                ; 880B
         cpx  #$03                 ; 880D
         bne  L87FE                ; 880F
         tya                       ; 8811
         clc                       ; 8812
         adc  #$25                 ; 8813
         tay                       ; 8815
         jmp  L87FE                ; 8816
L8819
         dec  $E6                  ; 8819
         ldy  $E6                  ; 881B
         bpl  L87D0                ; 881D
         rts                       ; 881F
sub_8820
         ldx  #$00                 ; 8820
         lda  $C000,x              ; 8822
L8825
         sta  sub_84E9,x           ; 8825
         inx                       ; 8828
         bne  L8825                ; 8829
         rts                       ; 882B
L882C
         lda  RTCLOK+2             ; 882C
L882E
         cmp  RTCLOK+2             ; 882E
         beq  L882E                ; 8830
         ldy  #$00                 ; 8832
         ldx  #$00                 ; 8834
         lda  $80                  ; 8836
         lsr                       ; 8838
         bcc  L883F                ; 8839
         ldy  #$00                 ; 883B
         ldx  #$00                 ; 883D
L883F
         sty  SDLSTL               ; 883F
         sty  DLISTL               ; 8842
         stx  SDLSTH               ; 8845
         stx  DLISTH               ; 8848
         ldy  #$00                 ; 884B
         bcc  L8851                ; 884D
         ldy  #$00                 ; 884F
L8851
         sty  $82                  ; 8851
         ldy  #$00                 ; 8853
         bcc  L8859                ; 8855
         ldy  #$00                 ; 8857
L8859
         sty  $81                  ; 8859
         ldx  #$00                 ; 885B
         ldy  #$C4                 ; 885D
         bcc  L8865                ; 885F
         ldx  #$80                 ; 8861
         ldy  #$C4                 ; 8863
L8865
         stx  $84                  ; 8865
         sty  $85                  ; 8867
         ldx  #$00                 ; 8869
         bcc  L886F                ; 886B
         ldx  #$00                 ; 886D
L886F
         stx  $83                  ; 886F
         inc  $80                  ; 8871
         rts                       ; 8873
         dta $8D,$A4,$88,$8E,$A6,$88,$8C,$A8,$88,$A5,$86,$A6,$87,$A4,$88,$8D ; 8874
         dta $0A,$D4,$8D,$1A,$D0,$8E,$16,$D0,$8C,$17,$D0,$A5,$89,$A6,$8A,$8D ; 8884
         dta $18,$D0,$8E,$19,$D0,$A9,$AA,$A2,$88,$8D,$00,$02,$8E,$01,$02,$A9 ; 8894
         dta $00,$A2,$00,$A0,$00,$40,$48,$8A,$48,$E6,$A4,$8D,$0A,$D4,$A5,$83 ; 88A4
         dta $8D,$09,$D4,$A6,$A4,$E0,$03,$90,$34,$E0,$0B,$90,$5A,$8D,$0A,$D4 ; 88B4
         dta $A9,$6C,$8D,$09,$D4,$A9,$0E,$8D,$17,$D0,$A2,$0B,$BD,$6D,$93,$8D ; 88C4
         dta $18,$D0,$8D,$1A,$D0,$8D,$0A,$D4,$CA,$10,$F1,$A9,$00,$85,$A4,$A9 ; 88D4
         dta $74,$A2,$88,$8D,$00,$02,$8E,$01,$02,$68,$AA,$68,$40,$CA,$8A,$0A ; 88E4
         dta $0A,$0A,$AA,$8D,$0A,$D4,$BD,$5D,$93,$8D,$1A,$D0,$8D,$0A,$D4,$BD ; 88F4
         dta $5E,$93,$8D,$1A,$D0,$8D,$0A,$D4,$BD,$5F,$93,$8D,$1A,$D0,$8D,$0A ; 8904
         dta $D4,$BD,$60,$93,$8D,$1A,$D0,$A9,$29,$8D,$00,$02,$A9,$89,$8D,$01 ; 8914
         dta $02,$68,$AA,$68,$40,$48,$8A,$48,$A5,$83,$8D,$0A,$D4,$09,$04,$8D ; 8924
         dta $09,$D4,$A6,$A4,$E0,$03,$B0,$2A,$CA,$8A,$0A,$0A,$0A,$AA,$8D,$0A ; 8934
         dta $D4,$BD,$61,$93,$8D,$1A,$D0,$8D,$0A,$D4,$BD,$62,$93,$8D,$1A,$D0 ; 8944
         dta $8D,$0A,$D4,$BD,$63,$93,$8D,$1A,$D0,$8D,$0A,$D4,$BD,$64,$93,$8D ; 8954
         dta $1A,$D0,$A9,$AA,$8D,$00,$02,$A9,$88,$8D,$01,$02,$68,$AA,$68,$40 ; 8964
         dta $00,$70,$4E,$00,$71,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E ; 8974
         dta $0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$80,$90,$C4,$00 ; 8984
         dta $BC,$C4,$00,$BC,$C4,$28,$BC,$C4,$28,$BC,$C4,$50,$BC,$C4,$50,$BC ; 8994
         dta $C4,$78,$BC,$C4,$78,$BC,$C4,$A0,$BC,$C4,$A0,$BC,$C4,$C8,$BC,$C4 ; 89A4
         dta $C8,$BC,$C4,$F0,$BC,$C4,$F0,$BC,$C4,$18,$BD,$C4,$18,$BD,$C4,$40 ; 89B4
         dta $BD,$C4,$40,$BD,$C4,$68,$BD,$C4,$68,$BD,$20,$42,$29,$A1,$10,$02 ; 89C4
         dta $02,$41,$74,$89,$00,$70,$4E,$00,$71,$0E,$0E,$0E,$0E,$0E,$0E,$0E ; 89D4
         dta $0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E ; 89E4
         dta $80,$90,$C4,$00,$BE,$C4,$00,$BE,$C4,$28,$BE,$C4,$28,$BE,$C4,$50 ; 89F4
         dta $BE,$C4,$50,$BE,$C4,$78,$BE,$C4,$78,$BE,$C4,$A0,$BE,$C4,$A0,$BE ; 8A04
         dta $C4,$C8,$BE,$C4,$C8,$BE,$C4,$F0,$BE,$C4,$F0,$BE,$C4,$18,$BF,$C4 ; 8A14
         dta $18,$BF,$C4,$40,$BF,$C4,$40,$BF,$C4,$68,$BF,$C4,$68,$BF,$20,$42 ; 8A24
         dta $29,$A1,$10,$02,$02,$41,$D8,$89,$00,$64,$00,$C8,$01,$2C,$01,$90 ; 8A34
         dta $A5,$AA,$C9,$01,$F0,$03,$4C,$16,$97      ; 8A44
sub_8A4D
         lda  #$00                 ; 8A4D
         tay                       ; 8A4F
L8A50
         sta  $CC00,y              ; 8A50
         sta  $CD00,y              ; 8A53
         sta  $CE00,y              ; 8A56
         sta  $CF00,y              ; 8A59
         iny                       ; 8A5C
         bne  L8A50                ; 8A5D
         rts                       ; 8A5F
         dta $D0,$FE,$F0,$FE                          ; 8A60
sub_8A64
         bne  L8A8E                ; 8A64
         lda  $8A6F                ; 8A66
         eor  #$02                 ; 8A69
         sta  $8A6F                ; 8A6B
         ldx  #$02                 ; 8A6E
         lda  $8A60,x              ; 8A70
         sta  sub_8A64             ; 8A73
         cmp  $8A60                ; 8A76
         beq  L8A8E                ; 8A79
         lda  #$40                 ; 8A7B
         jsr  entry_F2E4           ; 8A7D
         lda  $8A7C                ; 8A80
         eor  #$20                 ; 8A83
         sta  $8A7C                ; 8A85
         lda  $A9                  ; 8A88
         eor  #$01                 ; 8A8A
         sta  $A9                  ; 8A8C
L8A8E
         rts                       ; 8A8E
         dta $A5,$14,$29,$01,$D0,$06,$20,$2F,$8C,$4C,$A6,$8A,$AD,$1F,$D0,$29 ; 8A8F
         dta $04,$20,$64,$8A,$20,$08,$8F,$A9,$00,$85,$A8,$A9,$CC,$85,$A3,$AD ; 8A9F
         dta $4D,$93,$D0,$0B,$A2,$03,$9D,$00,$D0,$CA,$10,$03,$4C,$03,$8C,$AD ; 8AAF
         dta $4E,$93,$18,$69,$1B,$85,$A2,$AC,$51,$93,$B9,$50,$C6,$85,$A0,$B9 ; 8ABF
         dta $70,$C6,$65,$A8,$65,$A8,$85,$A1,$AC,$53,$93,$D0,$03,$4C,$18,$8C ; 8ACF
         dta $A0,$23,$A9,$00,$91,$A2,$88,$91,$A2,$88,$91,$A2,$88,$B3,$A0,$BD ; 8ADF
         dta $00,$C0,$91,$A2,$88,$B3,$A0,$BD,$00,$C0,$91,$A2,$88,$B3,$A0,$BD ; 8AEF
         dta $00,$C0,$91,$A2,$88,$B3,$A0,$BD,$00,$C0,$91,$A2,$88,$B3,$A0,$BD ; 8AFF
         dta $00,$C0,$91,$A2,$88,$B3,$A0,$BD,$00,$C0,$91,$A2,$88,$B3,$A0,$BD ; 8B0F
         dta $00,$C0,$91,$A2,$88,$B3,$A0,$BD,$00,$C0,$91,$A2,$88,$B3,$A0,$BD ; 8B1F
         dta $00,$C0,$91,$A2,$88,$B3,$A0,$BD,$00,$C0,$91,$A2,$88,$B3,$A0,$BD ; 8B2F
         dta $00,$C0,$91,$A2,$88,$B3,$A0,$BD,$00,$C0,$91,$A2,$88,$B3,$A0,$BD ; 8B3F
         dta $00,$C0,$91,$A2,$88,$B3,$A0,$BD,$00,$C0,$91,$A2,$88,$B3,$A0,$BD ; 8B4F
         dta $00,$C0,$91,$A2,$88,$B3,$A0,$BD,$00,$C0,$91,$A2,$88,$B3,$A0,$BD ; 8B5F
         dta $00,$C0,$91,$A2,$88,$B3,$A0,$BD,$00,$C0,$91,$A2,$88,$B3,$A0,$BD ; 8B6F
         dta $00,$C0,$91,$A2,$88,$B3,$A0,$BD,$00,$C0,$91,$A2,$88,$B3,$A0,$BD ; 8B7F
         dta $00,$C0,$91,$A2,$88,$B3,$A0,$BD,$00,$C0,$91,$A2,$88,$B3,$A0,$BD ; 8B8F
         dta $00,$C0,$91,$A2,$88,$B3,$A0,$BD,$00,$C0,$91,$A2,$88,$B3,$A0,$BD ; 8B9F
         dta $00,$C0,$91,$A2,$88,$B3,$A0,$BD,$00,$C0,$91,$A2,$88,$B3,$A0,$BD ; 8BAF
         dta $00,$C0,$91,$A2,$88,$B3,$A0,$BD,$00,$C0,$91,$A2,$88,$B3,$A0,$BD ; 8BBF
         dta $00,$C0,$91,$A2,$88,$B3,$A0,$BD,$00,$C0,$91,$A2,$88,$B3,$A0,$BD ; 8BCF
         dta $00,$C0,$91,$A2,$88,$B3,$A0,$BD,$00,$C0,$91,$A2,$88,$A9,$00,$91 ; 8BDF
         dta $A2,$C6,$A2,$91,$A2,$E6,$A2,$E6,$A3,$E6,$A8,$A5,$A8,$C9,$04,$F0 ; 8BEF
         dta $03,$4C,$BE,$8A,$AD,$4D,$93,$18,$69,$28,$8D,$00,$D0,$8D,$01,$D0 ; 8BFF
         dta $69,$08,$8D,$02,$D0,$8D,$03,$D0,$60,$A0,$23,$A9,$00,$91,$A2,$88 ; 8C0F
         dta $91,$A2,$88,$91,$A2,$88,$B1,$A0,$91,$A2,$88,$D0,$F9,$4C,$EC,$8B ; 8C1F
         dta $A5,$8D,$F0,$01,$60,$A0,$00,$AD,$4E,$93,$C9,$90,$90,$31,$AD,$51 ; 8C2F
         dta $93,$C9,$0F,$F0,$15,$A9,$0F,$8D,$51,$93,$A9,$0A,$8D,$5A,$8C,$C6 ; 8C3F
         dta $A7,$A9,$21,$A2,$18,$A0,$14,$4C,$E4,$F2,$A9,$00,$F0,$04,$CE,$5A ; 8C4F
         dta $8C,$60,$AD,$4F,$93,$8D,$4D,$93,$AD,$50,$93,$8D,$4E,$93,$60,$20 ; 8C5F
         dta $41,$8D,$AD,$4E,$93,$29,$0F,$D0,$41,$AD,$55,$93,$F0,$04,$C9,$0A ; 8C6F
         dta $90,$38,$AD,$56,$93,$29,$01,$F0,$31,$8C,$54,$93,$AE,$52,$93,$AD ; 8C7F
         dta $54,$93,$30,$1F,$AD,$59,$93,$D0,$0E,$AD,$84,$02,$29,$01,$D0,$13 ; 8C8F
         dta $A2,$0D,$8E,$59,$93,$D0,$0C,$AA,$E8,$8E,$59,$93,$E0,$10,$90,$03 ; 8C9F
         dta $8C,$59,$93,$BD,$79,$93,$8D,$51,$93,$60,$AD,$58,$93,$10,$15,$AD ; 8CAF
         dta $4E,$93,$29,$FE,$8D,$4E,$93,$A2,$09,$29,$02,$D0,$02,$A2,$0A,$8E ; 8CBF
         dta $52,$93,$D0,$B5,$AD,$54,$93,$30,$22,$F0,$18,$AE,$55,$93,$E0,$0C ; 8CCF
         dta $F0,$11,$BD,$95,$93,$18,$6D,$4E,$93,$8D,$4E,$93,$EE,$55,$93,$A2 ; 8CDF
         dta $0C,$D0,$9C,$8C,$55,$93,$A9,$80,$8D,$54,$93,$EE,$4E,$93,$EE,$4E ; 8CEF
         dta $93,$AD,$4E,$93,$29,$FE,$8D,$4E,$93,$8C,$59,$93,$A2,$0C,$4C,$8E ; 8CFF
         dta $8C,$4C,$ED,$7E,$AD,$0A,$D2,$29,$03,$0A,$AA,$BD,$3C,$8A,$8D,$C5 ; 8D0F
         dta $95,$BD,$3D,$8A,$8D,$CA,$95,$20,$B2,$95,$A9,$0A,$85,$D3,$C6,$D3 ; 8D1F
         dta $F0,$DF,$20,$BC,$95,$20,$AD,$87,$10,$F4,$20,$4E,$8E,$10,$EF,$4C ; 8D2F
         dta $D5,$BD,$AD,$78,$02,$AE,$54,$93,$F0,$05,$4A,$4A,$4C,$A5,$8D,$4A ; 8D3F
         dta $B0,$18,$AE,$58,$93,$10,$0B,$A5,$14,$29,$02,$D0,$01,$60,$CE,$4E ; 8D4F
         dta $93,$60,$A2,$01,$8E,$54,$93,$8E,$55,$93,$4A,$B0,$39,$AE,$56,$93 ; 8D5F
         dta $10,$0E,$A5,$14,$29,$02,$D0,$01,$60,$EE,$4E,$93,$EE,$4E,$93,$60 ; 8D6F
         dta $48,$8A,$29,$01,$F0,$1F,$AD,$4E,$93,$18,$69,$04,$29,$F0,$8D,$4E ; 8D7F
         dta $93,$8C,$54,$93,$8C,$55,$93,$A9,$01,$8D,$56,$93,$AD,$57,$93,$29 ; 8D8F
         dta $40,$85,$8F,$85,$8D,$68,$AE,$59,$93,$F0,$01,$60,$4A,$B0,$17,$AD ; 8D9F
         dta $4D,$93,$F0,$12,$CE,$4D,$93,$A9,$30,$8D,$08,$8C,$A9,$F8,$8D,$10 ; 8DAF
         dta $8C,$8D,$53,$93,$D0,$13,$4A,$B0,$24,$EE,$4D,$93,$A9,$28,$8D,$08 ; 8DBF
         dta $8C,$A9,$08,$8D,$10,$8C,$8C,$53,$93,$A5,$14,$29,$02,$D0,$0D,$EE ; 8DCF
         dta $52,$93,$AD,$52,$93,$C9,$08,$90,$03,$8C,$52,$93,$60,$8C,$52,$93 ; 8DDF
         dta $60                                      ; 8DEF
