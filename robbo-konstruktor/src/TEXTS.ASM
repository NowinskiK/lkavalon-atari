; TEXTS.ASM - editor tables (menu table $9F8E) and texts: screens, messages, element names
; $9F7B-$A808

         org $9F7B

         dta $1F,$04,$6B,$6F,$6C,$6F,$72,$79,$00,$00,$00,$08,$0E,$02,$00,$04 ; 9F7B
         dta $00,$00,$00,$9E,$97,$C9,$97,$8F,$96,$B5,$99,$26,$96,$3A,$A8,$14 ; 9F8B
         dta $98,$3E,$9C,$EB,$9B,$26,$96,$06,$03,$07,$07,$08,$09,$09,$0A,$0B ; 9F9B
         dta $0B,$02,$03,$04,$05,$03,$05,$02,$03,$02,$05,$14,$3C,$64,$8C,$B4 ; 9FAB
;  test planety        strona tytułowa
         dta d' test planety        strona tytu]owa    ' ; 9FBB
;  czyść planetę       kolejność planet
         dta d' czy{[ planet\       kolejno{[ planet   ' ; 9FE3
;  zmiana kolorów      test Robbo
         dta d' zmiana kolor_w      test Robbo         ' ; A00B
;  operacje dyskowe    zapisz Robbo
         dta d' operacje dyskowe    zapisz Robbo       ' ; A033
;  funkcje dodatkowe   funcje podstawowe
         dta d' funkcje dodatkowe   funcje podstawowe  ' ; A05B
;        ·· 00               ·· 00
         dta d'       ',$45,$46,d' 00               ',$47,$48,d' 00        ' ; A083
;                      Robbo Konstruktor
         dta d'                     Robbo Konstruktor  ' ; A0AB
;   /1990 by Avalon           planety: ·-z
         dta d'  /1990 by Avalon           planety: ',$5B,d'-z' ; A0D3
; ła ·-dobra ·-pusta  K: 01  -------------
         dta d']a ',$5A,d'-dobra ',$59,d'-pusta  ',d'K:'*,d' 01  -------------' ; A0FB
; ------------------- R: --  -------------
         dta d'------------------- ',d'R:'*,d' --  -------------' ; A123
; ------------------- funkcje:   zawartość
         dta d'------------------- funkcje:   zawarto{[' ; A14B
;  dysku:   `` zestaw  menu      ---------
         dta d' dysku:   `` zestaw  menu      ---------' ; A173
; -------   `` pusty   wczytaj
         dta d'-------   `` pusty   wczytaj            ' ; A19B
;                      zapisz
         dta d'                     zapisz             ' ; A1C3
;           ·· zestaw  skasuj     01 02 03
         dta d'          ',$45,$46,d' zestaw  skasuj     01 02 03' ; A1EB
;  04 05    ·· pełny  Włoż dyskietkę  na k
         dta d' 04 05    ',$47,$48,d' pe]ny  W]o| dyskietk\  na k' ; A213
; tórej chcesz zapisaćgotowe Robbo. Uwaga:
         dta d't_rej chcesz zapisa[gotowe Robbo. ',d'Uwaga:'* ; A23B
;  zawartość dyskietkizostanie skasowana p
         dta d' zawarto{[ dyskietkizostanie skasowana p' ; A263
; rzed zapisaniem gry! ·· ustaw taśmę w po
         dta d'rzed zapisaniem gry! ',$45,$46,d' ustaw ta{m\ w po' ; A28B
; rządanym miejscu ··  ··       i uruchom
         dta d'rz@danym miejscu ',$49,$4A,d'  ',$47,$48,d'       i uruchom ' ; A2B3
; magnetofon       ··
         dta d'magnetofon       ',$4B,$4C,d'                     ' ; A2DB
; 
         dta d'                    '                  ; A303
         dta $FF                                      ; A317
; klawisz HELP-instrukcja
         dta c'klawisz HELP-instrukcja',$00 ; A318
; strzał: kontynuacja,  ESC: menu
         dta c'strza',$0C,c': kontynuacja,  ESC: menu',$00 ; A330
; 123456   ←→ wybór koloru, ↑↓ menu
         dta c'123456   ',$1E,$1F,c' wyb',$0F,c'r koloru, ',$1C,$1D,c' menu',$00 ; A350
; zmiana koloru: ↑↓ kolor, ←→ jaskrawość
         dta c'zmiana koloru: ',$1C,$1D,c' kolor, ',$1E,$1F,c' jaskrawo',$13,$03,$00 ; A372
;  błąd:  brak robocika!
         dta c' b'*,$8C,$81,c'd: '*,c' brak robocika!',$00 ; A399
;  błąd:  brak kapsuły!
         dta c' b'*,$8C,$81,c'd: '*,c' brak kapsu',$0C,c'y!',$00 ; A3B0
;  błąd:  za dużo robocików!
         dta c' b'*,$8C,$81,c'd: '*,c' za du',$1A,c'o robocik',$0F,c'w!',$00 ; A3C6
;  błąd:  za dużo kapsuł!
         dta c' b'*,$8C,$81,c'd: '*,c' za du',$1A,c'o kapsu',$0C,c'!',$00 ; A3E1
;  błąd:  za dużo śrubek! - max:99
         dta c' b'*,$8C,$81,c'd: '*,c' za du',$1A,c'o ',$13,c'rubek! - max:99',$00 ; A3F9
; wyczyścić planetę?   tak  nie
         dta c'wyczy',$13,c'ci',$03,c' planet',$05,c'?   tak  nie',$00 ; A41A
; zestaw planet:   zapisz  wczytaj
         dta c'zestaw planet:   zapisz  wczytaj',$00 ; A438
;  błąd:  planeta jest pusta!
         dta c' b'*,$8C,$81,c'd: '*,c' planeta jest pusta!',$00 ; A459
; zaznacz planetę, ↓: wstawianie, ↑: menu
         dta c'zaznacz planet',$05,c', ',$1D,c': wstawianie, ',$1C,c': menu',$00 ; A475
; wstaw planetę, ↑: wybieranie, ↓: menu
         dta c'wstaw planet',$05,c', ',$1C,c': wybieranie, ',$1D,c': menu',$00 ; A49D
; włóż dyskietkę z Robbo Konstruktorem
         dta c'w',$0C,$0F,$1A,c' dyskietk',$05,c' z Robbo Konstruktorem',$00 ; A4C3
; wybierz funkcję i numer zestawu planet
         dta c'wybierz funkcj',$05,c' i numer zestawu planet',$00 ; A4E8
;  wczytać zestaw  01?   tak  nie
         dta c' wczyta',$03,c' zestaw  01?   tak  nie',$00 ; A50F
; szukanie początku zestawu planet
         dta c'szukanie pocz',$01,c'tku zestawu planet',$00 ; A52F
; kolejność planet:   ustalona  normalna
         dta c'kolejno',$13,$03,c' planet:   ustalona  normalna',$00 ; A550
;  wszystkie planety są puste! 
         dta c' wszystkie planety s'*,$81,c' puste! '*,$00 ; A577
; ?????????????????????????????
         dta c'?????????????????????????????',$00 ; A595
;  operacja przerwana! 
         dta c' operacja przerwana! '*,$00 ; A5B3
;  ten zestaw planet jest zniszczony! 
         dta c' ten zestaw planet jest zniszczony! '*,$00 ; A5C9
;  dyskietka jest uszkodzona! 
         dta c' dyskietka jest uszkodzona! '*,$00 ; A5EE
;  to nie jest zestaw planet! 
         dta c' to nie jest zestaw planet! '*,$00 ; A60B
; to jest dyskietka z Robbo Konstruktorem!
         dta c'to jest dyskietka z Robbo Konstruktorem!',$00 ; A628
;  błąd numer 100! 
         dta c' b'*,$8C,$81,c'd numer 100! '*,$00 ; A651
; wczytywanie
         dta c'wczytywanie',$00 ; A663
; zapisywanie
         dta c'zapisywanie',$00 ; A66F
; wpisz porządany tekst, ESC: menu
         dta c'wpisz porz',$01,c'dany tekst, ESC: menu',$00 ; A67B
; Robbo
         dta c'Robbo',$00 ; A69C
; śrubka
         dta $13,c'rubka',$00 ; A6A2
; kapsuła
         dta c'kapsu',$0C,c'a',$00 ; A6A9
; skrzynka
         dta c'skrzynka',$00 ; A6B1
; drzwi
         dta c'drzwi',$00 ; A6BA
; skrzynka na kółkach
         dta c'skrzynka na k',$0F,$0C,c'kach',$00 ; A6C0
; amunicja
         dta c'amunicja',$00 ; A6D4
; gruz
         dta c'gruz',$00 ; A6DD
; bomba
         dta c'bomba',$00 ; A6E2
; magnes
         dta c'magnes',$00 ; A6E8
; oczy
         dta c'oczy',$00 ; A6EF
; magnes
         dta c'magnes',$00 ; A6F4
; murek
         dta c'murek',$00 ; A6FB
; klucz
         dta c'klucz',$00 ; A701
; nicość
         dta c'nico',$13,$03,$00 ; A707
; gumka
         dta c'gumka',$00 ; A70E
; stworek leworęczny
         dta c'stworek lewor',$05,c'czny',$00 ; A714
; stworek praworęczny
         dta c'stworek prawor',$05,c'czny',$00 ; A727
; niespodzianka
         dta c'niespodzianka',$00 ; A73B
; działko obrotowe
         dta c'dzia',$0C,c'ko obrotowe',$00 ; A749
; działko ruchome
         dta c'dzia',$0C,c'ko ruchome',$00 ; A75A
; zmiana dział, nietoperzy  i teleportacji
         dta c'zmiana dzia',$0C,c', nietoperzy  i teleportacji',$00 ; A76A
; nietoperz strzelający
         dta c'nietoperz strzelaj',$01,c'cy',$00 ; A793
; nietoperz
         dta c'nietoperz',$00 ; A7A9
; działko
         dta c'dzia',$0C,c'ko',$00 ; A7B3
; laser
         dta c'laser',$00 ; A7BB
; blaster
         dta c'blaster',$00 ; A7C1
; teleportacja 
         dta c'teleportacja ' ; A7C9
         dta $06,$00                                  ; A7D6
;  wczytać zapisaćskasowaćkasetowe
         dta c' wczyta',$03,c' zapisa',$03,c'skasowa',$03,c'kasetowe' ; A7D8
         dta $80,$8F,$AD,$FE,$FF,$00,$15,$16,$17,$18,$19,$1A ; A7F8
; Robbo
         dta c'Robbo' ; A804
