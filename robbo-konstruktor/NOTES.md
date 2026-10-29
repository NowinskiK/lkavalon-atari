# Robbo Konstruktor – reverse-engineering notes

Working log, following [DISASSEMBLY-GUIDE.md](../DISASSEMBLY-GUIDE.md). [README.md](README.md) is the reference.

## Plan

| # | Step | Deliverable | Gate | Done |
|---|---|---|---|---|
| 1 | Inventory | disk structure, file chain, segment table, tags decoded | README tables | [x] |
| 2 | Memory image | game.bin, boot chain | odd regions explained | [x] (other sectors open) |
| 3 | Entry points + disassembly | entry list, code ranges | gaps looked at | [~] 11.4 KB found, some gaps open |
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
| 2026-10-29 | Entry points: jump tables, menu/editor/key dispatch, engine object table; 11.4 KB of code (section 3) |

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

## 3. Entry points and first disassembly (2026-10-29)

Tools copied from `../jaskiniowiec/util/` per the guide: `xex.py`, `rdis.py`, `asm.py`, `verify.py`
(`image.py` now uses the local copies). Disassembly with `rdis.analyze(game.bin, entries, nofollow)`.

**Round 1 – jump table only.** `$A810-$A83D` = 16 `JMP`s (module interface): start `JMP $A9A7`, others
`$B00A $B159 $B16C $ACB6 $AC8B $B0BC $B17F $F556 $B023 $B4CD $B3F5 $B4A2 $B3BE $B189 $B03B`. Result 4.2 KB.
Start `$A9A7`: `cli / cld`, stack, `jsr $AF3E`, then the **main loop `$A9B5`**: waits for OS timer 3 (`CDTMV3`
$21C, reloaded with 4), `jsr $A81C` (→ $ACB6), `jsr $94E0`, `jsr $A9D2`. `$A9D2` moves the **editor cursor**:
X/Y in `$C5`/`$C6`, joystick bits in `$A840` (8 right, 4 left, 2 down, 1 up); X 0-19 skipping 16, Y 0-9 → probably
a 16-column board window plus a tool palette in columns 17-19 (to confirm).

**Unreached segments** – a raw scan found stores to VDSLST/SDLSTL in `$1E00-$2FFF` (the engine sets its own display
lists and DLIs) and the **engine's jump table at `$1E00`** (`JMP $1F46`, entry `$1E03`, display list at `$1E0F`),
called from `$97B6` (`jsr $1E00`) and `$97C3` (`jsr $1E03`). The `jmp (ind)` "instructions" at `$9F7F-$A7CB` are
text (`$6C` = "l"): `$9F7B-$A808` is the editor's text area.

**Dispatch tables** – all use the same trick: copy the handler address into the operand of the next `JSR`/`JMP`
and execute it (self-modified, listed as `nofollow`):

| Table | Read at | Jump at | Entries | Meaning |
|---|---|---|---|---|
| `$9F8E` (word) | `$95AE` | `$9554` (`jsr`) | 10: `979E 97C9 968F 99B5 9626 A83A 9814 9C3E 9BEB 9626` | main menu handlers; menu words after it: "kolory" (colours), "test", "planety" (planets), "strona" (page) |
| `$902F` (word) | `$9014` | `$9028` (`jmp`) | 4: `9102 91BF 909C 905A` | editor sub-commands |
| `$9AFA` (word) | `$9AE6` | `$9A61` (`jmp`) | 4: `9B02 9B1A 9B23 9B2C` | editor sub-menu |
| `$B330` (key, lo, hi) | `$B22C` | `$B238` (`jmp`) | 9: keys `1E 1F 1C 1D 7E FE FF 7D 9B` | text input: cursor keys, Backspace, …, Clear, Return |
| `$31EF` (word, index = object code × 2) | `$213A` | `$2148` (`jsr`) | 97 (codes `$00`-`$60`), 0 = no behaviour | **engine: behaviour of each board object**, called for every cell in a 16 × 31 loop (`$214B-$2159`) |

`$979E` is the menu's "test" handler: `jsr $1E00` / `jsr $1E03` (run the engine on the edited board), then
`jmp $A810` (back to the editor).

The object table's size: `asl` / `bcs` only rejects codes ≥ $80; the entries are plausible up to code `$60`
(`$31EF-$32B0`), the next word is `$0200` (junk). Engine code is Robbo-style – compare with `../robbo/d1/R2.ASM`.

**Round 3 result:** 100 entry points (16 jump table, 10 menu, 2 engine, 8 editor, 9 keys, 55 object handlers),
5 self-modified jumps (`$9554 $2148 $9028 $9A61 $B238`) → **11,438 bytes of code**, 939 labels; interrupt routines
found by the vector heuristic: `$1EDE $1EFD $1F3C` (engine DLIs) and `$B05F` (editor DLI).

Method lessons: false "address tables" are common (instruction bytes look like addresses) – confirm a table by
finding the code that indexes it; that code also shows the table's base, entry size and the jump mechanism.

## Open questions

- Sectors outside the program chain (256, 260-264, 388, 392-396, 520, 524-532, 652, 784, 974, 989): saved boards?
  The singles 256, 388, 520, 652, 784 are 132 sectors apart.
- Boot record init address $19DD – the program has no code there at boot time; what is it for?
- `JMP $F556` in the jump table – an OS ROM routine or RAM under the OS?
- Code still unreached: `$2F54` (`jsr $3379`) / `$3379-$35A3`, `$0BD0-$0C1B`, `$2470-$24DF`, `$9582-$9625`,
  `$9C04-$9C3D`; data/text to classify: `$0803-$09A5` (display list + tables), `$0C6D-$1DD0` (4.4 KB, 88 % text-like
  – boards? texts?), `$3142-$3333`, `$35D0-$3682` (display list), `$4000-$47FF`, `$9F7B-$A808` (texts).
- Editor screen layout: is it a 16-column board window + palette (cursor X 0-19 skipping 16)?
- Map engine routines to Robbo's labels (assemble `../robbo/main.asm` with MADS `-t`).
