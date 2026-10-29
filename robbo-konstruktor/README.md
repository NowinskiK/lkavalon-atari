# Robbo Konstruktor (1990, L.K. Avalon) – reverse engineering

Level editor for [Robbo](../robbo). Analysis of the disk image
`bin/Robbo Konstruktor (1990)(L.K. Avalon)(PL).atr` (133,136 bytes), following
[DISASSEMBLY-GUIDE.md](../DISASSEMBLY-GUIDE.md). Process and findings: [NOTES.md](NOTES.md).

Status: steps 1-4 of the guide done – the program is split into sources (`src/`, `main.asm`) that reassemble
**byte for byte** with MADS (12.5 KB of code found). Step 5 in progress: the game engine carries the **original
Robbo names** (110 routines, zero page) found by matching against `../robbo/d1/*.ASM`; the editor is next.

## Files

| File | Purpose |
|---|---|
| `bin/Robbo Konstruktor (1990)(L.K. Avalon)(PL).atr` | original disk image ("fast hack by Mr.Bacardi") |
| `game.bin` | 64 KB memory image at program start (boot loader + all segments) |
| [util/atr.py](util/atr.py) | ATR reader: header, boot record, used sectors, DOS 2-style sector chains |
| [util/image.py](util/image.py) | builds `game.bin` from the disk |
| [util/split.py](util/split.py) | splits `game.bin` into `src/` and writes `main.asm`; tables `BLOCKS`, `ENTRIES` (+ dispatch tables), `NOFOLLOW`, `VARIABLES`, `COMMENTS`, `NAMES`, `POKES` |
| `util/xex.py`, `rdis.py`, `asm.py`, `verify.py` | from [../jaskiniowiec/util/](../jaskiniowiec/util/); `rdis.py` here also finds entries written into self-modified jumps and VBIs installed with SETVBV |
| `main.asm`, `src/` | generated sources (see below) |
| `Makefile` | `make` builds `bin/game.obx` with MADS, `make test` compares it with `game.bin` |

## Source blocks

| File | Address | Content |
|---|---|---|
| [src/JOINT.ASM](src/JOINT.ASM) | – | common labels (Atari OS/hardware, labels outside the blocks) |
| [src/RUNAD.DTA](src/RUNAD.DTA) | $02E0-$02E1 | RUNAD = $A810 |
| [src/HOOK.ASM](src/HOOK.ASM) | $0480-$0482 | restart hook: JMP $A810 |
| [src/BOOT.ASM](src/BOOT.ASM) | $0500-$067F | boot sectors 1-3: boot record and binary-file loader (cracked) |
| [src/EDIT08.ASM](src/EDIT08.ASM) | $0800-$0C6C | code: JMP $09A6 at $0800, tables, routines |
| [src/D0C6D.DTA](src/D0C6D.DTA) | $0C6D-$1DD0 | data (4.4 KB, text-like) |
| [src/ENGINE1.ASM](src/ENGINE1.ASM) | $1E00-$23FC | game engine: jump table $1E00, display list, DLIs |
| [src/ENGINE2.ASM](src/ENGINE2.ASM) | $243D-$35A3 | game engine: object behaviour (table $31EF), VBI $2F54 |
| [src/ENGINE3.ASM](src/ENGINE3.ASM) | $35C0-$395C | game engine: display list, code |
| [src/FONT3C.FNT](src/FONT3C.FNT) | $3C00-$3FFF | font (modified Robbo F.FNT) |
| [src/D4000.DTA](src/D4000.DTA) | $4000-$47FF | data |
| [src/FONT48.FNT](src/FONT48.FNT) | $4800-$4BFF | font (modified Robbo S.FNT) |
| [src/FONT4C.FNT](src/FONT4C.FNT) | $4C00-$4FFF | font (modified Robbo I.FNT) |
| [src/EDIT90.ASM](src/EDIT90.ASM) | $9000-$9430 | editor code |
| [src/EDITOR.ASM](src/EDITOR.ASM) | $94E0-$9F7A | editor: menu dispatch, cursor, commands |
| [src/TEXTS.DTA](src/TEXTS.DTA) | $9F7B-$A808 | editor tables and texts (menu table $9F8E) |
| [src/EDITOR2.ASM](src/EDITOR2.ASM) | $A810-$B5FF | editor: jump table $A810, main loop, screen, DLI, text input |
| [src/LOADSCR.DTA](src/LOADSCR.DTA) | $BC40-$BC67 | loading screen line "Robbo Konstruktor (C) 1990 Avalon" |

A first cut by segments; blocks will be regrouped into modules once the code is understood (step 6).

## Program structure (first look)

| Area | What |
|---|---|
| $A810 | jump table, 16 entries; start $A9A7, main loop $A9B5 (every 4 frames, OS timer 3) |
| $94E0-$9F7A | editor: menu dispatch (table $9F8E, menu words "kolory", "test", "planety", "strona"), cursor, commands |
| $9F7B-$A808 | editor texts |
| $A810-$B4F8 | editor: screen, DLI ($B05F), text input (key table $B330) |
| $1E00-$3919 | game engine (Robbo-based): jump table $1E00 / $1E03 (called by the menu's "test"), DLIs, object behaviour table $31EF (97 object codes) |
| $3C00-$4FFF | fonts (modified Robbo fonts) |

## How to regenerate

From this folder:

```powershell
py -3 util/atr.py "bin\Robbo Konstruktor (1990)(L.K. Avalon)(PL).atr"                      # disk info
py -3 util/atr.py "bin\Robbo Konstruktor (1990)(L.K. Avalon)(PL).atr" chain 4 konstruktor.xex  # the program file
py -3 ../jaskiniowiec/util/xex.py konstruktor.xex                                            # its segments
py -3 util/image.py "bin\Robbo Konstruktor (1990)(L.K. Avalon)(PL).atr" game.bin             # memory image
py -3 util/split.py game.bin                                                                 # sources
& $env:MADS main.asm -o:bin/game.obx                                                         # build
py -3 util/verify.py bin/game.obx                                                            # must match game.bin
```

`konstruktor.xex` is an intermediate (ignored by git, rebuilt from the disk).

## Disk structure

1,040 sectors × 128 bytes (enhanced density), 250 sectors used. **No DOS**: a boot disk with its own loader.

| Sectors | Content |
|---|---|
| 1-3 | boot record + loader, loaded to $0500 (boot record: 3 sectors, load $0500, init $19DD) |
| 4-222 | the program: one binary file (27,285 bytes) as a DOS 2-style sector chain |
| 360-361 | VTOC / "directory" – only text: "Robbo Konstruktor by L.K.Avalon --- fast hack by Mr.Bacardi" |
| 256, 260-264, 388, 392-396, 520, 524-532, 652, 784, 974, 989 | not in the program chain – probably saved boards (slots 132 sectors apart); not analysed yet |

## Boot loader ($0500-$067F)

A DOS 2-style binary loader without DOS: reads the sector chain from sector 4 (bytes 125-126 of each sector =
next sector, byte 127 = byte count) through SIOV, parses binary-file segments (skipping `$FFFF`), calls
INITAD after each segment and finally `jmp (RUNAD)` ($052E). Cracker patches: `NOP NOP NOP` at $052B and $05A3.

## Program segments (load order)

| # | Address | Content (first look) |
|---|---|---|
| 0 | $BC40-$BC67 | loading screen line at the OS screen: "Robbo Konstruktor (C) 1990 Avalon" (inverse) |
| 1 | $02E0-$02E1 | RUNAD = $A810 |
| 2 | $0480-$0482 | `JMP $A810` – restart hook |
| 3 | $94E0-$A808 | |
| 4 | $A810-$B5FF | jump table of 16 entries at $A810 (start = `JMP $A9A7`), display list at $A846 |
| 5 | $9000-$9430 | |
| 6 | $0800-$1DD0 | |
| 7 | $4000-$47FF | |
| 8 | $4C00-$4FFF | font, related to Robbo `I.FNT` |
| 9 | $35C0-$395C | |
| 10 | $1E00-$23FC | |
| 11 | $243D-$35A3 | contains code shared with Robbo (e.g. $338E = Robbo $30D4, 562 bytes) |
| 12 | $3C00-$3FFF | font, related to Robbo `F.FNT` |
| 13 | $4800-$4BFF | font, related to Robbo `S.FNT` |

No INIT segments, nothing packed: the loaded segments are the program's memory at start.

## Relation to Robbo

The repository has the original Robbo sources ([../robbo/](../robbo/)). Konstruktor reuses parts of them at
other addresses: three of Robbo's fonts in modified form ($3C00 ≈ `F.FNT`, $4800 ≈ `S.FNT`, $4C00 ≈ `I.FNT`)
and about 3.7 KB of identical code/data runs (longest: 721, 562, 257, 234 bytes). Where code matches, the
original label names from `robbo/d1/*.ASM` can be used.
