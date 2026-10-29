; ENGINE1.ASM - game engine: jump table $1E00, display list, info-line texts, DLIs, main loop (Robbo R1 reworked)
; $1E00-$23FC

         org $1E00


* engine set-up: screen, display list $1E0F, DLI $1EDE, font $3C00, score / keys / ammunition cleared ---
ENGINE_INIT
         jmp  ENGINE_INIT_         ; 1E00

* play a planet: A = data page ($50 + 2n), X = number shown, Y = lives, carry = demo; own VBI, returns to the editor ---
ENGINE_PLAY
         stx  $1E0B                ; 1E03
         tsx                       ; 1E06
         stx  $3331                ; 1E07
         ldx  #$0A                 ; 1E0A
         jmp  ENGINE_PLAY_         ; 1E0C
         dta $70,$70,$F0,$64,$00,$B6,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24 ; 1E0F
         dta $24,$24,$24,$24,$24,$24,$24,$24,$A4,$04,$50,$42,$3E,$1E,$02,$01 ; 1E1F
         dta $2F,$1E,$42,$8E,$1E,$01,$35,$1E,$80,$42,$B6,$1E,$41,$0F,$1E,$00 ; 1E2F
         dta $00,$00,$00,$00,$00,$00,$00,$00,$00,$4D,$4E,$00,$00,$00,$00,$49 ; 1E3F
         dta $4A,$00,$00,$00,$00,$55,$56,$00,$00,$00,$00,$51,$52,$00,$00,$00 ; 1E4F
         dta $00,$45,$46,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 1E5F
         dta $00,$4F,$50,$00,$00,$00,$00,$4B,$4C,$00,$00,$00,$00,$57,$58,$00 ; 1E6F
         dta $00,$00,$00,$53,$54,$00,$00,$00,$00,$47,$48,$00,$00,$00,$00 ; 1E7F
;   BREAK:  powrót do Robbo Konstruktora
         dta d'  BREAK:  powr_t do Robbo Konstruktora  ' ; 1E8E
; Wciśnięcie strzału przerywa demonstrację
         dta d'Wci{ni\cie strza]u przerywa demonstracj\' ; 1EB6

* DLI 1 (Robbo DLI1): players to the planet colour PCOLR3, chains to DLI2 ---
DLI1
         pha                       ; 1EDE
         lda  $02C3                ; 1EDF
         sta  WSYNC                ; 1EE2
         sta  COLPM0               ; 1EE5
         sta  $D013                ; 1EE8
         sta  $D014                ; 1EEB
         sta  $D015                ; 1EEE
         lda  #$FD                 ; 1EF1
         sta  VDSLST               ; 1EF3
         lda  #$1E                 ; 1EF6
         sta  VDSLST+1             ; 1EF8
         pla                       ; 1EFB
         rti                       ; 1EFC

* DLI 2 (Robbo DLI2): info line at VCOUNT $60 - font $4C00, colours from COLOR4, chains to DLI3 ---
DLI2
         pha                       ; 1EFD
         cld                       ; 1EFE
         lda  #$60                 ; 1EFF
L1F01
         cmp  VCOUNT               ; 1F01
         bne  L1F01                ; 1F04
         lda  #$20                 ; 1F06
         sta  DMACTL               ; 1F08
         lda  COLOR4               ; 1F0B
         sta  COLPM0               ; 1F0E
         sta  $D013                ; 1F11
         sta  $D014                ; 1F14
         sta  $D015                ; 1F17
         sta  COLPF2               ; 1F1A
         clc                       ; 1F1D
         adc  #$0A                 ; 1F1E
         sta  COLPF1               ; 1F20
         sta  WSYNC                ; 1F23
         lda  #$4C                 ; 1F26
         sta  CHBASE               ; 1F28
         lda  #$22                 ; 1F2B
         sta  DMACTL               ; 1F2D
         lda  #$3C                 ; 1F30
         sta  VDSLST               ; 1F32
         lda  #$1F                 ; 1F35
         sta  VDSLST+1             ; 1F37
         pla                       ; 1F3A
         rti                       ; 1F3B

* DLI 3 (Robbo DLI, 3rd case): info text colour cycles with RTCLOK ---
DLI3
         pha                       ; 1F3C
         lda  RTCLOK+2             ; 1F3D
         lsr                       ; 1F3F
         lsr                       ; 1F40
         sta  COLPF1               ; 1F41
         pla                       ; 1F44
         rti                       ; 1F45

* ENGINE_INIT: clear score / keys / ammunition, board row tables $23FD/$241D (board $BE00), display list, DLI1 ---
ENGINE_INIT_
         jsr  HALT                 ; 1F46
         lda  #$00                 ; 1F49
         sta  SDMCTL               ; 1F4B
         sta  DMACTL               ; 1F4E
         sta  VSF                  ; 1F51
         sta  $D405                ; 1F53
         sta  SCOR                 ; 1F56
         sta  SCOR+1               ; 1F58
         sta  SCOR+2               ; 1F5A
         sta  KEYS                 ; 1F5C
         sta  NABO                 ; 1F5E
         sta  RUCH                 ; 1F60
         sta  RUCH                 ; 1F62
         lda  #$FF                 ; 1F64
         sta  LSTE                 ; 1F66
         sta  $11                  ; 1F68
         lda  #$00                 ; 1F6A
         sta  $1E13                ; 1F6C
         sta  FADR                 ; 1F6F
         sta  $2491                ; 1F71
         lda  #$B6                 ; 1F74
         sta  $1E14                ; 1F76
         sta  FADR+1               ; 1F79
         sta  $2495                ; 1F7B
         lda  #$00                 ; 1F7E
         sta  ADDR                 ; 1F80
         lda  #$BE                 ; 1F82
         sta  ADDR+1               ; 1F84
         ldx  #$00                 ; 1F86
L1F88
         lda  ADDR                 ; 1F88
         sta  $23FD,x              ; 1F8A
         lda  ADDR+1               ; 1F8D
         sta  $241D,x              ; 1F8F
         clc                       ; 1F92
         lda  ADDR                 ; 1F93
         adc  #$10                 ; 1F95
         sta  ADDR                 ; 1F97
         bcc  L1F9D                ; 1F99
         inc  ADDR+1               ; 1F9B
L1F9D
         inx                       ; 1F9D
         cpx  #$20                 ; 1F9E
         bcc  L1F88                ; 1FA0
         lda  #$3C                 ; 1FA2
         sta  CHBAS                ; 1FA4
         lda  #$0F                 ; 1FA7
         sta  SDLSTL               ; 1FA9
         lda  #$1E                 ; 1FAC
         sta  SDLSTH               ; 1FAE
         jsr  HALT                 ; 1FB1
         lda  #$DE                 ; 1FB4
         sta  VDSLST               ; 1FB6
         lda  #$1E                 ; 1FB9
         sta  VDSLST+1             ; 1FBB
         lda  #$C0                 ; 1FBE
         sta  NMIEN                ; 1FC0
         lda  #$FF                 ; 1FC3
         jmp  SOUND_               ; 1FC5

* ENGINE_PLAY: own VBI (CVBL), clear the board, then the play loop (Robbo PCLO); a lost life restarts the planet ---
ENGINE_PLAY_
         sta  CNUM                 ; 1FC8
         stx  PNUM                 ; 1FCA
         lda  #$00                 ; 1FCC
         bcc  L1FD2                ; 1FCE
         lda  #$80                 ; 1FD0
L1FD2
         sta  DEMO                 ; 1FD2
         sty  $207D                ; 1FD4
         cpy  #$FF                 ; 1FD7
         bne  L1FDC                ; 1FD9
         iny                       ; 1FDB
L1FDC
         sty  LIVS                 ; 1FDC
         lda  VVBLKD               ; 1FDE
         sta  $3332                ; 1FE1
         lda  VVBLKD+1             ; 1FE4
         sta  $3333                ; 1FE7
         ldy  #$54                 ; 1FEA
         ldx  #$2F                 ; 1FEC
         lda  #$07                 ; 1FEE
         jsr  SETVBV               ; 1FF0
         lda  #$13                 ; 1FF3
         ldy  #$00                 ; 1FF5
L1FF7
         sta  $BE00,y              ; 1FF7
         sta  $BF00,y              ; 1FFA
         dey                       ; 1FFD
         bne  L1FF7                ; 1FFE
         jsr  CHNMON               ; 2000
L2003
         jsr  PLA1                 ; 2003
         jsr  ENTCV                ; 2006
         lda  #$00                 ; 2009
         sta  ESC_KEY              ; 200B
L200E
         lsr  $4D                  ; 200E
         lda  #$00                 ; 2010
         sta  FAC                  ; 2012
         jsr  CHNGCV               ; 2014
         lda  DEMO                 ; 2017
         beq  L2057                ; 2019
         lda  FIRE                 ; 201B
         beq  L2027                ; 201E
         lda  $021F                ; 2020
         bne  L205C                ; 2023
         beq  L2062                ; 2025
L2027
         ldx  #$10                 ; 2027
         jsr  WAIT                 ; 2029

* leave the game (BREAK or the end): Y = $99, back to the caller of ENGINE_PLAY ---
PLAY_ABORT
         ldx  $3331                ; 202C
         txs                       ; 202F
         ldy  #$99                 ; 2030
         ldx  PNUM                 ; 2032

* restore the caller's VBI, silence, players off; return X = planet number, Y = lives ---
PLAY_EXIT
         txa                       ; 2034
         pha                       ; 2035
         tya                       ; 2036
         pha                       ; 2037
         ldy  $3332                ; 2038
         ldx  $3333                ; 203B
         lda  #$07                 ; 203E
         jsr  SETVBV               ; 2040
         lda  #$FF                 ; 2043
         jsr  SOUND_               ; 2045
         ldx  #$03                 ; 2048
         lda  #$00                 ; 204A
L204C
         sta  HPOSP0,x             ; 204C
         dex                       ; 204F
         bpl  L204C                ; 2050
         pla                       ; 2052
         tay                       ; 2053
         pla                       ; 2054
         tax                       ; 2055
         rts                       ; 2056
L2057
         lda  ESC_KEY              ; 2057
         bne  L206C                ; 205A
L205C
         lda  FAC                  ; 205C
         bmi  NXCV                 ; 205E
         bne  L200E                ; 2060
L2062
         lda  #$00                 ; 2062
         sta  RUCH                 ; 2064
         sta  $021F                ; 2066
         jsr  WHIL                 ; 2069
L206C
         jsr  WYBC                 ; 206C
         lda  DEMO                 ; 206F
         bne  NXCV                 ; 2071
         sed                       ; 2073
         sec                       ; 2074
         lda  LIVS                 ; 2075
         sbc  #$01                 ; 2077
         sta  LIVS                 ; 2079
         cld                       ; 207B
         ldx  #$00                 ; 207C
         inx                       ; 207E
         beq  L2083                ; 207F
         bcs  L2003                ; 2081
L2083
         lda  #$00                 ; 2083
         sta  LIVS                 ; 2085
         ldy  #$99                 ; 2087
         bne  L208D                ; 2089
L208B
         ldy  LIVS                 ; 208B
L208D
         ldx  PNUM                 ; 208D
         jmp  PLAY_EXIT            ; 208F

* next cave (Robbo: "nxtcv") -------------------------------
NXCV
         lda  #$0F                 ; 2092
         sta  X                    ; 2094
L2096
         lda  #$00                 ; 2096
         sta  RUCH                 ; 2098
         lda  #$1F                 ; 209A
         sta  Y                    ; 209C
L209E
         lda  #$13                 ; 209E
         jsr  PUT_                 ; 20A0
         dec  Y                    ; 20A3
         bpl  L209E                ; 20A5
         jsr  CHNMON               ; 20A7
         lda  X                    ; 20AA
         and  #$03                 ; 20AC
         bne  L20B3                ; 20AE
         inc  CNTR                 ; 20B0
L20B3
         jsr  HALT                 ; 20B3
         dec  X                    ; 20B6
         bpl  L2096                ; 20B8
         inc  PNUM                 ; 20BA
         sec                       ; 20BC
         lda  DEMO                 ; 20BD
         bne  L208B                ; 20BF
         clc                       ; 20C1
         bcc  L208B                ; 20C2

* Robbo destroyed - the planet explodes (Robbo: "wybu komnate"): every cell except walls / empty becomes an explosion ---
WYBC
         lda  #$00                 ; 20C4
         sta  RUCH                 ; 20C6
         jsr  SOUND_               ; 20C8
         lda  #$1E                 ; 20CB
         sta  Y                    ; 20CD
L20CF
         lda  #$0F                 ; 20CF
         sta  X                    ; 20D1
L20D3
         jsr  TST_                 ; 20D3
         cmp  #$20                 ; 20D6
         beq  L20F4                ; 20D8
         cmp  #$00                 ; 20DA
         beq  L20F4                ; 20DC
         cmp  #$13                 ; 20DE
         beq  L20F4                ; 20E0
         cmp  #$11                 ; 20E2
         beq  L20F4                ; 20E4
         cmp  #$05                 ; 20E6
         beq  L20F4                ; 20E8
         clc                       ; 20EA
         lda  RANDOM               ; 20EB
         and  #$03                 ; 20EE
         adc  #$61                 ; 20F0
         sta  (ADDR),y             ; 20F2
L20F4
         dec  X                    ; 20F4
         bpl  L20D3                ; 20F6
         dec  Y                    ; 20F8
         bpl  L20CF                ; 20FA

* run the board for $30 frames (Robbo WHIL) ----------------
WHIL
         lda  #$30                 ; 20FC
         sta  $021E                ; 20FE
L2101
         jsr  CHNGCV               ; 2101
         lda  $021E                ; 2104
         bne  L2101                ; 2107
         rts                       ; 2109
CNTR             dta $00                              ; 210A animation counter (Robbo CNTR)

* one turn of the board (Robbo: "chng cave"): call the behaviour of each cell from table $31EF, next animation phase ---
CHNGCV
         inc  CNTR                 ; 210B
         jsr  TFAC                 ; 210E
         ldy  #$00                 ; 2111
         sty  Y1                   ; 2113
L2115
         ldx  #$00                 ; 2115
         stx  X1                   ; 2117
L2119
         lda  Y1                   ; 2119
         sta  Y                    ; 211B
         lda  X1                   ; 211D
         sta  X                    ; 211F
         ldy  Y                    ; 2121
         ora  $23FD,y              ; 2123
         sta  ADDR                 ; 2126
         lda  $241D,y              ; 2128
         sta  ADDR+1               ; 212B
         ldy  #$00                 ; 212D
         lda  (ADDR),y             ; 212F
         tay                       ; 2131
         asl                       ; 2132
         bcs  L216B                ; 2133
         cpy  #$61                 ; 2135
         bcs  L2175                ; 2137
         tay                       ; 2139
         lda  $31EF,y              ; 213A
         ldx  $31F0,y              ; 213D
         beq  L214B                ; 2140
         sta  $2149                ; 2142
         stx  $214A                ; 2145
         jsr  $2148                ; 2148
L214B
         inc  X1                   ; 214B
         lda  X1                   ; 214D
         cmp  #$10                 ; 214F
         bcc  L2119                ; 2151
         inc  Y1                   ; 2153
         lda  Y1                   ; 2155
         cmp  #$1F                 ; 2157
         bcc  L2115                ; 2159
         jsr  TFAC                 ; 215B
L215E
         lda  CDTMV3               ; 215E
         bne  L215E                ; 2161
         lda  #$07                 ; 2163
         sta  CDTMV3               ; 2165
         jmp  CHNMON               ; 2168
L216B
         tya                       ; 216B
         and  #$7F                 ; 216C
         ldy  #$00                 ; 216E
         sta  (ADDR),y             ; 2170
         jmp  L214B                ; 2172
L2175
         cpy  #$7B                 ; 2175
         bcs  L214B                ; 2177
         tya                       ; 2179
         cmp  #$69                 ; 217A
         bcc  L2189                ; 217C
         cmp  #$6E                 ; 217E
         bcs  L2189                ; 2180
         ldy  #$00                 ; 2182
         sty  TELE                 ; 2184
         iny                       ; 2186
         sty  FAC                  ; 2187
L2189
         sec                       ; 2189
         sbc  #$61                 ; 218A
         tax                       ; 218C
         lda  $31D5,x              ; 218D
         ldy  #$00                 ; 2190
         sta  (ADDR),y             ; 2192
         cmp  #$2A                 ; 2194
         bne  L214B                ; 2196
         lda  #$FF                 ; 2198
         sta  MOVE_DIR             ; 219A
         bmi  L214B                ; 219D

* start a planet (Robbo PLA1): info-line texts by mode, header to $BFF0, screws, colours, players, TELE / KEYS / NABO ---
PLA1
         lda  DEMO                 ; 219F
         beq  L21A8                ; 21A1
         lda  #$05                 ; 21A3
         sta  $021F                ; 21A5
L21A8
         ldx  #$34                 ; 21A8
         ldy  #$1E                 ; 21AA
         lda  TP_TEST              ; 21AC
         beq  L21B5                ; 21AF
         ldx  #$31                 ; 21B1
         ldy  #$1E                 ; 21B3
L21B5
         stx  $1E2F                ; 21B5
         sty  $1E30                ; 21B8
         ldx  #$3B                 ; 21BB
         ldy  #$1E                 ; 21BD
         lda  DEMO                 ; 21BF
         beq  L21C7                ; 21C1
         ldx  #$37                 ; 21C3
         ldy  #$1E                 ; 21C5
L21C7
         stx  $1E35                ; 21C7
         sty  $1E36                ; 21CA
         ldx  CNUM                 ; 21CD
         inx                       ; 21CF
         stx  SCRA+1               ; 21D0
         lda  #$00                 ; 21D2
         sta  SCRA                 ; 21D4
         ldy  #$F0                 ; 21D6
L21D8
         lda  (SCRA),y             ; 21D8
         sta  $BF00,y              ; 21DA
         iny                       ; 21DD
         bne  L21D8                ; 21DE
         lda  $BFF0                ; 21E0
         sta  $2248                ; 21E3
         lda  $BFF1                ; 21E6
         sta  ZEBR                 ; 21E9
         lda  #$04                 ; 21EB
         sta  GPRIOR               ; 21ED
         jsr  HALT                 ; 21F0
         lda  #$21                 ; 21F3
         sta  SDMCTL               ; 21F5
         sta  DMACTL               ; 21F8
         ldx  #$04                 ; 21FB
L21FD
         lda  $BFF2,x              ; 21FD
         sta  COLOR0,x             ; 2200
         sta  COLPF0,x             ; 2203
         lda  COLOR4               ; 2206
         sta  COLPM0,x             ; 2209
         dex                       ; 220C
         bpl  L21FD                ; 220D
         lda  $BFF7                ; 220F
         sta  $02C3                ; 2212
         lda  #$FF                 ; 2215
         ldx  #$08                 ; 2217
L2219
         sta  SIZEP0,x             ; 2219
         dex                       ; 221C
         bpl  L2219                ; 221D
         lda  #$40                 ; 221F
         sta  HPOSP0               ; 2221
         lda  #$60                 ; 2224
         sta  HPOSP1               ; 2226
         lda  #$80                 ; 2229
         sta  HPOSP2               ; 222B
         lda  #$A0                 ; 222E
         sta  HPOSP3               ; 2230
         ldx  #$01                 ; 2233
         stx  TELE                 ; 2235
         dex                       ; 2237
         stx  KEYS                 ; 2238
         stx  NABO                 ; 223A
         stx  RUCH                 ; 223C
         lda  #$0D                 ; 223E
         sta  LM                   ; 2240
         rts                       ; 2242
         dta $2C,$2D,$2E,$2F                          ; 2243

* enter a planet (Robbo: "wejscie"): wall shapes into the font by the header, draw the board column by column ---
ENTCV
         lda  #$00                 ; 2247
         lsr                       ; 2249
         pha                       ; 224A
         and  #$30                 ; 224B
         sta  SCRA                 ; 224D
         sta  CHAD                 ; 224F
         ldx  #$48                 ; 2251
         pla                       ; 2253
         and  #$40                 ; 2254
         beq  L225A                ; 2256
         inx                       ; 2258
         inx                       ; 2259
L225A
         stx  CHAD+1               ; 225A
         inx                       ; 225C
         stx  SCRA+1               ; 225D
         ldy  #$0F                 ; 225F
L2261
         lda  (CHAD),y             ; 2261
         sta  $3C00,y              ; 2263
         lda  (SCRA),y             ; 2266
         sta  $3D00,y              ; 2268
         dey                       ; 226B
         bpl  L2261                ; 226C
         lda  #$0F                 ; 226E
         sta  X                    ; 2270
L2272
         lda  #$00                 ; 2272
         sta  Y                    ; 2274
L2276
         lda  CNUM                 ; 2276
         sta  ADDR+1               ; 2278
         lda  Y                    ; 227A
         asl                       ; 227C
         asl                       ; 227D
         asl                       ; 227E
         asl                       ; 227F
         sta  ADDR                 ; 2280
         bcc  L2286                ; 2282
         inc  ADDR+1               ; 2284
L2286
         ldy  X                    ; 2286
         lda  (ADDR),y             ; 2288
         cmp  #$2E                 ; 228A
         bne  L2297                ; 228C
         lda  RANDOM               ; 228E
         and  #$03                 ; 2291
         tax                       ; 2293
         lda  $2243,x              ; 2294
L2297
         cmp  #$2A                 ; 2297
         bne  L22A0                ; 2299
         jsr  MFX1                 ; 229B
         lda  #$1B                 ; 229E
L22A0
         cmp  #$2B                 ; 22A0
         bne  L22AC                ; 22A2
         ldx  CNUM                 ; 22A4
         cpx  LSTE                 ; 22A6
         bne  L22AC                ; 22A8
         lda  #$E1                 ; 22AA
L22AC
         jsr  PUT_                 ; 22AC
         inc  Y                    ; 22AF
         lda  Y                    ; 22B1
         cmp  #$1F                 ; 22B3
         bcc  L2276                ; 22B5
         lda  #$20                 ; 22B7
         jsr  PUT_                 ; 22B9
         jsr  CHNMON               ; 22BC
         lda  X                    ; 22BF
         and  #$03                 ; 22C1
         bne  L22C8                ; 22C3
         inc  CNTR                 ; 22C5
L22C8
         jsr  HALT                 ; 22C8
         dec  X                    ; 22CB
         bpl  L2272                ; 22CD
         rts                       ; 22CF

* step X one cell right; carry set if the cell is free -----
RT_
         inc  X                    ; 22D0
         jsr  TST_                 ; 22D2
         beq  L22DB                ; 22D5
         dec  X                    ; 22D7
         sec                       ; 22D9
         rts                       ; 22DA
L22DB
         dec  ADDR+1               ; 22DB
         dey                       ; 22DD
         lda  (ADDR),y             ; 22DE
         tax                       ; 22E0
         lda  #$20                 ; 22E1
         sta  (ADDR),y             ; 22E3
         iny                       ; 22E5
         inc  ADDR+1               ; 22E6
         txa                       ; 22E8
         ora  #$80                 ; 22E9
         sta  (ADDR),y             ; 22EB
         clc                       ; 22ED
         rts                       ; 22EE

* step X one cell left; carry set if the cell is free ------
LT_
         dec  X                    ; 22EF
         jsr  TST_                 ; 22F1
         beq  L22FA                ; 22F4
         inc  X                    ; 22F6
         sec                       ; 22F8
         rts                       ; 22F9
L22FA
         iny                       ; 22FA
         lda  (ADDR),y             ; 22FB
         tax                       ; 22FD
         lda  #$20                 ; 22FE
         sta  (ADDR),y             ; 2300
         dey                       ; 2302
         txa                       ; 2303
         sta  (ADDR),y             ; 2304
         clc                       ; 2306
         rts                       ; 2307

* step Y one cell down; carry set if the cell is free ------
DW_
         inc  Y                    ; 2308
         jsr  TST_                 ; 230A
         beq  L2313                ; 230D
         dec  Y                    ; 230F
         sec                       ; 2311
         rts                       ; 2312
L2313
         dec  ADDR+1               ; 2313
         ldy  #$F0                 ; 2315
         lda  (ADDR),y             ; 2317
         tax                       ; 2319
         lda  #$20                 ; 231A
         sta  (ADDR),y             ; 231C
         ldy  #$00                 ; 231E
         inc  ADDR+1               ; 2320
         txa                       ; 2322
         ora  #$80                 ; 2323
         sta  (ADDR),y             ; 2325
         clc                       ; 2327
         rts                       ; 2328

* step Y one cell up; carry set if the cell is free --------
UP_
         dec  Y                    ; 2329
         jsr  TST_                 ; 232B
         beq  L2334                ; 232E
         inc  Y                    ; 2330
         sec                       ; 2332
         rts                       ; 2333
L2334
         ldy  #$10                 ; 2334
         lda  (ADDR),y             ; 2336
         tax                       ; 2338
         lda  #$20                 ; 2339
         sta  (ADDR),y             ; 233B
         ldy  #$00                 ; 233D
         txa                       ; 233F
         sta  (ADDR),y             ; 2340
         clc                       ; 2342
         rts                       ; 2343

* step one cell in the direction LM: UP_ / DW_ / LT_ / RT_ through JMP1, carry set if blocked (Robbo FD_) ---
FD_
         lda  LM                   ; 2344
         ldx  #$FF                 ; 2346
L2348
         inx                       ; 2348
         lsr                       ; 2349
         bcs  L2348                ; 234A
         lda  $235B,x              ; 234C
         sta  $2359                ; 234F
         lda  $235F,x              ; 2352
         sta  $235A                ; 2355

* JMP to the step routine, operand from the tables $235B / $235F (Robbo JMP1, LMVT) ---
JMP1
         jmp  JMP1                 ; 2358
         dta $29,$08,$EF,$D0,$23,$23,$22,$22          ; 235B

* test the cell to the left --------------------------------
T_LT
         dec  X                    ; 2363
         jsr  TST_                 ; 2365
         inc  X                    ; 2368
         jmp  T_EX                 ; 236A

* test the cell to the right -------------------------------
T_RT
         inc  X                    ; 236D
         jsr  TST_                 ; 236F
         dec  X                    ; 2372
         jmp  T_EX                 ; 2374

* test the cell above --------------------------------------
T_UP
         dec  Y                    ; 2377
         jsr  TST_                 ; 2379
         inc  Y                    ; 237C
         jmp  T_EX                 ; 237E

* test the cell below --------------------------------------
T_DW
         inc  Y                    ; 2381
         jsr  TST_                 ; 2383
         dec  Y                    ; 2386

* properties of the tested cell from WHAT $32B1: bit 0 = a bullet destroys it, bit 1 = a bomb destroys it (Robbo T_EX) ---
T_EX
         tax                       ; 2388
         lda  $32B1,x              ; 2389
         rts                       ; 238C

* add points to the score (Robbo: "dodaj punkty") ----------
ASCO
         sed                       ; 238D
         clc                       ; 238E
         adc  SCOR+2               ; 238F
         sta  SCOR+2               ; 2391
         txa                       ; 2393
         adc  SCOR+1               ; 2394
         sta  SCOR+1               ; 2396
         lda  #$00                 ; 2398
         adc  SCOR                 ; 239A
         sta  SCOR                 ; 239C
         cld                       ; 239E
         rts                       ; 239F

* wait X frames (Robbo WAIT) -------------------------------
WAIT
         jsr  HALT                 ; 23A0
         dex                       ; 23A3
         bne  WAIT                 ; 23A4

* wait for the next frame (Robbo HALT) ---------------------
HALT
         lda  RTCLOK+2             ; 23A6
L23A8
         cmp  RTCLOK+2             ; 23A8
         beq  L23A8                ; 23AA
         rts                       ; 23AC

* read the board cell at X/Y -------------------------------
GET_
         lda  X                    ; 23AD
         ldy  Y                    ; 23AF
         ora  $23FD,y              ; 23B1
         sta  ADDR                 ; 23B4
         lda  $241D,y              ; 23B6
         sta  ADDR+1               ; 23B9
         ldy  #$00                 ; 23BB
         lda  (ADDR),y             ; 23BD
         pha                       ; 23BF
         lda  #$20                 ; 23C0
         sta  (ADDR),y             ; 23C2
         pla                       ; 23C4
         rts                       ; 23C5

* write object A to the board cell at X/Y ------------------
PUT_
         pha                       ; 23C6
         lda  X                    ; 23C7
         ldy  Y                    ; 23C9
         ora  $23FD,y              ; 23CB
         sta  ADDR                 ; 23CE
         lda  $241D,y              ; 23D0
         sta  ADDR+1               ; 23D3
         pla                       ; 23D5
         ldy  #$00                 ; 23D6
         sta  (ADDR),y             ; 23D8
         rts                       ; 23DA

* test the board cell --------------------------------------
TST_
         lda  X                    ; 23DB
         cmp  #$10                 ; 23DD
         bcs  TST_W                ; 23DF
         ldy  Y                    ; 23E1
         cpy  #$1F                 ; 23E3
         bcs  TST_W                ; 23E5
         ora  $23FD,y              ; 23E7
         sta  ADDR                 ; 23EA
         lda  $241D,y              ; 23EC
         sta  ADDR+1               ; 23EF
         ldy  #$00                 ; 23F1
         lda  (ADDR),y             ; 23F3
         and  #$7F                 ; 23F5
         cmp  #$20                 ; 23F7
         rts                       ; 23F9

* outside the board: answer $A0, a wall (Robbo TST_W) ------
TST_W
         lda  #$A0                 ; 23FA
         rts                       ; 23FC
