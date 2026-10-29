# Disassembly guide – turning an Atari 8-bit game into MADS sources

Step-by-step method for reverse-engineering a game that exists only as a binary (XEX/ATR) into sources that
reassemble **byte for byte**, then understanding and documenting it. Written for AI agents and people starting
a new game in this repository. Worked example throughout: [jaskiniowiec/](jaskiniowiec/) (its
[NOTES.md](jaskiniowiec/NOTES.md) has the full story, its tools are in [jaskiniowiec/util/](jaskiniowiec/util/)).

Read [CLAUDE.md](CLAUDE.md) first – repository conventions, MADS set-up and working rules apply here too.

---

## 1. Principles

1. **Byte-exact or nothing.** Every change to sources or tools ends with: assemble with MADS, compare with the
   reference image, result must be identical. Names and comments never change bytes – so they can always be verified.
2. **Generate, don't hand-edit.** Sources are produced by a script from the memory image plus tables (blocks,
   variables, names, comments). Knowledge goes into the tables, then regenerate. Hand-editing starts only when
   the sources are final (and then the generator must not be run over them again).
3. **Evidence for every claim.** Write down *which instruction at which address* shows a fact
   (`$8CE1: lda $9395,x` → jump arc). Unproven ideas are marked "probably" and listed as open questions.
4. **Record as you go.** Every work session adds a dated section to the game's `NOTES.md`; the `README.md` is
   the up-to-date reference. Nobody should have to re-discover anything.
5. **Verify against reality.** A screenshot from an emulator, a run in the emulator, the real display list –
   prefer measured facts over assumptions (see lessons 6.4).

---

## 2. Set-up

- Folder per game: `<game>/` with `README.md`, `NOTES.md`, `main.asm`, `Makefile`, `src/`, `bin/`, `img/`,
  `util/` (game-specific tools).
- Tools: Python 3 (`py -3`), MADS in the `MADS` environment variable (root README "MADS location"),
  palette `util/palette/XFormer.act`. GNU make may be missing – run the Makefile commands directly.
- Start the tools by copying [jaskiniowiec/util/](jaskiniowiec/util/) into `<game>/util/` and adapting them:

| Tool | Purpose | What to adapt |
|---|---|---|
| `xex.py` | segment list, linear disassembler, opcode table, OS/hardware label table `L` | add labels; undocumented opcodes if the game uses them |
| `emu.py` | minimal 6502 emulator running the XEX load sequence (INITAD/RUNAD) | hardware stubs (VCOUNT, CONSOL, RANDOM, keyboard) |
| `resume.py` | continue from a snapshot (e.g. a frozen version's restore routine) | start address, stop condition |
| `rdis.py` | recursive-descent disassembler + `Lister` (labels, variables, comments, init tables) | usually nothing |
| `split.py` | `BLOCKS`, `VARIABLES`, `COMMENTS`, `NAMES`, `POKES`, `NOFOLLOW` → `src/`, `main.asm` | all tables |
| `asm.py` | tiny assembler for the generated subset – fallback check without MADS | nothing |
| `verify.py` | load a segment file into 64 KB, compare with the reference image | reference file name |
| `levels.py` | render maps/logo to PNG with the real palette | everything (game-specific) |

- Run tools with the game folder as the working directory (`py -3 util/split.py …`); data paths are relative.

---

## 3. Step by step

Each step has a **goal**, **how**, and a **gate** (what must be true before moving on).

### Step 1 – Inventory the binary

- Find the file, note name, size, origin. Decode the TOSEC-style tags: `[h]` hacked/frozen, `[t]` trainer,
  `[a]` alternate, `[cr]` cracked – they predict loaders, trainers and damage.
- `py -3 util/xex.py <file>` – list segments: addresses, INITAD ($2E2) / RUNAD ($2E0) segments.
- Identify each segment's role: intro, loader, depacker, packed data, copier to RAM under the OS, music…
- **Gate:** a table "segment → address → role" in the README.

### Step 2 – Get the real memory image

Packed, frozen or cracked games only exist in their final form after the loader ran. **Emulate the load** rather
than re-implementing a depacker.

- `py -3 util/emu.py <file> <stop> mem.bin` – runs every INIT, then RUN, stops at the address where the game
  proper starts (or a snapshot-restore routine). Then `resume.py` if a snapshot restore follows → `game.bin`.
- Trace suspicious areas segment by segment (e.g. a region that is unexpectedly zero) before trusting the image.
- Write down the boot chain: who jumps where, what each stage does.
- **Gate:** `game.bin` (64 KB) + boot chain in the README; zero/odd regions explained.

### Step 3 – Find entry points and disassemble

- Entry points: RUNAD/INITAD targets, the game's start, NMI/IRQ/RESET vectors ($FFFA-$FFFF when the OS is off),
  **interrupt vectors set from code or init tables** (VDSLST $200, VVBLKI $222, VVBLKD $224), DLI chains (a DLI
  that writes the next DLI's address), jump tables.
- `rdis.py` follows JMP/JSR/branches and immediate vector set-ups. It **cannot** see code reached only through
  data – search for it: writes to variables you know, pointers in init tables, `jmp (ind)`.
- An instruction whose operand is patched at run time (self-modified JMP/JSR) must go into `NOFOLLOW`.
- **Gate:** a code-range list; every big unexplained gap between code ranges looked at.

### Step 4 – Split into blocks, reassemble byte-exact

- In `split.py` define `BLOCKS` (file, first, last, description): code → `.ASM`, data → binary with the Atari
  `$FFFF,start,end` header (included with `opt h-` + `ins`). Names by address (`D0500.DTA`) until understood.
- Generate, assemble, verify:
  ```
  py -3 util/split.py game.bin <entries…>
  "$MADS" main.asm -o:bin/game.obx
  py -3 util/verify.py bin/game.obx
  ```
- Add a `Makefile` (`all`, `test`) like the other games.
- **Gate:** "matches game.bin byte for byte" with real MADS.

### Step 5 – Understand the code

Work top-down; the order below finds the structure fastest.

1. **Call graph with resources** – per routine: callers, callees, hardware registers, zero-page and absolute
   addresses used. Clusters appear (display, sound, sprites, player, enemies).
2. **Start and main loop** – read the game's start, then every routine the per-frame loop calls.
3. **Interrupts** – NMI/DLI/VBI handlers; who sets which vector (init tables!).
4. **Init tables** – lists of (address, value) pokes reveal hardware set-up and the meaning of variables.
5. **Data** – display lists (count lines to get block sizes), fonts (CHBASE values), screen codes
   (text is often in the game's own font / tiles), pointer tables, KBCODE tables (cheat codes).
6. **Missing callers** – if nobody calls a routine statically: search immediate pairs, RTS tricks, self-modified
   operands, init tables; finally **emulate** from the game start and see whether the main loop reaches it
   (if not → interrupt).
7. Write every finding with addresses into `NOTES.md` as you go.

- **Gate:** every routine has a one-line description (`COMMENTS`), the main loop and interrupts are explained.

### Step 6 – Regroup blocks into modules

- Re-cut `BLOCKS` along **contiguous** ranges with one purpose (player, enemies, levels, interrupts, ending…).
  Contiguity forces compromises – document them in the description.
- Data blocks get real names (`FONT08.FNT`, `MAP30.DTA`, `SHAPES.DTA`).
- Remove the old block files (`git rm` exact paths), regenerate, verify.
- **Gate:** README block table with one row per file; byte-exact.

### Step 7 – Name and comment

Style of [robbo/d1/R1.ASM](robbo/d1/R1.ASM): `* group ----` comment lines, upper-case names with `_`, a comment at
the end of every variable line.

- `VARIABLES` – `'* group ----'` headers + `(address, size, NAME, comment)`. Variables inside an `.ASM` block are
  defined where they live (`PLAYER_X dta $B6 ; player X`), the others as `EQU` in `JOINT.ASM`.
- `NAMES` – every procedure (JSR target) and routine-like jump target; prefix per module (`EN_`, `PL_`, `SCR_`…).
  **Identify the logic first, then name it.**
- `COMMENTS` – a `* what it does ---` header above every routine and data block.
- `POKES` – init tables written as `dta a(NAME),$vv`.
- **Gate:** no generated `sub_XXXX` labels left; byte-exact; names unique (`split.py` checks).

### Step 8 – Graphics and verification against the real game

- Render fonts, maps, logos with the real palette (`util/palette/XFormer.act`).
- Get a **screenshot from an emulator** and compare: layout tile by tile, and colours – a screenshot has only a
  few exact colours, so each can be traced back to an Atari colour value and checked against the code.
- Keep the screenshot as `img/<game>.png` (repo convention) and the renders in `img/`.
- **Gate:** renders match the screenshot; differences explained.

### Step 9 – Document, clean, commit

- `README.md` – reference: files, blocks, boot chain, memory map, game structure, known addresses, level maps.
- `NOTES.md` – dated sections (what, how, findings with evidence, lessons), Timeline, Open questions.
- Clean: `git status --short --ignored`; remove build outputs, intermediates, caches, stale files (exact paths).
- Verify the build once more, then commit (on a branch, with a descriptive message).

---

## 4. Plan template

Copy into the game's `NOTES.md` as the first section and tick off.

```markdown
## Plan

| # | Step | Deliverable | Gate | Done |
|---|---|---|---|---|
| 1 | Inventory | segment table, tags decoded | README table | [ ] |
| 2 | Memory image | game.bin, boot chain | odd regions explained | [ ] |
| 3 | Entry points + disassembly | entry list, code ranges | gaps looked at | [ ] |
| 4 | Blocks + byte-exact build | src/, main.asm, Makefile | MADS: byte for byte | [ ] |
| 5 | Understand code | call graph, main loop, interrupts, init tables | every routine described | [ ] |
| 6 | Modules | BLOCKS regrouped, data named | byte-exact, README block table | [ ] |
| 7 | Names + comments | VARIABLES, NAMES, COMMENTS, POKES | no sub_XXXX, byte-exact | [ ] |
| 8 | Graphics + verification | renders, screenshot in img/ | renders match screenshot | [ ] |
| 9 | Docs, clean, commit | README, NOTES, CLAUDE.md rules | clean tree, verified build | [ ] |
| – | Optional | runnable XEX, level images with objects, music extraction | | [ ] |
```

NOTES.md section template:

```markdown
## N. <topic> (YYYY-MM-DD)

What was done and why. How (commands, scripts, method).

Findings (each with evidence):
- `$ADDR` … – shown by `$ADDR: instruction`.

Corrections of earlier sections (mark the old text "corrected in section N").
Lessons. Verified: <build / render / emulator result>.
```

Table entry templates for `split.py`:

```python
BLOCKS    = [('PLAYER.ASM', 0x8A4D, 0x8DEF, 'player control (deferred VBI $8A8F)'), ...]
VARIABLES = ['* player ----', (0x934D, 1, 'PLAYER_X', 'player X'), ...]
COMMENTS  = {0x8EC3: 'main loop: every 3rd frame', ...}
NAMES     = {0x8EC3: 'MAIN_LOOP', ...}
POKES     = {0x930A: 21}          # init table: 21 x (lo, hi, value)
NOFOLLOW  = {0xF372}              # JMP with self-modified operand
```

---

## 5. Atari 8-bit hints

- **Memory:** OS ROM $C000-$CFFF / $D800-$FFFF can be switched off (PORTB $D301 bit 0) – games put code and
  fonts in the RAM underneath. I/O is $D000-$D7FF (GTIA $D0, POKEY $D2, PIA $D3, ANTIC $D4).
- **Shadow registers:** the OS VBI copies $2C0-$2C8 → colours, $22F → DMACTL, $230 → DLIST, $2F4 → CHBASE; a game
  with its own VBI often keeps that convention. Values in a *snapshot* are whatever was current then.
- **Display lists:** `$4x` = LMS (next 2 bytes = address), low nibble = mode (2 = text, 4 = 4-colour chars,
  `E` = 160×192 4 colours), `$8x` = DLI on that line, `$41` = jump and wait for VBL. Counting the mode lines gives
  the exact size of the screen data.
- **ANTIC mode 4:** 2 bits per pixel; pixel value 3 uses PF3 instead of PF2 when the character's bit 7 is set.
- **DLI chains:** each DLI stores the next DLI's address into VDSLST – follow the chain to find all of them.
  Background "colour" is per scanline: read the DLIs before rendering.
- **Init tables:** `(lo, hi, value)` triples applied in a loop (`lda tab,x / sta ($C0),y`) – decode them early.
- **Text** is often in screen codes of a custom font, or in tiles – a plain ATASCII search finds nothing.
- **Keyboard:** KBCODE values (+$40 = Shift) – a table compared with KBCODE in the VBI is likely a cheat code.
- **Music:** CMC players use `jmp` table at +0 (init), +3 (command: A=$70 init tune with X/Y = address,
  $10 = song position, $40 = stop), +6 (play, from the VBI).
- **Protection:** reads of SERIN ($D20D), checksums of own code, traps that wipe code when a flag is wrong; cracks
  NOP them out (`EA EA EA`) – and sometimes NOP the wrong bytes.
- **Frozen/cracked versions:** trainers are loaded on top of game data; "snapshot" values come from the cracker's
  code, not the game's initial state – take initial values from the game's own init tables.

---

## 6. Lessons learnt (Jaskiniowiec)

### 6.1 Getting the image
- Emulate the loader of packed/frozen files instead of guessing the depacker; trace which segment changes a
  suspicious region before believing (or rejecting) it.
- An emulator stub that never returns the awaited value hangs the run (VCOUNT had to reach $80).

### 6.2 Disassembly pitfalls
- Recursive descent misses code reached through **data**: VVBLKD set from an init table (the whole player code!),
  DLI chains via VDSLST. Look for writes to known variables, then for who calls that code; if nobody, check the
  interrupt vectors in init tables; a short emulation run proves "not called from the main loop".
- Heuristics produce false positives: pairing an immediate load with the *next* vector store turned a display
  list into "code" and invented an interrupt routine. Track which register holds which value.
- Self-modified JMP/JSR operands point to garbage – don't follow them (`NOFOLLOW`).
- Undocumented opcodes exist in real games (`$AB` LXA) – an opcode table without them leaves `dta` holes.
- MADS chooses zero page automatically; forcing absolute with `.w` works only for LDA/LDX/LDY/STA/STX/STY – emit
  `dta $op,a(addr)` for the others. Check such facts in the local MADS docs (`doc/mads_eng.html`).

### 6.3 Data and the crack
- A crack can damage the game: the trainer was loaded over level 2's map rows, and in the level 3 loader three
  bytes of the cave-room copy were NOPed (`A0 EA EA EA AA` instead of `A0 40 B9 38 AA`) – probably making level 3
  unfinishable. Compare repeated code patterns (five loaders alike, one different) to spot such damage.
- Don't trust guessed sizes: the logo was 24 lines, not 28 – the display list told the truth.
- Words matter: the "treasures" were food (the status-line bar is labelled "JEDZENIE").

### 6.4 Verification
- A real screenshot is the best test: exact colours trace back to Atari colour values; the palette that matched
  (XFormer) turned out to be the emulator the screenshot came from.
- Values in the snapshot (background $A4 green) were the trainer's – the game's init table said $76; and the
  playfield background was black because the DLIs change it per scanline.
- Don't put renders made with wrong assumptions into the repo – fix the rules in a tool and regenerate.
- A stand-in assembler is fine for a first check, but run real MADS as soon as it is available.

### 6.5 Repository and environment
- A clean `git status` does not mean a file is gone – it means it is unchanged; check the file list.
- `.gitignore` patterns are case-insensitive on Windows: `*.XEX` also ignored the original `.xex`.
- A new user environment variable is not seen by running programs or their child processes; VS Code (and its
  terminals) must be restarted. Test set-up instructions before documenting them.
- Clean after every change (build outputs, intermediates, caches, stale files) – delete exact paths only.
- Keep instructions in `CLAUDE.md` (travels with the repo), findings in `NOTES.md`, reference in `README.md`.

---

## 7. Definition of done for a game

- [ ] Sources reassemble byte for byte with MADS (`make test` or the documented commands).
- [ ] Every block, routine and variable has a name and a comment; no generated `sub_XXXX` labels.
- [ ] README: files, blocks, boot chain, memory map, game structure, known addresses, images.
- [ ] NOTES: dated sections with evidence, Timeline, Open questions; damage/oddities explained.
- [ ] Renders verified against a real screenshot (`img/<game>.png`).
- [ ] Root README lists the game; repo clean; changes committed.
