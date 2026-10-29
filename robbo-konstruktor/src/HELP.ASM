; HELP.ASM - help text: 16 pages in Polish (HELP key), packed: bit 7 = add a space
; $0C6D-$1DD0

         org $0C6D

         dta $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$79,$0C,$80,$01 ; 0C6D
; Mamy zaszczyt przedstawić pierwszy szeroko dostępny program
         dta c'Mamy zaszczyt przedstawi',$03,c' pierwsz',c'y'*,c'szeroko dost',$05,c'pny program ' ; 0C7B
; użytkowy firmy Avalon - Robbo Konstruktor.   Pozwala on
         dta c'u',$1A,c'ytkow',c'y'*,c'firmy Avalon - Robbo Konstruktor',c'. '*,c'Pozwala on ' ; 0CB6
; na tworzenie i testowanie dowolnych planet, na których mały
         dta c'na tworzenie i testowani',c'e'*,c'dowolnych planet, na kt',$0F,c'rych ma',$0C,c'y'* ; 0CEB
; robocik przeżyje nowe przygody.    Przy pomocy Konstruktora
         dta c'robocik prze',$1A,c'yje nowe przygody.',c'  '*,c'Przy pomocy Konstruktora ' ; 0D25
; możesz też zapisać na (taśmie/dyskietce) samodzielnie działającą,
         dta c'mo',$1A,c'esz te',$9A,c'zapisa',$03,c' na (ta',$13,c'mie/dyskietce) samodzielni',c'e'*,c'dzia',$0C,c'aj',$01,c'c',$01,c', ' ; 0D5F
; Twoją wersję gry "Robbo".   Używaj joysticka lub klawiszy
         dta c'Twoj',$01,c' wersj',$05,c' gry ',$14,c'Robbo',$14,c'. '*,c'U',$1A,c'ywaj joysticka lub klawiszy ' ; 0D9F
; ←→↑↓   Klawisze: spacja, RETURN i SHIFT działają jak strzał
         dta $1E,$1F,$1C,$9D,c' '*,c'Klawisze: spacja, RETURN i SHIF',c'T'*,c'dzia',$0C,c'aj',$01,c' jak strza',$0C,c' ' ; 0DD7
; w joysticku.
         dta c'w joysticku.' ; 0E10

* help page 1 --------------------------------------------
         dta $00,$01                               ; 0E1C
; Podczas pracy w każdej chwili możesz otrzymać podpowiedż
         dta c'Podczas pracy w ka',$1A,c'dej chwili mo',$1A,c'es',c'z'*,c'otrzyma',$03,c' podpowied',$1A,c' ' ; 0E1E
; po wciśnięciu klawisza HELP.   Powinieneś również zwracać
         dta c'po wci',$13,c'ni',$05,c'ci',c'u'*,c'klawisza HELP',c'. '*,c'Powiniene',$13,c' r',$0F,c'wnie',$1A,c' zwraca',$03,c' ' ; 0E56
; uwagę na komunikaty pojawiające się w dolnej części ekranu.
         dta c'uwag',$85,c'na komunikaty pojawiaj',$01,c'ce si',$85,c'w dolnej cz',$05,$13,c'ci ekranu',c'.'* ; 0E8D
;     Nasz nowy adres:   2 Laboratorium Komputerowe  Avalon
         dta c'  '*,c'Nasz nowy adres',c': 2'*,c'Laboratorium Komputerowe  Avalo',c'n'* ; 0EC6
; 8 skrytka pocztowa 702  9 2 35-959 Rzeszów   5 życzymy przyjemnej
         dta c'8'*,c'skrytka pocztowa 702',c' 92'*,c'35-959 Rzesz',$0F,c'w 5'*,$1A,c'yczymy przyjemnej ' ; 0EFA
; zabawy!
         dta c'zabawy!' ; 0F35

* help page 2 --------------------------------------------
         dta $00,$02                               ; 0F3C
; "Menu główne:"   Zawiera zestaw funkcji, których nazwy są
         dta $14,c'Menu g',$0C,$0F,c'wne:',$94,c' '*,c'Zawiera zestaw funkcji, kt',$0F,c'ryc',c'h'*,c'nazwy s',$01,c' ' ; 0F3E
; widoczne w dolnej części ekranu. Możesz wybrać jedną z nich
         dta c'widoczne w dolnej cz',$05,$13,c'c',c'i'*,c'ekranu. Mo',$1A,c'esz wybra',$03,c' jedn',$01,c' z nic',c'h'* ; 0F75
; ustawiając kursor na odpowiedniej pozycji przy pomocy ↑↓
         dta c'ustawiaj',$01,c'c kursor na odpowiednie',c'j'*,c'pozycji przy pomocy ',$1C,$1D,c' ' ; 0FAF
; i wciskając strzał. Opisy działania funkcji znajdziesz na
         dta c'i wciskaj',$01,c'c'*,c'strza',$0C,c'. Opisy dzia',$0C,c'ania funkcj',c'i'*,c'znajdziesz na ' ; 0FE7
; następnych stronach.   Za pomocą ←→ możesz wybrać planetę,
         dta c'nast',$05,c'pnych stronach',c'. '*,c'Za pomoc',$01,c' ',$1E,$1F,c' mo',$1A,c'esz wybra',$03,c' planet',$05,c','* ; 101F
; którą będziesz następnie układał.   Aby przejść do edytora
         dta c'kt',$0F,c'r',$01,c' b',$05,c'dziesz nast',$05,c'pnie uk',$0C,c'ada',$0C,c'. '*,c'Aby przej',$13,$03,c' do edytora ' ; 1057
; wciśnij ESC lub ↑ gdy kursor wskazuje najwyżej umieszczoną
         dta c'wci',$13,c'nij ES',c'C'*,c'lub ',$1C,c' gdy kursor wskazuje najwy',$1A,c'e',c'j'*,c'umieszczon',$01,c' ' ; 1090
; nazwę funkcji.
         dta c'nazw',$05,c' funkcji.' ; 10C9

* help page 3 --------------------------------------------
         dta $00,$03                               ; 10D7
; "Test planety:"   Umożliwia przetestowanie aktualnej planety.
         dta $14,c'Test planety:',$94,c' '*,c'Umo',$1A,c'liwia przetestowanie aktualne',c'j'*,c'planety',c'.'* ; 10D9
;   Wykrycie błędów uniemożliwiających poprawne działanie
         dta c' '*,c'Wykrycie b',$0C,$05,c'd',$0F,c'w uniemo',$1A,c'liwiaj',$01,c'cyc',c'h'*,c'poprawne dzia',$0C,c'anie ' ; 1113
; gry zostanie zasygnalizowane komunikatem.
         dta c'gry zostani',c'e'*,c'zasygnalizowane komunikatem.' ; 1149

* help page 4 --------------------------------------------
         dta $00,$04                               ; 1171
; "Czyść planetę:"   Twierdząca odpowiedż na pytanie poprzedzające
         dta $14,c'Czy',$13,$03,c' planet',$05,c':',$94,c' '*,c'Twierdz',$01,c'ca odpowied',$1A,c' na pytani',c'e'*,c'poprzedzaj',$01,c'ce ' ; 1173
; wykonanie funkcji spowoduje wyczyszczenie planety i przywrócenie
         dta c'wykonanie funkcj',c'i'*,c'spowoduje wyczyszczenie planet',c'y'*,c'i przywr',$0F,c'cenie ' ; 11B1
; pierwotnych kolorów.   Zawartości wyczyszczonej planety
         dta c'pierwotnych kolor',$0F,c'w',c'. '*,c'Zawarto',$13,c'ci wyczyszczonej planet',c'y'* ; 11F0
; nie możesz odzyskać!
         dta c'nie mo',$1A,c'esz odzyska',$03,c'!' ; 1225

* help page 5 --------------------------------------------
         dta $00,$05                               ; 1239
; "Zmiana kolorów:"   Pozwala zmieniać kolory elementów planety.
         dta $14,c'Zmiana kolor',$0F,c'w:',$94,c' '*,c'Pozwala zmienia',$03,c' kolory element',$0F,c'w'*,c'planety. ' ; 123B
; Możesz wskazać kursorem dowolny kolor i wcisnąć strzał aby
         dta c'Mo',$1A,c'esz wskaza',$03,c' kursore',c'm'*,c'dowolny kolor i wcisn',$01,$03,c' strza',$8C,c'aby ' ; 1277
; dokonać jego zmiany.   "Uwaga:" jeżeli używasz monitora
         dta c'dokona',$03,c' jego zmiany',c'. '*,$14,c'Uwaga:',$14,c' je',$1A,c'eli u',$1A,c'ywasz monitor',c'a'* ; 12B0
; monochromatycznego dostrzeżesz jedynie zmiany jaskrawości!
         dta c'monochromatycznego dostrze',$1A,c'es',c'z'*,c'jedynie zmiany jaskrawo',$13,c'ci!' ; 12E5

* help page 6 --------------------------------------------
         dta $00,$06                               ; 131E
; "Operacje (kasetowe/dyskowe):"   Funkcja ta umożliwia zapisanie
         dta $14,c'Operacje (kasetowe/dyskowe):',$94,c' '*,c'Funkcja ta umo',$1A,c'liwia zapisani',c'e'* ; 1320
; lub wczytanie zestawu planet z (taśmy magnetofonowej. /dyskietki
         dta c'lub wczytanie zestawu plane',c't'*,c'z (ta',$13,c'my magnetofonowej',c'.'*,c'/dyskietki ' ; 135D
; z Robbo Konstruktorem, a także na skasowanie niepotrzebnego
         dta c'z Robbo Konstruktorem',c','*,c'a tak',$1A,c'e na skasowanie niepotrzebneg',c'o'* ; 139C
; zestawu. Zawartość dyskietki jest wyświetlona w centralnej
         dta c'zestawu',c'.'*,c'Zawarto',$13,$03,c' dyskietki jest wy',$13,c'wietlon',c'a'*,c'w centralnej ' ; 13D6
; części menu. Dyskietka może zawierać 5 zestawów. Powyższe
         dta c'cz',$05,$13,c'ci menu',c'.'*,c'Dyskietka mo',$1A,c'e zawiera',$03,c' 5 zestaw',$0F,c'w',c'.'*,c'Powy',$1A,c'sze ' ; 140F
; operacje można wykonać na każdym z nich. )  Zapisany zestaw
         dta c'operacje mo',$1A,c'na wykona',$83,c'na ka',$1A,c'dym z nich',c'.'*,c')',c' '*,c'Zapisany zestaw ' ; 1447
; planet zawiera również tekst strony tytułowej i końcowej
         dta c'planet zawier',c'a'*,c'r',$0F,c'wnie',$1A,c' tekst strony tytu',$0C,c'owe',c'j'*,c'i ko',$0E,c'cowej ' ; 1480
; oraz kolejność planet.
         dta c'oraz kolejno',$13,$03,c' planet.' ; 14B7

* help page 7 --------------------------------------------
         dta $00,$07                               ; 14CD
; "Funkcje dodatkowe:"   Użycie tej funkcji powoduje wyświetlenie
         dta $14,c'Funkcje dodatkowe:',$94,c' '*,c'U',$1A,c'ycie tej funkcji powoduj',c'e'*,c'wy',$13,c'wietlenie ' ; 14CF
; zestawu funkcji dodatkowych.
         dta c'zestawu funkcj',c'i'*,c'dodatkowych.' ; 150C

* help page 8 --------------------------------------------
         dta $00,$08                               ; 1527
; "Strona tytułowa:"   Pozwala na zredagowanie tekstów: początkowego
         dta $14,c'Strona tytu',$0C,c'owa:',$94,c' '*,c'Pozwala na zredagowanie tekst',$0F,c'w',c':'*,c'pocz',$01,c'tkowego ' ; 1529
; i gratulacyjnego. Będą się one pojawiały w Twojej wersji
         dta c'i gratulacyjnego',c'.'*,c'B',$05,c'd',$01,c' si',$05,c' one pojawia',$0C,c'y w Twoje',c'j'*,c'wersji ' ; 1569
; gry Robbo.   Wciskając klawisze: a,c,e,l,n,o,s,z wraz z
         dta c'gry Robbo',c'. '*,c'Wciskaj',$01,c'c klawisze: a,c,e,l,n,o,s,',c'z'*,c'wraz z ' ; 15A0
; klawiszem CONTROL możesz uzyskać litery:     ą,ć,ę,ł,ń,ó,ś,ż.
         dta c'klawiszem CONTROL mo',$1A,c'es',c'z'*,c'uzyska',$03,c' litery:     ',$01,c',',$03,c',',$05,c',',$0C,c',',$0E,c',',$0F,c',',$13,c',',$1A,c'.'* ; 15D5
;   Dużymi literami możesz pisać wciskając odpowiednie klawisze
         dta c' '*,c'Du',$1A,c'ymi literami mo',$1A,c'esz pisa',$83,c'wciskaj',$01,c'c odpowiednie klawisz',c'e'* ; 1611
; wraz z klawiszem SHIFT.
         dta c'wraz z klawiszem SHIFT.' ; 164C

* help page 9 --------------------------------------------
         dta $00,$09                               ; 1663
; "Kolejność planet:"   Umożliwia ustalenie kolejności planet
         dta $14,c'Kolejno',$13,$03,c' planet:',$94,c' '*,c'Umo',$1A,c'liwia ustalenie kolejno',$13,c'c',c'i'*,c'planet ' ; 1665
; w grze Robbo. Użycie tej funkcji NIE JEST KONIECZNE! Jeżeli
         dta c'w grze Robbo. U',$1A,c'yci',c'e'*,c'tej funkcji NIE JEST KONIECZNE',c'!'*,c'Je',$1A,c'eli ' ; 169E
; jej nie wykorzystasz, planety będą ułożone w takiej kolejności,
         dta c'jej nie wykorzystasz, planet',c'y'*,c'b',$05,c'd',$01,c' u',$0C,c'o',$1A,c'one w takiej kolejno',$13,c'ci',c','* ; 16D8
; jak w Robbo Konstruktorze.   K: oznacza kolejność w Konstruktorze
         dta c'jak w Robbo Konstruktorze',c'. '*,c'K: oznacza kolejno',$13,$03,c' w Konstruktorz',c'e'* ; 1716
; R: oznacza kolejność w Robbo   Przy pomocy ←→ i strzału
         dta c'R: oznacza kolejno',$13,$03,c' w Robb',c'o '*,c'Przy pomocy ',$1E,$1F,c' i strza',$0C,c'u ' ; 1755
; możesz wybrać planetę z R: i wstawić ją w dowolne miejsce
         dta c'mo',$1A,c'es',c'z'*,c'wybra',$03,c' planet',$05,c' z R: i wstawi',$03,c' j',$81,c'w dowolne miejsce ' ; 178B
; w K:. Na wybranej planecie pojawi się trójkącik.
         dta c'w K:. Na wybrane',c'j'*,c'planecie pojawi si',$05,c' tr',$0F,c'jk',$01,c'cik.' ; 17C3

* help page 10 --------------------------------------------
         dta $00,$0A                               ; 17F2
; "Test Robbo:"   Umożliwia przetestowanie Twojej wersji gry.
         dta $14,c'Test Robbo:',$94,c' '*,c'Umo',$1A,c'liwia przetestowanie Twoje',c'j'*,c'wersji gry',c'.'* ; 17F4
;   Wykrycie błędów uniemożliwiających jej poprawne działanie
         dta c' '*,c'Wykrycie b',$0C,$05,c'd',$0F,c'w uniemo',$1A,c'liwiaj',$01,c'cyc',c'h'*,c'jej poprawne dzia',$0C,c'anie ' ; 182C
; zostanie zasygnalizowane komunikatem. Planeta zawierająca
         dta c'zostani',c'e'*,c'zasygnalizowane komunikatem',c'.'*,c'Planeta zawieraj',$01,c'ca ' ; 1866
; błąd zostanie pokazana na ekranie.
         dta c'b',$0C,$01,c'd zostani',c'e'*,c'pokazana na ekranie.' ; 189E

* help page 11 --------------------------------------------
         dta $00,$0B                               ; 18BF
; "Zapisz Robbo:"   Przy pomocy tej funkcji możesz zapisać
         dta $14,c'Zapisz Robbo:',$94,c' '*,c'Przy pomocy tej funkcji mo',$1A,c'es',c'z'*,c'zapisa',$03,c' ' ; 18C1
; na (taśmie/dyskietce)  samodzielnie działającą grę Robbo.
         dta c'na (ta',$13,c'mie/dyskietce)',c' '*,c'samodzielnie dzia',$0C,c'aj',$01,c'c',$01,c' gr',$05,c' Robbo',c'.'* ; 18F7
;   Możesz ją wczytać przez wciśnięcie (START /)OPTION i włączenie
         dta c' '*,c'Mo',$1A,c'esz j',$01,c' wczyta',$03,c' przez wci',$13,c'ni',$05,c'ci',c'e'*,c'(START /)OPTION i w',$0C,$01,c'czenie ' ; 192F
; komputera.   Wykrycie błędów uniemożliwiających jej poprawne
         dta c'komputera',c'. '*,c'Wykrycie b',$0C,$05,c'd',$0F,c'w uniemo',$1A,c'liwiaj',$01,c'cyc',c'h'*,c'jej poprawne ' ; 196E
; działanie zostanie zasygnalizowane komunikatem. Planeta
         dta c'dzia',$0C,c'anie zostani',c'e'*,c'zasygnalizowane komunikatem',c'.'*,c'Planeta ' ; 19A8
; zawierająca błąd zostanie pokazana na ekranie.
         dta c'zawieraj',$01,c'ca b',$0C,$01,c'd zostani',c'e'*,c'pokazana na ekranie.' ; 19DE

* help page 12 --------------------------------------------
         dta $00,$0C                               ; 1A0B
; "Funkcje podstawowe:"   Użycie tej funkcji powoduje wyświetlenie
         dta $14,c'Funkcje podstawowe:',$94,c' '*,c'U',$1A,c'ycie tej funkcji powoduj',c'e'*,c'wy',$13,c'wietlenie ' ; 1A0D
; zestawu funkcji podstawowych.
         dta c'zestawu funkcj',c'i'*,c'podstawowych.' ; 1A4B

* help page 13 --------------------------------------------
         dta $00,$0D                               ; 1A67
; "Zbiór elementów składowych planety:"   Jest on widoczny
         dta $14,c'Zbi',$0F,c'r element',$0F,c'w sk',$0C,c'adowych planety:',$94,c' '*,c'Jest on widoczny ' ; 1A69
; w prawej części ekranu. Możesz wybrać element, który chcesz
         dta c'w prawej cz',$05,$13,c'c',c'i'*,c'ekranu. Mo',$1A,c'esz wybra',$03,c' element',c','*,c'kt',$0F,c'ry chcesz ' ; 1AA0
; umieścić na planecie przez wskazanie go kursorem i wciśnięcie
         dta c'umie',$13,c'ci',$03,c' na planeci',c'e'*,c'przez wskazanie go kursore',c'm'*,c'i wci',$13,c'ni',$05,c'cie ' ; 1ADA
; strzału. Wybrany obiekt zacznie migać.   Powtórne wybranie
         dta c'strza',$0C,c'u. Wybrany obiek',c't'*,c'zacznie miga',$03,c'. '*,c'Powt',$0F,c'rne wybranie ' ; 1B16
; murka spowoduje zmianę jego kształtu.   Aby wrócić do menu
         dta c'murka spowoduj',c'e'*,c'zmian',$05,c' jego kszta',$0C,c'tu',c'. '*,c'Aby wr',$0F,c'ci',$03,c' do menu ' ; 1B4E
; możesz wcisnąć klawisz ESC lub ↓ gdy kursor znajduje się
         dta c'mo',$1A,c'esz wcisn',$01,$83,c'klawisz ESC lub ',$1D,c' gdy kurso',c'r'*,c'znajduje si',$05,c' ' ; 1B86
; w ostatniej linii zbioru elementów.
         dta c'w ostatniej lini',c'i'*,c'zbioru element',$0F,c'w.' ; 1BBD

* help page 14 --------------------------------------------
         dta $00,$0E                               ; 1BDF
; "Edytor planety:"   Służy do układania planet. Uprzednio
         dta $14,c'Edytor planety:',$94,c' '*,c'S',$0C,c'u',$1A,c'y do uk',$0C,c'adania planet. Uprzedni',c'o'* ; 1BE1
; zaznaczony element możesz umieścić na pozycji wskazywanej
         dta c'zaznaczony element mo',$1A,c'esz umie',$13,c'ci',$83,c'na pozycji wskazywanej ' ; 1C17
; przez kursor wciskając strzał. Ponowne wstawienie elementu
         dta c'przez kurso',c'r'*,c'wciskaj',$01,c'c strza',$0C,c'. Ponowne wstawieni',c'e'*,c'elementu ' ; 1C50
; w tym samym miejscu spowoduje jego usunięcie.   Aby wrócić
         dta c'w tym samym miejsc',c'u'*,c'spowoduje jego usuni',$05,c'cie',c'. '*,c'Aby wr',$0F,c'ci',$03,c' ' ; 1C89
; do menu wcisnij ESC.
         dta c'do menu wcisnij ESC.' ; 1CC1

* help page 15 --------------------------------------------
         dta $00,$0F                               ; 1CD5
;     Program Robbo Konstruktor został przetestowany w firmie
         dta c'  '*,c'Program Robbo Konstruktor zosta',$8C,c'przetestowany w firmie ' ; 1CD7
; Avalon.   Jeżeli Twoja wersja wykazuje błędy uniemożliwiające
         dta c'Avalon',c'. '*,c'Je',$1A,c'eli Twoja wersja wykazuje b',$0C,$05,c'd',c'y'*,c'uniemo',$1A,c'liwiaj',$01,c'ce ' ; 1D10
; jej używanie, jest nielegalną kopią!     Poprawnie działający
         dta c'jej u',$1A,c'ywanie',c','*,c'jest nielegaln',$01,c' kopi',$01,c'!  '*,c'Poprawnie dzia',$0C,c'aj',$01,c'cy ' ; 1D4B
; program, jak również inne gry Avalonu możesz nabyć wysyłkowo
         dta c'program',c','*,c'jak r',$0F,c'wnie',$1A,c' inne gry Avalon',c'u'*,c'mo',$1A,c'esz naby',$03,c' wysy',$0C,c'kow',c'o'* ; 1D85
; w naszej firmie.? ?
         dta c'w naszej firmie.',$80,$00 ; 1DBF
