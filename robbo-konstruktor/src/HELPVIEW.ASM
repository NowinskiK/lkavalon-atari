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
;    ··: zmiana strony,    strzał: menu
         dta d'   ',$5E,$5F,d': zmiana strony,    strza]: menu   ' ; 0906

* frame lines around the help page (frame characters of the font) ---
         dta $00,$1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D ; 092E
         dta $1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D ; 093E
         dta $1D,$1D,$1D,$1D,$1D,$1D,$1D,$00,$1B,$00,$00,$00,$00,$00,$00,$00 ; 094E
         dta $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 095E
         dta $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$1C ; 096E
         dta $00,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E ; 097E
         dta $1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E ; 098E
         dta $1E,$1E,$1E,$1E,$1E,$1E,$1E,$00          ; 099E
HELP_
         sta  $0C75                ; 09A6
         ldx  #$07                 ; 09A9
L09AB
         lda  $B0,x                ; 09AB
         sta  $0C6D,x              ; 09AD
         dex                       ; 09B0
         bpl  L09AB                ; 09B1
         lda  #$80                 ; 09B3
         bne  L09BD                ; 09B5
         jsr  CLICK                ; 09B7
         jsr  ED_DLIST             ; 09BA
L09BD
         asl  $09B4                ; 09BD
         lda  #$79                 ; 09C0
         sta  $B2                  ; 09C2
         lda  #$0C                 ; 09C4
         sta  $B3                  ; 09C6
         ldy  #$00                 ; 09C8
L09CA
         lda  ($B2),y              ; 09CA
         and  #$7F                 ; 09CC
         beq  L09D7                ; 09CE
         iny                       ; 09D0
         bne  L09CA                ; 09D1
         inc  $B3                  ; 09D3
         bne  L09CA                ; 09D5
L09D7
         clc                       ; 09D7
         tya                       ; 09D8
         adc  $B2                  ; 09D9
         sta  $B2                  ; 09DB
         bcc  L09E1                ; 09DD
         inc  $B3                  ; 09DF
L09E1
         ldy  #$01                 ; 09E1
         lda  ($B2),y              ; 09E3
         beq  L09F5                ; 09E5
         cmp  HELP_PAGE            ; 09E7
         bne  L09CA                ; 09E9
         lda  $B2                  ; 09EB
         sta  $0C77                ; 09ED
         lda  $B3                  ; 09F0
         sta  $0C78                ; 09F2
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
         lda  $0C6D,x              ; 0A36
         sta  $B0,x                ; 0A39
         dex                       ; 0A3B
         bpl  L0A36                ; 0A3C
         rts                       ; 0A3E

* help: draw one page (16 lines) from the text pointer $0C77 ---
HLP_PAGE
         ldx  #$5E                 ; 0A3F
         stx  $0909                ; 0A41
         inx                       ; 0A44
         stx  $090A                ; 0A45
         jsr  HLP_PTRTXT           ; 0A48
         ldx  #$00                 ; 0A4B
         stx  $0C76                ; 0A4D
         lda  ($B2,x)              ; 0A50
         cmp  #$80                 ; 0A52
         bne  L0A59                ; 0A54
         stx  $0909                ; 0A56
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
         lda  ($B2,x)              ; 0A70
         cmp  #$80                 ; 0A72
         bne  L0A79                ; 0A74
         stx  $090A                ; 0A76
L0A79
         rts                       ; 0A79

* help: format one line - frame characters, $14 toggles inverse, inverse digits = indentation ---
HLP_LINE
         ldy  #$27                 ; 0A7A
         lda  #$1C                 ; 0A7C
         sta  ($B0),y              ; 0A7E
         dey                       ; 0A80
         lda  #$00                 ; 0A81
L0A83
         sta  ($B0),y              ; 0A83
         dey                       ; 0A85
         bne  L0A83                ; 0A86
         lda  #$1B                 ; 0A88
         sta  ($B0),y              ; 0A8A
         ldy  #$02                 ; 0A8C
         ldx  #$00                 ; 0A8E
L0A90
         lda  ($B2,x)              ; 0A90
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
         lda  $0C76                ; 0AAA
         eor  #$80                 ; 0AAD
         sta  $0C76                ; 0AAF
         bcs  L0ABC                ; 0AB2
L0AB4
         jsr  ATA2SCR              ; 0AB4
         ora  $0C76                ; 0AB7
         sta  ($B0),y              ; 0ABA
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
         ora  $0C76                ; 0AC6
         sta  ($B0),y              ; 0AC9
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
         ora  $0C76                ; 0AE6
         sta  ($B0),y              ; 0AE9
         iny                       ; 0AEB
L0AEC
         jsr  HLP_INCTXT           ; 0AEC
         jmp  L0A90                ; 0AEF
L0AF2
         lda  $0C75                ; 0AF2
         bmi  L0AEC                ; 0AF5
         lda  #$2F                 ; 0AF7
L0AF9
         jsr  HLP_INCTXT           ; 0AF9
         cmp  ($B2,x)              ; 0AFC
         bne  L0AF9                ; 0AFE
         beq  L0AEC                ; 0B00
L0B02
         lda  $0C75                ; 0B02
         bpl  L0AEC                ; 0B05
         lda  #$29                 ; 0B07
         bne  L0AF9                ; 0B09
L0B0B
         lda  $0C76                ; 0B0B
         eor  #$80                 ; 0B0E
         sta  $0C76                ; 0B10
         jmp  L0AEC                ; 0B13

* help: copy the help screen buffer ------------------------
HLP_COPY
         jsr  HLP_PTRSCR           ; 0B16
         jsr  HLP_WAIT             ; 0B19
         ldy  #$00                 ; 0B1C
L0B1E
         lda  ($B2),y              ; 0B1E
         sta  ($B0),y              ; 0B20
         iny                       ; 0B22
         bne  L0B1E                ; 0B23
         inc  $B1                  ; 0B25
         inc  $B3                  ; 0B27
L0B29
         lda  ($B2),y              ; 0B29
         sta  ($B0),y              ; 0B2B
         iny                       ; 0B2D
         bne  L0B29                ; 0B2E
         inc  $B1                  ; 0B30
         inc  $B3                  ; 0B32
L0B34
         lda  ($B2),y              ; 0B34
         sta  ($B0),y              ; 0B36
         iny                       ; 0B38
         bpl  L0B34                ; 0B39
         rts                       ; 0B3B

* help: previous page (only if not at the start, marker $0909) ---
HLP_PREV
         lda  $0909                ; 0B3C
         bne  L0B42                ; 0B3F
         rts                       ; 0B41
L0B42
         jsr  CLICK                ; 0B42
         jsr  HLP_PTRTXT           ; 0B45
L0B48
         dec  $B3                  ; 0B48
         ldy  #$FF                 ; 0B4A
L0B4C
         lda  ($B2),y              ; 0B4C
         and  #$7F                 ; 0B4E
         beq  L0B5B                ; 0B50
         dey                       ; 0B52
         bne  L0B4C                ; 0B53
         lda  ($B2),y              ; 0B55
         and  #$7F                 ; 0B57
         bne  L0B48                ; 0B59
L0B5B
         lda  #$D0                 ; 0B5B
         ldx  #$0B                 ; 0B5D
         jmp  L0B81                ; 0B5F

* help: next page (only if more text, marker $090A) --------
HLP_NEXT
         lda  $090A                ; 0B62
         bne  L0B68                ; 0B65
         rts                       ; 0B67
L0B68
         jsr  CLICK                ; 0B68
         jsr  HLP_PTRTXT           ; 0B6B
         ldy  #$01                 ; 0B6E
L0B70
         lda  ($B2),y              ; 0B70
         and  #$7F                 ; 0B72
         beq  L0B7D                ; 0B74
         iny                       ; 0B76
         bne  L0B70                ; 0B77
         inc  $B3                  ; 0B79
         bne  L0B70                ; 0B7B
L0B7D
         lda  #$F7                 ; 0B7D
         ldx  #$0B                 ; 0B7F
L0B81
         sta  $0BB2                ; 0B81
         stx  $0BB3                ; 0B84
         clc                       ; 0B87
         tya                       ; 0B88
         adc  $B2                  ; 0B89
         sta  $0C77                ; 0B8B
         lda  #$00                 ; 0B8E
         adc  $B3                  ; 0B90
         sta  $0C78                ; 0B92
         jsr  HLP_PAGE             ; 0B95
         lda  #$26                 ; 0B98
         sta  $B6                  ; 0B9A
         lda  #$01                 ; 0B9C
         sta  $B7                  ; 0B9E
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
         jsr  HLP_SCROLL           ; 0BB1
         jsr  HLP_NEXTLN           ; 0BB4
         jsr  HLP_NEXTSRC          ; 0BB7
         pla                       ; 0BBA
         tax                       ; 0BBB
         dex                       ; 0BBC
         bne  L0BAF                ; 0BBD
         inc  $B7                  ; 0BBF
         dec  $B6                  ; 0BC1
         bne  L0BA0                ; 0BC3

* help: clear the line buffer $0956 ------------------------
HLP_CLRBUF
         ldy  #$26                 ; 0BC5
         lda  #$00                 ; 0BC7
L0BC9
         sta  $0956,y              ; 0BC9
         dey                       ; 0BCC
         bne  L0BC9                ; 0BCD
         rts                       ; 0BCF
         dta $A5,$B2,$8D,$DF,$0B,$A5,$B3,$8D,$E0,$0B,$A2,$01,$A4,$B6,$BD,$DE ; 0BD0
         dta $0B,$91,$B0,$E8,$C8,$C0,$27,$90,$F5,$A9,$1C,$A4,$B6,$C0,$02,$90 ; 0BE0
         dta $05,$91,$B0,$99,$56,$09,$60,$A0,$26,$C4,$B7,$F0,$09,$88,$B1,$B0 ; 0BF0
         dta $C8,$91,$B0,$88,$10,$F3,$B1,$B2,$91,$B0,$88,$D0,$F9,$A9,$1C,$A4 ; 0C00
         dta $B7,$C8,$C0,$27,$B0,$05,$91,$B0,$99,$56,$09,$60 ; 0C10

* help: pointers to the screen buffers ---------------------
HLP_PTRSCR
         lda  #$80                 ; 0C1C
         sta  $B2                  ; 0C1E
         lda  #$B8                 ; 0C20
         sta  $B3                  ; 0C22
         lda  #$00                 ; 0C24
         sta  $B0                  ; 0C26
         lda  #$B6                 ; 0C28
         sta  $B1                  ; 0C2A
         rts                       ; 0C2C

* help: pointers to the screen and the text position -------
HLP_PTRTXT
         lda  #$80                 ; 0C2D
         sta  $B0                  ; 0C2F
         lda  #$B8                 ; 0C31
         sta  $B1                  ; 0C33
         lda  $0C77                ; 0C35
         sta  $B2                  ; 0C38
         lda  $0C78                ; 0C3A
         sta  $B3                  ; 0C3D
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
         inc  $B2                  ; 0C47
         bne  L0C4D                ; 0C49
         inc  $B3                  ; 0C4B
L0C4D
         rts                       ; 0C4D
         dta $E6,$B0,$D0,$02,$E6,$B1,$60              ; 0C4E

* help: next screen line (+40) -----------------------------
HLP_NEXTLN
         clc                       ; 0C55
         lda  #$28                 ; 0C56
         adc  $B0                  ; 0C58
         sta  $B0                  ; 0C5A
         bcc  L0C60                ; 0C5C
         inc  $B1                  ; 0C5E
L0C60
         rts                       ; 0C60

* help: next source line (+40) -----------------------------
HLP_NEXTSRC
         clc                       ; 0C61
         lda  #$28                 ; 0C62
         adc  $B2                  ; 0C64
         sta  $B2                  ; 0C66
         bcc  L0C6C                ; 0C68
         inc  $B3                  ; 0C6A
L0C6C
         rts                       ; 0C6C
