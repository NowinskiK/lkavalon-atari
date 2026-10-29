; LEVEL.ASM - level loaders, text screens, level completion; ending scroller VBI ($9CFB)
; $9A00-$9E96

         org $9A00

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
