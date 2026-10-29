# Robbo Konstruktor (1990, L.K. Avalon) – reverse engineering

Level editor for [Robbo](../robbo). Analysis of the disk image
`bin/Robbo Konstruktor (1990)(L.K. Avalon)(PL).atr` (133,136 bytes), following
[DISASSEMBLY-GUIDE.md](../DISASSEMBLY-GUIDE.md). Process and findings: [NOTES.md](NOTES.md).

Status: steps 1-2 of the guide done (disk read, memory image); disassembly not started yet.

## Files

| File | Purpose |
|---|---|
| `bin/Robbo Konstruktor (1990)(L.K. Avalon)(PL).atr` | original disk image ("fast hack by Mr.Bacardi") |
| `game.bin` | 64 KB memory image at program start (boot loader + all segments) |
| [util/atr.py](util/atr.py) | ATR reader: header, boot record, used sectors, DOS 2-style sector chains |
| [util/image.py](util/image.py) | builds `game.bin` from the disk |

The XEX tools (`xex.py` …) are used from [../jaskiniowiec/util/](../jaskiniowiec/util/) for now.

## How to regenerate

From this folder:

```powershell
py -3 util/atr.py "bin\Robbo Konstruktor (1990)(L.K. Avalon)(PL).atr"                      # disk info
py -3 util/atr.py "bin\Robbo Konstruktor (1990)(L.K. Avalon)(PL).atr" chain 4 konstruktor.xex  # the program file
py -3 ../jaskiniowiec/util/xex.py konstruktor.xex                                            # its segments
py -3 util/image.py "bin\Robbo Konstruktor (1990)(L.K. Avalon)(PL).atr" game.bin             # memory image
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
