# code.R
# 
# Codi de la pràctica #2 de Tipologia i Cicle de Vida de les Dades
# UOC. 2021-2022.

# requirements:
# - library tidyverse
library(tidyverse)

setwd('D:/prg/TCVD-Practica2/code')
fitxer_ruta <- '../data/transfermarkt.csv'

# llegir el fitxer de dades
dades <- read.csv(file = fitxer_ruta)

# comprovar primeres files
head(dades)

# filtrar: llevar columnes innecessàries
players <- dades %>% select(-url, -owngoals, -yellowcards, -yellow2cards, -redcards)
players$age <- as.integer(players$age)

# comprovar tipus de de les columnes
sapply(players, function(x) class(x))

# Convertim el camp 'age' en numèric (integer)
class(players$age)
players$age <- as.integer(players$age)
class(players$age)

# Transformació columna `value`: dividim per 1.000.000 (milions d'euros)
summary(players$value)
players$value <- players$value / 1e6
summary(players$value)

# Nombre de files amb valor 0 per cada columna 
sapply(players, function(x) sum(x == 0))

# jugadors sense partits
nrow(players[players$matches == 0,])

# eliminem els jugadors sense partits del dataset
nrow(players[!players$matches == 0,])
players <- players[!players$matches == 0,]
nrow(players)

# Nombre de files amb columnes amb valor 0
sapply(players, function(x) sum(x == 0))

# Nombre de files amb columnes amb valors buits (NA)
sapply(players, function(x) sum(is.na(x)))

# Files amb valor NA per al camp 'age':
nrow(players[is.na(players$age),])
players[is.na(players$age), ]

# Filtrem el dataset llevant les files amb valor desconegut per al camp 'age'
nrow(players[!is.na(players$age), ])
players <- players[!is.na(players$age), ]
nrow(players)

########## 

# variables numèriques
columns <- c("age", "value", "matches", "goals", "assists", "subston", "substoff")

# Estadístiques
for (column in columns) {
  print(paste("summary(players$", column, ")", sep =""))
  print(summary(players[[column]]))
}

# Boxplots in PDF file
pdf("figures/boxplot.pdf")
for (column in columns) {
  title <- paste("Boxplotbo of players ", column, sep="")
  boxplot(players[[column]], ylab=column, main=title)
}
dev.off()

# Boxplots in PNG files
for (column in columns) {
  title <- paste("Boxplot of players ", column, sep="")
  pngfile <- paste("figures/boxplot-", column, ".png", sep="")
  png(pngfile)
  boxplot(players[[column]], ylab=column, main=title)
  dev.off()
}

# Outliers
for (column in columns) {
  print(paste("Outliers for players ", column, ":", sep=""))
  print(boxplot.stats(players[[column]])$out)
}

