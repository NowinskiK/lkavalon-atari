; ENGINE1.ASM - game engine: jump table $1E00, display list, DLIs
; $1E00-$23FC

         org $1E00

entry_1E00
         jmp  L1F46                ; 1E00
entry_1E03
         stx  $1E0B                ; 1E03
         tsx                       ; 1E06
         stx  $3331                ; 1E07
         ldx  #$0A                 ; 1E0A
         jmp  L1FC8                ; 1E0C
         dta $70,$70,$F0,$64,$00,$B6,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24 ; 1E0F
         dta $24,$24,$24,$24,$24,$24,$24,$24,$A4,$04,$50,$42,$3E,$1E,$02,$01 ; 1E1F
         dta $2F,$1E,$42,$8E,$1E,$01,$35,$1E,$80,$42,$B6,$1E,$41,$0F,$1E,$00 ; 1E2F
         dta $00,$00,$00,$00,$00,$00,$00,$00,$00,$4D,$4E,$00,$00,$00,$00,$49 ; 1E3F
         dta $4A,$00,$00,$00,$00,$55,$56,$00,$00,$00,$00,$51,$52,$00,$00,$00 ; 1E4F
         dta $00,$45,$46,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 1E5F
         dta $00,$4F,$50,$00,$00,$00,$00,$4B,$4C,$00,$00,$00,$00,$57,$58,$00 ; 1E6F
         dta $00,$00,$00,$53,$54,$00,$00,$00,$00,$47,$48,$00,$00,$00,$00,$00 ; 1E7F
         dta $00,$22,$32,$25,$21,$2B,$1A,$00,$00,$70,$6F,$77,$72,$3F,$74,$00 ; 1E8F
         dta $64,$6F,$00,$32,$6F,$62,$62,$6F,$00,$2B,$6F,$6E,$73,$74,$72,$75 ; 1E9F
         dta $6B,$74,$6F,$72,$61,$00,$00,$37,$63,$69,$7B,$6E,$69,$3C,$63,$69 ; 1EAF
         dta $65,$00,$73,$74,$72,$7A,$61,$3D,$75,$00,$70,$72,$7A,$65,$72,$79 ; 1EBF
         dta $77,$61,$00,$64,$65,$6D,$6F,$6E,$73,$74,$72,$61,$63,$6A,$3C ; 1ECF
irq_1EDE
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
irq_1EFD
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
irq_1F3C
         pha                       ; 1F3C
         lda  RTCLOK+2             ; 1F3D
         lsr                       ; 1F3F
         lsr                       ; 1F40
         sta  COLPF1               ; 1F41
         pla                       ; 1F44
         rti                       ; 1F45
L1F46
         jsr  sub_23A6             ; 1F46
         lda  #$00                 ; 1F49
         sta  SDMCTL               ; 1F4B
         sta  DMACTL               ; 1F4E
         sta  $99                  ; 1F51
         sta  $D405                ; 1F53
         sta  $A4                  ; 1F56
         sta  $A5                  ; 1F58
         sta  $A6                  ; 1F5A
         sta  $9E                  ; 1F5C
         sta  $A2                  ; 1F5E
         sta  $A8                  ; 1F60
         sta  $A8                  ; 1F62
         lda  #$FF                 ; 1F64
         sta  $A1                  ; 1F66
         sta  $11                  ; 1F68
         lda  #$00                 ; 1F6A
         sta  $1E13                ; 1F6C
         sta  $86                  ; 1F6F
         sta  $2491                ; 1F71
         lda  #$B6                 ; 1F74
         sta  $1E14                ; 1F76
         sta  $87                  ; 1F79
         sta  $2495                ; 1F7B
         lda  #$00                 ; 1F7E
         sta  $80                  ; 1F80
         lda  #$BE                 ; 1F82
         sta  $81                  ; 1F84
         ldx  #$00                 ; 1F86
L1F88
         lda  $80                  ; 1F88
         sta  $23FD,x              ; 1F8A
         lda  $81                  ; 1F8D
         sta  $241D,x              ; 1F8F
         clc                       ; 1F92
         lda  $80                  ; 1F93
         adc  #$10                 ; 1F95
         sta  $80                  ; 1F97
         bcc  L1F9D                ; 1F99
         inc  $81                  ; 1F9B
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
         jsr  sub_23A6             ; 1FB1
         lda  #$DE                 ; 1FB4
         sta  VDSLST               ; 1FB6
         lda  #$1E                 ; 1FB9
         sta  VDSLST+1             ; 1FBB
         lda  #$C0                 ; 1FBE
         sta  NMIEN                ; 1FC0
         lda  #$FF                 ; 1FC3
         jmp  sub_3334             ; 1FC5
L1FC8
         sta  $9D                  ; 1FC8
         stx  $A9                  ; 1FCA
         lda  #$00                 ; 1FCC
         bcc  L1FD2                ; 1FCE
         lda  #$80                 ; 1FD0
L1FD2
         sta  $A3                  ; 1FD2
         sty  $207D                ; 1FD4
         cpy  #$FF                 ; 1FD7
         bne  L1FDC                ; 1FD9
         iny                       ; 1FDB
L1FDC
         sty  $9F                  ; 1FDC
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
         jsr  sub_243D             ; 2000
L2003
         jsr  sub_219F             ; 2003
         jsr  sub_2247             ; 2006
         lda  #$00                 ; 2009
         sta  $3154                ; 200B
L200E
         lsr  $4D                  ; 200E
         lda  #$00                 ; 2010
         sta  $9C                  ; 2012
         jsr  sub_210B             ; 2014
         lda  $A3                  ; 2017
         beq  L2057                ; 2019
         lda  $3145                ; 201B
         beq  L2027                ; 201E
         lda  $021F                ; 2020
         bne  L205C                ; 2023
         beq  L2062                ; 2025
L2027
         ldx  #$10                 ; 2027
         jsr  sub_23A0             ; 2029
L202C
         ldx  $3331                ; 202C
         txs                       ; 202F
         ldy  #$99                 ; 2030
         ldx  $A9                  ; 2032
L2034
         txa                       ; 2034
         pha                       ; 2035
         tya                       ; 2036
         pha                       ; 2037
         ldy  $3332                ; 2038
         ldx  $3333                ; 203B
         lda  #$07                 ; 203E
         jsr  SETVBV               ; 2040
         lda  #$FF                 ; 2043
         jsr  sub_3334             ; 2045
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
         lda  $3154                ; 2057
         bne  L206C                ; 205A
L205C
         lda  $9C                  ; 205C
         bmi  L2092                ; 205E
         bne  L200E                ; 2060
L2062
         lda  #$00                 ; 2062
         sta  $A8                  ; 2064
         sta  $021F                ; 2066
         jsr  sub_20FC             ; 2069
L206C
         jsr  sub_20C4             ; 206C
         lda  $A3                  ; 206F
         bne  L2092                ; 2071
         sed                       ; 2073
         sec                       ; 2074
         lda  $9F                  ; 2075
         sbc  #$01                 ; 2077
         sta  $9F                  ; 2079
         cld                       ; 207B
         ldx  #$00                 ; 207C
         inx                       ; 207E
         beq  L2083                ; 207F
         bcs  L2003                ; 2081
L2083
         lda  #$00                 ; 2083
         sta  $9F                  ; 2085
         ldy  #$99                 ; 2087
         bne  L208D                ; 2089
L208B
         ldy  $9F                  ; 208B
L208D
         ldx  $A9                  ; 208D
         jmp  L2034                ; 208F
L2092
         lda  #$0F                 ; 2092
         sta  $92                  ; 2094
L2096
         lda  #$00                 ; 2096
         sta  $A8                  ; 2098
         lda  #$1F                 ; 209A
         sta  $93                  ; 209C
L209E
         lda  #$13                 ; 209E
         jsr  L23C6                ; 20A0
         dec  $93                  ; 20A3
         bpl  L209E                ; 20A5
         jsr  sub_243D             ; 20A7
         lda  $92                  ; 20AA
         and  #$03                 ; 20AC
         bne  L20B3                ; 20AE
         inc  $210A                ; 20B0
L20B3
         jsr  sub_23A6             ; 20B3
         dec  $92                  ; 20B6
         bpl  L2096                ; 20B8
         inc  $A9                  ; 20BA
         sec                       ; 20BC
         lda  $A3                  ; 20BD
         bne  L208B                ; 20BF
         clc                       ; 20C1
         bcc  L208B                ; 20C2
sub_20C4
         lda  #$00                 ; 20C4
         sta  $A8                  ; 20C6
         jsr  sub_3334             ; 20C8
         lda  #$1E                 ; 20CB
         sta  $93                  ; 20CD
L20CF
         lda  #$0F                 ; 20CF
         sta  $92                  ; 20D1
L20D3
         jsr  sub_23DB             ; 20D3
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
         sta  ($80),y              ; 20F2
L20F4
         dec  $92                  ; 20F4
         bpl  L20D3                ; 20F6
         dec  $93                  ; 20F8
         bpl  L20CF                ; 20FA
sub_20FC
         lda  #$30                 ; 20FC
         sta  $021E                ; 20FE
L2101
         jsr  sub_210B             ; 2101
         lda  $021E                ; 2104
         bne  L2101                ; 2107
         rts                       ; 2109
         dta $00                                      ; 210A
sub_210B
         inc  $210A                ; 210B
         jsr  sub_2582             ; 210E
         ldy  #$00                 ; 2111
         sty  $95                  ; 2113
L2115
         ldx  #$00                 ; 2115
         stx  $94                  ; 2117
L2119
         lda  $95                  ; 2119
         sta  $93                  ; 211B
         lda  $94                  ; 211D
         sta  $92                  ; 211F
         ldy  $93                  ; 2121
         ora  $23FD,y              ; 2123
         sta  $80                  ; 2126
         lda  $241D,y              ; 2128
         sta  $81                  ; 212B
         ldy  #$00                 ; 212D
         lda  ($80),y              ; 212F
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
         inc  $94                  ; 214B
         lda  $94                  ; 214D
         cmp  #$10                 ; 214F
         bcc  L2119                ; 2151
         inc  $95                  ; 2153
         lda  $95                  ; 2155
         cmp  #$1F                 ; 2157
         bcc  L2115                ; 2159
         jsr  sub_2582             ; 215B
L215E
         lda  CDTMV3               ; 215E
         bne  L215E                ; 2161
         lda  #$07                 ; 2163
         sta  CDTMV3               ; 2165
         jmp  sub_243D             ; 2168
L216B
         tya                       ; 216B
         and  #$7F                 ; 216C
         ldy  #$00                 ; 216E
         sta  ($80),y              ; 2170
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
         sty  $9B                  ; 2184
         iny                       ; 2186
         sty  $9C                  ; 2187
L2189
         sec                       ; 2189
         sbc  #$61                 ; 218A
         tax                       ; 218C
         lda  $31D5,x              ; 218D
         ldy  #$00                 ; 2190
         sta  ($80),y              ; 2192
         cmp  #$2A                 ; 2194
         bne  L214B                ; 2196
         lda  #$FF                 ; 2198
         sta  $3142                ; 219A
         bmi  L214B                ; 219D
sub_219F
         lda  $A3                  ; 219F
         beq  L21A8                ; 21A1
         lda  #$05                 ; 21A3
         sta  $021F                ; 21A5
L21A8
         ldx  #$34                 ; 21A8
         ldy  #$1E                 ; 21AA
         lda  $35C1                ; 21AC
         beq  L21B5                ; 21AF
         ldx  #$31                 ; 21B1
         ldy  #$1E                 ; 21B3
L21B5
         stx  $1E2F                ; 21B5
         sty  $1E30                ; 21B8
         ldx  #$3B                 ; 21BB
         ldy  #$1E                 ; 21BD
         lda  $A3                  ; 21BF
         beq  L21C7                ; 21C1
         ldx  #$37                 ; 21C3
         ldy  #$1E                 ; 21C5
L21C7
         stx  $1E35                ; 21C7
         sty  $1E36                ; 21CA
         ldx  $9D                  ; 21CD
         inx                       ; 21CF
         stx  $83                  ; 21D0
         lda  #$00                 ; 21D2
         sta  $82                  ; 21D4
         ldy  #$F0                 ; 21D6
L21D8
         lda  ($82),y              ; 21D8
         sta  $BF00,y              ; 21DA
         iny                       ; 21DD
         bne  L21D8                ; 21DE
         lda  $BFF0                ; 21E0
         sta  $2248                ; 21E3
         lda  $BFF1                ; 21E6
         sta  $A0                  ; 21E9
         lda  #$04                 ; 21EB
         sta  GPRIOR               ; 21ED
         jsr  sub_23A6             ; 21F0
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
         stx  $9B                  ; 2235
         dex                       ; 2237
         stx  $9E                  ; 2238
         stx  $A2                  ; 223A
         stx  $A8                  ; 223C
         lda  #$0D                 ; 223E
         sta  $98                  ; 2240
         rts                       ; 2242
         dta $2C,$2D,$2E,$2F                          ; 2243
sub_2247
         lda  #$00                 ; 2247
         lsr                       ; 2249
         pha                       ; 224A
         and  #$30                 ; 224B
         sta  $82                  ; 224D
         sta  $84                  ; 224F
         ldx  #$48                 ; 2251
         pla                       ; 2253
         and  #$40                 ; 2254
         beq  L225A                ; 2256
         inx                       ; 2258
         inx                       ; 2259
L225A
         stx  $85                  ; 225A
         inx                       ; 225C
         stx  $83                  ; 225D
         ldy  #$0F                 ; 225F
L2261
         lda  ($84),y              ; 2261
         sta  $3C00,y              ; 2263
         lda  ($82),y              ; 2266
         sta  $3D00,y              ; 2268
         dey                       ; 226B
         bpl  L2261                ; 226C
         lda  #$0F                 ; 226E
         sta  $92                  ; 2270
L2272
         lda  #$00                 ; 2272
         sta  $93                  ; 2274
L2276
         lda  $9D                  ; 2276
         sta  $81                  ; 2278
         lda  $93                  ; 227A
         asl                       ; 227C
         asl                       ; 227D
         asl                       ; 227E
         asl                       ; 227F
         sta  $80                  ; 2280
         bcc  L2286                ; 2282
         inc  $81                  ; 2284
L2286
         ldy  $92                  ; 2286
         lda  ($80),y              ; 2288
         cmp  #$2E                 ; 228A
         bne  L2297                ; 228C
         lda  RANDOM               ; 228E
         and  #$03                 ; 2291
         tax                       ; 2293
         lda  $2243,x              ; 2294
L2297
         cmp  #$2A                 ; 2297
         bne  L22A0                ; 2299
         jsr  sub_2731             ; 229B
         lda  #$1B                 ; 229E
L22A0
         cmp  #$2B                 ; 22A0
         bne  L22AC                ; 22A2
         ldx  $9D                  ; 22A4
         cpx  $A1                  ; 22A6
         bne  L22AC                ; 22A8
         lda  #$E1                 ; 22AA
L22AC
         jsr  L23C6                ; 22AC
         inc  $93                  ; 22AF
         lda  $93                  ; 22B1
         cmp  #$1F                 ; 22B3
         bcc  L2276                ; 22B5
         lda  #$20                 ; 22B7
         jsr  L23C6                ; 22B9
         jsr  sub_243D             ; 22BC
         lda  $92                  ; 22BF
         and  #$03                 ; 22C1
         bne  L22C8                ; 22C3
         inc  $210A                ; 22C5
L22C8
         jsr  sub_23A6             ; 22C8
         dec  $92                  ; 22CB
         bpl  L2272                ; 22CD
         rts                       ; 22CF
sub_22D0
         inc  $92                  ; 22D0
         jsr  sub_23DB             ; 22D2
         beq  L22DB                ; 22D5
         dec  $92                  ; 22D7
         sec                       ; 22D9
         rts                       ; 22DA
L22DB
         dec  $81                  ; 22DB
         dey                       ; 22DD
         lda  ($80),y              ; 22DE
         tax                       ; 22E0
         lda  #$20                 ; 22E1
         sta  ($80),y              ; 22E3
         iny                       ; 22E5
         inc  $81                  ; 22E6
         txa                       ; 22E8
         ora  #$80                 ; 22E9
         sta  ($80),y              ; 22EB
         clc                       ; 22ED
         rts                       ; 22EE
sub_22EF
         dec  $92                  ; 22EF
         jsr  sub_23DB             ; 22F1
         beq  L22FA                ; 22F4
         inc  $92                  ; 22F6
         sec                       ; 22F8
         rts                       ; 22F9
L22FA
         iny                       ; 22FA
         lda  ($80),y              ; 22FB
         tax                       ; 22FD
         lda  #$20                 ; 22FE
         sta  ($80),y              ; 2300
         dey                       ; 2302
         txa                       ; 2303
         sta  ($80),y              ; 2304
         clc                       ; 2306
         rts                       ; 2307
sub_2308
         inc  $93                  ; 2308
         jsr  sub_23DB             ; 230A
         beq  L2313                ; 230D
         dec  $93                  ; 230F
         sec                       ; 2311
         rts                       ; 2312
L2313
         dec  $81                  ; 2313
         ldy  #$F0                 ; 2315
         lda  ($80),y              ; 2317
         tax                       ; 2319
         lda  #$20                 ; 231A
         sta  ($80),y              ; 231C
         ldy  #$00                 ; 231E
         inc  $81                  ; 2320
         txa                       ; 2322
         ora  #$80                 ; 2323
         sta  ($80),y              ; 2325
         clc                       ; 2327
         rts                       ; 2328
sub_2329
         dec  $93                  ; 2329
         jsr  sub_23DB             ; 232B
         beq  L2334                ; 232E
         inc  $93                  ; 2330
         sec                       ; 2332
         rts                       ; 2333
L2334
         ldy  #$10                 ; 2334
         lda  ($80),y              ; 2336
         tax                       ; 2338
         lda  #$20                 ; 2339
         sta  ($80),y              ; 233B
         ldy  #$00                 ; 233D
         txa                       ; 233F
         sta  ($80),y              ; 2340
         clc                       ; 2342
         rts                       ; 2343
sub_2344
         lda  $98                  ; 2344
         ldx  #$FF                 ; 2346
L2348
         inx                       ; 2348
         lsr                       ; 2349
         bcs  L2348                ; 234A
         lda  $235B,x              ; 234C
         sta  $2359                ; 234F
         lda  $235F,x              ; 2352
         sta  $235A                ; 2355
L2358
         jmp  L2358                ; 2358
         dta $29,$08,$EF,$D0,$23,$23,$22,$22          ; 235B
sub_2363
         dec  $92                  ; 2363
         jsr  sub_23DB             ; 2365
         inc  $92                  ; 2368
         jmp  L2388                ; 236A
sub_236D
         inc  $92                  ; 236D
         jsr  sub_23DB             ; 236F
         dec  $92                  ; 2372
         jmp  L2388                ; 2374
sub_2377
         dec  $93                  ; 2377
         jsr  sub_23DB             ; 2379
         inc  $93                  ; 237C
         jmp  L2388                ; 237E
sub_2381
         inc  $93                  ; 2381
         jsr  sub_23DB             ; 2383
         dec  $93                  ; 2386
L2388
         tax                       ; 2388
         lda  $32B1,x              ; 2389
         rts                       ; 238C
sub_238D
         sed                       ; 238D
         clc                       ; 238E
         adc  $A6                  ; 238F
         sta  $A6                  ; 2391
         txa                       ; 2393
         adc  $A5                  ; 2394
         sta  $A5                  ; 2396
         lda  #$00                 ; 2398
         adc  $A4                  ; 239A
         sta  $A4                  ; 239C
         cld                       ; 239E
         rts                       ; 239F
sub_23A0
         jsr  sub_23A6             ; 23A0
         dex                       ; 23A3
         bne  sub_23A0             ; 23A4
sub_23A6
         lda  RTCLOK+2             ; 23A6
L23A8
         cmp  RTCLOK+2             ; 23A8
         beq  L23A8                ; 23AA
         rts                       ; 23AC
sub_23AD
         lda  $92                  ; 23AD
         ldy  $93                  ; 23AF
         ora  $23FD,y              ; 23B1
         sta  $80                  ; 23B4
         lda  $241D,y              ; 23B6
         sta  $81                  ; 23B9
         ldy  #$00                 ; 23BB
         lda  ($80),y              ; 23BD
         pha                       ; 23BF
         lda  #$20                 ; 23C0
         sta  ($80),y              ; 23C2
         pla                       ; 23C4
         rts                       ; 23C5
L23C6
         pha                       ; 23C6
         lda  $92                  ; 23C7
         ldy  $93                  ; 23C9
         ora  $23FD,y              ; 23CB
         sta  $80                  ; 23CE
         lda  $241D,y              ; 23D0
         sta  $81                  ; 23D3
         pla                       ; 23D5
         ldy  #$00                 ; 23D6
         sta  ($80),y              ; 23D8
         rts                       ; 23DA
sub_23DB
         lda  $92                  ; 23DB
         cmp  #$10                 ; 23DD
         bcs  L23FA                ; 23DF
         ldy  $93                  ; 23E1
         cpy  #$1F                 ; 23E3
         bcs  L23FA                ; 23E5
         ora  $23FD,y              ; 23E7
         sta  $80                  ; 23EA
         lda  $241D,y              ; 23EC
         sta  $81                  ; 23EF
         ldy  #$00                 ; 23F1
         lda  ($80),y              ; 23F3
         and  #$7F                 ; 23F5
         cmp  #$20                 ; 23F7
         rts                       ; 23F9
L23FA
         lda  #$A0                 ; 23FA
         rts                       ; 23FC
