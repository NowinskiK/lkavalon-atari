; Robbo Konstruktor (1990, L.K. Avalon) - memory image of the program rebuilt from blocks
; Output is a segment file matching game.bin, not a runnable executable.

         icl "src/JOINT.ASM"


         opt h-
         ins "src/RUNAD.DTA"        ; $02E0-$02E1 RUNAD = $A810

         opt h+
         icl "src/HOOK.ASM"         ; $0480-$0482 restart hook: JMP $A810
         icl "src/BOOT.ASM"         ; $0500-$067F boot sectors 1-3: boot record and binary-file loader (cracked)
         icl "src/EDIT08.ASM"       ; $0800-$0C6C code: JMP $09A6 at $0800, tables, routines

         opt h-
         ins "src/D0C6D.DTA"        ; $0C6D-$1DD0 data (4.4 KB, text-like)

         opt h+
         icl "src/ENGINE1.ASM"      ; $1E00-$23FC game engine: jump table $1E00, display list, DLIs
         icl "src/ENGINE2.ASM"      ; $243D-$35A3 game engine: object behaviour (table $31EF), VBI $2F54
         icl "src/ENGINE3.ASM"      ; $35C0-$395C game engine: display list, code

         opt h-
         ins "src/FONT3C.FNT"       ; $3C00-$3FFF font (modified Robbo F.FNT)
         ins "src/D4000.DTA"        ; $4000-$47FF data
         ins "src/FONT48.FNT"       ; $4800-$4BFF font (modified Robbo S.FNT)
         ins "src/FONT4C.FNT"       ; $4C00-$4FFF font (modified Robbo I.FNT)

         opt h+
         icl "src/EDIT90.ASM"       ; $9000-$9430 editor code
         icl "src/EDITOR.ASM"       ; $94E0-$9F7A editor: menu dispatch, cursor, commands

         opt h-
         ins "src/TEXTS.DTA"        ; $9F7B-$A808 editor tables and texts (menu table $9F8E)

         opt h+
         icl "src/EDITOR2.ASM"      ; $A810-$B5FF editor: jump table $A810, main loop, screen, DLI, text input

         opt h-
         ins "src/LOADSCR.DTA"      ; $BC40-$BC67 loading screen line "Robbo Konstruktor (C) 1990 Avalon"
