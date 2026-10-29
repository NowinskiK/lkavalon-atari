# LK Avalon sources

Repository contains sources of the LK Avalon games for 8-bit Atari, released around 1990.

Sources were downloaded from [Atari XL/XE Source Archive](http://sources.pigwa.net/), transformed from ATASCII to ASCII with [convert-atascii.go](util/convert-atascii.go) and manually cleaned up. Now they can be compiled with [MADS](https://mads.atari8.info/).

## Available sources

* [Digi Duck](digi-duck)
* [Fred](fred)
* [Hans Kloss](hans-kloss)
* [Misja](misja)
* [Robbo](robbo)

## Requirements

* MADS assembler
* GNU make
* golang - optionally, for running extra tools
* Python 3 - for the [Jaskiniowiec](jaskiniowiec) reverse-engineering tools

### MADS location

The build expects the full path to the MADS executable in the `MADS` environment variable
(the [Jaskiniowiec](jaskiniowiec) Makefile uses it and falls back to `mads` on `PATH`; the other Makefiles
still call `mads` from `PATH`). Check whether it exists:

```powershell
$env:MADS                                              # PowerShell
```

```bash
echo "$MADS"                                           # Git Bash / Linux / macOS
```

If it is empty, set it once (example path – use your own MADS folder):

```powershell
# Windows, permanently for the current user (open a new terminal afterwards)
[Environment]::SetEnvironmentVariable('MADS', 'x:\ATARI\Tools\Mad-Assembler-2.1.5\mads.exe', 'User')
```

```bash
# Linux / macOS (add to ~/.bashrc or ~/.zshrc)
export MADS="$HOME/tools/mads/mads"
```

Windows environment variables are also visible in Git Bash (new session needed), where the path
can be used as `"$MADS"`.

## Compilation

Each game can be compiled with:

```bash
"$MADS" main.asm -o:game.xex
```

Or with make:

```bash
make
```

Checksums can be validated with:
```bash
make test
```
