# Rozwiązania SQL z maturalnego zbioru zadań

## Zadanie 98

### 98.1

Imiona dziewcząt w zestawieniu kończą się na literę „a”. Podaj klasy, w których ponad 50% wszystkich uczniów to dziewczęta.

<details>
<summary>Solution</summary>

```sql
SELECT u.Klasa
FROM uczniowie u
GROUP BY u.Klasa
HAVING SUM(CASE WHEN u.Imie LIKE "%a" THEN 1 ELSE 0 END) > COUNT(*) / 2
```

</details>

<details>
<summary>Answer</summary>

| Klasa |
| ----- |
| I A   |
| I C   |

</details>

### 98.2

Podaj daty, kiedy w szkole wystawiono więcej niż 10 jedynek jednego dnia.

<details>
<summary>Solution</summary>

```sql
SELECT o.Data
FROM oceny o
WHERE o.Ocena = 1
GROUP BY o.Data
HAVING COUNT(*) > 10
```

</details>

<details>
<summary>Answer</summary>

| Data       |
| ---------- |
| 2014-10-14 |
| 2014-11-11 |

</details>

### 98.3

Podaj, z dokładnością do dwóch miejsc po przecinku, średnie ocen z języka polskiego dla każdej klasy czwartej.

<details>
<summary>Solution</summary>

```sql
SELECT u.Klasa, ROUND(AVG(o.Ocena), 2) srednia
FROM oceny o
JOIN uczniowie u ON o.Id_ucznia = u.Id_ucznia
JOIN przedmioty p ON o.Id_przedmiotu = p.Id_przedmiotu
WHERE u.Klasa LIKE "IV%" AND p.Nazwa_przedmiotu = "j.polski"
GROUP BY u.Klasa
```

</details>

<details>
<summary>Answer</summary>

| Klasa | srednia |
| ----- | ------- |
| IV A  | 3.53    |
| IV B  | 3.45    |
| IV C  | 3.40    |
| IV D  | 3.90    |
| IV E  | 3.51    |

</details>

### 98.4

Podaj zestawienie zawierające dla każdego przedmiotu liczbę piątek wystawionych w kolejnych miesiącach od września do grudnia łącznie we wszystkich klasach.

<details>
<summary>Solution - simple</summary>

```sql
SELECT p.Nazwa_przedmiotu, MONTH(o.Data) miesiac, COUNT(*) liczba
FROM oceny o
JOIN przedmioty p ON o.Id_przedmiotu = p.Id_przedmiotu
WHERE o.Ocena = 5
GROUP BY p.Id_przedmiotu, miesiac
```

</details>

<details>
<summary>Answer - simple</summary>

| Nazwa_przedmiotu                                      | miesiac | liczba |
| ----------------------------------------------------- | ------- | ------ |
| j.polski                                              | 9       | 37     |
| j.polski                                              | 10      | 81     |
| j.polski                                              | 11      | 62     |
| j.polski                                              | 12      | 41     |
| j.angielski                                           | 9       | 50     |
| j.angielski                                           | 10      | 85     |
| j.angielski                                           | 11      | 72     |
| j.angielski                                           | 12      | 50     |
| j.niemiecki                                           | 9       | 66     |
| j.niemiecki                                           | 10      | 106    |
| j.niemiecki                                           | 11      | 84     |
| j.niemiecki                                           | 12      | 53     |
| matematyka                                            | 9       | 32     |
| matematyka                                            | 10      | 39     |
| matematyka                                            | 11      | 48     |
| matematyka                                            | 12      | 35     |
| fizyka                                                | 9       | 14     |
| fizyka                                                | 10      | 21     |
| fizyka                                                | 11      | 31     |
| fizyka                                                | 12      | 9      |
| historia                                              | 9       | 2      |
| historia                                              | 10      | 2      |
| geografia                                             | 10      | 1      |
| geografia                                             | 11      | 1      |
| biologia                                              | 9       | 8      |
| biologia                                              | 10      | 20     |
| biologia                                              | 11      | 9      |
| biologia                                              | 12      | 5      |
| chemia                                                | 9       | 18     |
| chemia                                                | 10      | 31     |
| chemia                                                | 11      | 31     |
| chemia                                                | 12      | 13     |
| informatyka                                           | 9       | 33     |
| informatyka                                           | 10      | 31     |
| informatyka                                           | 11      | 34     |
| informatyka                                           | 12      | 25     |
| wiedza o spoleczenstwie                               | 9       | 7      |
| wiedza o spoleczenstwie                               | 10      | 15     |
| wiedza o spoleczenstwie                               | 11      | 9      |
| wiedza o spoleczenstwie                               | 12      | 7      |
| wiedza o kulturze                                     | 9       | 7      |
| wiedza o kulturze                                     | 10      | 16     |
| wiedza o kulturze                                     | 11      | 13     |
| wiedza o kulturze                                     | 12      | 10     |
| edukacja dla bezpieczenstwa                           | 9       | 9      |
| edukacja dla bezpieczenstwa                           | 10      | 15     |
| edukacja dla bezpieczenstwa                           | 11      | 14     |
| edukacja dla bezpieczenstwa                           | 12      | 8      |
| podstawy przedsiebiorczosci                           | 9       | 6      |
| podstawy przedsiebiorczosci                           | 10      | 16     |
| podstawy przedsiebiorczosci                           | 11      | 16     |
| podstawy przedsiebiorczosci                           | 12      | 12     |
| wychowanie fizyczne                                   | 9       | 23     |
| wychowanie fizyczne                                   | 10      | 39     |
| wychowanie fizyczne                                   | 11      | 34     |
| wychowanie fizyczne                                   | 12      | 15     |
| historia i spoleczenstwo - przedmiot uzupelniajacy    | 9       | 8      |
| historia i spoleczenstwo - przedmiot uzupelniajacy    | 10      | 4      |
| historia i spoleczenstwo - przedmiot uzupelniajacy    | 11      | 6      |
| historia i spoleczenstwo - przedmiot uzupelniajacy    | 12      | 3      |
| systemy operacyjne                                    | 9       | 4      |
| systemy operacyjne                                    | 10      | 19     |
| systemy operacyjne                                    | 11      | 12     |
| systemy operacyjne                                    | 12      | 9      |
| urzadzenia techniki komputerowej                      | 9       | 8      |
| urzadzenia techniki komputerowej                      | 10      | 18     |
| urzadzenia techniki komputerowej                      | 11      | 19     |
| urzadzenia techniki komputerowej                      | 12      | 15     |
| diagnostyka i naprawa urzadzen techniki komputerow... | 9       | 8      |
| diagnostyka i naprawa urzadzen techniki komputerow... | 10      | 13     |
| diagnostyka i naprawa urzadzen techniki komputerow... | 11      | 9      |
| diagnostyka i naprawa urzadzen techniki komputerow... | 12      | 13     |
| jezyk angielski zawodowy w branzy informatycznej      | 9       | 1      |
| jezyk angielski zawodowy w branzy informatycznej      | 10      | 1      |
| jezyk angielski zawodowy w branzy informatycznej      | 11      | 1      |
| sieci komputerowe                                     | 10      | 2      |
| witryny i aplikacje internetowe                       | 9       | 5      |
| witryny i aplikacje internetowe                       | 10      | 6      |
| witryny i aplikacje internetowe                       | 11      | 9      |
| witryny i aplikacje internetowe                       | 12      | 3      |
| administracja sieciowymi systemami operacyjnymi       | 12      | 2      |
| projektowanie i montaz lokalnych sieci komputerowy... | 9       | 10     |
| projektowanie i montaz lokalnych sieci komputerowy... | 10      | 11     |
| projektowanie i montaz lokalnych sieci komputerowy... | 11      | 11     |
| projektowanie i montaz lokalnych sieci komputerowy... | 12      | 6      |
| systemy baz danych                                    | 9       | 6      |
| systemy baz danych                                    | 10      | 5      |
| systemy baz danych                                    | 11      | 8      |
| systemy baz danych                                    | 12      | 5      |
| administracja bazami danych                           | 9       | 3      |
| administracja bazami danych                           | 10      | 13     |
| administracja bazami danych                           | 11      | 7      |
| administracja bazami danych                           | 12      | 1      |

</details>

<details>
<summary>Solution - pivot</summary>

```sql
SELECT
  p.Nazwa_przedmiotu,
  SUM(CASE WHEN MONTH(o.Data) = 9 THEN 1 ELSE 0 END) wrzesien,
  SUM(CASE WHEN MONTH(o.Data) = 10 THEN 1 ELSE 0 END) pazdziernik,
  SUM(CASE WHEN MONTH(o.Data) = 11 THEN 1 ELSE 0 END) listopad,
  SUM(CASE WHEN MONTH(o.Data) = 12 THEN 1 ELSE 0 END) grudzien
FROM oceny o
JOIN przedmioty p ON o.Id_przedmiotu = p.Id_przedmiotu
WHERE o.Ocena = 5
GROUP BY p.Id_przedmiotu
```

</details>

<details>
<summary>Answer - pivot</summary>

| Nazwa_przedmiotu                                      | wrzesien | pazdziernik | listopad | grudzien |
| ----------------------------------------------------- | -------- | ----------- | -------- | -------- |
| j.polski                                              | 37       | 81          | 62       | 41       |
| j.angielski                                           | 50       | 85          | 72       | 50       |
| j.niemiecki                                           | 66       | 106         | 84       | 53       |
| matematyka                                            | 32       | 39          | 48       | 35       |
| fizyka                                                | 14       | 21          | 31       | 9        |
| historia                                              | 2        | 2           | 0        | 0        |
| geografia                                             | 0        | 1           | 1        | 0        |
| biologia                                              | 8        | 20          | 9        | 5        |
| chemia                                                | 18       | 31          | 31       | 13       |
| informatyka                                           | 33       | 31          | 34       | 25       |
| wiedza o spoleczenstwie                               | 7        | 15          | 9        | 7        |
| wiedza o kulturze                                     | 7        | 16          | 13       | 10       |
| edukacja dla bezpieczenstwa                           | 9        | 15          | 14       | 8        |
| podstawy przedsiebiorczosci                           | 6        | 16          | 16       | 12       |
| wychowanie fizyczne                                   | 23       | 39          | 34       | 15       |
| historia i spoleczenstwo - przedmiot uzupelniajacy    | 8        | 4           | 6        | 3        |
| systemy operacyjne                                    | 4        | 19          | 12       | 9        |
| urzadzenia techniki komputerowej                      | 8        | 18          | 19       | 15       |
| diagnostyka i naprawa urzadzen techniki komputerow... | 8        | 13          | 9        | 13       |
| jezyk angielski zawodowy w branzy informatycznej      | 1        | 1           | 1        | 0        |
| sieci komputerowe                                     | 0        | 2           | 0        | 0        |
| witryny i aplikacje internetowe                       | 5        | 6           | 9        | 3        |
| administracja sieciowymi systemami operacyjnymi       | 0        | 0           | 0        | 2        |
| projektowanie i montaz lokalnych sieci komputerowy... | 10       | 11          | 11       | 6        |
| systemy baz danych                                    | 6        | 5           | 8        | 5        |
| administracja bazami danych                           | 3        | 13          | 7        | 1        |

</details>

### 98.5

Podaj zestawienie imion i nazwisk uczniów klasy II A, którzy nie otrzymali żadnej oceny z przedmiotu sieci komputerowe.

<details>
<summary>Solution - using NOT EXISTS</summary>

```sql
SELECT u.Imie, u.Nazwisko
FROM uczniowie u
WHERE u.Klasa = "II A" AND NOT EXISTS (
  SELECT 1
  FROM oceny o
  JOIN przedmioty p ON o.Id_przedmiotu = p.Id_przedmiotu
  WHERE o.Id_ucznia = u.Id_ucznia AND p.Nazwa_przedmiotu = "sieci komputerowe"
)
```

</details>

<details>
<summary>Solution - using COUNT()</summary>

```sql
SELECT u.Imie, u.Nazwisko
FROM uczniowie u
WHERE u.Klasa = "II A" AND (
  SELECT COUNT(*)
  FROM oceny o
  JOIN przedmioty p ON o.Id_przedmiotu = p.Id_przedmiotu
  WHERE p.Nazwa_przedmiotu = "sieci komputerowe" AND o.Id_ucznia = u.Id_ucznia
) = 0
```

</details>

<details>
<summary>Answer</summary>

| Imie     | Nazwisko      |
| -------- | ------------- |
| Aneta    | Duda          |
| Miroslaw | Gorski        |
| Lukasz   | Kostoczko     |
| Donald   | Krychowski    |
| Adrian   | Lubaczewski   |
| Piotr    | Nawrocki      |
| Michal   | Nowakowski    |
| Piotr    | Prusinski     |
| Grzegorz | Tomkow        |
| Radoslaw | Wojciechowski |
| Mariusz  | Wojtyra       |

</details>

## Zadanie 99

### 99.1

Podaj liczbę wszystkich ankietowanych dziewcząt i wszystkich ankietowanych chłopców.

<details>
<summary>Solution</summary>

```sql
SELECT a.Plec, COUNT(*) liczba
FROM ankiety a
GROUP BY a.Plec
```

</details>

<details>
<summary>Answer</summary>

| Plec | liczba |
| ---- | ------ |
| k    | 2779   |
| m    | 2781   |

</details>

### 99.2

Dla każdego rodzaju szkoły podaj średnią ocenę odpowiedzi na każde pytanie. Wyniki podaj w zaokrągleniu do dwóch miejsc po przecinku.

<details>
<summary>Solution</summary>

```sql
SELECT
  s.Rodzaj_szkoly,
  ROUND(AVG(a.pyt1), 2) pyt1,
  ROUND(AVG(a.pyt2), 2) pyt2,
  ROUND(AVG(a.pyt3), 2) pyt3,
  ROUND(AVG(a.pyt4), 2) pyt4,
  ROUND(AVG(a.pyt5), 2) pyt5,
  ROUND(AVG(a.pyt6), 2) pyt6
FROM szkoly s
JOIN ankiety a ON s.Id_szkoly = a.Id_szkoly
GROUP BY s.Rodzaj_szkoly
```

</details>

<details>
<summary>Answer</summary>

| Rodzaj_szkoly | pyt1 | pyt2 | pyt3 | pyt4 | pyt5 | pyt6 |
| ------------- | ---- | ---- | ---- | ---- | ---- | ---- |
| G             | 2.93 | 2.33 | 2.51 | 2.69 | 2.99 | 2.96 |
| LO            | 3.02 | 2.27 | 2.59 | 2.60 | 3.01 | 2.97 |
| SP            | 3.52 | 1.99 | 2.26 | 2.65 | 3.03 | 3.35 |
| SZ            | 3.01 | 2.21 | 2.45 | 2.63 | 3.09 | 3.04 |
| T             | 3.02 | 2.01 | 2.53 | 2.65 | 3.07 | 2.94 |

</details>

### 99.3

Dla każdej gminy wyznacz średnią ocenę uczniów, z jej terenu podaną w odpowiedzi na ostatnie (szóste) pytanie. Wyniki umieść w zestawieniu zawierającym dwie kolumny: kod gminy, średnią ocenę uczniów. Zestawienie uporządkuj malejąco ze względu na średnią ocenę. Średnie podaj w zaokrągleniu do dwóch miejsc po przecinku.

<details>
<summary>Solution</summary>

```sql
SELECT g.Kod_gminy, ROUND(AVG(a.pyt6), 2) srednia
FROM gminy g
JOIN szkoly s ON g.Kod_gminy = s.Kod_gminy
JOIN ankiety a ON s.Id_szkoly = a.Id_szkoly
GROUP BY g.Kod_gminy
ORDER BY srednia DESC
```

</details>

<details>
<summary>Answer</summary>

| Kod_gminy | srednia |
| --------- | ------- |
| GM07      | 3.63    |
| GM08      | 3.37    |
| GM17      | 3.28    |
| GM01      | 3.26    |
| GM15      | 3.18    |
| GM12      | 3.13    |
| GM11      | 3.12    |
| GM09      | 3.11    |
| GM02      | 3.09    |
| GM06      | 3.09    |
| GM13      | 3.08    |
| GM16      | 3.07    |
| GM03      | 3.05    |
| GM19      | 3.05    |
| GM10      | 3.03    |
| GM04      | 3.02    |
| GM05      | 2.98    |
| GM18      | 2.96    |
| GM20      | 2.96    |
| GM14      | 2.92    |

</details>

### 99.4

Utwórz zestawienie zawierające dla każdego rodzaju szkoły informacje o liczbie uczniów, którzy podali ocenę 5 na pytanie trzecie. Zestawienie posortuj alfabetycznie według rodzaju szkoły.

<details>
<summary>Solution</summary>

```sql
SELECT s.Rodzaj_szkoly, COUNT(*) liczba
FROM ankiety a
JOIN szkoly s ON a.Id_szkoly = s.Id_szkoly
WHERE a.pyt3 = 5
GROUP BY s.Rodzaj_szkoly
ORDER BY s.Rodzaj_szkoly
```

</details>

<details>
<summary>Answer</summary>

| Rodzaj_szkoly | liczba |
| ------------- | ------ |
| G             | 80     |
| LO            | 94     |
| SP            | 70     |
| SZ            | 12     |
| T             | 35     |

</details>

### 99.5

Podaj nazwę gminy z największą liczbą uczniów biorących udział w badaniu oraz liczbę tych uczniów.

<details>
<summary>Solution</summary>

```sql
SELECT g.Nazwa_gminy, COUNT(*) liczba
FROM ankiety a
JOIN szkoly s ON a.Id_szkoly = s.Id_szkoly
JOIN gminy g ON s.Kod_gminy = g.Kod_gminy
GROUP BY g.Kod_gminy
ORDER BY liczba DESC
LIMIT 1
```

</details>

<details>
<summary>Answer</summary>

| Nazwa_gminy  | liczba |
| ------------ | ------ |
| Lipcowa Rosa | 390    |

</details>

### 99.6

Utwórz zestawienie zawierające informacje o liczbie dziewcząt i chłopców (osobno) z poszczególnych rodzajów szkół, którzy podali najwyższą ocenę 5 na pytanie 1.

<details>
<summary>Solution - simple</summary>

```sql
SELECT s.Rodzaj_szkoly, a.Plec, COUNT(*) liczba
FROM ankiety a
JOIN szkoly s ON a.Id_szkoly = s.Id_szkoly
WHERE a.pyt1 = 5
GROUP BY s.Rodzaj_szkoly, a.Plec
```

</details>

<details>
<summary>Answer - simple</summary>

| Rodzaj_szkoly | Plec | liczba |
| ------------- | ---- | ------ |
| G             | k    | 130    |
| G             | m    | 119    |
| LO            | k    | 116    |
| LO            | m    | 108    |
| SP            | k    | 276    |
| SP            | m    | 307    |
| SZ            | k    | 19     |
| SZ            | m    | 35     |
| T             | k    | 77     |
| T             | m    | 65     |

</details>

<details>
<summary>Solution - pivot</summary>

```sql
SELECT
	s.Rodzaj_szkoly,
    SUM(CASE WHEN a.Plec = "m" THEN 1 ELSE 0 END) chlopcow,
    SUM(CASE WHEN a.Plec = "k" THEN 1 ELSE 0 END) dziewczat
FROM ankiety a
JOIN szkoly s ON a.Id_szkoly = s.Id_szkoly
WHERE a.pyt1 = 5
GROUP BY s.Rodzaj_szkoly
```

</details>

<details>
<summary>Answer - pivot</summary>

| Rodzaj_szkoly | chlopcow | dziewczat |
| ------------- | -------- | --------- |
| G             | 119      | 130       |
| LO            | 108      | 116       |
| SP            | 307      | 276       |
| SZ            | 35       | 19        |
| T             | 65       | 77        |

</details>

## Zadanie 100

### 100.1

Utwórz zestawienie, w którym dla każdej listy zadań podasz średnią liczbę punktów otrzymanych za te zadania przez uczniów. W zestawieniu podaj nazwę listy oraz średnią liczbę punktów zaokrągloną do dwóch miejsc po przecinku.

<details>
<summary>Solution</summary>

```sql
SELECT l.nazwa, ROUND(AVG(p.punkty), 2) srednia
FROM listy l
JOIN punktacja p ON l.id_listy = p.id_listy
GROUP BY l.id_listy
```

</details>

<details>
<summary>Answer</summary>

| nazwa | srednia |
| ----- | ------- |
| C1    | 11.80   |
| C2    | 11.07   |
| C3    | 9.67    |
| C4    | 10.62   |
| C5    | 10.02   |
| C6    | 10.55   |
| C7    | 11.13   |
| P1    | 17.95   |
| P2    | 19.65   |
| P3    | 19.98   |
| P4    | 20.83   |

</details>

### 100.2

Utwórz zestawienie, w którym podasz imiona i nazwiska osób, które spóźniły się o 14 lub więcej dni z oddaniem dowolnej listy o nazwie zaczynającej się od litery „P”.

<details>
<summary>Solution - using EXISTS</summary>

```sql
SELECT o.imie, o.nazwisko
FROM osoby o
WHERE EXISTS (
	SELECT 1
	FROM punktacja p
	JOIN listy l ON p.id_listy = l.id_listy
	WHERE p.id_osoby = o.id_osoby
  AND l.nazwa LIKE "P%"
  AND p.data >= l.termin_oddania + 14
)
```

</details>

<details>
<summary>Solution - using GROUP BY</summary>

```sql
SELECT o.imie, o.nazwisko
FROM osoby o
JOIN punktacja p ON o.id_osoby = p.id_osoby
JOIN listy l ON p.id_listy = l.id_listy
WHERE l.nazwa LIKE "P%" AND p.data >= l.termin_oddania + 14
GROUP BY o.id_osoby
```

</details>

<details>
<summary>Answer</summary>

| imie   | nazwisko     |
| ------ | ------------ |
| Albert | Mikos        |
| Lukasz | Rdzanek      |
| Dawid  | Zajaczkowski |

</details>

### 100.3

Na podstawie liczby wszystkich zdobytych przez uczniów punktów wystawione zostały oceny według zasad przedstawionych w tabeli:

| przedział punktów | ocena |
| ----------------- | ----- |
| (0, 72)           | 1     |
| [72, 90)          | 2     |
| [90, 126)         | 3     |
| [126, 153)        | 4     |
| [153, 180)        | 5     |

Podaj, ile osób otrzymało ocenę 1, 2, 3, 4, 5.

<details>
<summary>Solution - using WITH (CTE - Common Table Expression)</summary>

```sql
WITH suma_punktow AS (
	SELECT SUM(p.punkty) punkty
	FROM punktacja p
	GROUP BY p.id_osoby
)
SELECT
	CASE
		WHEN punkty > 0 AND punkty < 72 THEN 1
        WHEN punkty >= 72 AND punkty < 90 THEN 2
        WHEN punkty >= 90 AND punkty < 126 THEN 3
        WHEN punkty >= 126 AND punkty < 153 THEN 4
        WHEN punkty >= 153 AND punkty < 180 THEN 5
	END ocena,
	COUNT(*) liczba
FROM suma_punktow
GROUP BY ocena
```

</details>

<details>
<summary>Solution - using subquery in FROM</summary>

```sql
SELECT
	CASE
		WHEN sp.punkty > 0 AND sp.punkty < 72 THEN 1
        WHEN sp.punkty >= 72 AND sp.punkty < 90 THEN 2
        WHEN sp.punkty >= 90 AND sp.punkty < 126 THEN 3
        WHEN sp.punkty >= 126 AND sp.punkty < 153 THEN 4
        WHEN sp.punkty >= 153 AND sp.punkty < 180 THEN 5
	END ocena,
	COUNT(*) liczba
FROM (
	SELECT SUM(p.punkty) punkty
	FROM punktacja p
	GROUP BY p.id_osoby
) sp
GROUP BY ocena
```

</details>

<details>
<summary>Answer</summary>

| ocena | liczba |
| ----- | ------ |
| 2     | 1      |
| 3     | 5      |
| 4     | 18     |
| 5     | 36     |

</details>

### 100.4

Utwórz czytelne zestawienie tabelaryczne, w którym dla każdej grupy podasz, ile osób otrzymało liczbę punktów równą 10, 11, 12. W swoich obliczeniach weź pod uwagę wszystkie listy zadań.

<details>
<summary>Comment to the solution</summary>

The task is to count the number of people who received exactly 10, 11, or 12 points.\
However, their solution incorrectly counts the number of submissions that received these scores instead of counting unique individuals.\
This means that if a person scored 10 points multiple times on different assignments, they are counted multiple times instead of just once.\
The correct approach ensures that each person is counted only once per score category, regardless of how many times they achieved that score.

</details>

<details>
<summary>Solution (mine)</summary>

```sql
WITH osoba_punkty AS (
	SELECT p.id_osoby, p.punkty
    FROM punktacja p
    WHERE p.punkty BETWEEN 10 AND 12
    GROUP BY p.id_osoby, p.punkty
)
SELECT
	o.grupa,
    SUM(CASE WHEN op.punkty = 10 THEN 1 ELSE 0 END) "10 punktow",
    SUM(CASE WHEN op.punkty = 11 THEN 1 ELSE 0 END) "11 punktow",
    SUM(CASE WHEN op.punkty = 12 THEN 1 ELSE 0 END) "12 punktow"
FROM osoba_punkty op
JOIN osoby o ON op.id_osoby = o.id_osoby
GROUP BY o.grupa
```

</details>

<details>
<summary>Answer (mine)</summary>

| grupa | 10 punktow | 11 punktow | 12 punktow |
| ----- | ---------- | ---------- | ---------- |
| G1    | 7          | 6          | 9          |
| G2    | 8          | 10         | 13         |
| G3    | 11         | 14         | 15         |
| G4    | 11         | 10         | 13         |
| G5    | 9          | 8          | 9          |

</details>

<details>
<summary>Solution (theirs)</summary>

```sql
SELECT
	o.grupa,
    SUM(CASE WHEN p.punkty = 10 THEN 1 ELSE 0 END) "10 punktow",
    SUM(CASE WHEN p.punkty = 11 THEN 1 ELSE 0 END) "11 punktow",
    SUM(CASE WHEN p.punkty = 12 THEN 1 ELSE 0 END) "12 punktow"
FROM punktacja p
JOIN osoby o ON p.id_osoby = o.id_osoby
GROUP BY o.grupa
```

</details>

<details>
<summary>Answer (theirs)</summary>

| grupa | 10 punktow | 11 punktow | 12 punktow |
| ----- | ---------- | ---------- | ---------- |
| G1    | 12         | 11         | 25         |
| G2    | 9          | 17         | 33         |
| G3    | 20         | 39         | 43         |
| G4    | 21         | 15         | 50         |
| G5    | 14         | 14         | 31         |

</details>

### 100.5

Podaj imiona i nazwiska osób, które nie wysłały przynajmniej jednej listy zadań. Zestawienie posortuj rosnąco ze względu na nazwiska osób.

<details>
<summary>Solution</summary>

```sql
SELECT o.imie, o.nazwisko
FROM osoby o
LEFT JOIN punktacja p ON o.id_osoby = p.id_osoby
LEFT JOIN listy l ON p.id_listy = l.id_listy
GROUP BY o.id_osoby
HAVING COUNT(*) < 11
ORDER BY o.nazwisko
```

</details>

<details>
<summary>Answer</summary>

| imie       | nazwisko  |
| ---------- | --------- |
| Robert     | Czaja     |
| Bartlomiej | Gosk      |
| Albert     | Mikos     |
| Krzysztof  | Plata     |
| Igor       | Rybarczyk |
| Karol      | Wojciul   |

</details>

## Zadanie 101

### 101.1

Podaj, ile kobiet i ilu mężczyzn uczęszczało na zajęcia Fitness TBC. Zwróć uwagę, że niektóre osoby mogły być na tych zajęciach kilkakrotnie, a w zestawieniu powinny być uwzględnione tylko raz.

<details>
<summary>Solution</summary>

```sql
SELECT o.Plec, COUNT(DISTINCT w.Id_uzytkownika) liczba
FROM osoby o
JOIN wejscia w ON o.Id_uzytkownika = w.Id_uzytkownika
JOIN zajecia z ON w.Id_zajec = z.Id_zajec
WHERE z.Zajecia = "Fitness TBC"
GROUP BY o.Plec
```

</details>

<details>
<summary>Answer</summary>

| Plec | liczba |
| ---- | ------ |
| K    | 90     |
| M    | 45     |

</details>

### 101.2

Utwórz zestawienie, w którym dla każdego obiektu podasz, jaką łączną kwotę zapłacono za prowadzone w nim zajęcia.

<details>
<summary>Solution</summary>

```sql
SELECT z.Obiekt, SUM(z.Koszt) kwota
FROM wejscia w
JOIN zajecia z ON w.Id_zajec = z.Id_zajec
GROUP BY z.Obiekt
```

</details>

<details>
<summary>Answer</summary>

| Obiekt            | kwota |
| ----------------- | ----- |
| Active            | 3334  |
| Aqua Park         | 2218  |
| Bodyfit           | 2180  |
| Lady Fitness Club | 924   |
| Platinium Center  | 1419  |
| Pure Jatomi       | 1771  |
| Redeco            | 3613  |
| Spartan           | 3173  |
| Top-Gym           | 1804  |

</details>

### 101.3

Podaj nazwiska i imiona osób, które w dniu 16 kwietnia 2014 r. uczestniczyły w więcej niż jednych zajęciach.

<details>
<summary>Solution</summary>

```sql
SELECT o.Nazwisko, o.Imie
FROM wejscia w
JOIN osoby o ON w.Id_uzytkownika = o.Id_uzytkownika
WHERE w.Data = "2014-04-16"
GROUP BY o.Id_uzytkownika
HAVING COUNT(*) > 1
```

</details>

<details>
<summary>Answer</summary>

| Nazwisko   | Imie    |
| ---------- | ------- |
| Kowalska   | Maria   |
| Olech      | Klaudia |
| Pozarzycka | Justyna |

</details>

### 101.4

Podaj rodzaj zajęć, w których uczestniczyło najwięcej osób. Podaj podaj liczbę tych osób i nazwę obiektu, w którym te zajęcia były prowadzone.

<details>
<summary>Comment to the solution</summary>

The task is to count the number of people who participated in the most popular type of activity.\
However, their solution incorrectly counts the number of entries instead of counting unique individuals.\
This means that if a person attended the same activity multiple times, they are counted multiple times instead of just once.\
The correct approach ensures that each person is counted only once per activity type, regardless of how many times they attended.

</details>

<details>
<summary>Solution (mine)</summary>

```sql
WITH zliczone AS (
  SELECT z.Zajecia, COUNT(DISTINCT w.Id_uzytkownika) liczba, z.Obiekt
	FROM wejscia w
	JOIN zajecia z ON w.Id_zajec = z.Id_zajec
  GROUP BY z.Id_zajec
)
SELECT *
FROM zliczone z
WHERE z.liczba = (SELECT MAX(liczba) FROM zliczone)
```

</details>

<details>
<summary>Answer (mine)</summary>

| Zajecia  | liczba | Obiekt  |
| -------- | ------ | ------- |
| Silownia | 121    | Redeco  |
| Silownia | 121    | Active  |
| Silownia | 121    | Bodyfit |
| Silownia | 121    | Spartan |

</details>

<details>
<summary>Solution (theirs)</summary>

```sql
SELECT z.Zajecia, COUNT(*) liczba, z.Obiekt
FROM wejscia w
JOIN zajecia z ON w.Id_zajec = z.Id_zajec
GROUP BY z.Id_zajec
ORDER BY liczba DESC
LIMIT 1
```

</details>

<details>
<summary>Answer (theirs)</summary>

| Zajecia  | liczba | Obiekt  |
| -------- | ------ | ------- |
| Silownia | 127    | Spartan |

</details>

### 101.5

Utwórz zestawienie, w którym dla każdego obiektu podasz, ile odnotowano w nim wejść na zajęcia. Zestawienie uporządkuj alfabetycznie według nazw obiektów.

<details>
<summary>Solution</summary>

```sql
SELECT z.Obiekt, COUNT(*) liczba
FROM wejscia w
JOIN zajecia z ON w.Id_zajec = z.Id_zajec
GROUP BY z.Obiekt
ORDER BY z.Obiekt
```

</details>

<details>
<summary>Answer</summary>

| Obiekt            | liczba |
| ----------------- | ------ |
| Active            | 339    |
| Aqua Park         | 226    |
| Bodyfit           | 223    |
| Lady Fitness Club | 84     |
| Platinium Center  | 120    |
| Pure Jatomi       | 161    |
| Redeco            | 383    |
| Spartan           | 300    |
| Top-Gym           | 164    |

</details>
