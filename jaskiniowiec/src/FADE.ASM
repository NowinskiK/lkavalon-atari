; FADE.ASM - colour fades
; $96C8-$9795

         org $96C8


* fade out and clear the screens ---------------------------
FADE_OUT
         ldy  #$07                 ; 96C8
L96CA
         jsr  WAIT_FRAME           ; 96CA
         jsr  FADE_STEP            ; 96CD
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
         jsr  WAIT_FRAME           ; 96E1
         jsr  FADE_STEP            ; 96E4
         dey                       ; 96E7
         bne  L96E1                ; 96E8
         rts                       ; 96EA

* one fade-out step ----------------------------------------
FADE_STEP
         ldx  #$01                 ; 96EB
         dec  COL_PF               ; 96ED
         lda  COL_PF               ; 96EF
         and  #$0F                 ; 96F1
         bne  L96F7                ; 96F3
         stx  COL_PF               ; 96F5
L96F7
         dec  COL_PF+1             ; 96F7
         lda  COL_PF+1             ; 96F9
         and  #$0F                 ; 96FB
         bne  L9701                ; 96FD
         stx  COL_PF+1             ; 96FF
L9701
         dec  COL_PF+2             ; 9701
         lda  COL_PF+2             ; 9703
         and  #$0F                 ; 9705
         bne  L970B                ; 9707
         stx  COL_PF+2             ; 9709
L970B
         dec  COL_PF+3             ; 970B
         lda  COL_PF+3             ; 970D
         and  #$0F                 ; 970F
         bne  L9715                ; 9711
         stx  COL_PF+3             ; 9713
L9715
         rts                       ; 9715
         dta $A9,$FF,$8D,$01,$D3,$A9,$00,$8D,$00,$D4,$8D,$0E,$D4,$8D,$2F,$02 ; 9716
         dta $4C,$77,$E4                              ; 9726

* fade in (status line colour fixed) -----------------------
FADE_IN2
         lda  TARGET_COLS          ; 9729
         and  #$F0                 ; 972C
         sta  COL_PF               ; 972E
         lda  TARGET_COLS+1        ; 9730
         and  #$F0                 ; 9733
         sta  COL_PF+1             ; 9735
         lda  TARGET_COLS+2        ; 9737
         and  #$F0                 ; 973A
         sta  COL_PF+2             ; 973C
         lda  #$20                 ; 973E
         sta  COL_PF+3             ; 9740
         bne  L9760                ; 9742

* fade in to TARGET_COLS -----------------------------------
FADE_IN
         lda  TARGET_COLS          ; 9744
         and  #$F0                 ; 9747
         sta  COL_PF               ; 9749
         lda  TARGET_COLS+1        ; 974B
         and  #$F0                 ; 974E
         sta  COL_PF+1             ; 9750
         lda  TARGET_COLS+2        ; 9752
         and  #$F0                 ; 9755
         sta  COL_PF+2             ; 9757
         lda  TARGET_COLS+3        ; 9759
         and  #$F0                 ; 975C
         sta  COL_PF+3             ; 975E
L9760
         ldy  #$0F                 ; 9760
L9762
         jsr  WAIT_FRAME           ; 9762
         lda  COL_PF               ; 9765
         cmp  TARGET_COLS          ; 9767
         beq  L976E                ; 976A
         inc  COL_PF               ; 976C
L976E
         lda  COL_PF+1             ; 976E
         cmp  TARGET_COLS+1        ; 9770
         beq  L9777                ; 9773
         inc  COL_PF+1             ; 9775
L9777
         lda  COL_PF+2             ; 9777
         cmp  TARGET_COLS+2        ; 9779
         beq  L9780                ; 977C
         inc  COL_PF+2             ; 977E
L9780
         lda  COL_PF+3             ; 9780
         and  #$0F                 ; 9782
         sta  $978D                ; 9784
         lda  TARGET_COLS+3        ; 9787
         and  #$0F                 ; 978A
         cmp  #$00                 ; 978C
         beq  L9792                ; 978E
         inc  COL_PF+3             ; 9790
L9792
         dey                       ; 9792
         bne  L9762                ; 9793
         rts                       ; 9795
