library("httr")
library("foreign")
library("twitteR")
library(splitstackshape)
library("tidyverse")
library("sqldf")
library("ROAuth")
library("httr")
library("foreign")
library(tidyverse)
library(splitstackshape)
library(sqldf)
library("rtweet")
library("rjson")
library(mongolite)
library(beepr)


# ## nos conectamos a mongolite -----------------------------------------
# url_path = 'mongodb+srv://elinagomez:i25SJBackC3pKXV@cluster0.vl4me.mongodb.net/myFirstDatabase?retryWrites=true&w=majority'
# 
# url_path = "mongodb+srv://elinagomez:i25SJBackC3pKXV@cluster0.vl4me.mongodb.net/myFirstDatabase?retryWrites=true&w=majority"
# 
# url_path ="mongodb+srv://elinagomez:i25SJBackC3pKXV@cluster0.vl4me.mongodb.net/test"
# 
# 
# url_path = "mongodb+srv://elinagomez:i25SJBackC3pKXV@cluster0.vl4me.mongodb.net/myFirstDatabase?retryWrites=true&w=majority"
# 
# 
# url_path = "mongodb+srv://elinagomez:i25SJBackC3pKXV@cluster0.vl4me.mongodb.net/myFirstDatabase?retryWrites=true&w=majority"
# 
# url_path = 'mongodb+srv://elinagomez:i25SJBackC3pKXV@cluster0.vl4me.mongodb.net/test'
# descargamos los datasets necesarios -------------------------------------

options(scipen = 9999)

#Cargamos los datasets necesarios -----------------------------------------
### name_columns ------

##credenciales rtweet

token = create_token(app = "Cursocuali", 
                     consumer_key = "RPTRJroZJtehFMGs30pX96F7t",
                     consumer_secret = "ih7OJVNAnzwbpWVgedAB4D0B2rtSlCUG0X9EBuHNEoSGDkuqVm",
                     access_token = "2296175138-EJAjXB7H3gnnUIFxYWl53WPSv691LsZeLDXuNfE", 
                     access_secret = "6rTXlnlhaGtHuAnC6KCVuNqu60R4IBMyW3SSs0AArjWGJ", 
                     set_renv = TRUE)

##primer carga (09/12/2021) SOLO SE CORRE LA PRIMERA VEZ
#votosi <- search_tweets(
#  "#votosi", n = 18000, include_rts = TRUE,retryonratelimit=TRUE)
#votosi$date=Sys.Date()

##creo bd
#acumulada <- mongo(collection = "tweets_collection", 
#                 db = "acumulada",
#                 url = url_path)
#le pongo la primer carga con fecha
#acumulada$insert(votosi)


##CORRIDA DIARIA AUTOMÁTICA

# acumulada <- mongo(collection = "tweets_collection", 
#                    db = "acumulada",
#                    url = url_path)
# votosi_df_acumulada <- acumulada$find(query = '{}')


##votosidiaria - se corre diariamente


votosi_diaria <- search_tweets(
  "#votosi", n = 18000, include_rts = TRUE,retryonratelimit=TRUE)
votosi_diaria$date <- Sys.Date()

##homogeinizo nombres

votosi_diaria = votosi_diaria %>%
  select(-quote_count,-reply_count,-ext_media_type,-account_lang,
         -ext_media_t.co,-media_t.co,-urls_t.co)

##CAMBIAR CADA DÍA

votosi_diaria302022=votosi_diaria

save(votosi_diaria302022, file = paste0("C:/Users/Usuario/Documents/LUC/Bases_diarias/votosi/base", 
                              Sys.Date(),".RData")) 



##votasidiaria - se corre diariamente

votasi_diaria <- search_tweets(
  "#votasi", n = 18000, include_rts = TRUE,retryonratelimit=TRUE)
votasi_diaria$date <- Sys.Date()

votasi_diaria = votasi_diaria %>%
  select(-quote_count,-reply_count,-ext_media_type,-account_lang,
         -ext_media_t.co,-media_t.co,-urls_t.co)

##CAMBIAR CADA DÍA

votasi_diaria302022=votasi_diaria

save(votasi_diaria302022, file = paste0("C:/Users/Usuario/Documents/LUC/Bases_diarias/votasi/base_votasi", 
                                    Sys.Date(),".RData")) 


# ##base general sacando duplicados
# 
# votosi_crec <- rbind(votosi_df_acumulada, votosi_diaria)
# votosi_crec <- subset(votosi_crec,duplicated(votosi_crec$status_id)==F)
# 
# 
# ##saco lo que hay en duplicados y cargo acumulado
# 
# acumulada$drop()
# 
# acumulada$insert(votosi_crec)


##LUC diaria


##votosidiaria


luc_diaria <- search_tweets(
  "LUC", n = 18000, include_rts = TRUE,retryonratelimit=TRUE)
luc_diaria$date <- Sys.Date()

##homogeinizo nombres

luc_diaria = luc_diaria %>%
  select(-quote_count,-reply_count,-ext_media_type,-account_lang,
         -ext_media_t.co,-media_t.co,-urls_t.co)


##me quedo con Uruguay y/o Montevideo

luc_diaria_uru = luc_diaria%>%
dplyr::filter(grepl('Uruguay|Montevideo', location))


##ponerle nombre diferente al objeto!!!!!!!!!!!

luc_diaria_uru302022 = luc_diaria_uru

save(luc_diaria_uru302022, file = paste0("C:/Users/Usuario/Documents/LUC/Bases_diarias/luc/base_luc", 
                                  Sys.Date(),".RData")) 




##votaNOderogar

noderogar_diaria <- search_tweets(
  "#votaNOderogar", n = 18000, include_rts = TRUE,retryonratelimit=TRUE)
noderogar_diaria$date <- Sys.Date()

##homogeinizo nombres

noderogar_diaria = noderogar_diaria %>%
  select(-quote_count,-reply_count,-ext_media_type,-account_lang,
         -ext_media_t.co,-media_t.co,-urls_t.co)

##CAMBIAR CADA DÍA

noderogar_diaria302022=noderogar_diaria


save(noderogar_diaria302022, file = paste0("C:/Users/Usuario/Documents/LUC/Bases_diarias/votanoderogar/base_votanoderogar", 
                                   Sys.Date(),".RData")) 




##Screpeo Prensa


prensa_luc  = gdeltr2::ft_v2_api(
  terms = c("LUC", "Ley de Urgente Consideración"),
  modes = c("ArtList"),
  visualize_results = F,
  timespans = "55 days",
  source_countries = "UY"
) 

prensa_luc = subset(prensa_luc,duplicated(prensa_luc$titleArticle)==FALSE)

prensa_luc302022 = prensa_luc

save(prensa_luc302022, file = paste0("C:/Users/Usuario/Documents/LUC/Bases_diarias/prensa/prensa_luc", Sys.Date(),".RData")) 

