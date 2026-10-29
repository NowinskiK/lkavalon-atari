; Robbo Konstruktor, fixed version: copy protection switched off (PROTECTION.md), help page 15 replaced and the
; keyboard of the title-page text editor fixed.
; Problem reported in: https://atarionline.pl/forum/comments.php?DiscussionID=3815
; The program itself is main.asm, unchanged (byte-exact with game.bin); this file adds these changes:
; 1. the trap in ELEM_MSG_: "jsr PLANET_CLR" at $9CF7 (20 DB 97) becomes three NOPs, so showing the wall "murek" in
;    the palette no longer erases the planet, whatever PROT_SUM holds;
; 2. the boot-loader check in ASK_YESNO_ (PROT_BOOT $B47D): its one-shot flag, the operand of "lda #$00", is set to
;    $80, so the check is skipped and never patches COUNT_ELEM_ ("za duzo robocikow!" after the first yes/no question);
; 3. help page 15, Avalon's notice that a faulty copy is illegal, replaced by a note about this version;
; 4. the title-page text editor read key codes through the XL ROM's keyboard table at a fixed address ($FB51), so
;    under any other OS (AltirraOS, OS-B) keys gave wrong letters; it now uses the OS pointer KEYDEF ($79), which
;    the XL ROM sets to $FB51 itself.
; Build: "$MADS" nocopyprot.asm -o:bin/nocopyprot.obx, then util/mkatr.py writes it onto a copy of the disk,
; bin/Robbo Konstruktor (1990)(L.K. Avalon)(PL)[cr CAMOsoft 2026].atr
; (VS Code task "Robbo Konstruktor: run build (protection off)").

         icl "main.asm"

         opt h+
         org $9CF7                 ; in ELEM_MSG_, after "lda HDR_BUF+4,x / beq L9CFA"
         nop                       ; was: jsr PLANET_CLR
         nop
         nop

         org $B47E                 ; PROT_BOOT: "lda #$00 / bmi" - the one-shot flag
         dta $80                   ; was $00: already done, skip the check

         org $08B6                 ; help screen, bottom panel (HELPVIEW.ASM): lines 4 and 5 of the credits
; screen codes, exactly 40 characters per line (the display list shows 40 bytes from $083E, $0866, ... $08DE);
; "/" is the (c) sign of the font at $4C00. Edit the text between the quotes, keep the length - ert checks it.
         dta d' /1990 Laboratorium Komputerowe Avalon  ' ; 08B6
         ert *<>$08DE              ; line 4 must be 40 characters
         dta d'  Fixed version:  Oct 2026 by CAMOsoft  ' ; 08DE
         ert *<>$0906              ; line 5 must be 40 characters

         org $B210                 ; TITLE_ED_: key from CH into Y instead of X ...
         ldy  CH                   ; was: ldx CH
         cpy  #$FF                 ; was: cpx #$FF  (followed by beq / lda #$FF / sta CH)
         org $B21C                 ; ... and the character through the OS table pointer
         lda  ($79),y              ; was: lda $FB51,x  - KEYDEF, the XL OS keyboard table pointer
         nop                       ; (keeps the next instruction at $B21F)

         org $1CD7                 ; help page 15 (after its marker $00 $0F): the new text
; a character with bit 7 (c'x'*) ends its line, $A0 = an empty line; util/helppage.py shows the page
;
         dta $A0
         dta $A0
;  Program Robbo Konstruktor został
         dta c'Program Robbo Konstruktor zosta',$8C
;  przetestowany w firmie Avalon.
         dta c'przetestowany w firmie Avalon',c'.'*
;
         dta $A0
;  W tej wersji usunięto
         dta c'W tej wersji usuni',$05,c't',c'o'*
;  zabezpieczenia objawiające się
         dta c'zabezpieczenia objawiaj',$01,c'ce si',$85
;  jak błędy w działaniu programu.
         dta c'jak b',$0C,$05,c'dy w dzia',$0C,c'aniu programu',c'.'*
;
         dta $A0
         dta $A0
;  Fixed version:
         dta c'Fixed version',c':'*
;  2026 by CAMOsoft
         dta c'2026 by CAMOsof',c't'*
;  Kamil Nowinski
         dta c'Kamil Nowinski'
         dta $80,$00               ; end of the last page, as in the original
:$1DD1-* dta $00                   ; rest of the old text, up to and including $1DD0: zeros, as after the original end
