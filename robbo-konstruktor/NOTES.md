# Robbo Konstruktor – reverse-engineering notes

Working log, following [DISASSEMBLY-GUIDE.md](../DISASSEMBLY-GUIDE.md). [README.md](README.md) is the reference.

## Plan

| # | Step | Deliverable | Gate | Done |
|---|---|---|---|---|
| 1 | Inventory | disk structure, file chain, segment table, tags decoded | README tables | [x] |
| 2 | Memory image | game.bin, boot chain | odd regions explained | [x] (other sectors open) |
| 3 | Entry points + disassembly | entry list, code ranges | gaps looked at | [x] 12.5 KB |
| 4 | Blocks + byte-exact build | src/, main.asm, Makefile | MADS: byte for byte | [x] |
| 5 | Understand code | call graph, main loop, interrupts, init tables; map shared code to Robbo labels | every routine described | [~] engine named from Robbo |
| 6 | Modules | BLOCKS regrouped, data named | byte-exact, README block table | [ ] |
| 7 | Names + comments | VARIABLES, NAMES, COMMENTS, POKES (Robbo names where code matches) | no sub_XXXX, byte-exact | [ ] |
| 8 | Graphics + verification | renders, screenshot in img/ | renders match screenshot | [ ] |
| 9 | Docs, clean, commit | README, NOTES, root README entry | clean tree, verified build | [ ] |
| – | Optional | board format and saved boards on the disk, compare editor engine with Robbo | | [ ] |

### Step 5 sub-plan – the editor (agreed 2026-10-29)

| # | Part | What | Done |
|---|---|---|---|
| 5.1 | Start-up and main loop | start routine, screen set-up (display lists, DLIs, fonts), per-frame loop: cursor, keys, messages | [x] |
| 5.2 | Menu handlers | the 10 handlers of table $9F8E, checked against the menu texts and named; what "test" checks (error messages) | [x] |
| 5.3 | Palette and elements | element → board cell; do the 27 names follow the object codes; variables $A317, $A7D6 | [~] codes and glyphs known; switch entry 21 (variants) open |
| 5.4 | Tape and disk | save / load of planet sets → planet format; the extra disk sectors (saved sets) decoded and rendered | [x] |
| 5.5 | Engine leftovers | the 26 engine routines still `sub_XXXX` (Konstruktor's changes to Robbo's engine) | [ ] |
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
code or no match); MADS build still byte-exact.

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

## Open questions


- Sectors outside the program chain (256, 260-264, 388, 392-396, 520, 524-532, 652, 784, 974, 989): saved boards?
  The singles 256, 388, 520, 652, 784 are 132 sectors apart.
- Boot record init address $19DD – the program has no code there at boot time; what is it for?
- `JMP $F556` in the jump table – an OS ROM routine or RAM under the OS?
- Data to classify: `$0803-$09A5` (display list + tables), `$3142-$3333`, `$35D0-$3682` (display list),
  `$4000-$47FF`; help-text preamble `$0C77`: `79 0C 80 01`; tables in `TEXTS.ASM` ($9FA2, $9FAC, $A7F8, $A7FE).
- Palette entry 21 (switch) and the placeholders 22-29: which codes do bats, gun, laser, blaster and teleport use?
- Editor screen layout: is it a 16-column board window + palette (cursor X 0-19 skipping 16)?
- The 26 remaining `sub_XXXX` in the engine and the editor code (no source): analyse and name.
- Engine data tables: compare with Robbo's (e.g. `$33CC` = Robbo `R1.ASM` 1624 ff.).
