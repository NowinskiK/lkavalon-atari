; JOINT.ASM - common labels

; Atari OS and hardware

BRKKEY   equ $0011
RTCLOK   equ $0012
ATRACT   equ $004D
SAVMSC   equ $0058
VDSLST   equ $0200
CDTMV3   equ $021C
CDTMV4   equ $021E
VVBLKI   equ $0222
VVBLKD   equ $0224
SDMCTL   equ $022F
SDLSTL   equ $0230
SDLSTH   equ $0231
COLDST   equ $0244
GPRIOR   equ $026F
STICK0   equ $0278
STRIG0   equ $0284
PCOLR0   equ $02C0
PCOLR3   equ $02C3
COLOR0   equ $02C4
COLOR1   equ $02C5
COLOR2   equ $02C6
COLOR3   equ $02C7
COLOR4   equ $02C8
KRPDEL   equ $02D9
KEYREP   equ $02DA
RUNAD    equ $02E0
INITAD   equ $02E2
DVSTAT   equ $02EA
CRSINH   equ $02F0
CHBAS    equ $02F4
CH       equ $02FC
DDEVIC   equ $0300
DUNIT    equ $0301
DCOMND   equ $0302
DSTATS   equ $0303
DBUFLO   equ $0304
DBUFHI   equ $0305
DTIMLO   equ $0306
DBYTLO   equ $0308
DBYTHI   equ $0309
DAUX1    equ $030A
DAUX2    equ $030B
HPOSP0   equ $D000
HPOSP1   equ $D001
HPOSP2   equ $D002
HPOSP3   equ $D003
HPOSM0   equ $D004
SIZEP0   equ $D008
SIZEP1   equ $D009
SIZEM    equ $D00C
GRAFP1   equ $D00E
TRIG0    equ $D010
TRIG1    equ $D011
COLPM0   equ $D012
COLPM1   equ $D013
COLPM2   equ $D014
COLPM3   equ $D015
COLPF0   equ $D016
COLPF1   equ $D017
COLPF2   equ $D018
COLPF3   equ $D019
COLBK    equ $D01A
PRIOR    equ $D01B
GRACTL   equ $D01D
HITCLR   equ $D01E
CONSOL   equ $D01F
AUDF1    equ $D200
AUDC1    equ $D201
AUDCTL   equ $D208
KBCODE   equ $D209
RANDOM   equ $D20A
IRQEN    equ $D20E
SKCTL    equ $D20F
PORTA    equ $D300
PORTB    equ $D301
DMACTL   equ $D400
DLISTL   equ $D402
DLISTH   equ $D403
VSCROL   equ $D405
PMBASE   equ $D407
CHBASE   equ $D409
WSYNC    equ $D40A
VCOUNT   equ $D40B
NMIEN    equ $D40E
NMIST    equ $D40F
DSKINV   equ $E453
CIOV     equ $E456
SIOV     equ $E459
SETVBV   equ $E45C
SYSVBV   equ $E45F
XITVBV   equ $E462
WARMSV   equ $E474
COLDSV   equ $E477

; game variables outside the .ASM blocks (the others are defined where they live)

* zero page - engine (Robbo layout, names from robbo/d1/R1.ASM) ---
ADDR           equ $0080  ; +01 pointer
SCRA           equ $0082  ; +01 screen address
CHAD           equ $0084  ; +01 pointer (Robbo CHAD)
FADR           equ $0086  ; +01 screen address of Robbo, the scroll follows it (Robbo FADR)
X              equ $0092  ; current cell X
Y              equ $0093  ; current cell Y
X1             equ $0094  ; cell X (second)
Y1             equ $0095  ; cell Y (second)
FX             equ $0096  ; Robbo FX
FY             equ $0097  ; Robbo FY
LM             equ $0098  ; Robbo LM
VSF            equ $0099  ; vertical scroll, fine
VSC            equ $009A  ; vertical scroll, coarse
TELE           equ $009B  ; teleport (Robbo TELE)
FAC            equ $009C  ; Robbo FAC (facing / state)
CNUM           equ $009D  ; cave number
KEYS           equ $009E  ; keys collected
LIVS           equ $009F  ; lives
ZEBR           equ $00A0  ; collected ("zebrane") - screws
LSTE           equ $00A1  ; Robbo LSTE
NABO           equ $00A2  ; ammunition ("naboje")
DEMO           equ $00A3  ; demo mode flag
SCOR           equ $00A4  ; +02 score, BCD
HLP            equ $00A7  ; temporary (Robbo HLP)
RUCH           equ $00A8  ; move ("ruch")
TOLE           equ $00AA  ; Robbo TOLE

* zero page - sound (Robbo layout, names from robbo/d1/R1.ASM SOUND_) ---
_PNTR          equ $00F0  ; +03 position in the sound of each channel
_ADDR          equ $00F4  ; +07 address of the sound of each channel (2 bytes per channel)
_SCRA          equ $00FC  ; +01 sound pointer
_HLP           equ $00FE  ; +01 temporary: AUDF / AUDC value

* zero page - editor temporaries: each routine uses them in its own way ---
PTR1           equ $00B0  ; +01 pointer: target (help screen line, board cell for PUT_CELL, display)
PTR2           equ $00B2  ; +01 pointer: source (help text, message, board cell from CELL_ADDR, title text)
TMP1           equ $00B4  ; temporary (element code; title editor: page 0 / 1)
TMP2           equ $00B5  ; temporary (title editor: cursor position in the line)
TMP3           equ $00B6  ; temporary / counter (help: lines, digits: tens)
TMP4           equ $00B7  ; temporary / counter (help: lines, digits: units)

* zero page - tape / disk ------
IO_PTR         equ $00B8  ; +01 address of the next byte of a segment (IO_DIR: slot bit mask)
IO_END         equ $00BA  ; +01 last address of the segment
IO_POS         equ $00BF  ; next byte in the sector buffer IO_BUF

* zero page - title page -------
TP_SCR         equ $00E0  ; +01 logo: screen address of the letter column
TP_HDR         equ $00E2  ; +01 planet being searched / played: its data page (header at +$F0 of the second page)
TP_LETTER      equ $00E4  ; logo: letter 4..0 of "ROBBO"
TP_TMP         equ $00E6  ; +01 temporary: planet code, logo pixels doubled, colour offset
TP_TIMER       equ $00E8  ; +01 frame counter (demo after 8 x 256 frames)
TP_NUM         equ $00EA  ; planet number shown
TP_LIVES       equ $00EB  ; lives left (8 at the start)
TP_POS         equ $00EC  ; position in PLAY_ORDER
TP_HUE         equ $00ED  ; random hue of the logo colour bars (every 256 frames)

* title page data --------------
PLAY_ORDER     equ $39E0  ; +1F planets of the saved game / test Robbo in play order (copied from ORDER), bit 7 = play
TP_TEXT_A      equ $3A00  ; +FF title page text A: start
TP_TEXT_B      equ $3B00  ; +FF title page text B: congratulations at the end

* zero page - editor -----------
FRAMES         equ $00C4  ; editor frame counter (main loop)
CUR_X          equ $00C5  ; cursor column (0-15 board, 17-19 palette)
CUR_Y          equ $00C6  ; cursor row (0-9)
WIN_TOP        equ $00C7  ; first board row shown in the 10-row window
SCR_PAGE       equ $00C8  ; screen buffer being drawn ($B6 / $B8)
PAL_SEL        equ $00C9  ; selected palette row
ED_FLAGS       equ $00CA  ; editor flags (bit 7 tested by the cursor and the redraw)
MENU_POS       equ $00CB  ; main menu: row, bit 7 = page (basic / additional functions)
PLANET         equ $00CD  ; current planet (0-31), bit 7 = none
HELP_PAGE      equ $00CE  ; help page shown by the HELP key (2 = menu, 3-12 = functions)
PANEL_ST       equ $00CF  ; lower screen panel state (PANEL)

* engine variables (Konstruktor) ---
PNUM           equ $00A9  ; planet number shown in the info line
BOARD          equ $BE00  ; +1EF the planet being played: 16 x 31 cells (TSTTAB rows)
BOARD_HDR      equ $BFF0  ; +07 its header: wall type, screws, COLOR0-4, PCOLR3
TSTTAB         equ $23FD  ; +3F address of each board row: 32 low bytes, then 32 high bytes (Robbo tsttab)
FONT           equ $3C00  ; +3FF board font (Robbo FONT)

* OS (XL/XE ROM) ---------------
OS_BELL        equ $F556  ; XL/XE OS: buzzer - the key click ($F983) 33 times; not an entry in OS-B or AltirraOS
OS_KEYTAB      equ $FB51  ; XL/XE OS: key code -> ATASCII table (KEYDEF points here); not in OS-B or AltirraOS

* boot loader (sectors 1-3) ----
BOOT_ADR       equ $0043  ; +01 address the next byte of the segment goes to
BOOT_END       equ $0045  ; +01 last address of the segment
BOOT_BCNT      equ $0047  ; data bytes in the sector (DOS 2 byte 127)
BOOT_BPOS      equ $0048  ; next byte in the sector buffer
SEC_LINKH      equ $03FE  ; SEC_LINKH,x with X = 127: sector byte 125, file number and next sector high bits
SEC_LINKL      equ $03FF  ; SEC_LINKL,x with X = 127: sector byte 126, next sector low byte
SEC_BUF        equ $0400  ; sector buffer (DBUF, 128 bytes), a DOS 2 sector: 125 data bytes and the link

* screen memory ----------------
SCREEN         equ $B600  ; screen: editor screen A (board window 10 x 40), title logo, help page
SCREEN_B       equ $B800  ; editor screen B (drawn while A is shown, then swapped)
PANEL_LH       equ $BBEC  ; PANEL_TXT-20: PANEL_LH,x is the left half of the row whose right half is PANEL_TXT,x
PANEL_TXT      equ $BC00  ; +C7 lower panel, 5 text lines of 40 characters
STATUS         equ $BCC8  ; +27 status line: messages, "tak nie" question
GR_BLANK       equ $BD00  ; empty graphics lines (mode F, $BD00-$BDFF without GR_LINE)
GR_LINE        equ $BD50  ; +27 dotted line ($55) between the parts of the screen
BOARD_T_7C     equ $43E0  ; +1F characters $7C-$7F of the upper board font: the wall of the planet (by its header), the selected element in the cursor frame
BOARD_B_7C     equ $47E0  ; +1F the same in the lower board font

* planets ----------------------
PLANET_STATE   equ $39A0  ; +1F status of the 32 planets: 0 empty, bit 7 = bad (low bits = error message), else good
ORDER          equ $39C0  ; +1F planet order set in "kolejnosc planet": planet number, bit 7 = in the game
PLANET_HDR     equ $51F0  ; +07 header of planet 0 (colours); the operand high byte is patched for planet n: +n x $200

* editor screen and input ------
DLI_ROW        equ $0000  ; line counter of ED_DLI: odd / even rows use the lower / upper board font

* tape / disk ------------------
IO_BUF         equ $9431  ; +7F sector buffer of the tape / disk routines
