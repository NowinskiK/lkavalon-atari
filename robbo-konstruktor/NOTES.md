# Robbo Konstruktor – reverse-engineering notes

Working log, following [DISASSEMBLY-GUIDE.md](../DISASSEMBLY-GUIDE.md). [README.md](README.md) is the reference.

## Plan

| # | Step | Deliverable | Gate | Done |
|---|---|---|---|---|
| 1 | Inventory | disk structure, file chain, segment table, tags decoded | README tables | [x] |
| 2 | Memory image | game.bin, boot chain | odd regions explained | [x] (other sectors open) |
| 3 | Entry points + disassembly | entry list, code ranges | gaps looked at | [ ] |
| 4 | Blocks + byte-exact build | src/, main.asm, Makefile | MADS: byte for byte | [ ] |
| 5 | Understand code | call graph, main loop, interrupts, init tables; map shared code to Robbo labels | every routine described | [ ] |
| 6 | Modules | BLOCKS regrouped, data named | byte-exact, README block table | [ ] |
| 7 | Names + comments | VARIABLES, NAMES, COMMENTS, POKES (Robbo names where code matches) | no sub_XXXX, byte-exact | [ ] |
| 8 | Graphics + verification | renders, screenshot in img/ | renders match screenshot | [ ] |
| 9 | Docs, clean, commit | README, NOTES, root README entry | clean tree, verified build | [ ] |
| – | Optional | board format and saved boards on the disk, compare editor engine with Robbo | | [ ] |

## Timeline

| Date | Step |
|---|---|
| 2026-10-29 | Disk read, boot loader understood, program file extracted, memory image built, relation to Robbo found (sections 1-2) |

## 1. Inventory – the disk (2026-10-29)

Input: `bin/Robbo Konstruktor (1990)(L.K. Avalon)(PL).atr`, 133,136 bytes. Tag `(PL)` only, but the disk itself
says "fast hack by Mr.Bacardi" – a cracked version with its own (fast) loader.

**ATR header**: magic $0296, 133,120 bytes of data = 1,040 sectors × 128 bytes (enhanced density). 250 sectors
are non-empty: 1-222, 256, 260-264, 360-361, 388, 392-396, 520, 524-532, 652, 784, 974, 989.

**No DOS.** The VTOC (360) and the "directory" (361) contain only text; the eight directory entries read
"Robbo Ko|nstruktor|by|L.K.Aval|on|--------|fast hac|k by|Mr.Bacar|di" (flags $42, no sectors).

**Boot record** (sector 1): flags $AE, 3 sectors, load address $0500, init $19DD. The boot code ($0506 ff.):

- `$054C`: clears the sector buffer $0400, reads with `DSKINV` / `SIOV` (`DCOMND` = 'R');
- `$05F5`: reads the next sector of a **DOS 2-style chain** – next sector from bytes 125-126 (`and #$03` for the
  high bits), byte count from byte 127; density check through `$02EA`;
- `$0534`: returns the next byte of the file; `$05B0`-`$05F2`: binary-file parser – start/end address (skips
  `$FFFF`), copies bytes with `sta ($43,x)`, then `jsr $0531` = `jmp (INITAD)` after each segment;
- end of file (next sector 0, `ldy #$88`) → `$0525`: `pla / pla / cpy #$88 / beq` → `jmp (RUNAD)` ($052E).
- Cracker patches visible as `NOP NOP NOP` at $052B and $05A3.

So the disk holds an ordinary Atari binary file, stored from sector 4. `util/atr.py chain 4` follows the chain:
**219 sectors (4-222), 27,285 bytes**, 14 segments (README table). RUNAD = $A810; there are no INIT segments
and nothing is packed – unlike Jaskiniowiec, no loader emulation is needed.

First looks at the small segments:

- `$BC40-$BC67` (loaded first) – one 40-character line in inverse video at the OS default screen ($BC40):
  "Robbo Konstruktor (C) 1990 Avalon" – the loading screen.
- `$0480-$0482` = `JMP $A810` – a restart hook to the program start.
- `$A810` – a jump table of 16 `JMP`s (a module interface); the start is `JMP $A9A7`. One entry is
  `JMP $F556` – into OS ROM (to check). `$A846` is a display list, not code: `C4 00 B6 C4 00 B6 C4 28 B6 …`
  = ANTIC mode 4 rows at $B600, **each row twice** – the same 2×2-character tile technique as Jaskiniowiec.

## 2. Memory image and relation to Robbo (2026-10-29)

**Memory image**: `util/image.py` = boot sectors 1-3 at $0500 (the boot loader stays in memory) + all segments
→ `game.bin` (MD5 `b22f97b7dd9d2f22d291bc80db6f6942`). Gaps: everything not loaded is zero.

**Relation to Robbo** – the repository has Robbo's original sources and their builds (`../robbo/bin/*.xex`).
Compared Konstruktor's memory with the `robbo.xex` image:

- At the **same addresses** there is almost nothing in common (0-10 % per page) – a different memory layout.
- **Fonts** (`../robbo/d2/*.FNT`, searched as 64-byte chunks anywhere): `F.FNT` 14/16 chunks found (Konstruktor
  $3C00-$3FFF), `S.FNT` 8/16 ($4800-$4BFF), `I.FNT` 8/16 ($4C00-$4FFF), `M.FNT` 0/8 – modified copies.
- **Identical runs ≥ 24 bytes** anywhere: 38 runs, 3,752 bytes. Longest: Konstruktor $3D2F = Robbo $152F
  (721, font data), $338E = $30D4 (562), $4CFF = $18FF (257), $3C16 = $1416 (234), $3155 = $2E9E (109),
  $23F7 = $2C6B (70), $1EB4 = $1C7B (42, Robbo's code starts at $1C00).

Meaning: Konstruktor reuses Robbo's graphics and part of its engine (it has to draw and test boards). The code
runs give a way to name routines with the **original labels**: assemble Robbo with MADS `-t` (label table) and
translate matching addresses.

Lesson: for a game from the same author/publisher, look for existing sources first – byte-run matching (16-byte
index, extend while equal) finds shared code and data regardless of address.

## Open questions

- Sectors outside the program chain (256, 260-264, 388, 392-396, 520, 524-532, 652, 784, 974, 989): saved boards?
  The singles 256, 388, 520, 652, 784 are 132 sectors apart.
- Boot record init address $19DD – the program has no code there at boot time; what is it for?
- `JMP $F556` in the jump table – an OS ROM routine or RAM under the OS?
- What do the other segments contain ($94E0, $9000, $0800, $4000, $35C0, $1E00, $243D)?
