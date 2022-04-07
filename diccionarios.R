
library(dplyr)
library(quanteda)

midic <- dictionary(list(
  Adopciones = c("adopción","adopcion","adopciones"),
  Alquiler = c("alquiler","alquileres","inquilino","arrendatario"),                            
  ANCAP = c("ancap"),
  ANEP = c("anep"),
  ANTEL = c("antel"),
  Aumento_de_penas = c("penas","condena"),
  Colonización = c("colonización","colonizacion"),
  Combustible = c("combustible","combustibles"),
  Delito = c("delitos"),
  Educación = c("educación", "educativo", "educativa", "educacion"),
  Empresas_públicas = c("empresas públicas","empresa pública"),
  Pandemia = c("pandemia"),
  Portabilidad = c("portabilidad"),
  Regla_fiscal = c("regla fiscal"),
  Seguridad = c("seguridad"),
  Vivienda = c("vivienda"),
  Libertades = c("libertad", "libertades"),
  Derechos = c("derecho","derechos")
))


total_votasi_org = total_votasi %>%
  filter(is_retweet == FALSE)
  


dfm <- quanteda::dfm(quanteda::tokens(total_votasi_org$text),
                     tolower = TRUE,
                     verbose = FALSE)%>%
  quanteda::dfm_remove(c(stopwords("spanish"),"#votosi","#votasi","#votosí"),min_nchar=4)



midic_result<-dfm_lookup(dfm,dictionary=midic,nomatch="no_aparece")
midic_result=convert(midic_result, to = "data.frame") 

temasvotasi = midic_result %>%
  select(- doc_id)%>%
  summarise(across(everything(), ~ sum(., is.na(.), 0)))%>%
  t()%>%
  as.data.frame()


##votaNOderogar


total_votano_org = total_votano %>%
  filter(is_retweet == FALSE)



dfm <- quanteda::dfm(quanteda::tokens(total_votano_org$text),
                     tolower = TRUE,
                     verbose = FALSE)%>%
  quanteda::dfm_remove(c(stopwords("spanish"),"#votosi","#votasi","#votosí"),min_nchar=4)



midic_result<-dfm_lookup(dfm,dictionary=midic,nomatch="no_aparece")
midic_result=convert(midic_result, to = "data.frame") 

temasvotano = midic_result %>%
  select(- doc_id)%>%
  summarise(across(everything(), ~ sum(., is.na(.), 0)))%>%
  t()%>%
  as.data.frame()

temas2= cbind(temasvotasi,temasvotano)


prueba=reshape::melt(temas2)












