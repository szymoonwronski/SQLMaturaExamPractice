# Rozwiązania SQL z matur

## Formuła 2023

### Maj 2024

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

Using 'LEFT JOIN' ensures that all firms are included in the result set even if they have no installations.\
Using 'INNER JOIN' would result in firms with no installations being excluded from the result set.

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
