; IRQ.ASM - NMI, IRQ, VBI (cheat code at $9F75)
; $9E97-$9FDA

         org $9E97

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
         dta $72,$68,$80,$00                          ; 9FD7
