# Jaskiniowiec – reverse-engineering notes

Working log of how the game was taken apart, what was found and what we learnt on the way.
[README.md](README.md) is the reference (files, blocks, addresses); this file explains **how** we got there
and **why** things are the way they are.

## Timeline

| Date | Step |
|---|---|
| 2026-10-28 | XEX parsed, loader emulated, snapshot restored → `game.bin`; whole image disassembled into one listing (`jaskiniowiec.asm`, 8,489 lines) |
| 2026-10-28 | Listing split into blocks like [misja](../misja) / [digi-duck](../digi-duck): `split.py`, `main.asm`, `asm.py`, `verify.py`, `Makefile` |
| 2026-10-29 | Code analysed (call graph + reading + emulation), blocks regrouped into logical modules, new entry points found |
| 2026-10-29 | MADS 2.1.5 provided; real MADS build verified byte for byte (section 6) |
| 2026-10-29 | MADS path moved to the `MADS` environment variable (section 7) |
| 2026-10-29 | Local MADS checked against the 2.1.5 tag on GitHub; docs reviewed (section 8) |
| 2026-10-29 | Python tools moved to `util/` (section 9) |
| 2026-10-29 | `MADS` env var set-up instructions tested and corrected (section 10) |
| 2026-10-29 | Level rendering to PNG proven with a prototype (section 11) |
| 2026-10-29 | Atari palette `util/palette/jakub.act` added; prototype renders with real colours (section 12) |
| 2026-10-29 | Renders verified against a real start-screen screenshot; XFormer palette, black playfield, logo (section 13) |
| 2026-10-29 | Reference screenshot saved as `img/jaskiniowiec.png` (section 14) |
| 2026-10-29 | `util/levels.py` added; level maps and logo rendered to `img/levels/` (section 15) |
| 2026-10-29 | Stale block files from the first split removed, repo cleaned (section 16) |
| 2026-10-29 | `LEVEL.ASM` walked through; level 3 cave-room bug, text pages, logo height (section 17) |

## 1. From XEX to memory image

The file is a cracked, "frozen" version (`[h CAMOsoft][t +1 CAMOsoft]`): the game was snapshotted from memory,
packed and wrapped in a loader with an intro and a trainer. The real game code exists only after the loader
has run, so we emulate the load instead of reading segments.

1. `xex.py` – list the 22 segments (see README "XEX structure").
2. `emu.py` – minimal 6502 emulator: loads segments one by one, runs INITAD/RUNAD, stops when PC hits $0480
   (snapshot restore) → `mem.bin`.
3. `resume.py` – runs the snapshot restore until `RTI` → resume PC $6200 → `game.bin` (64 KB as at game start).

Emulator stubs (good enough for the loader, **not** for gameplay): `$14` increments on read, CONSOL alternates,
VCOUNT/RANDOM fake, I/O $D000-$D7FF reads 0, OS ROM calls skipped as RTS when PORTB bit 0 = 1.

Sanity check done: $D800-$E9FF is zero in `game.bin` although 5 KB was copied to $D800 during loading.
Traced per segment: the depacker (segment 20) clears it. The game later copies its fonts to $D800/$E000
itself, and CHBAS=$E0 in the snapshot is the trainer using the OS ROM font – so the zeros are correct.

## 2. Splitting into blocks

Goal: same layout as the other games in this repo, sources that MADS can reassemble byte for byte.

Conventions taken from misja / digi-duck:
- code → `.ASM` files, each with its own `org`;
- data → binary files **with the Atari `$FFFF,start,end` header**, included in `main.asm` under `opt h-` with `ins`;
- common labels → `JOINT.ASM`;
- `Makefile` with `all` and `test`.
- One `src/` folder (digi-duck style); misja's `d1/`/`d2/` mirror its original disks, which we don't have.

How it works:
- `rdis.py` was refactored into `analyze()` (recursive descent from entry points) and `Lister`
  (listing of any range; remembers placed and used labels).
- `split.py` has the `BLOCKS` table (file, first, last, description). It asserts that blocks don't overlap,
  don't touch I/O and that no instruction crosses a block boundary; warns about non-zero bytes outside blocks.
- Labels used but not placed (inside an instruction or outside the blocks) go to `JOINT.ASM` as `equ`.
- `VECTORS.ASM` is written with `dta a(label)`.

MADS pitfalls handled in the generator:
- An absolute-mode instruction with an operand < $100 would be assembled as zero page by MADS → written as
  `dta $op,a($00xx)` (none occur in this game, but the guard stays).
- OS names that are expressions (`RTCLOK+2`) are not emitted as `equ`, only their base.
- No `.local` blocks: labels are global because modules reference each other.

Verification: MADS is not installed on this machine, so `asm.py` (a tiny assembler for exactly the subset
`split.py` writes) assembles `main.asm`, and `verify.py` loads the segments into 64 KB and compares with
`game.bin`. Result: **byte for byte identical**. With MADS available run `make test` – that has not been done yet.

## 3. Analysing the code – method

What worked, in order:

1. **Call graph with resources** (scratch script): for every `sub_`/`entry_`/`irq_` label, follow the flow
   without entering JSRs and record callers, callees, hardware registers, zero-page and absolute addresses used.
   Clusters appeared immediately (sprite engine writing $C880+, music player, ending with its own DL/DLI…).
2. **Read the per-frame loop** (`$8EC3`) and then each routine it calls, in a compact one-line-per-label dump
   (`awk` range + `paste`), naming variables by how they are used.
3. **Decode data** referenced by code: display-list parameter block ($93A4), init poke tables ($929B, $930A),
   text in screen codes ($A0C8 "JEDZENIE", "ZYCIA", $A1A1 scroller text), shape pointer tables ($C800/$C840).
4. **Find missing code**: the player variables ($934D/$934E…) were written only from $8A8F-$8DEF, which nothing
   called. Static searches (JSR/JMP, immediate pairs, RTS trick, self-modified operands) found nothing.
   **Emulating** the game from $8E67 showed the main loop runs but never enters that code → it must be an
   interrupt. The init poke table at $929B sets VVBLKD ($0224/$0225) = $8A8F. Same for the DLIs (VDSLST=$8874).
   (The emulator needed a VCOUNT stub that eventually returns $80, otherwise it hangs at $8FC1.)
5. **Regroup blocks** along contiguous address ranges that share one purpose; add the new entry points
   (8A8F 8874 88AA 8929 93C7) → 10.7 KB of code instead of 9.7 KB.

## 4. What we learnt about the game

### Memory map

| Range | Content |
|---|---|
| $0800 / $1000 / $1800 | 3 fonts × 2 KB (level font A, level font B, text screens), copied to $D800 and $E000 by $9215 |
| $2000-$27FF | sprite shapes, 64 × 32 bytes |
| $3000-$6BFF | 6 level maps × $A00 (10 rows × 256 tiles, a tile = 2 characters) |
| $6C00 | status line font |
| $7000 | tile attributes (`$8DF0`: `(tile >> 1) & $7F`) |
| $7100 | mode E picture above the playfield |
| $7C00-$8873 | software sprite engine |
| $8874-$8A4C | DLI chain + display lists $8974 / $89D8 |
| $8A4D-$9FDA | game logic (player, main loop, enemies, rooms, items, levels, interrupts) |
| $9FDB-$AB7C | texts, status line, per-level tables |
| $AB7D-$B4ED | ending |
| $B4EE-$BBFF | unused copy of the music file (loader leftover) |
| $BC00-$BFFF | playfield screens, 2 buffers ($BC00 / $BE00) |
| $C000-$C9FF | bit-reverse, pixel-mirror and mask tables, current level data, shape pointers |
| $CC00-$CFFF | P/M players (PMBASE=$C8) |
| $D800 / $E000 | level fonts, double-buffered (RAM under OS) |
| $EA00 / $F2E1 | CMC music / CMC player |

### How the game runs

- `$8E67` start: OS off (PORTB=$FE), own NMI/IRQ vectors, init poke table (VDSLST, SDLSTL, VVBLKD, PMBASE,
  GRACTL, colours, lives $A7=3, energy $A5=$60), level 1, intro text screen.
- Main loop `$8EC3`, every 3 frames: enemies → sprite drawing → buffer swap, sound effects, player map probe,
  enemy contact, status line, cave rooms, level completion.
- The screen is double-buffered: screen, font and display list are swapped every frame (`$882C`, `$80` parity,
  `$83` = current font page). Enemies are software sprites drawn into characters; the player is P/M graphics.
- Player moves in the deferred VBI ($8A8F); OPTION toggles music ($8A64).
- Walking off the screen (player X $934D > $9C or < 4) scrolls the map by one screen (column $935A).
- 6 levels, order by `$935C`: maps $3000, $6200, $3A00, $4E00, $4400, $5800. Each level loader copies its enemy
  set to $C500 and cave rooms to $C600. A level ends on an exit tile with 32 treasures (`$A6`=$20).
  After level 6: ending ($AEF0).
- `$9357` = tile attributes under the player: bit 3 hazard (energy loss), bit 4 exit, bit 5 treasure.
- Energy $A5 reaches 0 → life lost, energy back to $60. Lives $A7 = 0 → game over screen.
- Text screens ($9C5A) show pages from $9C3A and wait for fire; types 0 intro, 1 next level, 2 game over, 3 victory.

### Curiosities

- Cheat: typing **PIERWSZY** with Shift (table $9F75, checked in the VBI) sets lives to 8.
- Copy protection leftovers: VBI checks $D20D (SERIN), $C001, $C002; `$9A28` checks $D20D – all NOPed by
  the crack. `$8820` fills the sprite routine at $84E9 with zeros when `$DF` bit 7 is clear (a trap).
- `$93C7` builds the $C000/$C100/$C200 tables but is never called – the tables were already in the snapshot.
- **The crack damages level 2**: the trainer is loaded at $6200-$646F, on top of level 2's map rows 0-2, and the
  crack stub at $BC00 zeroes that area. Other maps have 10-40 tiles in those rows, so some level 2 tiles are
  probably lost in this version. Needs another dump of the game to confirm/restore.
- The README's original note "DLIST $BDEF" was wrong: SDLSTL in the snapshot points at garbage; the game's
  display lists are $8974/$89D8, the ending's is $ACFC.

## 5. Lessons

- Emulate the loader of packed/frozen files instead of guessing the depacker; check suspicious zero areas by
  tracing which segment cleared them.
- Recursive descent misses code reached through **data**: interrupt vectors in poke tables, VDSLST chains,
  self-modified operands. Look for writes to the variables you are interested in, then for who calls that code;
  if nothing does, check interrupt vectors set from tables.
- A short emulation run is a cheap way to prove "not called from the main loop".
- Keep generated sources reproducible: change `BLOCKS` / entry points in `split.py` and regenerate, never edit
  `src/` by hand until annotation starts; verify after every regeneration.
- Without MADS, a small purpose-built assembler is enough to prove the split is lossless – but run real MADS
  before relying on the sources.
- File names by address (`Dxxxx`) until the content is understood; rename when it is.

## 6. Verified with real MADS (2026-10-29)

MADS 2.1.5 (build 3, 21 Feb 22) at `x:\ATARI\Tools\Mad-Assembler-2.1.5\mads.exe` (not on PATH).

```
/x/ATARI/Tools/Mad-Assembler-2.1.5/mads.exe main.asm -o:bin/game.obx
py -3 verify.py bin/game.obx
```

Result: no errors or warnings, "6021 lines of source assembled in 3 pass", 56,176 bytes written,
**matches game.bin byte for byte**. So the syntax `split.py` writes is valid MADS: zero-page choice,
`opt h-` + `ins` of headered files, global labels, `equ` in `JOINT.ASM` all behave as assumed.

- The MADS file is 70 bytes smaller than `asm.py`'s output: MADS writes the `$FFFF` marker only before the
  first segment, `asm.py` before every segment. Both are valid; `verify.py` reads either.
- `Makefile` now has `MADS ?= mads`, so `make MADS=/x/ATARI/Tools/Mad-Assembler-2.1.5/mads.exe test` works
  where make exists (it is not installed here – run the commands directly).
- MADS is now the authority for the build; `asm.py` stays as a fallback.

Lesson: the stand-in assembler gave the right answer, but only the real tool can confirm syntax assumptions –
worth running as soon as it is available, before annotation changes pile up.

## 7. MADS path in an environment variable (2026-10-29)

Decision: no machine-specific paths in the docs or build files. The MADS executable is configured in the
`MADS` environment variable (full path). The Makefile already has `MADS ?= mads`, so make uses the variable
when set and falls back to `mads` on `PATH`.

- Set-up instructions with the example value `x:\ATARI\Tools\Mad-Assembler-2.1.5\mads.exe` are in the root
  README ("MADS location"): check with `$env:MADS` / `echo "$MADS"`, set permanently with
  `[Environment]::SetEnvironmentVariable('MADS', '<path>', 'User')` (new terminal needed afterwards).
- Commands: PowerShell `& $env:MADS main.asm -o:bin/game.obx`, Git Bash `"$MADS" main.asm -o:bin/game.obx`.
- CLAUDE.md: always call `$MADS`; if it is empty, tell the user and point to the README.

## 8. MADS 2.1.5 sources and documentation (2026-10-29)

Upstream: <https://github.com/tebe6502/Mad-Assembler/tree/2.1.5> (docs in `doc/`).

**Is the local copy the real 2.1.5?** Yes. Compared `x:\ATARI\Tools\Mad-Assembler-2.1.5` with files downloaded
from the `2.1.5` tag: `mads.exe`, `mads.pas`, `CHANGELOG`, `README.md`, `doc/mads.html`, `doc/mads_eng.html` are
byte-identical. (A first comparison of `mads_eng.html` failed only because `gh api` changed the downloaded
bytes; a plain raw download matched. Lesson: compare with a raw download before concluding a file differs.)
`mads.exe` reports "mads 2.1.5 build 3 (21 Feb 22)", matching the last CHANGELOG entry (2022-02-21).

**What the documentation confirms about our generated sources** (`doc/mads_eng.html`):

- MADS picks zero page automatically when the operand value is < $100 ("Assembling into zero page").
  Forcing absolute with a mnemonic extension (`lda.w $80` → `AD 80 00`) works **only for LDA, LDX, LDY,
  STA, STX, STY**. So `split.py`'s fallback `dta $op,a($00xx)` is the right general solution (it also covers
  `adc`, `cmp`, `inc` …), not just a workaround.
- Labels are case-insensitive by default (`-c` makes them case-sensitive) – our generated names are unique
  either way, and `asm.py` also treats them case-insensitively.
- `opt h+` (default) writes `$FFFF` headers, `opt h-` omits them – used for `ins` of headered data files.
  `opt h-f+` writes one RAW block – could produce a flat memory image directly if ever needed.
- `ins 'file'[,+offset[,length]]` can skip bytes at the start or take a part of a file – an alternative if we
  ever want headerless data files.

**Switches worth using during annotation:** `-l` (listing with addresses and bytes), `-t` (label table),
`-u` (warn about unused labels – shows generated labels that annotation made obsolete), `-bc` (branch out of
range / page-crossing warnings – useful after editing code).

## 9. Python tools moved to `util/` (2026-10-29)

All seven scripts (`xex.py`, `emu.py`, `resume.py`, `rdis.py`, `split.py`, `asm.py`, `verify.py`) moved with
`git mv` (history kept) to `jaskiniowiec/util/`. The game-specific tools stay in the game folder; the root
`util/` holds repo-wide tools (`convert-atascii.go`).

- Imports: `sys.path.insert(0, '.')` replaced by the script's own folder
  (`os.path.dirname(os.path.abspath(__file__))`), so the scripts find each other regardless of the working directory.
- Data paths unchanged: still relative to the **game folder**, so commands are run from `jaskiniowiec/` as
  `py -3 util/<script>.py …`. Makefile `test` calls `util/verify.py`.
- Regenerate commands now use the original XEX from `bin/` instead of `x:\ATARI\GryKamil\…`.
- Re-tested the whole pipeline from the new location: `game.bin` regenerated with the same MD5
  (`d1c4962b5bf3f5c958e0653d51adde9b`), `split.py` output unchanged (no git diff in `src/`/`main.asm`),
  MADS build and `asm.py` build both verify byte for byte.

## 10. Testing the `MADS` environment variable set-up (2026-10-29)

The README's `SetEnvironmentVariable(..., 'User')` line was tested with a throw-away variable `MADS_TEST`
(removed afterwards):

- The value is written for the user (read back from the User scope: correct path).
- It is **not** visible in the running session, and **not** in a new process started from that session
  (`powershell -Command '$env:MADS_TEST'` printed nothing) – child processes inherit the parent's environment.
  Only programs started fresh afterwards see it, so VS Code / Windows Terminal must be restarted; a new
  terminal tab is not enough. README corrected (was "open a new terminal afterwards") and now also shows
  `$env:MADS = '...'` for the current session.
- PowerShell `& $env:MADS_TEST` and Git Bash `"$MADS_TEST"` both run MADS with the Windows path
  (`x:\ATARI\...\mads.exe`); a Git Bash build of `main.asm` through the variable verified byte for byte.

Lesson: test set-up instructions before documenting them – "new terminal" is a common but wrong assumption
for terminals hosted inside an IDE.

## 11. Rendering levels to images – feasibility (2026-10-29)

Question: can the levels be extracted to images? **Yes** – a prototype (scratch script, not in the repo yet)
rendered all 6 levels to PNG from `game.bin`; level 1 shows clouds, trees, ladder, rock platforms correctly.

How a level is displayed (evidence):

- Map: 10 rows × 256 tiles; tile byte `b` → characters `2b` and `2b+1` side by side (`$8FC7`: `asl` / `+1`),
  so `asl` moves bit 6 of `b` into character bit 7.
- **A tile is 2×2 characters**: the game display list ($8974) shows every screen row twice
  (`C4 00 BC C4 00 BC …`, mode 4 + LMS + DLI), and the DLIs alternate CHBASE between `$83` (`$88B2`) and
  `$83 | 4` (`$8931`). So a 2 KB level font = 1 KB of top halves + 1 KB of bottom halves; a tile is
  8 × 16 mode-4 pixels, a screen 20 tiles wide.
- ANTIC mode 4: 2 bits per pixel; value 3 uses COLPF3 instead of COLPF2 when character bit 7 is set.
- Fonts and colours per level (level loaders):

  | Levels (maps) | Font | Tile attributes | PF0 PF1 PF2 PF3 |
  |---|---|---|---|
  | 1, 3, 5 ($3000, $3A00, $4400) | A $0800 (`$9221`) | $7000 | B6 F4 FA 8C (`$9A79`) |
  | 2, 4, 6 ($6200, $4E00, $5800) | B $1000 (`$9239`) | $7080 | 76 F4 0C 7E (`$9B16`) |

  Background is `$86` (=$76 from the init table); the attribute table pointer is written to `$8DF5/$8DF6`.
  This answers the open question "which levels use font A / B".

Limits of the prototype: approximate Atari palette (no real palette file), per-row DLI colours (sky gradient
$935D…, status line) and the mode-E picture above the playfield are not drawn; enemies/treasures are not
part of the map (they come from `LEVELDAT.DTA`).

Level 2 render confirms the crack damage visually: map rows 0-2 ($6200-$646F) show the trainer's code and
text as garbage tiles (in `game.bin` the trainer is still there; the game zeroes it before starting), while
the level's ceiling in row 3 is intact – the lost tiles are the decoration above it.

## 12. Atari palette and correct background colour (2026-10-29)

- Palette: [`../util/palette/jakub.act`](../util/palette/jakub.act) (repo-wide, see its README) – Jakub Bogusz's
  palette from the Atari800 emulator (`act/jakub.act`, built in since 1.3.6), 768 bytes = 256 × RGB, index =
  Atari colour value. Chosen because it is the emulator's own built-in palette; `Real.act` (Zdenek Eisenhammer)
  is the alternative in the same folder. Sanity check: grey ramp $00-$0F, 16 distinct hues.
- With it the level 1 render looks right (green trees, yellow-brown rocks, white-blue clouds).
- **Background colour fix**: the prototype took COLBK from `$86` in `game.bin` = `$A4` (green) – that is the
  trainer's leftover. In the game the init table ($929B) sets `$86` = **`$76`** (sky blue), and the DLI row
  colours at $935D (`76 74 76 74 … 72`) are a blue gradient. Rendering with `$76` gives a blue sky.
  *(Corrected in section 13: `$76` is only the logo area; the playfield is black below map row 1.)*

Lesson: values in `game.bin` are a snapshot from the trainer, not the game's own initial state – take initial
values from the game's init tables ($929B, $930A) instead.

## 13. Verification against a real screenshot (2026-10-29)

The user provided an emulator screenshot of the start screen (1083×736, logo, level 1 first screen, player,
status line "StanBit 1995", "JEDZENIE", "ZYCIA 3").

**Colours.** The screenshot has only 24 distinct colours, so it is an exact emulator palette. Matching them
against all five Atari800 palettes: **XFormer.act** average distance 1.3 RGB units (each colour within 1-2),
jakub 22.6, Real 23.5, default 26.8. Translating each colour back to an Atari value through XFormer gives
exactly the values found in the code:

- level 1 colours PF0-PF3 `$B6 $F4 $FA $8C` (`$9A79`) – all present;
- logo colours `$10 $24 $3A` on `$76` = COLOR0-2 / COLOR4 from the init table ($929B: $2C4-$2C6, $2C8);
- sky bands `$76 $74 $72` = DLI row colour table $935D;
- playfield background `$00`; status line colours `$94 $86 …` (table $936D).

So the colour analysis was right; only the palette (jakub) was not what the reference uses →
`util/palette/XFormer.act` added and made the default (jakub kept as alternative).

**Background correction** (section 12 was wrong): `$86` = `$76` is the background of the **logo area**
(DLI $8874 runs at the end of the picture). On the playfield, the DLIs ($88AA / $8929) set COLBK only for
map rows 0-1: row `r`, half `h`, first 4 scanlines from `$935D + r*8 + h*4 + line`; the last value written is
`$00`, so rows 2-9 are **black**. Rendering with this rule gives the blue bands with the top-right cloud in
them, exactly as in the screenshot.

**Layout.** The first screen (tiles 0-19 of map $3000) matches the screenshot tile for tile: ground from
tile 6, the sign at tiles 6-7, plant at 11, three trees + one, bushes, the two clouds. The player is not in
the map (P/M graphics), as expected.

**Logo.** Rendering `PICTURE.DTA` ($7100, mode E, 40 bytes per line) with colours `$76/$10/$24/$3A` shows the
"JASKINIOWIEC" title exactly as on the screenshot → block description updated (`split.py`, README); sources
regenerated and verified with MADS.

Lessons: a reference screenshot is the best test – exact palette colours can be traced back to Atari colour
values and compared with the code; and "background" on the Atari is per scanline (DLIs), not one value.

## 14. Reference screenshot in the repo (2026-10-29)

The start-screen screenshot from section 13 is now [`img/jaskiniowiec.png`](img/jaskiniowiec.png)
(1083×736, MD5 `181d3b5e3ea2ab6c1d85376f6b77ca09`), following the repo convention (`misja/img/misja.png`)
and shown at the top of the README.

Source confirmed by the user: the game was running in the **XFormer emulator**. That explains why
`XFormer.act` matched its 24 colours within 1-2 RGB steps – it is the same emulator's palette (the small
differences are rounding between XFormer and the `.act` file).

Use it as the reference for any future rendering (levels, logo, status line, sprites): compare layout and
trace exact colours back to Atari values with `util/palette/XFormer.act`.

## 15. Level pictures in the repo (2026-10-29)

The scratch-pad renders from sections 11-12 were **not** copied: they used the jakub palette and a blue
playfield background, both wrong according to the screenshot (section 13). Instead the verified rules went
into a permanent tool, [`util/levels.py`](util/levels.py), and the pictures were regenerated:

```powershell
py -3 util/levels.py game.bin img/levels
```

- Output: `img/levels/level1.png` … `level6.png` (4096×160: 256 tiles × 8 mode-4 pixels, each drawn 2×1)
  and `logo.png` (320×28, `PICTURE.DTA`).
- Rules: XFormer palette (`util/palette/XFormer.act`, overridable as 3rd argument); per-level font and
  colours from the level loaders; background from the DLI table $935D for map rows 0-1, black below;
  logo in COLOR4/COLOR0-2 `$76/$10/$24/$3A`.
- Level 2: the trainer bytes $6200-$646F are zeroed before rendering, as the crack stub at $BC00 does before
  the game starts – the picture shows what the player sees (blank sky above the cave ceiling). The garbage
  version is described in section 11.
- Checked: level 2 (cave, font B) and level 4 (ice rocks, font B) look consistent; level 1's first screen
  was already verified against the screenshot.
- README has a "Level maps" section with all six maps and the logo.

Not drawn: enemies, treasures and cave rooms (`LEVELDAT.DTA`), the player, the status line.

## 16. Stale files removed, repo cleaned (2026-10-29)

**Stale sources.** Eight files from the first split (section 2) were still in `src/` and tracked in git,
although `main.asm` had not included them since the regrouping (section 3): `CODE7C.ASM` (now
`SPRITE.ASM`, `DLI.ASM`, `PLAYER.ASM`), `CODEA0.ASM`, `START.ASM` (now `SCREEN.ASM`), `D1800.DTA`, `D2500.DTA`,
`D6470.DTA`, `D7000.DTA`, `LEVELS.DTA`. They were older and less complete (generated before the player/DLI
entry points were known, so that code was only `dta`). Found by listing `src/` files not referenced by
`main.asm`; removed with `git rm` (exact paths). `src/` now has exactly the 37 blocks + `JOINT.ASM`.
MADS build re-verified byte for byte; no document referred to the removed names.

How it happened: an earlier `git status` was clean and was taken as "the files are gone" – but clean only means
unchanged. Lesson (now in CLAUDE.md): check the file list itself, not the status.

**Clean-up.** Removed regenerable leftovers: `mem.bin` (intermediate from `emu.py`), `bin/game.obx` (build
output), `__pycache__/` in `jaskiniowiec/` (stale, from before the `util/` move) and in `util/`.
New standing rule in CLAUDE.md: clean the repo after changes (obsolete files, build/intermediate/cache files),
check with `git status --short --ignored`, delete exact paths only.

**Found while cleaning:** the original XEX in `bin/` is **not tracked** – the root `.gitignore` rule `*.XEX`
matches `.xex` too (case-insensitive file system). It is needed only to regenerate `game.bin`; README and
CLAUDE.md now say so. Committing it (a cracked commercial file) is left to the user.

## 17. `LEVEL.ASM` walkthrough (2026-10-29)

`src/LEVEL.ASM` ($9A00-$9E96) – everything between "play a level" and "show a screen":

| Routine | What it does |
|---|---|
| `$9A00`, `$9A28`, `$9A8E`, `$9AB6`, `$9ADE`, `$9B2D` | level loaders 1, 3, 5, 4, 6, 2: copy the enemy set ($D0 bytes from $A517 + $D0·n) to $C500, clear $C5D0-$C5DF, copy the cave-room table ($41 bytes from $A9F7 + $41·n) to $C600, set map base (`$8FCC/$8FD0`), attribute table (`$8DF5/$8DF6`), colours ($9349-$934C) and copy the level font (`$9221` font A / `$9239` font B) |
| `$9A79` | colours for font-A levels: `$B6 $F4 $FA $8C` |
| `$9B55` / `$9B72` / `$9B8F` / `$9BAF` | text screens intro / next level / game over / victory: fade out, park the player, clear P/M, music position (`$9215`, X = 0 or 7), then `$9C5A` with screen type 0-3 |
| `$9BDD` | text-screen colours `$16 $24 $FA $8C` |
| `$9BF2` | draws a 20×10-tile page into both screen buffers (like the map: tile b → chars 2b, 2b+1) |
| `$9C5A` | text-screen driver: page list from $9C3A (pointer, count), shows a page, fades in, waits for fire (`STRIG0`); without fire it switches pages every ~256 frames (`$13`) |
| `$9CCC` | switches the status-line text (LMS at `$89D0/$8A34`) from the table at $9CEB |
| `$9CFB` | **not** used by the levels: the ending installs it as VBI (`$B299`); scrolls the text at $A1A1 into the ending's line $B473 |
| `$9D6D` | level completion: exit tile (`$9357` bit 4) with 32 treasures → next level (`$935C`); after 6 → `$9BAF` + ending `$AEF0`. On a new level: next-level screen, reset player/treasures, energy $60, **one extra life** (`inc $A7`), patch level digits, call the loader, redraw, spawn enemies |

**Finding: level 3 has no cave rooms (crack damage or protection leftover).** Five loaders copy cave rooms with
`A0 40 B9 xx xx 99 00 C6 88 10 F7` (`ldy #$40 / lda table,y / sta $C600,y / dey / bpl`). Level 3's loader
($9A28) is 10 bytes longer: it has an extra protection check `lda $D20D / cmp #$80 / beq +3 / 3 × nop`
(failure path NOPed), and its copy reads `A0 EA EA EA AA 99 00 C6 88 10 F7` – the bytes `40 B9 38` (operand
`#$40`, `lda abs,y`, low byte of `$AA38`) are `EA EA EA`. Executed, it is `ldy #$EA / nop / nop / tax /
sta $C600,y`, which fills $C600-$C6EA with the value read from `$D20D`. Nothing in the code writes these bytes
(searched for stores to $9A44-$9A4F), so they are static in this dump. The intended table at `$AA38` exists and
has the same format as the others (16 rooms × 4 bytes).
Consequence: the cave-room scan (`$962B`) ends at once (value 0) or never matches a screen (any other value) →
no cave rooms on level 3. Treasures exist only in cave rooms (`$A6` is incremented only at `$99F0`), and a level
needs 32 → **level 3 most likely cannot be completed in this version**. Who caused it (a misplaced crack patch,
or the original protection's failure path) can't be told from this dump. To confirm: play level 3 in an emulator,
or compare with another dump. Fix would be 3 bytes: `$9A4A-$9A4C` = `40 B9 38`.

**Resolved: `$7788` / `$7879`** (open question) are the level digits on the next-level text pages: page $7718
row 5 col 12 ("etap _ kompletny") and page $77E0 row 7 col 13 ("powodzenia w etapie _"), from the table $9E49
indexed by `$935C`.

**Text pages and logo height.** The text pages (table $9C3A: intro $74C0/$7588, next level $7718/$77E0,
game over $7650, victory $78A8/$7970/$7A38) lie inside `PICTURE.DTA`. Counting the game's display list ($8974:
`4E 00 71` + 23 × `0E`) shows the logo is **24** mode-E lines ($7100-$74BF), not 28: the text pages follow
directly. `util/levels.py` drew 28 lines (4 lines of page data at the bottom of `logo.png`) → fixed to 24,
`logo.png` regenerated; level maps unchanged. Block descriptions updated (`PICTURE.DTA`, `LEVEL.ASM`), sources
regenerated and verified with MADS. The intro page text was changed by the cracker ("FILE VERSION … CAMOSOFT").

## Open questions

- Commit the original XEX to `bin/` (needs an exception in `.gitignore`)? User's decision.
- Draw enemy start positions, treasures and cave-room entrances onto the level maps (`LEVELDAT.DTA`).
- `D0500.DTA` ($0500-$07FF) and `D2800.DTA` ($2800-$2BFF, $2F00-$2FFF) – unknown.
- `CMC.ASM`: `JMP $5968` ($F372) and `JSR $5B73` ($F654) point into the maps – probably player tables taken as code.
- Confirm in an emulator that level 3 has no cave rooms (section 17); restore with `$9A4A-$9A4C` = `40 B9 38`?
- Split `PICTURE.DTA` into the logo ($7100-$74BF) and the text pages ($74C0-$7BFF)? Render the text pages.
- Runnable XEX: needs a loader for the blocks under the OS ROM and the hardware state.
