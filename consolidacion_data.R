## Data consolidada CNE & RC

load("Info.RData")
ls()

library(data.table)
library(dplyr)
library(haven)
library(sqldf)
ls("package:data.table")
ls("package:dplyr")

# Info CNE
d_cne <- data.table(datos_cne)
dim(d_cne)
unlist(lapply(d_cne, class))
# Info RC
d_rc <- data.table(datos_rc)
dim(d_rc)
unlist(lapply(d_rc, class))
# Fijamos keys para el merge
setkey(d_cne, identificacion)
setkey(d_rc, identificacion)
# cruce de info
data <- merge(d_cne, d_rc, all=TRUE)
dim(data)
colnames(data)
lapply(data, class)
# almacenamos la data cruzada
save(list = c("data"), file = "DataCruce.RData", envir = .GlobalEnv)
# eliminamos los archivos fuentes
rm(list=c("datos_cne", "datos_rc", "d_cne", "d_rc"))

### Cruzamos la informacion de desempeno 
load("DataCruce.RData")

base_info <- read_spss("base_con_info.sav")
base_info <- data.table(base_info)
base_info <- base_info[,.(NUM, PTO_OBS, MORA_N0, DIAS_VEN_N0, CANT_DESEMP, MAX_DIAS_VEN, GB_60, GB_90)]
head(base_info)
base_info$GB_60 <- as.numeric(base_info$GB_60)
base_info$GB_90 <- as.numeric(base_info$GB_90)
colnames(base_info) <- c("identificacion", "PTO_OBS", "MORA_N0", "DIAS_VEN_N0", "CANT_DESEMP", "MAX_DIAS_VEN", "GB_60", "GB_90")
unlist(lapply(base_info, class))

setkey(base_info, identificacion)
setkey(data, identificacion)

datos <- merge(data, base_info, all.y = TRUE)
head(datos)

with(datos, round(100*prop.table(table(provincia, GB_60), margin=1),2))

datos[provincia %in% c("ESMERALDAS", "GUAYAS", "LOS RIOS", "MANABI", "SANTA ELENA", "EL ORO")]







### Completamos variables
# llenamos provincia
data$provincia[is.na(data$provincia)] <- "SIN"
with(data, table(provincia))
# llenamos canton
data$canton[is.na(data$canton)] <- "SIN"
with(data, table(canton))
# llenamos parroquia
data$parroquia[is.na(data$parroquia)] <- "SIN"
with(data, table(parroquia))
# llenamos fecha nacimiento
data$fecha_nacimiento[is.na(data$fecha_nacimiento)] <- "2015-01-01 00:00:00.000"
# llenamos genero
data$genero[is.na(data$genero)] <- "M"
with(data, table(genero))


head(data)
tail(data)

data[provincia %in% c(NA)]
sum(with(data, table(provincia)))
summarise(d, table(provincia))
filter(flights, month == 1, day == 1)
