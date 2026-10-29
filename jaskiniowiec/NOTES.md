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

## Open questions

- `D0500.DTA` ($0500-$07FF) and `D2800.DTA` ($2800-$2BFF, $2F00-$2FFF) – unknown.
- Which levels use font A ($0800) and which font B ($1000)?
- `CMC.ASM`: `JMP $5968` ($F372) and `JSR $5B73` ($F654) point into the maps – probably player tables taken as code.
- `$7788` / `$7879` are patched per level from $9E49 (inside the picture) – meaning unknown.
- Reassemble with real MADS (`make test`).
- Runnable XEX: needs a loader for the blocks under the OS ROM and the hardware state.
