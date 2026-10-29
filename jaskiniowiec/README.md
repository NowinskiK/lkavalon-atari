# Jaskiniowiec (1995, StanBit) – XEX reverse engineering

Analysis of `Jaskiniowiec (1995)(StanBit)(PL)[h CAMOsoft][t +1 CAMOsoft].xex`
(original location: `x:\ATARI\GryKamil\`, 35,286 bytes).

Goal: unpack the cracked XEX, get the real game code into memory and disassemble it,
then (later) annotate it the same way as Dangerous City's `DC.ASM`.

## Files in this folder

| File | Purpose |
|---|---|
| `main.asm` | MADS file linking all blocks from `src/` back into the game memory image |
| `src/` | The game split into blocks (see [Source blocks](#source-blocks)) |
| `game.bin` | 64 KB memory image as it is when the game starts (after loader, depacker and snapshot restore) |
| `xex.py` | XEX segment parser + linear 6502 disassembler + Atari OS/hardware label table |
| `emu.py` | Minimal 6502 emulator that runs the XEX load sequence (INITAD/RUNAD) and dumps memory at a stop address |
| `resume.py` | Continues from `mem.bin` at $0480 (snapshot restore) until `RTI`, prints the resume PC, writes `game.bin` |
| `rdis.py` | Recursive-descent disassembler (follows JMP/JSR/branches and DLI/VBI vector setups) → MADS-style listing |
| `split.py` | Splits `game.bin` into the blocks of `src/` (block table `BLOCKS` at the top) and writes `main.asm` |
| `asm.py` | Minimal assembler for the MADS subset `split.py` writes – checks the split without MADS |
| `verify.py` | Compares an assembled segment file with `game.bin` byte for byte |
| `Makefile` | `make` builds `bin/game.obx` with MADS, `make test` verifies it |

## Source blocks

Like [Misja](../misja) and [Digi Duck](../digi-duck): code areas are disassembled to `.ASM` files,
data areas are binary files with an Atari `$FFFF` header (included with `OPT h-` / `INS`).
Names are by address where the content is not understood yet – rename them in `BLOCKS` in `split.py`.

| File | Address | Content |
|---|---|---|
| [src/JOINT.ASM](src/JOINT.ASM) | – | common labels (Atari OS/hardware, labels outside the blocks) |
| [src/SYSTEM.DTA](src/SYSTEM.DTA) | $0000-$04FF | zero page, stack, OS variables at snapshot time |
| [src/D0500.DTA](src/D0500.DTA) | $0500-$17FF | data |
| [src/D1800.DTA](src/D1800.DTA) | $1800-$24FF | data |
| [src/D2500.DTA](src/D2500.DTA) | $2500-$2F7F | data (32-byte records) |
| [src/LEVELS.DTA](src/LEVELS.DTA) | $2F80-$61FF | level tile maps |
| [src/TRAINER.ASM](src/TRAINER.ASM) | $6200-$646F | CAMOsoft crack stub and trainer |
| [src/D6470.DTA](src/D6470.DTA) | $6470-$6BFF | character screen |
| [src/FONT6C.FNT](src/FONT6C.FNT) | $6C00-$6FFF | font |
| [src/D7000.DTA](src/D7000.DTA) | $7000-$7BFF | data |
| [src/CODE7C.ASM](src/CODE7C.ASM) | $7C00-$8DEF | code and tables |
| [src/MAIN.ASM](src/MAIN.ASM) | $8DF0-$9FFF | game entry ($8E67), NMI/IRQ/VBI handlers |
| [src/CODEA0.ASM](src/CODEA0.ASM) | $A000-$BBFF | code, display list ($ACFC) |
| [src/START.ASM](src/START.ASM) | $BC00-$BFFF | start stub ($BC00) and tables |
| [src/TABLES.DTA](src/TABLES.DTA) | $C000-$C9FF | tables (bit reverse at $C000) |
| [src/MUSIC.CMC](src/MUSIC.CMC) | $EA00-$F2E0 | CMC music module |
| [src/CMC.ASM](src/CMC.ASM) | $F2E1-$FAD1 | CMC music player |
| [src/VECTORS.ASM](src/VECTORS.ASM) | $FFFA-$FFFF | NMI, RESET, IRQ vectors |

$CA00-$FFF9 outside the blocks and the I/O area $D000-$D7FF are zero in `game.bin`.
`main.asm` produces a segment file equal to `game.bin`, not a runnable executable
(segments under the OS ROM need a loader – see next steps).

## How to regenerate

Requires Python 3 (`py -3`). Run from this folder (scripts import each other from `.`):

```
py -3 xex.py "x:\ATARI\GryKamil\Jaskiniowiec (1995)(StanBit)(PL)[h CAMOsoft][t +1 CAMOsoft].xex"
py -3 emu.py "x:\ATARI\GryKamil\Jaskiniowiec (1995)(StanBit)(PL)[h CAMOsoft][t +1 CAMOsoft].xex" 0480 mem.bin
py -3 resume.py
py -3 split.py game.bin 6214 9EAE 9EC8 9ED6 62DF 9E97 F2E1 F2E4 F2E7
py -3 asm.py main.asm bin/game.obx
py -3 verify.py bin/game.obx
```

1. `xex.py` – lists segments.
2. `emu.py` – loads all segments, runs INIT/RUN vectors, stops when PC reaches $0480 → `mem.bin`.
3. `resume.py` – runs the snapshot restore → reports `resume PC=$6200` → `game.bin`.
4. `split.py` – writes `src/*` and `main.asm`. Arguments after `game.bin` are entry points.
5. `asm.py` + `verify.py` – reassemble and check the result equals `game.bin` (with MADS: `make test`).

`py -3 rdis.py game.bin 0000-FFFF <entries>` still writes the whole image as one listing (`0000_FFFF.asm`).

## XEX structure (22 segments)

| # | Address | Content |
|---|---|---|
| 0–1 | $0C00-$0CF5, INIT $0C03 | CAMOsoft intro, XOR `$A2`-encrypted (bytes $0C1E-$0CF5). Text: "JASKINIOWIEC / press START / File version by CAMOsoft / Copyright (C) 1995 by StanBit" |
| 2–3 | $28A0, INIT $28A0 | Saves RUNAD to $27FE |
| 4 | $2800-$2894 | RLE unpacker (header at $3000: dest start, dest end) |
| 5 | $3000-$4384 | Packed loading-screen data |
| 6–7 | $28A0, RUNAD $28A0 | Restores RUNAD, unpacks loading screen (`JSR $2800`), `JSR $2710`, then `JMP $0500` |
| 8 | $0500-$0535 | Block copier: $6400 → (patched target), with OS ROM off (PORTB=$FE) |
| 9–11 | $6400-$77FF + patch $0514, INIT $0500 | 5 KB → **$EC00** (RAM under OS) |
| 12–14 | same | 5 KB → **$D800** |
| 15 | $022F | SDMCTL |
| 16–18 | same | 5 KB → **$BC00** |
| 19 | $85D6-$BBFF | Main game, **packed** (13,866 bytes) |
| 20 | $0500-$06B1 | Depacker: relocates itself to $0700/$0800 and zero page, OS off, unpacks backwards (skips I/O $D000-$D7FF), ends with `JMP $0480` |
| 21 | $02E0-$02E3 | RUNAD $0500, INITAD $0C00 (shows the intro first) |

## Boot chain

1. **$0C00** – intro, waits for START, `JMP $28A0` → loading screen → `JMP $0500` (depacker).
2. **$0480** – **memory-snapshot restore** (this is the `[h]` = hacked/frozen version):
   restores zero page from $0C80, stack from $1400, $1000 → zero page, GTIA/POKEY/PIA registers,
   moves some pages via a stub copied onto the stack, then `RTI`.
   The `NOP NOP` at $0495 is a patched-out START wait.
3. **$6200** – crack stub: sets DOSINI ($02/$03) = $6214, `BOOT?`=2, `JMP WARMSV`.
4. **$6214** – **CAMOsoft trainer** (`[t +1]`): fading text from $6418
   **"Unlimited lives ?  [Y/N]"**. Keys checked: KBCODE $2B (**Y**) and $2D (**T** = "Tak").
   On yes it calls the patch from the table at $63C2 → **$6376**:
   ```
   6376  LDA #$EA        ; NOP
         STA $8C4E/$8C4F ; removes DEC $A7
         STA $982D/$982E ; removes DEC $A7
   ```
   → **lives counter = zero page `$A7`**.
5. **$BC00** – clears trainer memory $6200-$646F, `JMP $8E67`.
6. **$8E67** – **real game entry** (start annotating here).

## Known addresses in the game

| Address | Meaning |
|---|---|
| $8E67 | Game entry |
| $A7 (ZP) | Lives counter (decremented at $8C4E and $982D) |
| $9EAE | Own NMI handler (OS ROM off): DLI → `JMP (VDSLST)`, else VBI |
| $9EC8 | Own IRQ handler (just disables IRQEN) |
| $9ED6 | VBI routine (sets PORTB=$FF …) |
| $9E97 | Music re-init (`JSR $8FBF`, CMC init) |
| $F2E1 | **CMC music player** (same convention as Dangerous City `rep`): `LDA #$70 / LDX #<tune / LDY #>tune / JSR $F2E4`; `+6` = play |
| $EA00 | Music data (tune passed in X/Y = $00/$EA) |
| `A=$21, X=$18, Y=$14, JSR $F2E4` | Sound effect, e.g. on life lost ($8C50, $9822) |
| $2F80-~$5500 | Character tile maps of side-scrolling levels (clouds `cdde`, platforms `GKJKILJ…O`, `PQR`, `TU`, water rows `MNMN`) |
| CHBAS $E0 | Set by the trainer ($6234) – OS ROM font; RAM under the OS at $E000 is empty |
| $6C00 | Game font (`LDA #$6C / STA CHBASE`) |
| $ACFC | Display list (set at $AC18, $B25C); SDLSTL=$BDEF in the snapshot is not a real display list |

Code ranges found by `rdis.py` (≈9.7 KB, 4,557 instructions, 421 labels):
$6214-$6375 (trainer), $7C03-$87AC, $87CC-$8873, $8A4D-$8A8E, $8DF0-$9F96,
$AB7D-$AC27, $AEF0-$B3DA, $BC00-$BC17, $C0AB-$C0BF, $F2E1-$FA97 (music player).

## Limitations

- This is a **disassembly**, not a high-level decompilation; turning it into readable logic is manual work.
- Code reached only via jump tables or `JMP (ind)` is not discovered and shows as `dta` – add entry
  points to the `rdis.py` command line when you find them.
- The emulator stubs hardware: `$14` increments on every read, CONSOL alternates 6/7, VCOUNT/RANDOM fake,
  `$D000-$D7FF` reads 0 / writes ignored, RAM under OS treated as flat memory, OS ROM calls (when PORTB bit 0 = 1)
  are skipped as `RTS`. Good enough for the loader; not for running gameplay.
- In-game texts are probably in the custom font, so the text scan found only tile maps.

## Next steps (ideas)

- Annotate the main loop from $8E67 (like `DC.ASM`): joystick handling, player movement, collisions, lives ($A7).
- Find the level map format/width and extract levels to images.
- Identify the `Dxxxx.DTA` blocks and give them proper names (fonts, P/M graphics, screens).
- `CMC.ASM` has `JMP $5968` ($F372) and `JSR $5B73` ($F654) into `LEVELS.DTA` – probably player tables disassembled as code.
- Add a loader so `main.asm` builds a runnable XEX (copy blocks under the OS ROM, restore hardware state, `JMP $8E67`).
