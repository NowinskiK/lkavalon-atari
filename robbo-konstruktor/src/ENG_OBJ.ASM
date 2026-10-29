; ENG_OBJ.ASM - engine: object behaviours (table $31EF) - teleports, surprise, boxes, bomb, magnets, guns, bullets, creatures, bats, eyes, capsule
; $28EC-$2F52

         org $28EC

TELE_CODE        dta $00                              ; 28EC teleport Robbo is entering (TELE_IN)

* Robbo entering a teleport, code $39 (Konstruktor): FAC = 1, TELE = the teleport, put the teleport back ---
TELE_IN
         lda  #$01                 ; 28ED
         sta  FAC                  ; 28EF
         lda  TELE_CODE            ; 28F1
         sta  TELE                 ; 28F4
         jmp  PUT_                 ; 28F6
         dta $00,$0F,$11,$20                          ; 28F9

* teleport $30-$38 (Robbo: "wyj z telepor"): if it is TELE, Robbo comes out next to it ---
TELP
         jsr  TST_                 ; 28FD
         cmp  TELE                 ; 2900
         beq  L2905                ; 2902
         rts                       ; 2904
L2905
         lda  #$01                 ; 2905
         sta  FAC                  ; 2907
         sec                       ; 2909
         lda  ADDR                 ; 290A
         sbc  #$10                 ; 290C
         sta  ADDR                 ; 290E
         bcs  L2914                ; 2910
         dec  ADDR+1               ; 2912
L2914
         ldx  #$03                 ; 2914
L2916
         ldy  $28F9,x              ; 2916
         lda  (ADDR),y             ; 2919
         cmp  #$20                 ; 291B
         beq  L2923                ; 291D
         dex                       ; 291F
         bpl  L2916                ; 2920
         rts                       ; 2922
L2923
         lda  #$69                 ; 2923
         jsr  PUT_                 ; 2925
         jsr  FD_                  ; 2928
         bcc  WYSE                 ; 292B
         lda  LM                   ; 292D
         pha                       ; 292F
         ldy  #$00                 ; 2930
L2932
         iny                       ; 2932
         lsr                       ; 2933
         bcs  L2932                ; 2934
         tya                       ; 2936
         asl                       ; 2937
         asl                       ; 2938
         tay                       ; 2939
         dey                       ; 293A

* teleport exit: try the directions in turn (table TMVS $296B) for a free cell (Robbo WYCP) ---
WYCP
         tya                       ; 293B
         pha                       ; 293C
         lda  $296B,y              ; 293D
         sta  LM                   ; 2940
         jsr  FD_                  ; 2942
         pla                       ; 2945
         tay                       ; 2946
         bcc  L2954                ; 2947
         dey                       ; 2949
         bpl  WYCP                 ; 294A
         pla                       ; 294C
         sta  LM                   ; 294D
         lda  TELE                 ; 294F
         jmp  PUT_                 ; 2951
L2954
         pla                       ; 2954
         sta  LM                   ; 2955

* Robbo leaves the teleport: put him at the new cell, the teleport back, TELE = 1 (Robbo WYSE) ---
WYSE
         jsr  MFX1                 ; 2957
         lda  X1                   ; 295A
         sta  X                    ; 295C
         lda  Y1                   ; 295E
         sta  Y                    ; 2960
         lda  TELE                 ; 2962
         ldx  #$01                 ; 2964
         stx  TELE                 ; 2966
         jmp  PUT_                 ; 2968
         dta $0D,$0B,$07,$0E,$0E,$07,$0B,$0D,$07,$0E,$0D,$0B,$0B,$0D,$0E,$07 ; 296B

* surprise box: random object (RND) ------------------------
NIES
         lda  RANDOM               ; 297B
         and  #$1F                 ; 297E
         tax                       ; 2980
         lda  $29D3,x              ; 2981
         beq  L2989                ; 2984
         jmp  PUT_                 ; 2986
L2989
         lda  #$2B                 ; 2989
         jsr  PUT_                 ; 298B
         lda  #$1E                 ; 298E
         sta  Y                    ; 2990
L2992
         lda  #$0F                 ; 2992
         sta  X                    ; 2994

* "super!" - a rare surprise (Robbo: "super!"): over the whole board magnets vanish, doors, eyes and creatures explode (Robbo SUP1) ---
SUP1
         jsr  TST_                 ; 2996
         and  #$7F                 ; 2999
         tax                       ; 299B
         lda  #$A0                 ; 299C
         cpx  #$28                 ; 299E
         beq  L29BC                ; 29A0
         cpx  #$29                 ; 29A2
         beq  L29BC                ; 29A4
         cpx  #$7C                 ; 29A6
         beq  SUP2                 ; 29A8
         cpx  #$12                 ; 29AA
         beq  SUP2                 ; 29AC
         cpx  #$26                 ; 29AE
         beq  SUP2                 ; 29B0
         cpx  #$41                 ; 29B2
         bcc  L29BF                ; 29B4
         cpx  #$4F                 ; 29B6
         bcs  L29BF                ; 29B8

* put an explosion $E1; at the end +500 points, sound $0D (Robbo SUP2) ---
SUP2
         lda  #$E1                 ; 29BA
L29BC
         jsr  PUT_                 ; 29BC
L29BF
         dec  X                    ; 29BF
         bpl  SUP1                 ; 29C1
         dec  Y                    ; 29C3
         bpl  L2992                ; 29C5
         ldx  #$05                 ; 29C7
         lda  #$00                 ; 29C9
         jsr  ASCO                 ; 29CB
         lda  #$0D                 ; 29CE
         jmp  SOUND_               ; 29D0
         dta $00,$00,$3F,$3F,$21,$21,$21,$21,$3D,$3D,$3D,$24,$24,$24,$24,$24 ; 29D3
         dta $26,$26,$40,$2B,$2B,$2B,$2B,$2B,$63,$63,$15,$2C,$2E,$2D,$2F,$23 ; 29E3

* sliding box (bezwladna skrzynia) moving left until blocked (Robbo: "bezw skrzynie") ---
BEZL
         jsr  LT_                  ; 29F3
         bcc  BEZX                 ; 29F6
         jsr  BEZS                 ; 29F8
         jmp  PP1L                 ; 29FB

* sliding box (bezwladna skrzynia) moving right until blocked (Robbo: "bezw skrzynie") ---
BEZR
         jsr  RT_                  ; 29FE
         bcc  BEZX                 ; 2A01
         jsr  BEZS                 ; 2A03
         jmp  PP1R                 ; 2A06

* sliding box (bezwladna skrzynia) moving up until blocked (Robbo: "bezw skrzynie") ---
BEZU
         jsr  UP_                  ; 2A09
         bcc  BEZX                 ; 2A0C
         jsr  BEZS                 ; 2A0E
         jmp  PP1U                 ; 2A11

* sliding box (bezwladna skrzynia) moving down until blocked (Robbo: "bezw skrzynie") ---
BEZD
         jsr  DW_                  ; 2A14
         bcs  L2A1E                ; 2A17

* sliding box: cannot move ---------------------------------
BEZX
         lda  #$08                 ; 2A19
         jmp  SOUND_               ; 2A1B
L2A1E
         jsr  BEZS                 ; 2A1E
         jmp  PP1D                 ; 2A21

* sliding box: common part ---------------------------------
BEZS
         lda  #$06                 ; 2A24
         jmp  PUT_                 ; 2A26

* random return (Robbo: "losowy powrot") -------------------
RNDR
         lda  RANDOM               ; 2A29
         cmp  #$12                 ; 2A2C
         bcc  L2A32                ; 2A2E
         pla                       ; 2A30
         pla                       ; 2A31
L2A32
         rts                       ; 2A32

* bomb, code $60 (Robbo: "bomba"): explodes the 3 x 3 cells around it that may be destroyed (table $32B1, Robbo WHAT) ---
BOMB
         lda  #$00                 ; 2A33
         jsr  SOUND_               ; 2A35
         jsr  TST_                 ; 2A38
         sec                       ; 2A3B
         lda  ADDR                 ; 2A3C
         sbc  #$11                 ; 2A3E
         sta  ADDR                 ; 2A40
         bcs  L2A46                ; 2A42
         dec  ADDR+1               ; 2A44
L2A46
         ldx  #$08                 ; 2A46
L2A48
         clc                       ; 2A48
         lda  X                    ; 2A49
         adc  $2A9C,x              ; 2A4B
         cmp  #$10                 ; 2A4E
         bcs  L2A88                ; 2A50
         lda  Y                    ; 2A52
         adc  $2AA5,x              ; 2A54
         cmp  #$1F                 ; 2A57
         bcs  L2A88                ; 2A59
         ldy  $2A93,x              ; 2A5B
         lda  (ADDR),y             ; 2A5E
         and  #$7F                 ; 2A60
         tay                       ; 2A62
         cpx  #$04                 ; 2A63
         beq  BOM0                 ; 2A65
         lda  $32B1,y              ; 2A67
         and  #$02                 ; 2A6A
         beq  L2A88                ; 2A6C

* blow up one of the 3 x 3 cells: a bomb $40 becomes a lit bomb $E0 (chain reaction), the others an explosion phase from WBPO (Robbo BOM0) ---
BOM0
         tya                       ; 2A6E
         pha                       ; 2A6F
         lda  $2A93,x              ; 2A70
         tay                       ; 2A73
         pla                       ; 2A74
         cmp  #$40                 ; 2A75
         bne  L2A7D                ; 2A77
         lda  #$E0                 ; 2A79
         bne  L2A86                ; 2A7B
L2A7D
         clc                       ; 2A7D
         lda  RANDOM               ; 2A7E
         and  #$01                 ; 2A81
         adc  $2AAE,x              ; 2A83
L2A86
         sta  (ADDR),y             ; 2A86
L2A88
         dex                       ; 2A88
         bpl  L2A48                ; 2A89
         jmp  TST_                 ; 2A8B

* a bullet hit a bomb: put a lit bomb $60 (Robbo WYBO) -----
WYBO
         lda  #$60                 ; 2A8E
         jmp  PUT_                 ; 2A90
         dta $00,$01,$02,$10,$11,$12,$20,$21,$22,$FF,$00,$01,$FF,$00,$01,$FF ; 2A93
         dta $00,$01,$FF,$FF,$FF,$00,$00,$00,$01,$01,$01,$61,$62,$61,$62,$63 ; 2AA3
         dta $62,$61,$62,$61                          ; 2AB3

* put an explosion or empty space (Robbo: "put wyb|spc") ---
PUTW
         tax                       ; 2AB7
         lda  #$20                 ; 2AB8
         cpx  #$5D                 ; 2ABA
         beq  L2AC0                ; 2ABC
         cpx  #$5B                 ; 2ABE
L2AC0
         beq  L2AC4                ; 2AC0
         lda  #$66                 ; 2AC2
L2AC4
         jmp  PUT_                 ; 2AC4

* Robbo pulled left by a magnet (Robbo: "przyciagania faca") ---
MGFL
         lda  #$01                 ; 2AC7
         sta  FAC                  ; 2AC9
         sta  RUCH                 ; 2ACB
         jsr  LT_                  ; 2ACD
         bcs  PRZY                 ; 2AD0
         rts                       ; 2AD2

* pulled in by a magnet: Robbo destroyed, sound $0A --------
PRZY
         lda  #$76                 ; 2AD3
         jsr  PUT_                 ; 2AD5
         lda  #$00                 ; 2AD8
         sta  FAC                  ; 2ADA
         lda  #$0A                 ; 2ADC
         jmp  SOUND_               ; 2ADE

* Robbo pulled right by a magnet ---------------------------
MGFR
         lda  #$01                 ; 2AE1
         sta  FAC                  ; 2AE3
         sta  RUCH                 ; 2AE5
         jsr  RT_                  ; 2AE7
         bcs  PRZY                 ; 2AEA
         rts                       ; 2AEC

* small gun firing left (Robbo DZ1L) -----------------------
DZ1L
         jsr  RNDR                 ; 2AED
         lda  #$01                 ; 2AF0
         jsr  SOUND_               ; 2AF2
         jmp  PP1L                 ; 2AF5

* small gun bullet (pocisk) moving left --------------------
PO1L
         jsr  LT_                  ; 2AF8
         bcs  L2AFE                ; 2AFB
         rts                       ; 2AFD
L2AFE
         jsr  PUTW                 ; 2AFE

* small gun bullet position (pozycja pocisku): next cell left, hit tests ---
PP1L
         jsr  T_LT                 ; 2B01
         dec  X                    ; 2B04
         cpx  #$20                 ; 2B06
         beq  L2B0E                ; 2B08
         cpx  #$5D                 ; 2B0A
         bne  PPP1                 ; 2B0C
L2B0E
         lda  #$4F                 ; 2B0E
         jmp  PUT_                 ; 2B10

* small gun bullet: hit something --------------------------
PPP1
         lsr                       ; 2B13
         bcs  L2B1B                ; 2B14
         lda  #$02                 ; 2B16
         jmp  SOUND_               ; 2B18
L2B1B
         cpx  #$40                 ; 2B1B
         bne  L2B22                ; 2B1D
         jmp  WYBO                 ; 2B1F
L2B22
         cpx  #$3F                 ; 2B22
         bne  L2B29                ; 2B24
         jmp  PUNIES               ; 2B26
L2B29
         lda  #$0A                 ; 2B29
         jsr  SOUND_               ; 2B2B
         lda  #$61                 ; 2B2E
         jmp  PUT_                 ; 2B30

* small gun firing right (Robbo DZ1R) ----------------------
DZ1R
         jsr  RNDR                 ; 2B33
         lda  #$01                 ; 2B36
         jsr  SOUND_               ; 2B38
         jmp  PP1R                 ; 2B3B

* small gun bullet (pocisk) moving right -------------------
PO1R
         jsr  RT_                  ; 2B3E
         bcs  L2B44                ; 2B41
         rts                       ; 2B43
L2B44
         jsr  PUTW                 ; 2B44

* small gun bullet position (pozycja pocisku): next cell right, hit tests ---
PP1R
         jsr  T_RT                 ; 2B47
         inc  X                    ; 2B4A
         cpx  #$20                 ; 2B4C
         beq  L2B54                ; 2B4E
         cpx  #$5D                 ; 2B50
         bne  PPP1                 ; 2B52
L2B54
         lda  #$D0                 ; 2B54
         jmp  PUT_                 ; 2B56

* small gun (dzialko) fires up -----------------------------
DZ1U
         jsr  RNDR                 ; 2B59
         lda  #$01                 ; 2B5C
         jsr  SOUND_               ; 2B5E
         jmp  PP1U                 ; 2B61

* small gun bullet (pocisk) moving up ----------------------
PO1U
         jsr  UP_                  ; 2B64
         bcs  L2B6A                ; 2B67
         rts                       ; 2B69
L2B6A
         jsr  PUTW                 ; 2B6A

* small gun bullet position (pozycja pocisku): next cell up, hit tests ---
PP1U
         jsr  T_UP                 ; 2B6D
         dec  Y                    ; 2B70
         cpx  #$20                 ; 2B72
         beq  L2B7A                ; 2B74
         cpx  #$5B                 ; 2B76
         bne  PPP1                 ; 2B78
L2B7A
         lda  #$51                 ; 2B7A
         jmp  PUT_                 ; 2B7C

* small gun firing down (Robbo DZ1D) -----------------------
DZ1D
         jsr  RNDR                 ; 2B7F
         lda  #$01                 ; 2B82
         jsr  SOUND_               ; 2B84
         jmp  PP1D                 ; 2B87

* small gun bullet (pocisk) moving down --------------------
PO1D
         jsr  DW_                  ; 2B8A
         bcs  L2B90                ; 2B8D
         rts                       ; 2B8F
L2B90
         jsr  PUTW                 ; 2B90

* small gun bullet position (pozycja pocisku): next cell down, hit tests ---
PP1D
         jsr  T_DW                 ; 2B93
         inc  Y                    ; 2B96
         cpx  #$20                 ; 2B98
         beq  L2BA3                ; 2B9A
         cpx  #$5B                 ; 2B9C
         beq  L2BA3                ; 2B9E
         jmp  PPP1                 ; 2BA0
L2BA3
         lda  #$D2                 ; 2BA3
         jmp  PUT_                 ; 2BA5

* laser fires left -----------------------------------------
DZ2L
         jsr  RNDR                 ; 2BA8
         jmp  PP2L                 ; 2BAB

* laser bullet (pocisk) moving left ------------------------
PO2L
         jsr  LT_                  ; 2BAE
         bcs  L2BBA                ; 2BB1
         inc  X                    ; 2BB3
         lda  #$5D                 ; 2BB5
         jmp  PUT_                 ; 2BB7
L2BBA
         lda  #$50                 ; 2BBA
         jsr  PUT_                 ; 2BBC

* laser bullet position (pozycja pocisku): next cell left, hit tests ---
PP2L
         jsr  T_LT                 ; 2BBF
         dec  X                    ; 2BC2
         cpx  #$20                 ; 2BC4
         bne  PPP2                 ; 2BC6
         lda  #$53                 ; 2BC8
         jmp  PUT_                 ; 2BCA

* laser: hit something -------------------------------------
PPP2
         lsr                       ; 2BCD
         bcs  L2BD5                ; 2BCE
         lda  #$02                 ; 2BD0
         jmp  SOUND_               ; 2BD2
L2BD5
         cpx  #$40                 ; 2BD5
         bne  L2BDC                ; 2BD7
         jmp  WYBO                 ; 2BD9
L2BDC
         cpx  #$3F                 ; 2BDC
         bne  L2BE3                ; 2BDE
         jmp  PUNIES               ; 2BE0
L2BE3
         lda  #$0A                 ; 2BE3
         jsr  SOUND_               ; 2BE5
         lda  #$61                 ; 2BE8
         jmp  PUT_                 ; 2BEA

* laser fires right ----------------------------------------
DZ2R
         jsr  RNDR                 ; 2BED
         jmp  PP2R                 ; 2BF0

* laser bullet (pocisk) moving right -----------------------
PO2R
         jsr  RT_                  ; 2BF3
         bcs  L2BFF                ; 2BF6
         dec  X                    ; 2BF8
         lda  #$5D                 ; 2BFA
         jmp  PUT_                 ; 2BFC
L2BFF
         lda  #$4F                 ; 2BFF
         jsr  PUT_                 ; 2C01

* laser bullet position (pozycja pocisku): next cell right, hit tests ---
PP2R
         jsr  T_RT                 ; 2C04
         inc  X                    ; 2C07
         cpx  #$20                 ; 2C09
         bne  PPP2                 ; 2C0B
         lda  #$D4                 ; 2C0D
         jmp  PUT_                 ; 2C0F

* laser fires up -------------------------------------------
DZ2U
         jsr  RNDR                 ; 2C12
         jmp  PP2U                 ; 2C15

* laser bullet (pocisk) moving up --------------------------
PO2U
         jsr  UP_                  ; 2C18
         bcs  L2C24                ; 2C1B
         inc  Y                    ; 2C1D
         lda  #$5B                 ; 2C1F
         jmp  PUT_                 ; 2C21
L2C24
         lda  #$52                 ; 2C24
         jsr  PUT_                 ; 2C26

* laser bullet position (pozycja pocisku): next cell up, hit tests ---
PP2U
         jsr  T_UP                 ; 2C29
         dec  Y                    ; 2C2C
         cpx  #$20                 ; 2C2E
         bne  PPP2                 ; 2C30
         lda  #$55                 ; 2C32
         jmp  PUT_                 ; 2C34

* laser fires down -----------------------------------------
DZ2D
         jsr  RNDR                 ; 2C37
         jmp  PP2D                 ; 2C3A

* laser bullet (pocisk) moving down ------------------------
PO2D
         jsr  DW_                  ; 2C3D
         bcs  L2C49                ; 2C40
         dec  Y                    ; 2C42
         lda  #$5B                 ; 2C44
         jmp  PUT_                 ; 2C46
L2C49
         lda  #$51                 ; 2C49
         jsr  PUT_                 ; 2C4B

* laser bullet position (pozycja pocisku): next cell down, hit tests ---
PP2D
         jsr  T_DW                 ; 2C4E
         inc  Y                    ; 2C51
         cpx  #$20                 ; 2C53
         beq  L2C5A                ; 2C55
         jmp  PPP2                 ; 2C57
L2C5A
         lda  #$D6                 ; 2C5A
         jmp  PUT_                 ; 2C5C

* blaster fires left ---------------------------------------
DZ3L
         jsr  RNDR                 ; 2C5F
         jmp  PP3L                 ; 2C62

* blaster bullet (pocisk) moving left ----------------------
PO3L
         jsr  LT_                  ; 2C65
         bcs  L2C74                ; 2C68
         jsr  D3TB                 ; 2C6A
         inc  X                    ; 2C6D
         lda  #$62                 ; 2C6F
         jmp  PUT_                 ; 2C71
L2C74
         lda  #$62                 ; 2C74
         jsr  PUT_                 ; 2C76

* blaster bullet position (pozycja pocisku): next cell left, hit tests ---
PP3L
         jsr  T_LT                 ; 2C79
         dec  X                    ; 2C7C
         cpx  #$20                 ; 2C7E
         beq  L2C86                ; 2C80
         lsr                       ; 2C82
         bcs  L2C86                ; 2C83
         rts                       ; 2C85
L2C86
         jsr  D3TB                 ; 2C86
         lda  #$57                 ; 2C89
         jmp  PUT_                 ; 2C8B

* blaster fires right --------------------------------------
DZ3R
         jsr  RNDR                 ; 2C8E
         jmp  PP3R                 ; 2C91

* blaster bullet (pocisk) moving right ---------------------
PO3R
         jsr  RT_                  ; 2C94
         bcs  L2CA3                ; 2C97
         jsr  D3TB                 ; 2C99
         dec  X                    ; 2C9C
         lda  #$62                 ; 2C9E
         jmp  PUT_                 ; 2CA0
L2CA3
         lda  #$62                 ; 2CA3
         jsr  PUT_                 ; 2CA5

* blaster bullet position (pozycja pocisku): next cell right, hit tests ---
PP3R
         jsr  T_RT                 ; 2CA8
         inc  X                    ; 2CAB
         cpx  #$20                 ; 2CAD
         beq  L2CB5                ; 2CAF
         lsr                       ; 2CB1
         bcs  L2CB5                ; 2CB2
         rts                       ; 2CB4
L2CB5
         jsr  D3TB                 ; 2CB5
         lda  #$D8                 ; 2CB8
         jmp  PUT_                 ; 2CBA

* blaster fires up -----------------------------------------
DZ3U
         jsr  RNDR                 ; 2CBD
         jmp  PP3U                 ; 2CC0

* blaster bullet (pocisk) moving up ------------------------
PO3U
         jsr  UP_                  ; 2CC3
         bcs  L2CD2                ; 2CC6
         jsr  D3TB                 ; 2CC8
         inc  Y                    ; 2CCB
         lda  #$62                 ; 2CCD
         jmp  PUT_                 ; 2CCF
L2CD2
         lda  #$62                 ; 2CD2
         jsr  PUT_                 ; 2CD4

* blaster bullet position (pozycja pocisku): next cell up, hit tests ---
PP3U
         jsr  T_UP                 ; 2CD7
         dec  Y                    ; 2CDA
         cpx  #$20                 ; 2CDC
         beq  L2CE4                ; 2CDE
         lsr                       ; 2CE0
         bcs  L2CE4                ; 2CE1
         rts                       ; 2CE3
L2CE4
         jsr  D3TB                 ; 2CE4
         lda  #$59                 ; 2CE7
         jmp  PUT_                 ; 2CE9

* blaster fires down ---------------------------------------
DZ3D
         jsr  RNDR                 ; 2CEC
         jmp  PP3D                 ; 2CEF

* blaster bullet (pocisk) moving down ----------------------
PO3D
         jsr  DW_                  ; 2CF2
         bcs  L2D01                ; 2CF5
         jsr  D3TB                 ; 2CF7
         dec  Y                    ; 2CFA
         lda  #$62                 ; 2CFC
         jmp  PUT_                 ; 2CFE
L2D01
         lda  #$62                 ; 2D01
         jsr  PUT_                 ; 2D03

* blaster bullet position (pozycja pocisku): next cell down, hit tests ---
PP3D
         jsr  T_DW                 ; 2D06
         inc  Y                    ; 2D09
         cpx  #$20                 ; 2D0B
         beq  L2D13                ; 2D0D
         lsr                       ; 2D0F
         bcs  L2D13                ; 2D10
         rts                       ; 2D12
L2D13
         jsr  D3TB                 ; 2D13
         lda  #$DA                 ; 2D16
         jmp  PUT_                 ; 2D18

* blaster: test for a bomb (Robbo: "dz3 test bomba") -------
D3TB
         cpx  #$3F                 ; 2D1B
         beq  PUNIES               ; 2D1D
         cpx  #$40                 ; 2D1F
         bne  L2D28                ; 2D21
         pla                       ; 2D23
         pla                       ; 2D24
         jmp  WYBO                 ; 2D25
L2D28
         rts                       ; 2D28

* put a surprise box (Robbo: "put niespodzianka") ----------
PUNIES
         lda  #$0A                 ; 2D29
         jsr  SOUND_               ; 2D2B
         lda  #$6E                 ; 2D2E
         jmp  PUT_                 ; 2D30

* rotating small gun (Robbo: "ruch dzialo") ----------------
DZRU
         lda  CNTR                 ; 2D33
         and  #$03                 ; 2D36
         bne  RDZ1                 ; 2D38
         lda  RANDOM               ; 2D3A
         and  #$03                 ; 2D3D
         bne  RDZ1                 ; 2D3F
         jsr  GET_                 ; 2D41
         lsr  RANDOM               ; 2D44
         bcs  RDZL                 ; 2D47
         adc  #$01                 ; 2D49
         cmp  #$30                 ; 2D4B
         bcc  L2D51                ; 2D4D
         lda  #$2C                 ; 2D4F
L2D51
         jmp  PUT_                 ; 2D51

* rotating gun turns to the previous direction, codes $2C-$2F (Robbo RDZL) ---
RDZL
         sbc  #$01                 ; 2D54
         cmp  #$2C                 ; 2D56
         bcs  L2D5C                ; 2D58
         lda  #$2F                 ; 2D5A
L2D5C
         jmp  PUT_                 ; 2D5C

* rotating gun fires in its direction, 1 turn in 8 (table RDZP, Robbo RDZ1) ---
RDZ1
         lda  RANDOM               ; 2D5F
         and  #$07                 ; 2D62
         beq  L2D67                ; 2D64
         rts                       ; 2D66
L2D67
         jsr  TST_                 ; 2D67
         sec                       ; 2D6A
         sbc  #$2C                 ; 2D6B
         asl                       ; 2D6D
         tax                       ; 2D6E
         lda  $2D79,x              ; 2D6F
         pha                       ; 2D72
         lda  $2D78,x              ; 2D73
         pha                       ; 2D76
         rts                       ; 2D77
         dta $46,$2B,$92,$2B,$00,$2B,$6C,$2B          ; 2D78

* moving small gun, left (Robbo: "mov dziala") -------------
MODL
         lda  CNTR                 ; 2D80
         lsr                       ; 2D83
         bcc  MOD1                 ; 2D84
         jsr  LT_                  ; 2D86
         bcc  MOD1                 ; 2D89
         lda  #$0D                 ; 2D8B
         jsr  PUT_                 ; 2D8D
         jmp  MOD1                 ; 2D90

* moving small gun, right ----------------------------------
MODR
         lda  CNTR                 ; 2D93
         lsr                       ; 2D96
         bcc  MOD1                 ; 2D97
         jsr  RT_                  ; 2D99
         bcc  MOD1                 ; 2D9C
         lda  #$0E                 ; 2D9E
         jsr  PUT_                 ; 2DA0

* moving small gun: common part ----------------------------
MOD1
         jmp  DZ1U                 ; 2DA3

* barrier (Robbo: "zapora"), code $11: moves the block $0F one cell right along the row up to the end $05, then again from the start (interpretation) ---
ZAPO
         jsr  TST_                 ; 2DA6
         ldy  #$01                 ; 2DA9
         lda  (ADDR),y             ; 2DAB
         cmp  #$0F                 ; 2DAD
         beq  L2DB3                ; 2DAF
         lda  #$20                 ; 2DB1
L2DB3
         pha                       ; 2DB3
         jsr  TST_                 ; 2DB4
L2DB7
         iny                       ; 2DB7
         inc  X                    ; 2DB8
         lda  (ADDR),y             ; 2DBA
         cmp  #$0F                 ; 2DBC
         bne  L2DD0                ; 2DBE
         dec  X                    ; 2DC0
         dey                       ; 2DC2
         beq  L2DC9                ; 2DC3
         lda  #$0F                 ; 2DC5
         sta  (ADDR),y             ; 2DC7
L2DC9
         iny                       ; 2DC9
         inc  X                    ; 2DCA
         lda  #$20                 ; 2DCC
         sta  (ADDR),y             ; 2DCE
L2DD0
         lda  (ADDR),y             ; 2DD0
         cmp  #$05                 ; 2DD2
         bne  L2DB7                ; 2DD4
         pla                       ; 2DD6
         dey                       ; 2DD7
         dec  X                    ; 2DD8
         cmp  #$0F                 ; 2DDA
         beq  L2DDF                ; 2DDC
         rts                       ; 2DDE
L2DDF
         sta  (ADDR),y             ; 2DDF
         rts                       ; 2DE1

* left-hand creature, moving left (Robbo: "stworki leworecz") ---
STWA
         jsr  LT_                  ; 2DE2
         bcs  L2DEC                ; 2DE5
         lda  #$44                 ; 2DE7
         jmp  PUT_                 ; 2DE9
L2DEC
         jsr  UP_                  ; 2DEC
         bcs  L2DF2                ; 2DEF
         rts                       ; 2DF1
L2DF2
         lda  #$43                 ; 2DF2
         jmp  PUT_                 ; 2DF4

* left-hand creature, moving right -------------------------
STWB
         jsr  RT_                  ; 2DF7
         bcs  L2E01                ; 2DFA
         lda  #$C3                 ; 2DFC
         jmp  PUT_                 ; 2DFE
L2E01
         jsr  DW_                  ; 2E01
         bcs  L2E07                ; 2E04
         rts                       ; 2E06
L2E07
         lda  #$44                 ; 2E07
         jmp  PUT_                 ; 2E09

* left-hand creature, moving up ----------------------------
STWC
         jsr  UP_                  ; 2E0C
         bcs  L2E16                ; 2E0F
         lda  #$41                 ; 2E11
         jmp  PUT_                 ; 2E13
L2E16
         jsr  RT_                  ; 2E16
         bcs  L2E1C                ; 2E19
         rts                       ; 2E1B
L2E1C
         lda  #$42                 ; 2E1C
         jmp  PUT_                 ; 2E1E

* left-hand creature, moving down --------------------------
STWD
         jsr  DW_                  ; 2E21
         bcs  L2E2B                ; 2E24
         lda  #$C2                 ; 2E26
         jmp  PUT_                 ; 2E28
L2E2B
         jsr  LT_                  ; 2E2B
         bcs  L2E31                ; 2E2E
         rts                       ; 2E30
L2E31
         lda  #$41                 ; 2E31
         jmp  PUT_                 ; 2E33

* right-hand creature, moving left (Robbo: "praworeczne") ---
STWE
         jsr  LT_                  ; 2E36
         bcs  L2E40                ; 2E39
         lda  #$47                 ; 2E3B
         jmp  PUT_                 ; 2E3D
L2E40
         jsr  DW_                  ; 2E40
         bcs  L2E46                ; 2E43
         rts                       ; 2E45
L2E46
         lda  #$48                 ; 2E46
         jmp  PUT_                 ; 2E48

* right-hand creature, moving right ------------------------
STWF
         jsr  RT_                  ; 2E4B
         bcs  L2E55                ; 2E4E
         lda  #$C8                 ; 2E50
         jmp  PUT_                 ; 2E52
L2E55
         jsr  UP_                  ; 2E55
         bcs  L2E5B                ; 2E58
         rts                       ; 2E5A
L2E5B
         lda  #$C7                 ; 2E5B
         jmp  PUT_                 ; 2E5D

* right-hand creature, moving up ---------------------------
STWG
         jsr  UP_                  ; 2E60
         bcs  L2E6A                ; 2E63
         lda  #$46                 ; 2E65
         jmp  PUT_                 ; 2E67
L2E6A
         jsr  LT_                  ; 2E6A
         bcs  L2E70                ; 2E6D
         rts                       ; 2E6F
L2E70
         lda  #$45                 ; 2E70
         jmp  PUT_                 ; 2E72

* right-hand creature, moving down -------------------------
STWH
         jsr  DW_                  ; 2E75
         bcs  L2E7F                ; 2E78
         lda  #$C5                 ; 2E7A
         jmp  PUT_                 ; 2E7C
L2E7F
         jsr  RT_                  ; 2E7F
         bcs  L2E85                ; 2E82
         rts                       ; 2E84
L2E85
         lda  #$46                 ; 2E85
         jmp  PUT_                 ; 2E87

* creature going left and right (Robbo: "lewo-prawo"), moving left ---
STWI
         jsr  LT_                  ; 2E8A
         bcs  L2E90                ; 2E8D
         rts                       ; 2E8F
L2E90
         lda  #$CA                 ; 2E90
         jmp  PUT_                 ; 2E92

* creature going left and right, moving right --------------
STWJ
         jsr  RT_                  ; 2E95
         bcs  L2E9B                ; 2E98
         rts                       ; 2E9A
L2E9B
         lda  #$C9                 ; 2E9B
         jmp  PUT_                 ; 2E9D

* creature going up and down (Robbo: "gora-dol"), moving up ---
STWK
         jsr  UP_                  ; 2EA0
         bcs  L2EA6                ; 2EA3
         rts                       ; 2EA5
L2EA6
         lda  #$CC                 ; 2EA6
         jmp  PUT_                 ; 2EA8

* creature going up and down, moving down ------------------
STWL
         jsr  DW_                  ; 2EAB
         bcs  L2EB1                ; 2EAE
         rts                       ; 2EB0
L2EB1
         lda  #$CB                 ; 2EB1
         jmp  PUT_                 ; 2EB3

* shooting bat flying left (Robbo: "toperze pif-pafy"), shoots down at random ---
TOPL
         jsr  LT_                  ; 2EB6
         bcc  L2ECA                ; 2EB9
         lda  #$4E                 ; 2EBB
         jmp  PUT_                 ; 2EBD

* shooting bat flying right --------------------------------
TOPR
         jsr  RT_                  ; 2EC0
         bcc  L2ECA                ; 2EC3
         lda  #$4D                 ; 2EC5
         jsr  PUT_                 ; 2EC7
L2ECA
         lda  RANDOM               ; 2ECA
         and  #$07                 ; 2ECD
         beq  L2ED2                ; 2ECF
         rts                       ; 2ED1
L2ED2
         jmp  PP1D                 ; 2ED2

* eyes - follow Robbo (Robbo: "sledz") ---------------------
LEDZ
         lsr  RANDOM               ; 2ED5
         bcs  SKAC                 ; 2ED8
         lda  Y                    ; 2EDA
         cmp  FY                   ; 2EDC
         beq  LEX                  ; 2EDE
         bcc  L2EE8                ; 2EE0
         jsr  UP_                  ; 2EE2
         bcs  LEX                  ; 2EE5
         rts                       ; 2EE7
L2EE8
         jsr  DW_                  ; 2EE8
         bcs  LEX                  ; 2EEB
         rts                       ; 2EED

* eyes in Robbo's row or column: step towards him (Robbo LEX) ---
LEX
         lda  X                    ; 2EEE
         cmp  FX                   ; 2EF0
         bne  L2F11                ; 2EF2

* eyes: now and then a step in a random direction (table TMVS, Robbo SKAC) ---
SKAC
         lda  RANDOM               ; 2EF4
         and  #$20                 ; 2EF7
         beq  L2EFC                ; 2EF9
         rts                       ; 2EFB
L2EFC
         lda  RANDOM               ; 2EFC
         and  #$03                 ; 2EFF
         tax                       ; 2F01
         lda  LM                   ; 2F02
         pha                       ; 2F04
         lda  $296B,x              ; 2F05
         sta  LM                   ; 2F08
         jsr  FD_                  ; 2F0A
         pla                       ; 2F0D
         sta  LM                   ; 2F0E
         rts                       ; 2F10
L2F11
         bcs  L2F16                ; 2F11
         jmp  RT_                  ; 2F13
L2F16
         jmp  LT_                  ; 2F16

* capsule, closed: when all screws are collected, flash and open it (Robbo WYZA) ---
WYZA
         lda  ZEBR                 ; 2F19
         beq  L2F1E                ; 2F1B
L2F1D
         rts                       ; 2F1D
L2F1E
         ldx  TELE                 ; 2F1E
         dex                       ; 2F20
         beq  L2F1D                ; 2F21
         lda  #$0D                 ; 2F23
         jsr  SOUND_               ; 2F25
         lda  $02C3                ; 2F28
         pha                       ; 2F2B
         lda  #$0F                 ; 2F2C
         sta  $02C3                ; 2F2E
         jsr  HALT                 ; 2F31
         jsr  HALT                 ; 2F34
         jsr  HALT                 ; 2F37
         pla                       ; 2F3A
         sta  $02C3                ; 2F3B
         lda  #$15                 ; 2F3E
         jmp  PUT_                 ; 2F40

* capsule, open: blinks $15 / $16 (Robbo WYOT) -------------
WYOT
         lda  CNTR                 ; 2F43
         and  #$03                 ; 2F46
         beq  L2F4B                ; 2F48
         rts                       ; 2F4A
L2F4B
         jsr  TST_                 ; 2F4B
         eor  #$03                 ; 2F4E
         jmp  PUT_                 ; 2F50
