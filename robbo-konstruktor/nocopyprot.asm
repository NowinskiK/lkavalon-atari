; Robbo Konstruktor with the copy protection switched off (PROTECTION.md).
; Problem reported in: https://atarionline.pl/forum/comments.php?DiscussionID=3815
; The program itself is main.asm, unchanged (byte-exact with game.bin); this file adds three segments:
; 1. the trap in ELEM_MSG_: "jsr PLANET_CLR" at $9CF7 (20 DB 97) becomes three NOPs, so showing the wall "murek" in
;    the palette no longer erases the planet, whatever PROT_SUM holds;
; 2. the boot-loader check in ASK_YESNO_ (PROT_BOOT $B47D): its one-shot flag, the operand of "lda #$00", is set to
;    $80, so the check is skipped and never patches COUNT_ELEM_ ("za duzo robocikow!" after the first yes/no question);
; 3. help page 15, Avalon's notice that a faulty copy is illegal, replaced by a note about this version.
; Build: "$MADS" nocopyprot.asm -o:bin/nocopyprot.obx, then util/mkatr.py writes it onto a copy of the disk
; (VS Code task "Robbo Konstruktor: run build (protection off)").

         icl "main.asm"

         opt h+
         org $9CF7                 ; in ELEM_MSG_, after "lda HDR_BUF+4,x / beq L9CFA"
         nop                       ; was: jsr PLANET_CLR
         nop
         nop

         org $B47E                 ; PROT_BOOT: "lda #$00 / bmi" - the one-shot flag
         dta $80                   ; was $00: already done, skip the check

         org $1CD7                 ; help page 15 (after its marker $00 $0F): the new text
; a character with bit 7 (c'x'*) ends its line, $A0 = an empty line; util/helppage.py shows the page
;
         dta $A0
         dta $A0
;  Program Robbo Konstruktor został
         dta c'Program Robbo Konstruktor zosta',$8C
;  przetestowany w firmie Avalon.
         dta c'przetestowany w firmie Avalon.'*
;
         dta $A0
;  W tej wersji usunięto
         dta c'W tej wersji usuni',$05,c'to'*
;  zabezpieczenia objawiające się
         dta c'zabezpieczenia objawiaj',$01,c'ce si',$85
;  jak błędy w działaniu programu.
         dta c'jak b',$0C,$05,c'dy w dzia',$0C,c'aniu programu.'*
;
         dta $A0
         dta $A0
;  Fixed version:
         dta c'Fixed version:'*
;  2026 by CAMOsoft
         dta c'2026 by CAMOsoft'*
;  Kamil Nowinski
         dta c'Kamil Nowinski'
         dta $80,$00               ; end of the last page, as in the original
