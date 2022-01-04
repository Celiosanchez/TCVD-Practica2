# Pràctica 2: Neteja i anàlisi de les dades

- [Pràctica 2: Neteja i anàlisi de les dades](#pràctica-2-neteja-i-anàlisi-de-les-dades)
  - [0. Requeriments](#0-requeriments)
  - [1. Dataset](#1-dataset)
  - [2. Integració i selecció de les dades d’interès a analitzar](#2-integració-i-selecció-de-les-dades-dinterès-a-analitzar)
    - [2.1. Filtre de variables (columnes)](#21-filtre-de-variables-columnes)
      - [Selecció de columnes](#selecció-de-columnes)
      - [Conversió del tipus del camp `age`](#conversió-del-tipus-del-camp-age)
      - [Transformació sobre la columna `value`](#transformació-sobre-la-columna-value)
    - [2.2. Filtre de jugadors (files)](#22-filtre-de-jugadors-files)
      - [Eliminem files amb `matches == 0`](#eliminem-files-amb-matches--0)
  - [3. Neteja de les dades](#3-neteja-de-les-dades)
    - [3.1. Dades amb zeros i elements buits](#31-dades-amb-zeros-i-elements-buits)
      - [Nombre de files amb columnes amb valor 0](#nombre-de-files-amb-columnes-amb-valor-0)
    - [Nombre de files amb columnes amb valors buits (NA)](#nombre-de-files-amb-columnes-amb-valors-buits-na)
    - [3.2. Identificació i tractament de valors extrems](#32-identificació-i-tractament-de-valors-extrems)
      - [Comprovació de les estadístiques de les variables numèriques](#comprovació-de-les-estadístiques-de-les-variables-numèriques)
      - [Boxplots in PDF file](#boxplots-in-pdf-file)
      - [Boxplots in PNG files](#boxplots-in-png-files)
      - [Outliers per a cada columna](#outliers-per-a-cada-columna)
  - [4. Anàlisi de les dades.](#4-anàlisi-de-les-dades)
    - [4.1. Selecció dels grups de dades que es volen analitzar/comparar](#41-selecció-dels-grups-de-dades-que-es-volen-analitzarcomparar)
    - [4.2. Comprovació de la normalitat i homogeneïtat de la variància.](#42-comprovació-de-la-normalitat-i-homogeneïtat-de-la-variància)
    - [4.3. Aplicació de proves estadístiques per comparar els grups de dades.](#43-aplicació-de-proves-estadístiques-per-comparar-els-grups-de-dades)
  - [5. Representació dels resultats a partir de taules i gràfiques.](#5-representació-dels-resultats-a-partir-de-taules-i-gràfiques)
  - [6. Resolució del problema.](#6-resolució-del-problema)

## 0. Requeriments

Carreguem els paquets necessaris:
```
> library(tidyverse)
```

## 1. Dataset

Carreguem el dataset des del fitxer:
```
> fitxer_ruta <- '../data/transfermarkt.csv'
> dades <- read.csv(fitxer_ruta)
```

## 2. Integració i selecció de les dades d’interès a analitzar

### 2.1. Filtre de variables (columnes)

#### Selecció de columnes

Generem un nou dataset (`players`) com a resultat del filtre d'eliminar les columnes següents:

  - `url`: columna 4
  - `owngoals`: columna 12
  - `yellowcards`: columna 14
  - `yellow2cards`: columna 15
  - `redcards`: columna 16

```
> players <- dades %>% select(-url, -owngoals, -yellowcards, -yellow2cards, -redcards)
```

#### Conversió del tipus del camp `age`

Convertim el camp `age` en numèric (integer)

```
> class(players$age)
[1] "character"
> players$age <- as.integer(players$age)
Warning message:
NAs introduced by coercion
```

Nota: obtenim un `warning` de coerció. Aquesta advertència ens indica que no s'han pogut convertir tots els valors, i per tant algunes files es quedaran amb `age == NA`. Aquestes dades les tractarem en l'apartat 3.

#### Transformació sobre la columna `value` 

Dividim el valor de la columna `value` per 1.000.000 per a convertir en milions d'euros:

```
> summary(players$value)
     Min.   1st Qu.    Median      Mean   3rd Qu.      Max. 
    75000   1000000   2500000   5700862   5000000 160000000 
> players$value <- players$value / 1e6
> summary(players$value)
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
  0.075   1.000   2.500   5.701   5.000 160.000
```

Comprovem el resultat del filtre i conversions de columnes:

```
> head(players)
  position_id position_ranking                 player   position age  country                club value
1           1                1   Gianluigi Donnarumma Goalkeeper  22    Italy Paris Saint-Germain    65
2           1                2       Thibaut Courtois Goalkeeper  29  Belgium         Real Madrid    65
3           1                3              Jan Oblak Goalkeeper  28 Slovenia AtlÃ©tico de Madrid    60
4           1                4                Alisson Goalkeeper  29   Brazil        Liverpool FC    60
5           1                5                Ederson Goalkeeper  28   Brazil     Manchester City    50
6           1                6 Marc-AndrÃ© ter Stegen Goalkeeper  29  Germany        FC Barcelona    45
  matches goals assists subston substoff
1      11     0       0       0        0
2      25     0       0       0        0
3      24     0       0       0        0
4      24     0       0       0        0
5      25     0       0       0        0
6      22     0       0       0        0
```

### 2.2. Filtre de jugadors (files)

Comprovem jugadors sense partits (`matches`) és igual a 0):
```
> nrow(players[players$matches == 0,])
[1] 1321
```

Comprovem jugadors amb partits:
```
> nrow(players[!players$matches == 0,])
[1] 5179
```

#### Eliminem files amb `matches == 0`

Eliminem els jugadors sense partits, deixant sols els que tenen partits disputats:

```
> players <- players[!players$matches == 0,]
> nrow(players)
[1] 5179
```

## 3. Neteja de les dades

### 3.1. Dades amb zeros i elements buits

#### Nombre de files amb columnes amb valor 0

```
> sapply(players, function(x) sum(x == 0))
     position_id position_ranking           player         position              age          country 
               0                0                0                0               NA                0 
            club            value          matches            goals          assists          subston 
               0                0                0             2133             2008             1175 
        substoff 
             775
```

Obtenim els següents resultats:

* Les files amb `matches == 0` ja han sigut eliminades en l'apartat 2.
* Les columnes amb valors 0 són: `goals`, `assists`, `subston` i `substoff`. Són valors normals, ja que representen als jugadors que no han puntuat en aquestes estadísiques. No requereixen tractament.
* La columna `age` conté el valor NA, que tractarem al següent apartat.

### Nombre de files amb columnes amb valors buits (NA)

```
> sapply(players, function(x) sum(is.na(x)))
     position_id position_ranking           player         position              age          country 
               0                0                0                0                2                0 
            club            value          matches            goals          assists          subston 
               0                0                0                0                0                0 
        substoff 
               0 
```

Observem que hi ha 2 files amb edat desconeguda (`age == NA`). Consultem aquests jugadors:

```
> nrow(players[is.na(players$age),])
[1] 2
> players[is.na(players$age), ]
     position_id position_ranking           player       position age country             club value matches
3406           8              406 Khaled Al Fadhli Right Midfield  NA  Kuwait        Qadsia SC 0.200       2
5970          13              470    Milos Rosevic Second Striker  NA  Serbia FK Timok Zajecar 0.075      17
     goals assists subston substoff
3406     0       0       0        1
5970     0       1       2        6
```

Atès que es tracta d'un nombre reduït de files (sols 2), creiem que no és necessari utiltizar cap tècnica de tractament de valors desconeguts i podem ignorar-les. Esborrem les files:

```
> nrow(players)
[1] 5179
> nrow(players[!is.na(players$age), ])
[1] 5177
> players <- players[!is.na(players$age), ]
> nrow(players)
[1] 5177
```

### 3.2. Identificació i tractament de valors extrems

Identifiquem les variables numèriques:

```
> columns <- c("age", "value", "matches", "goals", "assists", "subston", "substoff")
> columns
[1] "age"      "value"    "matches"  "goals"    "assists"  "subston"  "substoff"
```

#### Comprovació de les estadístiques de les variables numèriques

```
> for (column in columns) {
+     print(paste("summary(players$", column, ")", sep =""))
+     print(summary(players[[column]]))
+ }
[1] "summary(players$age)"
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
  16.00   23.00   25.00   25.58   28.00   43.00 
[1] "summary(players$value)"
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
  0.075   1.300   3.000   6.670   6.500 160.000 
[1] "summary(players$matches)"
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
   1.00   12.00   17.00   16.13   21.00   36.00 
[1] "summary(players$goals)"
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
  0.000   0.000   1.000   2.004   3.000  30.000 
[1] "summary(players$assists)"
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
  0.000   0.000   1.000   1.585   2.000  17.000 
[1] "summary(players$subston)"
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
  0.000   1.000   3.000   3.669   6.000  23.000 
[1] "summary(players$substoff)"
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
  0.000   1.000   4.000   4.866   7.000  24.000 
```

#### Boxplots in PDF file

```
> pdf("figures/boxplot.pdf")
> for (column in columns) {
+     title <- paste("Boxplot of players ", column, sep="")
+     boxplot(players[[column]], ylab=column, main=title)
+ }
> dev.off()
RStudioGD 
        2 
```

#### Boxplots in PNG files

```
> for (column in columns) {
+     title <- paste("Boxplot of players ", column, sep="")
+     pngfile <- paste("figures/boxplot-", column, ".png", sep="")
+     
+     png(pngfile)
+     boxplot(players[[column]], ylab=column, main=title)
+     dev.off()
+     
+     imglink <- paste("![", title, "](", pngfile, ")", sep="")
+     print(imglink)
+ }
[1] "![Boxplot of players age](figures/boxplot-age.png)"
[1] "![Boxplot of players value](figures/boxplot-value.png)"
[1] "![Boxplot of players matches](figures/boxplot-matches.png)"
[1] "![Boxplot of players goals](figures/boxplot-goals.png)"
[1] "![Boxplot of players assists](figures/boxplot-assists.png)"
[1] "![Boxplot of players subston](figures/boxplot-subston.png)"
[1] "![Boxplot of players substoff](figures/boxplot-substoff.png)"
```

Resultat: 

![Boxplot of players age](figures/boxplot-age.png)
![Boxplot of players value](figures/boxplot-value.png)
![Boxplot of players matches](figures/boxplot-matches.png)
![Boxplot of players goals](figures/boxplot-goals.png)
![Boxplot of players assists](figures/boxplot-assists.png)
![Boxplot of players subston](figures/boxplot-subston.png)
![Boxplot of players substoff](figures/boxplot-substoff.png)

#### Outliers per a cada columna

```
> for (column in columns) {
+     print(paste("Outliers for players ", column, ":", sep=""))
+     print(boxplot.stats(players[[column]])$out)
+ }
[1] "Outliers for players age:"
 [1] 37 36 36 37 36 38 36 43 38 36 36 36 36 36 36 38 36 40 37 38 38 36 40
[1] "Outliers for players value:"
  [1]  65.0  65.0  60.0  60.0  50.0  45.0  32.0  32.0  25.0  25.0  25.0  25.0  22.0  20.0  20.0  20.0
 [17]  18.0  18.0  18.0  17.0  17.0  16.0  16.0  16.0  16.0  15.0  15.0  15.0  15.0  15.0  75.0  75.0
 [33]  65.0  65.0  65.0  60.0  60.0  60.0  55.0  55.0  55.0  50.0  50.0  50.0  48.0  45.0  45.0  45.0
 [49]  45.0  45.0  45.0  40.0  40.0  40.0  35.0  35.0  35.0  35.0  35.0  32.0  32.0  30.0  30.0  30.0
 [65]  30.0  30.0  30.0  30.0  28.0  28.0  28.0  28.0  28.0  25.0  25.0  25.0  25.0  25.0  25.0  25.0
 [81]  25.0  25.0  25.0  25.0  25.0  25.0  24.0  24.0  24.0  23.0  23.0  23.0  22.0  22.0  22.0  22.0
 [97]  22.0  22.0  22.0  22.0  20.0  20.0  20.0  20.0  20.0  20.0  20.0  20.0  18.0  18.0  18.0  18.0
[113]  18.0  18.0  18.0  18.0  18.0  18.0  18.0  18.0  18.0  17.0  17.0  17.0  17.0  17.0  16.0  16.0
[129]  16.0  16.0  16.0  15.0  15.0  15.0  15.0  15.0  15.0  15.0  15.0  15.0  15.0  70.0  65.0  50.0
[145]  48.0  42.0  40.0  40.0  38.0  35.0  32.0  30.0  28.0  25.0  25.0  22.0  20.0  20.0  20.0  20.0
[161]  18.0  18.0  18.0  18.0  17.0  17.0  17.0  16.0  16.0  15.0  15.0  15.0  15.0  15.0  15.0  80.0
[177]  70.0  60.0  55.0  38.0  30.0  28.0  25.0  25.0  25.0  25.0  25.0  25.0  25.0  25.0  25.0  23.0
[193]  22.0  22.0  20.0  20.0  20.0  20.0  18.0  18.0  18.0  18.0  18.0  18.0  17.0  17.0  17.0  16.0
[209]  16.0  15.0  15.0  15.0  85.0  75.0  70.0  60.0  60.0  60.0  50.0  45.0  45.0  40.0  40.0  40.0
[225]  40.0  40.0  35.0  35.0  35.0  35.0  30.0  30.0  30.0  30.0  28.0  27.0  26.0  25.0  25.0  25.0
[241]  23.0  22.0  22.0  20.0  20.0  20.0  20.0  20.0  20.0  20.0  20.0  20.0  18.0  18.0  17.0  17.0
[257]  16.0  16.0  16.0  15.0  15.0  15.0  15.0  85.0  80.0  75.0  70.0  70.0  70.0  70.0  65.0  60.0
[273]  55.0  55.0  55.0  55.0  55.0  50.0  50.0  48.0  45.0  45.0  40.0  40.0  40.0  40.0  38.0  35.0
[289]  35.0  35.0  33.0  32.0  32.0  32.0  30.0  30.0  30.0  30.0  30.0  30.0  28.0  27.0  27.0  26.0
[305]  25.0  25.0  25.0  25.0  25.0  25.0  25.0  25.0  24.0  24.0  24.0  22.0  22.0  22.0  22.0  22.0
[321]  22.0  22.0  22.0  22.0  20.0  20.0  20.0  20.0  20.0  20.0  19.0  18.0  18.0  18.0  18.0  18.0
[337]  18.0  18.0  18.0  18.0  18.0  18.0  17.5  17.0  17.0  16.0  16.0  16.0  15.0  15.0  15.0  15.0
[353]  15.0  15.0  15.0  15.0  15.0  15.0  15.0  15.0  15.0  15.0  15.0  15.0  25.0  22.0  18.0  15.0
[369]  65.0  40.0  35.0  32.0  30.0  20.0  20.0  15.0  15.0  90.0  90.0  75.0  75.0  70.0  70.0  55.0
[385]  55.0  50.0  50.0  50.0  42.0  42.0  40.0  38.0  35.0  35.0  30.0  30.0  27.0  25.0  25.0  25.0
[401]  25.0  25.0  25.0  22.0  22.0  20.0  20.0  20.0  20.0  20.0  20.0  20.0  20.0  18.0  18.0  18.0
[417]  18.0  17.0  16.0  16.0  16.0  16.0  16.0  15.0  15.0  15.0 100.0  90.0  85.0  85.0  85.0  80.0
[433]  80.0  80.0  70.0  70.0  60.0  60.0  45.0  40.0  40.0  40.0  35.0  35.0  32.0  32.0  30.0  30.0
[449]  28.0  28.0  28.0  28.0  27.0  25.0  25.0  24.0  22.0  22.0  22.0  22.0  20.0  20.0  20.0  20.0
[465]  20.0  18.0  18.0  18.0  18.0  18.0  18.0  18.0  18.0  17.0  17.0  16.0  16.0  16.0  16.0  15.0
[481]  15.0  15.0 100.0  70.0  70.0  60.0  55.0  50.0  45.0  45.0  40.0  40.0  40.0  40.0  40.0  38.0
[497]  35.0  35.0  35.0  33.0  32.0  30.0  30.0  30.0  30.0  28.0  28.0  27.0  27.0  25.0  25.0  25.0
[513]  25.0  25.0  22.0  22.0  22.0  22.0  22.0  22.0  20.0  20.0  20.0  20.0  20.0  18.0  18.0  18.0
[529]  18.0  17.0  16.0  16.0  16.0  16.0  15.0  15.0  15.0  15.0  15.0  15.0  15.0  15.0  60.0  50.0
[545]  50.0  40.0  30.0  25.0  19.0  18.0  18.0  15.0  15.0 160.0 150.0 100.0 100.0  80.0  70.0  60.0
[561]  60.0  55.0  50.0  50.0  50.0  45.0  45.0  45.0  40.0  40.0  40.0  40.0  38.0  38.0  38.0  35.0
[577]  35.0  35.0  35.0  33.0  32.0  32.0  32.0  32.0  30.0  30.0  30.0  28.0  28.0  28.0  27.0  25.0
[593]  25.0  25.0  22.0  22.0  22.0  22.0  22.0  22.0  22.0  22.0  21.0  20.0  20.0  20.0  20.0  20.0
[609]  20.0  20.0  20.0  20.0  20.0  20.0  20.0  20.0  18.0  18.0  18.0  18.0  18.0  18.0  17.5  17.0
[625]  17.0  17.0  17.0  17.0  17.0  17.0  16.0  16.0  16.0  16.0  15.0  15.0  15.0  15.0  15.0  15.0
[641]  15.0  15.0  15.0  15.0  15.0  15.0  15.0
[1] "Outliers for players matches:"
[1] 35 36
[1] "Outliers for players goals:"
  [1] 10  8  9  8  8  8  8 11  9  8  9 13  8  8  8 13  9  8 14  9  9 11 13  9 12  8  9  8  8 15 10 12
 [33]  8 10  9 10  8  9 13  9  9 17 16  8  9  8 11 12 10  8 11  8  8  9  9  8 10  8 10 12  9  9  9  9
 [65] 11 12  8  9  8  8 10 12  8 11  9 13 14  9  9 12 16  8 10 18 11 11 11 21 12 16  9  9 11  9  9  9
 [97]  8 11 19  8 11  9  8  9 22 11  8 13 11  8 11  8 11 10  8  9 10  8  9 10  8 14  9 11  8 14  9  9
[129] 10  8 13  9 17 11  8 10  9  8  8  8  9 11  8 13  8  8  8  8  8  9  8  9  9  9  8 25  8 16 14 12
[161] 12 10  8 10 15 19 11 11 20  9 16 30 10  8 16  9 12 10 18 15 12 18 16 14 22 10 20 14  8 18  9  8
[193] 14 22 14 12  8 27 10 14  9  8  9 19 13  9  8  9  8 13  9  8  9  9 20  8  8  9  8  9 10  8 13  9
[225]  8 18  9  9 11  8  8  8 11 11 10  8  8  9 10  8 12  9 16 14 12 13 11  9 11 14 17 16  9 12 10  9
[257] 15 10 10 11  8 17  8 11  9  8  8  8 13  9 13 10 19 13 12 14 10 12 14 22 10 10  8  9  8 11  9  8
[289]  8  9  9 10 10  9 16 11  8 14
[1] "Outliers for players assists:"
  [1]  6  6  6  8  7  6 16  9  6  6  6 10 11  7  6  6  7 13  6  6  8  7  6  7  7  6  6  6  9  6  8  7
 [33]  8  6  7  7  7  7  6  7  6  6  8  6  7  9  6  6  9  6  9  6  6 14  7  8  6  8  6  7 17  7 12  7
 [65]  9  6  6  6  7  6  7  9 10  7  9  6  6  6  6  6  6  6 10  7  6  6  8  6  6  7  6  8  9 11 10  6
 [97]  8  8  6  9  6  8  8  9  6 10  7  7  8  6  9  6  8  7  8  6  8  7  6  7  6 11  8  6  6  8 11  8
[129] 11 11  8 11  8  8  8 11  8  6  9 11  8  6 11  9  6 13  6  7  7  8  6  6  9  6  6  6 12 11  6  6
[161]  9  8 10  8  6  6  7  6  6  8  7  6  7  7  8 12  7  6  6  7  8 12  8  7  9  7  8 10  7 14  6  7
[193]  7  6  7 11  6  9  9 10  8  7  7  6  7 12  7  6  6  7  6  7 10  6  6  9  9  9  6  7  6  7  7  9
[225]  6  6 17 12  7  8  7  6  7  7  7  6  6 15  9  6  7  6  8  8  7  7  7  6  8  7  6  9  6  9  6  6
[257]  6  7  7  9  8  7  6  7  7  7  6  6
[1] "Outliers for players subston:"
  [1] 14 16 15 14 17 14 17 15 14 14 15 17 17 14 16 15 14 16 15 15 14 17 17 22 14 15 14 15 22 14 16 16
 [33] 14 20 14 14 15 15 16 17 15 15 14 19 17 16 14 14 15 15 17 15 14 15 15 16 16 18 19 15 15 16 20 18
 [65] 14 19 15 17 16 17 17 14 15 15 14 14 14 15 16 16 15 16 14 16 14 15 17 15 16 14 15 18 15 16 17 16
 [97] 19 15 14 14 14 18 18 17 16 15 17 14 15 14 23 15 16 14 15
[1] "Outliers for players substoff:"
 [1] 17 17 20 17 17 20 18 17 18 17 20 17 18 18 17 17 21 19 19 17 20 20 19 18 17 20 21 17 19 19 18 17
[33] 17 24 18 21 18 22 17 23 17 17 20 18 18 18 19 22 17
```

## 4. Anàlisi de les dades.

### 4.1. Selecció dels grups de dades que es volen analitzar/comparar 

```
> players.attack <- players[players$position_id > 6, ]
> players.defens <- players[players$position_id < 7, ]
```



### 4.2. Comprovació de la normalitat i homogeneïtat de la variància.

Comprovem la normalitat amb el test de Shapiro-Wink:


### 4.3. Aplicació de proves estadístiques per comparar els grups de dades. 

En funció de les dades i de l’objectiu de l’estudi, aplicar proves de contrast d’hipòtesis, correlacions, regressions, etc. Aplicar almenys tres mètodes d’anàlisi diferents. 

## 5. Representació dels resultats a partir de taules i gràfiques.

## 6. Resolució del problema.

