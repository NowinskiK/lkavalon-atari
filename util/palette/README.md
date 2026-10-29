# Atari 8-bit palettes

Palettes used to turn Atari colour values (`$hl`: hue in the high nibble, luminance in the low nibble) into RGB,
e.g. when rendering game graphics to images.

| File | Use | Author / origin | MD5 |
|---|---|---|---|
| [XFormer.act](XFormer.act) | **default** – matches a reference screenshot of Jaskiniowiec (24 of 24 colours within 1-2 RGB steps) | palette of the XFormer emulator, as shipped with Atari800 | `778f0827d79126a39e6ca1caf89f3a7d` |
| [jakub.act](jakub.act) | alternative | Jakub Bogusz; built into Atari800 since 1.3.6 | `114eb4b325af0ea8cd6173a677200a96` |

- Format: 768 bytes = 256 × RGB (one byte per channel), index = Atari colour value (Adobe Color Table `.act`,
  the format Atari emulators load).
- Source: <https://github.com/atari800/atari800/tree/master/act> (`XFormer.act` last changed upstream in
  commit `c3d8074628`, 2000-10-10; `jakub.act` in `c8bedf4985`, 2001-11-30). Atari800 is distributed under GPL-2.0.
- Downloaded 2026-10-29. Atari800 also has `Real.act`, `default.act`, `gray.act` in the same folder.

Reading it in Python:

```python
pal = open('util/palette/XFormer.act', 'rb').read()
rgb = lambda c: tuple(pal[c * 3:c * 3 + 3])
```

How the default was chosen: the 24 distinct colours of a Jaskiniowiec start-screen screenshot
([jaskiniowiec/img/jaskiniowiec.png](../../jaskiniowiec/img/jaskiniowiec.png), taken in the XFormer emulator)
were matched against all five Atari800 palettes – average distance XFormer 1.3, jakub 22.6, Real 23.5,
default 26.8 (RGB units). The near-exact match is expected: it is the same emulator's palette.
See `jaskiniowiec/NOTES.md` section 13.
