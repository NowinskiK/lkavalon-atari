"""Splits the game memory image into source blocks (like misja/digi-duck):
code areas -> src/*.ASM (disassembly), data areas -> binary files with an Atari $FFFF header,
plus src/JOINT.ASM (common labels) and main.asm (links everything back together).

Usage: py -3 util/split.py game.bin ENTRY [ENTRY ...]
Edit BLOCKS to move boundaries or give blocks better names, then run it again."""
import sys, os
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from xex import L
from rdis import analyze, Lister, hw

# (file, first, last, description) - .ASM files are disassembled, everything else is written as binary
BLOCKS = [
    ('SYSTEM.DTA',  0x0000, 0x04FF, 'zero page, stack, OS variables at snapshot time'),
    ('D0500.DTA',   0x0500, 0x07FF, 'unknown (loader leftovers?)'),
    ('FONT08.FNT',  0x0800, 0x0FFF, 'level font A (copied to $D800/$E000 by $9221)'),
    ('FONT10.FNT',  0x1000, 0x17FF, 'level font B (copied by $9239)'),
    ('FONT18.FNT',  0x1800, 0x1FFF, 'text screens font (copied by $9215)'),
    ('SHAPES.DTA',  0x2000, 0x27FF, 'sprite shapes, 64 frames x 32 bytes'),
    ('D2800.DTA',   0x2800, 0x2FFF, 'unknown; $2C00-$2EFF is the ending work area'),
    ('MAP30.DTA',   0x3000, 0x39FF, 'level 1 map (10 rows x 256)'),
    ('MAP3A.DTA',   0x3A00, 0x43FF, 'level 3 map'),
    ('MAP44.DTA',   0x4400, 0x4DFF, 'level 5 map'),
    ('MAP4E.DTA',   0x4E00, 0x57FF, 'level 4 map'),
    ('MAP58.DTA',   0x5800, 0x61FF, 'level 6 map'),
    ('TRAINER.ASM', 0x6200, 0x646F, 'CAMOsoft crack stub and trainer, over level 2 map rows 0-2'),
    ('MAP62.DTA',   0x6470, 0x6BFF, 'level 2 map (rest)'),
    ('FONT6C.FNT',  0x6C00, 0x6FFF, 'status line font'),
    ('TILES.DTA',   0x7000, 0x70FF, 'tile attributes (read by $8DF0)'),
    ('PICTURE.DTA', 0x7100, 0x7BFF, 'title logo (mode E, 24 lines, to $74BF) and text screen pages ($74C0)'),
    ('SPRITE.ASM',  0x7C00, 0x8873, 'software sprite engine, double-buffered screen'),
    ('DLI.ASM',     0x8874, 0x8A4C, 'DLI chain ($8874), display lists ($8974, $89D8)'),
    ('PLAYER.ASM',  0x8A4D, 0x8DEF, 'player control (deferred VBI $8A8F), music on/off'),
    ('MAIN.ASM',    0x8DF0, 0x9026, 'status line, game entry ($8E67), main loop, screen flip, map drawing'),
    ('ENEMY.ASM',   0x9027, 0x9214, 'enemies: movement and spawning'),
    ('INIT.ASM',    0x9215, 0x948E, 'font copy, init tables, variables ($9349-$93C6), table builder'),
    ('ROOMS.ASM',   0x948F, 0x96C7, 'player map probe ($948F), cave rooms'),
    ('FADE.ASM',    0x96C8, 0x9795, 'colour fades'),
    ('ITEMS.ASM',   0x9796, 0x99FF, 'enemy contact, energy and lives, treasures'),
    ('LEVEL.ASM',   0x9A00, 0x9E96, 'level loaders, text screens, level completion; ending scroller VBI ($9CFB)'),
    ('IRQ.ASM',     0x9E97, 0x9FDA, 'NMI, IRQ, VBI (cheat code at $9F75)'),
    ('TEXTS.DTA',   0x9FDB, 0xA4E8, 'cave room screen, status line, text pages'),
    ('LEVELDAT.DTA', 0xA4E9, 0xAB7C, 'per-level tables: treasures, enemies, cave rooms'),
    ('ENDING.ASM',  0xAB7D, 0xB4ED, 'ending sequence, its DLI and display list ($ACFC)'),
    ('MUSCOPY.DTA', 0xB4EE, 0xBBFF, 'unused copy of MUSIC.CMC with XEX header'),
    ('SCREEN.ASM',  0xBC00, 0xBFFF, 'playfield screen memory (2 buffers); crack start stub at $BC00'),
    ('TABLES.DTA',  0xC000, 0xC9FF, 'mirror/mask tables, current level data, shape pointers'),
    ('MUSIC.CMC',   0xEA00, 0xF2E0, 'CMC music module'),
    ('CMC.ASM',     0xF2E1, 0xFAD1, 'CMC music player'),
    ('VECTORS.ASM', 0xFFFA, 0xFFFF, 'NMI, RESET, IRQ vectors'),
]

# Named variables: '* group' headers and (address, size, name, comment). Variables inside an .ASM block are
# written there as `NAME dta ... ; comment`, the others become `NAME equ ...` in JOINT.ASM. Evidence for each
# entry is in NOTES.md (sections 4, 13, 17, 18). Values in game.bin are a snapshot from the trainer.
VARIABLES = [
    '* zero page - display -----------',
    (0x0080, 1, 'FRAME',        'frame counter; bit 0 selects screen/font/DL buffer ($882C)'),
    (0x0083, 1, 'FONT_PAGE',    'CHBASE of the visible level font ($D8 / $E0), set by the DLIs'),
    (0x0084, 2, 'SPR_LIST',     'pointer to the sprite list of the drawn buffer ($C400 / $C480)'),
    (0x0086, 1, 'COL_BK',       'background colour above the playfield (DLI $8874)'),
    (0x0087, 4, 'COL_PF',       'playfield colours PF0-PF3 (DLI $8874); faded towards TARGET_COLS'),
    (0x00A4, 1, 'DLI_ROW',      'map row counter of the DLI chain'),
    '* zero page - game --------------',
    (0x008B, 2, 'MAP_PTR',      'pointer into the level map ($912F)'),
    (0x008D, 1, 'COUNTER',      'loop counter (screen scroll steps, $8F52)'),
    (0x008E, 1, 'NEXT_TICK',    'RTCLOK value of the next game frame (main loop runs every 3rd frame)'),
    (0x008F, 1, 'CAVE_FLAG',    'non-zero: enter the cave room ($94F7)'),
    (0x00A5, 1, 'ENERGY',       'energy, $60 when full; 0 costs a life ($9802)'),
    (0x00A6, 1, 'FOOD',         'food collected ("JEDZENIE"), 32 needed to finish a level'),
    (0x00A7, 1, 'LIVES',        'lives ("ZYCIA"), 3 at start'),
    (0x00A9, 1, 'MUSIC_OFF',    'non-zero: music and sound effects off (OPTION toggles, $8A64)'),
    (0x00DF, 1, 'PROT_FLAG',    'copy-protection flag: bit 7 clear destroys $84E9 ($8820)'),
    '* enemies (4 each) --------------',
    (0x7C60, 4, 'ENEMY_X',      'enemy X'),
    (0x7C64, 4, 'ENEMY_Y',      'enemy Y (0 = no enemy)'),
    (0x7C68, 4, 'ENEMY_FLAGS',  'enemy flags (bit 7 = mirrored)'),
    (0x7C6C, 4, 'ENEMY_FRAME',  'enemy sprite frame'),
    '* status line (screen memory) ---',
    (0xA0DF, 16, 'BAR_FOOD',    'food bar, half a character per unit'),
    (0xA104, 1, 'LIVES_DIGIT',  'lives digit'),
    (0xA107, 24, 'BAR_ENERGY',  'energy bar, a quarter character per unit'),
    '* text screens ------------------',
    (0x7788, 1, 'DIGIT_DONE',   'level digit in "etap N kompletny" (next-level page 1)'),
    (0x7879, 1, 'DIGIT_NEXT',   'level digit in "powodzenia w etapie N" (next-level page 2)'),
    (0x9E49, 8, 'LEVEL_DIGITS', 'digit tiles: [LEVEL] -> DIGIT_DONE, [LEVEL+1] -> DIGIT_NEXT'),
    '* cheat -------------------------',
    (0x9F75, 8, 'CHEAT_KEYS',   'KBCODEs of "PIERWSZY" (shifted); typed in the VBI -> 8 lives'),
    '* colours -----------------------',
    (0x9349, 4, 'TARGET_COLS',  'target colours PF0-PF3 of the screen (fades $9729/$9744)'),
    '* player ------------------------',
    (0x934D, 1, 'PLAYER_X',     'player X'),
    (0x934E, 1, 'PLAYER_Y',     'player Y'),
    (0x934F, 1, 'RESPAWN_X',    'player X after losing a life / entering a screen'),
    (0x9350, 1, 'RESPAWN_Y',    'player Y after losing a life / entering a screen'),
    (0x9351, 1, 'PLAYER_FRAME', 'player sprite frame (from ANIM_FRAMES)'),
    (0x9352, 1, 'WALK_STEP',    'walk-cycle index into ANIM_FRAMES'),
    (0x9353, 1, 'FACING',       'facing: 0 right, $F8 left'),
    (0x9354, 1, 'JUMP_STATE',   'jump: 0 on ground, >0 rising, $80 falling'),
    (0x9355, 1, 'JUMP_STEP',    'step in JUMP_ARC (0-11)'),
    (0x9356, 1, 'PROBE_FLOOR',  'tile attributes below the player ($948F)'),
    (0x9357, 1, 'PROBE_TILE',   'tile attributes at the player: bit 3 hazard, 4 exit, 5 food'),
    (0x9358, 1, 'PROBE_WALL',   'tile attributes beside the player'),
    (0x9359, 1, 'SWING',        'club-swing timer: fire sets $0D, counts to $10'),
    '* level -------------------------',
    (0x935A, 1, 'SCREEN_COL',   'map column of the visible screen'),
    (0x935B, 1, 'VAR_935B',     'only reset at a new level'),
    (0x935C, 1, 'LEVEL',        'level number 1-6'),
    '* DLI colour tables -------------',
    (0x935D, 16, 'SKY_COLS',    'background per scanline, map rows 0-1 (4 lines per half row)'),
    (0x936D, 12, 'STATUS_COLS', 'status line background, 12 scanlines'),
    '* player tables -----------------',
    (0x9379, 20, 'ANIM_FRAMES', 'state -> sprite frame; $0D-$0F = club swing'),
    (0x9395, 12, 'JUMP_ARC',    'Y change per jump step: 0 -2 -3 -3 -3 -2 -2 -2 -1 -1 0 +1'),
    '* sprite engine set-up ----------',
    (0x93A4, 8, 'SCREEN_SETUP', 'fonts $D8/$E0, screens $BC/$BE, display lists $8974/$89D8 ($7C03)'),
    '* enemy state (4 each) ----------',
    (0x93B0, 4, 'ENEMY_SPEED',  'speed / direction (+1 / -1, flipped on turn)'),
    (0x93B4, 4, 'ENEMY_ANIM',   'animation counter (0-3)'),
    (0x93BB, 4, 'ENEMY_ANIM_FR', 'frame offset per animation step'),
    (0x93BF, 4, 'ENEMY_TYPE',   'type: 0 walker, negative vertical, $40 static'),
    (0x93C3, 4, 'ENEMY_HITS',   'hits left (3 at spawn), removed at 0'),
]

# group comments above routines and data blocks: address -> what it is (written as `* text ---`)
COMMENTS = {
    # TRAINER.ASM
    0x6200: 'crack stub: DOSINI = trainer, warm start',
    0x6214: 'CAMOsoft trainer: "Unlimited lives ? [Y/N]"',
    0x62DF: 'trainer DLIs',
    0x6376: 'trainer patch: NOP the two DEC LIVES ($8C4E, $982D)',
    # SPRITE.ASM
    0x7C03: 'sprite engine: set up screens, fonts and DLs from a parameter block (X/Y)',
    0x7C84: 'draw all enemies into the hidden buffer',
    0x7DB2: 'sprite helpers: screen position, background, character allocation',
    0x7FE1: 'draw a shape: four variants (mirrored / not, two sizes) - $7FE1, $8243, $84E9, $864B',
    0x87CC: 'copy the sprite characters into the screen',
    0x8820: 'copy-protection trap: wipes the shape routine at $84E9',
    0x882C: 'wait for VBL, swap screen / font / display list buffers',
    # DLI.ASM
    0x8874: 'DLI: colours below the logo',
    0x88AA: 'DLI: top half of a map row (font, sky colours, status line)',
    0x8929: 'DLI: bottom half of a map row (font + $400)',
    0x8974: 'display list, screen buffer $BC00',
    0x89D8: 'display list, screen buffer $BE00',
    # PLAYER.ASM
    0x8A4D: 'clear the P/M players $CC00-$CFFF',
    0x8A64: 'music on / off (OPTION)',
    0x8A8F: 'player control - deferred VBI (VVBLKD)',
    # MAIN.ASM
    0x8DF0: 'tile attributes of tile A',
    0x8DF8: 'status line: food bar, energy bar, lives digit',
    0x8E67: 'game entry',
    0x8E80: 'new game',
    0x8EC3: 'main loop: every 3rd frame',
    0x8F08: 'sound effects from the player state',
    0x8F4C: 'scroll one screen right',
    0x8F82: 'scroll one screen left',
    0x8FB8: 'wait for the next frame',
    0x8FBF: 'wait for VCOUNT = $80',
    0x8FC7: 'draw the visible 20x10 tiles of the map into both screens',
    # ENEMY.ASM
    0x9027: 'move the 4 enemies, then draw sprites and swap buffers',
    0x909D: 'enemy: walker (turns at walls and edges)',
    0x90E5: 'enemy: flyer (horizontal)',
    0x9102: 'enemy: vertical',
    0x912F: 'map pointer / tile under X (A) and Y',
    0x9151: 'spawn the enemies of the current screen',
    # INIT.ASM
    0x9215: 'text screen set-up: music position, text font to $D800 / $E000',
    0x9221: 'copy level font A ($0800)',
    0x9239: 'copy level font B ($1000)',
    0x927D: 'apply the hardware / display init table',
    0x929B: 'init table: hardware and display (address, value)',
    0x92EC: 'apply the game-state init table',
    0x930A: 'init table: game state (address, value)',
    0x93C7: 'build the bit-reverse / mirror / mask tables at $C000 (not called)',
    # ROOMS.ASM
    0x948F: 'probe the map around the player -> PROBE_FLOOR / PROBE_TILE / PROBE_WALL',
    0x94F7: 'cave room: own loop until the player walks out',
    0x95D5: 'draw the cave room screen',
    0x9615: 'find the cave room of this screen, choose its food',
    0x9699: 'spawn the cave room enemies',
    # FADE.ASM
    0x96C8: 'fade out and clear the screens',
    0x96EB: 'one fade-out step',
    0x9729: 'fade in (status line colour fixed)',
    0x9744: 'fade in to TARGET_COLS',
    # ITEMS.ASM
    0x9796: 'player contact with hazards and enemies',
    0x9802: 'lose energy; at 0 lose a life',
    0x9837: 'draw the two food items of a cave room',
    0x9883: 'draw one food item into the screen',
    0x996F: 'is the player on a food item?',
    0x99E4: 'pick up food: FOOD + 1',
    # LEVEL.ASM
    0x9A00: 'level loaders: enemies -> $C500, cave rooms -> $C600, map, font, colours (level 1)',
    0x9A28: 'level 3 loader (cave-room copy broken, NOTES.md section 17)',
    0x9A79: 'colours of the font-A levels',
    0x9A8E: 'level 5 loader',
    0x9AB6: 'level 4 loader',
    0x9ADE: 'level 6 loader',
    0x9B2D: 'level 2 loader',
    0x9B55: 'text screen: intro',
    0x9B72: 'text screen: next level',
    0x9B8F: 'text screen: game over',
    0x9BAF: 'text screen: victory',
    0x9BDD: 'text screen colours',
    0x9BF2: 'draw a 20x10-tile text page',
    0x9C5A: 'text screen driver: pages, fade, wait for fire',
    0x9CCC: 'switch the status-line text',
    0x9CFB: 'ending scroller (VBI, installed by the ending at $B299)',
    0x9D6D: 'level completion: exit + 32 food -> next level, after 6 -> ending',
    # IRQ.ASM
    0x9E97: 'music init',
    0x9EAE: 'NMI: DLI -> (VDSLST), else VBI',
    0x9EC8: 'IRQ: disable POKEY interrupts',
    0x9ED6: 'VBI: shadow registers, joystick, cheat keys, music',
    0x9F7E: 'clear screens and level fonts',
    # ENDING.ASM
    0xAB7D: 'ending: build pixel table at $2C00',
    0xABDA: 'ending DLI',
    0xACFC: 'ending display list',
    0xAEF0: 'ending sequence',
    # CMC.ASM
    0xF2E1: 'CMC music player: init (+0), command (+3), play (+6)',
}

# init poke tables: address -> number of (lo, hi, value) entries
POKES = {
    0x929B: 27,   # hardware and display set-up, applied by $927D
    0x930A: 21,   # game state reset, applied by $92EC
}

SRC = 'src'


def header(name, lo, hi, desc):
    return ['; %s - %s' % (name, desc), '; $%04X-$%04X' % (lo, hi), '', '         org $%04X' % lo, '']


def main():
    mem = open(sys.argv[1], 'rb').read()
    code, labels = analyze(mem, [int(a, 16) for a in sys.argv[2:]])
    lst = Lister(mem, code, labels, VARIABLES, POKES, COMMENTS)
    os.makedirs(SRC, exist_ok=True)

    prev = -1
    for name, lo, hi, desc in BLOCKS:
        assert lo > prev, '%s overlaps the previous block' % name
        assert not any(hw(a) for a in (lo, hi)), '%s touches I/O' % name
        for a, n in code.items():
            assert not (a < lo <= a + n - 1 or a <= hi < a + n - 1), \
                'instruction at $%04X crosses the boundary of %s' % (a, name)
        prev = hi
        path = os.path.join(SRC, name)
        if name == 'VECTORS.ASM':
            vec = [mem[a] | mem[a + 1] << 8 for a in (0xFFFA, 0xFFFC, 0xFFFE)]
            body = ['         dta %-40s ; %s' % ('a(%s)' % lst.nm(v, 2), n) for v, n in zip(vec, ('NMI', 'RESET', 'IRQ'))]
            open(path, 'w', newline='\n').write('\n'.join(header(name, lo, hi, desc) + body) + '\n')
        elif name.endswith('.ASM'):
            body = lst.lines(lo, hi)
            open(path, 'w', newline='\n').write('\n'.join(header(name, lo, hi, desc) + body) + '\n')
        else:
            open(path, 'wb').write(bytes([0xFF, 0xFF, lo & 0xFF, lo >> 8, hi & 0xFF, hi >> 8]) + mem[lo:hi + 1])

    lost_comments = sorted(set(COMMENTS) - lst.placed_comments)
    if lost_comments:
        print('WARNING: comments not placed (inside an instruction or a binary block):',
              ' '.join('$%04X' % a for a in lost_comments))

    # anything outside the blocks that is not zero would be lost
    covered = bytearray(65536)
    for _, lo, hi, _ in BLOCKS: covered[lo:hi + 1] = b'\1' * (hi - lo + 1)
    lost = [a for a in range(65536) if mem[a] and not covered[a] and not hw(a)]
    if lost: print('WARNING: %d non-zero bytes outside blocks, first at $%04X' % (len(lost), lost[0]))

    # labels used in operands but not written at their own address (inside an instruction or outside the blocks)
    extra = sorted(a for a in lst.used if a not in lst.placed)
    joint = ['; JOINT.ASM - common labels', '', '; Atari OS and hardware', '']
    joint += ['%-8s equ $%04X' % (n, a) for a, n in sorted(L.items(), key=lambda x: x[0]) if '+' not in n]
    joint += ['', '; game variables outside the .ASM blocks (the others are defined where they live)']
    group = None
    for v in VARIABLES:
        if isinstance(v, str):
            group = v; continue
        addr, size, name, comment = v
        if addr in lst.var_placed: continue
        if group: joint += ['', group]; group = None
        size_note = '+%02X ' % (size - 1) if size > 1 else ''
        joint.append('%-14s equ $%04X  ; %s%s' % (name, addr, size_note, comment))
    if extra:
        joint += ['', '; labels not at an instruction boundary or outside the source blocks', '']
        joint += ['%-10s equ $%04X' % (lst.used[a], a) for a in extra]
    open(os.path.join(SRC, 'JOINT.ASM'), 'w', newline='\n').write('\n'.join(joint) + '\n')

    out = ['; Jaskiniowiec (1995, StanBit) - memory image of the game rebuilt from blocks',
           '; Output is a segment file matching game.bin, not a runnable executable.', '',
           '         icl "src/JOINT.ASM"', '']
    h = None
    for name, lo, hi, desc in BLOCKS:
        want = 'h+' if name.endswith('.ASM') else 'h-'
        if want != h:
            out += ['', '         opt %s' % want]; h = want
        line = ('icl' if name.endswith('.ASM') else 'ins') + ' "%s/%s"' % (SRC, name)
        out.append('         %-26s ; $%04X-$%04X %s' % (line, lo, hi, desc))
    open('main.asm', 'w', newline='\n').write('\n'.join(out) + '\n')

    print('blocks:', len(BLOCKS), 'code bytes:', sum(code.values()), 'labels:', len(labels),
          'extra equ labels:', len(extra))


if __name__ == '__main__':
    main()
