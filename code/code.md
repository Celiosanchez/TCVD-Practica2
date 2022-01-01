
## Dataset original

Dataset original: 
* Fitxer: `data/transfermarkt.csv`
* Descripció: resultat de la pràctica #1
* Tipus de dades de les columnes.

| column           | type      |
|------------------|-----------|
| position_id      | integer   |
| position_ranking | integer   |
| player           | character |
| url              | character |
| position         | character |
| age              | character |
| country          | character |
| club             | character |
| value            | integer   |
| matches          | integer   |
| goals            | integer   |
| owngoals         | integer   |
| assists          | integer   |
| yellowcards      | integer   |
| yellow2cards     | integer   |
| redcards         | integer   |
| subston          | integer   |
| substoff         | integer   |

Accions a realitzar:
* Cal modificar el tipus del camp `age` a numèric (integer).

## Codi

Carreguem els paquets necessaris:
```
> library(tidyverse)
```

Carreguem el dataset des del fitxer:
```
> fitxer_ruta <- '../data/transfermarkt.csv'
> dades <- read.csv(file - fitxer_ruta)
```

Comprovem les primeres files:
```
> head(dades)
  position_id position_ranking                 player                                         url   position
1           1                1   Gianluigi Donnarumma /gianluigi-donnarumma/profil/spieler/315858 Goalkeeper
2           1                2       Thibaut Courtois     /thibaut-courtois/profil/spieler/108390 Goalkeeper
3           1                3              Jan Oblak            /jan-oblak/profil/spieler/121483 Goalkeeper
4           1                4                Alisson              /alisson/profil/spieler/105470 Goalkeeper
5           1                5                Ederson              /ederson/profil/spieler/238223 Goalkeeper
6           1                6 Marc-AndrÃ© ter Stegen /marc-andre-ter-stegen/profil/spieler/74857 Goalkeeper
  age  country                club    value matches goals owngoals assists yellowcards yellow2cards redcards
1  22    Italy Paris Saint-Germain 65000000      11     0        0       0           2            0        0
2  29  Belgium         Real Madrid 65000000      25     0        0       0           1            0        0
3  28 Slovenia AtlÃ©tico de Madrid 60000000      24     0        0       0           0            0        0
4  29   Brazil        Liverpool FC 60000000      24     0        1       0           0            0        0
5  28   Brazil     Manchester City 50000000      25     0        0       0           2            0        0
6  29  Germany        FC Barcelona 45000000      22     0        0       0           3            0        0
  subston substoff
1       0        0
2       0        0
3       0        0
4       0        0
5       0        0
6       0        0
```

Comprovem el tipus de dades les columnes:

```
> sapply(dades, function(x) class(x))
     position_id position_ranking           player              url         position              age 
       "integer"        "integer"      "character"      "character"      "character"      "character" 
         country             club            value          matches            goals         owngoals 
     "character"      "character"        "integer"        "integer"        "integer"        "integer" 
         assists      yellowcards     yellow2cards         redcards          subston         substoff 
       "integer"        "integer"        "integer"        "integer"        "integer"        "integer" 
```


Generem un nou dataset (`players`) com a resultat del filtre d'eliminar la quarta columan (url):
```
> players <- dades[, -(4)]
```

Comprovem les primeres files:
```
> head(players)
  position_id position_ranking                 player   position age  country                club    value
1           1                1   Gianluigi Donnarumma Goalkeeper  22    Italy Paris Saint-Germain 65000000
2           1                2       Thibaut Courtois Goalkeeper  29  Belgium         Real Madrid 65000000
3           1                3              Jan Oblak Goalkeeper  28 Slovenia AtlÃ©tico de Madrid 60000000
4           1                4                Alisson Goalkeeper  29   Brazil        Liverpool FC 60000000
5           1                5                Ederson Goalkeeper  28   Brazil     Manchester City 50000000
6           1                6 Marc-AndrÃ© ter Stegen Goalkeeper  29  Germany        FC Barcelona 45000000
  matches goals owngoals assists yellowcards yellow2cards redcards subston substoff
1      11     0        0       0           2            0        0       0        0
2      25     0        0       0           1            0        0       0        0
3      24     0        0       0           0            0        0       0        0
4      24     0        1       0           0            0        0       0        0
5      25     0        0       0           2            0        0       0        0
6      22     0        0       0           3            0        0       0        0

```

Nombre de files amb valor 0 per cada columna:
```
> sapply(players, function(x) sum(x == 0))
     position_id position_ranking           player         position              age          country 
               0                0                0                0                0                0 
            club            value          matches            goals         owngoals          assists 
               0                0             1321             3454             6336             3329 
     yellowcards     yellow2cards         redcards          subston         substoff 
            2503             6245             6222             2496             2096 
```

Comprovem jugadors sense partits (`matches` és igual a 0):
```
> nrow(players[players$matches == 0,])
[1] 1321
```

Comprovem jugadors amb partits:
```
> nrow(players[!players$matches == 0,])
[1] 5179
```

Eliminem els jugadors sense partits, deixant sols els que tenen partits disputats:
```
> players <- players[!players$matches == 0,]
> nrow(players)
[1] 5179
```

Convertim el camp 'age' en numèric (integer)
```
> players$age <- as.integer(players$age)
Warning message:
NAs introduced by coercion
```

Valors desconeguts per cada columna:
```
> sapply(players, function(x) sum(is.na(x)))
     position_id position_ranking           player         position              age          country 
               0                0                0                0                2                0 
            club            value          matches            goals         owngoals          assists 
               0                0                0                0                0                0 
     yellowcards     yellow2cards         redcards          subston         substoff 
               0                0                0                0                0 
```

Jugadors amb valor desconegut per al camp 'age':
```
> nrow(players[is.na(players$age),])
[1] 2
> players[is.na(players$age), ]
     position_id position_ranking           player       position age country             club  value matches
3406           8              406 Khaled Al Fadhli Right Midfield  NA  Kuwait        Qadsia SC 200000       2
5970          13              470    Milos Rosevic Second Striker  NA  Serbia FK Timok Zajecar  75000      17
     goals owngoals assists yellowcards yellow2cards redcards subston substoff
3406     0        0       0           0            0        0       0        1
5970     0        0       1           3            0        0       2        6
```

Filtrem el dataset llevant les files amb valor desconegut per al camp 'age'
```
[1] 5177
> players <- players[!is.na(players$age), ]
> nrow(players)
[1] 5177
```

