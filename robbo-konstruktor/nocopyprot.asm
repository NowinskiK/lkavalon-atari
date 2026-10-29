; Robbo Konstruktor with the copy protection switched off (PROTECTION.md).
; The program itself is main.asm, unchanged (byte-exact with game.bin); this file adds one segment that replaces
; the trap in ELEM_MSG_: "jsr PLANET_CLR" at $9CF7 (20 DB 97) becomes three NOPs, so showing the wall "murek" in the
; palette no longer erases the planet, whatever PROT_SUM holds.
; Build: "$MADS" nocopyprot.asm -o:bin/nocopyprot.obx, then util/mkatr.py writes it onto a copy of the disk
; (VS Code task "Robbo Konstruktor: run build (protection off)").

         icl "main.asm"

         opt h+
         org $9CF7                 ; in ELEM_MSG_, after "lda HDR_BUF+4,x / beq L9CFA"
         nop                       ; was: jsr PLANET_CLR
         nop
         nop
