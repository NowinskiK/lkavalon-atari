; Robbo Konstruktor with the copy protection switched off (PROTECTION.md).
; The program itself is main.asm, unchanged (byte-exact with game.bin); this file adds two segments:
; 1. the trap in ELEM_MSG_: "jsr PLANET_CLR" at $9CF7 (20 DB 97) becomes three NOPs, so showing the wall "murek" in
;    the palette no longer erases the planet, whatever PROT_SUM holds;
; 2. the boot-loader check in ASK_YESNO_ (PROT_BOOT $B47D): its one-shot flag, the operand of "lda #$00", is set to
;    $80, so the check is skipped and never patches COUNT_ELEM_ ("za duzo robocikow!" after the first yes/no question).
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
