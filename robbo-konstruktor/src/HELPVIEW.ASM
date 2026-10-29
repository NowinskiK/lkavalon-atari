; HELPVIEW.ASM - help viewer: screen (display list, credits panel), paging, line unpacking
; $0800-$0C6C

         org $0800


* HELP: show the help text, page by page (entered from HELP_KEY) ---
HELP
         jmp  HELP_                ; 0800

* help screen display list: frame $092E, help page $B600 (17 lines), frame $0956, panel $083E (5 lines) and $0906 between graphics lines $BD00 / $BD50 ---
         dta $10,$70,$42,$2E,$09,$02,$42,$00,$B6,$02,$02,$02,$02,$02,$02,$02 ; 0803
         dta $02,$02,$02,$02,$02,$02,$02,$02,$42,$56,$09,$02,$20,$4F,$50,$BD ; 0813
         dta $0F,$0F,$42,$3E,$08,$02,$02,$02,$02,$4F,$00,$BD,$0F,$0F,$0F,$0F ; 0823
         dta $42,$06,$09,$4F,$00,$BD,$0F,$0F,$41,$03,$08 ; 0833

* help screen bottom panel (credits) and key hints - screen codes ---
;        ··  Robbo  Konstruktor  ··
         dta d'       ',$45,$46,d'  Robbo  Konstruktor  ',$49,$4A,d'       ' ; 083E
;        ··  autor: Janusz Pelc  ··
         dta d'       ',$47,$48,d'  autor: Janusz Pelc  ',$4B,$4C,d'       ' ; 0866
; 
         dta d'                                        ' ; 088E
;      /1990 Laboratorium Komputerowe
         dta d'     /1990 Laboratorium Komputerowe     ' ; 08B6
;                  Avalon
         dta d'                 Avalon                 ' ; 08DE
; 
         dta d'   '                                   ; 0906

* help viewer ------------------
HLP_ARROWS       dta $5E,$5F                          ; 0909 arrows <- -> in the key hint line: 0 = no previous / next page
; : zmiana strony,    strzał: menu
         dta d': zmiana strony,    strza]: menu   '   ; 090B

* frame lines around the help page (frame characters of the font) ---
         dta $00,$1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D ; 092E
         dta $1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D ; 093E
         dta $1D,$1D,$1D,$1D,$1D,$1D,$1D,$00          ; 094E
HLP_LINEBUF      dta $1B,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$1C ; 0956 frame line under the help page, also the line buffer of the scroll
         dta $00,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E ; 097E
         dta $1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E ; 098E
         dta $1E,$1E,$1E,$1E,$1E,$1E,$1E,$00          ; 099E

* help: save PTR1 ... TMP4, find page HELP_PAGE, show it; the stick turns pages, fire leaves ---
HELP_
         sta  HLP_TAPE             ; 09A6
         ldx  #$07                 ; 09A9
L09AB
         lda  PTR1,x               ; 09AB
         sta  HLP_SAVE,x           ; 09AD
         dex                       ; 09B0
         bpl  L09AB                ; 09B1
HLP_FIRST        equ *+1                              ; 09B4 first call (start-up page): no click; ASL clears it
         lda  #$80                 ; 09B3
         bne  L09BD                ; 09B5
         jsr  CLICK                ; 09B7
         jsr  ED_DLIST             ; 09BA
L09BD
         asl  HLP_FIRST            ; 09BD
         lda  #$79                 ; 09C0
         sta  PTR2                 ; 09C2
         lda  #$0C                 ; 09C4
         sta  PTR2+1               ; 09C6
         ldy  #$00                 ; 09C8
L09CA
         lda  (PTR2),y             ; 09CA
         and  #$7F                 ; 09CC
         beq  L09D7                ; 09CE
         iny                       ; 09D0
         bne  L09CA                ; 09D1
         inc  PTR2+1               ; 09D3
         bne  L09CA                ; 09D5
L09D7
         clc                       ; 09D7
         tya                       ; 09D8
         adc  PTR2                 ; 09D9
         sta  PTR2                 ; 09DB
         bcc  L09E1                ; 09DD
         inc  PTR2+1               ; 09DF
L09E1
         ldy  #$01                 ; 09E1
         lda  (PTR2),y             ; 09E3
         beq  L09F5                ; 09E5
         cmp  HELP_PAGE            ; 09E7
         bne  L09CA                ; 09E9
         lda  PTR2                 ; 09EB
         sta  HLP_TOP              ; 09ED
         lda  PTR2+1               ; 09F0
         sta  HLP_TOP+1            ; 09F2
L09F5
         jsr  HLP_PAGE             ; 09F5
         jsr  HLP_COPY             ; 09F8
         ldx  #$03                 ; 09FB
         ldy  #$08                 ; 09FD
         jsr  SET_DLIST            ; 09FF
L0A02
         jsr  INPUT                ; 0A02
         lda  JOY                  ; 0A05
         and  #$04                 ; 0A08
         bne  L0A12                ; 0A0A
         jsr  HLP_PREV             ; 0A0C
         jmp  L0A1C                ; 0A0F
L0A12
         lda  JOY                  ; 0A12
         and  #$08                 ; 0A15
         bne  L0A24                ; 0A17
         jsr  HLP_NEXT             ; 0A19
L0A1C
         lda  #$FF                 ; 0A1C
         sta  JOY                  ; 0A1E
         jmp  L0A02                ; 0A21
L0A24
         jsr  KEY_EVENT            ; 0A24
         bcc  L0A2E                ; 0A27
         jsr  INPUT_CLR            ; 0A29
         bne  L0A1C                ; 0A2C
L0A2E
         jsr  CLICK                ; 0A2E
         jsr  ED_DLIST             ; 0A31
         ldx  #$07                 ; 0A34
L0A36
         lda  HLP_SAVE,x           ; 0A36
         sta  PTR1,x               ; 0A39
         dex                       ; 0A3B
         bpl  L0A36                ; 0A3C
         rts                       ; 0A3E

* help: draw one page (16 lines) from the text pointer HLP_TOP ---
HLP_PAGE
         ldx  #$5E                 ; 0A3F
         stx  HLP_ARROWS           ; 0A41
         inx                       ; 0A44
         stx  HLP_ARROWS+1         ; 0A45
         jsr  HLP_PTRTXT           ; 0A48
         ldx  #$00                 ; 0A4B
         stx  HLP_INV              ; 0A4D
         lda  (PTR2,x)             ; 0A50
         cmp  #$80                 ; 0A52
         bne  L0A59                ; 0A54
         stx  HLP_ARROWS           ; 0A56
L0A59
         jsr  HLP_INCTXT           ; 0A59
         jsr  HLP_INCTXT           ; 0A5C
         ldx  #$10                 ; 0A5F
L0A61
         txa                       ; 0A61
         pha                       ; 0A62
         jsr  HLP_LINE             ; 0A63
         jsr  HLP_NEXTLN           ; 0A66
         pla                       ; 0A69
         tax                       ; 0A6A
         dex                       ; 0A6B
         bne  L0A61                ; 0A6C
         ldx  #$00                 ; 0A6E
         lda  (PTR2,x)             ; 0A70
         cmp  #$80                 ; 0A72
         bne  L0A79                ; 0A74
         stx  HLP_ARROWS+1         ; 0A76
L0A79
         rts                       ; 0A79

* help: format one line - frame characters, $14 toggles inverse, inverse digits = indentation ---
HLP_LINE
         ldy  #$27                 ; 0A7A
         lda  #$1C                 ; 0A7C
         sta  (PTR1),y             ; 0A7E
         dey                       ; 0A80
         lda  #$00                 ; 0A81
L0A83
         sta  (PTR1),y             ; 0A83
         dey                       ; 0A85
         bne  L0A83                ; 0A86
         lda  #$1B                 ; 0A88
         sta  (PTR1),y             ; 0A8A
         ldy  #$02                 ; 0A8C
         ldx  #$00                 ; 0A8E
L0A90
         lda  (PTR2,x)             ; 0A90
         beq  L0ABF                ; 0A92
         bpl  L0AD3                ; 0A94
         cmp  #$B1                 ; 0A96
         bcc  L0A9E                ; 0A98
         cmp  #$BA                 ; 0A9A
         bcc  L0AC0                ; 0A9C
L0A9E
         cmp  #$A0                 ; 0A9E
         beq  L0ABC                ; 0AA0
         and  #$7F                 ; 0AA2
         beq  L0ABF                ; 0AA4
         cmp  #$14                 ; 0AA6
         bne  L0AB4                ; 0AA8
         lda  HLP_INV              ; 0AAA
         eor  #$80                 ; 0AAD
         sta  HLP_INV              ; 0AAF
         bcs  L0ABC                ; 0AB2
L0AB4
         jsr  ATA2SCR              ; 0AB4
         ora  HLP_INV              ; 0AB7
         sta  (PTR1),y             ; 0ABA
L0ABC
         jmp  HLP_INCTXT           ; 0ABC
L0ABF
         rts                       ; 0ABF
L0AC0
         sec                       ; 0AC0
         sbc  #$B1                 ; 0AC1
         tax                       ; 0AC3
         lda  #$00                 ; 0AC4
L0AC6
         ora  HLP_INV              ; 0AC6
         sta  (PTR1),y             ; 0AC9
         iny                       ; 0ACB
         dex                       ; 0ACC
         bpl  L0AC6                ; 0ACD
         ldx  #$00                 ; 0ACF
         beq  L0AEC                ; 0AD1
L0AD3
         cmp  #$29                 ; 0AD3
         beq  L0AEC                ; 0AD5
         cmp  #$28                 ; 0AD7
         beq  L0AF2                ; 0AD9
         cmp  #$2F                 ; 0ADB
         beq  L0B02                ; 0ADD
         cmp  #$14                 ; 0ADF
         beq  L0B0B                ; 0AE1
         jsr  ATA2SCR              ; 0AE3
         ora  HLP_INV              ; 0AE6
         sta  (PTR1),y             ; 0AE9
         iny                       ; 0AEB
L0AEC
         jsr  HLP_INCTXT           ; 0AEC
         jmp  L0A90                ; 0AEF
L0AF2
         lda  HLP_TAPE             ; 0AF2
         bmi  L0AEC                ; 0AF5
         lda  #$2F                 ; 0AF7
L0AF9
         jsr  HLP_INCTXT           ; 0AF9
         cmp  (PTR2,x)             ; 0AFC
         bne  L0AF9                ; 0AFE
         beq  L0AEC                ; 0B00
L0B02
         lda  HLP_TAPE             ; 0B02
         bpl  L0AEC                ; 0B05
         lda  #$29                 ; 0B07
         bne  L0AF9                ; 0B09
L0B0B
         lda  HLP_INV              ; 0B0B
         eor  #$80                 ; 0B0E
         sta  HLP_INV              ; 0B10
         jmp  L0AEC                ; 0B13

* help: copy the help screen buffer ------------------------
HLP_COPY
         jsr  HLP_PTRSCR           ; 0B16
         jsr  HLP_WAIT             ; 0B19
         ldy  #$00                 ; 0B1C
L0B1E
         lda  (PTR2),y             ; 0B1E
         sta  (PTR1),y             ; 0B20
         iny                       ; 0B22
         bne  L0B1E                ; 0B23
         inc  PTR1+1               ; 0B25
         inc  PTR2+1               ; 0B27
L0B29
         lda  (PTR2),y             ; 0B29
         sta  (PTR1),y             ; 0B2B
         iny                       ; 0B2D
         bne  L0B29                ; 0B2E
         inc  PTR1+1               ; 0B30
         inc  PTR2+1               ; 0B32
L0B34
         lda  (PTR2),y             ; 0B34
         sta  (PTR1),y             ; 0B36
         iny                       ; 0B38
         bpl  L0B34                ; 0B39
         rts                       ; 0B3B

* help: previous page (only if not at the start: left arrow in HLP_ARROWS) ---
HLP_PREV
         lda  HLP_ARROWS           ; 0B3C
         bne  L0B42                ; 0B3F
         rts                       ; 0B41
L0B42
         jsr  CLICK                ; 0B42
         jsr  HLP_PTRTXT           ; 0B45
L0B48
         dec  PTR2+1               ; 0B48
         ldy  #$FF                 ; 0B4A
L0B4C
         lda  (PTR2),y             ; 0B4C
         and  #$7F                 ; 0B4E
         beq  L0B5B                ; 0B50
         dey                       ; 0B52
         bne  L0B4C                ; 0B53
         lda  (PTR2),y             ; 0B55
         and  #$7F                 ; 0B57
         bne  L0B48                ; 0B59
L0B5B
         lda  #$D0                 ; 0B5B
         ldx  #$0B                 ; 0B5D
         jmp  L0B81                ; 0B5F

* help: next page (only if more text: right arrow in HLP_ARROWS+1) ---
HLP_NEXT
         lda  HLP_ARROWS+1         ; 0B62
         bne  L0B68                ; 0B65
         rts                       ; 0B67
L0B68
         jsr  CLICK                ; 0B68
         jsr  HLP_PTRTXT           ; 0B6B
         ldy  #$01                 ; 0B6E
L0B70
         lda  (PTR2),y             ; 0B70
         and  #$7F                 ; 0B72
         beq  L0B7D                ; 0B74
         iny                       ; 0B76
         bne  L0B70                ; 0B77
         inc  PTR2+1               ; 0B79
         bne  L0B70                ; 0B7B
L0B7D
         lda  #$F7                 ; 0B7D
         ldx  #$0B                 ; 0B7F
L0B81
         sta  HLP_STEP             ; 0B81
         stx  HLP_STEP+1           ; 0B84
         clc                       ; 0B87
         tya                       ; 0B88
         adc  PTR2                 ; 0B89
         sta  HLP_TOP              ; 0B8B
         lda  #$00                 ; 0B8E
         adc  PTR2+1               ; 0B90
         sta  HLP_TOP+1            ; 0B92
         jsr  HLP_PAGE             ; 0B95
         lda  #$26                 ; 0B98
         sta  TMP3                 ; 0B9A
         lda  #$01                 ; 0B9C
         sta  TMP4                 ; 0B9E
L0BA0
         jsr  HLP_PTRSCR           ; 0BA0
         lda  #$60                 ; 0BA3
L0BA5
         cmp  VCOUNT               ; 0BA5
         bne  L0BA5                ; 0BA8
         jsr  HLP_CLRBUF           ; 0BAA
         ldx  #$10                 ; 0BAD
L0BAF
         txa                       ; 0BAF
         pha                       ; 0BB0

* help: scroll animation -----------------------------------
HLP_SCROLL
HLP_STEP         equ *+1                              ; 0BB2 line step of the scroll: HLP_STEP_R (previous page) / HLP_STEP_L (next page)
         jsr  HLP_SCROLL           ; 0BB1
         jsr  HLP_NEXTLN           ; 0BB4
         jsr  HLP_NEXTSRC          ; 0BB7
         pla                       ; 0BBA
         tax                       ; 0BBB
         dex                       ; 0BBC
         bne  L0BAF                ; 0BBD
         inc  TMP4                 ; 0BBF
         dec  TMP3                 ; 0BC1
         bne  L0BA0                ; 0BC3

* help: clear the line buffer HLP_LINEBUF ------------------
HLP_CLRBUF
         ldy  #$26                 ; 0BC5
         lda  #$00                 ; 0BC7
L0BC9
         sta  HLP_LINEBUF,y        ; 0BC9
         dey                       ; 0BCC
         bne  L0BC9                ; 0BCD
         rts                       ; 0BCF

* help scroll step back: the new page slides in from the right over the old one, from column TMP3 ---
HLP_STEP_R
         lda  PTR2                 ; 0BD0
         sta  HLP_SRC              ; 0BD2
         lda  PTR2+1               ; 0BD5
         sta  HLP_SRC+1            ; 0BD7
         ldx  #$01                 ; 0BDA
         ldy  TMP3                 ; 0BDC
L0BDE
HLP_SRC          equ *+1                              ; 0BDF source line of HLP_STEP_R
         lda  L0BDE,x              ; 0BDE
         sta  (PTR1),y             ; 0BE1
         inx                       ; 0BE3
         iny                       ; 0BE4
         cpy  #$27                 ; 0BE5
         bcc  L0BDE                ; 0BE7
         lda  #$1C                 ; 0BE9
         ldy  TMP3                 ; 0BEB
         cpy  #$02                 ; 0BED
         bcc  L0BF6                ; 0BEF
         sta  (PTR1),y             ; 0BF1
         sta  HLP_LINEBUF,y        ; 0BF3
L0BF6
         rts                       ; 0BF6

* help scroll step forward: the old page moves right, the new one shows from the left up to column TMP4 ---
HLP_STEP_L
         ldy  #$26                 ; 0BF7
L0BF9
         cpy  TMP4                 ; 0BF9
         beq  L0C06                ; 0BFB
         dey                       ; 0BFD
         lda  (PTR1),y             ; 0BFE
         iny                       ; 0C00
         sta  (PTR1),y             ; 0C01
         dey                       ; 0C03
         bpl  L0BF9                ; 0C04
L0C06
         lda  (PTR2),y             ; 0C06
         sta  (PTR1),y             ; 0C08
         dey                       ; 0C0A
         bne  L0C06                ; 0C0B
         lda  #$1C                 ; 0C0D
         ldy  TMP4                 ; 0C0F
         iny                       ; 0C11
         cpy  #$27                 ; 0C12
         bcs  L0C1B                ; 0C14
         sta  (PTR1),y             ; 0C16
         sta  HLP_LINEBUF,y        ; 0C18
L0C1B
         rts                       ; 0C1B

* help: pointers to the screen buffers ---------------------
HLP_PTRSCR
         lda  #$80                 ; 0C1C
         sta  PTR2                 ; 0C1E
         lda  #$B8                 ; 0C20
         sta  PTR2+1               ; 0C22
         lda  #$00                 ; 0C24
         sta  PTR1                 ; 0C26
         lda  #$B6                 ; 0C28
         sta  PTR1+1               ; 0C2A
         rts                       ; 0C2C

* help: pointers to the screen and the text position -------
HLP_PTRTXT
         lda  #$80                 ; 0C2D
         sta  PTR1                 ; 0C2F
         lda  #$B8                 ; 0C31
         sta  PTR1+1               ; 0C33
         lda  HLP_TOP              ; 0C35
         sta  PTR2                 ; 0C38
         lda  HLP_TOP+1            ; 0C3A
         sta  PTR2+1               ; 0C3D
         rts                       ; 0C3F

* help: wait for the next frame ----------------------------
HLP_WAIT
         lda  RTCLOK+2             ; 0C40
L0C42
         cmp  RTCLOK+2             ; 0C42
         beq  L0C42                ; 0C44
         rts                       ; 0C46

* help: advance the text pointer ---------------------------
HLP_INCTXT
         inc  PTR2                 ; 0C47
         bne  L0C4D                ; 0C49
         inc  PTR2+1               ; 0C4B
L0C4D
         rts                       ; 0C4D

* help: advance the screen pointer - not called ------------
HLP_INCSCR
         inc  PTR1                 ; 0C4E
         bne  L0C54                ; 0C50
         inc  PTR1+1               ; 0C52
L0C54
         rts                       ; 0C54

* help: next screen line (+40) -----------------------------
HLP_NEXTLN
         clc                       ; 0C55
         lda  #$28                 ; 0C56
         adc  PTR1                 ; 0C58
         sta  PTR1                 ; 0C5A
         bcc  L0C60                ; 0C5C
         inc  PTR1+1               ; 0C5E
L0C60
         rts                       ; 0C60

* help: next source line (+40) -----------------------------
HLP_NEXTSRC
         clc                       ; 0C61
         lda  #$28                 ; 0C62
         adc  PTR2                 ; 0C64
         sta  PTR2                 ; 0C66
         bcc  L0C6C                ; 0C68
         inc  PTR2+1               ; 0C6A
L0C6C
         rts                       ; 0C6C
