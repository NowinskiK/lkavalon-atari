; MAIN.ASM - status line, game entry ($8E67), main loop, screen flip, map drawing
; $8DF0-$9026

         org $8DF0


* tile attributes of tile A --------------------------------
TILE_ATTR
         and  #$7F                 ; 8DF0
         lsr                       ; 8DF2
         tax                       ; 8DF3
         lda  $7000,x              ; 8DF4
         rts                       ; 8DF7

* status line: food bar, energy bar, lives digit -----------
STATUS
         lda  FOOD                 ; 8DF8
         lsr                       ; 8DFA
         sta  $C0                  ; 8DFB
         ldy  #$0F                 ; 8DFD
L8DFF
         lda  #$7E                 ; 8DFF
         cpy  $C0                  ; 8E01
         bcc  L8E07                ; 8E03
         lda  #$7F                 ; 8E05
L8E07
         sta  BAR_FOOD,y           ; 8E07
         dey                       ; 8E0A
         bpl  L8DFF                ; 8E0B
         ldy  $C0                  ; 8E0D
         lda  FOOD                 ; 8E0F
         and  #$01                 ; 8E11
         beq  L8E1A                ; 8E13
         lda  #$7D                 ; 8E15
         sta  BAR_FOOD,y           ; 8E17
L8E1A
         lda  ENERGY               ; 8E1A
         lsr                       ; 8E1C
         lsr                       ; 8E1D
         sta  $C0                  ; 8E1E
         ldy  #$17                 ; 8E20
L8E22
         lda  #$7E                 ; 8E22
         cpy  $C0                  ; 8E24
         bcc  L8E2A                ; 8E26
         lda  #$7F                 ; 8E28
L8E2A
         sta  BAR_ENERGY,y         ; 8E2A
         dey                       ; 8E2D
         bpl  L8E22                ; 8E2E
         ldy  $C0                  ; 8E30
         lda  ENERGY               ; 8E32
         and  #$02                 ; 8E34
         beq  L8E3D                ; 8E36
         lda  #$7D                 ; 8E38
         sta  BAR_ENERGY,y         ; 8E3A
L8E3D
         lda  LIVES                ; 8E3D
         and  #$0F                 ; 8E3F
         clc                       ; 8E41
         adc  #$10                 ; 8E42
         cmp  #$1A                 ; 8E44
         bcc  L8E4A                ; 8E46
         adc  #$06                 ; 8E48
L8E4A
         sta  LIVES_DIGIT          ; 8E4A
         rts                       ; 8E4D
         dta $A0,$7F,$B9,$00,$05,$D9,$00,$06,$F0,$0C,$88,$B9,$00,$05,$D9,$00 ; 8E4E
         dta $06,$F0,$03,$A9,$FF,$60,$A9,$00,$60      ; 8E5E

* game entry -----------------------------------------------
GAME_START
         nop                       ; 8E67
         lda  #$00                 ; 8E68
         sta  $9EDF                ; 8E6A
         lda  #$00                 ; 8E6D
         sta  NMIEN                ; 8E6F
         lda  #$FE                 ; 8E72
         sta  PORTB                ; 8E74
         jsr  CLR_SCREENS          ; 8E77
         jsr  INIT_HW              ; 8E7A
         jsr  MUSIC_INIT           ; 8E7D

* new game -------------------------------------------------
NEW_GAME
         ldx  #$01                 ; 8E80
         lda  LEVEL_DIGITS,x       ; 8E82
         sta  DIGIT_DONE           ; 8E85
         inx                       ; 8E88
         lda  LEVEL_DIGITS,x       ; 8E89
         sta  DIGIT_NEXT           ; 8E8C
         jsr  INIT_GAME            ; 8E8F
         jsr  SCR_INTRO            ; 8E92
         jsr  COLS_A               ; 8E95
         jsr  STATUS               ; 8E98
         jsr  LOAD_L1              ; 8E9B
         jsr  DRAW_MAP             ; 8E9E
         lda  #$AB                 ; 8EA1
         sta  $89D0                ; 8EA3
         sta  $8A34                ; 8EA6
         lda  #$A0                 ; 8EA9
         sta  $89D1                ; 8EAB
         sta  $8A35                ; 8EAE
         jsr  FADE_IN              ; 8EB1
         jsr  EN_SPAWN             ; 8EB4
         lda  #$40                 ; 8EB7
         sta  PLAYER_X             ; 8EB9
         lda  RTCLOK+2             ; 8EBC
         clc                       ; 8EBE
         adc  #$02                 ; 8EBF
         sta  NEXT_TICK            ; 8EC1

* main loop: every 3rd frame -------------------------------
MAIN_LOOP
         lda  #$00                 ; 8EC3
         sta  $4D                  ; 8EC5
         sta  CH                   ; 8EC7
L8ECA
         lda  RTCLOK+2             ; 8ECA
         cmp  NEXT_TICK            ; 8ECC
         bcc  L8ECA                ; 8ECE
         clc                       ; 8ED0
         adc  #$03                 ; 8ED1
         sta  NEXT_TICK            ; 8ED3
         jsr  ENEMIES              ; 8ED5
         jsr  SFX                  ; 8ED8
         jsr  PROBE                ; 8EDB
         jsr  CONTACT              ; 8EDE
         jsr  STATUS               ; 8EE1
         jsr  CAVE                 ; 8EE4
         jsr  LEVEL_DONE           ; 8EE7
         lda  LIVES                ; 8EEA
         beq  L8F02                ; 8EEC
         lda  PLAYER_X             ; 8EEE
         cmp  #$9C                 ; 8EF1
         bcc  L8EF8                ; 8EF3
         jmp  SCROLL_R             ; 8EF5
L8EF8
         cmp  #$04                 ; 8EF8
         bcs  L8EFF                ; 8EFA
         jmp  SCROLL_L             ; 8EFC
L8EFF
         jmp  MAIN_LOOP            ; 8EFF
L8F02
         jsr  SCR_OVER             ; 8F02
         jmp  NEW_GAME             ; 8F05

* sound effects from the player state ----------------------
SFX
         lda  MUSIC_OFF            ; 8F08
         beq  L8F0D                ; 8F0A
         rts                       ; 8F0C
L8F0D
         lda  JUMP_STATE           ; 8F0D
         cmp  #$01                 ; 8F10
         bne  L8F24                ; 8F12
         lda  JUMP_STEP            ; 8F14
         cmp  #$02                 ; 8F17
         bne  L8F24                ; 8F19
         lda  #$22                 ; 8F1B
         ldx  #$05                 ; 8F1D
         ldy  #$17                 ; 8F1F
         jmp  CMC_CMD              ; 8F21
L8F24
         lda  SWING                ; 8F24
         cmp  #$0D                 ; 8F27
         bne  L8F34                ; 8F29
         lda  #$22                 ; 8F2B
         ldx  #$05                 ; 8F2D
         ldy  #$18                 ; 8F2F
         jmp  CMC_CMD              ; 8F31
L8F34
         lda  PLAYER_FRAME         ; 8F34
         cmp  #$02                 ; 8F37
         beq  L8F42                ; 8F39
         lda  PLAYER_FRAME         ; 8F3B
         cmp  #$03                 ; 8F3E
         bne  L8F4B                ; 8F40
L8F42
         lda  #$22                 ; 8F42
         ldx  #$18                 ; 8F44
         ldy  #$13                 ; 8F46
         jmp  CMC_CMD              ; 8F48
L8F4B
         rts                       ; 8F4B

* scroll one screen right ----------------------------------
SCROLL_R
         inc  PLAYER_X             ; 8F4C
         inc  PLAYER_X             ; 8F4F
         lda  #$13                 ; 8F52
         sta  COUNTER              ; 8F54
L8F56
         inc  SCREEN_COL           ; 8F56
         lda  PLAYER_X             ; 8F59
         sec                       ; 8F5C
         sbc  #$08                 ; 8F5D
         sta  PLAYER_X             ; 8F5F
         jsr  WAIT_FRAME           ; 8F62
         jsr  DRAW_MAP             ; 8F65
         dec  COUNTER              ; 8F68
         bne  L8F56                ; 8F6A
         inc  COUNTER              ; 8F6C
         lda  PLAYER_X             ; 8F6E
         sta  RESPAWN_X            ; 8F71
         lda  PLAYER_Y             ; 8F74
         sbc  #$20                 ; 8F77
         sta  RESPAWN_Y            ; 8F79
         jsr  EN_SPAWN             ; 8F7C
         jmp  MAIN_LOOP            ; 8F7F

* scroll one screen left -----------------------------------
SCROLL_L
         dec  PLAYER_X             ; 8F82
         dec  PLAYER_X             ; 8F85
         lda  #$13                 ; 8F88
         sta  COUNTER              ; 8F8A
L8F8C
         dec  SCREEN_COL           ; 8F8C
         lda  PLAYER_X             ; 8F8F
         clc                       ; 8F92
         adc  #$08                 ; 8F93
         sta  PLAYER_X             ; 8F95
         jsr  WAIT_FRAME           ; 8F98
         jsr  DRAW_MAP             ; 8F9B
         dec  COUNTER              ; 8F9E
         bne  L8F8C                ; 8FA0
         inc  COUNTER              ; 8FA2
         lda  PLAYER_X             ; 8FA4
         sta  RESPAWN_X            ; 8FA7
         lda  PLAYER_Y             ; 8FAA
         sbc  #$20                 ; 8FAD
         sta  RESPAWN_Y            ; 8FAF
         jsr  EN_SPAWN             ; 8FB2
         jmp  MAIN_LOOP            ; 8FB5

* wait for the next frame ----------------------------------
WAIT_FRAME
         lda  RTCLOK+2             ; 8FB8
L8FBA
         cmp  RTCLOK+2             ; 8FBA
         beq  L8FBA                ; 8FBC
         rts                       ; 8FBE

* wait for VCOUNT = $80 ------------------------------------
WAIT_VCOUNT
         lda  #$80                 ; 8FBF
L8FC1
         cmp  VCOUNT               ; 8FC1
         bne  L8FC1                ; 8FC4
         rts                       ; 8FC6

* draw the visible 20x10 tiles of the map into both screens ---
DRAW_MAP
         lda  SCREEN_COL           ; 8FC7
         clc                       ; 8FCA
         adc  #$00                 ; 8FCB
         sta  $C0                  ; 8FCD
         lda  #$30                 ; 8FCF
         sta  $C1                  ; 8FD1
         lda  #$00                 ; 8FD3
         sta  $8FFD                ; 8FD5
         sta  $9000                ; 8FD8
         sta  $9007                ; 8FDB
         sta  $900A                ; 8FDE
         lda  #$BC                 ; 8FE1
         sta  $8FFE                ; 8FE3
         sta  $9008                ; 8FE6
         lda  #$BE                 ; 8FE9
         sta  $9001                ; 8FEB
         sta  $900B                ; 8FEE
         lda  #$0A                 ; 8FF1
         sta  $E6                  ; 8FF3
         ldx  #$00                 ; 8FF5
L8FF7
         ldy  #$00                 ; 8FF7
L8FF9
         lda  ($C0),y              ; 8FF9
         asl                       ; 8FFB
         sta  LBC00,x              ; 8FFC
         sta  $BE00,x              ; 8FFF
         inx                       ; 9002
         clc                       ; 9003
         adc  #$01                 ; 9004
         sta  LBC00,x              ; 9006
         sta  $BE00,x              ; 9009
         inx                       ; 900C
         bne  L901B                ; 900D
         inc  $8FFE                ; 900F
         inc  $9001                ; 9012
         inc  $9008                ; 9015
         inc  $900B                ; 9018
L901B
         iny                       ; 901B
         cpy  #$14                 ; 901C
         bne  L8FF9                ; 901E
         inc  $C1                  ; 9020
         dec  $E6                  ; 9022
         bne  L8FF7                ; 9024
         rts                       ; 9026
