
## Tipus de dades de les columnes

| column           | type      |
|------------------|-----------|
| position_id      | integer   | 
| position_ranking | integer   | 
| player           | character | 
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

## Codi

```
> library(tidyverse)
> fitxer_ruta <- '../data/transfermarkt.csv'
> dades <- read.csv(file - fitxer_ruta)
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
>
> sapply(dades, function(x) class(x))
     position_id position_ranking           player              url         position              age 
       "integer"        "integer"      "character"      "character"      "character"      "character" 
         country             club            value          matches            goals         owngoals 
     "character"      "character"        "integer"        "integer"        "integer"        "integer" 
         assists      yellowcards     yellow2cards         redcards          subston         substoff 
       "integer"        "integer"        "integer"        "integer"        "integer"        "integer" 
>
> players <- dades[, -(4)]
>
> # comprovar primeres files
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
>
> # comprovar tipus de de les columnes
> sapply(players, function(x) class(x))
     position_id position_ranking           player         position              age          country 
       "integer"        "integer"      "character"      "character"      "character"      "character" 
            club            value          matches            goals         owngoals          assists 
     "character"        "integer"        "integer"        "integer"        "integer"        "integer" 
     yellowcards     yellow2cards         redcards          subston         substoff 
       "integer"        "integer"        "integer"        "integer"        "integer" 
> 
> # Valors desconeguts per cada columna
> sapply(players, function(x) sum(is.na(x)))
     position_id position_ranking           player         position              age          country 
               0                0                0                0                0                0 
            club            value          matches            goals         owngoals          assists 
               0                0                0                0                0                0 
     yellowcards     yellow2cards         redcards          subston         substoff 
               0                0                0                0                0  
> 
> # Nombre de files amb valor 0 per cada columna 
> # per exemple, jugadors sense partits
> sapply(players, function(x) sum(x == 0))
     position_id position_ranking           player         position              age          country 
               0                0                0                0                0                0 
            club            value          matches            goals         owngoals          assists 
               0                0             1321             3454             6336             3329 
     yellowcards     yellow2cards         redcards          subston         substoff 
            2503             6245             6222             2496             2096 
>

```
