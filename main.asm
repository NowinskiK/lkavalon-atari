     OPT h+
     .local
     ICL "d1/R1.ASM"
     .endl

     .local
     ICL "d1/TITLE.ASM"
     .endl

     ORG $2E0
     DTA A($3800)

     OPT h-
     INS "d2/C1.OBJ"
     INS "d2/C2.OBJ"
     INS "d2/C3.OBJ"
     INS "d2/M.FNT"
     INS "d2/S.FNT"
     INS "d2/F.FNT"
     INS "d2/I.FNT"


