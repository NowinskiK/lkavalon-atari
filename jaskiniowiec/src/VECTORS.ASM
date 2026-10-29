; VECTORS.ASM - NMI, RESET, IRQ vectors
; $FFFA-$FFFF

         org $FFFA

         dta a(NMI_HND)                               ; NMI
         dta a($9EC7)                                 ; RESET
         dta a(IRQ_HND)                               ; IRQ
