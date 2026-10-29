; PLAYER.ASM - player control (deferred VBI $8A8F), music on/off
; $8A4D-$8DEF

         org $8A4D

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
entry_8A8F
         lda  RTCLOK+2             ; 8A8F
         and  #$01                 ; 8A91
         bne  L8A9B                ; 8A93
         jsr  sub_8C2F             ; 8A95
         jmp  L8AA6                ; 8A98
L8A9B
         lda  CONSOL               ; 8A9B
         and  #$04                 ; 8A9E
         jsr  sub_8A64             ; 8AA0
         jsr  sub_8F08             ; 8AA3
L8AA6
         lda  #$00                 ; 8AA6
         sta  $A8                  ; 8AA8
         lda  #$CC                 ; 8AAA
         sta  $A3                  ; 8AAC
         lda  $934D                ; 8AAE
         bne  L8ABE                ; 8AB1
         ldx  #$03                 ; 8AB3
         sta  HPOSP0,x             ; 8AB5
         dex                       ; 8AB8
         bpl  L8ABE                ; 8AB9
         jmp  L8C03                ; 8ABB
L8ABE
         lda  $934E                ; 8ABE
         clc                       ; 8AC1
         adc  #$1B                 ; 8AC2
         sta  $A2                  ; 8AC4
         ldy  $9351                ; 8AC6
         lda  $C650,y              ; 8AC9
         sta  $A0                  ; 8ACC
         lda  $C670,y              ; 8ACE
         adc  $A8                  ; 8AD1
         adc  $A8                  ; 8AD3
         sta  $A1                  ; 8AD5
         ldy  $9353                ; 8AD7
         bne  L8ADF                ; 8ADA
         jmp  L8C18                ; 8ADC
L8ADF
         ldy  #$23                 ; 8ADF
         lda  #$00                 ; 8AE1
         sta  ($A2),y              ; 8AE3
         dey                       ; 8AE5
         sta  ($A2),y              ; 8AE6
         dey                       ; 8AE8
         sta  ($A2),y              ; 8AE9
         dey                       ; 8AEB
         dta $B3,$A0,$BD,$00,$C0,$91,$A2,$88,$B3,$A0,$BD,$00,$C0,$91,$A2,$88 ; 8AEC
         dta $B3,$A0,$BD,$00,$C0,$91,$A2,$88,$B3,$A0,$BD,$00,$C0,$91,$A2,$88 ; 8AFC
         dta $B3,$A0,$BD,$00,$C0,$91,$A2,$88,$B3,$A0,$BD,$00,$C0,$91,$A2,$88 ; 8B0C
         dta $B3,$A0,$BD,$00,$C0,$91,$A2,$88,$B3,$A0,$BD,$00,$C0,$91,$A2,$88 ; 8B1C
         dta $B3,$A0,$BD,$00,$C0,$91,$A2,$88,$B3,$A0,$BD,$00,$C0,$91,$A2,$88 ; 8B2C
         dta $B3,$A0,$BD,$00,$C0,$91,$A2,$88,$B3,$A0,$BD,$00,$C0,$91,$A2,$88 ; 8B3C
         dta $B3,$A0,$BD,$00,$C0,$91,$A2,$88,$B3,$A0,$BD,$00,$C0,$91,$A2,$88 ; 8B4C
         dta $B3,$A0,$BD,$00,$C0,$91,$A2,$88,$B3,$A0,$BD,$00,$C0,$91,$A2,$88 ; 8B5C
         dta $B3,$A0,$BD,$00,$C0,$91,$A2,$88,$B3,$A0,$BD,$00,$C0,$91,$A2,$88 ; 8B6C
         dta $B3,$A0,$BD,$00,$C0,$91,$A2,$88,$B3,$A0,$BD,$00,$C0,$91,$A2,$88 ; 8B7C
         dta $B3,$A0,$BD,$00,$C0,$91,$A2,$88,$B3,$A0,$BD,$00,$C0,$91,$A2,$88 ; 8B8C
         dta $B3,$A0,$BD,$00,$C0,$91,$A2,$88,$B3,$A0,$BD,$00,$C0,$91,$A2,$88 ; 8B9C
         dta $B3,$A0,$BD,$00,$C0,$91,$A2,$88,$B3,$A0,$BD,$00,$C0,$91,$A2,$88 ; 8BAC
         dta $B3,$A0,$BD,$00,$C0,$91,$A2,$88,$B3,$A0,$BD,$00,$C0,$91,$A2,$88 ; 8BBC
         dta $B3,$A0,$BD,$00,$C0,$91,$A2,$88,$B3,$A0,$BD,$00,$C0,$91,$A2,$88 ; 8BCC
         dta $B3,$A0,$BD,$00,$C0,$91,$A2,$88,$B3,$A0,$BD,$00,$C0,$91,$A2,$88 ; 8BDC
L8BEC
         lda  #$00                 ; 8BEC
         sta  ($A2),y              ; 8BEE
         dec  $A2                  ; 8BF0
         sta  ($A2),y              ; 8BF2
         inc  $A2                  ; 8BF4
         inc  $A3                  ; 8BF6
         inc  $A8                  ; 8BF8
         lda  $A8                  ; 8BFA
         cmp  #$04                 ; 8BFC
         beq  L8C03                ; 8BFE
         jmp  L8ABE                ; 8C00
L8C03
         lda  $934D                ; 8C03
         clc                       ; 8C06
         adc  #$28                 ; 8C07
         sta  HPOSP0               ; 8C09
         sta  HPOSP1               ; 8C0C
         adc  #$08                 ; 8C0F
         sta  HPOSP2               ; 8C11
         sta  HPOSP3               ; 8C14
         rts                       ; 8C17
L8C18
         ldy  #$23                 ; 8C18
         lda  #$00                 ; 8C1A
         sta  ($A2),y              ; 8C1C
         dey                       ; 8C1E
         sta  ($A2),y              ; 8C1F
         dey                       ; 8C21
         sta  ($A2),y              ; 8C22
         dey                       ; 8C24
L8C25
         lda  ($A0),y              ; 8C25
         sta  ($A2),y              ; 8C27
         dey                       ; 8C29
         bne  L8C25                ; 8C2A
         jmp  L8BEC                ; 8C2C
sub_8C2F
         lda  $8D                  ; 8C2F
         beq  L8C34                ; 8C31
         rts                       ; 8C33
L8C34
         ldy  #$00                 ; 8C34
         lda  $934E                ; 8C36
         cmp  #$90                 ; 8C39
         bcc  L8C6E                ; 8C3B
         lda  $9351                ; 8C3D
         cmp  #$0F                 ; 8C40
         beq  L8C59                ; 8C42
         lda  #$0F                 ; 8C44
         sta  $9351                ; 8C46
         lda  #$0A                 ; 8C49
         sta  $8C5A                ; 8C4B
         dec  $A7                  ; 8C4E
         lda  #$21                 ; 8C50
         ldx  #$18                 ; 8C52
         ldy  #$14                 ; 8C54
         jmp  entry_F2E4           ; 8C56
L8C59
         lda  #$00                 ; 8C59
         beq  L8C61                ; 8C5B
         dec  $8C5A                ; 8C5D
         rts                       ; 8C60
L8C61
         lda  $934F                ; 8C61
         sta  $934D                ; 8C64
         lda  $9350                ; 8C67
         sta  $934E                ; 8C6A
         rts                       ; 8C6D
L8C6E
         jsr  sub_8D41             ; 8C6E
         lda  $934E                ; 8C71
         and  #$0F                 ; 8C74
         bne  L8CB9                ; 8C76
         lda  $9355                ; 8C78
         beq  L8C81                ; 8C7B
         cmp  #$0A                 ; 8C7D
         bcc  L8CB9                ; 8C7F
L8C81
         lda  $9356                ; 8C81
         and  #$01                 ; 8C84
         beq  L8CB9                ; 8C86
L8C88
         sty  $9354                ; 8C88
         ldx  $9352                ; 8C8B
L8C8E
         lda  $9354                ; 8C8E
         bmi  L8CB2                ; 8C91
         lda  $9359                ; 8C93
         bne  L8CA6                ; 8C96
         lda  STRIG0               ; 8C98
         and  #$01                 ; 8C9B
         bne  L8CB2                ; 8C9D
         ldx  #$0D                 ; 8C9F
         stx  $9359                ; 8CA1
         bne  L8CB2                ; 8CA4
L8CA6
         tax                       ; 8CA6
         inx                       ; 8CA7
         stx  $9359                ; 8CA8
         cpx  #$10                 ; 8CAB
         bcc  L8CB2                ; 8CAD
         sty  $9359                ; 8CAF
L8CB2
         lda  $9379,x              ; 8CB2
         sta  $9351                ; 8CB5
         rts                       ; 8CB8
L8CB9
         lda  $9358                ; 8CB9
         bpl  L8CD3                ; 8CBC
         lda  $934E                ; 8CBE
         and  #$FE                 ; 8CC1
         sta  $934E                ; 8CC3
         ldx  #$09                 ; 8CC6
         and  #$02                 ; 8CC8
         bne  L8CCE                ; 8CCA
         ldx  #$0A                 ; 8CCC
L8CCE
         stx  $9352                ; 8CCE
         bne  L8C88                ; 8CD1
L8CD3
         lda  $9354                ; 8CD3
         bmi  L8CFA                ; 8CD6
         beq  L8CF2                ; 8CD8
         ldx  $9355                ; 8CDA
         cpx  #$0C                 ; 8CDD
         beq  L8CF2                ; 8CDF
         lda  $9395,x              ; 8CE1
         clc                       ; 8CE4
         adc  $934E                ; 8CE5
         sta  $934E                ; 8CE8
         inc  $9355                ; 8CEB
         ldx  #$0C                 ; 8CEE
         bne  L8C8E                ; 8CF0
L8CF2
         sty  $9355                ; 8CF2
         lda  #$80                 ; 8CF5
         sta  $9354                ; 8CF7
L8CFA
         inc  $934E                ; 8CFA
         inc  $934E                ; 8CFD
         lda  $934E                ; 8D00
         and  #$FE                 ; 8D03
         sta  $934E                ; 8D05
         sty  $9359                ; 8D08
         ldx  #$0C                 ; 8D0B
         jmp  L8C8E                ; 8D0D
         dta $4C,$ED,$7E,$AD,$0A,$D2,$29,$03,$0A,$AA,$BD,$3C,$8A,$8D,$C5,$95 ; 8D10
         dta $BD,$3D,$8A,$8D,$CA,$95,$20,$B2,$95,$A9,$0A,$85,$D3,$C6,$D3,$F0 ; 8D20
         dta $DF,$20,$BC,$95,$20,$AD,$87,$10,$F4,$20,$4E,$8E,$10,$EF,$4C,$D5 ; 8D30
         dta $BD                                      ; 8D40
sub_8D41
         lda  STICK0               ; 8D41
         ldx  $9354                ; 8D44
         beq  L8D4E                ; 8D47
         lsr                       ; 8D49
         lsr                       ; 8D4A
         jmp  L8DA5                ; 8D4B
L8D4E
         lsr                       ; 8D4E
         bcs  L8D69                ; 8D4F
         ldx  $9358                ; 8D51
         bpl  L8D61                ; 8D54
         lda  RTCLOK+2             ; 8D56
         and  #$02                 ; 8D58
         bne  L8D5D                ; 8D5A
         rts                       ; 8D5C
L8D5D
         dec  $934E                ; 8D5D
         rts                       ; 8D60
L8D61
         ldx  #$01                 ; 8D61
         stx  $9354                ; 8D63
         stx  $9355                ; 8D66
L8D69
         lsr                       ; 8D69
         bcs  L8DA5                ; 8D6A
         ldx  $9356                ; 8D6C
         bpl  L8D7F                ; 8D6F
         lda  RTCLOK+2             ; 8D71
         and  #$02                 ; 8D73
         bne  L8D78                ; 8D75
         rts                       ; 8D77
L8D78
         inc  $934E                ; 8D78
         inc  $934E                ; 8D7B
         rts                       ; 8D7E
L8D7F
         pha                       ; 8D7F
         txa                       ; 8D80
         and  #$01                 ; 8D81
         beq  L8DA4                ; 8D83
         lda  $934E                ; 8D85
         clc                       ; 8D88
         adc  #$04                 ; 8D89
         and  #$F0                 ; 8D8B
         sta  $934E                ; 8D8D
         sty  $9354                ; 8D90
         sty  $9355                ; 8D93
         lda  #$01                 ; 8D96
         sta  $9356                ; 8D98
         lda  $9357                ; 8D9B
         and  #$40                 ; 8D9E
         sta  $8F                  ; 8DA0
         sta  $8D                  ; 8DA2
L8DA4
         pla                       ; 8DA4
L8DA5
         ldx  $9359                ; 8DA5
         beq  L8DAB                ; 8DA8
         rts                       ; 8DAA
L8DAB
         lsr                       ; 8DAB
         bcs  L8DC5                ; 8DAC
         lda  $934D                ; 8DAE
         beq  L8DC5                ; 8DB1
         dec  $934D                ; 8DB3
         lda  #$30                 ; 8DB6
         sta  $8C08                ; 8DB8
         lda  #$F8                 ; 8DBB
         sta  $8C10                ; 8DBD
         sta  $9353                ; 8DC0
         bne  L8DD8                ; 8DC3
L8DC5
         lsr                       ; 8DC5
         bcs  L8DEC                ; 8DC6
         inc  $934D                ; 8DC8
         lda  #$28                 ; 8DCB
         sta  $8C08                ; 8DCD
         lda  #$08                 ; 8DD0
         sta  $8C10                ; 8DD2
         sty  $9353                ; 8DD5
L8DD8
         lda  RTCLOK+2             ; 8DD8
         and  #$02                 ; 8DDA
         bne  L8DEB                ; 8DDC
         inc  $9352                ; 8DDE
         lda  $9352                ; 8DE1
         cmp  #$08                 ; 8DE4
         bcc  L8DEB                ; 8DE6
         sty  $9352                ; 8DE8
L8DEB
         rts                       ; 8DEB
L8DEC
         sty  $9352                ; 8DEC
         rts                       ; 8DEF
