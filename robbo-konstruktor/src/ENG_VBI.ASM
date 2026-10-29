; ENG_VBI.ASM - engine: VBI CVBL - info line, scrolling; input KEJO
; $2F53-$3141

         org $2F53

BDEC             dta $00                              ; 2F53 planet number in BCD (Robbo BDEC)

* VBI (Robbo CVBL): sound, info line (planet, ammunition, keys, lives, screws, score), DLI1, scrolling ---
CVBL
         jsr  SOUNDV               ; 2F54
         lda  PNUM                 ; 2F57
         pha                       ; 2F59
         lda  #$00                 ; 2F5A
         sta  BDEC                 ; 2F5C
         ldx  #$07                 ; 2F5F
         sed                       ; 2F61
L2F62
         asl  PNUM                 ; 2F62
         adc  BDEC                 ; 2F64
         sta  BDEC                 ; 2F67
         dex                       ; 2F6A
         bpl  L2F62                ; 2F6B
         cld                       ; 2F6D
         ldy  #$25                 ; 2F6E
         jsr  INFO_BYTE            ; 2F70
         pla                       ; 2F73
         sta  PNUM                 ; 2F74
         ldy  #$1F                 ; 2F76
         lda  NABO                 ; 2F78
         jsr  INFO_BYTE            ; 2F7A
         ldy  #$19                 ; 2F7D
         lda  KEYS                 ; 2F7F
         jsr  INFO_BYTE            ; 2F81
         ldy  #$13                 ; 2F84
         lda  LIVS                 ; 2F86
         jsr  INFO_BYTE            ; 2F88
         ldy  #$0D                 ; 2F8B
         lda  ZEBR                 ; 2F8D
         jsr  INFO_BYTE            ; 2F8F
         ldx  #$02                 ; 2F92
         ldy  #$07                 ; 2F94
L2F96
         lda  SCOR,x               ; 2F96
         jsr  INFO_BYTE            ; 2F98
         dex                       ; 2F9B
         bpl  L2F96                ; 2F9C
         lda  COLOR4               ; 2F9E
         sta  COLPM0               ; 2FA1
         sta  COLPM1               ; 2FA4
         sta  COLPM2               ; 2FA7
         sta  COLPM3               ; 2FAA
         lda  #$DE                 ; 2FAD
         sta  VDSLST               ; 2FAF
         lda  #$1E                 ; 2FB2
         sta  VDSLST+1             ; 2FB4
         lda  VSF                  ; 2FB7
         bne  SCRL                 ; 2FB9
         clc                       ; 2FBB
         lda  DLSA                 ; 2FBC
         adc  #$7F                 ; 2FBF
         tax                       ; 2FC1
         lda  DLSA+1               ; 2FC2
         adc  #$00                 ; 2FC5
         cpx  FADR                 ; 2FC7
         sbc  FADR+1               ; 2FC9
         bcc  L2FE4                ; 2FCB
         lda  DLSA                 ; 2FCD
         cmp  #$01                 ; 2FD0
         lda  DLSA+1               ; 2FD2
         sbc  #$B6                 ; 2FD5
         bcc  EXTV                 ; 2FD7
         lda  #$0E                 ; 2FD9
         sta  VSC                  ; 2FDB
         lda  #$82                 ; 2FDD
         sta  VSF                  ; 2FDF
         jmp  SCRL                 ; 2FE1
L2FE4
         clc                       ; 2FE4
         lda  DLSA                 ; 2FE5
         adc  #$FF                 ; 2FE8
         tax                       ; 2FEA
         lda  DLSA+1               ; 2FEB
         adc  #$01                 ; 2FEE
         cpx  FADR                 ; 2FF0
         sbc  FADR+1               ; 2FF2
         bcc  L2FF9                ; 2FF4

* end of the VBI -------------------------------------------
EXTV
         jmp  XITVBV               ; 2FF6
L2FF9
         lda  DLSA                 ; 2FF9
         cmp  #$40                 ; 2FFC
         lda  DLSA+1               ; 2FFE
         sbc  #$BB                 ; 3001
         bcs  EXTV                 ; 3003
         lda  #$02                 ; 3005
         sta  VSC                  ; 3007
         lda  #$42                 ; 3009
         sta  VSF                  ; 300B

* scroll the cave view -------------------------------------
SCRL
         bit  VSF                  ; 300D
         bpl  SCDW                 ; 300F
         lda  VSC                  ; 3011
         bne  SCU1                 ; 3013
         sta  VSCROL               ; 3015
         lda  #$0E                 ; 3018
         sta  VSC                  ; 301A
         lda  VSF                  ; 301C
         dec  VSF                  ; 301E
         and  #$0F                 ; 3020
         bne  L3026                ; 3022
         sta  VSF                  ; 3024
L3026
         jmp  EXTV                 ; 3026

* scroll up ------------------------------------------------
SCU1
         dec  VSC                  ; 3029
         dec  VSC                  ; 302B
         and  #$07                 ; 302D
         sta  VSCROL               ; 302F
         cmp  #$06                 ; 3032
         bne  EXTV                 ; 3034
         sec                       ; 3036
         lda  DLSA                 ; 3037
         sbc  #$20                 ; 303A
         sta  DLSA                 ; 303C
         bcs  L3044                ; 303F
         dec  DLSA+1               ; 3041
L3044
         lda  #$06                 ; 3044
         sta  VSCROL               ; 3046
         lda  VSC                  ; 3049
         bne  EXTV                 ; 304B

* scroll down ----------------------------------------------
SCDW
         lda  VSC                  ; 304D
         inc  VSC                  ; 304F
         inc  VSC                  ; 3051
         and  #$07                 ; 3053
         sta  VSCROL               ; 3055
         bne  EXTV                 ; 3058

* scroll: load a screen line -------------------------------
LDW
         clc                       ; 305A
         lda  DLSA                 ; 305B
         adc  #$20                 ; 305E
         sta  DLSA                 ; 3060
         bcc  L3068                ; 3063
         inc  DLSA+1               ; 3065
L3068
         lda  VSC                  ; 3068
         cmp  #$10                 ; 306A
         bcc  EXTV                 ; 306C
         lda  VSF                  ; 306E
         dec  VSF                  ; 3070
         and  #$0F                 ; 3072
         bne  L3078                ; 3074
         sta  VSF                  ; 3076
L3078
         lda  #$02                 ; 3078
         sta  VSC                  ; 307A
         jmp  EXTV                 ; 307C

* show a BCD byte in the info line at Y (Robbo DSPB) -------
INFO_BYTE
         pha                       ; 307F
         jsr  INFO_DIGIT           ; 3080
         pla                       ; 3083
         lsr                       ; 3084
         lsr                       ; 3085
         lsr                       ; 3086
         lsr                       ; 3087

* show a digit in the info line at Y, top and bottom half (Robbo DSPD) ---
INFO_DIGIT
         stx  DSPB_X               ; 3088
         and  #$0F                 ; 308B
         tax                       ; 308D
         lda  DIGIT_T,x            ; 308E
         sta  INFO_TOP,y           ; 3091
         lda  DIGIT_B,x            ; 3094
         sta  INFO_BOT,y           ; 3097
DSPB_X           equ *+1                              ; 309B X kept by INFO_DIGIT
         ldx  #$9A                 ; 309A
         dey                       ; 309C
         rts                       ; 309D
DIGIT_T          dta $06,$03,$07,$07,$08,$09,$09,$0A,$0B,$0B ; 309E digits 0-9: character of the upper half
DIGIT_B          dta $02,$03,$04,$05,$03,$05,$02,$03,$02,$05 ; 30A8 digits 0-9: character of the lower half

* read the input (Robbo: "key to joy"): fire = triggers, SHIFT, RETURN; ESC; stick = both joysticks AND cursor keys ---
KEJO
         lda  SKCTL                ; 30B2
         and  #$04                 ; 30B5
         bne  L30C1                ; 30B7
         lda  KBCODE               ; 30B9
         and  #$3F                 ; 30BC
         sec                       ; 30BE
         sbc  #$0C                 ; 30BF
L30C1
         beq  L30C5                ; 30C1
         lda  #$01                 ; 30C3
L30C5
         sta  KEY_FIRE             ; 30C5
         lda  SKCTL                ; 30C8
         lsr                       ; 30CB
         lsr                       ; 30CC
         lsr                       ; 30CD
KEY_FIRE         equ *+1                              ; 30CF RETURN held: 0 (fire), else 1; ANDed with SHIFT and both triggers
         and  #$00                 ; 30CE
         and  TRIG0                ; 30D0
         and  TRIG1                ; 30D3
         sta  FIRE                 ; 30D6
         cmp  FIRE_LAST            ; 30D9
         beq  L30E1                ; 30DC
         sta  INPUT_NEW            ; 30DE
L30E1
         lda  FIRE                 ; 30E1
         sta  FIRE_LAST            ; 30E4
         txa                       ; 30E7
         pha                       ; 30E8
         ldx  #$00                 ; 30E9
         jsr  GET_KEY              ; 30EB
         bcs  L3101                ; 30EE
         cmp  #$1C                 ; 30F0
         bne  L30F7                ; 30F2
         sta  ESC_KEY              ; 30F4
L30F7
         ldx  #$04                 ; 30F7
L30F9
         cmp  KEJO_KEYS,x          ; 30F9
         beq  L3101                ; 30FC
         dex                       ; 30FE
         bne  L30F9                ; 30FF
L3101
         lda  KEJO_DIRS,x          ; 3101
         sta  KEY_DIR              ; 3104
         pla                       ; 3107
         tax                       ; 3108
         lda  PORTA                ; 3109
         lsr                       ; 310C
         lsr                       ; 310D
         lsr                       ; 310E
         lsr                       ; 310F
         and  PORTA                ; 3110
KEY_DIR          equ *+1                              ; 3114 stick bits of the cursor key (KEJO_DIRS), ANDed with both sticks
         and  #$00                 ; 3113
         sta  MOVE_IN              ; 3115
         cmp  #$0F                 ; 3118
         beq  L311F                ; 311A
         sta  INPUT_NEW            ; 311C
L311F
         rts                       ; 311F

* no input pending (INPUT_NEW = 0): set INPUT_NEW and MOVE_DIR to $FF, A = 0 - not called ---
INPUT_FORCE
         lda  INPUT_NEW            ; 3120
         bne  L312F                ; 3123
         lda  #$FF                 ; 3125
         sta  INPUT_NEW            ; 3127
         sta  MOVE_DIR             ; 312A
         lda  #$00                 ; 312D
L312F
         rts                       ; 312F

* key pressed: carry clear, A = key code; none: carry set, A = $FF ---
GET_KEY
         lda  SKCTL                ; 3130
         and  #$04                 ; 3133
         bne  L313E                ; 3135
         lda  KBCODE               ; 3137
         and  #$3F                 ; 313A
         clc                       ; 313C
         rts                       ; 313D
L313E
         lda  #$FF                 ; 313E
         sec                       ; 3140
         rts                       ; 3141
