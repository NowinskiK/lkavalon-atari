; ED_SCRN.ASM - editor: screen set-up, frame wait, click, keys, DLI, joystick / keyboard input
; $AF3E-$B188

         org $AF3E


* editor set-up (zero page cleared once, screen, colours, DLI, font $4C00) ---
ED_SETUP
         lda  #$00                 ; AF3E
         bne  LAF5C                ; AF40
         inc  $AF3F                ; AF42
         sta  ED_FLAGS             ; AF45
         ldx  #$D0                 ; AF47
LAF49
         sta  $00,x                ; AF49
         dex                       ; AF4B
         cpx  #$B0                 ; AF4C
         bcs  LAF49                ; AF4E
         lda  #$0C                 ; AF50
         sta  PAL_SEL              ; AF52
         lda  #$12                 ; AF54
         sta  CUR_X                ; AF56
         lda  #$09                 ; AF58
         sta  CUR_Y                ; AF5A
LAF5C
         lda  #$00                 ; AF5C
         sta  SDMCTL               ; AF5E
         sta  DMACTL               ; AF61
         sta  $00                  ; AF64
         jsr  WAIT_VBL             ; AF66
         lda  #$FF                 ; AF69
         ldx  #$10                 ; AF6B
LAF6D
         sta  HPOSP0,x             ; AF6D
         dex                       ; AF70
         bpl  LAF6D                ; AF71
         jsr  CELL_HEADER          ; AF73
         ldy  #$06                 ; AF76
         ldx  #$08                 ; AF78
LAF7A
         lda  #$00                 ; AF7A
         sta  AUDF1,x              ; AF7C
         lda  #$00                 ; AF7F
         beq  LAF85                ; AF81
         lda  ($B2),y              ; AF83
LAF85
         sta  $02C0,x              ; AF85
         sta  COLPM0,x             ; AF88
         dex                       ; AF8B
         bpl  LAF7A                ; AF8C
         lda  #$03                 ; AF8E
         sta  SKCTL                ; AF90
         sta  $AF80                ; AF93
         lda  #$14                 ; AF96
         sta  $02D9                ; AF98
         lda  #$03                 ; AF9B
         sta  $02DA                ; AF9D
         lda  #$5F                 ; AFA0
         sta  VDSLST               ; AFA2
         lda  #$B0                 ; AFA5
         sta  VDSLST+1             ; AFA7
         lda  #$C0                 ; AFAA
         sta  NMIEN                ; AFAC
         lda  #$4C                 ; AFAF
         sta  CHBAS                ; AFB1
         ldx  #$00                 ; AFB4
LAFB6
         lda  #$00                 ; AFB6
         sta  $BD00,x              ; AFB8
         cpx  #$28                 ; AFBB
         bcs  LAFC4                ; AFBD
         lda  #$55                 ; AFBF
         sta  $BD50,x              ; AFC1
LAFC4
         dex                       ; AFC4
         bne  LAFB6                ; AFC5
         stx  $BD00                ; AFC7
         lda  #$55                 ; AFCA
         sta  $BD50                ; AFCC
         jsr  ED_INIT              ; AFCF
         lda  #$B6                 ; AFD2
         sta  SCR_PAGE             ; AFD4
         ldx  #$02                 ; AFD6
LAFD8
         lda  $B5BC,x              ; AFD8
         sta  HPOSP0,x             ; AFDB
         dex                       ; AFDE
         bpl  LAFD8                ; AFDF
         inx                       ; AFE1
         stx  $D009                ; AFE2
         lda  #$FE                 ; AFE5
         sta  $D00E                ; AFE7
         lda  #$04                 ; AFEA
         sta  GPRIOR               ; AFEC
         lda  #$00                 ; AFEF
         sta  IRQEN                ; AFF1
         jsr  INPUT_CLR            ; AFF4
         lda  #$01                 ; AFF7
         sta  HELP_PAGE            ; AFF9
         jsr  HELP_KEY             ; AFFB
         lda  #$60                 ; AFFE
         sta  $AFF7                ; B000

* wait for the next frame ----------------------------------
WAIT_VBL
         lda  RTCLOK+2             ; B003
LB005
         cmp  RTCLOK+2             ; B005
         beq  LB005                ; B007
         rts                       ; B009

* click sound ----------------------------------------------
CLICK_
         lda  #$00                 ; B00A
         sta  AUDF1                ; B00C
         lda  #$64                 ; B00F
         sta  AUDC1                ; B011
         ldx  #$04                 ; B014
LB016
         ldy  #$00                 ; B016
LB018
         dey                       ; B018
         bne  LB018                ; B019
         dex                       ; B01B
         bne  LB016                ; B01C
         stx  AUDC1                ; B01E
         rts                       ; B021
         dta $00                                      ; B022

* key event ------------------------------------------------
KEY_EVENT_
         jsr  GETKEY               ; B023
         bcc  LB02D                ; B026
LB028
         sta  $B022                ; B028
         sec                       ; B02B
         rts                       ; B02C
LB02D
         cmp  #$1C                 ; B02D
         bne  LB028                ; B02F
         cmp  $B022                ; B031
         beq  LB028                ; B034
         sta  $B022                ; B036
         clc                       ; B039
         rts                       ; B03A

* wait for a key or fire -----------------------------------
WAIT_KEY_
         jsr  INPUT                ; B03B
         jsr  INPUT_CLR            ; B03E
         beq  LB051                ; B041
         jsr  KEY_EVENT            ; B043
         bcc  LB055                ; B046
         lda  JOY                  ; B048
         cmp  #$FF                 ; B04B
         bne  LB055                ; B04D
         sec                       ; B04F
         rts                       ; B050
LB051
         lda  #$00                 ; B051
         beq  LB057                ; B053
LB055
         lda  #$FF                 ; B055
LB057
         clc                       ; B057
         ldx  #$FF                 ; B058
         stx  JOY                  ; B05A
         tax                       ; B05D
         rts                       ; B05E

* editor DLI -----------------------------------------------
ED_DLI
         cld                       ; B05F
         pha                       ; B060
         lda  VCOUNT               ; B061
         cmp  #$0C                 ; B064
         bcs  LB085                ; B066
         lda  #$00                 ; B068
         sta  $00                  ; B06A
         lda  $00                  ; B06C
         lsr                       ; B06E
         lda  #$40                 ; B06F
         bcc  LB075                ; B071
         adc  #$03                 ; B073
LB075
         sta  CHBASE               ; B075
         inc  $00                  ; B078
         lda  $02C3                ; B07A
         sta  WSYNC                ; B07D
         sta  COLBK                ; B080
         pla                       ; B083
         rti                       ; B084
LB085
         lda  $00                  ; B085
         lsr                       ; B087
         lda  #$40                 ; B088
         bcc  LB08E                ; B08A
         adc  #$03                 ; B08C
LB08E
         sta  CHBASE               ; B08E
         inc  $00                  ; B091
         lda  $00                  ; B093
         cmp  #$15                 ; B095
         bcc  LB0BA                ; B097
         lda  COLOR4               ; B099
         sta  COLBK                ; B09C
         sta  COLPM0               ; B09F
         sta  $D013                ; B0A2
         sta  $D014                ; B0A5
         lda  #$00                 ; B0A8
         sta  COLPF2               ; B0AA
         lda  #$0A                 ; B0AD
         sta  COLPF1               ; B0AF
         lda  #$4C                 ; B0B2
         sta  CHBASE               ; B0B4
         jsr  INPUT                ; B0B7
LB0BA
         pla                       ; B0BA
         rti                       ; B0BB

* read joystick, fire, console keys and keyboard into JOY ---
INPUT_
         lsr  $4D                  ; B0BC
         jsr  GETKEY               ; B0BE
         bcs  LB0CA                ; B0C1
         sec                       ; B0C3
         sbc  #$0C                 ; B0C4
         beq  LB0CA                ; B0C6
         sbc  #$15                 ; B0C8
LB0CA
         beq  LB0CE                ; B0CA
         lda  #$01                 ; B0CC
LB0CE
         sta  $B0D8                ; B0CE
         lda  SKCTL                ; B0D1
         lsr                       ; B0D4
         lsr                       ; B0D5
         lsr                       ; B0D6
         and  #$00                 ; B0D7
         and  TRIG0                ; B0D9
         and  $D011                ; B0DC
         and  CONSOL               ; B0DF
         sta  TRIG_ST              ; B0E2
         cmp  TRIG_LAST            ; B0E5
         beq  LB0ED                ; B0E8
         sta  EVENT                ; B0EA
LB0ED
         lda  TRIG_ST              ; B0ED
         sta  TRIG_LAST            ; B0F0
         lda  JOY_RPT              ; B0F3
         bmi  LB0FB                ; B0F6
         dec  JOY_RPT              ; B0F8
LB0FB
         txa                       ; B0FB
         pha                       ; B0FC
         ldx  #$00                 ; B0FD
         jsr  GETKEY               ; B0FF
         bcs  LB10E                ; B102
         ldx  #$04                 ; B104
LB106
         cmp  $B512,x              ; B106
         beq  LB10E                ; B109
         dex                       ; B10B
         bne  LB106                ; B10C
LB10E
         lda  $B517,x              ; B10E
         eor  #$0F                 ; B111
         sta  $B123                ; B113
         pla                       ; B116
         tax                       ; B117
         lda  PORTA                ; B118
         lsr                       ; B11B
         lsr                       ; B11C
         lsr                       ; B11D
         lsr                       ; B11E
         and  PORTA                ; B11F
         and  #$00                 ; B122
         cmp  JOY_LAST             ; B124
         bne  LB12E                ; B127
         bit  JOY_RPT              ; B129
         bpl  LB158                ; B12C
LB12E
         bit  JOY                  ; B12E
         bpl  LB158                ; B131
         cmp  JOY_LAST             ; B133
         pha                       ; B136
         php                       ; B137
         lda  $B511                ; B138
         plp                       ; B13B
         beq  LB141                ; B13C
         lda  $B510                ; B13E
LB141
         sta  JOY_RPT              ; B141
         lda  JOY_LAST             ; B144
         sta  $B17E                ; B147
         pla                       ; B14A
         cmp  #$0F                 ; B14B
         beq  LB155                ; B14D
         sta  EVENT                ; B14F
         sta  JOY                  ; B152
LB155
         sta  JOY_LAST             ; B155
LB158
         rts                       ; B158

* clear the input event ------------------------------------
INPUT_CLR_
         lda  EVENT                ; B159
         bne  LB16B                ; B15C
         lda  #$FF                 ; B15E
         sta  EVENT                ; B160
         sta  JOY                  ; B163
         lda  #$00                 ; B166
         sta  $B5BB                ; B168
LB16B
         rts                       ; B16B

* read a key: KBCODE, carry clear if a key is pressed ------
GETKEY_
         lda  SKCTL                ; B16C
         and  #$04                 ; B16F
         bne  LB17A                ; B171
         lda  KBCODE               ; B173
         and  #$3F                 ; B176
         clc                       ; B178
         rts                       ; B179
LB17A
         lda  #$FF                 ; B17A
         sec                       ; B17C
         rts                       ; B17D
         dta $00                                      ; B17E

* test direction bits --------------------------------------
DIR_TEST_
         clc                       ; B17F
         and  $B17E                ; B180
         bne  LB186                ; B183
         sec                       ; B185
LB186
         rts                       ; B186
         dta $00,$00                                  ; B187
