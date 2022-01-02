# code.R
# 
# Codi de la prï¿½ctica #2 de Tipologia i Cicle de Vida de les Dades
# UOC. 2021-2022.

# requirements:
# - library tidyverse
library(tidyverse)

# setwd('D:/prg/TCVD-Practica2/code')
fitxer_ruta <- '../data/transfermarkt.csv'

# llegir el fitxer de dades
dades <- read.csv(file = fitxer_ruta)

# comprovar primeres files
head(dades)

# comprovar tipus de de les columnes
sapply(dades, function(x) class(x))

# filtrar: llevar columnes 4 (url)
players <- dades[, -(4)]

head(players)

# Nombre de files amb valor 0 per cada columna 

sapply(players, function(x) sum(x == 0))

# per exemple, jugadors sense partits
nrow(players[players$matches == 0,])

# eliminem els jugadors sense partits del dataset
nrow(players[!players$matches == 0,])
players <- players[!players$matches == 0,]
nrow(players)

# Modifiquem la columna 'value' passant-la a milions d'euros
summary(players$value)
players$value <- players$value / 1000000
summary(players$value)

# Convertim el camp 'age' en numèric (integer)
players$age <- as.integer(players$age)

# Valors desconeguts per cada columna
sapply(players, function(x) sum(is.na(x)))

# Files amb valor NA  per al camp 'age':
nrow(players[is.na(players$age),])
players[is.na(players$age), ]

# Filtrem el dataset llevant les files amb valor desconegut per al camp 'age'
nrow(players[!is.na(players$age), ])
players <- players[!is.na(players$age), ]
nrow(players)

# Valor 'age' a 0
nrow(players[players$age == 0,])
players[players$age == 0,]

# Nombre de files amb valor 0 per cada columna 
sapply(players, function(x) sum(x == 0))

# variables numèriques
columns <- c("age", "value", "matches", "goals", "owngoals", "assists", "yellowcards", "yellow2cards", "redcards", "subston", "substoff")

# Estadístiques
for (column in columns) {
  print(paste("summary(players$", column, ")", sep =""))
  print(summary(players[[column]]))
}

# Boxplots in PDF file
pdf("figures/boxplot.pdf")
for (column in columns) {
  title <- paste("Boxplot of players ", column, sep="")
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


