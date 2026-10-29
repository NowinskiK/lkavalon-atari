; PALETTE.ASM - tables: character codes $B4F9, palette codes $B51C, element glyphs $B55A
; $B4F9-$B5FF

         org $B4F9


* palette and characters -------
CHR_FROM         dta $40,$2F,$2A,$01,$03,$05,$0C,$0E,$0F,$13,$1A,$A0 ; B4F9 ATASCII codes with a glyph of their own (Polish letters, @ / *); $A0 ends
CHR_TO           dta $2F,$3F,$00,$40,$5B,$5C,$5D,$5E,$5F,$7B,$7C ; B505 their screen codes in the font $4C00
RPT_FIRST        dta $10                              ; B510 auto-repeat: frames before the first repeat
RPT_NEXT         dta $03                              ; B511 auto-repeat: frames between repeats
IN_KEYS          dta $00,$07,$06,$0E,$0F              ; B512 key codes of the cursor keys -> <- up down (entries 1-4)
IN_DIRS          dta $00,$08,$04,$01,$02              ; B517 direction bits for no key and for IN_KEYS 1-4 (inverted into IN_DIR)
PAL_CODES        dta $2A,$24,$14,$23,$12,$06,$21,$25,$40,$28,$26,$29,$00,$3D,$13,$20,$41,$45,$3F,$2E,$0E,$A0,$78,$78,$78,$78,$78,$78,$78,$78 ; B51C the palette, entries 0-29: element codes (Robbo level characters); 22-29 from PAL_SETS
PAL_SETS         dta $4E,$4A,$1F,$3E,$01,$31,$32,$33,$4D,$4C,$1D,$22,$17,$34,$35,$36,$4E,$49,$1E,$3C,$04,$31,$32,$33,$4D,$4B,$1C,$5E,$18,$34,$35,$36 ; B53A palette entries 22-29: 4 sets of 8 (guns, bats, teleports), chosen by entry 21
GLYPHS           dta $3A,$24,$1B,$A7,$29,$00,$02,$00,$25,$26,$22,$00,$00,$00,$3C,$00,$00,$B2,$B3,$B4,$B5,$B6,$B7,$00,$00,$00,$00,$00,$1E,$30,$18,$28,$01,$04,$04,$04,$04,$06,$06,$06,$06,$0E,$0A,$08,$0C,$90,$92,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$15,$00,$BE,$19,$00,$00,$1F,$00,$27,$00,$00,$00,$00,$00,$00,$00,$BB,$00,$00,$00,$B8,$3D,$20,$00,$00,$1C,$16,$00,$00,$00,$14,$1A,$1D,$17 ; B55A element code - $20 -> glyph g: a cell is drawn as characters 2g, 2g+1 / 2g+$40...
PAL_SET          dta $00                              ; B5BA palette set shown in entries 22-29 (bits 0-1), +1 by entry 21
BLINK_CNT        dta $00                              ; B5BB cursor blink counter: 0 after a move, bit 2 = phase
PM_HPOS          dta $10,$B0,$D1                      ; B5BC start positions of players 0-2
FRAME_COL        dta $00                              ; B5BF colour bits of the cursor frame ($AA)
FRAME_MASK       dta $FF,$FF,$C0,$C0,$C0,$C0,$C0,$C0,$FF,$FF,$03,$03,$03,$03,$03,$03,$C0,$C0,$C0,$C0,$C0,$C0,$FF,$FF,$03,$03,$03,$03,$03,$03,$FF,$FF ; B5C0 cursor frame around the selected element (characters $7E-$7F, both fonts)
STRIP_CHR        dta $AA,$55,$AA,$55,$5F,$58,$59,$54,$5E,$58,$58,$54,$5D,$58,$58,$5B,$58,$58,$5A,$54,$57,$58,$59,$54,$56,$58,$58,$54,$55,$58,$58,$5B ; B5E0 scroll bar beside the board: 8 x 4 characters
