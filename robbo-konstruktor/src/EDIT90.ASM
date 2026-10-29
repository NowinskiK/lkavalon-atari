; EDIT90.ASM - editor code
; $9000-$9430

         org $9000


* tape/disk: command letter in A (r, w, e, d - table $902B), dispatch via $902F ---
IO_CMD
         jmp  L9004                ; 9000
         dta $00                                      ; 9003
L9004
         stx  $9430                ; 9004
         ldx  #$03                 ; 9007
L9009
         cmp  $902B,x              ; 9009
         beq  L9011                ; 900C
         dex                       ; 900E
         bpl  L9009                ; 900F
L9011
         txa                       ; 9011
         asl                       ; 9012
         tax                       ; 9013
         lda  $902F,x              ; 9014
         sta  $9029                ; 9017
         lda  $9030,x              ; 901A
         sta  $902A                ; 901D
         lda  #$80                 ; 9020
         sta  $11                  ; 9022
         asl                       ; 9024
         sta  $9003                ; 9025
         jmp  $9028                ; 9028
         dta $72,$77,$65,$64,$02,$91,$BF,$91,$9C,$90,$5A,$90,$04,$00,$00,$01 ; 902B
         dta $84,$01,$08,$02,$8C,$02,$10,$03          ; 903B
;  RKdata 
         dta c' RKdata '* ; 9043
;  unused 
         dta c' unused ',$00 ; 904B
         dta $00,$01,$02,$04,$08,$10                  ; 9054

* directory: read the 5 slot headers, bit mask of used slots ---
IO_DIR
         lda  #$00                 ; 905A
         sta  $B8                  ; 905C
         ldx  #$05                 ; 905E
         stx  $9430                ; 9060
L9063
         jsr  IO_SLOTSEC           ; 9063
         jsr  IO_RDSEC             ; 9066
         bmi  L9080                ; 9069
         clc                       ; 906B
         lda  $9431                ; 906C
         bpl  L9072                ; 906F
         sec                       ; 9071
L9072
         rol  $B8                  ; 9072
         dec  $9430                ; 9074
         bne  L9063                ; 9077
         lda  $B8                  ; 9079
         sta  $9053                ; 907B
         ldy  #$01                 ; 907E
L9080
         php                       ; 9080
         lda  $9053                ; 9081
         plp                       ; 9084
         rts                       ; 9085

* header sector of slot $9430 -> DAUX (table $9037: sectors 4, 256, 388, 520, 652, 784) ---
IO_SLOTSEC
         lda  $9430                ; 9086
         asl                       ; 9089
         tax                       ; 908A
         lda  $9037,x              ; 908B
         sta  DAUX1                ; 908E
         lda  $9038,x              ; 9091
         sta  DAUX2                ; 9094
         lda  #$08                 ; 9097
         sta  $BF                  ; 9099
         rts                       ; 909B

* erase a slot: header " unused " --------------------------
IO_ERASE
         jsr  IO_CHKSLOT           ; 909C
         bmi  L90D6                ; 909F
         bcc  L90B6                ; 90A1
         lda  #$0E                 ; 90A3
         jsr  MESSAGE              ; 90A5
L90A8
         jsr  WAIT_KEY             ; 90A8
         bcs  L90A8                ; 90AB
         beq  IO_ERASE             ; 90AD
         jsr  CLICK                ; 90AF
         ldy  #$00                 ; 90B2
         beq  L90D6                ; 90B4
L90B6
         ldx  #$07                 ; 90B6
L90B8
         lda  $904B,x              ; 90B8
         sta  $9431,x              ; 90BB
         dex                       ; 90BE
         bpl  L90B8                ; 90BF
         jsr  IO_WRSEC             ; 90C1
         bmi  L90D6                ; 90C4
         ldx  $9430                ; 90C6
         lda  $9054,x              ; 90C9
         eor  #$FF                 ; 90CC
         and  $9053                ; 90CE
         sta  $9053                ; 90D1
         ldy  #$01                 ; 90D4
L90D6
         php                       ; 90D6
         lda  $9053                ; 90D7
         plp                       ; 90DA
         rts                       ; 90DB

* mark a slot used: header " RKdata " ----------------------
IO_MARK
         jsr  IO_SLOTSEC           ; 90DC
         jsr  IO_RDSEC             ; 90DF
         bmi  L90D6                ; 90E2
         ldx  #$07                 ; 90E4
L90E6
         lda  $9043,x              ; 90E6
         sta  $9431,x              ; 90E9
         dex                       ; 90EC
         bpl  L90E6                ; 90ED
         jsr  IO_WRSEC             ; 90EF
         bmi  L90D6                ; 90F2
         ldx  $9430                ; 90F4
         lda  $9054,x              ; 90F7
         ora  $9053                ; 90FA
         sta  $9053                ; 90FD
         bne  L90D6                ; 9100

* read a planet set from a slot ----------------------------
IO_READ
         jsr  IO_CHKSLOT           ; 9102
         bmi  L912F                ; 9105
         bcc  L911C                ; 9107
         lda  #$0E                 ; 9109
         jsr  MESSAGE              ; 910B
L910E
         jsr  WAIT_KEY             ; 910E
         bcs  L910E                ; 9111
         beq  IO_READ              ; 9113
         jsr  CLICK                ; 9115
         ldy  #$00                 ; 9118
         beq  L912F                ; 911A
L911C
         jsr  IO_MSG               ; 911C
         lda  #$FF                 ; 911F
         sta  $9003                ; 9121
         inc  DAUX1                ; 9124
         bne  L912C                ; 9127
         inc  DAUX2                ; 9129
L912C
         jsr  IO_LOADSET           ; 912C
L912F
         php                       ; 912F
         lda  $9053                ; 9130
         plp                       ; 9133
         rts                       ; 9134

* load the planets of a set --------------------------------
IO_LOADSET
         ldy  #$00                 ; 9135
L9137
         sty  $9140                ; 9137
         jsr  IO_GETBYTE           ; 913A
         bmi  L912F                ; 913D
         ldy  #$3F                 ; 913F
         dta $99,a($00B8)          ; 9141 sta ,y
         iny                       ; 9144
         cpy  #$04                 ; 9145
         bcc  L9137                ; 9147
         jsr  IO_CHECK             ; 9149
         bcc  L915A                ; 914C
         ldy  #$8F                 ; 914E
         lda  $B8                  ; 9150
         ora  $B9                  ; 9152
         bne  L9158                ; 9154
         ldy  #$01                 ; 9156
L9158
         tya                       ; 9158
         rts                       ; 9159
L915A
         jsr  IO_GETBYTE           ; 915A
         bmi  L912F                ; 915D
         ldy  #$00                 ; 915F
         sta  ($B8),y              ; 9161
         lda  $B9                  ; 9163
         cmp  $BB                  ; 9165
         bne  L9171                ; 9167
         lda  $B8                  ; 9169
         cmp  $BA                  ; 916B
         bne  L9171                ; 916D
         beq  IO_LOADSET           ; 916F
L9171
         inc  $B8                  ; 9171
         bne  L9177                ; 9173
         inc  $B9                  ; 9175
L9177
         jmp  L915A                ; 9177

* check the loaded set ("ten zestaw planet jest zniszczony") ---
IO_CHECK
         ldx  #$08                 ; 917A
L917C
         lda  $B8                  ; 917C
         cmp  $91B3,x              ; 917E
         lda  $B9                  ; 9181
         sbc  $91B4,x              ; 9183
         bcc  L91AB                ; 9186
         lda  $B8                  ; 9188
         cmp  $91B5,x              ; 918A
         lda  $B9                  ; 918D
         sbc  $91B6,x              ; 918F
         bcs  L91AB                ; 9192
         lda  $BA                  ; 9194
         cmp  $91B5,x              ; 9196
         lda  $BB                  ; 9199
         sbc  $91B6,x              ; 919B
         bcs  L91AB                ; 919E
         lda  $B8                  ; 91A0
         cmp  $BA                  ; 91A2
         lda  $B9                  ; 91A4
         sbc  $BB                  ; 91A6
         bcs  L91AB                ; 91A8
         rts                       ; 91AA
L91AB
         dex                       ; 91AB
         dex                       ; 91AC
         dex                       ; 91AD
         dex                       ; 91AE
         bpl  L917C                ; 91AF
         sec                       ; 91B1
         rts                       ; 91B2
         dta $A0,$39,$E0,$39,$00,$3A,$00,$3C,$00,$50,$00,$90 ; 91B3

* write a planet set to a slot -----------------------------
IO_WRITE
         lda  $9430                ; 91BF
         bne  L91EC                ; 91C2
         lda  #$01                 ; 91C4
         sta  $9430                ; 91C6
         jsr  IO_CHKSLOT           ; 91C9
         bmi  L91D6                ; 91CC
         bcs  L91D6                ; 91CE
         lda  $9053                ; 91D0
         ldy  #$FF                 ; 91D3
         rts                       ; 91D5
L91D6
         jsr  IO_MSG               ; 91D6
         dec  $9430                ; 91D9
         jsr  IO_SLOTSEC           ; 91DC
         lda  DAUX1                ; 91DF
         sta  $93B0                ; 91E2
         jsr  IO_SAVEGAME          ; 91E5
         bmi  L9201                ; 91E8
         bpl  L91F3                ; 91EA
L91EC
         jsr  IO_ERASE             ; 91EC
         beq  L9201                ; 91EF
         bmi  L9201                ; 91F1
L91F3
         jsr  IO_MSG               ; 91F3
         jsr  IO_SLOTSEC           ; 91F6
         jsr  IO_SAVESET           ; 91F9
         bmi  L9201                ; 91FC
         jsr  IO_MARK              ; 91FE
L9201
         php                       ; 9201
         lda  $9053                ; 9202
         plp                       ; 9205
         rts                       ; 9206

* save the planets: $5000 + n * $200, $1F7 bytes each, those used in $39A0 ---
IO_SAVESET
         ldx  #$EB                 ; 9207
         ldy  #$92                 ; 9209
         lda  $9430                ; 920B
         beq  L9214                ; 920E
         ldx  #$E1                 ; 9210
         ldy  #$92                 ; 9212
L9214
         stx  $9224                ; 9214
         sty  $9225                ; 9217
         ldx  #$00                 ; 921A
         stx  $9220                ; 921C
L921F
         ldx  #$1F                 ; 921F
         ldy  #$00                 ; 9221
L9223
         lda  L9223,x              ; 9223
         dta $99,a($00B8)          ; 9226 sta ,y
         inx                       ; 9229
         iny                       ; 922A
         cpy  #$04                 ; 922B
         bcc  L9223                ; 922D
         stx  $9220                ; 922F
         lda  $B8                  ; 9232
         ora  $B9                  ; 9234
         beq  L923F                ; 9236
         jsr  IO_PUTRANGE          ; 9238
         bmi  L9201                ; 923B
         bpl  L921F                ; 923D
L923F
         ldx  #$1F                 ; 923F
L9241
         stx  $9261                ; 9241
         lda  PLANET_STATE,x       ; 9244
         beq  L9260                ; 9247
         txa                       ; 9249
         asl                       ; 924A
         adc  #$50                 ; 924B
         sta  $B9                  ; 924D
         ora  #$01                 ; 924F
         sta  $BB                  ; 9251
         lda  #$00                 ; 9253
         sta  $B8                  ; 9255
         lda  #$F7                 ; 9257
         sta  $BA                  ; 9259
         jsr  IO_PUTRANGE          ; 925B
         bmi  L9201                ; 925E
L9260
         ldx  #$60                 ; 9260
         dex                       ; 9262
         bpl  L9241                ; 9263
         lda  #$00                 ; 9265
         jsr  IO_PUTBYTE           ; 9267
         bmi  L9201                ; 926A
         lda  #$00                 ; 926C
         jsr  IO_PUTBYTE           ; 926E
         bmi  L9201                ; 9271
         jmp  IO_WRSEC             ; 9273

* write a memory range as a byte stream --------------------
IO_PUTRANGE
         ldy  #$00                 ; 9276
L9278
         sty  $9287                ; 9278
         dta $B9,a($00B8)          ; 927B lda ,y
         jsr  IO_PUTBYTE           ; 927E
         bpl  L9286                ; 9281
         jmp  L9201                ; 9283
L9286
         ldy  #$86                 ; 9286
         iny                       ; 9288
         cpy  #$04                 ; 9289
         bcc  L9278                ; 928B
L928D
         ldy  #$00                 ; 928D
         lda  ($B8),y              ; 928F
         jsr  IO_PUTBYTE           ; 9291
         bpl  L9299                ; 9294
         jmp  L9201                ; 9296
L9299
         lda  $B9                  ; 9299
         cmp  $BB                  ; 929B
         bne  L92A8                ; 929D
         lda  $B8                  ; 929F
         cmp  $BA                  ; 92A1
         bne  L92A8                ; 92A3
         ldy  #$01                 ; 92A5
         rts                       ; 92A7
L92A8
         inc  $B8                  ; 92A8
         bne  L92AE                ; 92AA
         inc  $B9                  ; 92AC
L92AE
         jmp  L928D                ; 92AE

* save a stand-alone Robbo game: format the disk, write the game ---
IO_SAVEGAME
         jsr  IO_FORMAT            ; 92B1
         bmi  L92DB                ; 92B4
         ldx  #$01                 ; 92B6
         stx  DAUX1                ; 92B8
         dex                       ; 92BB
         stx  DAUX2                ; 92BC
         lda  #$00                 ; 92BF
         sta  $BF                  ; 92C1
         lda  #$A9                 ; 92C3
         sta  $B8                  ; 92C5
         lda  #$93                 ; 92C7
         sta  $B9                  ; 92C9
         lda  #$2F                 ; 92CB
         sta  $BA                  ; 92CD
         lda  #$94                 ; 92CF
         sta  $BB                  ; 92D1
         jsr  L928D                ; 92D3
         bmi  L92DB                ; 92D6
         jsr  IO_WRSEC             ; 92D8
L92DB
         php                       ; 92DB
         lda  $9053                ; 92DC
         plp                       ; 92DF
         rts                       ; 92E0
         dta $A0,$39,$DF,$39,$00,$3A,$FF,$3B,$00,$00,$00,$1E,$FF,$3F,$00,$48 ; 92E1
         dta $FF,$4F,$00,$00                          ; 92F1

* read one byte through the sector buffer $9431 ------------
IO_GETBYTE
         clc                       ; 92F5
         ldy  $BF                  ; 92F6
         bpl  L930C                ; 92F8
         jsr  IO_RDSEC             ; 92FA
         bpl  L9300                ; 92FD
         rts                       ; 92FF
L9300
         inc  DAUX1                ; 9300
         bne  L9308                ; 9303
         inc  DAUX2                ; 9305
L9308
         ldy  #$00                 ; 9308
         sty  $BF                  ; 930A
L930C
         lda  $9431,y              ; 930C
         inc  $BF                  ; 930F
         ldy  #$01                 ; 9311
         rts                       ; 9313

* write one byte through the sector buffer $9431 -----------
IO_PUTBYTE
         clc                       ; 9314
         ldy  $BF                  ; 9315
         bpl  L9330                ; 9317
         sta  $932B                ; 9319
         jsr  IO_WRSEC             ; 931C
         bpl  L9322                ; 931F
         rts                       ; 9321
L9322
         inc  DAUX1                ; 9322
         bne  L932A                ; 9325
         inc  DAUX2                ; 9327
L932A
         lda  #$2A                 ; 932A
         ldy  #$00                 ; 932C
         sty  $BF                  ; 932E
L9330
         sta  $9431,y              ; 9330
         inc  $BF                  ; 9333
         ldy  #$01                 ; 9335
         rts                       ; 9337

* read a sector into $9431 (SIO R) -------------------------
IO_RDSEC
         lda  #$52                 ; 9338
         bne  L933E                ; 933A

* write a sector from $9431 (SIO P) ------------------------
IO_WRSEC
         lda  #$50                 ; 933C
L933E
         sta  DCOMND               ; 933E
         lda  #$01                 ; 9341
         sta  DUNIT                ; 9343
         lda  #$31                 ; 9346
         sta  DBUFLO               ; 9348
         lda  #$94                 ; 934B
         sta  DBUFHI               ; 934D
         jmp  DSKINV               ; 9350

* read a slot header and check it --------------------------
IO_CHKSLOT
         jsr  IO_SLOTSEC           ; 9353
         jsr  IO_RDSEC             ; 9356
         bpl  L935D                ; 9359
         sec                       ; 935B
         rts                       ; 935C
L935D
         lda  CONSOL               ; 935D
         lsr                       ; 9360
         lsr                       ; 9361
         bcs  L9368                ; 9362
         ldy  #$01                 ; 9364
         sec                       ; 9366
         rts                       ; 9367
L9368
         lsr                       ; 9368
         bcs  L936E                ; 9369
         ldy  #$01                 ; 936B
         rts                       ; 936D
L936E
         ldy  #$07                 ; 936E
L9370
         lda  $9431,y              ; 9370
         cmp  $9043,y              ; 9373
         beq  L9381                ; 9376
         cmp  $904B,y              ; 9378
         beq  L9381                ; 937B
         ldy  #$01                 ; 937D
         sec                       ; 937F
         rts                       ; 9380
L9381
         dey                       ; 9381
         bpl  L9370                ; 9382
         ldy  #$01                 ; 9384
         clc                       ; 9386
         rts                       ; 9387

* format the disk (SIO command $22) ------------------------
IO_FORMAT
         lda  #$01                 ; 9388
         sta  DUNIT                ; 938A
         lda  #$22                 ; 938D
         sta  DCOMND               ; 938F
         lda  #$40                 ; 9392
         sta  DSTATS               ; 9394
         lda  #$F6                 ; 9397
         sta  DTIMLO               ; 9399
         lda  #$31                 ; 939C
         sta  DBUFLO               ; 939E
         lda  #$94                 ; 93A1
         sta  DBUFHI               ; 93A3
         jmp  SIOV                 ; 93A6
         dta $00,$03,$A9,$93,$C0,$35,$A9,$AF,$8D,$0A,$03,$A9,$80,$85,$BF,$20 ; 93A9
         dta $FD,$93,$A9,$08,$85,$BF,$A0,$00,$8C,$CA,$93,$20,$FD,$93,$30,$12 ; 93B9
         dta $A0,$C9,$99,$B8,$00,$C8,$C0,$04,$90,$EE,$A5,$B8,$05,$B9,$D0,$04 ; 93C9
         dta $18,$60,$38,$60,$20,$FD,$93,$30,$F9,$A0,$00,$91,$B8,$A5,$B9,$C5 ; 93D9
         dta $BB,$D0,$08,$A5,$B8,$C5,$BA,$D0,$02,$F0,$CB,$E6,$B8,$D0,$02,$E6 ; 93E9
         dta $B9,$4C,$DD,$93,$18,$A4,$BF,$10,$26,$A9,$52,$8D,$02,$03,$A9,$01 ; 93F9
         dta $8D,$01,$03,$A9,$31,$8D,$04,$03,$A9,$94,$8D,$05,$03,$20,$53,$E4 ; 9409
         dta $10,$01,$60,$EE,$0A,$03,$D0,$03,$EE,$0B,$03,$A0,$00,$84,$BF,$B9 ; 9419
         dta $31,$94,$E6,$BF,$A0,$01,$60,$00          ; 9429
