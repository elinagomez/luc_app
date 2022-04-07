
remotes::install_github("mkearney/tweetbotornot2")


library(tweetbotornot2)




cuentas_bot_no<- total_votano %>%
  #filter(is_retweet==FALSE)%>%
  group_by(screen_name)%>%
  summarise(conteo=n())%>%
  arrange(desc(conteo))
 # top_n(100)
  


bot_no = predict_bot(cuentas_bot_no$screen_name)

bot_no$bot_bien = format(bot_no$prob_bot, scientific = FALSE)


cuentas_bot_si <- total_votasi %>%
  filter(is_retweet==FALSE)%>%
  group_by(screen_name)%>%
  summarise(conteo=n())%>%
  arrange(desc(conteo))%>%
  top_n(50)


bot_si = predict_bot(cuentas_bot_si$screen_name)

bot_si$bot_bien = format(bot_si$prob_bot, scientific = FALSE)



