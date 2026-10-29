; Jaskiniowiec (1995, StanBit) - memory image of the game rebuilt from blocks
; Output is a segment file matching game.bin, not a runnable executable.

         icl "src/JOINT.ASM"


         opt h-
         ins "src/SYSTEM.DTA"       ; $0000-$04FF zero page, stack, OS variables at snapshot time
         ins "src/D0500.DTA"        ; $0500-$07FF unknown (loader leftovers?)
         ins "src/FONT08.FNT"       ; $0800-$0FFF level font A (copied to $D800/$E000 by $9221)
         ins "src/FONT10.FNT"       ; $1000-$17FF level font B (copied by $9239)
         ins "src/FONT18.FNT"       ; $1800-$1FFF text screens font (copied by $9215)
         ins "src/SHAPES.DTA"       ; $2000-$27FF sprite shapes, 64 frames x 32 bytes
         ins "src/D2800.DTA"        ; $2800-$2FFF unknown; $2C00-$2EFF is the ending work area
         ins "src/MAP30.DTA"        ; $3000-$39FF level 1 map (10 rows x 256)
         ins "src/MAP3A.DTA"        ; $3A00-$43FF level 3 map
         ins "src/MAP44.DTA"        ; $4400-$4DFF level 5 map
         ins "src/MAP4E.DTA"        ; $4E00-$57FF level 4 map
         ins "src/MAP58.DTA"        ; $5800-$61FF level 6 map

         opt h+
         icl "src/TRAINER.ASM"      ; $6200-$646F CAMOsoft crack stub and trainer, over level 2 map rows 0-2

         opt h-
         ins "src/MAP62.DTA"        ; $6470-$6BFF level 2 map (rest)
         ins "src/FONT6C.FNT"       ; $6C00-$6FFF status line font
         ins "src/TILES.DTA"        ; $7000-$70FF tile attributes (read by $8DF0)
         ins "src/PICTURE.DTA"      ; $7100-$7BFF mode E picture above the playfield

         opt h+
         icl "src/SPRITE.ASM"       ; $7C00-$8873 software sprite engine, double-buffered screen
         icl "src/DLI.ASM"          ; $8874-$8A4C DLI chain ($8874), display lists ($8974, $89D8)
         icl "src/PLAYER.ASM"       ; $8A4D-$8DEF player control (deferred VBI $8A8F), music on/off
         icl "src/MAIN.ASM"         ; $8DF0-$9026 status line, game entry ($8E67), main loop, screen flip, map drawing
         icl "src/ENEMY.ASM"        ; $9027-$9214 enemies: movement and spawning
         icl "src/INIT.ASM"         ; $9215-$948E font copy, init tables, variables ($9349-$93C6), table builder
         icl "src/ROOMS.ASM"        ; $948F-$96C7 player map probe ($948F), cave rooms
         icl "src/FADE.ASM"         ; $96C8-$9795 colour fades
         icl "src/ITEMS.ASM"        ; $9796-$99FF enemy contact, energy and lives, treasures
         icl "src/LEVEL.ASM"        ; $9A00-$9E96 level loaders, text screens, scroller, level completion
         icl "src/IRQ.ASM"          ; $9E97-$9FDA NMI, IRQ, VBI (cheat code at $9F75)

         opt h-
         ins "src/TEXTS.DTA"        ; $9FDB-$A4E8 cave room screen, status line, text pages
         ins "src/LEVELDAT.DTA"     ; $A4E9-$AB7C per-level tables: treasures, enemies, cave rooms

         opt h+
         icl "src/ENDING.ASM"       ; $AB7D-$B4ED ending sequence, its DLI and display list ($ACFC)

         opt h-
         ins "src/MUSCOPY.DTA"      ; $B4EE-$BBFF unused copy of MUSIC.CMC with XEX header

         opt h+
         icl "src/SCREEN.ASM"       ; $BC00-$BFFF playfield screen memory (2 buffers); crack start stub at $BC00

         opt h-
         ins "src/TABLES.DTA"       ; $C000-$C9FF mirror/mask tables, current level data, shape pointers
         ins "src/MUSIC.CMC"        ; $EA00-$F2E0 CMC music module

         opt h+
         icl "src/CMC.ASM"          ; $F2E1-$FAD1 CMC music player
         icl "src/VECTORS.ASM"      ; $FFFA-$FFFF NMI, RESET, IRQ vectors
