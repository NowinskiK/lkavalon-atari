; ED_MAIN.ASM - editor: jump table $A810, input variables, display lists, start, main loop, board editing, planet test, redraw
; $A810-$AF3D

         org $A810


* module interface: jump table (start, sounds, input, redraw, messages, ...) ---
START
         jmp  START_               ; A810
CLICK
         jmp  CLICK_               ; A813
INPUT_CLR
         jmp  INPUT_CLR_           ; A816
GETKEY
         jmp  GETKEY_              ; A819
REDRAW
         jmp  REDRAW_              ; A81C
COUNT_ELEM
         jmp  COUNT_ELEM_          ; A81F
INPUT
         jmp  INPUT_               ; A822
DIR_TEST
         jmp  DIR_TEST_            ; A825

* module service BELL: the OS buzzer (OS_BELL, XL/XE ROM); not called by Konstruktor itself ---
BELL
         jmp  OS_BELL              ; A828
KEY_EVENT
         jmp  KEY_EVENT_           ; A82B
TO_DIGITS
         jmp  TO_DIGITS_           ; A82E
ASK_YESNO
         jmp  ASK_YESNO_           ; A831
ATA2SCR
         jmp  ATA2SCR_             ; A834
SET_DLIST
         jmp  SET_DLIST_           ; A837
TITLE_ED
         jmp  TITLE_ED_            ; A83A
WAIT_KEY
         jmp  WAIT_KEY_            ; A83D

* input ------------------------
JOY              dta $00                              ; A840 input bits: stick, fire
JOY_LAST         dta $00                              ; A841 previous stick value
JOY_RPT          dta $00                              ; A842 auto-repeat counter
TRIG_ST          dta $00                              ; A843 fire / console keys
EVENT            dta $00                              ; A844 input event flag
TRIG_LAST        dta $00                              ; A845 previous fire / console keys
         dta $10,$F0,$C4,$00,$B6,$C4,$00,$B6,$C4,$28,$B6,$C4,$28,$B6,$C4,$50 ; A846
         dta $B6,$C4,$50,$B6,$C4,$78,$B6,$C4,$78,$B6,$C4,$A0,$B6,$C4,$A0,$B6 ; A856
         dta $C4,$C8,$B6,$C4,$C8,$B6,$C4,$F0,$B6,$C4,$F0,$B6,$C4,$18,$B7,$C4 ; A866
         dta $18,$B7,$C4,$40,$B7,$C4,$40,$B7,$C4,$68,$B7,$C4,$68,$B7,$20,$4F ; A876
         dta $50,$BD,$0F,$0F,$42,$00,$BC,$02,$02,$02,$02,$4F,$00,$BD,$0F,$0F ; A886
         dta $0F,$0F,$42,$C8,$BC,$4F,$00,$BD,$0F,$0F,$41,$46,$A8,$10,$F0,$C4 ; A896
         dta $00,$B8,$C4,$00,$B8,$C4,$28,$B8,$C4,$28,$B8,$C4,$50,$B8,$C4,$50 ; A8A6
         dta $B8,$C4,$78,$B8,$C4,$78,$B8,$C4,$A0,$B8,$C4,$A0,$B8,$C4,$C8,$B8 ; A8B6
         dta $C4,$C8,$B8,$C4,$F0,$B8,$C4,$F0,$B8,$C4,$18,$B9,$C4,$18,$B9,$C4 ; A8C6
         dta $40,$B9,$C4,$40,$B9,$C4,$68,$B9,$C4,$68,$B9,$20,$4F,$50,$BD,$0F ; A8D6
         dta $0F,$42,$00,$BC,$02,$02,$02,$02,$4F,$00,$BD,$0F,$0F,$0F,$0F,$42 ; A8E6
         dta $C8,$BC,$4F,$00,$BD,$0F,$0F,$41,$A3,$A8,$10,$70,$4F,$50,$BD,$0F ; A8F6
         dta $42,$00,$B6,$4F,$78,$BD,$0F,$0F,$42,$28,$B6,$02,$02,$02,$02,$02 ; A906
         dta $02,$02,$4F,$78,$BD,$0F,$0F,$4F,$50,$BD,$0F,$42,$00,$B8,$4F,$78 ; A916
         dta $BD,$0F,$0F,$42,$28,$B8,$02,$02,$02,$02,$02,$02,$02,$4F,$00,$BD ; A926
         dta $0F,$0F,$20,$4F,$50,$BD,$0F,$0F,$42,$00,$BC,$02,$02,$02,$02,$4F ; A936
         dta $00,$BD,$0F,$0F,$0F,$0F,$42,$C8,$BC,$4F,$00,$BD,$0F,$0F,$41,$00 ; A946
         dta $A9                                      ; A956
;     ·      tekst początkowy:       ·
         dta d'    '*,$DD,d'      tekst pocz@tkowy:       '*,$DD,d'    '* ; A957
;     ·     tekst gratulacyjny:      ·
         dta d'    '*,$DD,d'     tekst gratulacyjny:      '*,$DD,d'    '* ; A97F

* start: stack, init, then the main loop -------------------
START_
         cli                       ; A9A7
         cld                       ; A9A8
         ldx  #$FF                 ; A9A9
         txs                       ; A9AB
         stx  CH                   ; A9AC
         stx  JOY                  ; A9AF
         jsr  ED_SETUP             ; A9B2

* editor main loop: every 4 frames (CDTMV3) - redraw, frame, cursor ---
MAIN_LOOP
         lda  CDTMV3               ; A9B5
         bne  MAIN_LOOP            ; A9B8
         lda  #$04                 ; A9BA
         sta  CDTMV3               ; A9BC
         lda  #$FF                 ; A9BF
         sta  CH                   ; A9C1
         inc  FRAMES               ; A9C4
         jsr  REDRAW               ; A9C6
         jsr  ED_FRAME             ; A9C9
         jsr  EDIT                 ; A9CC
         jmp  MAIN_LOOP            ; A9CF

* board editor: cursor, palette, put elements --------------
EDIT
         lda  ED_FLAGS             ; A9D2
         bmi  LA9D7                ; A9D4
         rts                       ; A9D6
LA9D7
         inc  $B5BB                ; A9D7
         lda  #$00                 ; A9DA
         sta  $AB3E                ; A9DC
         ldx  CUR_X                ; A9DF
         ldy  CUR_Y                ; A9E1
         lda  WIN_TOP              ; A9E3
         sta  $B6                  ; A9E5
         lda  JOY                  ; A9E7
         and  #$08                 ; A9EA
         bne  LAA03                ; A9EC
         cpx  #$0F                 ; A9EE
         bne  LA9F7                ; A9F0
         lda  TRIG_ST              ; A9F2
         beq  LAA03                ; A9F5
LA9F7
         inx                       ; A9F7
         cpx  #$10                 ; A9F8
         bne  LA9FD                ; A9FA
         inx                       ; A9FC
LA9FD
         cpx  #$14                 ; A9FD
         bcc  LAA03                ; A9FF
         ldx  #$00                 ; AA01
LAA03
         lda  JOY                  ; AA03
         and  #$04                 ; AA06
         bne  LAA1D                ; AA08
         txa                       ; AA0A
         bne  LAA12                ; AA0B
         lda  TRIG_ST              ; AA0D
         beq  LAA1D                ; AA10
LAA12
         dex                       ; AA12
         cpx  #$10                 ; AA13
         bne  LAA18                ; AA15
         dex                       ; AA17
LAA18
         txa                       ; AA18
         bpl  LAA1D                ; AA19
         ldx  #$13                 ; AA1B
LAA1D
         lda  JOY                  ; AA1D
         and  #$02                 ; AA20
         bne  LAA40                ; AA22
         iny                       ; AA24
         cpy  #$0A                 ; AA25
         bcc  LAA40                ; AA27
         dey                       ; AA29
         cpx  #$10                 ; AA2A
         bcc  LAA38                ; AA2C
         lda  #$02                 ; AA2E
         jsr  DIR_TEST             ; AA30
         bcs  LAA40                ; AA33
         jmp  LAB4D                ; AA35
LAA38
         lda  WIN_TOP              ; AA38
         cmp  #$15                 ; AA3A
         bcs  LAA40                ; AA3C
         inc  $B6                  ; AA3E
LAA40
         lda  JOY                  ; AA40
         and  #$01                 ; AA43
         bne  LAA55                ; AA45
         dey                       ; AA47
         bpl  LAA55                ; AA48
         iny                       ; AA4A
         cpx  #$10                 ; AA4B
         bcs  LAA55                ; AA4D
         lda  WIN_TOP              ; AA4F
         beq  LAA55                ; AA51
         dec  $B6                  ; AA53
LAA55
         lda  $B6                  ; AA55
         cmp  WIN_TOP              ; AA57
         bne  LAA63                ; AA59
         cpx  CUR_X                ; AA5B
         bne  LAA63                ; AA5D
         cpy  CUR_Y                ; AA5F
         beq  LAA80                ; AA61
LAA63
         lda  #$00                 ; AA63
         sta  $B5BB                ; AA65
         stx  CUR_X                ; AA68
         sty  CUR_Y                ; AA6A
         lda  $B6                  ; AA6C
         sta  WIN_TOP              ; AA6E
         lda  TRIG_ST              ; AA70
         beq  LAA7B                ; AA73
         jsr  CLICK                ; AA75
         jmp  LAA80                ; AA78
LAA7B
         lda  #$01                 ; AA7B
         sta  $AB3E                ; AA7D
LAA80
         lda  #$FF                 ; AA80
         sta  JOY                  ; AA82
         jsr  KEY_EVENT            ; AA85
         bcs  LAA8D                ; AA88
         jmp  LAB4D                ; AA8A
LAA8D
         cmp  #$27                 ; AA8D
         beq  LAAE2                ; AA8F
         lda  CUR_X                ; AA91
         cmp  #$10                 ; AA93
         bcc  LAAED                ; AA95
         lda  #$0D                 ; AA97
         sta  HELP_PAGE            ; AA99
         lda  CUR_Y                ; AA9B
         asl                       ; AA9D
         adc  CUR_Y                ; AA9E
         sta  $B6                  ; AAA0
         sec                       ; AAA2
         lda  CUR_X                ; AAA3
         sbc  #$11                 ; AAA5
         clc                       ; AAA7
         adc  $B6                  ; AAA8
         pha                       ; AAAA
         tax                       ; AAAB
         lda  $B51C,x              ; AAAC
         jsr  ELEM_MSG             ; AAAF
         pla                       ; AAB2
         tax                       ; AAB3
         lda  $B51C,x              ; AAB4
         bmi  LAAE2                ; AAB7
         cpx  PAL_SEL              ; AAB9
         bne  LAAD8                ; AABB
         cmp  #$00                 ; AABD
         bne  LAB2E                ; AABF
         jsr  INPUT_CLR            ; AAC1
         bne  LAB2E                ; AAC4
         jsr  CELL_HEADER          ; AAC6
         ldy  #$00                 ; AAC9
         clc                       ; AACB
         lda  ($B2),y              ; AACC
         adc  #$20                 ; AACE
         sta  ($B2),y              ; AAD0
         jsr  CLICK                ; AAD2
         jmp  LAB2E                ; AAD5
LAAD8
         jsr  INPUT_CLR            ; AAD8
         bne  LAB2E                ; AADB
         stx  PAL_SEL              ; AADD
         jmp  CLICK                ; AADF
LAAE2
         jsr  INPUT_CLR            ; AAE2
         bne  LAB2E                ; AAE5
         inc  $B5BA                ; AAE7
         jmp  CLICK                ; AAEA
LAAED
         lda  #$00                 ; AAED
         jsr  MESSAGE              ; AAEF
         lda  #$0E                 ; AAF2
         sta  HELP_PAGE            ; AAF4
         ldx  CUR_X                ; AAF6
         clc                       ; AAF8
         lda  CUR_Y                ; AAF9
         adc  WIN_TOP              ; AAFB
         tay                       ; AAFD
         jsr  CELL_ADDR            ; AAFE
         ldx  PAL_SEL              ; AB01
         lda  $B51C,x              ; AB03
         sta  $AB35                ; AB06
         ldy  #$00                 ; AB09
         lda  ($B2),y              ; AB0B
         cmp  #$41                 ; AB0D
         bcc  LAB1D                ; AB0F
         cmp  #$49                 ; AB11
         bcs  LAB1D                ; AB13
         sec                       ; AB15
         sbc  #$41                 ; AB16
         and  #$04                 ; AB18
         clc                       ; AB1A
         adc  #$41                 ; AB1B
LAB1D
         cmp  $AB35                ; AB1D
         beq  LAB3D                ; AB20
         lda  JOY_LAST             ; AB22
         cmp  #$0F                 ; AB25
         bne  LAB2F                ; AB27
         jsr  INPUT_CLR            ; AB29
         beq  LAB34                ; AB2C
LAB2E
         rts                       ; AB2E
LAB2F
         lda  TRIG_ST              ; AB2F
         bne  LAB2E                ; AB32
LAB34
         lda  #$00                 ; AB34
         ldy  #$00                 ; AB36
         sta  ($B2),y              ; AB38
         jmp  CLICK                ; AB3A
LAB3D
         lda  #$3D                 ; AB3D
         bne  LAB4A                ; AB3F
         jsr  INPUT_CLR            ; AB41
         bne  LAB2E                ; AB44
         lda  #$20                 ; AB46
         sta  ($B2),y              ; AB48
LAB4A
         jmp  CLICK                ; AB4A
LAB4D
         jsr  CLICK                ; AB4D
         ldx  #$00                 ; AB50
         stx  ED_FLAGS             ; AB52
         stx  $B5BB                ; AB54
         dex                       ; AB57
         stx  JOY                  ; AB58
         lda  CUR_X                ; AB5B
         pha                       ; AB5D
         lda  CUR_Y                ; AB5E
         pha                       ; AB60
         lda  #$1E                 ; AB61
         sta  CUR_Y                ; AB63
LAB65
         lda  #$0F                 ; AB65
         sta  CUR_X                ; AB67
LAB69
         jsr  AUTO_VARIANT         ; AB69
         dec  CUR_X                ; AB6C
         bpl  LAB69                ; AB6E
         dec  CUR_Y                ; AB70
         bpl  LAB65                ; AB72
         pla                       ; AB74
         sta  CUR_Y                ; AB75
         pla                       ; AB77
         sta  CUR_X                ; AB78
         jsr  PLANET_TEST          ; AB7A
         bcc  LAB89                ; AB7D
         beq  LAB83                ; AB7F
         ora  #$80                 ; AB81
LAB83
         ldx  PLANET               ; AB83
         sta  PLANET_STATE,x       ; AB85
         rts                       ; AB88
LAB89
         pha                       ; AB89
         jsr  CELL_HEADER          ; AB8A
         pla                       ; AB8D
         jsr  TO_DIGITS            ; AB8E
         tya                       ; AB91
         ldy  #$01                 ; AB92
         sta  ($B2),y              ; AB94
         dey                       ; AB96
         lda  ($B2),y              ; AB97
         and  #$E0                 ; AB99
         ora  PLANET               ; AB9B
         sta  ($B2),y              ; AB9D
         ldx  PLANET               ; AB9F
         lda  #$01                 ; ABA1
         sta  PLANET_STATE,x       ; ABA3
         rts                       ; ABA6

* choose the variant ($41-$45) of an element from its free neighbours ---
AUTO_VARIANT
         ldx  CUR_X                ; ABA7
         ldy  CUR_Y                ; ABA9
         jsr  CELL_ADDR            ; ABAB
         ldy  #$00                 ; ABAE
         lda  ($B2),y              ; ABB0
         cmp  #$41                 ; ABB2
         bcc  LAC08                ; ABB4
         cmp  #$46                 ; ABB6
         bcs  LAC08                ; ABB8
         sec                       ; ABBA
         sbc  #$41                 ; ABBB
         and  #$04                 ; ABBD
         clc                       ; ABBF
         adc  #$41                 ; ABC0
         sta  $B4                  ; ABC2
         ldx  CUR_X                ; ABC4
         ldy  CUR_Y                ; ABC6
         jsr  CELL_ADDR            ; ABC8
         sec                       ; ABCB
         lda  $B2                  ; ABCC
         sbc  #$11                 ; ABCE
         sta  $B2                  ; ABD0
         bcs  LABD6                ; ABD2
         dec  $B3                  ; ABD4
LABD6
         ldx  #$03                 ; ABD6
LABD8
         clc                       ; ABD8
         lda  CUR_X                ; ABD9
         adc  $AC0D,x              ; ABDB
         cmp  #$10                 ; ABDE
         bcs  LABF7                ; ABE0
         lda  CUR_Y                ; ABE2
         adc  $AC11,x              ; ABE4
         cmp  #$1F                 ; ABE7
         bcs  LABF7                ; ABE9
         ldy  $AC09,x              ; ABEB
         lda  ($B2),y              ; ABEE
         cmp  #$20                 ; ABF0
         bne  LABF7                ; ABF2
         dex                       ; ABF4
         bne  LABD8                ; ABF5
LABF7
         clc                       ; ABF7
         txa                       ; ABF8
         adc  $B4                  ; ABF9
         pha                       ; ABFB
         ldx  CUR_X                ; ABFC
         ldy  CUR_Y                ; ABFE
         jsr  CELL_ADDR            ; AC00
         pla                       ; AC03
         ldy  #$00                 ; AC04
         sta  ($B2),y              ; AC06
LAC08
         rts                       ; AC08
         dta $10,$12,$01,$21,$FF,$01,$00,$00,$00,$00,$FF,$01 ; AC09

* test a planet: empty, Robbo ($2A) exactly 1, capsule ($14) exactly 1, screws ($24) < 100 ---
PLANET_TEST
         ldx  #$00                 ; AC15
         ldy  #$00                 ; AC17
         jsr  CELL_ADDR            ; AC19
         ldy  #$00                 ; AC1C
LAC1E
         lda  ($B2),y              ; AC1E
         cmp  #$20                 ; AC20
         bne  LAC38                ; AC22
         iny                       ; AC24
         bne  LAC1E                ; AC25
         inc  $B3                  ; AC27
LAC29
         lda  ($B2),y              ; AC29
         cmp  #$20                 ; AC2B
         bne  LAC38                ; AC2D
         iny                       ; AC2F
         cpy  #$F0                 ; AC30
         bcc  LAC29                ; AC32
         lda  #$00                 ; AC34
         beq  LAC68                ; AC36
LAC38
         lda  #$2A                 ; AC38
         jsr  COUNT_ELEM           ; AC3A
         tay                       ; AC3D
         bne  LAC44                ; AC3E
         lda  #$04                 ; AC40
         bne  LAC68                ; AC42
LAC44
         lda  #$06                 ; AC44
         cpy  #$01                 ; AC46
         bne  LAC68                ; AC48
         lda  #$14                 ; AC4A
         jsr  COUNT_ELEM           ; AC4C
         tay                       ; AC4F
         bne  LAC56                ; AC50
         lda  #$05                 ; AC52
         bne  LAC68                ; AC54
LAC56
         lda  #$07                 ; AC56
         cpy  #$01                 ; AC58
         bne  LAC68                ; AC5A
         lda  #$24                 ; AC5C
         jsr  COUNT_ELEM           ; AC5E
         cmp  #$64                 ; AC61
         bcs  LAC66                ; AC63
         rts                       ; AC65
LAC66
         lda  #$08                 ; AC66
LAC68
         tax                       ; AC68
         sec                       ; AC69
         rts                       ; AC6A

* address of the planet header (row 31) --------------------
CELL_HEADER
         ldx  #$00                 ; AC6B
         ldy  #$1F                 ; AC6D

* cell address: $5000 + planet * $200 + row * 16 + column ---
CELL_ADDR
         lda  #$00                 ; AC6F
         sta  $B3                  ; AC71
         tya                       ; AC73
         asl                       ; AC74
         asl                       ; AC75
         asl                       ; AC76
         asl                       ; AC77
         rol  $B3                  ; AC78
         sta  $B2                  ; AC7A
         lda  PLANET               ; AC7C
         asl                       ; AC7E
         adc  #$50                 ; AC7F
         adc  $B3                  ; AC81
         sta  $B3                  ; AC83
         txa                       ; AC85
         adc  $B2                  ; AC86
         sta  $B2                  ; AC88
         rts                       ; AC8A

* count the cells holding element A on the current planet ---
COUNT_ELEM_
         sta  $B4                  ; AC8B
         lda  #$00                 ; AC8D
         sta  $B6                  ; AC8F
         lda  #$1E                 ; AC91
         sta  $B7                  ; AC93
LAC95
         ldx  #$0F                 ; AC95
LAC97
         ldy  $B7                  ; AC97
         jsr  CELL_ADDR            ; AC99
         ldy  #$00                 ; AC9C
         lda  ($B2),y              ; AC9E
         cmp  $B4                  ; ACA0
         bne  LACAA                ; ACA2
         bit  $B6                  ; ACA4
         bmi  LACAA                ; ACA6
         inc  $B6                  ; ACA8
LACAA
         dex                       ; ACAA
         bpl  LAC97                ; ACAB
         dec  $B7                  ; ACAD
         bpl  LAC95                ; ACAF
         lda  $B6                  ; ACB1
         rts                       ; ACB3
         dta $03,$B0                                  ; ACB4

* redraw: palette, board window, planet strip, element preview; swap display lists ---
REDRAW_
         lda  $B5BA                ; ACB6
         and  #$03                 ; ACB9
         asl                       ; ACBB
         asl                       ; ACBC
         asl                       ; ACBD
         adc  #$07                 ; ACBE
         tax                       ; ACC0
         ldy  #$07                 ; ACC1
LACC3
         lda  $B53A,x              ; ACC3
         sta  $B532,y              ; ACC6
         dex                       ; ACC9
         dey                       ; ACCA
         bpl  LACC3                ; ACCB
         lda  #$00                 ; ACCD
         jsr  BLINK                ; ACCF
         lda  #$1D                 ; ACD2
         sta  $B6                  ; ACD4
         lda  #$09                 ; ACD6
         sta  $B7                  ; ACD8
LACDA
         ldx  #$13                 ; ACDA
LACDC
         ldy  $B6                  ; ACDC
         lda  $B51C,y              ; ACDE
         bpl  LACE7                ; ACE1
         lda  #$39                 ; ACE3
         bne  LAD06                ; ACE5
LACE7
         cmp  #$20                 ; ACE7
         bne  LACEF                ; ACE9
         lda  #$31                 ; ACEB
         bne  LAD06                ; ACED
LACEF
         cmp  #$00                 ; ACEF
         bne  LACF9                ; ACF1
         ldy  PLANET               ; ACF3
         bpl  LACF9                ; ACF5
         lda  #$20                 ; ACF7
LACF9
         sec                       ; ACF9
         and  #$7F                 ; ACFA
         sbc  #$20                 ; ACFC
         bcs  LAD02                ; ACFE
         adc  #$60                 ; AD00
LAD02
         tay                       ; AD02
         lda  $B55A,y              ; AD03
LAD06
         ldy  $B6                  ; AD06
         cpy  PAL_SEL              ; AD08
         bne  LAD1B                ; AD0A
         bit  ED_FLAGS             ; AD0C
         bpl  LAD1B                ; AD0E
         pha                       ; AD10
         lda  FRAMES               ; AD11
         lsr                       ; AD13
         lsr                       ; AD14
         pla                       ; AD15
         bcc  LAD1B                ; AD16
         lda  $B55A                ; AD18
LAD1B
         ldy  $B7                  ; AD1B
         jsr  PUT_CELL             ; AD1D
         dec  $B6                  ; AD20
         dex                       ; AD22
         cpx  #$11                 ; AD23
         bcs  LACDC                ; AD25
         dec  $B7                  ; AD27
         bpl  LACDA                ; AD29
         lda  $B55A                ; AD2B
         ldx  #$10                 ; AD2E
         ldy  #$09                 ; AD30
         jsr  PUT_CELL             ; AD32
         ldy  #$00                 ; AD35
         lda  $B55A                ; AD37
         jsr  PUT_CELL             ; AD3A
         iny                       ; AD3D
         jsr  PUT_CELL             ; AD3E
         lda  $AF36                ; AD41
         sta  $B0                  ; AD44
         lda  $AF37                ; AD46
         sta  $B1                  ; AD49
         lda  #$00                 ; AD4B
         sta  $B6                  ; AD4D
         tay                       ; AD4F
LAD50
         clc                       ; AD50
         lda  WIN_TOP              ; AD51
         adc  #$01                 ; AD53
         lsr                       ; AD55
         lsr                       ; AD56
         cmp  $B6                  ; AD57
         bne  LAD91                ; AD59
         clc                       ; AD5B
         lda  WIN_TOP              ; AD5C
         adc  #$01                 ; AD5E
         cmp  #$04                 ; AD60
         bcc  LAD68                ; AD62
         and  #$03                 ; AD64
         adc  #$03                 ; AD66
LAD68
         asl                       ; AD68
         asl                       ; AD69
         tax                       ; AD6A
LAD6B
         lda  $B5E0,x              ; AD6B
         sta  ($B0),y              ; AD6E
         lda  $B55A                ; AD70
         asl                       ; AD73
         iny                       ; AD74
         sta  ($B0),y              ; AD75
         dey                       ; AD77
         clc                       ; AD78
         lda  #$28                 ; AD79
         adc  $B0                  ; AD7B
         sta  $B0                  ; AD7D
         bcc  LAD83                ; AD7F
         inc  $B1                  ; AD81
LAD83
         inc  $B6                  ; AD83
         lda  $B6                  ; AD85
         cmp  #$08                 ; AD87
         bcs  LADB6                ; AD89
         inx                       ; AD8B
         txa                       ; AD8C
         and  #$03                 ; AD8D
         bne  LAD6B                ; AD8F
LAD91
         lda  #$54                 ; AD91
         ldx  $B6                  ; AD93
         bne  LAD99                ; AD95
         lda  #$5C                 ; AD97
LAD99
         sta  ($B0),y              ; AD99
         lda  $B55A                ; AD9B
         asl                       ; AD9E
         iny                       ; AD9F
         sta  ($B0),y              ; ADA0
         dey                       ; ADA2
         clc                       ; ADA3
         lda  #$28                 ; ADA4
         adc  $B0                  ; ADA6
         sta  $B0                  ; ADA8
         bcc  LADAE                ; ADAA
         inc  $B1                  ; ADAC
LADAE
         inc  $B6                  ; ADAE
         lda  $B6                  ; ADB0
         cmp  #$08                 ; ADB2
         bcc  LAD50                ; ADB4
LADB6
         lda  #$01                 ; ADB6
         jsr  BLINK                ; ADB8
         ldx  #$00                 ; ADBB
         ldy  WIN_TOP              ; ADBD
         jsr  CELL_ADDR            ; ADBF
         clc                       ; ADC2
         lda  $B2                  ; ADC3
         adc  #$9F                 ; ADC5
         sta  $B2                  ; ADC7
         lda  $B3                  ; ADC9
         adc  #$00                 ; ADCB
         sta  $B3                  ; ADCD
         lda  #$09                 ; ADCF
         sta  $B6                  ; ADD1
LADD3
         ldx  #$0F                 ; ADD3
LADD5
         ldy  #$00                 ; ADD5
         lda  PLANET               ; ADD7
         bmi  LADE7                ; ADD9
         lda  ($B2),y              ; ADDB
         sec                       ; ADDD
         and  #$7F                 ; ADDE
         sbc  #$20                 ; ADE0
         bcs  LADE6                ; ADE2
         adc  #$60                 ; ADE4
LADE6
         tay                       ; ADE6
LADE7
         lda  $B55A,y              ; ADE7
         ldy  $B6                  ; ADEA
         jsr  PUT_CELL             ; ADEC
         lda  $B2                  ; ADEF
         bne  LADF5                ; ADF1
         dec  $B3                  ; ADF3
LADF5
         dec  $B2                  ; ADF5
         dex                       ; ADF7
         bpl  LADD5                ; ADF8
         dec  $B6                  ; ADFA
         bpl  LADD3                ; ADFC
         lda  #$00                 ; ADFE
         sta  $B5                  ; AE00
         lda  $B4                  ; AE02
         asl                       ; AE04
         asl                       ; AE05
         rol  $B5                  ; AE06
         asl                       ; AE08
         rol  $B5                  ; AE09
         asl                       ; AE0B
         rol  $B5                  ; AE0C
         sta  $B4                  ; AE0E
         lda  #$40                 ; AE10
         adc  $B5                  ; AE12
         sta  $B5                  ; AE14
         lda  #$F0                 ; AE16
         sta  $B2                  ; AE18
         lda  #$43                 ; AE1A
         sta  $B3                  ; AE1C
         lda  #$60                 ; AE1E
LAE20
         cmp  VCOUNT               ; AE20
         bne  LAE20                ; AE23
         ldx  #$46                 ; AE25
         ldy  #$A8                 ; AE27
         lda  SCR_PAGE             ; AE29
         cmp  #$B6                 ; AE2B
         php                       ; AE2D
         beq  LAE34                ; AE2E
         ldx  #$A3                 ; AE30
         ldy  #$A8                 ; AE32
LAE34
         stx  SDLSTL               ; AE34
         sty  SDLSTH               ; AE37
         lda  #$22                 ; AE3A
         sta  SDMCTL               ; AE3C
         lda  #$B6                 ; AE3F
         plp                       ; AE41
         bne  LAE46                ; AE42
         lda  #$B8                 ; AE44
LAE46
         sta  SCR_PAGE             ; AE46
         lda  FRAMES               ; AE48
         lsr                       ; AE4A
         and  #$03                 ; AE4B
         tax                       ; AE4D
         lda  $B5E0,x              ; AE4E
         lda  #$AA                 ; AE51
         sta  $B5BF                ; AE53
         ldy  #$00                 ; AE56
         ldx  #$00                 ; AE58
LAE5A
         lda  $B5C0,x              ; AE5A
         eor  #$FF                 ; AE5D
         and  ($B4),y              ; AE5F
         sta  ($B2),y              ; AE61
         lda  $B5C0,x              ; AE63
         and  $B5BF                ; AE66
         ora  ($B2),y              ; AE69
         sta  ($B2),y              ; AE6B
         inx                       ; AE6D
         iny                       ; AE6E
         cpy  #$10                 ; AE6F
         bcc  LAE5A                ; AE71
         ldy  #$04                 ; AE73
LAE75
         inc  $B3                  ; AE75
         inc  $B5                  ; AE77
         dey                       ; AE79
         bne  LAE75                ; AE7A
         cpx  #$1F                 ; AE7C
         bcc  LAE5A                ; AE7E
         jsr  CELL_HEADER          ; AE80
         ldy  #$00                 ; AE83
         tya                       ; AE85
         ldx  PLANET               ; AE86
         bmi  LAE8C                ; AE88
         lda  ($B2),y              ; AE8A
LAE8C
         lsr                       ; AE8C
         pha                       ; AE8D
         and  #$30                 ; AE8E
         sta  $B4                  ; AE90
         sta  $B0                  ; AE92
         ldx  #$48                 ; AE94
         pla                       ; AE96
         and  #$40                 ; AE97
         beq  LAE9D                ; AE99
         inx                       ; AE9B
         inx                       ; AE9C
LAE9D
         stx  $B5                  ; AE9D
         inx                       ; AE9F
         stx  $B1                  ; AEA0
         ldy  #$0F                 ; AEA2
LAEA4
         lda  ($B4),y              ; AEA4
         sta  $43E0,y              ; AEA6
         lda  ($B0),y              ; AEA9
         sta  $47E0,y              ; AEAB
         dey                       ; AEAE
         bpl  LAEA4                ; AEAF
         rts                       ; AEB1

* blinking: toggle bit 0 of the selected glyphs every 4 frames ---
BLINK
         sta  $B6                  ; AEB2
         lda  FRAMES               ; AEB4
         and  #$04                 ; AEB6
         bne  LAEBC                ; AEB8
         sta  $B6                  ; AEBA
LAEBC
         ldy  #$2E                 ; AEBC
LAEBE
         jsr  BLINK_ONE            ; AEBE
         dey                       ; AEC1
         cpy  #$21                 ; AEC2
         bcs  LAEBE                ; AEC4
         ldy  #$06                 ; AEC6
         jsr  BLINK_ONE            ; AEC8
         ldy  #$54                 ; AECB
         jsr  BLINK_ONE            ; AECD
         ldy  #$0A                 ; AED0

* blinking: one glyph --------------------------------------
BLINK_ONE
         lda  $B55A,y              ; AED2
         and  #$FE                 ; AED5
         ora  $B6                  ; AED7
         sta  $B55A,y              ; AED9
         rts                       ; AEDC

* draw one board cell into the screen ----------------------
PUT_CELL
         cpy  CUR_Y                ; AEDD
         bne  LAEFD                ; AEDF
         cpx  CUR_X                ; AEE1
         bne  LAEFD                ; AEE3
         sta  $B4                  ; AEE5
         bit  ED_FLAGS             ; AEE7
         bpl  LAEFD                ; AEE9
         sta  $AEF5                ; AEEB
         lda  $B5BB                ; AEEE
         and  #$04                 ; AEF1
         php                       ; AEF3
         lda  #$F4                 ; AEF4
         plp                       ; AEF6
         bne  LAEFD                ; AEF7
         and  #$80                 ; AEF9
         ora  #$3F                 ; AEFB
LAEFD
         pha                       ; AEFD
         lda  #$00                 ; AEFE
         sta  $B1                  ; AF00
         tya                       ; AF02
         asl                       ; AF03
         asl                       ; AF04
         asl                       ; AF05
         sta  $B0                  ; AF06
         asl                       ; AF08
         asl                       ; AF09
         rol  $B1                  ; AF0A
         adc  $B0                  ; AF0C
         sta  $B0                  ; AF0E
         bcc  LAF14                ; AF10
         inc  $B1                  ; AF12
LAF14
         txa                       ; AF14
         asl                       ; AF15
         adc  $B0                  ; AF16
         sta  $AF36                ; AF18
         ora  #$01                 ; AF1B
         sta  $AF3B                ; AF1D
         bcc  LAF24                ; AF20
         inc  $B1                  ; AF22
LAF24
         clc                       ; AF24
         lda  $B1                  ; AF25
         adc  SCR_PAGE             ; AF27
         sta  $AF37                ; AF29
         sta  $AF3C                ; AF2C
         pla                       ; AF2F
         asl                       ; AF30
         php                       ; AF31
         asl                       ; AF32
         plp                       ; AF33
         ror                       ; AF34
         sta  $AF35                ; AF35
         ora  #$01                 ; AF38
         sta  $AF3A                ; AF3A
         rts                       ; AF3D
