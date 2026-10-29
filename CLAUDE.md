# CLAUDE.md

Sources of LK Avalon (and related) games for 8-bit Atari, assembled with MADS. One folder per game.

## Repository conventions

- Each game folder: `main.asm` (links everything), `Makefile` (`all`, `test`), `README.md`, `bin/`, `img/`, `archive/`.
- Code in `.ASM` files; binary data (fonts, music, levels) as files **with the Atari `$FFFF,start,end` header**,
  included in `main.asm` with `opt h-` + `ins`.
- `make test` must prove the build is byte-exact (md5 checksums or a verify script).
- Keep the style of the existing sources: MADS syntax, lower-case mnemonics, labels in column 1.
- Add a new game to the list in the root `README.md`.

## Environment

- Windows; use `py -3` for Python.
- MADS and GNU make are **not installed** on this machine – don't claim a MADS build was run.
  Say so and use the folder's own verify tools instead.

## jaskiniowiec/ (reverse-engineered, not original source)

Read `jaskiniowiec/README.md` (reference) and `jaskiniowiec/NOTES.md` (process, findings, lessons) first.

- `src/` and `main.asm` are **generated** by `split.py` from `game.bin`. Change block boundaries/names in
  `BLOCKS` in `split.py` and entry points on its command line, then regenerate. Don't hand-edit `src/` until
  annotation work starts (after that, `split.py` must not be rerun over annotated files).
- After every regeneration verify:
  ```
  py -3 split.py game.bin 6214 9EAE 9EC8 9ED6 62DF 9E97 F2E1 F2E4 F2E7 8A8F 8874 88AA 8929 93C7
  py -3 asm.py main.asm bin/game.obx
  py -3 verify.py bin/game.obx
  ```
  The result must be "matches game.bin byte for byte".
- Blocks must start/end on instruction boundaries (`split.py` asserts it); code reached only via data
  (interrupt vectors, poke tables, DLI chains) must be added as an entry point.
- `split.py` does not delete files: when blocks are renamed, stale files stay in `src/` – list them for the user
  to delete (deleting `src/*` is blocked by the safety check).
- Record new findings in `NOTES.md` (with addresses as evidence) and keep the README block table in sync.
