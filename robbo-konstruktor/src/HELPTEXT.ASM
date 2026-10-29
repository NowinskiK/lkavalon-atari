; HELPTEXT.ASM - help text: 16 pages in Polish (HELP key), one screen line per dta: bit 7 = last character of the line
; $0C6D-$1DD0

         org $0C6D

HLP_SAVE         dta $00,$00,$00,$00,$00,$00,$00,$00  ; 0C6D PTR1 ... TMP4 saved while the help is shown
HLP_TAPE         dta $00                              ; 0C75 DISK_SLOTS on entry: negative = no disk, the text shows the tape variants
HLP_INV          dta $00                              ; 0C76 inverse mask of the characters ($14 in the text toggles it)
HLP_TOP          dta $79,$0C                          ; 0C77 address of the text of the page shown
         dta $80,$01                                  ; 0C79
; Mamy zaszczyt przedstawić pierwszy
         dta c'Mamy zaszczyt przedstawi',$03,c' pierwsz',c'y'* ; 0C7B
; szeroko dostępny program użytkowy
         dta c'szeroko dost',$05,c'pny program u',$1A,c'ytkow',c'y'* ; 0C9D
; firmy Avalon - Robbo Konstruktor.
         dta c'firmy Avalon - Robbo Konstruktor',c'.'* ; 0CBE
;
         dta c' '* ; 0CDF
; Pozwala on na tworzenie i testowanie
         dta c'Pozwala on na tworzenie i testowani',c'e'* ; 0CE0
; dowolnych planet, na których mały
         dta c'dowolnych planet, na kt',$0F,c'rych ma',$0C,c'y'* ; 0D04
; robocik przeżyje nowe przygody.
         dta c'robocik prze',$1A,c'yje nowe przygody.',c' '* ; 0D25
;
         dta c' '* ; 0D45
; Przy pomocy Konstruktora możesz też
         dta c'Przy pomocy Konstruktora mo',$1A,c'esz te',$9A ; 0D46
; zapisać na (taśmie/dyskietce) samodzielnie
         dta c'zapisa',$03,c' na (ta',$13,c'mie/dyskietce) samodzielni',c'e'* ; 0D69
; działającą, Twoją wersję gry Robbo.
         dta c'dzia',$0C,c'aj',$01,c'c',$01,c', Twoj',$01,c' wersj',$05,c' gry ',$14,c'Robbo',$14,c'.'* ; 0D93
;
         dta c' '* ; 0DB8
; Używaj joysticka lub klawiszy ←→↑↓
         dta c'U',$1A,c'ywaj joysticka lub klawiszy ',$1E,$1F,$1C,$9D ; 0DB9
;
         dta c' '* ; 0DDB
; Klawisze: spacja, RETURN i SHIFT
         dta c'Klawisze: spacja, RETURN i SHIF',c'T'* ; 0DDC
; działają jak strzał w joysticku.
         dta c'dzia',$0C,c'aj',$01,c' jak strza',$0C,c' w joysticku.' ; 0DFC

* help page 1 --------------------------------------------
         dta $00,$01                               ; 0E1C
; Podczas pracy w każdej chwili możesz
         dta c'Podczas pracy w ka',$1A,c'dej chwili mo',$1A,c'es',c'z'* ; 0E1E
; otrzymać podpowiedż po wciśnięciu
         dta c'otrzyma',$03,c' podpowied',$1A,c' po wci',$13,c'ni',$05,c'ci',c'u'* ; 0E42
; klawisza HELP.
         dta c'klawisza HELP',c'.'* ; 0E63
;
         dta c' '* ; 0E71
; Powinieneś również zwracać uwagę
         dta c'Powiniene',$13,c' r',$0F,c'wnie',$1A,c' zwraca',$03,c' uwag',$85 ; 0E72
; na komunikaty pojawiające się
         dta c'na komunikaty pojawiaj',$01,c'ce si',$85 ; 0E92
; w dolnej części ekranu.
         dta c'w dolnej cz',$05,$13,c'ci ekranu',c'.'* ; 0EAF
;
         dta c' '* ; 0EC6
;
         dta c' '* ; 0EC7
; Nasz nowy adres:
         dta c'Nasz nowy adres',c':'* ; 0EC8
;
         dta c' '* ; 0ED8
;   Laboratorium Komputerowe  Avalon
         dta c'2'*,c'Laboratorium Komputerowe  Avalo',c'n'* ; 0ED9
;         skrytka pocztowa 702
         dta c'8'*,c'skrytka pocztowa 702',c' '* ; 0EFA
;            35-959 Rzeszów
         dta c'92'*,c'35-959 Rzesz',$0F,c'w'* ; 0F10
;
         dta c' '* ; 0F20
;      życzymy przyjemnej zabawy!
         dta c'5'*,$1A,c'yczymy przyjemnej zabawy!' ; 0F21

* help page 2 --------------------------------------------
         dta $00,$02                               ; 0F3C
; Menu główne:
         dta $14,c'Menu g',$0C,$0F,c'wne:',$94 ; 0F3E
;
         dta c' '* ; 0F4C
; Zawiera zestaw funkcji, których
         dta c'Zawiera zestaw funkcji, kt',$0F,c'ryc',c'h'* ; 0F4D
; nazwy są widoczne w dolnej części
         dta c'nazwy s',$01,c' widoczne w dolnej cz',$05,$13,c'c',c'i'* ; 0F6C
; ekranu. Możesz wybrać jedną z nich
         dta c'ekranu. Mo',$1A,c'esz wybra',$03,c' jedn',$01,c' z nic',c'h'* ; 0F8D
; ustawiając kursor na odpowiedniej
         dta c'ustawiaj',$01,c'c kursor na odpowiednie',c'j'* ; 0FAF
; pozycji przy pomocy ↑↓ i wciskając
         dta c'pozycji przy pomocy ',$1C,$1D,c' i wciskaj',$01,c'c'* ; 0FD0
; strzał. Opisy działania funkcji
         dta c'strza',$0C,c'. Opisy dzia',$0C,c'ania funkcj',c'i'* ; 0FF2
; znajdziesz na następnych stronach.
         dta c'znajdziesz na nast',$05,c'pnych stronach',c'.'* ; 1011
;
         dta c' '* ; 1033
; Za pomocą ←→ możesz wybrać planetę,
         dta c'Za pomoc',$01,c' ',$1E,$1F,c' mo',$1A,c'esz wybra',$03,c' planet',$05,c','* ; 1034
; którą będziesz następnie układał.
         dta c'kt',$0F,c'r',$01,c' b',$05,c'dziesz nast',$05,c'pnie uk',$0C,c'ada',$0C,c'.'* ; 1057
;
         dta c' '* ; 1078
; Aby przejść do edytora wciśnij ESC
         dta c'Aby przej',$13,$03,c' do edytora wci',$13,c'nij ES',c'C'* ; 1079
; lub ↑ gdy kursor wskazuje najwyżej
         dta c'lub ',$1C,c' gdy kursor wskazuje najwy',$1A,c'e',c'j'* ; 109B
; umieszczoną nazwę funkcji.
         dta c'umieszczon',$01,c' nazw',$05,c' funkcji.' ; 10BD

* help page 3 --------------------------------------------
         dta $00,$03                               ; 10D7
; Test planety:
         dta $14,c'Test planety:',$94 ; 10D9
;
         dta c' '* ; 10E8
; Umożliwia przetestowanie aktualnej
         dta c'Umo',$1A,c'liwia przetestowanie aktualne',c'j'* ; 10E9
; planety.
         dta c'planety',c'.'* ; 110B
;
         dta c' '* ; 1113
; Wykrycie błędów uniemożliwiających
         dta c'Wykrycie b',$0C,$05,c'd',$0F,c'w uniemo',$1A,c'liwiaj',$01,c'cyc',c'h'* ; 1114
; poprawne działanie gry zostanie
         dta c'poprawne dzia',$0C,c'anie gry zostani',c'e'* ; 1136
; zasygnalizowane komunikatem.
         dta c'zasygnalizowane komunikatem.' ; 1155

* help page 4 --------------------------------------------
         dta $00,$04                               ; 1171
; Czyść planetę:
         dta $14,c'Czy',$13,$03,c' planet',$05,c':',$94 ; 1173
;
         dta c' '* ; 1183
; Twierdząca odpowiedż na pytanie
         dta c'Twierdz',$01,c'ca odpowied',$1A,c' na pytani',c'e'* ; 1184
; poprzedzające wykonanie funkcji
         dta c'poprzedzaj',$01,c'ce wykonanie funkcj',c'i'* ; 11A3
; spowoduje wyczyszczenie planety
         dta c'spowoduje wyczyszczenie planet',c'y'* ; 11C2
; i przywrócenie pierwotnych kolorów.
         dta c'i przywr',$0F,c'cenie pierwotnych kolor',$0F,c'w',c'.'* ; 11E1
;
         dta c' '* ; 1204
; Zawartości wyczyszczonej planety
         dta c'Zawarto',$13,c'ci wyczyszczonej planet',c'y'* ; 1205
; nie możesz odzyskać!
         dta c'nie mo',$1A,c'esz odzyska',$03,c'!' ; 1225

* help page 5 --------------------------------------------
         dta $00,$05                               ; 1239
; Zmiana kolorów:
         dta $14,c'Zmiana kolor',$0F,c'w:',$94 ; 123B
;
         dta c' '* ; 124C
; Pozwala zmieniać kolory elementów
         dta c'Pozwala zmienia',$03,c' kolory element',$0F,c'w'* ; 124D
; planety. Możesz wskazać kursorem
         dta c'planety. Mo',$1A,c'esz wskaza',$03,c' kursore',c'm'* ; 126E
; dowolny kolor i wcisnąć strzał
         dta c'dowolny kolor i wcisn',$01,$03,c' strza',$8C ; 128E
; aby dokonać jego zmiany.
         dta c'aby dokona',$03,c' jego zmiany',c'.'* ; 12AC
;
         dta c' '* ; 12C4
; Uwaga: jeżeli używasz monitora
         dta $14,c'Uwaga:',$14,c' je',$1A,c'eli u',$1A,c'ywasz monitor',c'a'* ; 12C5
; monochromatycznego dostrzeżesz
         dta c'monochromatycznego dostrze',$1A,c'es',c'z'* ; 12E5
; jedynie zmiany jaskrawości!
         dta c'jedynie zmiany jaskrawo',$13,c'ci!' ; 1303

* help page 6 --------------------------------------------
         dta $00,$06                               ; 131E
; Operacje (kasetowe/dyskowe):
         dta $14,c'Operacje (kasetowe/dyskowe):',$94 ; 1320
;
         dta c' '* ; 133E
; Funkcja ta umożliwia zapisanie
         dta c'Funkcja ta umo',$1A,c'liwia zapisani',c'e'* ; 133F
; lub wczytanie zestawu planet
         dta c'lub wczytanie zestawu plane',c't'* ; 135D
; z (taśmy magnetofonowej.
         dta c'z (ta',$13,c'my magnetofonowej',c'.'* ; 1379
; /dyskietki z Robbo Konstruktorem,
         dta c'/dyskietki z Robbo Konstruktorem',c','* ; 1391
; a także na skasowanie niepotrzebnego
         dta c'a tak',$1A,c'e na skasowanie niepotrzebneg',c'o'* ; 13B2
; zestawu.
         dta c'zestawu',c'.'* ; 13D6
; Zawartość dyskietki jest wyświetlona
         dta c'Zawarto',$13,$03,c' dyskietki jest wy',$13,c'wietlon',c'a'* ; 13DE
; w centralnej części menu.
         dta c'w centralnej cz',$05,$13,c'ci menu',c'.'* ; 1402
; Dyskietka może zawierać 5 zestawów.
         dta c'Dyskietka mo',$1A,c'e zawiera',$03,c' 5 zestaw',$0F,c'w',c'.'* ; 141B
; Powyższe operacje można wykonać
         dta c'Powy',$1A,c'sze operacje mo',$1A,c'na wykona',$83 ; 143E
; na każdym z nich.
         dta c'na ka',$1A,c'dym z nich',c'.'* ; 145D
; )
         dta c')',c' '* ; 146E
; Zapisany zestaw planet zawiera
         dta c'Zapisany zestaw planet zawier',c'a'* ; 1470
; również tekst strony tytułowej
         dta c'r',$0F,c'wnie',$1A,c' tekst strony tytu',$0C,c'owe',c'j'* ; 148E
; i końcowej oraz kolejność planet.
         dta c'i ko',$0E,c'cowej oraz kolejno',$13,$03,c' planet.' ; 14AC

* help page 7 --------------------------------------------
         dta $00,$07                               ; 14CD
; Funkcje dodatkowe:
         dta $14,c'Funkcje dodatkowe:',$94 ; 14CF
;
         dta c' '* ; 14E3
; Użycie tej funkcji powoduje
         dta c'U',$1A,c'ycie tej funkcji powoduj',c'e'* ; 14E4
; wyświetlenie zestawu funkcji
         dta c'wy',$13,c'wietlenie zestawu funkcj',c'i'* ; 14FF
; dodatkowych.
         dta c'dodatkowych.' ; 151B

* help page 8 --------------------------------------------
         dta $00,$08                               ; 1527
; Strona tytułowa:
         dta $14,c'Strona tytu',$0C,c'owa:',$94 ; 1529
;
         dta c' '* ; 153B
; Pozwala na zredagowanie tekstów:
         dta c'Pozwala na zredagowanie tekst',$0F,c'w',c':'* ; 153C
; początkowego i gratulacyjnego.
         dta c'pocz',$01,c'tkowego i gratulacyjnego',c'.'* ; 155C
; Będą się one pojawiały w Twojej
         dta c'B',$05,c'd',$01,c' si',$05,c' one pojawia',$0C,c'y w Twoje',c'j'* ; 157A
; wersji gry Robbo.
         dta c'wersji gry Robbo',c'.'* ; 1599
;
         dta c' '* ; 15AA
; Wciskając klawisze: a,c,e,l,n,o,s,z
         dta c'Wciskaj',$01,c'c klawisze: a,c,e,l,n,o,s,',c'z'* ; 15AB
; wraz z klawiszem CONTROL możesz
         dta c'wraz z klawiszem CONTROL mo',$1A,c'es',c'z'* ; 15CE
; uzyskać litery:     ą,ć,ę,ł,ń,ó,ś,ż.
         dta c'uzyska',$03,c' litery:     ',$01,c',',$03,c',',$05,c',',$0C,c',',$0E,c',',$0F,c',',$13,c',',$1A,c'.'* ; 15ED
;
         dta c' '* ; 1611
; Dużymi literami możesz pisać
         dta c'Du',$1A,c'ymi literami mo',$1A,c'esz pisa',$83 ; 1612
; wciskając odpowiednie klawisze
         dta c'wciskaj',$01,c'c odpowiednie klawisz',c'e'* ; 162E
; wraz z klawiszem SHIFT.
         dta c'wraz z klawiszem SHIFT.' ; 164C

* help page 9 --------------------------------------------
         dta $00,$09                               ; 1663
; Kolejność planet:
         dta $14,c'Kolejno',$13,$03,c' planet:',$94 ; 1665
;
         dta c' '* ; 1678
; Umożliwia ustalenie kolejności
         dta c'Umo',$1A,c'liwia ustalenie kolejno',$13,c'c',c'i'* ; 1679
; planet w grze Robbo. Użycie
         dta c'planet w grze Robbo. U',$1A,c'yci',c'e'* ; 1697
; tej funkcji NIE JEST KONIECZNE!
         dta c'tej funkcji NIE JEST KONIECZNE',c'!'* ; 16B2
; Jeżeli jej nie wykorzystasz, planety
         dta c'Je',$1A,c'eli jej nie wykorzystasz, planet',c'y'* ; 16D1
; będą ułożone w takiej kolejności,
         dta c'b',$05,c'd',$01,c' u',$0C,c'o',$1A,c'one w takiej kolejno',$13,c'ci',c','* ; 16F5
; jak w Robbo Konstruktorze.
         dta c'jak w Robbo Konstruktorze',c'.'* ; 1716
;
         dta c' '* ; 1730
; K: oznacza kolejność w Konstruktorze
         dta c'K: oznacza kolejno',$13,$03,c' w Konstruktorz',c'e'* ; 1731
; R: oznacza kolejność w Robbo
         dta c'R: oznacza kolejno',$13,$03,c' w Robb',c'o'* ; 1755
;
         dta c' '* ; 1771
; Przy pomocy ←→ i strzału możesz
         dta c'Przy pomocy ',$1E,$1F,c' i strza',$0C,c'u mo',$1A,c'es',c'z'* ; 1772
; wybrać planetę z R: i wstawić ją
         dta c'wybra',$03,c' planet',$05,c' z R: i wstawi',$03,c' j',$81 ; 1791
; w dowolne miejsce w K:. Na wybranej
         dta c'w dowolne miejsce w K:. Na wybrane',c'j'* ; 17B1
; planecie pojawi się trójkącik.
         dta c'planecie pojawi si',$05,c' tr',$0F,c'jk',$01,c'cik.' ; 17D4

* help page 10 --------------------------------------------
         dta $00,$0A                               ; 17F2
; Test Robbo:
         dta $14,c'Test Robbo:',$94 ; 17F4
;
         dta c' '* ; 1801
; Umożliwia przetestowanie Twojej
         dta c'Umo',$1A,c'liwia przetestowanie Twoje',c'j'* ; 1802
; wersji gry.
         dta c'wersji gry',c'.'* ; 1821
;
         dta c' '* ; 182C
; Wykrycie błędów uniemożliwiających
         dta c'Wykrycie b',$0C,$05,c'd',$0F,c'w uniemo',$1A,c'liwiaj',$01,c'cyc',c'h'* ; 182D
; jej poprawne działanie zostanie
         dta c'jej poprawne dzia',$0C,c'anie zostani',c'e'* ; 184F
; zasygnalizowane komunikatem.
         dta c'zasygnalizowane komunikatem',c'.'* ; 186E
; Planeta zawierająca błąd zostanie
         dta c'Planeta zawieraj',$01,c'ca b',$0C,$01,c'd zostani',c'e'* ; 188A
; pokazana na ekranie.
         dta c'pokazana na ekranie.' ; 18AB

* help page 11 --------------------------------------------
         dta $00,$0B                               ; 18BF
; Zapisz Robbo:
         dta $14,c'Zapisz Robbo:',$94 ; 18C1
;
         dta c' '* ; 18D0
; Przy pomocy tej funkcji możesz
         dta c'Przy pomocy tej funkcji mo',$1A,c'es',c'z'* ; 18D1
; zapisać na (taśmie/dyskietce)
         dta c'zapisa',$03,c' na (ta',$13,c'mie/dyskietce)',c' '* ; 18EF
; samodzielnie działającą grę Robbo.
         dta c'samodzielnie dzia',$0C,c'aj',$01,c'c',$01,c' gr',$05,c' Robbo',c'.'* ; 190D
;
         dta c' '* ; 192F
; Możesz ją wczytać przez wciśnięcie
         dta c'Mo',$1A,c'esz j',$01,c' wczyta',$03,c' przez wci',$13,c'ni',$05,c'ci',c'e'* ; 1930
; (START /)OPTION i włączenie komputera.
         dta c'(START /)OPTION i w',$0C,$01,c'czenie komputera',c'.'* ; 1952
;
         dta c' '* ; 1978
; Wykrycie błędów uniemożliwiających
         dta c'Wykrycie b',$0C,$05,c'd',$0F,c'w uniemo',$1A,c'liwiaj',$01,c'cyc',c'h'* ; 1979
; jej poprawne działanie zostanie
         dta c'jej poprawne dzia',$0C,c'anie zostani',c'e'* ; 199B
; zasygnalizowane komunikatem.
         dta c'zasygnalizowane komunikatem',c'.'* ; 19BA
; Planeta zawierająca błąd zostanie
         dta c'Planeta zawieraj',$01,c'ca b',$0C,$01,c'd zostani',c'e'* ; 19D6
; pokazana na ekranie.
         dta c'pokazana na ekranie.' ; 19F7

* help page 12 --------------------------------------------
         dta $00,$0C                               ; 1A0B
; Funkcje podstawowe:
         dta $14,c'Funkcje podstawowe:',$94 ; 1A0D
;
         dta c' '* ; 1A22
; Użycie tej funkcji powoduje
         dta c'U',$1A,c'ycie tej funkcji powoduj',c'e'* ; 1A23
; wyświetlenie zestawu funkcji
         dta c'wy',$13,c'wietlenie zestawu funkcj',c'i'* ; 1A3E
; podstawowych.
         dta c'podstawowych.' ; 1A5A

* help page 13 --------------------------------------------
         dta $00,$0D                               ; 1A67
; Zbiór elementów składowych planety:
         dta $14,c'Zbi',$0F,c'r element',$0F,c'w sk',$0C,c'adowych planety:',$94 ; 1A69
;
         dta c' '* ; 1A8E
; Jest on widoczny w prawej części
         dta c'Jest on widoczny w prawej cz',$05,$13,c'c',c'i'* ; 1A8F
; ekranu. Możesz wybrać element,
         dta c'ekranu. Mo',$1A,c'esz wybra',$03,c' element',c','* ; 1AAF
; który chcesz umieścić na planecie
         dta c'kt',$0F,c'ry chcesz umie',$13,c'ci',$03,c' na planeci',c'e'* ; 1ACD
; przez wskazanie go kursorem
         dta c'przez wskazanie go kursore',c'm'* ; 1AEE
; i wciśnięcie strzału. Wybrany obiekt
         dta c'i wci',$13,c'ni',$05,c'cie strza',$0C,c'u. Wybrany obiek',c't'* ; 1B09
; zacznie migać.
         dta c'zacznie miga',$03,c'.'* ; 1B2D
;
         dta c' '* ; 1B3B
; Powtórne wybranie murka spowoduje
         dta c'Powt',$0F,c'rne wybranie murka spowoduj',c'e'* ; 1B3C
; zmianę jego kształtu.
         dta c'zmian',$05,c' jego kszta',$0C,c'tu',c'.'* ; 1B5D
;
         dta c' '* ; 1B72
; Aby wrócić do menu możesz wcisnąć
         dta c'Aby wr',$0F,c'ci',$03,c' do menu mo',$1A,c'esz wcisn',$01,$83 ; 1B73
; klawisz ESC lub ↓ gdy kursor
         dta c'klawisz ESC lub ',$1D,c' gdy kurso',c'r'* ; 1B94
; znajduje się w ostatniej linii
         dta c'znajduje si',$05,c' w ostatniej lini',c'i'* ; 1BB0
; zbioru elementów.
         dta c'zbioru element',$0F,c'w.' ; 1BCE

* help page 14 --------------------------------------------
         dta $00,$0E                               ; 1BDF
; Edytor planety:
         dta $14,c'Edytor planety:',$94 ; 1BE1
;
         dta c' '* ; 1BF2
; Służy do układania planet. Uprzednio
         dta c'S',$0C,c'u',$1A,c'y do uk',$0C,c'adania planet. Uprzedni',c'o'* ; 1BF3
; zaznaczony element możesz umieścić
         dta c'zaznaczony element mo',$1A,c'esz umie',$13,c'ci',$83 ; 1C17
; na pozycji wskazywanej przez kursor
         dta c'na pozycji wskazywanej przez kurso',c'r'* ; 1C39
; wciskając strzał. Ponowne wstawienie
         dta c'wciskaj',$01,c'c strza',$0C,c'. Ponowne wstawieni',c'e'* ; 1C5C
; elementu w tym samym miejscu
         dta c'elementu w tym samym miejsc',c'u'* ; 1C80
; spowoduje jego usunięcie.
         dta c'spowoduje jego usuni',$05,c'cie',c'.'* ; 1C9C
;
         dta c' '* ; 1CB5
; Aby wrócić do menu wcisnij ESC.
         dta c'Aby wr',$0F,c'ci',$03,c' do menu wcisnij ESC.' ; 1CB6

* help page 15 --------------------------------------------
         dta $00,$0F                               ; 1CD5
;
         dta c' '* ; 1CD7
;
         dta c' '* ; 1CD8
; Program Robbo Konstruktor został
         dta c'Program Robbo Konstruktor zosta',$8C ; 1CD9
; przetestowany w firmie Avalon.
         dta c'przetestowany w firmie Avalon',c'.'* ; 1CF9
;
         dta c' '* ; 1D17
; Jeżeli Twoja wersja wykazuje błędy
         dta c'Je',$1A,c'eli Twoja wersja wykazuje b',$0C,$05,c'd',c'y'* ; 1D18
; uniemożliwiające jej używanie,
         dta c'uniemo',$1A,c'liwiaj',$01,c'ce jej u',$1A,c'ywanie',c','* ; 1D3A
; jest nielegalną kopią!
         dta c'jest nielegaln',$01,c' kopi',$01,c'!'* ; 1D58
;
         dta c' '* ; 1D6E
;
         dta c' '* ; 1D6F
; Poprawnie działający program,
         dta c'Poprawnie dzia',$0C,c'aj',$01,c'cy program',c','* ; 1D70
; jak również inne gry Avalonu
         dta c'jak r',$0F,c'wnie',$1A,c' inne gry Avalon',c'u'* ; 1D8D
; możesz nabyć wysyłkowo
         dta c'mo',$1A,c'esz naby',$03,c' wysy',$0C,c'kow',c'o'* ; 1DA9
; w naszej firmie.
         dta c'w naszej firmie.',$80 ; 1DBF
;
         dta $00 ; 1DD0
