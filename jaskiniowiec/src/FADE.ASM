; FADE.ASM - colour fades
; $96C8-$9795

         org $96C8

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
