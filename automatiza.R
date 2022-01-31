library(taskscheduleR)
library(shiny)

#le aclaramos el script que queremos automatizar
script <- "C:/Users/Usuario/Documents/LUC/baja_tweets.R"

#elegimos un nombre, el archivo, la frecuencia, el horario y la fecha de comienzo:

 taskscheduler_create(taskname = "baja_tweets_luc", rscript = script, 
                      schedule = "DAILY", starttime = "03:00", 
                      startdate = format(Sys.Date(), "%d/%m/%Y"))


