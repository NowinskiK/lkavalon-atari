; Robbo Konstruktor (1990, L.K. Avalon) - memory image of the program rebuilt from blocks
; Output is a segment file matching game.bin, not a runnable executable.

         icl "src/JOINT.ASM"


         opt h-
         ins "src/RUNAD.DTA"        ; $02E0-$02E1 RUNAD = $A810

         opt h+
         icl "src/HOOK.ASM"         ; $0480-$0482 restart hook: JMP $A810
         icl "src/BOOT.ASM"         ; $0500-$067F boot sectors 1-3: boot record and binary-file loader (cracked)
         icl "src/HELPVIEW.ASM"     ; $0800-$0C6C help viewer: screen (display list, credits panel), paging, line unpacking
         icl "src/HELPTEXT.ASM"     ; $0C6D-$1DD0 help text: 16 pages in Polish (HELP key), one screen line per dta: bit 7 = last character of the line
         icl "src/ENG_PLAY.ASM"     ; $1E00-$22CF engine: jump table, display list, info-line texts, DLIs, set-up, play loop, planet start (Robbo R1)
         icl "src/ENG_BOARD.ASM"    ; $22D0-$23FC engine: board primitives - step, test, read / write a cell, score, frame wait
         icl "src/ENG_SCRN.ASM"     ; $243D-$2581 engine: CHNMON - BREAK test, Robbo's step, animated shapes, board to screen
         icl "src/ENG_ROBBO.ASM"    ; $2582-$28EB engine: Robbo - creatures and magnets next to him, move, shoot, push, door / screw / exit
         icl "src/ENG_OBJ.ASM"      ; $28EC-$2F52 engine: object behaviours (table $31EF) - teleports, surprise, boxes, bomb, magnets, guns, bullets, creatures, bats, eyes, capsule
         icl "src/ENG_VBI.ASM"      ; $2F53-$3141 engine: VBI CVBL - info line, scrolling; input KEJO
         icl "src/ENG_TAB.ASM"      ; $3142-$3333 engine: input variables, shape table, NEXT, object table $31EF, WHAT
         icl "src/ENG_SND.ASM"      ; $3334-$35A3 engine: sound effects and their data
         icl "src/TITLEPG.ASM"      ; $35C0-$395C title page of the saved Robbo game (also "test Robbo"): display list, texts, logo, planet sequence

         opt h-
         ins "src/GAME.FNT"         ; $3C00-$3FFF play-screen font (modified Robbo F.FNT; animated characters copied in by ANIM)
         ins "src/BOARD_T.FNT"      ; $4000-$43FF editor board font, top halves of the 2 x 2 cells (CHBASE $40)
         ins "src/BOARD_B.FNT"      ; $4400-$47FF editor board font, bottom halves (CHBASE $44)
         ins "src/SHAPES.FNT"       ; $4800-$4BFF element shapes, two animation phases (modified Robbo S.FNT; source for ANIM)
         ins "src/INFO.FNT"         ; $4C00-$4FFF info-line, help and title font with icons and (c) (modified Robbo I.FNT)

         opt h+
         icl "src/DISKIO.ASM"       ; $9000-$9430 tape / disk: planet sets in 5 slots, format, saving the stand-alone game
         icl "src/ED_MENU.ASM"      ; $94E0-$9CDC editor: services jump table, main menu and its 10 functions, disk sub-menu
         icl "src/ED_SERV.ASM"      ; $9CDD-$9F7A editor services: messages, set-up, colours, lower panel, digits, planet tables, display list
         icl "src/ED_TEXTS.ASM"     ; $9F7B-$A808 editor tables (header buffer, menu table $9F8E) and texts: screens, messages, element names
         icl "src/ED_MAIN.ASM"      ; $A810-$AF3D editor: jump table $A810, input variables, display lists, start, main loop, board editing, planet test, redraw
         icl "src/ED_SCRN.ASM"      ; $AF3E-$B188 editor: screen set-up, frame wait, click, keys, DLI, joystick / keyboard input
         icl "src/TITLE_ED.ASM"     ; $B189-$B3BD title-page text editor (start / congratulation texts)
         icl "src/ED_UTIL.ASM"      ; $B3BE-$B4F8 editor helpers: display list switch, yes / no question, ATASCII to screen code, digits
         icl "src/PALETTE.ASM"      ; $B4F9-$B5FF tables: character codes $B4F9, palette codes $B51C, element glyphs $B55A
         icl "src/LOADSCR.ASM"      ; $BC40-$BC67 loading screen line "Robbo Konstruktor (C) 1990 Avalon"
