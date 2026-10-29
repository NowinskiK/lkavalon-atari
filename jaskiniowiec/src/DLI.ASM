; DLI.ASM - DLI chain ($8874), display lists ($8974, $89D8)
; $8874-$8A4C

         org $8874

entry_8874
         sta  $88A4                ; 8874
         stx  $88A6                ; 8877
         sty  $88A8                ; 887A
         lda  $86                  ; 887D
         ldx  $87                  ; 887F
         ldy  $88                  ; 8881
         sta  WSYNC                ; 8883
         sta  COLBK                ; 8886
         stx  COLPF0               ; 8889
         sty  COLPF1               ; 888C
         lda  $89                  ; 888F
         ldx  $8A                  ; 8891
         sta  COLPF2               ; 8893
         stx  COLPF3               ; 8896
         lda  #$AA                 ; 8899
         ldx  #$88                 ; 889B
         sta  VDSLST               ; 889D
         stx  $0201                ; 88A0
         lda  #$00                 ; 88A3
         ldx  #$00                 ; 88A5
         ldy  #$00                 ; 88A7
         rti                       ; 88A9
entry_88AA
         pha                       ; 88AA
         txa                       ; 88AB
         pha                       ; 88AC
         inc  $A4                  ; 88AD
         sta  WSYNC                ; 88AF
         lda  $83                  ; 88B2
         sta  CHBASE               ; 88B4
         ldx  $A4                  ; 88B7
         cpx  #$03                 ; 88B9
         bcc  L88F1                ; 88BB
         cpx  #$0B                 ; 88BD
         bcc  L891B                ; 88BF
         sta  WSYNC                ; 88C1
         lda  #$6C                 ; 88C4
         sta  CHBASE               ; 88C6
         lda  #$0E                 ; 88C9
         sta  COLPF1               ; 88CB
         ldx  #$0B                 ; 88CE
L88D0
         lda  $936D,x              ; 88D0
         sta  COLPF2               ; 88D3
         sta  COLBK                ; 88D6
         sta  WSYNC                ; 88D9
         dex                       ; 88DC
         bpl  L88D0                ; 88DD
         lda  #$00                 ; 88DF
         sta  $A4                  ; 88E1
         lda  #$74                 ; 88E3
         ldx  #$88                 ; 88E5
         sta  VDSLST               ; 88E7
         stx  $0201                ; 88EA
         pla                       ; 88ED
         tax                       ; 88EE
         pla                       ; 88EF
         rti                       ; 88F0
L88F1
         dex                       ; 88F1
         txa                       ; 88F2
         asl                       ; 88F3
         asl                       ; 88F4
         asl                       ; 88F5
         tax                       ; 88F6
         sta  WSYNC                ; 88F7
         lda  $935D,x              ; 88FA
         sta  COLBK                ; 88FD
         sta  WSYNC                ; 8900
         lda  $935E,x              ; 8903
         sta  COLBK                ; 8906
         sta  WSYNC                ; 8909
         lda  $935F,x              ; 890C
         sta  COLBK                ; 890F
         sta  WSYNC                ; 8912
         lda  $9360,x              ; 8915
         sta  COLBK                ; 8918
L891B
         lda  #$29                 ; 891B
         sta  VDSLST               ; 891D
         lda  #$89                 ; 8920
         sta  $0201                ; 8922
         pla                       ; 8925
         tax                       ; 8926
         pla                       ; 8927
         rti                       ; 8928
entry_8929
         pha                       ; 8929
         txa                       ; 892A
         pha                       ; 892B
         lda  $83                  ; 892C
         sta  WSYNC                ; 892E
         ora  #$04                 ; 8931
         sta  CHBASE               ; 8933
         ldx  $A4                  ; 8936
         cpx  #$03                 ; 8938
         bcs  L8966                ; 893A
         dex                       ; 893C
         txa                       ; 893D
         asl                       ; 893E
         asl                       ; 893F
         asl                       ; 8940
         tax                       ; 8941
         sta  WSYNC                ; 8942
         lda  $9361,x              ; 8945
         sta  COLBK                ; 8948
         sta  WSYNC                ; 894B
         lda  $9362,x              ; 894E
         sta  COLBK                ; 8951
         sta  WSYNC                ; 8954
         lda  $9363,x              ; 8957
         sta  COLBK                ; 895A
         sta  WSYNC                ; 895D
         lda  $9364,x              ; 8960
         sta  COLBK                ; 8963
L8966
         lda  #$AA                 ; 8966
         sta  VDSLST               ; 8968
         lda  #$88                 ; 896B
         sta  $0201                ; 896D
         pla                       ; 8970
         tax                       ; 8971
         pla                       ; 8972
         rti                       ; 8973
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
