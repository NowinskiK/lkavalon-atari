# Robbo Konstruktor – what it is

What the program is about, for whom, how it is used, and the terms it uses – derived from its help text
(`src/HELP.ASM`), its screens and messages (`src/TEXTS.ASM`), its code (`NOTES.md`) and the instructions of the game
it edits (`../robbo/d1/TITLE.ASM`). Statements are marked *(interpretation)* where they are not read directly from
those sources.

## Overview

**Robbo Konstruktor** (L.K. Avalon, 1990) is a **construction kit for the game Robbo**. The help text introduces it
as "the first widely available utility program by Avalon" ("pierwszy szeroko dostępny program użytkowy firmy
Avalon"). With it you build your own *planets* – Robbo's levels – test them, arrange them into a game, and save a
**stand-alone version of Robbo** with your planets that runs without the Konstruktor.

The program contains a full copy of Robbo's game engine (code shared with `../robbo/`), so every planet can be played
directly from the editor.

## The game it builds – Robbo

From Robbo's own instructions (`../robbo/d1/TITLE.ASM`, translated):

> Robbo has to travel a hard road through the planets to escape from the hostile planetary system in which he was
> treacherously imprisoned. On every planet a small **capsule** is waiting for him that can fly to the next planet.
> Unfortunately most capsules are incomplete, so Robbo has to collect the right number of **parts** scattered all
> over the planet. The **evil creatures** ("złe stworki") – the inhabitants of the system – will try to stop him. On his way Robbo finds
> various objects; discover what they are for – try to push them, collect them or shoot at them. If Robbo gets into a
> situation with no way out, press ESC. Remember: every planet can be completed.

So a planet is complete when Robbo has collected enough screws (*śrubki*, the capsule's parts) and reaches the
capsule *(interpretation: "parts" = the screws, from the editor's test "za dużo śrubek – max: 99" and Robbo's level
data)*.

## Goal of the program

- **Design planets**: place elements on a board of 16 × 31 cells (the editor shows a 16 × 10 window and scrolls).
- **Check them**: the editor's test refuses a planet that cannot work – no Robbo, more than one Robbo, no capsule,
  more than one capsule, 100 or more screws ("błąd: brak robocika!", "za dużo kapsuł!", "za dużo śrubek! – max:99").
  Each planet is marked *good*, *bad* or *empty* (legend "zła / dobra / pusta").
- **Play them**: "test planety" runs Robbo's engine on the current planet, "test Robbo" on the whole game.
- **Make a game**: set the planet order, write the title and congratulation texts, set the colours.
- **Keep and share**: save / load sets of planets on tape or disk (5 slots on the Konstruktor disk), and save a
  stand-alone Robbo game ("zapisz Robbo") – on disk this formats the disk first.

## Users

- **The player-designer**: the person using the Konstruktor to build planets – the help addresses them directly
  ("Przy pomocy Konstruktora możesz…" – "with the Konstruktor you can…").
- **The players of the result**: the stand-alone Robbo game saved by the Konstruktor is for other people to play;
  its title page shows the designer's own texts.

## How it is used

1. **Main menu** along the bottom of the screen, two pages of functions (*funkcje podstawowe* / *dodatkowe*), chosen
   with the cursor and fire; ↑↓ choose the planet, ESC goes to the editor.
2. **Editor**: the board on the left, the **element palette** on the right; choose an element in the palette, put it
   on the board at the cursor with fire.
3. **HELP** at any time shows the help page for the current function; messages appear in the line at the bottom.
4. Controls: joystick or the cursor keys; space, RETURN and SHIFT work as fire.

| Function (Polish) | English | Menu page |
|---|---|---|
| test planety | test the planet | basic |
| czyść planetę | clear the planet | basic |
| zmiana kolorów | change the colours | basic |
| operacje dyskowe / kasetowe | disk / tape operations (load, save, erase a planet set) | basic |
| funkcje dodatkowe | additional functions (switch page) | basic |
| strona tytułowa | title page (start and congratulation texts) | additional |
| kolejność planet | planet order (ustalona / normalna – fixed / normal) | additional |
| test Robbo | test the whole game | additional |
| zapisz Robbo | save the stand-alone Robbo game | additional |
| funcje podstawowe *(sic)* | basic functions (switch page) | additional |

## Elements (the palette)

Codes are Robbo's level characters (README "Palette").

| Polish | English | Code | Role in the game *(interpretation from names and Robbo's code)* |
|---|---|---|---|
| Robbo | Robbo | `$2A` | the player's robot – exactly one per planet |
| śrubka | screw | `$24` | the capsule's parts to collect – up to 99 |
| kapsuła | capsule | `$14` | the exit to the next planet – exactly one |
| skrzynka | box | `$23` | can be pushed |
| skrzynka na kółkach | box on wheels | `$06` | a box that keeps rolling (*bezwładna skrzynia*, "BEZ" routines) |
| drzwi | door | `$12` | opens with a key |
| klucz | key | `$3D` | opens doors |
| amunicja | ammunition | `$21` | bullets for Robbo's gun |
| gruz | rubble | `$25` | |
| bomba | bomb | `$40` | |
| magnes | magnet | `$28`, `$29` | pulls Robbo in and destroys him (Robbo's `PRZY`) |
| oczy | eyes | `$26` | a creature |
| murek | (brick) wall | `$00` | |
| nicość | void / nothingness | `$13` | |
| gumka | eraser | `$20` | the empty cell – erases |
| stworek leworęczny / praworęczny | left-handed / right-handed creature | `$41` / `$45` | creatures following the wall on their left / right *(interpretation)* |
| niespodzianka | surprise | `$3F` | turns into a random object (Robbo's `NIES`) |
| działko obrotowe | rotating gun | `$2E` | |
| działko ruchome | moving gun | `$0E` | |
| zmiana dział, nietoperzy i teleportacji | change of guns, bats and teleports | `$A0` | a palette switch, not an element |
| nietoperz (strzelający) | bat (shooting) | | variants chosen with the switch |
| działko, laser, blaster | gun, laser, blaster | | gun variants (Robbo's `DZ1`, `DZ2`, `DZ3`) |
| teleportacja | teleport | | |

## Glossary (Polish – English)

### Program and game terms

| Polish | English | Meaning here |
|---|---|---|
| planeta | planet | a level / board of 16 × 31 cells |
| zestaw planet | planet set | the planets saved together in one slot |
| robocik | little robot | Robbo |
| część | part | what a capsule is missing – the screws |
| stworek | creature | an enemy, inhabitant of the system |
| element (składowy planety) | (planet) element | anything placed on a cell |
| zbiór elementów | element set | the palette |
| edytor planety | planet editor | |
| strona tytułowa | title page | |
| tekst początkowy / gratulacyjny | start / congratulation text | texts of the stand-alone game |
| kolejność | order | |
| ustalona / normalna | fixed / normal | planet order modes |
| kolory, jaskrawość | colours, brightness | |
| strzał | shot / fire | the fire button (and space, RETURN, SHIFT) |
| kursor | cursor | |
| podpowiedź | hint | help (HELP key) |
| komunikat | message | the line at the bottom of the screen |
| instrukcja | instructions | |

### Messages and answers

| Polish | English |
|---|---|
| błąd | error |
| brak robocika / kapsuły | no robot / no capsule |
| za dużo robocików / kapsuł / śrubek | too many robots / capsules / screws |
| planeta jest pusta | the planet is empty |
| wszystkie planety są puste | all planets are empty |
| wyczyścić planetę? | clear the planet? |
| tak / nie | yes / no |
| zła / dobra / pusta | bad / good / empty (planet status) |
| Uwaga | Attention |
| operacja przerwana | operation aborted |
| ten zestaw planet jest zniszczony | this planet set is damaged |
| dyskietka jest uszkodzona | the disk is damaged |
| to nie jest zestaw planet | this is not a planet set |
| szukanie początku zestawu planet | searching for the start of the planet set (tape) |
| wczytywanie / zapisywanie | loading / saving |

### Tape and disk

| Polish | English |
|---|---|
| dyskietka, dysk | diskette, disk |
| taśma, magnetofon | tape, tape recorder |
| operacje (kasetowe / dyskowe) | (tape / disk) operations |
| zawartość dysku | disk contents |
| wczytaj / zapisz / skasuj | load / save / erase |
| pusty / pełny | empty / full (slot) |
| zestaw 01 … 05 | set 01 … 05 (disk slots) |

### Label abbreviations in the engine (from Robbo's sources)

| Abbreviation | Polish | English | Confirmed |
|---|---|---|---|
| DZ | działko | small gun | user |
| PO | pocisk | bullet | user |
| PP | pozycja pocisku | bullet's position | user |
| BEZ | bezwładne skrzynie | sliding (inertial) boxes | user |
| DZRU | ruch działo | gun movement | Robbo's comment |
| MODL / MODR | mov działa | moving gun | Robbo's comment |
| NIES | niespodzianka | surprise box | code (`NIES LDA RND`) |
| TDOR / TSKA / TWYJ | drzwi? / skarb? / wyjście? | door? / treasure? / exit? | Robbo's comments (with "?") |
| PHAJ | pchaj | push | Robbo's comment |
| WFAC | pojawiaj | appear | Robbo's comment |
| ASCO | dodaj punkty | add points | Robbo's comment |
| PUTW | put wybuch / spacja | put explosion / space | Robbo's comment |
| ZEBR, NABO, LIVS, SCOR | zebrane, naboje, (lives), (score) | collected, ammunition, lives, score | from the names *(interpretation)* |

## Sources

- Help text: `src/HELP.ASM` (16 pages), decoded in README "Help text".
- Screens and messages: `src/TEXTS.ASM`, README "Editor texts".
- Code: `NOTES.md` sections 3-12.
- Robbo's instructions: `../robbo/d1/TITLE.ASM` (label `INST`).
