# Why Robbo Konstruktor erases your planet: the copy protection explained

Robbo Konstruktor (L.K. Avalon, 1990) is the level editor for Robbo. On a disk image in an emulator, a planet
sometimes empties itself while you edit. The forum thread
[Dyskowy Robbo Konstruktor na emulatorze](https://atarionline.pl/forum/comments.php?DiscussionID=3815)
(atarionline.pl, 2016–2019) reported this and found the cause by experiment: copy protection that reacts to the
emulator's disk acceleration. A second protection makes copied disks fail with "błąd - za dużo robocików!". This
article shows the code behind both, taken from the disassembly in this repository.

Addresses refer to the disk image `Robbo Konstruktor (1990)(L.K. Avalon)(PL).atr` ("fast hack by Mr.Bacardi") and to
the sources in [src/](src/), which rebuild that program byte for byte. Statements marked *(inferred)* follow from
the code but were not measured on real hardware.

## Symptom

- You edit a planet, and after a while the board is suddenly empty, with default colours and the status "pusta"
  (empty).
- It happens when you pick the **brick wall** (*murek*) in the element palette, or move the cursor over it.
  Every designer does this all the time, so it seems to happen "after a few minutes".
- In the emulator it goes away when the disk acceleration is switched off (Altirra: System → Acceleration →
  "D: patch (Disk SIO)"); the thread also found that PAL instead of NTSC mattered. The cassette version was not
  affected.

## Root cause in one paragraph

At start-up the program XORs two bytes: the last byte that arrived over the serial line (POKEY register `SERIN`,
`$D20D`) and the high byte of `DOSINI` (`$000D`). It stores the result at `$9F8B`. On the original disk the two are
equal, so the result is 0 *(inferred: that is the only value that passes)*. Later, whenever the editor shows the
name of the wall element, it reads that byte; if it is not 0, it erases the current planet. An emulator's SIO patch
loads sectors without passing the bytes through POKEY, so `SERIN` still holds some earlier value, the XOR is not 0, and
the trap fires.

## The three parts

### 1. The key: the boot record

The first six bytes of sector 1 are the boot record:

```
$0500: AE 03 00 05 DD 19     flags, 3 sectors, load address $0500, init address $19DD
```

The OS copies the init address into `DOSINI` ($0C/$0D). Nothing is ever loaded at `$19DD`; the address is not an
init routine but the key. Its high byte, **`$19`**, is the value `SERIN` has to match.

### 2. Taking the fingerprint: `PROT_KEY` ($9F4D)

These 39 bytes sit at the end of the routine that fills empty planets (`PLANETS_FILL`), run once at start-up, and
then destroy themselves:

```
PROT_KEY
         lda  $A804                ; 9F4D  the "R" of the text "Robbo"
         bmi  L9F6E                ; 9F50  bit 7 set -> skip the whole thing
         lda  CUR_ELEM             ; 9F52  palette entry shown = 6 at this moment
         sec                       ; 9F55
         rol                       ; 9F56  A = 6*2+1 = $0D
         sta  $B0                  ; 9F57  pointer 1, low byte = $0D
         sta  $B2                  ; 9F59  pointer 2, low byte = $0D
         asl                       ; 9F5B  $1A
         asl                       ; 9F5C  $34
         sec                       ; 9F5D
         rol                       ; 9F5E  $69
         asl                       ; 9F5F  $D2
         sta  $B3                  ; 9F60  pointer 2, high byte = $D2  -> $D20D = SERIN
         eor  $B3                  ; 9F62  A XOR A = 0
         sta  $B1                  ; 9F64  pointer 1, high byte = $00  -> $000D = DOSINI+1
         tay                       ; 9F66  Y = 0
         lda  ($B0),y              ; 9F67  DOSINI+1   ($19)
         eor  ($B2),y              ; 9F69  XOR SERIN
         sta  PROT_SUM             ; 9F6B  -> $9F8B
L9F6E
         lda  #$60                 ; 9F6E  RTS
         sta  PROT_KEY             ; 9F70  over its own first byte: never runs again
         rts                       ; 9F73
```

Neither `$D20D` nor `$000D` appears anywhere in the program: both pointers are computed from the number of the
palette entry shown at start-up. A search for `SERIN` or for the bytes `0D D2` finds nothing. After the first call
the routine is just an `RTS`. *(The test of `$A804` skips the protection when the "R" of "Robbo" is in inverse
video. That never happens in this image; maybe it is a switch for another version of the program.)*

### 3. The trap: `ELEM_MSG_` ($9CDD)

When the cursor is in the palette, the editor shows the element's name: palette entry X uses message number
X + $1E. The routine that does it has an extra test for one entry:

```
ELEM_MSG_
         ...
         txa                       ; 9CEB  X = palette entry
         adc  #$1E                 ; 9CEC  message number
         cmp  #$2A                 ; 9CEE  $2A = entry 12 = "murek", the brick wall
         bne  L9CFC                ; 9CF0
         lda  HDR_BUF+4,x          ; 9CF2  $9F7B + 4 + 12 = $9F8B = PROT_SUM
         beq  L9CFA                ; 9CF5  0 -> all right
         jsr  PLANET_CLR           ; 9CF7  otherwise: erase the current planet
L9CFA
         lda  #$2A                 ; 9CFA  then show "murek" as if nothing happened
```

`HDR_BUF` ($9F7B) is the buffer holding the current planet's header (colours), and `HDR_BUF+4,x` looks like an
ordinary read of a colour. Only with X = 12 does it reach past the 8-byte buffer and the 8 default colours at
`$9F83`, onto `PROT_SUM`. No instruction in the program names `$9F8B` except the store in `PROT_KEY`.

`PLANET_CLR` ($97DB) is the same routine the menu's "czyść planetę" (clear the planet) uses. It fills the 16 × 31
board with empty cells, writes the default header and marks the planet as empty in the planet table. Every time
the wall's name is shown with a bad `PROT_SUM`, the planet being edited is erased.

## Why emulators trigger it

On a real Atari every byte of a disk transfer goes through POKEY's serial input, so after loading `SERIN` holds the
last byte the drive sent. An SIO patch (Altirra's "D: patch", similar options in other emulators) intercepts the OS
call `SIOV` and copies the sector straight into memory, so POKEY never sees the bytes. `SERIN` then holds whatever
it had before; that value depends on what the emulator did earlier, which is why the thread saw the problem come and
go with other settings (NTSC / PAL, start order). In the thread Krótki explained the same mechanism for the cassette
version, which checks `SERIN` = `$FF` after loading.

The thread also says the original disk has an unreadable sector (989, "Record Not Found"). An ATR image cannot
store such a sector, so in this image sector 989 is just a normal sector. Whether, with the SIO patch off, `SERIN`
then ends as `$19` with this image has not been checked yet.

## The second protection: "błąd - za dużo robocików!"

The thread also reports a second fault on copied disks: after the first yes/no question (the forum found it in the
disk menu, "zapisać zestaw 01? tak nie"; yes or no does not matter), every test or save of a planet that is not
empty fails with "błąd - za dużo robocików!" (error – too many robots). The SIO patch has nothing to do with it, and
once it has happened, putting the right bytes back does not help: the program has already changed its own code.

### The check: `PROT_BOOT` ($B47D, at the end of `ASK_YESNO_`)

`ASK_YESNO_` ($B3F5) runs every "tak / nie" question. After the answer it does this:

```
PROT_BOOT
         lda  #$00                 ; B47D  one-shot flag: the operand $B47E gets bit 7 below
         bmi  LB49B                ; B47F  already done -> skip
         lsr  $B48C                ; B481  "eor $0A00,x" -> "eor $0500,x"  (the real address, halved)
         lsr  $B492                ; B484  "cmp $0440"   -> "cmp $0240"
         ldx  #$FF                 ; B487
         txa                       ; B489  A = $FF
LB48A
         eor  $0500,x              ; B48A  XOR of the bytes $05FF ... $0501: the boot loader in memory
         dex                       ; B48D
         bne  LB48A                ; B48E
         cmp  $0240                ; B490  DFLAGS: the boot record's first byte, $AE
         beq  LB49B                ; B493  equal -> the disk is the original
         lda  START                ; B495  $4C, the JMP opcode at $A810
         sta  $ACB3                ; B498  -> written into COUNT_ELEM_: the lock
LB49B
         sec                       ; B49B
         ror  $B47E                ; B49C  set the one-shot flag
```

In the program as loaded, the two addresses are stored doubled (`$0A00`, `$0440`), so a search for `$0500` or
`DFLAGS` finds nothing; the first run halves them with `lsr`, then sets the flag so the check never runs again –
which is why changing the bytes afterwards has no effect.

What is checked: the XOR of `$FF` and the boot sectors as they are in memory (`$0501-$05FF`, the boot loader) must
equal the boot record's flag byte, which the OS keeps in `DFLAGS` ($0240). In this image the boot loader is the
cracker's ("fast hack by Mr.Bacardi") and gives **`$C1`** instead of **`$AE`**. With `30 12 A2` at `$0513` – the bytes
named in the thread – instead of the cracked `4C A6 05`, the result is exactly `$AE`: the original loader passes, a
modified one fails.

### The lock: `COUNT_ELEM_` ($AC8B)

`COUNT_ELEM_` counts the cells of the planet holding an element; `PLANET_TEST` uses it before a test or a save:
exactly one Robbo (`$2A`), exactly one capsule, fewer than 100 screws. Its last instruction is followed by two
bytes that look like leftover data:

```
         lda  $B6                  ; ACB1  the count
         rts                       ; ACB3  $60 - after the failed check: $4C
         dta $03,$B0               ; ACB4
```

With `$4C` at `$ACB3` the routine ends with **`JMP $B003`** – `WAIT_VBL`, which returns with A = `RTCLOK+2`, the
frame counter. Every count is then a random number, almost never exactly 1, so the first test (Robbos) reports
"za dużo robocików!" (error 6). An empty planet is still accepted, because `PLANET_TEST` checks for "empty" before it
counts – which is why the error appears only after adding any element.

The 6502 emulator in this repository (`util/emu.py`) ran `PROT_BOOT` on this image: with the cracked loader
`$ACB3` becomes `$4C` (locked); with `30 12 A2` at `$0513` it stays `$60`.

## What to do

- **First protection, emulator**: switch off the disk SIO acceleration and use PAL (forum, posts 9–15). This does
  not help against the second one on a copied or cracked disk.
- **Patch both**: [nocopyprot.asm](nocopyprot.asm) builds the program from the unchanged sources and adds two
  segments:
  - `$9CF7`: `jsr PLANET_CLR` (`20 DB 97`) → `NOP NOP NOP` (`EA EA EA`) – the planet is never erased, whatever
    `SERIN` held;
  - `$B47E`: the one-shot flag `$00` → `$80` – `PROT_BOOT` believes it has already run and skips the check, so
    `COUNT_ELEM_` is never patched.

  `util/mkatr.py` writes the result onto a copy of the disk (`bin/build.atr`); it differs from the original image in
  exactly these 4 bytes. In VS Code: task "Robbo Konstruktor: run build (protection off)". The emulator run above
  confirms the second patch (`$ACB3` stays `RTS`).
- Smaller alternatives for the first protection: `$60` (`RTS`) at `$9F4D`, so `PROT_KEY` never runs and `PROT_SUM`
  keeps its initial 0; or `$D2` at `$A804` (an inverse "R") – both rely on `PROT_SUM` staying 0. For a program that
  is already locked in memory: put `$60` back at `$ACB3`.

## Credits

The problem and the experiments: MDW, voy, miker, QTZ and Krótki in the atarionline.pl thread (2016–2019); QTZ located
the stored value at `$9F8B`, Krótki identified `SERIN` and `DOSINI`; the reproduction of the second error and the
memory comparisons (`$0513` = `30 12 A2`, the changes around `$B47E`) pointed to the second check. The code analysis
here: NOTES.md sections 21-23.
