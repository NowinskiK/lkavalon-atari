# Robbo Konstruktor – reverse-engineering notes

Working log, following [DISASSEMBLY-GUIDE.md](../DISASSEMBLY-GUIDE.md). [README.md](README.md) is the reference.

## Plan

| # | Step | Deliverable | Gate | Done |
|---|---|---|---|---|
| 1 | Inventory | disk structure, file chain, segment table, tags decoded | README tables | [x] |
| 2 | Memory image | game.bin, boot chain | odd regions explained | [x] (other sectors open) |
| 3 | Entry points + disassembly | entry list, code ranges | gaps looked at | [x] 12.5 KB |
| 4 | Blocks + byte-exact build | src/, main.asm, Makefile | MADS: byte for byte | [x] |
| 5 | Understand code | call graph, main loop, interrupts, init tables; map shared code to Robbo labels | every routine described | [~] engine and editor named (5.1, 5.2, 5.4-5.6); 5.3 open |
| 6 | Modules | BLOCKS regrouped, data named | byte-exact, README block table | [x] |
| 7 | Names + comments | VARIABLES, NAMES, COMMENTS, POKES (Robbo names where code matches) | no sub_XXXX, byte-exact | [x] no bare addresses left (section 30) |
| 8 | Graphics + verification | renders, screenshot in img/ | renders match screenshot | [ ] |
| 9 | Docs, clean, commit | README, NOTES, root README entry | clean tree, verified build | [ ] |
| – | Optional | board format and saved boards on the disk, compare editor engine with Robbo | | [ ] |

### Step 5 sub-plan – the editor (agreed 2026-10-29)

| # | Part | What | Done |
|---|---|---|---|
| 5.1 | Start-up and main loop | start routine, screen set-up (display lists, DLIs, fonts), per-frame loop: cursor, keys, messages | [x] |
| 5.2 | Menu handlers | the 10 handlers of table $9F8E, checked against the menu texts and named; what "test" checks (error messages) | [x] |
| 5.3 | Palette and elements | element → board cell; do the 27 names follow the object codes; variables $A317, $A7D6 | [~] codes and glyphs known; entry 21 switches the sets `PAL_SETS` into entries 22-29 (section 30); which code is which element still open |
| 5.4 | Tape and disk | save / load of planet sets → planet format; the extra disk sectors (saved sets) decoded and rendered | [x] |
| 5.5 | Engine leftovers | the 58 generated engine labels (`sub_`, `irq_`, `entry_`): Konstruktor's changes to Robbo's engine | [x] |
| 5.6 | What it is about | ABOUT.md: overview, goal, users, how it is used, elements, glossary Polish–English (suggested by the user) | [x] |

Then steps 6-8. For step 8 a screenshot of the editor (and the main menu) from XFormer is requested from the user.

## Timeline

| Date | Step |
|---|---|
| 2026-10-29 | Disk read, boot loader understood, program file extracted, memory image built, relation to Robbo found (sections 1-2) |
| 2026-10-29 | Entry points: jump tables, menu/editor/key dispatch, engine object table; 11.4 KB of code (section 3) |
| 2026-10-29 | Self-modified jump targets found automatically; sources split, byte-exact MADS build (section 4) |
| 2026-10-29 | Engine named from Robbo's sources: 110 routines + zero page (section 5) |
| 2026-10-29 | Abbreviations translated by the user; comments corrected (section 6) |
| 2026-10-29 | `$0C6D-$1DD0` = help text, 16 pages decoded – the program's full feature list (section 7) |
| 2026-10-29 | Texts written as `dta c'…'` / `d'…'` strings in the sources; Polish letter codes confirmed (section 8) |
| 2026-10-29 | `TEXTS.DTA` analysed: two encodings, editor screens, messages, element names → `TEXTS.ASM` (section 9) |
| 2026-10-29 | Editor analysed and named (5.1-5.2, parts of 5.3-5.4): 144 routines, editor variables, planet format, disk slots (section 10) |
| 2026-10-29 | Saved planet sets loaded by emulating the program's own loader: erased slots with test boards only (section 11) |
| 2026-10-29 | Palette codes and glyphs; rendering like the editor (`util/render.py`), palette sheet and test boards in `img/` (section 12) |
| 2026-10-29 | ABOUT.md: what the program is about, users, usage, elements, Polish–English glossary (section 13) |
| 2026-10-29 | Engine leftovers named (5.5): 58 labels, 17 variables, engine and title-page texts; no generated labels left (section 14) |
| 2026-10-29 | The last 30 "not analysed yet" engine routines described from Robbo's source and comments (section 15) |
| 2026-10-29 | Running in Altirra from VS Code: tasks, `util/mkatr.py` (section 16) |
| 2026-10-29 | Help screen credits found ("autor: Janusz Pelc", "Laboratorium Komputerowe Avalon") and written as strings (section 17) |
| 2026-10-29 | Hidden-text scan (`util/findtext.py`): two more texts as strings, `HDR_BUF`, reviewed ranges; 0 candidates (section 18) |
| 2026-10-29 | Step 6: 17 segment blocks regrouped into 29 modules, fonts named by use (section 19) |
| 2026-10-29 | `$F556`: OS ROM (no `PORTB` writes); the XL/XE OS buzzer – `BELL` / `OS_BELL`; written for the XL/XE OS (section 20) |
| 2026-10-29 | Copy protection found from a forum report: `PROT_KEY` / `PROT_SUM` / check in `ELEM_MSG_`; boot init $19DD = the key (section 21) |
| 2026-10-29 | Patched build without the trap: `nocopyprot.asm`, VS Code task (section 22) |
| 2026-10-29 | Second protection ("za dużo robocików!"): `PROT_BOOT` checksum of the boot loader, lock at $ACB3; patched (section 23) |
| 2026-10-29 | Help format corrected (bit 7 = end of line), `util/helppage.py`, `HELPTEXT.ASM` one line per dta; new help page 15 in `nocopyprot.asm` (section 24) |
| 2026-10-29 | Page 15 fixed after a manual edit (bit 7 only on the last character of a line), padded to $1DD0 (section 25) |
| 2026-10-29 | Saving planet sets failed (error 139): OS-B's `DSKINV` sends `P` as a read – use the XL/XE OS; `mkatr.py` also clears the ATR write-protect flag and keeps saved sets (section 26) |
| 2026-10-29 | Title-page editor typed wrong letters: XL ROM keyboard table read at a fixed address; fixed build uses `KEYDEF` (section 27) |
| 2026-10-29 | The fixed version gets its own disk: `bin/Robbo Konstruktor (1990)(L.K. Avalon)(PL)[cr CAMOsoft 2026].atr` (section 28) |
| 2026-10-29 | GitHub Actions workflow: MADS from source, original (byte-exact) and fixed version, disk images as artifacts (section 29) |
| 2026-10-29 | Step 7: ~330 bare addresses named (OS, zero page, buffers, tables, self-modified operands), 4 hidden routines disassembled – among them the boot loader of the saved game; palette entries 22-29 explained (section 30) |

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

## 4. Remaining entries, split and byte-exact build (2026-10-29)

**Closing the gaps.** The unreached code areas had no direct `JSR`/`JMP`; searching their start addresses as
immediate pairs found how they are reached:

- `$2F54` – the engine's **deferred VBI**: `ldy #$54 / ldx #$2F / lda #$07 / jsr SETVBV` at `$1FEA` (the old VVBLKD
  is saved to `$3332/$3333` first).
- `$2470` – written into `$246E/$246F` at `$244D`; `$246D` is `JMP $246D`, a jump to itself that waits until its
  operand is patched.
- `$9582`, `$9C06` – written into `$9555/$9556`, the operand of the menu dispatch `jsr` at `$9554` (from `$9566`,
  `$9D97`, `$9BF2`): commands that set the next command.
- `$29D3`, `$2A93` are data tables read by code; `$9C04/$9C05` are two variables.

**Disassembler improvement** (`util/rdis.py`, this game's copy): the operands of `NOFOLLOW` jumps are treated
like vectors – an immediate address written into them (`lda #lo / sta op+1 / lda #hi / sta op+2`, any registers)
becomes an entry point; and `ldy #lo / ldx #hi / jsr SETVBV` installs a VBI routine. This found `$2470`, `$2F54`,
`$9582`, `$9643`, `$9A64`, `$9C06` automatically → **12,538 bytes of code**.

**Split** (`util/split.py`, generic part copied from Jaskiniowiec): entry points = `ENTRIES` (hook `$0480`, boot
`$0506`, `$0800`, engine `$1E00/$1E03`, jump table `$A810-$A83D`, menu handlers) + the dispatch tables read from the
image (`entries()`: object table `$31EF`, `$902F`, `$9AFA`, key table `$B330`); `NOFOLLOW` = the six self-modified
jumps. First cut by segments, 17 blocks (README). `$0800` turned out to be `JMP $09A6` (code), so the first block
starts there. Local OS labels added to `util/xex.py`: `DSKINV`, SIO control block `DDEVIC`…`DAUX2`, `CDTMV3`,
`DVSTAT` – the boot loader now reads with names.

**Result:** `py -3 util/split.py game.bin` → `"$MADS" main.asm` → **matches game.bin byte for byte** (MADS 2.1.5,
27,679 bytes written); the `asm.py` fallback matches too. `Makefile` like the other games. Only one label left
outside the blocks: `$F556` (a jump-table entry into OS ROM).

## 5. Naming the engine from Robbo's original sources (2026-10-29)

**Label table.** `../robbo/main.asm` needs level objects that are built first, so only the engine was assembled:
`"$MADS" ../robbo/d1/R1.ASM -t:<scratch>/r1.lab` (R1 includes R2; output in the scratchpad, nothing written to
`robbo/`) → 270 labels, 218 of them code in $1C00-$3FFF.

**Instruction-shape match.** The engine is at other addresses in Konstruktor, so absolute operands differ. A
signature = the next 8 instructions as (opcode, operand) where the operand is kept only for position-independent
modes (immediate, zero page, relative); a Robbo label is mapped when its signature occurs at exactly one
Konstruktor instruction start, and the signature is not just `BRK`s (that removed a false `$F556` = `CONG`).
Result: **90 unique matches**, 6 ambiguous.

**Call-site propagation.** Matched routine pairs are walked in parallel; where Robbo's `JSR`/`JMP` goes to a labelled
address, Konstruktor's target at the same place gets that label – repeated until nothing changes, accepted only
when all call sites agree. +**20 names**, no conflicts, among them the board primitives that the shape match could
not tell apart (same shape): `LT_ RT_ UP_ DW_` (step one cell, carry set if free – from Robbo's `PO2L`:
`jsr LT_ / bcs … / inc X`), `GET_ PUT_ TST_` (read / write / test the board cell at X/Y), `T_UP T_DW T_EX`.

**Zero page.** The shape match compares zero-page operands, so 90 matches mean the engine keeps **Robbo's zero-page
layout** ($80-$AA). Only `ENGINE*.ASM` use that range (checked), so Robbo's names were applied: `ADDR SCRA CHAD
FADR X Y X1 Y1 FX FY LM VSF VSC TELE FAC CNUM KEYS LIVS ZEBR LSTE NABO DEMO SCOR HLP RUCH TOLE` (comments
inferred from the Polish abbreviations where Robbo has none: `LIVS` lives, `NABO` naboje = ammunition, `ZEBR`
zebrane = collected, `SCOR` score BCD, `VSF/VSC` vertical scroll fine/coarse).

**Meaning of the families** (from Robbo's code, `R2.ASM`; *corrected in section 6*): `DZ1x/DZ2x/DZ3x` = *działko*
(small gun) firing, 1 small gun, 2 laser, 3 blaster, x = L/R/U/D; `POnx` = *pocisk* (bullet) of that gun moving;
`PPnx` = *pozycja pocisku* (bullet's position) – next cell, hit tests; `BEZL..BEZD` = objects moving until blocked
(abbreviation unexplained); `PRZY` = pulled in by a magnet (Robbo destroyed);
`PUTW` = put an explosion (*wybuch*) or empty space; `TDOR` door (needs `KEYS`), `TSKA` screw, `TWYJ` exit, `PHAJ`
push, `NIES` surprise box, `DZRU` rotating gun, `MODL/MODR` moving gun, `SCRL..LDW` scrolling, `SOUND_..SOPL` sound.
Comments in `COMMENTS` quote Robbo's Polish comment with a translation; routines whose purpose is not yet clear say
"Robbo routine …, not analysed yet".

**Tool change** (`util/split.py`): a name in `NAMES` also creates a label at a fall-through entry (`WFAC`, `LDW`
had no label because Konstruktor reaches them without a jump).

Result: 110 engine routines and 26 zero-page variables named; 26 engine routines still `sub_XXXX` (Konstruktor's own
code or no match – named in section 14); MADS build still byte-exact.

Lesson (also in the guide): with related sources, match by instruction shape (ignore absolute operands), then
propagate names through call sites – it finds routines a direct match cannot separate.

## 6. Abbreviations from the user (2026-10-29)

The user (a Polish speaker) explained Robbo's label abbreviations:

| Prefix | Polish | English | Was assumed |
|---|---|---|---|
| `DZ` | *działko* | small gun | *działo* (gun) – same meaning |
| `PO` | *pocisk* | bullet | correct |
| `PP` | *pozycja pocisku* | bullet's position | "place the bullet one cell further" – wrong |
| `BEZ` | – | unknown | *bezwładne skrzynie* (sliding boxes) – my guess, not confirmed |

Changes: the comments in `util/split.py` now say "small gun (działko)", "bullet (pocisk)", "bullet position (pozycja
pocisku): next cell …, hit tests". For `BEZx` the comment describes only what the code does – the object moves in
one direction until blocked, then continues as a bullet (`BEZL: jsr LT_ / bcc BEZX / jsr BEZS / jmp PP1L`) – and
marks the abbreviation as unexplained (Robbo's own comment is only "bezw skrzynie"). Sources regenerated, MADS
build byte-exact.

Lesson: don't present a guessed expansion of an abbreviation as fact – describe the behaviour from the code and mark
the name as unexplained until someone who knows confirms it.

## 7. The help text – Konstruktor's manual (2026-10-29)

The 4.4 KB block `$0C6D-$1DD0` (scored 88 % "text-like" in section 3) printed as 16-byte ATASCII rows is not boards
but **Polish prose**: "Mamy zaszczyt przedstawić pierwszy szeroko dostępny program użytkowy firmy Avalon – Robbo
Konstruktor. Pozwala on na tworzenie i testowanie dowolnych planet…" It is the help shown with the HELP key.

Format (from the bytes): 10 zero bytes, `$0C77`: `79 0C 80 01` (not understood yet), then the text. `$00 nn` starts
page *nn* (16 pages, 0-15); **bit 7 set = the character is followed by a space** (`pierwsz[F9]szeroko` =
"pierwszy szeroko", `[AE]` = ". "); Polish letters as low codes (`$01` ą, `$03` ć, `$05` ę, `$0C` ł, `$0F` ó,
`$13` ś, `$1A` ż), `$14` quotation mark (titles are `"…:"`), `$1C-$1F` the arrow characters. Mapping derived from
context; `$0E` (ń?) and `$1A` also standing where ź is expected ("podpowiedż") – asked the user.

The pages are the full feature list (README "Help text"): main menu at the bottom of the screen, test planet, clear
planet, colours, tape/disk operations for a set of planets, additional/basic function sets, title-page texts, planet
order, test the whole game, **save a stand-alone Robbo game**, the element palette "in the right part of the screen"
(confirms the cursor layout from section 3: board on the left, palette columns 17-19), the planet editor, and an
anti-piracy notice. "Planets" are Robbo's caves.

Block renamed `D0C6D.DTA` → `HELP.DTA` (`git rm` of the old file), sources regenerated, MADS build byte-exact.

Lesson: a Python write without `encoding='utf-8'` failed on "ą" *after* opening the file and left README.md empty;
restored from git. Always pass the encoding when writing text with non-ASCII characters on Windows.

## 8. Texts as strings in the sources (2026-10-29)

Suggested by the user (example: `robbo/d1/TITLE.ASM`, which writes its texts as `DTA D'…'`): texts are more
readable in the `.ASM` source than in a binary data file, and MADS encodes them.

**Atari character codes.** Two codings: **ATASCII** (OS, keyboard; MADS `c'…'`) and the **screen (internal) code**
that ANTIC reads from screen memory (MADS `d'…'`). ATASCII → screen: `$00-$1F` +$40, `$20-$5F` −$20, `$60-$7F` same;
bit 7 = inverse in both; a trailing `*` sets bit 7 on the whole string (MADS docs, "dta"). The help text is ATASCII,
the loading-screen line is screen code in inverse video.

**Polish letters confirmed** (both open questions answered from the program itself): help page 8 says Polish letters
are typed as CONTROL + a, c, e, l, n, o, s, z and lists them – "ą,ć,ę,ł,ń,ó,ś,ż" – exactly in the order of the codes
`$01 $03 $05 $0C $0E $0F $13 $1A` (= CONTROL + that letter in ATASCII). So `$0E` = ń, and there is only one z: ż and
ź share `$1A` ("podpowiedż"). Robbo's own TITLE.ASM solves the same problem differently (Polish glyphs on `@ \ [ ] _
{ ^ |`).

**Implementation.** `util/split.py` `TEXTS` = address ranges with a format; `util/rdis.py` renders them:
printable characters as `c'…'` (ATASCII) or `d'…'` (screen code), runs of inverse characters as `…'*`, everything
else (Polish CONTROL codes, quotes) as `$xx`; above each `dta` line a comment with the decoded Polish text (help
format: bit 7 = a space follows, `$00 nn` = page marker → `* help page N ---`). `HELP.DTA` → `HELP.ASM`,
`LOADSCR.DTA` → `LOADSCR.ASM` (old binaries removed with `git rm`). Sources are now written as UTF-8 (Polish letters in
comments); MADS ignores comment text. `util/asm.py` learnt `c'…'`/`d'…'` strings and quote-aware comment/argument
parsing. MADS and `asm.py` builds both byte-exact.

Example (`src/HELP.ASM`):

```
; Mamy zaszczyt przedstawić pierwszy szeroko dostępny program
         dta c'Mamy zaszczyt przedstawi',$03,c' pierwsz',c'y'*,c'szeroko dost',$05,c'pny program ' ; 0C7B
```

Lesson: generating Python code from a shell here-document mangled `\2` into the byte `$02` (twice) – avoid
backslash-digit sequences in generated code (use named groups) and check for control characters after scripted edits.

## 9. The editor's texts (2026-10-29)

`$9F7B-$A808` printed side by side as ATASCII and as screen code reads correctly in *different* places – the block
mixes two encodings:

- **Screen code** (`$9FBB-$A316`): `$00` is the space character there, so the zero bytes are spaces and blank screen
  areas, not separators – this is laid-out screen text. Printed as 40-character rows it shows the editor's screens:
  the **main menu** (5 rows × 2 columns of 20: left the basic functions "test planety, czyść planetę, zmiana kolorów,
  operacje dyskowe, funkcje dodatkowe", right the additional ones "strona tytułowa, kolejność planet, test Robbo,
  zapisz Robbo, funcje podstawowe" – the table `$9FB6` = 20, 60, 100, 140, 180 are the right column's offsets), the
  title, the planet legend, the disk panel and the save hints. Polish letters on the glyphs `@ \ [ ] _ { ^ |` – the
  same trick as Robbo's TITLE.ASM (the help text and messages use the CONTROL codes instead). "funcje podstawowe" is a
  typo in the original.
- **ATASCII** (`$A318-$A7D5`): `$00`-terminated strings, spaces are `$20`, bit 7 = **inverse highlight** (e.g.
  "**błąd:**", "**Uwaga:**") – unlike the help text, where bit 7 means "a space follows". Contents: key hints, error
  messages of the test functions ("brak robocika", "brak kapsuły", "za dużo robocików / kapsuł / śrubek – max: 99",
  "planeta jest pusta"), questions, tape/disk messages ("szukanie początku zestawu planet", "ten zestaw planet jest
  zniszczony", "dyskietka jest uszkodzona", "błąd numer 100"), and the **27 element names** of the palette.
- Two bytes inside the block are **variables**, found because code reads/writes them: `$A317` (by `$968F` – a menu
  handler – and `$9CE4`, `$9D07`, `$9DAC`) and `$A7D6` (`$9CDF`, `$9CE7`, `$9F52`). Meanings still open.
- `$A7D8-$A7F7`: four 8-character labels read with `lda $A7D8,x` (" wczytać", " zapisać", "skasować", "kasetowe");
  `$A7F8-$A803`: two small tables; `$A804-$A808`: "Robbo".

Method: classify each string by which decoding gives plausible Polish – but lowercase letters are identical in both
codings (`$61-$7A`), so the decisive clue was the meaning of `$00` (space in screen code). Confirmed by the readers:
code that indexes the texts and writes the two variables.

Implementation: two new `TEXTS` formats in `util/rdis.py` – `screen-pl` (screen code, 40-character rows, comment with
the glyph-mapped Polish letters) and `strings` (ATASCII, one string per line incl. its `$00`, inverse runs as `…'*`);
`TEXTS.DTA` → `TEXTS.ASM`; strings may now contain `{ | } ~` too. MADS and `asm.py` builds byte-exact.

Lesson: write analysis scripts to a file (Write tool) instead of passing them through a shell here-document – the
shell layer collapses backslashes (`'\\'` arrived as `'\'`).

## 10. The editor (steps 5.1-5.2, parts of 5.3-5.4) (2026-10-29)

Method: a call graph of all 112 editor routines (size, callers, callees, hardware, zero page, tables – scratch
script), then reading each cluster with a compact dump of the generated sources (names already shown). Every name
below rests on code that was read.

**Structure**

| Area | Content |
|---|---|
| `$A810` jump table | module interface: `START` (→ `START_` $A9A7), `CLICK`, `INPUT_CLR`, `GETKEY`, `REDRAW`, `COUNT_ELEM`, `INPUT`, `DIR_TEST`, `KEY_EVENT`, `TO_DIGITS`, `ASK_YESNO`, `ATA2SCR`, `SET_DLIST`, `TITLE_ED`, `WAIT_KEY`; `$A828` = `jmp $F556` has no callers (leftover) |
| `MAIN_LOOP` $A9B5 | every 4 frames (OS timer 3): `REDRAW`, `ED_FRAME`, `EDIT` |
| `ED_SETUP` $AF3E | one-time part (patches its own `lda #0`): zero page $B0-$D0, cursor 18/9; every time: screen off, colours, key repeat, DLI `ED_DLI` $B05F, **font $4C00**, P/M positions ($B5BC) |
| `$94E0` jump table | editor services: `ED_FRAME`, `ED_INIT`, `ED_COLORS`, `MESSAGE`, `IO_MSG`, `ELEM_MSG`, `ED_DLIST`, `HELP_KEY` |
| `REDRAW` $ACB6 | palette (columns 17-19, element codes $B51C → glyphs via $B55A), the 16 × 10 board window from row `WIN_TOP`, planet strip / scroll bar, enlarged element preview ($43E0/$47E0), display lists swapped ($A846 / $A8A3, screens `SCR_PAGE` $B6/$B8) |
| `HELP` $0800-$0C6C | help viewer: `HLP_PAGE` (16 lines), `HLP_LINE`, `HLP_PREV/NEXT` (markers $0909/$090A), scrolling |
| `IO_*` $9000-$9430 | tape/disk (below) |
| `TX_*` $B254-$B34C | text input for the title page (key table $B330: arrows, backspace, delete, insert, clear, return) |

**Main menu** (`MENU` $9582): the table index is row + 5 × page (`MENU_POS` bit 7 = page): entries 0-4 = left column
(basic functions), 5-9 = right column (additional) – exactly the layout of the menu text. Handlers: `M_TEST`
(test planety), `M_CLEAR` (czyść planetę), `M_COLORS` (zmiana kolorów), `M_DISK` (operacje dyskowe), `M_PAGE`
(funkcje dodatkowe / podstawowe – one routine flips the page), `TITLE_ED` (strona tytułowa), `M_ORDER` (kolejność
planet), `M_TESTALL` (test Robbo), `M_SAVEGAME` (zapisz Robbo → `SAVEGAME_GO`). **`HELP_PAGE` ($CE) = index / 2 + 3**
(2 while in the menu) – exactly the help page order: the HELP key is context-sensitive.

**Planets** (`CELL_ADDR` $AC6F): planet n at **`$5000 + n × $200`**, 16 × 31 cells row by row, header at offset
`$1F0-$1F7` (colours; defaults `$9F83`), `$1F7` bytes saved. Cells hold **Robbo's level characters**: `$20` empty,
`$2A` Robbo, `$14` capsule, `$24` screw (`PLANET_TEST` $AC15: Robbo exactly 1, capsule exactly 1, screws < 100 –
error messages 4-8). `PLANET_STATE` ($39A0, 32 bytes): 0 empty, bit 7 = bad (low bits = message), else good –
the legend "zła / dobra / pusta". `PLANET_CLR` fills with `$20` and restores the header.

**Tape / disk** (`IO_CMD` $9000): command letters `r w e d` (read, write, erase, directory, table $902B). Slot header
sectors (table $9037): **4, 256, 388, 520, 652, 784** – the extra used sectors on the disk are the 5 slots of saved
planet sets (slot 0 = sector 4, the program's own start). Header signature: inverse **" RKdata "** (used) or
**" unused "** (erased). `IO_RDSEC`/`IO_WRSEC` (SIO `R`/`P`, buffer $9431), `IO_FORMAT` (SIO `$22`, used by
`IO_SAVEGAME` – "zapisz Robbo" formats the disk and writes a stand-alone game). Without a disk drive, `ED_INIT_`
copies " kasetowe" over the menu word – the menu then says "operacje kasetowe".

**Engine entries**: `ENGINE_INIT` ($1E00: screen, DL $1E0F, DLI, font $3C00, score/keys/ammo cleared) and
`ENGINE_PLAY` ($1E03: A = planet data page, X = number shown, Y = lives, carry = demo; installs the engine VBI and
returns to the editor) – used by `M_TEST` and `M_TESTALL`.

**Answers to open questions**: `$A317` = `CUR_MSG` (message in the status line, `MESSAGE_` compares and stores
it); `$A7D6` = `CUR_ELEM` (palette entry whose name is shown; name = message entry + $1E) – so the 27 element names
follow the **palette order**. `$14` in the help text is **not a quotation mark but an inverse on/off toggle**
(`HLP_LINE`: `eor #$80` into $0C76) and inverse digits `$B1-$B9` are indentation codes – corrected in README.

**Naming**: 144 editor / help / I/O / boot routines named (`util/split.py` `NAMES`, prefixes `HLP_ IO_ ED_ M_ DISK_
TX_`, jump-table targets = service name + `_`), each with a comment; editor variables `FRAMES CUR_X CUR_Y WIN_TOP
SCR_PAGE PAL_SEL ED_FLAGS MENU_POS PLANET HELP_PAGE PANEL_ST CUR_MSG CUR_ELEM JOY… PLANET_STATE DISK_SLOTS`. MADS and
`asm.py` builds byte-exact. The 58 generated labels left are all in the engine (step 5.5).

## 11. The saved planet sets on the disk (step 5.4) (2026-10-29)

**Format** (from `IO_SAVESET` / `IO_LOADSET`): after the 8-byte slot header, a stream of segments like an Atari binary
file without `$FFFF`: start, end (inclusive), data; a start of `0000` ends it. `IO_CHECK` accepts only `$39A0-$39E0`
(planet tables), `$3A00-$3BFF` and `$5000-$8FFF` (planets). A set is saved as the list `$92E1` (`$39A0-$39DF`,
`$3A00-$3BFF`) plus one segment `$5000 + n × $200 … +$1F7` per used planet. The list `$92EB` (`$1E00-$3FFF`,
`$4800-$4FFF` – engine and fonts) is what "zapisz Robbo" writes for the stand-alone game.

**Method – emulate the program's own loader** (guide lesson): `util/emu.py` (copied from Jaskiniowiec) got an SIO
hook – an OS disk call (`DSKINV $E453` / `SIOV $E459`) reads the requested sector from the ATR into the buffer named in
the control block – and a `VCOUNT` stub that reaches every line value. `util/planets.py` runs `IO_CMD` with
`A = 'r'`, `X = slot` on `game.bin` and dumps memory after each slot.

**Result**

| Slot | Header | Sectors read | Planets (status) |
|---|---|---|---|
| 1 | " unused " | 256-264 | 0 (`01`) |
| 2 | " unused " | 388-396 | 0 (`01`) |
| 3 | " unused " | 520-532 | 0, 1 (`01 01`) |
| 4, 5 | " unused " | header only | – |

All headers are the plain " unused " signature (`20 75 6E 75 73 65 64 20`, written by `IO_ERASE`) – the sets were
**erased**; erasing rewrites only the header, so the old data is still readable. The planets are tiny **test boards**:
sets 1/0, 2/0, 3/0 are identical – Robbo (`$2A`) at row 0 column 15, a capsule (`$14`) at row 4 column 13 and four
cells of code `$00`; set 3/1: capsule, Robbo and three `$00` cells. So the disk holds no real levels – probably
someone checking the save function.

Also explained: the step-1 "gap" (slot 1 data at 260-264 after header 256) – sectors 257-259 are read too but contain
only zeros (mostly empty tables), so the used-sector scan did not count them.

Next: render a palette sheet (element code → glyph, name) – needs the element → glyph mapping (step 5.3) – and the
four test boards.

## 12. Palette and rendering (steps 5.3-5.4) (2026-10-29)

**How the editor draws a cell** (`REDRAW_`, `PUT_CELL` $AEDD, `ED_DLI` $B05F): element code c → index
`(c & $7F) − $20` (wrapping below 0) → glyph g = `$B55A[index]`; a cell is **2 × 2 characters**: codes `2g`, `2g+1`
(bit 7 kept), screen address row × 40 + column × 2; the display list shows each row twice and the DLI switches CHBASE
between **`$40` and `$44`** on alternate lines – so the board font is `$4000-$47FF` (`D4000.DTA`: top halves at
$4000, bottom halves at $4400). Mode 4, bit 7 → PF3. Colours from the planet header via `ED_COLORS_`: bytes 2-6 =
COLOR0-COLOR4, byte 7 = PCOLR3; defaults `$9F83` are all hue 0 (grey).

**Palette** (`$B51C`, 32 entries; the names are messages entry + $1E – README table): the codes are Robbo's level
characters. Rendering the glyphs answered the doubt raised by Robbo's level parser (which maps `$A0` to "█"): in the
palette `$00` "murek" draws a brick wall, and `$A0` (entry 21, "zmiana dział, nietoperzy i teleportacji") draws empty
– it is a mode switch, not an element. Entries 22-29 are placeholders (`$78`) for bats, gun, laser, blaster,
teleport, whose real codes depend on that switch (still to read in `EDIT`).

**Tool** `util/render.py` (XFormer palette): `palette` → `img/palette.png` (all 32 entries, names on stdout);
`planet` → one planet from a memory image. The four test boards from the disk: sets 1/0, 2/0, 3/0 are byte-identical
images → `img/test-board-1.png`; set 3/1 → `img/test-board-2.png`. They show Robbo, the capsule and brick-wall cells,
exactly as the data says – confirming code → glyph → 2 × 2 characters → fonts $4000/$4400.

`util/render.py` sets its stdout to UTF-8 (Polish element names) – printing failed with the Windows code page when
the output was redirected.

## 13. ABOUT.md – understanding the application (2026-10-29)

Suggested by the user: besides the code, step 5 should produce an understanding of what the program is about, in a
separate file with sections (overview, goal, users, glossary) and the mapping of terms between the languages.

`ABOUT.md` is built only from evidence and marks interpretations: the help pages (purpose, functions, controls), the
editor texts (menu, messages, element names), the code (planet format, test rules, palette codes) and Robbo's own
instruction text (`../robbo/d1/TITLE.ASM`, label `INST`) for the game's story – Robbo escapes a hostile planetary
system; on each planet a capsule waits, but it is incomplete, so Robbo collects its parts (the screws) while evil
creatures try to stop him. Sections: overview, the game it builds, goal of the program, users (the player-designer
and the players of the saved game), how it is used (menu function table), elements (palette with roles), glossary
(program terms, messages, tape/disk, engine label abbreviations with who confirmed them).

The convention is now general: `CLAUDE.md` and `DISASSEMBLY-GUIDE.md` (step 5, plan template, definition of done) ask
for an `ABOUT.md` in every game folder.

## 14. Engine leftovers (step 5.5) (2026-10-29)

**Starting point**: 58 generated labels, all in the engine – 26 `sub_`, 5 `irq_`, 27 `entry_`. Each routine was read
and compared with Robbo's sources (`../robbo/d1/R1.ASM`, `R2.ASM`) by hand – the shape match of section 5 had missed
them because Konstruktor changed them.

**Method 1 – the object table in parallel with Robbo's `PROC`.** `$31EF` is indexed by object code × 2, like Robbo's
`PROC` table (`R2.ASM`, `DTA D'    '` = two empty entries). Reading both side by side (scratch script) gave the
handler of each code: `$0B/$0C MGFL/MGFR`, `$14 WYZA`, `$15/$16 WYOT`, `$1B WFAC`, `$1D DZ1D`, `$1E DZ1L`, `$1F DZ1R`,
`$26 LEDZ`, `$2A MFAC`, `$30-$38 TELP`, `$3A NIES`, `$41-$4C STWA-STWL`, `$4D/$4E TOPL/TOPR`, `$60 BOMB` – each then
checked against Robbo's code (same calls, same codes put). Differences: Robbo's `$28 MGNL` is empty (moved, below);
`$27` points to `DZ2D` (empty in Robbo); **`$39` has its own handler `TELE_IN` ($28ED)** – `PHAJ` ($27B5) saves the
teleport Robbo walks into in `TELE_CODE` ($28EC) and puts `$39`; the next turn restores it and sets `TELE`.

**Method 2 – reading the reworked routines against `R1.ASM`.**

| Address | Name | Evidence |
|---|---|---|
| $20C4 / $20FC | `WYBC` / `WHIL` | same loop as Robbo's "wybu komnate": cells other than `$20 $00 $13 $11 $05` → `RANDOM & 3 + $61`; `WHIL`: timer $21E = $30, `CHNGCV` until 0 |
| $210B | `CHNGCV` | the cell loop calling `$31EF` through the self-modified `JSR $2148`, bit 7 / `$61-$7A` handling as Robbo's `NOR_` / `NXT_`; `$210A` = `CNTR`; the frame timer moved to the end (`CDTMV3`) |
| $219F / $2247 | `PLA1` / `ENTCV` | header copy, `ZEBR`, colours, players `$40 $60 $80 $A0`, `TELE/KEYS/NABO/RUCH`, `LM = $0D` as Robbo's `PLA1`; `ENTCV` = "wejscie": wall shapes by the header (operand `$2248` = header byte $F0), `*` → `MFX1`, `+` and `LSTE` |
| $23A0 / $23A6 | `WAIT` / `HALT` | identical to Robbo's (`RTCLOK+2`); `$3913` is a copy (`TP_HALT`) |
| $1EDE, $1EFD, $1F3C | `DLI1-3` | Robbo's `DLI` dispatches on a counter; Konstruktor chains by rewriting `VDSLST`: players → PCOLR3; info line (VCOUNT $60, font $4C, DMA); text colour `RTCLOK / 4` |
| $2470 | `DRAW_ROW` | not an interrupt: the target of the self-modified `JMP $246D` (`lda #$70 / sta $246E` looked like a vector set-up); draws a board row as 2 × 2 characters, switches the target to `$2498` after waiting a frame at the visible window |
| $2582-$2648 | `TFAC ZABJ MGNL FAC_TURN FAC_MOVE` | Robbo tests "czy obok jest fac?" in every creature (`STWA: JSR TFAC`); Konstruktor's creatures do not – instead `TFAC` checks the four cells around Robbo for eyes `$26` / creatures `$41-$4E` (`ZABJ`: explosion `$61`), `MGNL` looks along Robbo's row for magnet `$29` right / `$28` left and puts `$0C` / `$0B` (`MGFR` / `MGFL`); `FAC_MOVE` = the rest of Robbo's `MFAC` (`STRC` $26CF, `KIES`, `KIET` $26C7) |
| $26B9 | `SJMP` | `JSR *` with operand from `KIET` – as Robbo's `SJMP` |
| $2F54, $307F | `CVBL`, `INFO_BYTE/DIGIT` | Robbo's VBI: `SOUNDV`, planet number via `BDEC` ($2F53), ammunition / keys / lives / screws / score at the same offsets (`ldy #$25 $1F $19 $13 $0D $07`); digits from tables $309E / $30A8 (two-line digits) instead of `DSPD`'s arithmetic. `DSPB` / `DSPD` are taken by the editor's copy ($9EE2) |
| $30B2 | `KEJO` | replaces Robbo's `KEJO` / `TETR`: fire = `TRIG0 & TRIG1 & SHIFT & RETURN` (RETURN through the operand $30CF), ESC `$1C` → `ESC_KEY`, cursor keys (table $314A → $314F) through the operand $3114 AND both sticks (`PORTA`) → `MOVE_IN` |
| $35C0-$3919 | `TP_*` | the title page of the stand-alone game: display list $35D0 (logo $B600 in mode A, texts $3A00 / $3B00, two narrow lines from $3603 or $3643); `M_TESTALL` sets `TP_TEST` and jumps to `TP_START`; `TP_PLAY` walks the order table $39E0 (bit 7 = used), finds the planet whose header byte $F0 matches, calls `ENGINE_PLAY` with 8 lives, saves a restart point (`TP_RNUM/TP_RPOS`) every 4 planets; OPTION or ~8 × 256 frames → demo (`TP_DEMOFLAG`, carry to `ENGINE_PLAY`) |

Also named: `ENGINE_INIT_` / `ENGINE_PLAY_` (jump-table targets), `PLAY_ABORT` ($202C: BREAK from `CHNMON` – `BRKKEY`
$11 = 0 – or the end, Y = $99), `PLAY_EXIT`, `TP_LOOP`, `TP_EXIT`; `ENGINE_PLAY` with Y = $FF gives one try (the
operand of `ldx #` at $207D holds Y: `inx / beq` → game over at the first death) – used by "test planety"
*(interpretation from the code)*. `WFAC` is now code `$1B`'s entry $2615 (sets `FAC` first); the old `WFAC` $2619 is
`WFA1`.

**Texts**: the engine info lines $1E8E / $1EB6 (40 characters, `DLI2` sets normal width) and the title page lines
$3603-$3682 (4 × 32 characters, narrow playfield) are now `dta d'…'` strings (`TEXTS` in `split.py`) – README
"Engine structure".

**Not code**: `$3120-$312F` (`lda $3146 / bne / lda #$FF / sta $3146 / sta $3142 / lda #$00 / rts`) is never
referenced – a leftover routine, kept as data.

**Tool note**: `MADS` was not in this session's environment (set for the user, the session started earlier); the build
used the value from the user environment (`HKCU\Environment`), not a hard-coded path.

Result: no generated labels left anywhere (`grep -E '^[a-z]+_[0-9A-F]{4}' src/*.ASM` is empty); 65 names, 17
variables; MADS and `asm.py` builds byte-exact.

Lesson (guide): a self-modified `JMP` whose operand is set with `lda #lo / sta op / lda #hi / sta op+1` looks like a
vector set-up – check the store address before calling the target an interrupt handler.

## 15. The remaining Robbo routines described (step 5.5, part 2) (2026-10-29)

After section 14 every label had a name, but 30 engine routines named by the shape match (section 5) still had the
placeholder comment "Robbo routine …, not analysed yet". Each was read in Konstruktor next to Robbo's source; the
`COMMENTS` in `split.py` now say what they do. No placeholder is left in `src/`.

Findings worth keeping:

- **`WHAT` ($32B1, Robbo `R2.ASM` 1721) – property of each object code**, returned by `T_EX`. Robbo's legend line
  `* !zas "wyb #itoito` gives the values as screen codes: `!` = 1, `"` = 2, `#` = 3. The code says what the bits do:
  bullets (`PPP1`, `lsr` → carry = bit 0) destroy cells with bit 0 – a bomb becomes a lit bomb (`WYBO`), a surprise
  is opened (`PUNIES`), others explode; `BOMB` destroys cells with bit 1 (`and #%10`). So 1 = "zas" – shot
  (*zastrzelić*?), 2 = "wyb" – blown up (*wybuch*), 3 = "i to i to" (both) *(expansions are guesses – to confirm)*.
- **"super!"** (`SUP1` / `SUP2`, in `NIES`): a rare surprise – over the whole board magnets vanish, doors, eyes and
  creatures explode, +500 points (`ASCO` with X = $05).
- **Barrier** (`ZAPO`, code $11, Robbo comment "zapora"): moves a block `$0F` along the row to the right until the end
  piece `$05`, then starts again – not in the editor's palette *(interpretation of the movement)*.
- **Robbo's animation** (`CM1 CM2 FA1 CM3` in `ANIM`): element shapes for the animation phase (`CNTR`) come from the
  shapes font $4800 – characters $1C-$1F and $0A-$15 – and Robbo's own shape for the direction LM and walking phase
  goes to characters $5E/$5F; while he walks, bytes of the engine code are written to `CONSOL` as a footstep click
  (Robbo's comment "-tup-").
- **`MFEX` lost Robbo's creature and magnet tests** ("stworek?", "tst mgnes") – they are `TFAC` / `MGNL` in
  Konstruktor (section 14); `MFEX` now computes Robbo's screen address itself (row × 64 + column × 2 + $B600) for the
  scroll target in the `FADR` operands $2491 / $2495.
- Sound (`PSST RESE SO1-SO3`), teleport exit (`WYCP WYSE`), eyes (`LEX SKAC`), rotating gun (`RDZL RDZ1`), Robbo's
  move (`MFC1 MFX1 FGET KIES`), the step dispatcher (`FD_ JMP1`) and `TST_W` (outside the board = wall `$A0`) are as in
  Robbo.

Builds: MADS byte-exact.

## 16. Running the game from VS Code (2026-10-29)

Asked by the user. **`.vscode/tasks.json`** (repository root) has three tasks, run with PowerShell 7 in
`robbo-konstruktor/`: *run original* (boots the original ATR), *build + verify* (default build task: MADS, then
`verify.py`), *run build* (build → `util/mkatr.py` → boot `bin/build.atr`). Altirra comes from the new **`ALTIRRA`**
environment variable (set for the user: `…\Altirra-4.40\Altirra64.exe`), started through `Start-Process` with
`/singleinstance`, so the task ends at once and a running Altirra is reused (checked: one process after both runs).

**Why a tool**: `bin/game.obx` is a memory image in segments (main.asm says it is not runnable). `util/mkatr.py`
copies the original disk and writes the build back into it: boot sectors 1-3 from $0500-$067F, and the data bytes of
each segment of the program file (chain from sector 4) from the build's memory at the same addresses; headers, links,
byte counts and the other sectors (saved planet sets) are kept. Checks: the byte-exact build gives a disk identical to
the original; a build with one byte changed ($A9A7) gives a disk differing in exactly 1 byte. Limitation: the segment
layout is fixed – code growing past a segment end needs a new file layout.

Altirra's window title showed "ATOS" – Altirra's own OS replacement is in use, as no Atari OS ROM is configured in
Altirra – the user confirmed it is **AltirraOS 3.44 for XL/XE/XEGS** and that the program starts on it. AltirraOS keeps
only the documented OS entry points, so it cannot tell what `$F556` is (section 20); Konstruktor does not call it.

## 17. The help screen credits (2026-10-29)

The user showed a screenshot of the panel under the help pages ("Robbo Konstruktor / autor: Janusz Pelc" with a
planet and a Robbo icon) and could not find the text in the sources. **Search**: every word in ATASCII and screen
code, normal and inverse, in `game.bin` and the ATR (scratch script) – "autor", "Janusz", "Pelc" in screen code at
$0871-$0882, i.e. in `EDIT08.ASM`, in the region still listed as "data to classify" (`$0803-$09A5`), so the source only
had `dta $xx` bytes. ("Janusz"/"Pelc" also occur in ATASCII on the disk, in sector 360 – the text-only VTOC of section 1: a drawing
"Robbo Konstruktor … by Janusz Pelc", next to the "directory" label in 361.)

**What the region is**: `$0803` = the help screen's display list (`$10 $70`, mode 2 with LMS $092E = frame line, LMS
$B600 + 16 lines = the help page, LMS $0956 = frame, `$20`, mode F lines from $BD50 / $BD00 = the dotted lines, LMS
$083E + 4 lines = panel, LMS $0906 = key hints, `$41 $03 $08` = JVB). The panel lines are 40 characters:
$083E title with icons, $0866 author, $088E empty, $08B6 "©1990 Laboratorium Komputerowe", $08DE "Avalon", $0906 "←→:
zmiana strony, strzał: menu". They are now `TEXTS` (screen-pl) in `split.py`, with comments for the display list and
the frame lines $092E-$09A5.

**Font check** (characters drawn from `game.bin`, font $4C00): `$0F` is a **©** – this answers the open question about
"/1990 Avalon" on the title page; `$5E $5F` are arrows ← →; `$45-$48` / `$49-$4C` are the 2 × 2-character planet and
Robbo icons of the screenshot. In font $3C00 these codes are empty or element shapes, so the help screen uses $4C00.

**Findings for ABOUT.md**: the author is **Janusz Pelc** (the program's own credits), and "L.K." in "L.K. Avalon"
stands for **Laboratorium Komputerowe** (Computer Laboratory) Avalon.

Builds: MADS byte-exact.

Lesson (guide): when a known on-screen text is not in the sources, search the memory image for it in every character
coding (ATASCII, screen code, inverse) – it is often inside a region still emitted as `dta` bytes.

## 18. Scanning for hidden texts (2026-10-29)

The user asked how to make sure no text like the help credits (section 17) is missed again. Texts had been found only
where they were already expected. **New tool `util/findtext.py`** (repository level, for every game): reads the
`dta $xx … ; ADDR` lines of a game's sources, decodes each run of data bytes as ATASCII and as screen code (inverse
too; Polish letters as CONTROL codes or Robbo's glyphs) and reports sentence-like pieces made mostly of word-like
letter groups. It is a candidate list for a person; ranges checked and found not to be texts go into
`findtext-ignore.txt` with the reason.

First runs: the first heuristic (letters vs. length of the whole run) gave 51 / 59 candidates, mostly tables; judging
sentence-like pieces with word-shaped groups (lower case / Capitalised / capitals, a vowel) left 10-20, and found
everything known plus what was missed.

**Results here**:

| Address | Found | Done |
|---|---|---|
| $9043-$9053 | slot signatures " RKdata " (inverse) / " unused " | strings (`EDIT90.ASM`) |
| $A957-$A9A6 | "tekst początkowy:" / "tekst gratulacyjny:", headers of the title-page editor, copied at $B34E | strings (`EDITOR2.ASM`) |
| $9F7B-$9F82 | "kolory" – **not a text**: the header buffer of the current planet (copied to / from `$51F0 + 2n`, colours to COLOR0-4 at $9DE3, PCOLR3 from $9F82); its initial bytes happen to spell "kolory" | variable `HDR_BUF` |
| $29D3, $2AA8, $31D5 | Robbo's object-code tables written as letters (`NSPS`, `WBPO`, `NEXT`) | `findtext-ignore.txt` |
| $3440, $93D9, $B550 | pointer table, undisassembled code in `EDIT90`, palette / glyph tables | `findtext-ignore.txt` |

Result: `py -3 util/findtext.py robbo-konstruktor/src` → 0 candidates. MADS build byte-exact. The rule is in
`CLAUDE.md` and in the guide (step 7 gate, definition of done). The README "first look" line naming menu words
"kolory", "test"… at $94E0-$9F7A predates this and only lists words of the menu.

Tool lesson (again): a Python heredoc turned the regex `\b` into a backspace byte – edit Python code with the editor,
not with shell-quoted strings.

## 19. Modules (step 6) (2026-10-29)

**Method**: listed every named routine and data label in address order (scratch script over `src/`), then cut
`BLOCKS` in `util/split.py` where the purpose changes – always between routines, so the instruction-boundary check
passes. The gaps between modules ($23FD-$243C board row tables, $35A4-$35BF, $395D-$3BFF, $9431-$94DF, $A809-$A80F,
$B600-$BC3F) were checked: all zero in the image, filled at run time.

**Engine** (follows Robbo's own order): `ENG_PLAY` $1E00-$22CF (jump table … `ENTCV`), `ENG_BOARD` $22D0-$23FC
(`RT_` … `TST_W`), `ENG_SCRN` $243D-$2581 (`CHNMON` … `CM3`), `ENG_ROBBO` $2582-$28EB (`TFAC` … `TBEZ`), `ENG_OBJ`
$28EC-$2F52 (`TELE_CODE`/`TELE_IN` … `WYOT`), `ENG_VBI` $2F53-$3141 (`BDEC`, `CVBL` … `GET_KEY`), `ENG_TAB`
$3142-$3333 (input variables, shapes, `NEXT`, object table, `WHAT`), `ENG_SND` $3334-$35A3, `TITLEPG` $35C0-$395C.
Compromises: `ENG_PLAY` keeps the display list and info texts with the main loop (the jump table comes first);
`BDEC` goes with the VBI that uses it; `TELE_CODE` with `TELE_IN`.

**Fonts** named by use: `GAME.FNT` ($3C00, play screen, Robbo F.FNT), `BOARD_T.FNT` / `BOARD_B.FNT` (the former
`D4000.DTA` split into the two CHBASE halves $40 / $44 of the editor board, section 12), `SHAPES.FNT` ($4800, source of
`ANIM`, Robbo S.FNT), `INFO.FNT` ($4C00, info line, help panel and title page, icons and ©, Robbo I.FNT).

**Editor**: `HELPVIEW` / `HELPTEXT`, `DISKIO` ($9000), `ED_MENU` $94E0-$9CDC (services jump table, menu, functions,
disk sub-menu) and `ED_SERV` $9CDD-$9F7A (from `ELEM_MSG_`: the service bodies), `ED_TEXTS`, `ED_MAIN` $A810-$AF3D
(module jump table, input variables, display lists, start, main loop, `EDIT` … `PUT_CELL`), `ED_SCRN` $AF3E-$B188,
`TITLE_ED` $B189-$B3BD (`TITLE_ED_`, `TX_*`), `ED_UTIL` $B3BE-$B4F8, `PALETTE` $B4F9-$B5FF (character table $B4F9 –
its use is still to read –, palette codes, glyphs).

Old → new files (removed with `git rm` – files in `src/` not referenced by `main.asm`):

| Old | New |
|---|---|
| EDIT08.ASM | HELPVIEW.ASM |
| HELP.ASM | HELPTEXT.ASM |
| ENGINE1.ASM | ENG_PLAY.ASM + ENG_BOARD.ASM |
| ENGINE2.ASM | ENG_SCRN ENG_ROBBO ENG_OBJ ENG_VBI ENG_TAB ENG_SND (.ASM) |
| ENGINE3.ASM | TITLEPG.ASM |
| FONT3C.FNT | GAME.FNT |
| D4000.DTA | BOARD_T.FNT + BOARD_B.FNT |
| FONT48.FNT | SHAPES.FNT |
| FONT4C.FNT | INFO.FNT |
| EDIT90.ASM | DISKIO.ASM |
| EDITOR.ASM | ED_MENU.ASM + ED_SERV.ASM |
| TEXTS.ASM | ED_TEXTS.ASM |
| EDITOR2.ASM | ED_MAIN ED_SCRN TITLE_ED ED_UTIL PALETTE (.ASM) |

Checks: MADS and `asm.py` builds byte-exact (the MADS output grew to 27,671 bytes – more segment headers, same memory
image); `util/findtext.py` still 0 candidates; README block table generated from `BLOCKS`.

## 20. `JMP $F556` – ROM or RAM? (2026-10-29)

The user brought the background: on XL/XE machines `$D800-$FFFF` can be RAM when bit 0 of `PORTB` ($D301) is 0, so a
jump to `$F556` is a ROM call only while the OS is switched in. **Evidence**: no instruction in `src/` writes `PORTB`
(the only `PORTB` is the OS label in `JOINT.ASM`), and Robbo's sources do not either – the OS stays in, so
`J_F556` ($A828, an entry of the module jump table) jumps into the **OS ROM**. Nothing in Konstruktor calls `$A828`.

Which routine: Robbo's tape loader (`R1.ASM` `LOAD`, after the `REWT` screen) does `JSR loader+6 / BCC ok / JSR $F556
/ JMP lerr` – it is called after a load error, before the retry; a "beep and wait for a key" routine like the cassette
prompt would fit *(interpretation)*. In the 1200XL ROM in the user's Altirra folder ("Atari OS v10 82.10.26")
`$F556` is in the middle of a routine (`8D A0 02 85 6F A0 00 60`), so the address is not a stable entry across OS
versions – the programs expect a particular ROM (400/800 OS or 800XL rev. 2), which is needed to name the routine.

**Answer** (with the user, same day): the user disassembled `$F556` in Altirra's debugger with two OS images –
AltirraOS 3.44 (`LDA DINDEX … PLA` – a `PLA` that pops the caller's return address, no entry) and the 400/800 **OS-B**
(`ATARIOSB.ROM`): there `$F555` is `8D E6 02 STA MEMTOP+1`, so `$F556` is the middle of an instruction. The
**XL/XE ROM** next to it (`ATARIXL.ROM`, Atari800Win, md5 06daac977823773a3eea3422fd26a703 – read locally, not copied)
has a routine start there – `$F553 JMP $F41B` ends the previous one – : `LDY #$20 / JSR $F983 / DEY / BPL / RTS`, and
`$F983` toggles the console speaker (`STX $D01F`, 64 times, waiting a scan line) = the key click. So **`$F556` is the
OS buzzer: 33 key clicks** – the bell of the screen editor *(the CTRL+2 link is from memory)*. Robbo buzzes after a
tape load error and retries; Konstruktor's module service `$A828` is now **`BELL`** (`jmp OS_BELL`), unused by
Konstruktor itself. The programs target the **XL/XE OS**.

Repository fix: the step-6 commit (96fdbe8) had picked up `util/__pycache__/xex.cpython-311.pyc` – a doc script
imported `split.py` after the clean-up and the commit staged the whole folder. Removed with `git rm`; the root
`.gitignore` now has `__pycache__/`. Lesson: clean after the last script run, and look at `git status` before
staging a folder.

## 21. The copy protection – "the planet clears itself" (2026-10-29)

The user asked to read and file the forum thread [Dyskowy Robbo Konstruktor na emulatorze](https://atarionline.pl/forum/comments.php?DiscussionID=3815)
(atarionline.pl, 39 posts, 2016-2019; read through a fetch agent). **Reported there**: the disk version clears
the board when the wall (*murek*) is "hit"; the original disk has an unreadable sector 989 (RNF) that the protection
checks (miker, voy); switching off Altirra's "D: patch (Disk SIO)" and using PAL fixed it (QTZ); Krótki explained
that the program uses POKEY `SERIN`, which SIO patches do not update, XORed with `DOSINI`, stored and checked when
the wall is hit; QTZ located the store at `$9F8B`. A second error, "błąd - za dużo robocików!" after using the disk
menu on a copy (flag `$0C75`, bytes `$0513` = `30 12 A2` in his unlocked build), was never solved.

**Found in our image** (all three facts confirmed in the code):

- **Store** – the only reference to `$9F8B` in the whole image is `sta $9F8B` at $9F6B, in an unnamed tail of
  `PLANETS_FILL` ($9F4D-$9F73), now **`PROT_KEY`**: `lda $A804 / bmi skip` (runs while the "R" of "Robbo" is
  positive), then builds two pointers from `CUR_ELEM` with `sec / rol / asl / asl / sec / rol / asl` and an `eor`
  that zeroes the high byte: with `CUR_ELEM` = 6 at load they are **$000D** (`DOSINI+1`) and **$D20D** (`SERIN`);
  `lda ($B0),y / eor ($B2),y / sta $9F8B`; finally `lda #$60 / sta $9F4D` – an `RTS` over its own first byte, so it
  runs once. `$9F8B` is now **`PROT_SUM`**.
- **Check** – no instruction reads `$9F8B` by that address. `ELEM_MSG_` ($9CDD, shows the name of palette entry X):
  if the message number X + $1E is `$2A` – entry 12, **"murek"** – it does `lda HDR_BUF+4,x`; with X = 12 that is
  $9F7B + 4 + 12 = **$9F8B**; not 0 → `jsr PLANET_CLR`. The name is shown when the editor cursor stands on that
  palette entry (`ED_MAIN` $AAAC: entry = `CUR_Y` × 3 + `CUR_X` − $11, only when `CUR_X` ≥ $10) – that is the "hit
  the wall" of the thread; it erases the current planet.
- **Key** – the boot record's init address **$19DD** (open question since step 2: no code there) is not an init
  routine: the OS copies it into `DOSINI`, and `DOSINI+1` = **$19** is the value `SERIN` must hold. On the original
  disk the last serial byte at that moment is $19 *(inferred: the XOR must be 0)*; an SIO patch leaves `SERIN`
  unchanged, so the planet is erased.

Search method: the address bytes `8B 9F` occur once (the store); immediates `#$9F` / `#$8B` lead elsewhere (a
message number, a screen offset); the check was found from the effect – the callers of `PLANET_CLR`.

`$0C75` here is the help viewer's variable (set on entry, `bmi` / `bpl` choose which text variant to skip) and
`$0513` is boot-loader code no one reads – the "za dużo robocików" error of the thread is not explained by this image.

Names: `PROT_KEY`, `PROT_SUM` and the comment at $9CF2 in `util/split.py`; MADS byte-exact. README "Known issue".
For readers outside the project (asked by the user): [PROTECTION.md](PROTECTION.md) – symptom, root cause, the
three parts with listings, why emulators trigger it, workaround and a one-byte patch idea (not tested), credits.

Lesson (guide): when a forum or a user reports odd behaviour, search for the addresses they name, and when a value
is written but never read by its address, look for indexed reads whose base + index reach it.

## 22. A build without the protection (2026-10-29)

Asked by the user: make the program ignore the protection all the time. Options weighed (PROTECTION.md, "What to
do"): `RTS` at `PROT_KEY` $9F4D or an inverse "R" at $A804 keep `PROT_SUM` at its initial 0, but only as long as
nothing else writes it; **removing the trap** – `jsr PLANET_CLR` at $9CF7 → `NOP NOP NOP` – works whatever the
value is, so that was chosen. The editor alone is affected; "zapisz Robbo" saves only the engine and fonts.

**How, without touching the sources**: `src/` is generated and `main.asm` must stay byte-exact, so the patch is a
separate file, **`nocopyprot.asm`**: `icl "main.asm"`, then `opt h+ / org $9CF7 / nop ×3` – a later segment, so
both the Atari loader and `util/mkatr.py` (which builds memory from the segments in order) let it override the
3 bytes. Checks: `verify.py bin/nocopyprot.obx` → "DIFFERENT: 3 bytes, first at $9CF7"; the disk copy written by
`mkatr.py` differs from the original image in exactly 3 bytes (`20 DB 97` → `EA EA EA`); `main.asm` still
byte-exact. VS Code task "Robbo Konstruktor: run build (protection off)" runs it and starts Altirra (started fine).

To test in Altirra with the disk SIO patch **on**: draw on a planet, move the cursor onto the wall in the palette –
the planet must stay (the original erases it).

## 23. The second protection – "błąd - za dużo robocików!" (2026-10-29)

The user brought a reproduction (Polish, continuing the [forum thread](https://atarionline.pl/forum/comments.php?DiscussionID=3815)): start from a non-original disk, open "operacje dyskowe", choose any active
option and answer the question either way – afterwards adding any element to a planet makes the test or the save
fail with "błąd - za dużo robocików!"; with the modified .pro and the SIO patch on it does not happen. Clues from
memory dumps: `$0513` must hold `30 12 A2`; the values are read only at the first "zapisać zestaw 01? tak nie";
changing `$0513` later does not unlock; differences after unlocking at `$B47E $B48C $B492 $B4C9 $B4CB`; `$0C75` = 1
when bad (setting it to 0 does not unlock).

**Found**: `$B47E`, `$B48C`, `$B492` are inside `ASK_YESNO_` ($B3F5), the routine of every yes/no question
(`$B4C9`, `$B4CB` are the self-modified operands of `ATA2SCR_` – ordinary, not part of it). Its tail **`PROT_BOOT`**
($B47D-$B49E): `lda #$00 / bmi` – one-shot flag in the operand $B47E (`sec / ror $B47E` at the end); `lsr $B48C`,
`lsr $B492` halve the disguised operands `eor $0A00,x` / `cmp $0440` to **`$0500` / `$0240`**; `A = $FF XOR
$0501…$05FF` is compared with **`DFLAGS`** (boot record byte 0, $AE); not equal → `lda START / sta $ACB3`.

**Lock**: `$ACB3` is the `RTS` of `COUNT_ELEM_`, followed by `03 B0`; `$4C` makes it **`JMP $B003`** (`WAIT_VBL`,
returns A = `RTCLOK+2`). `PLANET_TEST` ($AC15): empty → "pusta" without counting; else the Robbo count must be 1 →
with the frame counter it is not → error 6 "za dużo robocików!". This is the "third somewhere" of the report – a code
patch, so restoring `$0513` or the flag no longer helps; `$60` at `$ACB3` does.

**This image**: the checksum is **$C1** (cracked loader, `$0513` = `4C A6 05`); with `30 12 A2` it is exactly **$AE**
– so this disk image locks itself at the first yes/no question, SIO patch or not. Confirmed with `util/emu.py`
(`CPU.call($B47D, stop=$B49F)`, `DFLAGS` set from the boot record): original + cracked loader → `$ACB3` = $4C;
original + `30 12 A2` → $60; patched build → $60 in both cases.

`$0C75` here is the help viewer's variable (section 21); the flag the report saw there belongs to its own build.

**Patch**: `nocopyprot.asm` got a second segment, `org $B47E / dta $80` – the check believes it already ran. The
patched disk copy differs in 4 bytes (`$9CF7-$9CF9`, `$B47E`). Names: `PROT_BOOT`, comments at $B47D and $ACB3 in
`util/split.py`; `main.asm` byte-exact. Article: PROTECTION.md "The second protection".

Correction: section 21 said `$0513` was "boot-loader code no one reads" – it is read, as part of this checksum.

Lesson (guide): a protection can lock by **patching code** (one opcode turns an `RTS` with "data" behind it into a
`JMP`) and hide its addresses as halved operands fixed up on the first run; compare memory before and after the
trigger and look for stores into code.

## 24. The help format, corrected – and a new help page 15 (2026-10-29)

The user wanted, in their version, to replace the last help page (Avalon's notice: "Program Robbo Konstruktor został
przetestowany w firmie Avalon. Jeżeli Twoja wersja wykazuje błędy uniemożliwiające jej używanie, jest nielegalną
kopią! …") with their own text (removed protections, "Fixed version: 2026 by CAMOsoft, Kamil Nowinski").

**The format was wrong in our notes.** Reading `HLP_LINE` ($0A7A) to lay out the new text: a byte with bit 7 is not
"followed by a space" (sections 7-8) but the **last character of its screen line**; `$A0` alone ends a line without
drawing (an empty line); `$B1-$B9` = 1-9 spaces; `$14` toggles inverse; `(` `/` `)` select tape / disk variants
(`$0C75`); `$80` ends the last page (the line loop stops advancing, `HLP_PAGE` hides the "next" arrow); `$00 nn`
starts page nn; page 0 starts at $0C79 (the preamble pointer at $0C77). Lines run from column 2 to 38 (37 characters),
16 per page. The decoded comments had joined the lines.

**Tool `util/helppage.py`**: runs the program's own `HLP_PAGE` in `util/emu.py` on a memory image (`game.bin` or a
build) with `$0C77` = the page address and prints the 16 lines of the buffer $B880; characters are decoded through a
reverse map built by running the program's `ATA2SCR` on every code (Polish letters first – they share glyphs with
`[ \ ] _`). Page 15 of `game.bin` matches the user's screenshot line for line.

**`rdis.py` 'help' format** now writes one `dta` per screen line (a line ends at a bit-7 byte), comment = the screen
line; `HELPTEXT.ASM` regenerated – byte-exact, `findtext.py` 0. Docstrings, the block description and README "Help
text" corrected; sections 7-8 above keep the old reading as history.

**New page 15** (in `nocopyprot.asm`, segment `org $1CD7`, generated by a scratch script from the user's lines: Polish
letters → CONTROL codes, last character of each line | $80, empty lines `$A0`, the last line followed by `$80 $00`
as in the original): exactly **250 of 250 bytes** – the page ends at $1DD0 and the help block cannot grow (fixed
segment layout of the disk file), so there was no byte to spare. `helppage.py bin/nocopyprot.obx 15` shows the text as
written; pages 0-14 render identically to the original. Disk copy: 176 bytes differ (4 protection bytes + the page).

## 25. Help page 15 – fixing a manual edit (2026-10-29)

The user shortened the new page by hand (the paragraph "Już dawno nie można zamówić niczego wysyłkowo z Avalonu."
removed) and merged lines such as `c'przetestowany w firmie Avalon',c'.'*` into `c'przetestowany w firmie Avalon.'*`.
In MADS a `*` after a string sets bit 7 on **every** character of it – for the help viewer each of them ended a line,
so the page showed one letter per line (`util/helppage.py` showed it; the build had been committed in 014ec50 and
4fa06a4). Fixed: bit 7 only on the last character of each of those 5 lines; the page is now 195 bytes, so the rest up
to $1DD0 is filled with `$00` (`:$1DD1-* dta $00`), the same zeros that follow the original end. Checked: page 15
renders as written, pages 0-14 identical to the original, `main.asm` byte-exact, `bin/build.atr` rewritten.

Lesson: after editing a help page, run `py -3 util/helppage.py bin/nocopyprot.obx 15` – a wrong `*` still assembles.

## 26. "błąd numer 139!" when saving a planet set (2026-10-29)

The user could not save a planet set ("zapisz zestaw → 01") on `bin/build.atr` in Altirra (started by the VS Code
task "run build (protection off)"; D1 = `build.atr`, write mode R/W, emulation "Fastest possible"): "błąd numer 139!"
– SIO status $8B, device NAK.

**The program is not at fault.** `DISKIO` uses only `R` ($52, read), `P` ($50, write without verify) and `$22`
(format, enhanced density – the program expects a 1050 and a 1040-sector disk; slots at sectors 256, 388, 520,
652, 784). Emulating the save with the program's own `IO_CMD` ('w', slot 1, one planet marked used, `CONSOL` = $07,
SIO calls logged by a hook in `util/emu.py`): `R 256`, then `P 256-264`, `R 256`, `P 256` – valid sectors on the
1040-sector image. (Side finding: `IO_CHKSLOT` $935D reads `CONSOL` after the header – SELECT held → refuse, OPTION
held → accept the disk whatever its header says.)

**The image is.** The ATR header byte 15 is `$01` in the original dump – the write-protect flag of the ATR format
(Atari800 calls it `writeprotect`) – and `mkatr.py` copied the header, so the emulated drive refused the writes
whatever the R/W setting *(the NAK rather than 144 is Altirra's choice – inferred, matches the report)*.

**Fix in `util/mkatr.py`**: the copy gets byte 15 = 0 (reported: "write protection removed"); "identical to the
original" now compares the data, not the header. And because every rebuild started again from the original, saved
sets would have been lost: an existing copy of the same size is now **updated in place** – only the boot sectors and
the program file are rewritten (tested: a marker in sector 256 survives a rebuild). Delete `bin/build.atr` to start
afresh from the original. The original image stays untouched (tracked, read-only by its header).

**Still 139 after that – the real cause: the OS.** The user had last selected the 400/800 **OS-B** in Altirra (for
the `$F556` test, section 20). The program calls `DSKINV` ($E453), which picks the transfer direction from the
command letter. XL/XE ROM (`ATARIXL.ROM`, `JMP $C6B3`): `CMP #$50 / BEQ` and `CMP #$57` → `DSTATS` = $80 (write).
OS-B (`ATARIOSB.ROM`, `JMP $EDF0`): only `CMP #$57` → for `P` ($50) `DSTATS` stays **$40 (read)** – the command frame
goes out, then the computer waits for data while the drive waits for the sector: error 139. Reading (`R`) works on
both, so only saving fails. Fix: XL/XE firmware in Altirra (the XL ROM or AltirraOS for XL/XE), cold reset *(to be
confirmed by the user)*. Another proof that the program is written for the XL/XE OS (section 20). The write-protect
flag of the ATR header may not have mattered; clearing it and keeping saved sets is still right for a working copy.

Lesson (guide): when an OS call fails only on one machine type, disassemble the call in each OS ROM – OS-B and XL
differ in details such as `DSKINV` knowing only `W` as a write.

## 27. Wrong letters in the title-page text editor (2026-10-29)

The user: editing "tekst początkowy" / "tekst gratulacyjny", A gives "T", Z nothing, G "8", B "L".

**Cause**: `TITLE_ED_` ($B210-$B21F) takes the key from `CH` and converts it with **`lda $FB51,x`** – the keyboard
table of the **XL ROM** at a fixed address. Checked in the ROMs: XL (`ATARIXL.ROM`) gives a z g b for those key codes
($3F $17 $3D $15); OS-B gives other bytes ($B0, "e", $C4, $F1) – also wrong, but not the reported letters, so the
user was most likely running **AltirraOS** (suggested for saving, section 26), whose table is elsewhere *(inferred;
AltirraOS is not available here to check)*. Same flaw as `$F556` (section 20): a fixed address inside one OS ROM.

**Fix** (in `nocopyprot.asm`): use **`KEYDEF`** ($79/$7A), the XL OS pointer to its keyboard table – the XL ROM sets
it to $FB51 itself (`$EF7F`: `lda #$51 / sta $79 / lda #$FB / sta $7A`), so the original machine behaves exactly as
before. 6 bytes: `ldx CH` → `ldy CH`, `cpx #$FF` → `cpy #$FF`, `lda $FB51,x` → `lda ($79),y` + `nop` (Y is free
there: the no-key path `LB1C3` sets its own registers, after the lookup `ldx #$00` restarts the key-table search).
The program does not use $79/$7A. Emulated: XL ROM table → "a" for key A; a table placed elsewhere with `KEYDEF`
pointing to it → the byte from that table. Patched build: only the intended bytes differ; `main.asm` byte-exact;
`bin/build.atr` updated in place.

## 28. A disk of its own for the fixed version (2026-10-29)

Asked by the user: the task "RUN BUILD (PROTECTION OFF)" (the user renamed the task labels to capitals) writes
**`bin/Robbo Konstruktor (1990)(L.K. Avalon)(PL)[cr CAMOsoft 2026].atr`** – the name follows the TOSEC style of the original
(`[cr …]` = cracked by) – instead of `bin/build.atr`, which "RUN BUILD" keeps for the unchanged build. The new disk
was seeded from `bin/build.atr`, where the user's planet sets saved with the fixed version were, so `mkatr.py`
updated it in place and they carried over; header byte 15 = 0 (writable). Unlike `build.atr` the new disk is not
ignored by git – whether to commit it is the user's decision.

Also prepared for the user to edit: the credits lines 4-5 of the help screen panel ($08B6 "©1990 Laboratorium
Komputerowe", $08DE "Avalon") copied into `nocopyprot.asm` as a segment, unchanged for now (0 bytes differ);
40 screen codes per line, `ert *<>$08DE` / `ert *<>$0906` stop the build when a line is not 40 characters (tested:
one character short → "ERROR: User error").

The user then edited the two lines ("©1990 Laboratorium Komputerowe Avalon", "Fixed version: Oct 2026 by CAMOsoft",
committed in 631ef4d) and sent a screenshot of the fixed version in Altirra – help page 0 with the new panel – saved
as `img/title-screen.png` (1079 × 698) and shown in README.

A second screenshot, the **editor** (fixed version in Altirra, 1075 × 702): saved as `img/editor.png`, shown in README
"Palette". It is the reference asked for in step 8 (renders vs. the real screen) and helps step 5.3: the palette on
the right shows all entries as the running program draws them, including the variants of the placeholder entries
22-29 (bats, guns, laser, blaster, teleport) – to compare with `img/palette.png`. Note: taken in Altirra, whose
default palette may differ from XFormer's.

## 29. CI on GitHub Actions (2026-10-29)

Asked by the user: a pipeline that builds both versions. **`.github/workflows/robbo-konstruktor.yml`** (`ubuntu-latest`;
on push / pull request touching `robbo-konstruktor/**`, `util/findtext.py` or the workflow, and by hand):

1. MADS 2.1.5 from source – `mads.pas` from the tag (raw.githubusercontent.com/tebe6502/Mad-Assembler/2.1.5),
   `apt-get install fp-compiler`, `fpc -Mdelphi -vh -O3 mads.pas` (the command in MADS's README); the binary is
   cached (`actions/cache`, key `mads-2.1.5-<os>`).
2. Original: `mads main.asm`, `verify.py` (byte for byte), `../util/findtext.py src` must end with "0 candidate",
   `mkatr.py` → `out/original/…[rebuilt].atr`, its log must say "data identical to the original".
3. Fixed: `mads nocopyprot.asm`, `helppage.py … 15` into the log, `mkatr.py` → `out/fixed/…[cr CAMOsoft 2026].atr`.
4. Both uploaded (`actions/upload-artifact`) as `robbo-konstruktor-original` / `robbo-konstruktor-fixed`. The files
   go into folders of their own and the folders are uploaded: upload-artifact treats paths as globs, and the
   `[cr …]` in the name would be a character class. `out/` is ignored by git.

Checked locally: every `run` step, in order, on a clean `git archive HEAD` export (local MADS, `py -3` for
`python3`) – all pass, both disks written. **Not checked locally**: the Free Pascal build of MADS on Ubuntu and the
actions themselves – the first run on GitHub will show (needs a push; the user's decision). Linux is case-sensitive:
`main.asm` names the `src/` files exactly as they are (upper case).

## 30. Names and comments (step 7) (2026-10-29)

**Starting point**: every routine already had a name and a comment (steps 5-6), but the operands still held about
**330 bare addresses** (~1,300 uses): OS / hardware registers missing from the label table, zero page, buffers
outside the program, tables inside the blocks and **self-modified operands**. A scratch inventory script listed them
by kind (OS, zero page, outside the image, data in a block, inside an instruction, binary block) and per routine;
they were named module by module, regenerating and checking byte-exactness after every batch.

**What was named** (all in `util/split.py`; evidence = the code that uses them):

- OS / hardware (`util/xex.py` `L`): `BRKKEY ATRACT CDTMV4 PCOLR0 PCOLR3 KRPDEL KEYREP SIZEP1 GRAFP1 TRIG1 COLPM1-3
  VSCROL`; `OS_KEYTAB` $FB51 (the XL ROM table of section 27).
- Zero page: the sound uses Robbo's `_PNTR _ADDR _SCRA _HLP` ($F0-$FF, `R1.ASM` 1494); the editor's $B0-$B7 are
  **shared temporaries** – every routine gives them its own meaning, so they are `PTR1 PTR2 TMP1-TMP4` with the main
  uses in the comment (like Robbo's `ADDR` / `HLP`); tape / disk `IO_PTR IO_END IO_POS`; title page `TP_*` ($E0-$ED:
  frame timer, order position, lives, logo pointers); boot loader `BOOT_ADR BOOT_END BOOT_BCNT BOOT_BPOS`, sector
  buffer `SEC_BUF` $0400 (`SEC_LINKH/L` $03FE/$03FF read with X = 127 = DOS 2 link bytes 125-126).
- Engine, Robbo's names where the code matches: `DLSA` $1E13 (the board's display-list address the scroll moves,
  `R2.ASM` 1323), `TSTTAB` $23FD (row addresses, high bytes at `TSTTAB+32` as in Robbo), `LMVT`, `PROC` / `CALL`
  (`CALL+1` = the patched JSR), `NEXT LOOK WHAT TMVS NSPS RDZP WBPO`, `FACET` (Robbo's `CHNMON-1`), `FONT` $3C00.
  Konstruktor's own: `BOARD` $BE00 / `BOARD_HDR` $BFF0, display-list JMPs `DL_BREAK DL_DEMO`, `INFO_TOP/BOT`,
  `WBPX WBPY` (the bomb's edge checks Robbo did not need), `KEJO_KEYS/DIRS` and the patched `AND #` operands
  `KEY_FIRE KEY_DIR`, `PLAY_SP OLD_VBI PLAY_NUM PLAY_TRY`.
- Editor: screens `SCREEN` $B600 / `SCREEN_B` $B800, `PANEL_TXT` $BC00 (`PANEL_LH` = `PANEL_TXT-20`: one routine
  writes the left half of a row through it), `STATUS` $BCC8, `GR_BLANK` / `GR_LINE` (the dotted $55 line);
  input `IN_FIRE IN_DIR IN_KEYS IN_DIRS RPT_FIRST RPT_NEXT`; tables `CHR_FROM/CHR_TO` (read by `ATA2SCR_` and
  `TX_ALLOWED`), `PAL_CODES PAL_SETS GLYPHS FRAME_MASK STRIP_CHR`; menu `MENU_JUMPS MENU_ROWS COL_REG COL_EDIT
  ORD_* DSK_* SG_CMD SG_SLOT`; tape / disk `IO_LETTERS IO_JUMPS SLOT_SEC SLOT_BIT IO_RANGES LIST_SET LIST_GAME IO_SLOT
  IO_USED IO_LOADED`; editor texts split into their parts (`MENU_TXT NUM_TXT TITLE_TXT LEGEND_TXT DISK_TXT
  SAVE_DISK SAVE_TAPE`) and the places the code patches inside messages (`ASK_WORD ASK_NUM ERR_DIGITS MSG_LIST`).
- `BOARD_T_7C / BOARD_B_7C` ($43E0 / $47E0) were called "element preview" in section 10: `REDRAW_` copies the
  **planet's wall** (by header byte 0, like `ENTCV`) into characters $7C-$7D and the selected element inside the
  cursor frame (`FRAME_MASK`) into $7E-$7F.

**Hidden code found** (entry points added, then named):

- **`GB_BOOT` $93A9-$942F – the boot loader of the saved stand-alone game.** `IO_SAVEGAME` ($92C3-$92D3) writes
  exactly this range to sectors 1-3 of the freshly formatted disk: `GB_HDR` = boot record (flags 0, 3 sectors, load
  $93A9, **init `TP_START` $35C0**), code at load + 6 = $93AF. It reads from sector `GB_SECTOR` (patched by
  `IO_WRITE` at $91E2 with the header sector of slot 0), skips the 8-byte slot header and loads segments in the
  planet-set format until start = 0 – then the OS runs the title page. Section 18 had listed $93D9 as "undisassembled
  code"; its `findtext-ignore.txt` line is gone.
- `HLP_STEP_R` $0BD0 / `HLP_STEP_L` $0BF7 – the two line steps of the help scroll, reached only through the JSR at
  $0BB1 that `HLP_PREV` / `HLP_NEXT` patch (`NOFOLLOW` added).
- `HLP_INCSCR` $0C4E and `INPUT_FORCE` $3120: never called (section 14 had $3120 as "not code").

**Palette entries 22-29 (step 5.3)**: `REDRAW_` ($ACB6) copies 8 codes from `PAL_SETS + 8 × (PAL_SET & 3)` into
`PAL_CODES+22`; entry 21 increments `PAL_SET` ($AAE7). The four sets contain direction characters (`>` `"` `<` `^`,
arrows $1C-$1F) and the teleports 1-3 / 4-6 – entry 21 ("zmiana dział, nietoperzy i teleportacji") turns guns and
bats and switches the teleport numbers. Which code is which element is still to be read from the glyphs.

**Lister changes** (`util/rdis.py`), all byte-neutral:

- a variable inside an instruction is written in place above it: `HLP_FIRST equ *+1`;
- an operand inside a labelled instruction is written `LABEL+k` (`sta CALL+1`, `sta PC_STA1+1`) – the
  self-modifying instructions got labels (`ROW_JMP ROW_CELL PB_BYTE PNL_HINT PNL_RIGHT PUT_ELEM ED_ERASE TX_GO
  PROT_EOR PROT_CMP COUNT_RTS …`), so no `Lxxxx+k` is left;
- a variable inside a text line: `NAME equ *+k` above that line; a variable that starts a text: its label;
- forced-absolute operands show the name (`dta $99,a(IO_PTR)`); offsets above 256 in hex (`FONT+$2F0`);
- `$00,x` stays `$00,x` (a base, not `DLI_ROW`, the variable at 0);
- a data variable must not cover code (assertion).

**Left as bare numbers on purpose**: the copy protection's disguised operands `$0A00` / `$0440` (halved at run
time, PROTECTION.md) and `$00,x` in `ED_SETUP`.

Gate: MADS build byte-exact; `nocopyprot.asm` builds (help page 15 unchanged); `findtext.py` 0 candidates; no
`sub_` / `entry_` / `Lxxxx+k` names. Local branch labels `Lxxxx` remain, as in the guide (jump targets inside a
routine).

Lessons (guide): name self-modified operands as `LABEL+k` after labelling the instruction – the code then reads like
the original sources (Robbo writes `STA CALL+1`); a JSR whose target is patched hides code: look at what the patches
store (`lda #$D0 / ldx #$0B`) and add those addresses as entry points; data written to disk can be code that runs
elsewhere (the saved game's boot) – check what an I/O routine writes, not only what it reads.

## Open questions

- Sectors outside the program chain (256, 260-264, 388, 392-396, 520, 524-532, 652, 784, 974, 989): saved boards?
  The singles 256, 388, 520, 652, 784 are 132 sectors apart.
- Data to classify: `$4000-$47FF` (board fonts: which glyph is which element); help-text preamble `$0C79`
  `80 01` (page marker of page 1?).
- `SERIN` with this ATR and the SIO patch off: does it end as $19 (first protection, section 21)?
- Palette entries 22-29: which of the codes in `PAL_SETS` is bat, gun, laser, blaster (teleports are 1-6)?
- Unread in step 7: `DSK_SAME` ($9ABA) – exact effect; `GLYPHS` beyond the 32 palette codes.
- Robbo's abbreviations to confirm (user): `WHAT` legend "zas" / "wyb" (shot / blown up?), `KIES` (kierunek
  strzału – shot direction?), `SKAC` (skacz – jump?), `WYZA` / `WYOT`, `ZABJ`, `CVBL`.
- Editor screen layout: is it a 16-column board window + palette (cursor X 0-19 skipping 16)?
- Engine data tables: compare with Robbo's (e.g. `$33CC` = Robbo `R1.ASM` 1624 ff.).
