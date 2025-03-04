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

### Czerwiec 2024

[View Matura](https://arkusze.pl/maturalne/informatyka-2024-czerwiec-matura-rozszerzona.pdf)

#### 8.1

Dla każdej szczepionki podaj, ile łącznie jej dawek zostało podanych pacjentom. Jako wynik
podaj listę zawierającą kod szczepionki i liczbę dawek. Lista powinna być posortowana
nierosnąco według liczby dawek.

<details>
<summary>Solution</summary>

```sql
SELECT w.kod_szczepionki, COUNT(*) liczba
FROM wizyty w
GROUP BY w.kod_szczepionki
ORDER BY liczba DESC
```

</details>

<details>
<summary>Answer</summary>

| kod_szczepionki | liczba |
| --------------- | ------ |
| sz15_5d         | 111    |
| sz10_4d         | 83     |
| sz21_5d         | 82     |
| sz17_4d         | 81     |
| sz20_5d         | 79     |
| sz9_5d          | 73     |
| sz3_5d          | 72     |
| sz13_5d         | 71     |
| sz1_3d          | 69     |
| sz6_3d          | 64     |
| sz12_3d         | 60     |
| sz7_5d          | 60     |
| sz24_3d         | 59     |
| sz22_3d         | 45     |
| sz18_2d         | 38     |
| sz19_2d         | 35     |
| sz4_2d          | 34     |
| sz8_2d          | 29     |
| sz16_1d         | 28     |
| sz11_1d         | 25     |
| sz23_1d         | 23     |
| sz5_1d          | 23     |
| sz14_1d         | 16     |
| sz2_1d          | 15     |

</details>

#### 8.2

Podaj, ilu różnych pacjentów przyjęło przynajmniej jedną dawkę szczepionki o kodzie
sz12_3d. Podaj, ile wśród nich było kobiet (płeć określa przedostatnia cyfra numeru PESEL,
cyfra parzysta oznacza płeć żeńską).

<details>
<summary>Solution</summary>

```sql
WITH lista AS (
  SELECT w.Pesel
  FROM wizyty w
  WHERE w.kod_szczepionki = "sz12_3d"
  GROUP BY w.Pesel
)
SELECT
  COUNT(*) wszystkich,
  SUM(CASE WHEN SUBSTR(l.Pesel, 10, 1) % 2 = 0 THEN 1 ELSE 0 END) kobiet
FROM lista l
```

</details>

<details>
<summary>Answer</summary>

| wszystkich | kobiet |
| ---------- | ------ |
| 24         | 17     |

</details>

#### 8.3

Podaj rok i miesiąc, w którym najwięcej osób ukończyło szczepienie (czyli: w tym miesiącu
przyjęło ostatnią rekomendowaną dawkę danego szczepienia). Podaj także liczbę osób,
które ukończyły szczepienie w tym terminie.

<details>
<summary>Solution</summary>

```sql
SELECT YEAR(w.data_szczepienia) rok, MONTH(w.data_szczepienia) miesiac, COUNT(*) liczba
FROM wizyty w
JOIN szczepionki s ON w.kod_szczepionki = s.kod_szczepionki
WHERE w.numer_dawki = s.liczba_dawek
GROUP BY rok, miesiac
ORDER BY liczba DESC
LIMIT 1
```

</details>

<details>
<summary>Answer</summary>

| rok  | miesiac | liczba |
| ---- | ------- | ------ |
| 2023 | 5       | 48     |

</details>

#### 8.4

Informacje o szczepieniach rozszerzono o dodatkowe dane:\
• do tabeli WIZYTY dodano pole kod_punktu – określające punkt szczepień, w którym
odbyło się szczepienie\
• dodano tabele PACJENCI i PUNKT_SZCZEPIEN\
• w tabeli PACJENCI podano numer PESEL pacjenta (pesel) i województwo
(województwo_pacjenta), w którym pacjent mieszka\
• w tabeli PUNKT_SZCZEPIEN podano kod punktu (kod_punktu) szczepienia
i województwo (województwo_punktu), w którym znajduje się punkt szczepień.\
Zapisz w języku SQL zapytanie, w którym podasz numery PESEL pacjentów, którzy przyjęli
co najmniej jedną dawkę szczepienia w województwie innym niż to, w którym mieszkają.\
Twoja odpowiedź będzie poprawna, także jeżeli PESEL pacjenta będzie wypisany więcej niż
jeden raz.\

<details>
<summary>Solution</summary>

```sql
SELECT DISTINCT p.pesel
FROM WIZYTY w
JOIN PACJENCI p ON w.pesel = p.pesel
JOIN PUNKT_SZCZEPIEN ps ON w.kod_punktu = ps.kod_punktu
WHERE p.wojewodztwo_pacjenta != w.wojewodztwo_punktu
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

#### 6.1

Znajdź 10 najczęstszych rodzajów dysków (czyli 10 najczęściej występujących pojemności)
wśród komputerów w centrum. Dla każdej ze znalezionych pojemności podaj liczbę
komputerów z takim dyskiem. Posortuj zestawienie nierosnąco względem liczby komputerów
z dyskiem o danej pojemności.

<details>
<summary>Solution</summary>

```sql
SELECT k.Pojemnosc_dysku, COUNT(*) liczba
FROM komputery k
GROUP BY k.Pojemnosc_dysku
ORDER BY liczba DESC
LIMIT 10
```

</details>

<details>
<summary>Answer</summary>

| Pojemnosc_dysku | liczba |
| --------------- | ------ |
| 300             | 173    |
| 200             | 31     |
| 500             | 31     |
| 800             | 29     |
| 700             | 28     |
| 600             | 26     |
| 400             | 20     |
| 290             | 11     |
| 220             | 10     |
| 160             | 10     |

</details>

#### 6.2

Znajdź wszystkie komputery w sekcji A, w których trzeba było przynajmniej dziesięciokrotnie
wymieniać podzespoły. Podaj ich numery, a także liczbę wymian podzespołów dla każdego
z nich.

<details>
<summary>Solution</summary>

```sql
SELECT k.Numer_komputera, COUNT(*) liczba
FROM komputery k
JOIN awarie a ON k.Numer_komputera = a.Numer_komputera
JOIN naprawy n ON a.Numer_zgloszenia = n.Numer_zgloszenia
WHERE k.Sekcja = "A" AND n.Rodzaj = "wymiana"
GROUP BY k.Numer_komputera
HAVING liczba >= 10
```

</details>

<details>
<summary>Answer</summary>

| Numer_komputera | liczba |
| --------------- | ------ |
| 42              | 11     |
| 123             | 11     |
| 171             | 12     |
| 202             | 12     |

</details>

#### 6.3

Pewnego dnia nastąpiła awaria wszystkich komputerów w jednej z sekcji. Podaj datę awarii
oraz symbol sekcji, w której nastąpiła awaria.

<details>
<summary>Solution</summary>

```sql
SELECT k.Sekcja, DATE(a.Czas_awarii) dzien
FROM awarie a
JOIN komputery k ON a.Numer_komputera = k.Numer_komputera
GROUP BY k.Sekcja, DATE(a.Czas_awarii)
HAVING COUNT(*) = (
  SELECT COUNT(*)
  FROM komputery k2
  WHERE k2.Sekcja = k.Sekcja
)
```

</details>

<details>
<summary>Answer</summary>

| Sekcja | dzien      |
| ------ | ---------- |
| Q      | 2015-12-23 |

</details>

#### 6.4

Znajdź awarię, której usunięcie trwało najdłużej (czas liczymy od wystąpienia awarii do
momentu zakończenia ostatniej z napraw, jakiej ta awaria wymagała). Podaj numer zgłoszenia,
czas wystąpienia awarii i czas zakończenia ostatniej naprawy.

<details>
<summary>Solution</summary>

```sql
SELECT a.Numer_zgloszenia, a.Czas_awarii, MAX(n.Czas_naprawy) ostatnia_naprawa
FROM awarie a
JOIN naprawy n ON a.Numer_zgloszenia = n.Numer_zgloszenia
GROUP BY n.Numer_zgloszenia
ORDER BY TIMEDIFF(MAX(n.Czas_naprawy), a.Czas_awarii) DESC
LIMIT 1
```

</details>

<details>
<summary>Answer</summary>

| Numer_zgloszenia | Czas_awarii         | ostatnia_naprawa    |
| ---------------- | ------------------- | ------------------- |
| 2087             | 2015-11-06 12:38:46 | 2015-11-13 12:38:32 |

</details>

#### 6.5

Podaj liczbę komputerów, które nie uległy żadnej awarii o priorytecie większym lub równym
8 (wliczamy w to też komputery, które w ogóle nie uległy awarii).

<details>
<summary>Solution</summary>

```sql
SELECT COUNT(*) liczba
FROM komputery k
LEFT JOIN awarie a ON k.Numer_komputera = a.Numer_komputera AND a.Priorytet >= 8
WHERE a.Numer_zgloszenia IS NULL
```

</details>

<details>
<summary>Answer</summary>

| liczba |
| ------ |
| 149    |

</details>

### Maj 2017

[View Matura](https://www.korepetycjezinformatyki.pl/wp-content/uploads/nowa-rozszerzona/informatyka-2017-maj-matura-rozszerzona-2.pdf)

#### 5.1

a) Podaj, ile towarzyskich, ile ligowych oraz ile pucharowych meczów rozegrała drużyna
Galop Kucykowo z drużynami ze swego miasta.\
b) W którym roku drużyna Galop Kucykowo rozegrała najwięcej meczów z drużynami
ze swego miasta (łącznie wszystkie rodzaje meczów)? Podaj rok i liczbę tych meczów.

<details>
<summary>Solution A</summary>

```sql
SELECT w.Rodzaj_meczu, COUNT(*) liczba
FROM wyniki w
JOIN druzyny d ON w.Id_druzyny = d.Id_druzyny
WHERE d.Miasto = "Kucykowo"
GROUP BY w.Rodzaj_meczu
```

</details>

<details>
<summary>Answer A</summary>

| Rodzaj_meczu | liczba |
| ------------ | ------ |
| L            | 113    |
| P            | 25     |
| T            | 6      |

</details>

<details>
<summary>Solution B</summary>

```sql
SELECT YEAR(w.Data_meczu) rok, COUNT(*) liczba
FROM wyniki w
JOIN druzyny d ON w.Id_druzyny = d.Id_druzyny
WHERE d.Miasto = "Kucykowo"
GROUP BY rok
ORDER BY liczba DESC
LIMIT 1
```

</details>

<details>
<summary>Answer B</summary>

| rok  | liczba |
| ---- | ------ |
| 2007 | 21     |

</details>

#### 5.2

Podaj listę zawierającą nazwy drużyn, z którymi drużyna Galop Kucykowo ma zerowy bilans
bramkowy, tzn. łączna liczba bramek zdobytych we wszystkich meczach rozegranych z daną
drużyną jest równa łącznej liczbie bramek straconych w tych meczach.

<details>
<summary>Solution</summary>

```sql
SELECT d.Nazwa
FROM wyniki w
JOIN druzyny d ON w.Id_druzyny = d.Id_druzyny
GROUP BY d.Id_druzyny
HAVING SUM(w.Bramki_zdobyte) = SUM(w.Bramki_stracone)
```

</details>

<details>
<summary>Answer</summary>

| Nazwa       |
| ----------- |
| Zwinne Mewy |
| Nocne Pumy  |

</details>

#### 5.3

Podaj liczby meczów wyjazdowych – wygranych, przegranych i zremisowanych – przez
drużynę Galop Kucykowo.

<details>
<summary>Solution</summary>

```sql
SELECT
  CASE
    WHEN w.Bramki_zdobyte > w.Bramki_stracone THEN "wygrane"
    WHEN w.Bramki_zdobyte = w.Bramki_stracone THEN "zremisowane"
    ELSE "przegrane"
  END rezultat,
  COUNT(*) liczba
FROM wyniki w
WHERE w.Gdzie = "W"
GROUP BY rezultat
```

</details>

<details>
<summary>Answer</summary>

| rezultat    | liczba |
| ----------- | ------ |
| przegrane   | 452    |
| wygrane     | 579    |
| zremisowane | 170    |

</details>

#### 5.4

Podaj, ilu sędziów spośród tych zapisanych w pliku sedziowie.txt nie sędziowało
żadnego pucharowego meczu drużyny Galop Kucykowo.

<details>
<summary>Solution</summary>

```sql
SELECT COUNT(*) liczba
FROM sedziowie s
LEFT JOIN wyniki w ON w.Nr_licencji = s.Nr_licencji AND w.Rodzaj_meczu = "P"
WHERE w.Id_meczu IS NULL
```

</details>

<details>
<summary>Answer</summary>

| liczba |
| ------ |
| 22     |

</details>

### Maj 2016

[View Matura](https://www.korepetycjezinformatyki.pl/wp-content/uploads/nowa-rozszerzona/informatyka-2016-maj-matura-rozszerzona-2.pdf)

#### 5.1

Podaj imię i nazwisko osoby, która wypożyczyła najwięcej podręczników. Wypisz tytuły
wszystkich książek przez nią wypożyczonych.

<details>
<summary>Solution</summary>

```sql
WITH najwiecej_wypozyczen AS (
  SELECT w.pesel
  FROM wypozyczenia w
  GROUP BY w.pesel
  ORDER BY COUNT(*) DESC
  LIMIT 1
)
SELECT s.imie, s.nazwisko, w.tytul
FROM wypozyczenia w
JOIN studenci s ON w.pesel = s.pesel
WHERE s.pesel = (SELECT nw.pesel FROM najwiecej_wypozyczen nw);
```

</details>

<details>
<summary>Answer</summary>

| imie      | nazwisko    | tytul                   |
| --------- | ----------- | ----------------------- |
| KRZYSZTOF | LEWANDOWSKI | TEORIA GRAFOW           |
| KRZYSZTOF | LEWANDOWSKI | JEZYKI PROGRAMOWANIA II |
| KRZYSZTOF | LEWANDOWSKI | METODY NUMERYCZNE II    |
| KRZYSZTOF | LEWANDOWSKI | FLASH I PHP             |

</details>

#### 5.2

Podaj średnią liczbę osób zameldowanych w jednym pokoju. Wynik zaokrąglij
do 4 miejsc po przecinku.

<details>
<summary>Solution</summary>

```sql
SELECT ROUND(AVG(liczba_osob), 4) srednia
FROM (
  SELECT m.id_pok, COUNT(*) liczba_osob
  FROM meldunek m
  GROUP BY m.id_pok
) AS pokoje
```

</details>

<details>
<summary>Answer</summary>

| srednia |
| ------- |
| 4.7101  |

</details>

#### 5.3

W numerze PESEL zawarta jest informacja o płci osoby. Jeżeli przedostatnia cyfra numeru
jest parzysta, to PESEL należy do kobiety, jeśli nieparzysta, to do mężczyzny.
Podaj liczbę kobiet i liczbę mężczyzn wśród studentów.

<details>
<summary>Solution</summary>

```sql
SELECT
  CASE
    WHEN (SUBSTR(s.pesel, 10, 1)) % 2 = 0 THEN "kobiet"
    ELSE "mezczyzn"
  END plec,
  COUNT(*) liczba
FROM studenci s
GROUP BY plec
```

</details>

<details>
<summary>Answer</summary>

| plec     | liczba |
| -------- | ------ |
| kobiet   | 138    |
| mezczyzn | 192    |

</details>

#### 5.4

Podaj nazwiska i imiona studentów, którzy nie mieszkają w pokojach w miasteczku
akademickim. Listę posortuj alfabetycznie wg nazwisk.

<details>
<summary>Solution</summary>

```sql
SELECT s.nazwisko, s.imie
FROM studenci s
LEFT JOIN meldunek m ON s.pesel = m.pesel
WHERE m.id_pok IS NULL
ORDER BY s.nazwisko
```

</details>

<details>
<summary>Answer</summary>

| nazwisko      | imie   |
| ------------- | ------ |
| DYLAG         | JACEK  |
| NAJDA         | PIOTR  |
| PIETRASZEWSKI | STEFAN |
| SIECZKOWSKI   | MACIEJ |
| ZALESKA       | JULIA  |

</details>

#### 5.5

Biblioteka planuje wprowadzenie zakazu wypożyczania kilku egzemplarzy tego samego
tytułu podręcznika studentom mieszkającym w jednym pokoju. Gdy ta zasada będzie
obowiązywać, w żadnym pokoju nie powtórzy się żaden tytuł podręcznika.
Podaj, ile byłoby wypożyczonych podręczników, gdyby takie ograniczenie już
funkcjonowało.

<details>
<summary>Solution</summary>

```sql
SELECT SUM(liczba_ksiazek) liczba
FROM (
  SELECT m.id_pok, COUNT(DISTINCT w.tytul) liczba_ksiazek
  FROM wypozyczenia w
  LEFT JOIN meldunek m ON w.pesel = m.pesel
  GROUP BY m.id_pok
) AS ksiazki
```

</details>

<details>
<summary>Answer</summary>

| liczba |
| ------ |
| 316    |

</details>

### Maj 2015

[View Matura](https://www.korepetycjezinformatyki.pl/wp-content/uploads/nowa-rozszerzona/informatyka-2015-maj-matura-rozszerzona-2.pdf)

#### 6.1

Podaj sezon i nazwę wyścigu Grand Prix, w którym Robert Kubica zdobył najwięcej
punktów.

<details>
<summary>Solution</summary>

```sql
SELECT r.Rok, r.GrandPrix
FROM wyniki w
JOIN kierowcy k ON w.Id_kierowcy = k.Id_kierowcy
JOIN wyscigi r ON w.Id_wyscigu = r.Id_wyscigu
WHERE k.Imie = "Robert" AND k.Nazwisko = "Kubica"
ORDER BY w.Punkty DESC
LIMIT 1
```

</details>

<details>
<summary>Answer</summary>

| Rok  | GrandPrix |
| ---- | --------- |
| 2010 | Australia |

</details>

#### 6.2

W których z miejsc podanych w plikach rozegrano najmniejszą liczbę wyścigów Grand Prix
w latach 2000–2012?

<details>
<summary>Solution</summary>

```sql
SELECT w.GrandPrix
FROM wyscigi w
GROUP BY w.GrandPrix
ORDER BY COUNT(*)
LIMIT 1
```

</details>

<details>
<summary>Answer</summary>

| GrandPrix |
| --------- |
| Indie     |

</details>

#### 6.3

Klasyfikacja generalna w danym sezonie jest tworzona na podstawie sumy punktów
uzyskanych przez kierowców w wyścigach rozegranych w tym sezonie. Utwórz zestawienie
zawierające nazwiska i imiona kierowców – zwycięzców klasyfikacji generalnej w sezonach
2000, 2006 i 2012 wraz z liczbami punktów przez nich uzyskanymi.

<details>
<summary>Solution</summary>

```sql
WITH suma_punktow AS (
  SELECT r.Rok, k.Imie, k.Nazwisko, SUM(w.Punkty) liczba_punktow
  FROM wyniki w
  JOIN wyscigi r ON w.Id_wyscigu = r.Id_wyscigu
  JOIN kierowcy k ON w.Id_kierowcy = k.Id_kierowcy
  WHERE r.Rok IN (2000, 2006, 2012)
  GROUP BY r.Rok, k.Id_kierowcy
),
zwyciezcy AS (
  SELECT sp.Rok, MAX(sp.liczba_punktow) punkty
  FROM suma_punktow sp
  GROUP BY sp.Rok
)
SELECT r.Rok, k.Imie, k.Nazwisko, SUM(w.Punkty) punkty
FROM wyniki w
JOIN kierowcy k ON w.Id_kierowcy = k.Id_kierowcy
JOIN wyscigi r ON w.Id_wyscigu = r.Id_wyscigu
GROUP BY r.Rok, k.Id_kierowcy
HAVING punkty = (
  SELECT z.punkty FROM zwyciezcy z WHERE z.Rok = r.Rok
)
```

</details>

<details>
<summary>Answer</summary>

| Rok  | Imie      | Nazwisko   | punkty |
| ---- | --------- | ---------- | ------ |
| 2000 | Michael   | Schumacher | 108    |
| 2006 | Fernando  | Alonso     | 134    |
| 2012 | Sebastian | Vettel     | 281    |

</details>

#### 6.4

Dla każdego kraju, którego reprezentanci zdobywali punkty w sezonie 2012, podaj liczbę tych
reprezentantów.

<details>
<summary>Solution</summary>

```sql
SELECT k.Kraj, COUNT(DISTINCT k.Id_kierowcy) liczba
FROM wyniki w
JOIN kierowcy k ON w.Id_kierowcy = k.Id_kierowcy
JOIN wyscigi r ON w.Id_wyscigu = r.Id_wyscigu
WHERE r.Rok = 2012
GROUP BY k.Kraj
```

</details>

<details>
<summary>Answer</summary>

| Kraj            | liczba |
| --------------- | ------ |
| Australia       | 2      |
| Brazylia        | 2      |
| Finlandia       | 1      |
| Francja         | 2      |
| Hiszpania       | 1      |
| Japonia         | 1      |
| Meksyk          | 1      |
| Niemcy          | 4      |
| Wenezuela       | 1      |
| Wielka Brytania | 3      |

</details>

### Czerwiec 2022

[View Matura](https://www.korepetycjezinformatyki.pl/wp-content/uploads/matury-czerwiec/informatyka-2022-czerwiec-matura-rozszerzona-2.pdf)

#### 6.1

Ile meczów zakończyło się tzw. tie-breakiem, czyli rozegrano w nich dokładnie pięć setów?

<details>
<summary>Solution</summary>

```sql
SELECT COUNT(*) liczba
FROM mecze m
WHERE m.Sety_wygrane + m.Sety_przegrane = 5
```

</details>

<details>
<summary>Answer</summary>

| liczba |
| ------ |
| 109    |

</details>

#### 6.2

Utwórz zestawienie miast z liczbą rozegranych w nich meczów. Wyniki posortuj
od największej liczby meczów do najmniejszej.

<details>
<summary>Solution</summary>

```sql
SELECT k.Miasto, COUNT(*) liczba
FROM mecze m
JOIN kluby k ON m.Id_klubu = k.Id_klubu
GROUP BY k.Miasto
ORDER BY liczba DESC
```

</details>

<details>
<summary>Answer</summary>

| Miasto     | liczba |
| ---------- | ------ |
| Wiralow    | 41     |
| Kukurykow  | 39     |
| Szymbark   | 32     |
| Preziowo   | 30     |
| Bialowo    | 21     |
| Gorkowo    | 18     |
| Kielkowo   | 17     |
| Licowo     | 15     |
| Radelko    | 15     |
| Sadelko    | 15     |
| Koszalkowo | 15     |
| Orecin     | 14     |
| Barylkowo  | 14     |
| Rezkow     | 13     |
| Warkowo    | 13     |
| Lewkowo    | 12     |

</details>

#### 6.3

Podaj imiona i nazwiska sędziów, którzy poprowadzili więcej spotkań (meczów) niż średnia
liczba spotkań przeprowadzonych przez jednego sędziego.

<details>
<summary>Comment</summary>

The question asks for the first name and last name of the referees, but to get full points, we also need to include the number of matches each referee officiated. The expected answer format includes this extra column, so without it, we’d only get 2 out of 3 points - which feels a bit unfair.

</details>

<details>
<summary>Solution (mine)</summary>

```sql
WITH srednia AS (
  SELECT COUNT(*) / (SELECT COUNT(*) FROM sedziowie) sr
  FROM mecze
)
SELECT s.Imie, s.Nazwisko
FROM mecze m
JOIN sedziowie s ON m.Id_sedziego = s.Id_sedziego
GROUP BY s.Id_sedziego
HAVING COUNT(*) > (SELECT sr FROM srednia)
```

</details>

<details>
<summary>Answer (mine)</summary>

| Imie       | Nazwisko  |
| ---------- | --------- |
| Szymon     | Rutkowski |
| Natalia    | Jankowska |
| Kamila     | Majewska  |
| Franciszek | Dudek     |
| Monika     | Kowalczyk |
| Barbara    | Kaczmarek |
| Katarzyna  | Olszewska |

</details>

<details>
<summary>Solution (theirs - expected)</summary>

```sql
WITH srednia AS (
  SELECT COUNT(*) / (SELECT COUNT(*) FROM sedziowie) sr
  FROM mecze
)
SELECT s.Imie, s.Nazwisko, COUNT(*) liczba
FROM mecze m
JOIN sedziowie s ON m.Id_sedziego = s.Id_sedziego
GROUP BY s.Id_sedziego
HAVING liczba > (SELECT sr FROM srednia)
```

</details>

<details>
<summary>Answer (theirs - expected)</summary>

| Imie       | Nazwisko  | liczba |
| ---------- | --------- | ------ |
| Szymon     | Rutkowski | 21     |
| Natalia    | Jankowska | 36     |
| Kamila     | Majewska  | 21     |
| Franciszek | Dudek     | 27     |
| Monika     | Kowalczyk | 26     |
| Barbara    | Kaczmarek | 21     |
| Katarzyna  | Olszewska | 25     |

</details>

#### 6.4

Podaj imiona i nazwiska sędziów, którzy nie prowadzili żadnego spotkania (meczu) ani
w Licowie („Licowo”), ani w Szymbarku (”Szymbark”) w okresie od 15 października 2019 roku
do 15 grudnia 2019 roku.

<details>
<summary>Solution</summary>

```sql
WITH spotkania AS (
  SELECT m.Id_meczu, m.Id_sedziego
  FROM mecze m
  JOIN kluby k ON m.Id_klubu = k.Id_klubu
  WHERE k.Miasto IN ("Licowo", "Szymbark") AND m.Data BETWEEN "2019-10-15" AND "2019-12-15"
)
SELECT s.Imie, s.Nazwisko
FROM sedziowie s
LEFT JOIN spotkania sp ON s.Id_sedziego = sp.Id_sedziego
WHERE sp.Id_meczu IS NULL
```

</details>

<details>Solution 2</summary>

```sql
SELECT s.Imie, s.Nazwisko
FROM sedziowie s
WHERE NOT EXISTS (
  SELECT 1
  FROM mecze m
  JOIN kluby k ON m.Id_klubu = k.Id_klubu
  WHERE k.Miasto IN ("Licowo", "Szymbark")
    AND m.Data BETWEEN "2019-10-15" AND "2019-12-15"
    AND m.Id_sedziego = s.Id_sedziego
)
```

</details>

<details>
<summary>Answer</summary>

| Imie       | Nazwisko    |
| ---------- | ----------- |
| Jan        | Malinowski  |
| Anna       | Nowak       |
| Agnieszka  | Wieczorek   |
| Kamila     | Majewska    |
| Piotr      | Lewandowski |
| Franciszek | Dudek       |
| Barbara    | Kaczmarek   |
| Zofia      | Grabowska   |

</details>

#### 6.5

Spotkanie (mecz) jest wygrane, jeśli liczba wygranych setów w tym spotkaniu jest większa
niż liczba setów przegranych. Utwórz zestawienie klubów, w przypadku których liczba
wygranych spotkań jest większa lub równa liczbie spotkań przegranych. Dla każdego takiego
klubu podaj jego nazwę, miasto oraz liczby spotkań wygranych i przegranych.

<details>
<summary>Solution</summary>

```sql
WITH wyniki AS (
  SELECT m.Id_klubu,
  CASE WHEN m.Sety_wygrane > m.Sety_przegrane THEN "wygrane" ELSE "przegrane" END wynik
  FROM mecze m
)
SELECT
  k.Nazwa, k.Miasto,
  SUM(CASE WHEN w.wynik = "wygrane" THEN 1 ELSE 0 END) wygranych,
  SUM(CASE WHEN w.wynik = "przegrane" THEN 1 ELSE 0 END) przegranych
FROM wyniki w
JOIN kluby k ON w.Id_klubu = k.Id_klubu
GROUP BY w.Id_klubu
HAVING wygranych >= przegranych
```

</details>

<details>
<summary>Solution 2</summary>

```sql
SELECT
  k.Nazwa, k.Miasto,
  SUM(CASE WHEN m.Sety_wygrane > m.Sety_przegrane THEN 1 ELSE 0 END) wygranych,
  SUM(CASE WHEN m.Sety_wygrane < m.Sety_przegrane THEN 1 ELSE 0 END) przegranych
FROM mecze m
JOIN kluby k ON m.Id_klubu = k.Id_klubu
GROUP BY k.Id_klubu
HAVING wygranych >= przegranych
```

</details>

<details>
<summary>Answer</summary>

| Nazwa       | Miasto    | wygranych | przegranych |
| ----------- | --------- | --------- | ----------- |
| Sfinks      | Szymbark  | 9         | 7           |
| Zenit       | Licowo    | 8         | 7           |
| Victoria    | Radelko   | 10        | 5           |
| Zjednoczeni | Kukurykow | 10        | 8           |
| Olimpia     | Orecin    | 9         | 5           |
| Stolar      | Wiralow   | 11        | 9           |
| Astecja     | Rezkow    | 10        | 3           |
| Bradownia   | Preziowo  | 9         | 9           |
| Spirca      | Lewkowo   | 6         | 6           |
| Huraganer   | Szymbark  | 8         | 8           |
| Waleczni    | Preziowo  | 7         | 5           |
| Libero      | Warkowo   | 8         | 5           |

</details>

### Czerwiec 2021

[View Matura](https://www.korepetycjezinformatyki.pl/wp-content/uploads/matury-czerwiec/informatyka-2021-czerwiec-matura-rozszerzona-2.pdf)

#### 6.1

Ile koncertów odbyło się w lipcu?

<details>
<summary>Solution</summary>

```sql
SELECT COUNT(*) liczba
FROM koncerty k
WHERE MONTH(k.data) = 7
```

</details>

<details>
<summary>Answer</summary>

| liczba |
| ------ |
| 122    |

</details>

#### 6.2

Podaj nazwę miasta, w którym wystąpiło łącznie najwięcej artystów (wykonawców). Jeżeli
miast, w których wystąpiła największa liczba artystów jest więcej niż jedno, podaj nazwy ich
wszystkich.\
**Uwaga**: artystę, który w danym mieście wystąpił ze swoim zespołem kilkakrotnie, liczymy tylko
raz.

<details>
<summary>Solution</summary>

```sql
WITH sq1 AS (
  SELECT k.kod_miasta, z.id_zespolu, z.liczba_artystow
  FROM koncerty k
  JOIN zespoly z ON k.id_zespolu = z.id_zespolu
  GROUP BY k.kod_miasta, z.id_zespolu
),
sq2 AS (
  SELECT sq1.kod_miasta, SUM(sq1.liczba_artystow) liczba
  FROM sq1
  GROUP BY sq1.kod_miasta
)
SELECT m.miasto
FROM sq2 s
JOIN miasta m ON s.kod_miasta = m.kod_miasta
WHERE s.liczba = (SELECT MAX(sq2.liczba) FROM sq2)
```

</details>

<details>
<summary>Answer</summary>

| miasto               |
| -------------------- |
| Grudziadz            |
| Piotrkow Trybunalski |

</details>

#### 6.3

Wykonaj zestawienie, w którym dla każdego województwa podasz średnią liczbę koncertów
w przeliczeniu na jedno miasto w tym województwie. Wyniki podaj w zaokrągleniu do dwóch
miejsc po przecinku i posortuj od najwyższej do najniższej średniej.

<details>
<summary>Solution</summary>

```sql
WITH sq1 AS (
  SELECT m.wojewodztwo, COUNT(*) liczba_miast
  FROM miasta m
  GROUP BY m.wojewodztwo
),
sq2 AS (
  SELECT m.wojewodztwo, COUNT(*) liczba_koncertow
  FROM koncerty k
  JOIN miasta m ON k.kod_miasta = m.kod_miasta
  GROUP BY m.wojewodztwo
)
SELECT sq1.wojewodztwo, ROUND(sq2.liczba_koncertow / sq1.liczba_miast, 2) srednia
FROM sq1
JOIN sq2 ON sq1.wojewodztwo = sq2.wojewodztwo
ORDER BY srednia DESC
```

</details>

<details>
<summary>Solution 2</summary>

```sql
SELECT
  m.wojewodztwo,
  ROUND(COUNT(DISTINCT k.id) / COUNT(DISTINCT m.kod_miasta), 2) srednia
FROM miasta m
LEFT JOIN koncerty k ON k.kod_miasta = m.kod_miasta
GROUP BY m.wojewodztwo
ORDER BY srednia DESC
```

</details>

<details>
<summary>Answer</summary>

| wojewodztwo         | srednia |
| ------------------- | ------- |
| swietokrzyskie      | 8.00    |
| lodzkie             | 7.00    |
| opolskie            | 7.00    |
| lubuskie            | 6.50    |
| slaskie             | 5.53    |
| malopolskie         | 5.33    |
| lubelskie           | 5.00    |
| podkarpackie        | 5.00    |
| dolnoslaskie        | 4.75    |
| kujawsko-pomorskie  | 4.25    |
| wielkopolskie       | 4.25    |
| podlaskie           | 4.00    |
| warminsko-mazurskie | 4.00    |
| zachodniopomorskie  | 4.00    |
| mazowieckie         | 2.67    |
| pomorskie           | 2.67    |

</details>

#### 6.4

Podaj nazwy zespołów, które nie koncertowały w okresie od 20 lipca do 25 lipca włącznie.

<details>
<summary>Solution</summary>

```sql
SELECT z.nazwa
FROM zespoly z
LEFT JOIN koncerty k ON z.id_zespolu = k.id_zespolu AND k.data BETWEEN "2017-07-20" AND "2017-07-25"
WHERE k.id IS NULL
```

</details>

<details>
<summary>Answer</summary>

| nazwa               |
| ------------------- |
| Male nutki          |
| Stare mandoliny     |
| Wiosenne bebny      |
| Powolne fortepiany  |
| Ciche organy        |
| Fajne trojkaty      |
| Rozstrojone pianina |
| Metalowe klarnety   |
| Zlote saksofony     |
| Piszczace trabki    |

</details>

#### 6.5

Podaj nazwy zespołów, które częściej koncertowały w weekendy (sobota, niedziela) niż w dni
powszednie (od poniedziałku do piątku). Dla każdego z tych zespołów podaj liczbę koncertów
w weekendy oraz liczbę koncertów w dni powszednie.

<details>
<summary>Solution</summary>

```sql
SELECT
  z.nazwa,
  COUNT(CASE WHEN WEEKDAY(k.data) BETWEEN 0 AND 4 THEN 1 END) powszedni,
  COUNT(CASE WHEN WEEKDAY(k.data) BETWEEN 5 AND 6 THEN 1 END) weekend
FROM koncerty k
JOIN zespoly z ON k.id_zespolu = z.id_zespolu
GROUP BY z.id_zespolu
HAVING weekend > powszedni
```

</details>

<details>
<summary>Answer</summary>

| nazwa                 | powszedni | weekend |
| --------------------- | --------- | ------- |
| Niebieskie kontrabasy | 1         | 4       |
| Wiosenne bebny        | 3         | 4       |
| Powolne fortepiany    | 4         | 5       |

</details>

### Czerwiec 2020

[View Matura](https://www.korepetycjezinformatyki.pl/wp-content/uploads/matury-czerwiec/informatyka-2020-czerwiec-matura-rozszerzona-2.pdf)

#### 6.1

Podaj liczbę kobiet i liczbę mężczyzn uczestniczących w ankiecie. Możesz wykorzystać fakt,
że w danych imiona wszystkich kobiet (i tylko kobiet) kończą się literą „a”.

<details>
<summary>Solution</summary>

```sql
SELECT
  CASE WHEN a.Imie LIKE "%a" THEN "kobiety" ELSE "mezczyzni" END plec,
  COUNT(*) liczba
FROM dane_ankiet a
GROUP BY plec
```

</details>

<details>
<summary>Answer</summary>

| plec      | liczba |
| --------- | ------ |
| kobiety   | 161    |
| mezczyzni | 119    |

</details>

#### 6.2

Utwórz zestawienie zawierające nazwy poszczególnych środków lokomocji oraz liczby
ankietowanych z województwa mazowieckiego korzystających z nich latem.

<details>
<summary>Solution</summary>

```sql
WITH korzystajacy AS (
  SELECT l.Srod_lok, COUNT(*) liczba
  FROM lok l
  JOIN dane_ankiet a ON l.Id = a.Id
  WHERE l.Pora_roku = "lato" AND a.Wojewodztwo = "Mazowieckie"
  GROUP BY l.Srod_lok
)
SELECT DISTINCT l.Srod_lok, k.liczba
FROM lok l
LEFT JOIN korzystajacy k ON l.Srod_lok = k.Srod_lok
```

</details>

<details>
<summary>Answer</summary>

| Srod_lok | liczba |
| -------- | ------ |
| autobus  | 1      |
| pociag   | 5      |
| rower    | 13     |
| samochod | 4      |
| tramwaj  | 20     |

</details>

#### 6.3

Utwórz zestawienie zawierające nazwy województw, w których w badaniu wzięło udział
więcej niż 20 osób. Dla każdego z tych województw podaj liczbę ankietowanych osób.

<details>
<summary>Solution</summary>

```sql
SELECT a.Wojewodztwo, COUNT(*) liczba
FROM dane_ankiet a
GROUP BY a.Wojewodztwo
HAVING liczba > 20
```

</details>

<details>
<summary>Answer</summary>

| Wojewodztwo   | liczba |
| ------------- | ------ |
| Dolnoslaskie  | 30     |
| Mazowieckie   | 43     |
| Slaskie       | 23     |
| Wielkopolskie | 30     |

</details>

#### 6.4

Znajdź ankietowanych, którzy są w wieku powyżej 50 lat, mają wykształcenie wyższe
(wyzsze) lub średnie (srednie) oraz nie interesują się ani informatyką (informatyka),
ani grami komputerowymi (gry komputerowe). Utwórz zestawienie (posortowane
alfabetycznie według nazwiska) zawierające imiona i nazwiska tych ankietowanych oraz
nazwy województw, z których oni pochodzą. W zestawieniu dane każdej osoby mogą wystąpić
tylko raz.

<details>
<summary>Solution</summary>

```sql
SELECT a.Imie, a.Nazwisko, a.Wojewodztwo
FROM dane_ankiet a
WHERE a.Wiek > 50
  AND a.Wyksztalcenie IN ("wyzsze", "srednie")
  AND NOT EXISTS (
    SELECT 1
    FROM zain z
    WHERE z.Id = a.Id
      AND z.Zainteresowania IN ("informatyka", "gry komputerowe")
  )
ORDER BY a.Nazwisko
```

</details>

<details>
<summary>Answer</summary>

| Imie      | Nazwisko      | Wojewodztwo           |
| --------- | ------------- | --------------------- |
| Maria     | Bobowik       | Lubelskie             |
| Elzbieta  | Borowska      | Malopolskie           |
| Anna      | Borowska      | Malopolskie           |
| Sebastian | Busma         | Lubuskie              |
| Marta     | Czajewska     | Pomorskie             |
| Barbara   | Dziegielewska | Pomorskie             |
| Piotr     | Gawkowski     | Podkarpackie          |
| Kamila    | Glowacka      | Swietokrzyskie        |
| Andrzej   | Iwaszczuk     | Mazowieckie           |
| Michal    | Janasz        | Mazowieckie           |
| Justyna   | Jankowska     | Mazowieckie           |
| Marcin    | Jasinski      | Mazowieckie           |
| Grzegorz  | Kanadys       | Warminsko - Mazurskie |
| Katarzyna | Karwowska     | Mazowieckie           |
| Marta     | Kimsza        | Pomorskie             |
| Klara     | Klimaszewska  | Dolnoslaskie          |
| Emilia    | Kobeszko      | Lubelskie             |
| Maria     | Korol         | Malopolskie           |
| Piotr     | Korzunowicz   | Dolnoslaskie          |
| Karolina  | Kozlowska     | Mazowieckie           |
| Monika    | Krasowska     | Lubelskie             |

</details>

#### 6.5

Podaj średni dochód kobiet z województwa zachodniopomorskiego, dla których jednym ze
środków lokomocji jest rower.

<details>
<summary>Solution</summary>

```sql
SELECT AVG(a.Dochod) srednia
FROM dane_ankiet a
WHERE a.Imie LIKE "%a"
  AND a.Wojewodztwo = "Zachodniopomorskie"
  AND EXISTS (
    SELECT 1
    FROM lok l
    WHERE l.Id = a.Id AND l.Srod_lok = "rower"
  )
```

</details>

<details>
<summary>Answer</summary>

| srednia   |
| --------- |
| 3250.0000 |

</details>

### Czerwiec 2019

[View Matura](https://www.korepetycjezinformatyki.pl/wp-content/uploads/matury-czerwiec/informatyka-2019-czerwiec-matura-rozszerzona-2.pdf)

#### 6.1

Która oferta wzbudziła zainteresowanie największej liczby klientów? Podaj jej identyfikator
oraz imię i nazwisko agenta, który się nią zajmował. Jest tylko jedna taka oferta.

<details>
<summary>Solution</summary>

```sql
SELECT z.Id_oferty, a.Imie, a.Nazwisko
FROM zainteresowanie z
JOIN oferty o ON z.Id_oferty = o.Id_oferty
JOIN agenci a ON o.Id_agenta = a.Id_agenta
GROUP BY o.Id_oferty
ORDER BY COUNT(*) DESC
LIMIT 1
```

</details>

<details>
<summary>Answer</summary>

| Id_oferty | Imie  | Nazwisko |
| --------- | ----- | -------- |
| AB553DN   | Karol | Zakowicz |

</details>

#### 6.2

Podaj średnią cenę ofert w każdym województwie. Zestawienie uporządkuj alfabetycznie
według nazw województw. Wyniki podaj z dokładnością do dwóch miejsc po przecinku.

<details>
<summary>Solution</summary>

```sql
SELECT o.Woj, ROUND(AVG(o.Cena), 2) srednia
FROM oferty o
GROUP BY o.Woj
ORDER BY o.Woj
```

</details>

<details>
<summary>Answer</summary>

| Woj                 | srednia   |
| ------------------- | --------- |
| dolnoslaskie        | 345000.00 |
| kujawsko-pomorskie  | 299000.00 |
| lodzkie             | 304100.00 |
| lubelskie           | 260879.33 |
| lubuskie            | 227283.33 |
| malopolskie         | 650000.00 |
| mazowieckie         | 267082.83 |
| opolskie            | 400000.00 |
| podkarpackie        | 301312.50 |
| podlaskie           | 271206.95 |
| pomorskie           | 414150.00 |
| swietokrzyskie      | 319207.63 |
| warminsko-mazurskie | 132450.00 |
| wielkopolskie       | 298600.00 |
| zachodniopomorskie  | 269025.20 |

</details>

#### 6.3

Którzy agenci mają aktualne oferty mieszkań z basenem? Przygotuj zestawienie, które będzie
zawierało następujące elementy: imię i nazwisko agenta opiekującego się daną ofertą,
identyfikator oferty, województwo, powierzchnię i cenę mieszkania w danej ofercie.

<details>
<summary>Solution</summary>

```sql
SELECT a.Imie, a.Nazwisko, o.Id_oferty, o.Woj, o.Pow, o.Cena
FROM oferty o
JOIN agenci a ON o.Id_agenta = a.Id_agenta
WHERE o.Id_oferty LIKE "%MT" AND o.Status = "A"
```

</details>

<details>
<summary>Answer</summary>

| Imie      | Nazwisko  | Id_oferty | Woj           | Pow | Cena   |
| --------- | --------- | --------- | ------------- | --- | ------ |
| Adam      | Nowak     | AB557MT   | lubelskie     | 83  | 349000 |
| Adam      | Nowak     | AB695MT   | podkarpackie  | 162 | 420800 |
| Adam      | Nowak     | AB702MT   | mazowieckie   | 49  | 186000 |
| Milena    | Karwik    | AB691MT   | lubuskie      | 39  | 170000 |
| Piotr     | Kopacz    | AB543MT   | podlaskie     | 85  | 325000 |
| Krzysztof | Nowak     | AB700MT   | mazowieckie   | 85  | 265000 |
| Karol     | Zakowicz  | AB644MT   | mazowieckie   | 76  | 174500 |
| Karol     | Szwarc    | AB699MT   | lodzkie       | 68  | 190500 |
| Rozalia   | Siedlecka | AB696MT   | wielkopolskie | 42  | 160000 |

</details>

#### 6.4

Podaj imiona i nazwiska agentów, którzy spośród swoich ofert z 2017 roku nie sprzedali
żadnego domu ani mieszkania.

<details>
<summary>Solution</summary>

```sql
SELECT DISTINCT a.Imie, a.Nazwisko
FROM oferty o
JOIN agenci a ON o.Id_agenta = a.Id_agenta
WHERE NOT EXISTS (
  SELECT 1
  FROM oferty o2
  WHERE o2.Id_agenta = a.Id_agenta
  AND YEAR(o2.Data_zglosz) = 2017
  AND o2.Status = "S"
)
```

</details>

<details>
<summary>Answer</summary>

| Imie      | Nazwisko     |
| --------- | ------------ |
| Milena    | Karwik       |
| Jerzy     | Andrzejewski |
| Krzysztof | Nowak        |

</details>

#### 6.5

Podaj listę aktualnych ofert sprzedaży tych domów i mieszkań, które mają powierzchnię
powyżej 180 m2 i co najmniej 2 łazienki. W zestawieniu uwzględnij identyfikator oferty,
powierzchnię nieruchomości, liczbę pokoi i liczbę łazienek, cenę oraz imię i nazwisko agenta
opiekującego się daną ofertą.

<details>
<summary>Solution</summary>

```sql
SELECT o.Id_oferty, o.Pow, o.L_pokoi, o.L_laz, o.Cena, a.Imie, a.Nazwisko
FROM oferty o
JOIN agenci a ON o.Id_agenta = a.Id_agenta
WHERE o.Status = "A" AND o.Pow > 180 AND o.L_laz >= 2
```

</details>

<details>

<summary>Answer</summary>

| Id_oferty | Pow | L_pokoi | L_laz | Cena   | Imie      | Nazwisko |
| --------- | --- | ------- | ----- | ------ | --------- | -------- |
| AB680DT   | 220 | 6       | 2     | 520000 | Adam      | Nowak    |
| AB682DN   | 203 | 5       | 3     | 485000 | Adam      | Nowak    |
| AB686MN   | 192 | 6       | 2     | 375000 | Adam      | Nowak    |
| AB672DT   | 212 | 6       | 2     | 575000 | Sebastian | Babij    |
| AB683DN   | 195 | 5       | 2     | 395800 | Piotr     | Kopacz   |
| AB692DT   | 244 | 8       | 3     | 650000 | Piotr     | Kopacz   |
| AB666DN   | 220 | 6       | 3     | 450000 | Krzysztof | Nowak    |
| AB693DN   | 182 | 7       | 2     | 425000 | Krzysztof | Nowak    |
| AB670DN   | 208 | 5       | 3     | 358400 | Karol     | Zakowicz |
| AB694DN   | 212 | 8       | 3     | 630000 | Karol     | Szwarc   |
| AB697DN   | 195 | 6       | 2     | 460000 | Karol     | Szwarc   |

</details>

### Czerwiec 2018

[View Matura](https://www.korepetycjezinformatyki.pl/wp-content/uploads/matury-czerwiec/informatyka-2018-czerwiec-matura-rozszerzona-2.pdf)

#### 6.1

Utwórz zestawienie zawierające następujące informacje: imię, nazwisko, nr rejestracyjny
samochodu, czas wypożyczenia (różnica między datą wypożyczenia i datą zwrotu – liczba dób),
należność za wypożyczenie. Wiersze posortuj rosnąco według nazwiska klienta, a następnie –
według imienia klienta i numeru rejestracyjnego samochodu. Podaj pierwszy i ostatni wiersz
z uzyskanej tabeli.
**Uwaga**: dla daty wypożyczenia 2015-05-24 i daty zwrotu 2015-05-28 czas wypożyczenia to
4 doby.

<details>
<summary>Solution</summary>

```sql
(
  SELECT k.Imie, k.Nazwisko, s.Nr_rej,
    DATEDIFF(w.Zwrot, w.Wypozyczenie) czas,
    c.Cena * DATEDIFF(w.Zwrot, w.Wypozyczenie) cena
  FROM wypozyczenia w
  JOIN samochody s ON w.Nr_ew = s.Nr_ew
  JOIN klienci k ON w.Nr_klienta = k.Nr_klienta
  JOIN ceny_za_dobe c ON LEFT(s.Nr_firmowy, 1) = c.Klasa
  ORDER BY k.Nazwisko, k.Imie, s.Nr_rej
  LIMIT 1
)
UNION
(
  SELECT k.Imie, k.Nazwisko, s.Nr_rej,
    DATEDIFF(w.Zwrot, w.Wypozyczenie) czas,
    c.Cena * DATEDIFF(w.Zwrot, w.Wypozyczenie) cena
  FROM wypozyczenia w
  JOIN samochody s ON w.Nr_ew = s.Nr_ew
  JOIN klienci k ON w.Nr_klienta = k.Nr_klienta
  JOIN ceny_za_dobe c ON LEFT(s.Nr_firmowy, 1) = c.Klasa
  ORDER BY k.Nazwisko DESC, k.Imie DESC, s.Nr_rej DESC
  LIMIT 1
)
```

</details>

<details>
<summary>Answer</summary>

| Imie    | Nazwisko | Nr_rej | czas | cena |
| ------- | -------- | ------ | ---- | ---- |
| Nela    | Aabacka  | WI1150 | 2    | 160  |
| Aaricia | Zgbacka  | WI1126 | 11   | 880  |

</details>

#### 6.2

Dla każdej klasy samochodu podaj liczbę wypożyczeń samochodów tej klasy.

<details>
<summary>Solution</summary>

```sql
SELECT LEFT(s.Nr_firmowy, 1) klasa, COUNT(*) liczba
FROM wypozyczenia w
JOIN samochody s ON w.Nr_ew = s.Nr_ew
GROUP BY klasa
```

</details>

<details>
<summary>Answer</summary>

| klasa | liczba |
| ----- | ------ |
| B     | 100    |
| C     | 48     |
| D     | 53     |

</details>

#### 6.3

Podaj imię i nazwisko osoby(osób), która(e) wypożyczała(y) samochody największą liczbę
razy, oraz liczbę tych wypożyczeń.

<details>
<summary>Solution</summary>

```sql
WITH sq AS (
  SELECT w.Nr_klienta, COUNT(*) liczba
  FROM wypozyczenia w
  GROUP BY w.Nr_klienta
)
SELECT k.Imie, k.Nazwisko, s.liczba
FROM sq s
JOIN klienci k ON s.Nr_klienta = k.Nr_klienta
WHERE s.liczba = (SELECT MAX(liczba) FROM sq)
```

</details>

<details>
<summary>Answer</summary>

| Imie   | Nazwisko | liczba |
| ------ | -------- | ------ |
| Ramzes | Hcbacki  | 5      |

</details>

#### 6.4

Przygotuj zestawienie samochodów, które nie były wypożyczane. Podaj ich liczbę w podziale
na klasy i miejscowości.

<details>
<summary>Comment</summary>

Expected answer differs from mine.\
They don't inlcude cars from those cities: Piarowa and Wielka Wola.\
But I don't know why though, because I don't see any reason to do so.

</details>

<details>
<summary>Solution - simple</summary>

```sql
SELECT s.Miejscowosc, LEFT(s.Nr_firmowy, 1) klasa, COUNT(*) liczba
FROM samochody s
LEFT JOIN wypozyczenia w ON s.Nr_ew = w.Nr_ew
WHERE w.Lp IS NULL
GROUP BY s.Miejscowosc, klasa
```

</details>

<details>
<summary>Answer (mine)</summary>

| Miejscowosc  | klasa | liczba |
| ------------ | ----- | ------ |
| Aniolkowo    | B     | 12     |
| Aniolkowo    | C     | 8      |
| Aniolkowo    | D     | 7      |
| Manipulatowo | B     | 31     |
| Manipulatowo | C     | 14     |
| Manipulatowo | D     | 11     |
| Nieszczerzyn | B     | 17     |
| Nieszczerzyn | C     | 9      |
| Nieszczerzyn | D     | 4      |
| Piarowa      | B     | 16     |
| Piarowa      | C     | 18     |
| Piarowa      | D     | 8      |
| Wielka Wola  | B     | 25     |
| Wielka Wola  | C     | 11     |
| Wielka Wola  | D     | 7      |

</details>

<details>
<summary>Solution - pivot</summary>

```sql
SELECT s.Miejscowosc,
SUM(CASE WHEN LEFT(s.Nr_firmowy, 1) = "B" THEN 1 ELSE 0 END) B,
SUM(CASE WHEN LEFT(s.Nr_firmowy, 1) = "C" THEN 1 ELSE 0 END) C,
SUM(CASE WHEN LEFT(s.Nr_firmowy, 1) = "D" THEN 1 ELSE 0 END) D
FROM samochody s
LEFT JOIN wypozyczenia w ON s.Nr_ew = w.Nr_ew
WHERE w.Lp IS NULL
GROUP BY s.Miejscowosc
```

</details>

<details>
<summary>Answer (mine)</summary>

| Miejscowosc  | B   | C   | D   |
| ------------ | --- | --- | --- |
| Aniolkowo    | 12  | 8   | 7   |
| Manipulatowo | 31  | 14  | 11  |
| Nieszczerzyn | 17  | 9   | 4   |
| Piarowa      | 16  | 18  | 8   |
| Wielka Wola  | 25  | 11  | 7   |

</details>

<details>
<summary>Answer (thiers)</summary>

| Miejscowosc  | B   | C   | D   |
| ------------ | --- | --- | --- |
| Aniolkowo    | 12  | 8   | 7   |
| Manipulatowo | 31  | 14  | 11  |
| Nieszczerzyn | 17  | 9   | 4   |

</details>

#### 6.5

Podaj liczbę zarejestrowanych klientów, którzy nie wypożyczyli żadnego samochodu.

<details>
<summary>Solution</summary>

```sql
SELECT COUNT(*) liczba
FROM klienci k
LEFT JOIN wypozyczenia w ON k.Nr_klienta = w.Nr_klienta
WHERE w.Lp IS NULL
```

</details>

<details>
<summary>Answer</summary>

| liczba |
| ------ |
| 72     |

</details>

### Czerwiec 2017

[View Matura](https://www.korepetycjezinformatyki.pl/wp-content/uploads/matury-czerwiec/informatyka-2017-czerwiec-matura-rozszerzona-2.pdf)

#### 6.1

Wyszukaj wszystkie programy z rodzaju edytor dokumentow tekstowych, które są
zawarte przynajmniej w dwóch różnych pakietach. Utwórz zestawienie zawierające dla
każdego z tych programów: jego nazwę, cenę oraz liczbę pakietów, w których jest zawarty.

<details>
<summary>Solution</summary>

```sql
SELECT pr.program, pr.cena, COUNT(*) liczba_pakietow
FROM zestawy z
JOIN programy pr ON z.Id_programu = pr.Id_programu
JOIN pakiety pa ON z.Id_pakietu = pa.Id_pakietu
WHERE pr.rodzaj = "edytor dokumentow tekstowych"
GROUP BY pr.Id_programu
HAVING liczba_pakietow >= 2
```

</details>

<details>
<summary>Answer</summary>

| program                   | cena | liczba_pakietow |
| ------------------------- | ---- | --------------- |
| Word                      | 120  | 4               |
| Publisher                 | 170  | 3               |
| Writer                    | 0    | 3               |
| Foxit Redactor for Office | 1621 | 2               |

</details>

#### 6.2

Podaj unikatową listę nazw pakietów zawierających takie programy, w których do opisu
rodzaju użyto słowo: zarzadzanie (unikatowa lista zawiera elementy bez powtórzeń).

<details>
<summary>Solution</summary>

```sql
SELECT DISTINCT pa.nazwa_pakietu
FROM zestawy z
JOIN programy pr ON z.Id_programu = pr.Id_programu
JOIN pakiety pa ON z.Id_pakietu = pa.Id_pakietu
WHERE pr.rodzaj LIKE "%zarzadzanie%"
```

</details>

<details>
<summary>Answer</summary>

| nazwa_pakietu                           |
| --------------------------------------- |
| Calligra Suite                          |
| gDOC                                    |
| DocuPDF                                 |
| GFI Security                            |
| IBM Data Software                       |
| OKAY                                    |
| Sales Partner                           |
| Subiekt                                 |
| SolarWinds Systems Management           |
| SolarWinds Free System Management Tools |

</details>

#### 6.3

Dla każdego pakietu oblicz jego wartość, czyli sumę cen programów w nim zawartych.
Utwórz zestawienie zawierające trzy najdroższe pakiety (o największych wartościach), dla
każdego z nich podaj nazwę pakietu, nazwę firmy i wartość.

<details>
<summary>Solution</summary>

```sql
SELECT pa.nazwa_pakietu, pa.firma, SUM(pr.cena) wartosc
FROM zestawy z
JOIN programy pr ON z.Id_programu = pr.Id_programu
JOIN pakiety pa ON z.Id_pakietu = pa.Id_pakietu
GROUP BY pa.Id_pakietu
ORDeR BY wartosc DESC
LIMIT 3
```

</details>

<details>
<summary>Answer</summary>

| nazwa_pakietu                 | firma        | wartosc |
| ----------------------------- | ------------ | ------- |
| SolarWinds Systems Management | SolarWinds   | 57520   |
| MicroStation                  | Bentley      | 35736   |
| GFI Security                  | GFI Software | 14811   |

</details>

#### 6.4

Podaj nazwy wszystkich programów, które nie występują w żadnym pakiecie.

<details>
<summary>Solution</summary>

```sql
SELECT pr.program
FROM programy pr
LEFT JOIN zestawy z ON pr.Id_programu = z.Id_programu
WHERE z.Lp IS NULL
```

</details>

<details>
<summary>Answer</summary>

| program         |
| --------------- |
| Lightroom       |
| Audition        |
| Scribus         |
| Adobe PageMaker |
| QuarkXPress     |

</details>

#### 6.5

Wyszukaj takie pakiety, które zawierają przynajmniej jeden program w cenie większej niż
0 zł (komercyjny) i przynajmniej jeden program w cenie równej 0 zł (darmowy). Utwórz
zestawienie, w którym podasz nazwy tych pakietów oraz liczbę programów komercyjnych,
a także liczbę programów darmowych w nim zawartych dla każdego pakietu.

<details>
<summary>Solution</summary>

```sql
SELECT pa.nazwa_pakietu,
  SUM(CASE WHEN pr.cena = 0 THEN 1 ELSE 0 END) darmowych,
  SUM(CASE WHEN pr.cena != 0 THEN 1 ELSE 0 END) komercyjnych
FROM zestawy z
JOIN programy pr ON z.Id_programu = pr.Id_programu
JOIN pakiety pa ON z.Id_pakietu = pa.Id_pakietu
GROUP BY pa.Id_pakietu
HAVING darmowych >= 1 AND komercyjnych >= 1
```

</details>

<details>
<summary>Answer</summary>

| nazwa_pakietu              | darmowych | komercyjnych |
| -------------------------- | --------- | ------------ |
| Expression Studio          | 1         | 3            |
| Logo-Gry                   | 2         | 8            |
| MicroStation               | 1         | 4            |
| dbForge                    | 1         | 5            |
| ApexSQL Developer          | 2         | 7            |
| DaemonTools Lite           | 1         | 8            |
| IconCool Software          | 1         | 4            |
| Sothink Suite              | 1         | 6            |
| Foxit PDF Development Kits | 1         | 2            |

</details>

### Czerwiec 2016

[View Matura](https://www.korepetycjezinformatyki.pl/wp-content/uploads/matury-czerwiec/informatyka-2016-czerwiec-matura-rozszerzona-2.pdf)

#### 5.1

Utwórz zestawienie zawierające nazwiska i imiona zdających, którzy zdawali egzamin
maturalny z informatyki. Wyniki uporządkuj alfabetycznie według nazwisk zdających.

<details>
<summary>Solution</summary>

```sql
SELECT m.Nazwisko, m.Imie
FROM zdaje z
JOIN maturzysta m ON z.Id_zdajacego = m.Id_zdajacego
JOIN przedmioty p ON z.Id_przedmiotu = p.Id_przedmiotu
WHERE p.Nazwa_przedmiotu = "informatyka"
ORDER BY m.Nazwisko
```

</details>

<details>

<summary>Answer</summary>

| Nazwisko   | Imie     |
| ---------- | -------- |
| Badowski   | Fryderyk |
| Barszcz    | Tomasz   |
| Makowicz   | Magda    |
| Nowak      | Pawel    |
| Nowakowski | Marek    |
| Rybicka    | Maria    |
| Wysocka    | Justyna  |

</details>

#### 5.2

Podaj nazwę przedmiotu, który był zdawany najczęściej jako przedmiot dodatkowy, oraz
liczbę osób, które go wybrały.

<details>
<summary>Solution</summary>

```sql
SELECT p.Nazwa_przedmiotu, COUNT(*) liczba
FROM zdaje z
JOIN przedmioty p ON z.Id_przedmiotu = p.Id_przedmiotu
WHERE p.Typ = "dodatkowy"
GROUP BY p.Id_przedmiotu
ORDER BY liczba DESC
LIMIT 1
```

</details>

<details>
<summary>Answer</summary>

| Nazwa_przedmiotu        | liczba |
| ----------------------- | ------ |
| wiedza o spoleczenstwie | 8      |

</details>

#### 5.3

Podaj nazwiska i imiona wszystkich zdających, którzy wybrali największą liczbę egzaminów
maturalnych z przedmiotów dodatkowych, oraz podaj liczbę tych przedmiotów.

<details>
<summary>Solution</summary>

```sql
WITH sq AS (
  SELECT z.Id_zdajacego, COUNT(*) liczba
  FROM zdaje z
  JOIN przedmioty p ON z.Id_przedmiotu = p.Id_przedmiotu
  WHERE p.Typ = "dodatkowy"
  GROUP BY z.Id_zdajacego
)
SELECT m.Nazwisko, m.Imie, s.liczba
FROM sq s
JOIN maturzysta m ON s.Id_zdajacego = m.Id_zdajacego
WHERE s.liczba = (SELECT MAX(liczba) FROM sq)
```

</details>

<details>
<summary>Answer</summary>

| Nazwisko | Imie   | liczba |
| -------- | ------ | ------ |
| Bajda    | Maria  | 3      |
| Zalicki  | Marcin | 3      |
| Baranska | Joanna | 3      |

</details>

#### 5.4

Podaj nazwę przedmiotu dodatkowego, który nie został ani razu wybrany na egzaminie
maturalnym.

<details>
<summary>Solution</summary>

```sql
SELECT DISTINCT p.Nazwa_przedmiotu
FROM przedmioty p
LEFT JOIN zdaje z ON p.Id_przedmiotu = z.Id_przedmiotu
WHERE z.Lp IS NULL
```

</details>

<details>
<summary>Answer</summary>

| Nazwa_przedmiotu                  |
| --------------------------------- |
| jezyk lacinski i kultura antyczna |

</details>

#### 5.5

Podaj imię i nazwisko najmłodszego maturzysty oraz nazwy przedmiotów dodatkowych, które
ta osoba wybrała na egzaminie maturalnym.

<details>
<summary>Comment</summary>

Expected answer doesn't check if the subject is additional or not.\
But question clearly states that only additional subjects should be displayed.

</details>

<details>
<summary>Solution (mine)</summary>

```sql
SELECT m.Imie, m.Nazwisko, p.Nazwa_przedmiotu
FROM zdaje z
JOIN przedmioty p ON z.Id_przedmiotu = p.Id_przedmiotu
JOIN maturzysta m ON z.Id_zdajacego = m.Id_zdajacego
WHERE p.Typ = "dodatkowy" AND m.Id_zdajacego = (
  SELECT m.Id_zdajacego
  FROM maturzysta m
  ORDER BY m.Data_urodzenia DESC
  LIMIT 1
)
```

</details>

<details>
<summary>Answer (mine)</summary>

| Imie  | Nazwisko   | Nazwa_przedmiotu |
| ----- | ---------- | ---------------- |
| Marek | Nowakowski | informatyka      |

</details>

<details>
<summary>Solution (theirs)</summary>

```sql
SELECT m.Imie, m.Nazwisko, p.Nazwa_przedmiotu
FROM zdaje z
JOIN przedmioty p ON z.Id_przedmiotu = p.Id_przedmiotu
JOIN maturzysta m ON z.Id_zdajacego = m.Id_zdajacego
WHERE m.Id_zdajacego = (
  SELECT m.Id_zdajacego
  FROM maturzysta m
  ORDER BY m.Data_urodzenia DESC
  LIMIT 1
)
```

</details>

<details>
<summary>Answer (theirs)</summary>

| Imie  | Nazwisko   | Nazwa_przedmiotu |
| ----- | ---------- | ---------------- |
| Marek | Nowakowski | jezyk polski     |
| Marek | Nowakowski | matematyka       |
| Marek | Nowakowski | jezyk niemiecki  |
| Marek | Nowakowski | informatyka      |

</details>

#### 5.6

Podaj liczbę mężczyzn, którzy przystąpili do egzaminu maturalnego. Wykorzystaj
przedostatnią cyfrę numeru PESEL, która tylko dla mężczyzn jest nieparzysta.

<details>
<summary>Solution</summary>

```sql
SELECT COUNT(*) liczba
FROM maturzysta m
WHERE SUBSTR(m.PESEL, 10, 1) % 2 = 1
```

</details>

<details>
<summary>Answer</summary>

| liczba |
| ------ |
| 180    |

</details>

### Czerwiec 2015

[View Matura](https://www.korepetycjezinformatyki.pl/wp-content/uploads/matury-czerwiec/informatyka-2015-czerwiec-matura-rozszerzona-2.pdf)

#### 5.1

Podaj nazwę wykroczenia, za które kierowcy byli najczęściej karani, oraz liczbę jego
wystąpień.

<details>
<summary>Solution</summary>

```sql
SELECT w.nazwa, COUNT(*) liczba
FROM mandaty m
JOIN wykroczenia w ON m.kod_wyk = w.kod_wyk
GROUP BY w.kod_wyk
ORDER BY liczba DESC
LIMIT 1
```

</details>

<details>
<summary>Answer</summary>

| nazwa                                                | liczba |
| ---------------------------------------------------- | ------ |
| Przekroczenie dopuszczalnej predkosci o 21 - 30 km/h | 77     |

</details>

#### 5.2

Wykonaj zestawienie zawierające numery PESEL tych kierowców, którzy zdali egzamin na
prawo jazdy w 2013 roku i otrzymali w sumie więcej niż 20 punktów karnych. Zestawienie
powinno zawierać również uzyskane przez nich łączne liczby punktów karnych.

<details>
<summary>Solution</summary>

```sql
SELECT k.pesel, SUM(w.punkty) liczba
FROM mandaty m
JOIN wykroczenia w ON m.kod_wyk = w.kod_wyk
JOIN kierowcy k ON m.pesel = k.pesel
WHERE YEAR(k.data_prawa_jazdy) = 2013
GROUP BY k.pesel
HAVING liczba > 20
```

</details>

<details>
<summary>Answer</summary>

| pesel       | liczba |
| ----------- | ------ |
| 80062465997 | 27     |
| 81011159031 | 32     |
| 81011807736 | 26     |

</details>

#### 5.3

Wykonaj zestawienie zawierające nazwy wszystkich wykroczeń, które w swojej nazwie
zawierają tekst „naruszenie zakazu”. Przy wyszukiwaniu nazw wykroczeń nie rozróżniaj
wielkości liter.

<details>
<summary>Solution</summary>

```sql
SELECT w.nazwa
FROM wykroczenia w
WHERE w.nazwa LIKE "%naruszenie zakazu%"
```

</details>

<details>
<summary>Answer</summary>

| nazwa                                                                                                |
| ---------------------------------------------------------------------------------------------------- |
| Naruszenie zakazu wyprzedzania pojazdu silnikowego przy dojezdzaniu do wierzcholka wzniesienia       |
| Naruszenie zakazu wyprzedzania na zakretach oznaczonych znakami ostrzegawczymi                       |
| Naruszenie zakazu wyprzedzania na skrzyzowaniach                                                     |
| Naruszenie zakazu zawracania na autostradzie lub drodze ekspresowej                                  |
| Naruszenie zakazu postoju w miejscach utrudniajacych wjazd lub wyjazd                                |
| Naruszenie zakazu postoju w miejscach utrudniajacych dostep do innego prawidowo zaparkowanego pojadu |
| Naruszenie zakazu postoju przed lub za przejazdem kolejowym                                          |
| Naruszenie zakazu postoju w strefie zamieszkania w miejscach innych niz wyznaczone                   |
| W czasie jazdy naruszenie zakazu palenia tytoniu lub spozywania pokarmow.                            |

</details>

#### 5.4

Podaj, w którym miesiącu wypisano najmniej mandatów. Dla tego miesiąca podaj łączną
kwotę mandatów oraz ich liczbę.

<details>
<summary>Solution</summary>

```sql
SELECT MONTH(m.data_wyk) miesiac, SUM(w.mandat) suma, COUNT(*) liczba
FROM mandaty m
JOIN wykroczenia w ON m.kod_wyk = w.kod_wyk
GROUP BY miesiac
ORDER BY liczba
LIMIT 1
```

</details>

<details>
<summary>Answer</summary>

| miesiac | suma  | liczba |
| ------- | ----- | ------ |
| 2       | 12750 | 63     |

</details>

#### 5.5

Podaj liczbę kierowców, którzy nie otrzymali żadnego mandatu. Podaj miasto, z którego
pochodzi najwięcej takich kierowców.

<details>
<summary>Solution</summary>

```sql
SELECT k.miasto,
  (SELECT COUNT(*)
  FROM kierowcy k2
  LEFT JOIN mandaty m2 ON k2.pesel = m2.pesel
  WHERE m2.lp IS NULL) liczba
FROM kierowcy k
LEFT JOIN mandaty m ON k.pesel = m.pesel
WHERE m.lp IS NULL
GROUP BY k.miasto
ORDER BY COUNT(*) DESC
LIMIT 1
```

</details>

<details>
<summary>Answer</summary>

| miasto   | liczba |
| -------- | ------ |
| Warszawa | 190    |

</details>
