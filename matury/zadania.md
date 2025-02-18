# Rozwiązania SQL z matur

## Formuła 2023

### Maj 2024

[View Matura](https://www.korepetycjezinformatyki.pl/wp-content/uploads/2024/05/informatyka-2024-maj-matura-rozszerzona.pdf)

#### 8.1

Podaj imię i nazwisko kierowcy, dla którego suma kwot za wszystkie mandaty była
największa, oraz podaj tę największą sumę. Jest tylko jeden taki kierowca.

<details>
<summary>Solution</summary>

```sql
SELECT k.Imie, k.Nazwisko, SUM(t.Kwota) kwota
FROM rejestr r
JOIN kierowcy k ON r.IdOsoby = k.IdOsoby
JOIN taryfikator t ON r.IdWykroczenia = t.IdWykroczenia
GROUP BY k.IdOsoby
ORDER BY kwota DESC
LIMIT 1
```

</details>

<details>
<summary>Answer</summary>

| Imie   | Nazwisko | kwota |
| ------ | -------- | ----- |
| Rafael | Blake    | 3700  |

</details>

#### 8.2

W którym miesiącu kierowcy otrzymali najmniej punktów karnych (łącznie) za wykroczenia
polegające na przekroczeniu dozwolonej prędkości o więcej niż 20 km/h (wykroczenia
o identyfikatorach od 3 do 6)? Podaj miesiąc oraz łączną liczbę punktów karnych z tego
miesiąca.

<details>
<summary>Solution</summary>

```sql
SELECT MONTH(r.Data) miesiac, SUM(t.Punkty) punkty
FROM rejestr r
JOIN kierowcy k ON r.IdOsoby = k.IdOsoby
JOIN taryfikator t ON r.IdWykroczenia = t.IdWykroczenia
WHERE t.IdWykroczenia BETWEEN 3 AND 6
GROUP BY miesiac
ORDER BY punkty
LIMIT 1
```

</details>

<details>
<summary>Answer</summary>

| miesiac | punkty |
| ------- | ------ |
| 11      | 1766   |

</details>

#### 8.3

Wykonaj zestawienie numerów rejestracyjnych samochodów wraz z imionami i nazwiskami
ich właścicieli, którzy nie figurują w rejestrze wykroczeń. Zestawienie posortuj alfabetycznie
według numerów rejestracyjnych samochodów.

<details>
<summary>Solution</summary>

```sql
SELECT k.NrRejestracyjny, k.Imie, k.Nazwisko
FROM kierowcy k
LEFT JOIN rejestr r ON k.IdOsoby = r.IdOsoby
WHERE r.IdOsoby IS NULL
ORDER BY k.NrRejestracyjny
```

</details>

<details>
<summary>Answer</summary>

| NrRejestracyjny # 1 | Imie     | Nazwisko |
| ------------------- | -------- | -------- |
| BHW4028             | Sandra   | Wheeler  |
| CJX1859             | Quynn    | Travis   |
| KNM7950             | Jasper   | Santos   |
| NIP6570             | Honorato | Roth     |
| QFR8936             | Ivy      | Bowen    |
| SRU9727             | Helen    | White    |
| XHK9060             | Quentin  | Tyler    |
| YYS1077             | Kevin    | Wright   |

</details>

#### 8.4

Baza danych rejestru wykroczeń została zmodyfikowana. Dodano nową tabelę Fotoradar,
wraz z polami IdFotoradaru, Miejscowosc i DozwolonaPredkosc. Natomiast do tabeli Rejestr
zostało dodane pole IdFotoradaru, w którym dla każdego rekordu zapisano identyfikator tego
fotoradaru, który zarejestrował dane wykroczenie.\
Załóżmy, że w bazie istnieją fotoradary, które nie zarejestrowały żadnych wykroczeń.\
Zapisz w języku SQL zapytanie, w wyniku którego otrzymasz identyfikatory tych fotoradarów.

<details>
<summary>Solution</summary>

```sql
SELECT f.IdFotoradaru
FROM fotoradar f
LEFT JOIN rejestr r ON f.IdFotoradaru = r.IdFotoradaru
WHERE r.IdFotoradaru IS NULL
```

</details>

### Maj 2023

[View Matura](https://www.korepetycjezinformatyki.pl/wp-content/uploads/2024/03/informatyka-2023-maj-matura-rozszerzona.pdf)

#### 7.1

Podaj tytuł gry, która otrzymała najwięcej ocen.

<details>
<summary>Solution</summary>

```sql
SELECT g.nazwa
FROM oceny o
JOIN gry g ON o.id_gry = g.id_gry
GROUP BY g.id_gry
ORDER BY COUNT(*) DESC
LIMIT 1
```

</details>

<details>
<summary>Answer</summary>

| nazwa |
| ----- |
| K2    |

</details>

#### 7.2

Dla każdej gry z kategorii „imprezowa” podaj średnią jej ocen z dokładnością do dwóch
miejsc po przecinku.

<details>
<summary>Solution</summary>

```sql
SELECT g.nazwa, ROUND(AVG(o.ocena), 2) srednia
FROM oceny o
JOIN gry g ON o.id_gry = g.id_gry
WHERE g.kategoria = "imprezowa"
GROUP BY g.id_gry
```

</details>

<details>
<summary>Answer</summary>

| nazwa                | srednia |
| -------------------- | ------- |
| Szeryf z Nottingham  | 7.88    |
| Colt Express         | 7.54    |
| 5 sekund             | 8.16    |
| Sushi Go             | 8.07    |
| Przebiegle wielblady | 7.73    |
| Avalone              | 8.25    |
| Swiatowy Konflikt    | 7.80    |
| Jenga                | 8.16    |
| Mamy szpiega         | 8.22    |
| Koncept              | 8.37    |

</details>

#### 7.3

Podaj liczbę graczy, którzy nie posiadają żadnej z ocenianych przez siebie gier (nie mają
żadnej gry ze stanem „posiada”), a wystawili co najmniej jedną ocenę.

<details>
<summary>Solution</summary>

```sql
SELECT COUNT(DISTINCT o.id_gracza) liczba
FROM oceny o
WHERE NOT EXISTS (
	SELECT 1
	FROM oceny io
	WHERE io.id_gracza = o.id_gracza AND io.stan = "posiada"
)
```

</details>

<details>
<summary>Answer</summary>

| liczba |
| ------ |
| 334    |

</details>

#### 7.4

W ocenianiu gier planszowych uczestniczą osoby w wieku od 10 do 99 lat. Osoby oceniające
gry podzielono na trzy kategorie wiekowe: juniorzy (do 19 lat), seniorzy (od 20 do 49 lat) oraz
weterani (od 50 lat).\
Wykonaj zestawienie, w którym dla każdej kategorii wiekowej podasz największą liczbę ocen
wystawionych jednej grze przez użytkowników z tej kategorii wiekowej oraz nazwy gier z tą
liczbą ocen.\
Jeżeli gier, które otrzymały taką samą największą liczbę ocen od użytkowników z danej
kategorii wiekowej, jest więcej niż jedna – podaj tytuły ich wszystkich.\

<details>
<summary>Solution</summary>

```sql
WITH KategorieWiekowe AS (
  SELECT
    o.id_gry,
    g.nazwa,
    CASE
      WHEN p.wiek <= 19 THEN "juniorzy"
      WHEN p.wiek BETWEEN 20 AND 49 THEN "seniorzy"
      ELSE "weterani"
    END kategoria
  FROM oceny o
  JOIN gry g ON o.id_gry = g.id_gry
  JOIN gracze p ON o.id_gracza = p.id_gracza
),
LiczbaOcen AS (
  SELECT
    kategoria,
    nazwa,
    COUNT(*) liczba_ocen
  FROM KategorieWiekowe
  GROUP BY kategoria, nazwa
),
MaxOcen AS (
  SELECT
    kategoria,
    MAX(liczba_ocen) max_ocen
  FROM LiczbaOcen
  GROUP BY kategoria
)
SELECT l.kategoria, l.nazwa, l.liczba_ocen
FROM LiczbaOcen l
JOIN MaxOcen m
ON l.kategoria = m.kategoria AND l.liczba_ocen = m.max_ocen
```

</details>

<details>
<summary>Answer</summary>

| kategoria | nazwa               | liczba_ocen |
| --------- | ------------------- | ----------- |
| juniorzy  | K2                  | 6           |
| juniorzy  | Terraformacja Marsa | 6           |
| seniorzy  | K2                  | 24          |
| weterani  | Robinson Crusoe     | 28          |

</details>

#### 7.5

Do wcześniej opisanych tabel bazy danych dołączamy kolejną o nazwie sklep, w której
zapisano cennik gier sprzedawanych w pewnym sklepie. Tabela zawiera następujące pola:\
id_gry – identyfikator gry\
cena – cena gry\
promocja – informacja, czy cena jest ceną promocyjną (wartość true – jeśli cena jest
promocyjna albo false – kiedy nie jest promocyjna)\
Tabele gry i sklep są połączone relacją jeden do wielu.\
Uwaga:\
• gra może mieć dwie ceny (cena w promocji i cena bez promocji), tj. może występować
w tabeli sklep dwa razy\
• tabela sklep zawiera tylko identyfikatory gier, które są w ofercie sklepu (nie musi zawierać
wszystkich identyfikatorów z tabeli gry).\
Zapisz zapytanie SQL, w wyniku którego uzyskamy informację, ile należałoby zapłacić za
zakup w tym sklepie po jednej sztuce ze wszystkich gier logicznych (kategoria „logiczna”)
dostępnych w cenach promocyjnych.

<details>
<summary>Solution</summary>

```sql
SELECT SUM(s.cena) kwota
FROM sklep s
JOIN gry g ON s.id_gry = g.id_gry
WHERE s.promocja = true AND g.kategoria = "logiczna"
```

</details>

### Czerwiec 2023

[View Matura](https://www.korepetycjezinformatyki.pl/wp-content/uploads/2024/03/informatyka-2023-czerwiec-matura-rozszerzona.pdf)

<details>
<summary>Problematic data</summary>

Let's try to import data from the `instalacje.txt` file.\
The problem is with the `data_i` column, where the date is stored as `DD.MM.YYYY` instead of `YYYY-MM-DD`.\
What are we going to do is to define its type as `varchar` which will allow use to just import the data.\
Then we can change the format of the date to `YYYY-MM-DD`.\

```sql
UPDATE instalacje
SET data_i = STR_TO_DATE(data_i, '%d.%m.%Y')
```

Having done that, we can change the type of the column to `date` for easy calculations.\
Done!

</details>

#### 7.1

Dla każdego typu urządzenia podaj liczbę instalacji aplikacji na tym typie urządzenia.

<details>
<summary>Solution</summary>

```sql
SELECT u.typ_u, COUNT(*) liczba
FROM instalacje i
JOIN urzadzenia u ON i.kod_u = u.kod_u
GROUP BY u.typ_u
```

</details>

<details>
<summary>Answer</summary>

| typ_u  | liczba |
| ------ | ------ |
| PC     | 16     |
| Phone  | 2814   |
| Tablet | 267    |

</details>

#### 7.2

Podaj nazwę producenta urządzeń, dla którego w lutym 2019 wykonano najwięcej instalacji.\
Podaj liczbę tych instalacji.

<details>
<summary>Solution</summary>

```sql
SELECT u.producent_u, COUNT(*) liczba
FROM instalacje i
JOIN urzadzenia u ON i.kod_u = u.kod_u
WHERE MONTH(i.data_i) = 2
GROUP BY u.producent_u
ORDER BY liczba DESC
LIMIT 1
```

</details>

<details>
<summary>Answer</summary>

| producent_u | liczba |
| ----------- | ------ |
| Samsung     | 478    |

</details>

#### 7.3

Podaj nazwy pięciu krajów, w których przeprowadzono najwięcej instalacji w przeliczeniu na
1 000 000 mieszkańców, oraz podaj liczby tych instalacji.\
Dla każdego z tych pięciu krajów podaj liczbę instalacji na 1 000 000 mieszkańców
z dokładnością do dwóch miejsc po przecinku.\
**Uwaga**: pomiń kraje, w których jest mniej niż milion mieszkańców.

<details>
<summary>Solution</summary>

```sql
SELECT k.nazwa_k, ROUND(COUNT(*) / k.ludnosc_k * 1000000, 2) wspolczynnik
FROM instalacje i
JOIN kraje k ON i.kod_k = k.kod_k
WHERE k.ludnosc_k >= 1000000
GROUP BY k.kod_k
ORDER BY wspolczynnik DESC
LIMIT 5
```

</details>

<details>
<summary>Answer</summary>

| nazwa_k        | wspolczynnik |
| -------------- | ------------ |
| SWITZERLAND    | 5.28         |
| SLOVENIA       | 4.35         |
| IRELAND        | 3.91         |
| AUSTRIA        | 3.84         |
| CZECH REPUBLIC | 3.76         |

</details>

#### 7.4

Podaj kod oraz nazwę urządzenia typu tablet („Tablet”), na którym zainstalowano aplikację
w największej liczbie krajów. Podaj także liczbę krajów, w których instalowano aplikację na
tym urządzeniu.

<details>
<summary>Solution</summary>

```sql
SELECT u.kod_u, u.nazwa_u, COUNT(DISTINCT k.kod_k) liczba
FROM instalacje i
JOIN kraje k ON i.kod_k = k.kod_k
JOIN urzadzenia u ON i.kod_u = u.kod_u
WHERE u.typ_u = "Tablet"
GROUP BY u.kod_u
ORDER BY liczba DESC
LIMIT 1
```

</details>

<details>
<summary>Answer</summary>

| kod_u | nazwa_u             | liczba |
| ----- | ------------------- | ------ |
| 11935 | Galaxy Tab A (2016) | 20     |

</details>

#### 7.5

Do istniejących już tabel bazy danych dołączono tabelę firmy zawierającą dane firm,
w których wykonywano instalacje aplikacji.\
Tabela firmy zawiera pola id_firmy (identyfikator firmy – klucz podstawowy) oraz nazwa –
nazwa firmy.\
Do tabeli instalacje (zawierającej dane z pliku instalacje.txt) dodano pole id_firmy
wskazujące, w której firmie na należących do niej urządzeniach wykonano instalację.\
Tabele firmy i instalacje połączone są relacją jeden do wielu.\
Zapisz w języku SQL zapytanie, w którym dla każdej nazwy firmy z tabeli firmy zliczysz liczbę
instalacji wykonanych w tej firmie. Wynik posortuj nierosnąco według liczby instalacji.

<details>
<summary>Comment</summary>

The task is to count the number of installations performed in each company.\
However, using INNER JOIN would exclude companies with no installations from the results.\
To ensure all companies are included, even those without installations, LEFT JOIN should be used instead.\
This way, companies without any installations will still appear in the results with a count of zero.

</details>

<details>
<summary>Solution (mine)</summary>

```sql
SELECT f.nazwa, COUNT(*) liczba
FROM firma f
LEFT JOIN instalacje i ON f.id_firmy = i.id_firmy
GROUP BY f.id_firmy
ORDER BY liczba DESC
```

</details>

<details>
<summary>Solution (theirs)</summary>

```sql
SELECT f.nazwa, COUNT(*) liczba
FROM firma f
JOIN instalacje i ON f.id_firmy = i.id_firmy
GROUP BY f.id_firmy
ORDER BY liczba DESC
```

</details>

## Formuła 2015

### Maj 2022

[View Matura](https://www.korepetycjezinformatyki.pl/wp-content/uploads/nowa-rozszerzona/informatyka-2022-maj-matura-rozszerzona-2.pdf)

#### 6.1

Oblicz i podaj, ile wszystkich wejść dziewcząt z klas o profilu biologiczno-chemicznym
(„biologiczno-chemiczny”) do szkoły zarejestrował system kontroli dostępu w analizowanym
okresie 5 dni. Wszystkie imiona dziewcząt (i tylko dziewcząt) w tej szkole kończą się literą a.

<details>
<summary>Solution</summary>

```sql
SELECT COUNT(*) liczba
FROM ewidencja e
JOIN uczen u ON e.IdUcznia = u.IdUcznia
JOIN klasa k ON u.IdKlasy = k.IdKlasy
WHERE u.Imie LIKE "%a" AND k.ProfilKlasy = "biologiczno-chemiczny"
```

</details>

<details>
<summary>Answer</summary>

| liczba |
| ------ |
| 165    |

</details>

#### 6.2

Utwórz zestawienie zawierające informację o liczbie uczniów, którzy w poszczególnych
dniach analizowanego okresu nie spóźnili się do szkoły. Jako godzinę rozpoczęcia zajęć
przyjmujemy godzinę 8:00. Wejście ucznia zarejestrowane po 8:00 traktujemy jako spóźnienie

<details>
<summary>Solution</summary>

```sql
SELECT DATE(e.Wejscie) dzien, COUNT(*) liczba
FROM ewidencja e
WHERE TIME(e.Wejscie) <= "8:00:00"
GROUP BY dzien
```

</details>

<details>
<summary>Answer</summary>

| dzien      | liczba |
| ---------- | ------ |
| 2022-04-04 | 233    |
| 2022-04-05 | 303    |
| 2022-04-06 | 134    |
| 2022-04-07 | 280    |
| 2022-04-08 | 127    |

</details>

#### 6.3

Dla każdej osoby zliczamy łączny czas pobytu w szkole w analizowanym okresie 5 dni.
Podaj identyfikatory oraz imiona i nazwiska trzech osób, które w ciągu monitorowanego
czasu przebywały najdłużej na terenie szkoły.

<details>
<summary>Solution</summary>

```sql
WITH czasy AS (
  SELECT e.IdUcznia, TIMEDIFF(e.Wyjscie, e.Wejscie) czas
	FROM ewidencja e
)
SELECT u.IdUcznia, u.Imie, u.Nazwisko
FROM uczen u
JOIN czasy c ON u.IdUcznia = c.IdUcznia
GROUP BY u.IdUcznia
ORDER BY SUM(TIME_TO_SEC(c.czas)) DESC
LIMIT 3
```

</details>

<details>
<summary>Answer</summary>

| IdUcznia | Imie      | Nazwisko |
| -------- | --------- | -------- |
| 314      | Sebastian | Rabaj    |
| 172      | Monika    | Kado     |
| 299      | Alicja    | Kronecka |

</details>

#### 6.4

Podaj imiona i nazwiska wszystkich uczniów, którzy byli nieobecni 6.04.2022 r.

<details>
<summary>Solution</summary>

```sql
SELECT u.Imie, u.Nazwisko
FROM uczen u
LEFT JOIN ewidencja e ON u.IdUcznia = e.IdUcznia AND DATE(e.Wejscie) = "2022-04-06"
WHERE e.IdUcznia IS NULL
```

</details>

<details>
<summary>Answer</summary>

| Imie      | Nazwisko |
| --------- | -------- |
| Mateusz   | Kordas   |
| Krzysztof | Michalak |
| Oliwier   | Ziolko   |

</details>

### Maj 2021

[View Matura](https://www.korepetycjezinformatyki.pl/wp-content/uploads/nowa-rozszerzona/informatyka-2021-maj-matura-rozszerzona-2.pdf)

#### 6.1

Podaj 5 krajów, z których najwięcej graczy dołączyło do gry w 2018 roku. Dla każdego z tych
krajów podaj liczbę graczy, którzy dołączyli w 2018 roku.

<details>
<summary>Solution</summary>

```sql
SELECT g.kraj, COUNT(*) liczba
FROM gracze g
WHERE YEAR(g.data_dolaczenia) = 2018
GROUP BY g.kraj
ORDER BY liczba DESC
LIMIT 5
```

</details>

<details>
<summary>Answer</summary>

| kraj              | liczba # 1 |
| ----------------- | ---------- |
| Polska            | 11         |
| Stany Zjednoczone | 8          |
| Francja           | 7          |
| Niemcy            | 6          |
| Rosja             | 6          |

</details>

#### 6.2

Podaj sumę wartości pola strzał (strzal) dla każdej klasy jednostek, które mają „elf” jako część
nazwy.

<details>
<summary>Solution</summary>

```sql
SELECT k.nazwa, SUM(k.strzal) suma
FROM jednostki j
JOIN klasy k ON j.nazwa = k.nazwa
WHERE k.nazwa LIKE "%elf%"
GROUP BY k.nazwa
```

</details>

<details>
<summary>Answer</summary>

| nazwa                 | suma |
| --------------------- | ---- |
| ciemny elf            | 555  |
| elfi czarodziej       | 435  |
| lesny elf             | 1815 |
| wysoki elf-gwardzista | 870  |

</details>

#### 6.3

Podaj numery graczy, którzy nie mają artylerzystów (jednostek o nazwie artylerzysta). Numery
podaj w porządku rosnącym.

<details>
<summary>Solution</summary>

```sql
SELECT g.id_gracza
FROM gracze g
LEFT JOIN jednostki j ON g.id_gracza = j.id_gracza AND j.nazwa = "artylerzysta"
WHERE j.id_jednostki IS NULL
ORDER BY g.id_gracza
```

</details>

<details>
<summary>Answer</summary>

| id_gracza |
| --------- |
| 22        |
| 24        |
| 29        |
| 35        |
| 36        |
| 37        |
| 38        |
| 47        |
| 54        |
| 61        |
| 64        |
| 72        |
| 110       |
| 114       |
| 115       |
| 122       |
| 123       |
| 138       |
| 141       |
| 167       |

</details>

#### 6.4

Jeden krok jednostki to przejście o 1 w dowolnym z czterech kierunków (północ, południe,
wschód lub zachód). W jednej turze jednostka może wykonać co najwyżej tyle kroków, ile
wynosi jej szybkosc. Innymi słowy jednostka w ciągu jednej tury może przemieścić się z punktu
(x,y) do punktu (x1,y1), jeśli |x – x1| + |y – y1| ≤ szybkosc.\
Tytułowa Kamienna Brama znajduje się w miejscu (100,100). Wyszukaj jednostki, które mogą
w jednej turze dojść do Bramy, i podziel je na poszczególne klasy. Utwórz zestawienie, które
dla każdej klasy poda jej nazwę oraz liczbę jednostek z tej klasy mogących w jednej turze
osiągnąć Bramę.

<details>
<summary>Solution</summary>

```sql
SELECT k.nazwa, COUNT(*) liczba
FROM jednostki j
JOIN klasy k ON j.nazwa = k.nazwa
WHERE ABS(100 - j.lok_x) + ABS(100 - j.lok_y) <= k.szybkosc
GROUP BY k.nazwa
```

</details>

<details>
<summary>Answer</summary>

| nazwa                 | liczba |
| --------------------- | ------ |
| architekt             | 1      |
| artylerzysta          | 4      |
| balista               | 2      |
| ciemny elf            | 1      |
| drwal                 | 3      |
| elfi czarodziej       | 1      |
| goniec                | 2      |
| ifryt                 | 1      |
| kaplan                | 2      |
| kawalerzysta          | 7      |
| konny lucznik         | 4      |
| kusznik               | 1      |
| lekki jezdziec        | 19     |
| lucznik               | 1      |
| mag powietrza         | 3      |
| mag wody              | 2      |
| paladyn               | 1      |
| piechur               | 7      |
| pikinier              | 5      |
| robotnik              | 5      |
| topornik              | 5      |
| wysoki elf-gwardzista | 1      |
| zwiadowca             | 4      |

</details>

#### 6.5

Jeśli w pewnej lokalizacji znajdują się jednostki więcej niż jednego gracza, toczy się tam
(jedna) bitwa. Oblicz:\
a) ile bitew ma miejsce na planszy,\
b) w ilu bitwach biorą udział gracze z Polski.\
**Uwaga**: zauważ, że w jednej lokalizacji może się znajdować więcej niż jedna jednostka tego
samego gracza.

<details>
<summary>Solution</summary>

```sql
WITH bitwy AS (
  SELECT
    j.lok_x,
    j.lok_y,
    COUNT(DISTINCT g.id_gracza) liczba,
    SUM(CASE WHEN g.kraj = 'Polska' THEN 1 ELSE 0 END) polakow
  FROM jednostki j
  JOIN gracze g ON j.id_gracza = g.id_gracza
  GROUP BY j.lok_x, j.lok_y
  HAVING liczba > 1
)
SELECT
  COUNT(*) ile_bitew,
  SUM(CASE WHEN b.polakow > 0 THEN 1 ELSE 0 END) ile_polakow
FROM bitwy b
```

</details>

<details>
<summary>Answer</summary>

| ile_bitew | ile_polakow |
| --------- | ----------- |
| 1061      | 245         |

</details>

### Maj 2020

[View Matura](https://www.korepetycjezinformatyki.pl/wp-content/uploads/nowa-rozszerzona/informatyka-2020-maj-matura-rozszerzona-2.pdf)

<details>
<summary>Problematic data</summary>

Let's try to import data from the `panstwa.txt` file.\
The problem is with the `Populacja` column, which uses `,` as a decimal separator instead of `.`.\
What are we going to do is to define its type as `varchar` which will allow use to just import the data.\
Then we can replace the `,` with `.`.\

```sql
UPDATE panstwa
SET Populacja = REPLACE(Populacja, ',', '.')
```

Having done that, we can change the type of the column to `decimal(8, 1)` for easy calculations.\
Done!

</details>

#### 5.1

Utwórz zestawienie, które dla każdej rodziny językowej podaje, ile języków do niej należy.
Posortuj zestawienie nierosnąco według liczby języków.

<details>
<summary>Solution</summary>

```sql
SELECT Rodzina, COUNT(*) liczba
FROM jezyki
GROUP BY Rodzina
ORDER BY liczba DESC
```

</details>

<details>
<summary>Answer</summary>

| Rodzina                    | liczba |
| -------------------------- | ------ |
| nigero-kongijska           | 137    |
| austronezyjska             | 65     |
| indoeuropejska             | 63     |
| sino-tybetanska            | 43     |
| nilo-saharyjska            | 30     |
| afroazjatycka              | 28     |
| dajska                     | 23     |
| austroazjatycka            | 20     |
| turecka                    | 15     |
| drawidyjska                | 15     |
| jezyk izolowany            | 8      |
| polnocno-wschodniokaukaska | 7      |
| otomang                    | 7      |
| mongolska                  | 5      |
| majanska                   | 5      |
| hmong-mien                 | 4      |
| abchasko-adygijska         | 3      |
| uralska                    | 3      |
| tupi                       | 1      |
| keczua                     | 1      |
| algijska                   | 1      |
| uto-aztecka                | 1      |
| na-dene                    | 1      |
| tungusko-mandzurska        | 1      |

</details>

#### 5.2

Podaj liczbę języków, które nie są językami urzędowymi w żadnym państwie. Przy
rozwiązywaniu zadania pamiętaj, że w jednym państwie może być kilka języków urzędowych
oraz że dany język może być językiem urzędowym w jednym państwie, a w innym – nie.

<details>
<summary>Solution</summary>

```sql
SELECT COUNT(*) liczba
FROM jezyki j
WHERE NOT EXISTS (
	SELECT 1
	FROM uzytkownicy u
	WHERE u.Jezyk = j.Jezyk AND u.Urzedowy = "tak"
)
```

</details>

<details>
<summary>Answer</summary>

| liczba |
| ------ |
| 445    |

</details>

#### 5.3

Podaj wszystkie języki, którymi posługują się użytkownicy na co najmniej czterech
kontynentach.\
**Uwaga**: dla uproszczenia przyjmujemy, że państwo leży na tym kontynencie, na którym
znajduje się jego stolica.

<details>
<summary>Solution</summary>

```sql
SELECT u.Jezyk
FROM uzytkownicy u
JOIN panstwa p ON u.Panstwo = p.Panstwo
GROUP BY u.Jezyk
HAVING COUNT(DISTINCT p.Kontynent) >= 4
```

</details>

<details>
<summary>Answer</summary>

| Jezyk      |
| ---------- |
| angielski  |
| arabski    |
| gudzaracki |
| tamilski   |

</details>

#### 5.4

Znajdź 6 języków, którymi posługuje się łącznie najwięcej mieszkańców obu Ameryk
(„Ameryka Polnocna” i „Ameryka Poludniowa”), a które nie należą do rodziny
indoeuropejskiej („indoeuropejska”). Dla każdego z nich podaj nazwę, rodzinę językową
i liczbę użytkowników w obu Amerykach łącznie.

<details>
<summary>Solution</summary>

```sql
SELECT j.Jezyk, j.Rodzina, SUM(u.Uzytkownicy) liczba
FROM uzytkownicy u
JOIN panstwa p ON u.Panstwo = p.Panstwo
JOIN jezyki j ON u.Jezyk = j.Jezyk
WHERE p.Kontynent IN ("Ameryka Polnocna", "Ameryka Poludniowa") AND j.Rodzina != "indoeuropejska"
GROUP BY j.Jezyk
ORDER BY liczba DESC
LIMIT 6
```

</details>

<details>
<summary>Answer</summary>

| Jezyk       | Rodzina         | liczba |
| ----------- | --------------- | ------ |
| mandarynski | sino-tybetanska | 3.1    |
| arabski     | afroazjatycka   | 2.7    |
| tagalog     | austronezyjska  | 1.9    |
| wietnamski  | austroazjatycka | 1.5    |
| nahuatl     | uto-aztecka     | 1.4    |
| koreanski   | jezyk izolowany | 1.2    |

</details>

#### 5.5

Znajdź państwa, w których co najmniej 30% populacji posługuje się językiem, który nie jest
językiem urzędowym obowiązującym w tym państwie. Dla każdego takiego państwa podaj
jego nazwę i język, którym posługuje się co najmniej 30% populacji, a który nie jest
urzędowym językiem w tym państwie, oraz procent populacji posługującej się tym językiem.

<details>
<summary>Solution</summary>

```sql
SELECT p.Panstwo, u.Jezyk, 100 * u.Uzytkownicy / p.Populacja procent
FROM uzytkownicy u
JOIN panstwa p ON u.Panstwo = p.Panstwo
WHERE u.Urzedowy = "nie" AND u.Uzytkownicy >= 0.3 * p.Populacja
```

</details>

<details>
<summary>Answer</summary>

| Panstwo   | Jezyk      | procent  |
| --------- | ---------- | -------- |
| Etiopia   | oromo      | 35.51308 |
| Indonezja | jawajski   | 32.72516 |
| Pakistan  | pendzabski | 40.44468 |

</details>

### Maj 2019

[View Matura](https://www.korepetycjezinformatyki.pl/wp-content/uploads/nowa-rozszerzona/informatyka-2019-maj-matura-rozszerzona-2.pdf)

#### 6.1

Podaj listę wszystkich nazw perfum, których jednym ze składników jest „absolut jasminu”.

<details>
<summary>Solution</summary>

```sql
SELECT p.nazwa_p
FROM sklad s
JOIN perfumy p ON s.id_perfum = p.id_perfum
WHERE s.nazwa_skladnika = "absolut jasminu"
```

</details>

<details>
<summary>Answer</summary>

| nazwa_p       |
| ------------- |
| Oyal Priather |
| Ologne D'oud  |
| Uelques FleuE |

</details>

#### 6.2

Podaj listę różnych rodzin zapachów. Dla każdej rodziny podaj jej nazwę, cenę najtańszych
perfum z tej rodziny i ich nazwę.

<details>
<summary>Solution - using WITH (CTE - Common Table Expression)</summary>

```sql
WITH najtansze AS (
	SELECT p.rodzina_zapachow, MIN(p.cena) najmniej
	FROM perfumy p
	GROUP BY p.rodzina_zapachow
)
SELECT n.rodzina_zapachow, n.najmniej, p.nazwa_p
FROM najtansze n
JOIN perfumy p ON n.rodzina_zapachow = p.rodzina_zapachow AND n.najmniej = p.cena
```

</details>

<details>
<summary>Solution - using subquery in WHERE</summary>

```sql
SELECT p.rodzina_zapachow, p.cena, p.nazwa_p
FROM perfumy p
WHERE p.cena = (
  SELECT MIN(p2.cena)
	FROM perfumy p2
	WHERE p.rodzina_zapachow = p2.rodzina_zapachow
)
```

</details>

<details>
<summary>Answer</summary>

| rodzina_zapachow      | najmniej | nazwa_p              |
| --------------------- | -------- | -------------------- |
| aromatyczna           | 124      | Ibrary Ollec D'amore |
| cytrusowa             | 259      | Sian Grad            |
| cytrusowo-aromatyczna | 178      | Re Nostrum,ir        |
| drzewna               | 123      | Pperlee Bouquet      |
| kwiatowa              | 110      | Ose Deurmaline       |
| kwiatowo-drzewna      | 104      | Rougna               |
| kwiatowo-orientalna   | 103      | Arla : Vivace        |
| kwiatowo-szyprowa     | 287      | Etish Pothal         |
| orientalna            | 113      | Anille La Tosca      |
| orientalna lagodna    | 122      | Ndy Warhol S Rose    |
| orientalno-drzewna    | 138      | LackNight            |
| owocowa               | 154      | Ake Perfucturne      |
| pudrowa               | 139      | Ivm Cristal          |
| skorzana              | 112      | Ui Mare              |
| szyprowa              | 226      | Usk ti 1888          |
| szyprowo-skorzana     | 158      | Uir OtPlace          |
| wodna                 | 146      | Ilver Mounaya        |
| zielona               | 406      | EOman                |

</details>

#### 6.3

Utwórz uporządkowaną alfabetycznie listę wszystkich nazw marek, które nie zawierają
w swoich perfumach żadnego składnika mającego w nazwie słowo „paczula”.

<details>
<summary>Solution</summary>

```sql
SELECT m.nazwa_m
FROM marki m
WHERE NOT EXISTS (
    SELECT 1
    FROM sklad s
	JOIN perfumy p ON s.id_perfum = p.id_perfum
	WHERE p.id_marki = m.id_marki AND s.nazwa_skladnika LIKE "%paczula%"
)
ORDER BY m.nazwa_m
```

</details>

<details>
<summary>Answer</summary>

| nazwa_m        |
| -------------- |
| Aison Eranciro |
| Arthbey        |
| Embert Lucas   |
| Enmith         |
| Nnick a Kieffo |

</details>

#### 6.4

Ceny wszystkich perfum marki Mou De Rosine z rodziny o nazwie „orientalno-drzewna”
zostały obniżone o 15%. Podaj listę zawierającą wszystkie nazwy takich perfum i ich ceny po
obniżce. Listę posortuj niemalejąco według ceny.

<details>
<summary>Solution</summary>

```sql
SELECT p.nazwa_p, p.cena * 0.85 nowa_cena
FROM perfumy p
JOIN marki m ON p.id_marki = m.id_marki
WHERE m.nazwa_m = "Mou De Rosine" AND p.rodzina_zapachow = "orientalno-drzewna"
ORDER BY nowa_cena
```

</details>

<details>
<summary>Answer</summary>

| nazwa_p           | nowa_cena |
| ----------------- | --------- |
| Ourn Boise        | 141.95    |
| Onou Back         | 222.70    |
| Pic An            | 230.35    |
| Nterl Bambola     | 292.40    |
| Ubilatio Champs   | 381.65    |
| Ibrary Ollec D'or | 489.60    |
| Ate An            | 544.85    |
| Elov & Musc       | 660.45    |

</details>

#### 6.5

Istnieją marki, których wszystkie perfumy należą do tylko jednej rodziny zapachów. Podaj listę
wszystkich nazw takich marek. Lista powinna zawierać nazwy marek i nazwy odpowiednich
rodzin zapachów.

<details>
<summary>Solution</summary>

```sql
SELECT m.nazwa_m, p.rodzina_zapachow
FROM marki m
JOIN perfumy p ON m.id_marki = p.id_marki
GROUP BY m.id_marki
HAVING COUNT(DISTINCT p.rodzina_zapachow) = 1
```

</details>

<details>
<summary>Answer</summary>

| nazwa_m        | rodzina_zapachow    |
| -------------- | ------------------- |
| Ightce         | aromatyczna         |
| X ICologne     | orientalno-drzewna  |
| Nnick a Kieffo | orientalna          |
| Enmith         | kwiatowo-orientalna |
| Issmkunstwerke | orientalna          |

</details>

### Maj 2018

[View Matura](https://www.korepetycjezinformatyki.pl/wp-content/uploads/nowa-rozszerzona/informatyka-2018-maj-matura-rozszerzona-2.pdf)

### Maj 2017

[View Matura](https://www.korepetycjezinformatyki.pl/wp-content/uploads/nowa-rozszerzona/informatyka-2017-maj-matura-rozszerzona-2.pdf)

### Maj 2016

[View Matura](https://www.korepetycjezinformatyki.pl/wp-content/uploads/nowa-rozszerzona/informatyka-2016-maj-matura-rozszerzona-2.pdf)

### Maj 2015

[View Matura](https://www.korepetycjezinformatyki.pl/wp-content/uploads/nowa-rozszerzona/informatyka-2015-maj-matura-rozszerzona-2.pdf)
