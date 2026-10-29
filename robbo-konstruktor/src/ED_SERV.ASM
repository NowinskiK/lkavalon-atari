; ED_SERV.ASM - editor services: messages, set-up, colours, lower panel, digits, planet tables, display list
; $9CDD-$9F7A

         org $9CDD


* show the name of palette entry X (message X + $1E, kept in CUR_ELEM) ---
ELEM_MSG_
         ldy  #$FF                 ; 9CDD
         cmp  CUR_ELEM             ; 9CDF
         beq  L9CE7                ; 9CE2
         sty  CUR_MSG              ; 9CE4
L9CE7
         sta  CUR_ELEM             ; 9CE7
         clc                       ; 9CEA
         txa                       ; 9CEB
         adc  #$1E                 ; 9CEC
         cmp  #$2A                 ; 9CEE
         bne  L9CFC                ; 9CF0

* copy protection check: X = 12 ("murek") makes HDR_BUF+4,x read PROT_SUM ($9F8B); not 0 -> the planet is cleared ---
         lda  HDR_BUF+4,x          ; 9CF2
         beq  L9CFA                ; 9CF5
         jsr  PLANET_CLR           ; 9CF7
L9CFA
         lda  #$2A                 ; 9CFA
L9CFC
         cmp  #$39                 ; 9CFC
         bcc  MESSAGE_             ; 9CFE
         lda  #$39                 ; 9D00

* show message A centred in the status line $BCC8 (number kept in CUR_MSG) ---
MESSAGE_
         cmp  CUR_MSG              ; 9D02
         beq  L9D56                ; 9D05
         sta  CUR_MSG              ; 9D07
         jsr  MSG_ADDR             ; 9D0A
         ldy  #$FF                 ; 9D0D
L9D0F
         iny                       ; 9D0F
         lda  (PTR2),y             ; 9D10
         bne  L9D0F                ; 9D12
         dey                       ; 9D14
         sty  TMP3                 ; 9D15
         sec                       ; 9D17
         lda  #$27                 ; 9D18
         sbc  TMP3                 ; 9D1A
         lsr                       ; 9D1C
         sta  TMP3                 ; 9D1D
         sec                       ; 9D1F
         lda  #$27                 ; 9D20
         sbc  TMP3                 ; 9D22
         tax                       ; 9D24
         stx  TMP3                 ; 9D25
L9D27
         lda  (PTR2),y             ; 9D27
         cmp  #$61                 ; 9D29
         bcc  L9D31                ; 9D2B
         cmp  #$7B                 ; 9D2D
         bcc  L9D34                ; 9D2F
L9D31
         jsr  ATA2SCR              ; 9D31
L9D34
         sta  STATUS,x             ; 9D34
         dex                       ; 9D37
         dey                       ; 9D38
         bpl  L9D27                ; 9D39
         txa                       ; 9D3B
         bmi  L9D46                ; 9D3C
         lda  #$00                 ; 9D3E
L9D40
         sta  STATUS,x             ; 9D40
         dex                       ; 9D43
         bpl  L9D40                ; 9D44
L9D46
         lda  #$00                 ; 9D46
         ldx  #$27                 ; 9D48
         cpx  TMP3                 ; 9D4A
         beq  L9D56                ; 9D4C
L9D4E
         sta  STATUS,x             ; 9D4E
         dex                       ; 9D51
         cpx  TMP3                 ; 9D52
         bne  L9D4E                ; 9D54
L9D56
         rts                       ; 9D56

* address of message A (skips A strings from $A318) --------
MSG_ADDR
         ldx  #$18                 ; 9D57
         stx  PTR2                 ; 9D59
         ldx  #$A3                 ; 9D5B
         stx  PTR2+1               ; 9D5D
         tax                       ; 9D5F
         beq  L9D77                ; 9D60
L9D62
         ldy  #$FF                 ; 9D62
L9D64
         iny                       ; 9D64
         lda  (PTR2),y             ; 9D65
         bne  L9D64                ; 9D67
         clc                       ; 9D69
         iny                       ; 9D6A
         tya                       ; 9D6B
         adc  PTR2                 ; 9D6C
         sta  PTR2                 ; 9D6E
         bcc  L9D74                ; 9D70
         inc  PTR2+1               ; 9D72
L9D74
         dex                       ; 9D74
         bne  L9D62                ; 9D75
L9D77
         rts                       ; 9D77

* editor init: disk directory, "kasetowe" in the menu if there is no disk, start the menu ---
ED_INIT_
         lda  #$00                 ; 9D78
         bne  L9D97                ; 9D7A
         inc  ED_INIT_+1           ; 9D7C
         jsr  PLANETS_INIT         ; 9D7F
         lda  #$64                 ; 9D82
         jsr  IO_CMD               ; 9D84
         sta  DISK_SLOTS           ; 9D87
         bpl  L9D97                ; 9D8A
         ldx  #$07                 ; 9D8C
L9D8E
         lda  DEV_WORDS+24,x       ; 9D8E
         sta  MENU_TXT+130,x       ; 9D91
         dex                       ; 9D94
         bpl  L9D8E                ; 9D95
L9D97
         lda  #$82                 ; 9D97
         sta  MENU_CALL+1          ; 9D99
         lda  #$95                 ; 9D9C
         sta  MENU_CALL+2          ; 9D9E
         ldx  #$00                 ; 9DA1
         stx  PANEL_TXT            ; 9DA3
         stx  PANEL_ST             ; 9DA6
         stx  TP_TEST              ; 9DA8
         dex                       ; 9DAB
         stx  CUR_MSG              ; 9DAC
         lda  #$1F                 ; 9DAF
         sta  TP_LAST              ; 9DB1
         lda  #$00                 ; 9DB4
         jsr  MESSAGE              ; 9DB6
         jmp  PANEL                ; 9DB9

* colours of the current planet (header) or the defaults $9F83 ---
ED_COLORS_
         ldx  #$07                 ; 9DBC
         lda  PLANET               ; 9DBE
         bmi  L9DD3                ; 9DC0
         asl                       ; 9DC2
         adc  #$51                 ; 9DC3
         sta  HDR_LOAD+2           ; 9DC5
HDR_LOAD
         lda  PLANET_HDR,x         ; 9DC8
         sta  HDR_BUF,x            ; 9DCB
         dex                       ; 9DCE
         bpl  HDR_LOAD             ; 9DCF
         bmi  L9DDC                ; 9DD1
L9DD3
         lda  COLS_DEF,x           ; 9DD3
         sta  HDR_BUF,x            ; 9DD6
         dex                       ; 9DD9
         bpl  L9DD3                ; 9DDA
L9DDC
         lda  VCOUNT               ; 9DDC
         bpl  L9DDC                ; 9DDF
         ldx  #$04                 ; 9DE1
L9DE3
         lda  HDR_BUF+2,x          ; 9DE3
         sta  COLOR0,x             ; 9DE6
         sta  COLPF0,x             ; 9DE9
         dex                       ; 9DEC
         bpl  L9DE3                ; 9DED
         lda  COLOR4               ; 9DEF
         ldx  #$02                 ; 9DF2
L9DF4
         sta  PCOLR0,x             ; 9DF4
         sta  COLPM0,x             ; 9DF7
         dex                       ; 9DFA
         bpl  L9DF4                ; 9DFB
         lda  HDR_BUF+7            ; 9DFD
         sta  PCOLR3               ; 9E00
         rts                       ; 9E03

* default colours into the planet header -------------------
COLS_DEFAULT
         lda  PLANET               ; 9E04
         asl                       ; 9E06
         adc  #$51                 ; 9E07
         sta  HDR_STORE+2          ; 9E09
         ldx  #$07                 ; 9E0C
L9E0E
         lda  HDR_BUF,x            ; 9E0E
HDR_STORE
         sta  PLANET_HDR,x         ; 9E11
         dex                       ; 9E14
         bpl  L9E0E                ; 9E15
         rts                       ; 9E17

* draw the lower screen panel for state PANEL_ST -----------
PANEL
         ldx  PANEL_ST             ; 9E18
         beq  L9E7D                ; 9E1A
         dex                       ; 9E1C
         beq  L9E5D                ; 9E1D
         dex                       ; 9E1F
         beq  L9E4B                ; 9E20
         lda  #$27                 ; 9E22
         ldy  #$A2                 ; 9E24
         dex                       ; 9E26
         beq  L9E2D                ; 9E27
         lda  #$9F                 ; 9E29
         ldy  #$A2                 ; 9E2B
L9E2D
         sta  PNL_HINT+1           ; 9E2D
         sty  PNL_HINT+2           ; 9E30
         ldx  #$77                 ; 9E33
PNL_HINT
         lda  PNL_HINT,x           ; 9E35
         sta  PANEL_TXT+40,x       ; 9E38
         cpx  #$28                 ; 9E3B
         bcs  L9E47                ; 9E3D
         lda  #$00                 ; 9E3F
         sta  PANEL_TXT,x          ; 9E41
         sta  PANEL_TXT+160,x      ; 9E44
L9E47
         dex                       ; 9E47
         bpl  PNL_HINT             ; 9E48
         rts                       ; 9E4A
L9E4B
         ldx  #$C7                 ; 9E4B
L9E4D
         lda  DISK_TXT,x           ; 9E4D
         sta  PANEL_TXT,x          ; 9E50
         dex                       ; 9E53
         bne  L9E4D                ; 9E54
         lda  DISK_TXT             ; 9E56
         sta  PANEL_TXT            ; 9E59
         rts                       ; 9E5C
L9E5D
         ldx  #$27                 ; 9E5D
L9E5F
         lda  LEGEND_TXT,x         ; 9E5F
         sta  PANEL_TXT,x          ; 9E62
         lda  LEGEND_TXT+40,x      ; 9E65
         sta  PANEL_TXT+80,x       ; 9E68
         lda  LEGEND_TXT+80,x      ; 9E6B
         sta  PANEL_TXT+120,x      ; 9E6E
         lda  #$00                 ; 9E71
         sta  PANEL_TXT+40,x       ; 9E73
         sta  PANEL_TXT+160,x      ; 9E76
         dex                       ; 9E79
         bpl  L9E5F                ; 9E7A
         rts                       ; 9E7C
L9E7D
         ldy  PLANET               ; 9E7D
         iny                       ; 9E7F
         tya                       ; 9E80
         jsr  TO_DIGITS            ; 9E81
         tya                       ; 9E84
         ldy  #$0B                 ; 9E85
         jsr  DSPB                 ; 9E87
         lda  #$00                 ; 9E8A
         ldx  MENU_POS             ; 9E8C
         bpl  L9E92                ; 9E8E
         lda  #$14                 ; 9E90
L9E92
         clc                       ; 9E92
         adc  #$5B                 ; 9E93
         sta  PNL_RIGHT+1          ; 9E95
         ldx  #$A0                 ; 9E98
         bcc  L9E9D                ; 9E9A
         inx                       ; 9E9C
L9E9D
         stx  PNL_RIGHT+2          ; 9E9D
         lda  #$D3                 ; 9EA0
         sta  PNL_LEFT+1           ; 9EA2
         lda  #$A0                 ; 9EA5
         sta  PNL_LEFT+2           ; 9EA7
         ldx  #$C7                 ; 9EAA
L9EAC
         ldy  #$13                 ; 9EAC
PNL_RIGHT
         lda  PNL_RIGHT,y          ; 9EAE
         sta  PANEL_TXT,x          ; 9EB1
PNL_LEFT
         lda  PNL_LEFT,y           ; 9EB4
         sta  PANEL_LH,x           ; 9EB7
         dex                       ; 9EBA
         dey                       ; 9EBB
         bpl  PNL_RIGHT            ; 9EBC
         sec                       ; 9EBE
         lda  PNL_RIGHT+1          ; 9EBF
         sbc  #$28                 ; 9EC2
         sta  PNL_RIGHT+1          ; 9EC4
         bcs  L9ECC                ; 9EC7
         dec  PNL_RIGHT+2          ; 9EC9
L9ECC
         sec                       ; 9ECC
         lda  PNL_LEFT+1           ; 9ECD
         sbc  #$14                 ; 9ED0
         sta  PNL_LEFT+1           ; 9ED2
         bcs  L9EDA                ; 9ED5
         dec  PNL_LEFT+2           ; 9ED7
L9EDA
         sec                       ; 9EDA
         txa                       ; 9EDB
         sbc  #$14                 ; 9EDC
         tax                       ; 9EDE
         bcs  L9EAC                ; 9EDF
         rts                       ; 9EE1

* display a byte as two digits (Robbo: "display byte") -----
DSPB
         pha                       ; 9EE2
         jsr  DSPD                 ; 9EE3
         pla                       ; 9EE6
         lsr                       ; 9EE7
         lsr                       ; 9EE8
         lsr                       ; 9EE9
         lsr                       ; 9EEA

* display digits -------------------------------------------
DSPD
         and  #$0F                 ; 9EEB
         tax                       ; 9EED
         lda  DIGITS_T,x           ; 9EEE
         sta  NUM_TXT,y            ; 9EF1
         lda  DIGITS_B,x           ; 9EF4
         sta  NUM_TXT+20,y         ; 9EF7
         dey                       ; 9EFA
         rts                       ; 9EFB

* initialise the planet tables (skipped while START is held) ---
PLANETS_INIT
         lda  CONSOL               ; 9EFC
         lsr                       ; 9EFF
         bcs  L9F03                ; 9F00
         rts                       ; 9F02
L9F03
         ldy  #$00                 ; 9F03
         tya                       ; 9F05
L9F06
         sta  TP_TEXT_B,y          ; 9F06
         sta  TP_TEXT_A,y          ; 9F09
         cpy  #$20                 ; 9F0C
         bcs  L9F16                ; 9F0E
         sta  PLANET_STATE,y       ; 9F10
         sta  ORDER,y              ; 9F13
L9F16
         dey                       ; 9F16
         bne  L9F06                ; 9F17

* fill the empty planets with blank cells and the default header ---
PLANETS_FILL
         lda  #$1F                 ; 9F19
         sta  TMP3                 ; 9F1B
L9F1D
         ldx  TMP3                 ; 9F1D
         lda  PLANET_STATE,x       ; 9F1F
         bne  L9F49                ; 9F22
         txa                       ; 9F24
         asl                       ; 9F25
         adc  #$50                 ; 9F26
         sta  PTR2+1               ; 9F28
         lda  #$20                 ; 9F2A
         ldy  #$00                 ; 9F2C
         sty  PTR2                 ; 9F2E
L9F30
         sta  (PTR2),y             ; 9F30
         dey                       ; 9F32
         bne  L9F30                ; 9F33
         inc  PTR2+1               ; 9F35
L9F37
         sta  (PTR2),y             ; 9F37
         dey                       ; 9F39
         bne  L9F37                ; 9F3A
         ldy  #$F7                 ; 9F3C
         ldx  #$07                 ; 9F3E
L9F40
         lda  COLS_DEF,x           ; 9F40
         sta  (PTR2),y             ; 9F43
         dey                       ; 9F45
         dex                       ; 9F46
         bpl  L9F40                ; 9F47
L9F49
         dec  TMP3                 ; 9F49
         bpl  L9F1D                ; 9F4B

* copy protection, run once at the end of the first PLANETS_FILL (then patched to RTS): PROT_SUM = SERIN XOR DOSINI+1, pointers disguised as arithmetic on CUR_ELEM ($000D, $D20D); skipped if $A804 is negative ---
PROT_KEY
         lda  ROBBO_TXT            ; 9F4D
         bmi  L9F6E                ; 9F50
         lda  CUR_ELEM             ; 9F52
         sec                       ; 9F55
         rol                       ; 9F56
         sta  PTR1                 ; 9F57
         sta  PTR2                 ; 9F59
         asl                       ; 9F5B
         asl                       ; 9F5C
         sec                       ; 9F5D
         rol                       ; 9F5E
         asl                       ; 9F5F
         sta  PTR2+1               ; 9F60
         eor  PTR2+1               ; 9F62
         sta  PTR1+1               ; 9F64
         tay                       ; 9F66
         lda  (PTR1),y             ; 9F67
         eor  (PTR2),y             ; 9F69
         sta  PROT_SUM             ; 9F6B
L9F6E
         lda  #$60                 ; 9F6E
         sta  PROT_KEY             ; 9F70
         rts                       ; 9F73

* editor display list $94FE --------------------------------
ED_DLIST_
         ldx  #$FE                 ; 9F74
         ldy  #$94                 ; 9F76
         jmp  SET_DLIST            ; 9F78
