; Jaskiniowiec (1995, StanBit) - memory image of the game rebuilt from blocks
; Output is a segment file matching game.bin, not a runnable executable.

         icl "src/JOINT.ASM"


         opt h-
         ins "src/SYSTEM.DTA"       ; $0000-$04FF zero page, stack, OS variables at snapshot time
         ins "src/D0500.DTA"        ; $0500-$17FF data
         ins "src/D1800.DTA"        ; $1800-$24FF data
         ins "src/D2500.DTA"        ; $2500-$2F7F data (32-byte records)
         ins "src/LEVELS.DTA"       ; $2F80-$61FF level tile maps

         opt h+
         icl "src/TRAINER.ASM"      ; $6200-$646F CAMOsoft crack stub and trainer

         opt h-
         ins "src/D6470.DTA"        ; $6470-$6BFF character screen
         ins "src/FONT6C.FNT"       ; $6C00-$6FFF font
         ins "src/D7000.DTA"        ; $7000-$7BFF data

         opt h+
         icl "src/CODE7C.ASM"       ; $7C00-$8DEF code and tables
         icl "src/MAIN.ASM"         ; $8DF0-$9FFF game entry ($8E67), NMI/IRQ/VBI handlers
         icl "src/CODEA0.ASM"       ; $A000-$BBFF code, display list ($ACFC)
         icl "src/START.ASM"        ; $BC00-$BFFF start stub ($BC00) and tables

         opt h-
         ins "src/TABLES.DTA"       ; $C000-$C9FF tables (bit reverse at $C000)
         ins "src/MUSIC.CMC"        ; $EA00-$F2E0 CMC music module

         opt h+
         icl "src/CMC.ASM"          ; $F2E1-$FAD1 CMC music player
         icl "src/VECTORS.ASM"      ; $FFFA-$FFFF NMI, RESET, IRQ vectors
