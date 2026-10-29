; DISKIO.ASM - tape / disk: planet sets in 5 slots, format, saving the stand-alone game
; $9000-$9430

         org $9000


* tape/disk: command letter in A (r, w, e, d - IO_LETTERS), X = slot; dispatch via IO_JUMPS ---
IO_CMD
         jmp  L9004                ; 9000

* tape / disk ------------------
IO_LOADED        dta $00                              ; 9003 $FF after a set was read (IO_READ), 0 at each command
L9004
         stx  IO_SLOT              ; 9004
         ldx  #$03                 ; 9007
L9009
         cmp  IO_LETTERS,x         ; 9009
         beq  L9011                ; 900C
         dex                       ; 900E
         bpl  L9009                ; 900F
L9011
         txa                       ; 9011
         asl                       ; 9012
         tax                       ; 9013
         lda  IO_JUMPS,x           ; 9014
         sta  IO_GO+1              ; 9017
         lda  IO_JUMPS+1,x         ; 901A
         sta  IO_GO+2              ; 901D
         lda  #$80                 ; 9020
         sta  BRKKEY               ; 9022
         asl                       ; 9024
         sta  IO_LOADED            ; 9025
IO_GO
         jmp  IO_GO                ; 9028
IO_LETTERS       dta $72,$77,$65,$64                  ; 902B command letters: r(ead) w(rite) e(rase) d(irectory)
IO_JUMPS         dta $02,$91,$BF,$91,$9C,$90,$5A,$90  ; 902F IO_READ, IO_WRITE, IO_ERASE, IO_DIR
SLOT_SEC         dta $04,$00,$00,$01,$84,$01,$08,$02,$8C,$02,$10,$03 ; 9037 header sector of slots 0-5: 4, 256, 388, 520, 652, 784
SIG_USED                                              ; 9043 slot header of a used slot
;  RKdata 
         dta c' RKdata '* ; 9043
SIG_FREE                                              ; 904B slot header of an erased slot
;  unused 
         dta c' unused ' ; 904B
IO_USED          dta $00                              ; 9053 bit mask of the used slots (IO_DIR), returned in A
SLOT_BIT         dta $00,$01,$02,$04,$08,$10          ; 9054 bit of slots 1-5 in IO_USED

* directory: read the 5 slot headers, bit mask of used slots ---
IO_DIR
         lda  #$00                 ; 905A
         sta  IO_PTR               ; 905C
         ldx  #$05                 ; 905E
         stx  IO_SLOT              ; 9060
L9063
         jsr  IO_SLOTSEC           ; 9063
         jsr  IO_RDSEC             ; 9066
         bmi  L9080                ; 9069
         clc                       ; 906B
         lda  IO_BUF               ; 906C
         bpl  L9072                ; 906F
         sec                       ; 9071
L9072
         rol  IO_PTR               ; 9072
         dec  IO_SLOT              ; 9074
         bne  L9063                ; 9077
         lda  IO_PTR               ; 9079
         sta  IO_USED              ; 907B
         ldy  #$01                 ; 907E
L9080
         php                       ; 9080
         lda  IO_USED              ; 9081
         plp                       ; 9084
         rts                       ; 9085

* header sector of slot IO_SLOT -> DAUX (SLOT_SEC: sectors 4, 256, 388, 520, 652, 784) ---
IO_SLOTSEC
         lda  IO_SLOT              ; 9086
         asl                       ; 9089
         tax                       ; 908A
         lda  SLOT_SEC,x           ; 908B
         sta  DAUX1                ; 908E
         lda  SLOT_SEC+1,x         ; 9091
         sta  DAUX2                ; 9094
         lda  #$08                 ; 9097
         sta  IO_POS               ; 9099
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
         lda  SIG_FREE,x           ; 90B8
         sta  IO_BUF,x             ; 90BB
         dex                       ; 90BE
         bpl  L90B8                ; 90BF
         jsr  IO_WRSEC             ; 90C1
         bmi  L90D6                ; 90C4
         ldx  IO_SLOT              ; 90C6
         lda  SLOT_BIT,x           ; 90C9
         eor  #$FF                 ; 90CC
         and  IO_USED              ; 90CE
         sta  IO_USED              ; 90D1
         ldy  #$01                 ; 90D4
L90D6
         php                       ; 90D6
         lda  IO_USED              ; 90D7
         plp                       ; 90DA
         rts                       ; 90DB

* mark a slot used: header " RKdata " ----------------------
IO_MARK
         jsr  IO_SLOTSEC           ; 90DC
         jsr  IO_RDSEC             ; 90DF
         bmi  L90D6                ; 90E2
         ldx  #$07                 ; 90E4
L90E6
         lda  SIG_USED,x           ; 90E6
         sta  IO_BUF,x             ; 90E9
         dex                       ; 90EC
         bpl  L90E6                ; 90ED
         jsr  IO_WRSEC             ; 90EF
         bmi  L90D6                ; 90F2
         ldx  IO_SLOT              ; 90F4
         lda  SLOT_BIT,x           ; 90F7
         ora  IO_USED              ; 90FA
         sta  IO_USED              ; 90FD
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
         sta  IO_LOADED            ; 9121
         inc  DAUX1                ; 9124
         bne  L912C                ; 9127
         inc  DAUX2                ; 9129
L912C
         jsr  IO_LOADSET           ; 912C
L912F
         php                       ; 912F
         lda  IO_USED              ; 9130
         plp                       ; 9133
         rts                       ; 9134

* load the planets of a set --------------------------------
IO_LOADSET
         ldy  #$00                 ; 9135
L9137
         sty  LS_IDX+1             ; 9137
         jsr  IO_GETBYTE           ; 913A
         bmi  L912F                ; 913D
LS_IDX
         ldy  #$3F                 ; 913F
         dta $99,a(IO_PTR)         ; 9141 sta ,y
         iny                       ; 9144
         cpy  #$04                 ; 9145
         bcc  L9137                ; 9147
         jsr  IO_CHECK             ; 9149
         bcc  L915A                ; 914C
         ldy  #$8F                 ; 914E
         lda  IO_PTR               ; 9150
         ora  IO_PTR+1             ; 9152
         bne  L9158                ; 9154
         ldy  #$01                 ; 9156
L9158
         tya                       ; 9158
         rts                       ; 9159
L915A
         jsr  IO_GETBYTE           ; 915A
         bmi  L912F                ; 915D
         ldy  #$00                 ; 915F
         sta  (IO_PTR),y           ; 9161
         lda  IO_PTR+1             ; 9163
         cmp  IO_END+1             ; 9165
         bne  L9171                ; 9167
         lda  IO_PTR               ; 9169
         cmp  IO_END               ; 916B
         bne  L9171                ; 916D
         beq  IO_LOADSET           ; 916F
L9171
         inc  IO_PTR               ; 9171
         bne  L9177                ; 9173
         inc  IO_PTR+1             ; 9175
L9177
         jmp  L915A                ; 9177

* check the loaded set ("ten zestaw planet jest zniszczony") ---
IO_CHECK
         ldx  #$08                 ; 917A
L917C
         lda  IO_PTR               ; 917C
         cmp  IO_RANGES,x          ; 917E
         lda  IO_PTR+1             ; 9181
         sbc  IO_RANGES+1,x        ; 9183
         bcc  L91AB                ; 9186
         lda  IO_PTR               ; 9188
         cmp  IO_RANGES+2,x        ; 918A
         lda  IO_PTR+1             ; 918D
         sbc  IO_RANGES+3,x        ; 918F
         bcs  L91AB                ; 9192
         lda  IO_END               ; 9194
         cmp  IO_RANGES+2,x        ; 9196
         lda  IO_END+1             ; 9199
         sbc  IO_RANGES+3,x        ; 919B
         bcs  L91AB                ; 919E
         lda  IO_PTR               ; 91A0
         cmp  IO_END               ; 91A2
         lda  IO_PTR+1             ; 91A4
         sbc  IO_END+1             ; 91A6
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
IO_RANGES        dta $A0,$39,$E0,$39,$00,$3A,$00,$3C,$00,$50,$00,$90 ; 91B3 segments a set may load (IO_CHECK): $39A0-$39E0, $3A00-$3C00, $5000-$9000

* write a planet set to a slot; slot 0: the stand-alone game ("zapisz Robbo") ---
IO_WRITE
         lda  IO_SLOT              ; 91BF
         bne  L91EC                ; 91C2
         lda  #$01                 ; 91C4
         sta  IO_SLOT              ; 91C6
         jsr  IO_CHKSLOT           ; 91C9
         bmi  L91D6                ; 91CC
         bcs  L91D6                ; 91CE
         lda  IO_USED              ; 91D0
         ldy  #$FF                 ; 91D3
         rts                       ; 91D5
L91D6
         jsr  IO_MSG               ; 91D6
         dec  IO_SLOT              ; 91D9
         jsr  IO_SLOTSEC           ; 91DC
         lda  DAUX1                ; 91DF
         sta  GB_SECTOR            ; 91E2
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
         lda  IO_USED              ; 9202
         plp                       ; 9205
         rts                       ; 9206

* save the segments of LIST_SET (slot 0: LIST_GAME), then the used planets: $5000 + n * $200, $1F8 bytes each ---
IO_SAVESET
         ldx  #$EB                 ; 9207
         ldy  #$92                 ; 9209
         lda  IO_SLOT              ; 920B
         beq  L9214                ; 920E
         ldx  #$E1                 ; 9210
         ldy  #$92                 ; 9212
L9214
         stx  SS_LIST+1            ; 9214
         sty  SS_LIST+2            ; 9217
         ldx  #$00                 ; 921A
         stx  SS_POS+1             ; 921C
SS_POS
         ldx  #$1F                 ; 921F
         ldy  #$00                 ; 9221
SS_LIST
         lda  SS_LIST,x            ; 9223
         dta $99,a(IO_PTR)         ; 9226 sta ,y
         inx                       ; 9229
         iny                       ; 922A
         cpy  #$04                 ; 922B
         bcc  SS_LIST              ; 922D
         stx  SS_POS+1             ; 922F
         lda  IO_PTR               ; 9232
         ora  IO_PTR+1             ; 9234
         beq  L923F                ; 9236
         jsr  IO_PUTRANGE          ; 9238
         bmi  L9201                ; 923B
         bpl  SS_POS               ; 923D
L923F
         ldx  #$1F                 ; 923F
L9241
         stx  SS_PLANET+1          ; 9241
         lda  PLANET_STATE,x       ; 9244
         beq  SS_PLANET            ; 9247
         txa                       ; 9249
         asl                       ; 924A
         adc  #$50                 ; 924B
         sta  IO_PTR+1             ; 924D
         ora  #$01                 ; 924F
         sta  IO_END+1             ; 9251
         lda  #$00                 ; 9253
         sta  IO_PTR               ; 9255
         lda  #$F7                 ; 9257
         sta  IO_END               ; 9259
         jsr  IO_PUTRANGE          ; 925B
         bmi  L9201                ; 925E
SS_PLANET
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
         sty  PR_IDX+1             ; 9278
         dta $B9,a(IO_PTR)         ; 927B lda ,y
         jsr  IO_PUTBYTE           ; 927E
         bpl  PR_IDX               ; 9281
         jmp  L9201                ; 9283
PR_IDX
         ldy  #$86                 ; 9286
         iny                       ; 9288
         cpy  #$04                 ; 9289
         bcc  L9278                ; 928B

* write the bytes IO_PTR ... IO_END (without the segment header) ---
IO_PUTDATA
         ldy  #$00                 ; 928D
         lda  (IO_PTR),y           ; 928F
         jsr  IO_PUTBYTE           ; 9291
         bpl  L9299                ; 9294
         jmp  L9201                ; 9296
L9299
         lda  IO_PTR+1             ; 9299
         cmp  IO_END+1             ; 929B
         bne  L92A8                ; 929D
         lda  IO_PTR               ; 929F
         cmp  IO_END               ; 92A1
         bne  L92A8                ; 92A3
         ldy  #$01                 ; 92A5
         rts                       ; 92A7
L92A8
         inc  IO_PTR               ; 92A8
         bne  L92AE                ; 92AA
         inc  IO_PTR+1             ; 92AC
L92AE
         jmp  IO_PUTDATA           ; 92AE

* stand-alone game: format the disk, write its boot loader GB_HDR ... $942F to sectors 1-3 ---
IO_SAVEGAME
         jsr  IO_FORMAT            ; 92B1
         bmi  L92DB                ; 92B4
         ldx  #$01                 ; 92B6
         stx  DAUX1                ; 92B8
         dex                       ; 92BB
         stx  DAUX2                ; 92BC
         lda  #$00                 ; 92BF
         sta  IO_POS               ; 92C1
         lda  #$A9                 ; 92C3
         sta  IO_PTR               ; 92C5
         lda  #$93                 ; 92C7
         sta  IO_PTR+1             ; 92C9
         lda  #$2F                 ; 92CB
         sta  IO_END               ; 92CD
         lda  #$94                 ; 92CF
         sta  IO_END+1             ; 92D1
         jsr  IO_PUTDATA           ; 92D3
         bmi  L92DB                ; 92D6
         jsr  IO_WRSEC             ; 92D8
L92DB
         php                       ; 92DB
         lda  IO_USED              ; 92DC
         plp                       ; 92DF
         rts                       ; 92E0
LIST_SET         dta $A0,$39,$DF,$39,$00,$3A,$FF,$3B,$00,$00 ; 92E1 segments of a planet set: planet tables $39A0-$39DF, title texts $3A00-$3BFF; 0 ends
LIST_GAME        dta $00,$1E,$FF,$3F,$00,$48,$FF,$4F,$00,$00 ; 92EB segments of the stand-alone game: engine $1E00-$3FFF, fonts $4800-$4FFF; 0 ends

* read one byte through the sector buffer IO_BUF -----------
IO_GETBYTE
         clc                       ; 92F5
         ldy  IO_POS               ; 92F6
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
         sty  IO_POS               ; 930A
L930C
         lda  IO_BUF,y             ; 930C
         inc  IO_POS               ; 930F
         ldy  #$01                 ; 9311
         rts                       ; 9313

* write one byte through the sector buffer IO_BUF ----------
IO_PUTBYTE
         clc                       ; 9314
         ldy  IO_POS               ; 9315
         bpl  L9330                ; 9317
         sta  PB_BYTE+1            ; 9319
         jsr  IO_WRSEC             ; 931C
         bpl  L9322                ; 931F
         rts                       ; 9321
L9322
         inc  DAUX1                ; 9322
         bne  PB_BYTE              ; 9325
         inc  DAUX2                ; 9327
PB_BYTE
         lda  #$2A                 ; 932A
         ldy  #$00                 ; 932C
         sty  IO_POS               ; 932E
L9330
         sta  IO_BUF,y             ; 9330
         inc  IO_POS               ; 9333
         ldy  #$01                 ; 9335
         rts                       ; 9337

* read a sector into IO_BUF (SIO R) ------------------------
IO_RDSEC
         lda  #$52                 ; 9338
         bne  L933E                ; 933A

* write a sector from IO_BUF (SIO P) -----------------------
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
         lda  IO_BUF,y             ; 9370
         cmp  SIG_USED,y           ; 9373
         beq  L9381                ; 9376
         cmp  SIG_FREE,y           ; 9378
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
GB_HDR           dta $00,$03,$A9,$93,$C0,$35          ; 93A9 boot record of the saved game: flags, 3 sectors, load $93A9, init TP_START

* boot of the saved stand-alone game (OS: load address + 6): segments from sector GB_SECTOR, after the 8-byte slot header; RTS at start 0, then the OS runs TP_START ---
GB_BOOT
GB_SECTOR        equ *+1                              ; 93B0 first data sector (IO_WRITE: the header sector of slot 0)
         lda  #$AF                 ; 93AF
         sta  DAUX1                ; 93B1
         lda  #$80                 ; 93B4
         sta  IO_POS               ; 93B6
         jsr  GB_GETBYTE           ; 93B8
         lda  #$08                 ; 93BB
         sta  IO_POS               ; 93BD
L93BF
         ldy  #$00                 ; 93BF
L93C1
         sty  GB_IDX+1             ; 93C1
         jsr  GB_GETBYTE           ; 93C4
         bmi  L93DB                ; 93C7
GB_IDX
         ldy  #$C9                 ; 93C9
         dta $99,a(IO_PTR)         ; 93CB sta ,y
         iny                       ; 93CE
         cpy  #$04                 ; 93CF
         bcc  L93C1                ; 93D1
         lda  IO_PTR               ; 93D3
         ora  IO_PTR+1             ; 93D5
         bne  L93DD                ; 93D7
         clc                       ; 93D9
         rts                       ; 93DA
L93DB
         sec                       ; 93DB
         rts                       ; 93DC
L93DD
         jsr  GB_GETBYTE           ; 93DD
         bmi  L93DB                ; 93E0
         ldy  #$00                 ; 93E2
         sta  (IO_PTR),y           ; 93E4
         lda  IO_PTR+1             ; 93E6
         cmp  IO_END+1             ; 93E8
         bne  L93F4                ; 93EA
         lda  IO_PTR               ; 93EC
         cmp  IO_END               ; 93EE
         bne  L93F4                ; 93F0
         beq  L93BF                ; 93F2
L93F4
         inc  IO_PTR               ; 93F4
         bne  L93FA                ; 93F6
         inc  IO_PTR+1             ; 93F8
L93FA
         jmp  L93DD                ; 93FA

* boot of the saved game: next byte of the data sectors (own copy of IO_GETBYTE, DSKINV) ---
GB_GETBYTE
         clc                       ; 93FD
         ldy  IO_POS               ; 93FE
         bpl  L9428                ; 9400
         lda  #$52                 ; 9402
         sta  DCOMND               ; 9404
         lda  #$01                 ; 9407
         sta  DUNIT                ; 9409
         lda  #$31                 ; 940C
         sta  DBUFLO               ; 940E
         lda  #$94                 ; 9411
         sta  DBUFHI               ; 9413
         jsr  DSKINV               ; 9416
         bpl  L941C                ; 9419
         rts                       ; 941B
L941C
         inc  DAUX1                ; 941C
         bne  L9424                ; 941F
         inc  DAUX2                ; 9421
L9424
         ldy  #$00                 ; 9424
         sty  IO_POS               ; 9426
L9428
         lda  IO_BUF,y             ; 9428
         inc  IO_POS               ; 942B
         ldy  #$01                 ; 942D
         rts                       ; 942F
IO_SLOT          dta $00                              ; 9430 slot (X of IO_CMD): 1-5 planet sets, 0 = the stand-alone game
