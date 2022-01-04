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

# seleccionem sols els jugadors amb més d'un partit 
nrow(players[players$matches > 2,])
players <- players[players$matches > 2,]
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
  
  imglink <- paste("![", title, "](/", pngfile, ")", sep="")
  print(imglink)
}

# Outliers
for (column in columns) {
  print(paste("Outliers for players ", column, ":", sep=""))
  print(boxplot.stats(players[[column]])$out)
}

# exclusió del jugadors amb menys de 3 partits
players <- players[players$matches > 2, ]

# 2 grups: jugadores defensius i ofensius 
# posicio_id < 7 (des del porter fins al mig defensiu) 
# posicio_id > 6 (des del mig-centre fins als davanters)

players.attack <- players[players$position_id > 6, ]
players.defens <- players[players$position_id < 7, ]

# afegim columna `type` per a difereciar entre jugadors:
# type = 1: defensiu
# type = 2: ofensiu

players$type <- with(players, ifelse(position_id < 7, 1, 2))

write.csv(players, "players.csv")

# Comprovació de la normalitat (Shapiro-Wilk)

for (column in columns) {
  print(paste("Shapiro Test: variable ", column, sep=""))
  print(shapiro.test(players[[column]]))
}

# Comprovació de l'homoscedasticitat: test de Fligner-Killeen

fligner.test(value ~ type, data = players)
fligner.test(goals ~ type, data = players)
fligner.test(age ~ type, data = players)

# 4.3. Aplicació de proves estadístiques per comparar els grups de dades


# anàlisi correlació entre les diferents variables numèriques:
  
cor(players %>% select(value, age, type, goals, matches))

# analisi de correlació amb els 2 grups de jugadors (defensius/ofensius)

cor(players.defens %>% select(value, age, goals, matches))
cor(players.attack %>% select(value, age, goals, matches))

# test de correlació de Spearman (per a variables sense  una distribució normal)


for (column in c("age", "type", "goals", "matches")) {
   print(paste("Test Spearman value-", column, sep=""))
   print(cor.test(players$value, players[[column]], method = "spearman"))
}

# correlació de Spearman de les variables `value` i `goals` en les 2 grups que hem definit:
  
cor.test(players.defens$value, players.defens$goals, method = "spearman")
cor.test(players.attack$value, players.attack$goals, method = "spearman")

# Visualització

# Boxplot `goals` i `assists` segon type:
title <- "Gols i assistencies per tipus de jugador"
pngfile <- "figures/boxplot-goals-assists-type.png"
png(pngfile)
boxplot(players.defens$goals, players.attack$goals, players.defens$assists, players.attack$assists, 
        horizontal = TRUE, 
        names=c("Gols-Def.", "Gols-Atac.", "Assist.-Def.", "Assist-Atac."), 
        col=c("orange", "green", "orange", "green"), 
        main=title
)
dev.off()

# Gràfic boxpolot `value` - `type`

title <- "Valor per tipus de jugador"
pngfile <- "figures/boxplot-value-type.png"
png(pngfile)
boxplot(players.defens$value, players.attack$value, col=c("red", "yellow"), main=title)
dev.off()



