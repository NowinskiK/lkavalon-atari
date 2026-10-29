; VECTORS.ASM - NMI, RESET, IRQ vectors
; $FFFA-$FFFF

         org $FFFA

         dta a(entry_9EAE)                            ; NMI
         dta a($9EC7)                                 ; RESET
         dta a(entry_9EC8)                            ; IRQ
