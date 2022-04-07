library(shiny)
library(shinydashboard)
library(dplyr)
library(purrr)
library(rlang)
library(stringr)
library(DT)
library(googlesheets4)
library(shinyWidgets)
library(plotly)
library(openxlsx)
library(dplyr)
library(wrapr)
library(shinycssloaders)
library(igraph)
library(visNetwork)
library(graphTweets) 
library(quanteda)
library(wordcloud2)



# ##Cargo datos por indicador

# load("tw_acumula.RData")
# 
# total_uni$fecha=as.Date(substr(total_uni$created_at,1,10))

source("carga_bases.R")


ui <- fluidPage( 
    includeCSS("www/elina.css"),
    #tags$style(HTML(".js-irs-0 .irs-single, .js-irs-0 .irs-bar-edge, .js-irs-0 .irs-bar {background: purple;border-color: purple}")),
    dashboardPage(
    
    skin = "purple",
                    dashboardHeader(
                        title = "ObservaLUC",
                        titleWidth = 200
                    ),
                    dashboardSidebar(
                        width = 180,
                        
                        
                        
                        sidebarMenu(
                            menuItem("Acerca de", tabName = "acercade", icon = icon("info")),
                            menuItem("     Twitter", tabName = "monitor", icon = icon("twitter"),
                                     menuSubItem("#votosi",tabName = "votosi"),
                                     menuSubItem("#votasi",tabName = "votasi"),
                                     menuSubItem("#votaNOderogar",tabName = "votano"),
                                     menuSubItem("LUC",tabName = "luc")),
                            menuItem("     Prensa", tabName = "prensa", icon = icon("newspaper"),
                                     menuSubItem("LUC",tabName = "luc_press"))
                            
                            
                        )
                        
                        
                    ),
                    dashboardBody(
                        
                        tabItems(
                            tabItem(tabName = "acercade",
                                    br(),
                                    h2("Observador social - Ley de Urgente Consideración (LUC)"),
                                    br()),
                            
                            # tabItem(tabName = "monitor", 
                            #         fluidRow(h4(""))),
                            
                            tabItem(tabName = "votosi",
                                    
                                    tabsetPanel(type= "tabs",
                                                tabPanel("Cantidad de Tweets",br(),br(),

                                                         fluidRow(valueBoxOutput("tweets_total",width = 4),
                                                             valueBoxOutput("tweets_ori",width = 3),
                                                             valueBoxOutput("retweets_total",width = 3)
                                        
                                                             ),
                                                         fluidRow(sliderInput("rango_votosi",
                                                                              label = "Seleccionar rango temporal",
                                                                              min = min(total_uni$created_at),
                                                                              max = max(total_uni$created_at),
                                                                              value=c(min(total_uni$created_at),max(total_uni$created_at)),
                                                                              timeFormat="%d-%m-%Y",width = "95%")),
                                                         
                                                         fluidRow(column(2,uiOutput("fecha_dato"))),
                                                         br(),
                                                         tags$h4("Evolución de Tweets #votosi",style="display:inline-block",
                                                         ),
                                                         div(style="display:inline-block", 
                                                             dropdown(
                                                                 style = "minimal",
                                                                 status = "royal",
                                                                 width = "150px",
                                                                 right = TRUE,
                                                                 icon = icon("info", lib = "font-awesome"),
                                                                 uiOutput("def_votosi"))
                                                         ),
                                                         br(),
                                                         br(),
                                                         fluidRow(
                                                             box("",
                                                                 status = "primary", solidHeader = TRUE,width = 12,
                                                                 
                                                                 plotly::plotlyOutput("plot_evolucion")%>% withSpinner(color="#6C0BA9",hide.ui = FALSE))
                                                             
                                                         ),
                                                         
                                                         
                                                         
                                                ),
                                                
                                                tabPanel("Comunidades",br(),br(),
                                                         br(),
                                                         tags$style(HTML(".js-irs-0 .irs-single, .js-irs-0 .irs-bar-edge, .js-irs-0 .irs-bar {background: purple;border-color: purple}")),
                                                         
                                                         # tags$h4("Análisis de comunidades",style="display:inline-block",
                                                         # ),
                                                         br(),
                                                         fluidRow(sliderInput("rango_votosi_comunidades",
                                                                              label = "Seleccionar rango temporal",
                                                                              min = min(total_uni$created_at),
                                                                              max = max(total_uni$created_at),
                                                                              value=c(min(total_uni$created_at),max(total_uni$created_at)),
                                                                              timeFormat="%d-%m-%Y",width = "95%")),
                                                         
                                                         br(),
                                                         br(),
                                                         fluidRow(
                                                             
                                                             visNetworkOutput("comunidades")%>%withSpinner(color="#6C0BA9",hide.ui = FALSE)
                                                             # box("",
                                                             #     status = "primary", solidHeader = TRUE,width = 12,
                                                             #     
                                                             #     plotOutput("comunidades")%>% withSpinner(color="#6C0BA9",hide.ui = FALSE))
                                                             
                                                         ),
                                                         
                                                ),
                                                
                                                tabPanel("Texto",br(),br(),
                                                         br(),
                                                         fluidRow(sliderInput("rango_votosi_texto",
                                                                              label = "Seleccionar rango temporal",
                                                                              min = min(total_uni$created_at),
                                                                              max = max(total_uni$created_at),
                                                                              value=c(min(total_uni$created_at),max(total_uni$created_at)),
                                                                              timeFormat="%d-%m-%Y",width = "95%")),
                                                         
                                                         br(),
                                                         br(),
                                                         tabsetPanel(tabPanel("Nubes de palabras",fluidRow(column(12, wordcloud2Output("nube_votosi")%>% withSpinner(color="#6C0BA9")))),
                                                                     tabPanel("Redes de co-ocurrencia", fluidRow(column(12, imageOutput("redes_votosi")%>% withSpinner(color="#6C0BA9")))))
                                                         
                                                ),
                                                tabPanel("Cuentas",br(),br(),
                                                         br(),
                                                         fluidRow(sliderInput("rango_votosi_cuentas",
                                                                              label = "Seleccionar rango temporal",
                                                                              min = min(total_uni$created_at),
                                                                              max = max(total_uni$created_at),
                                                                              value=c(min(total_uni$created_at),max(total_uni$created_at)),
                                                                              timeFormat="%d-%m-%Y",width = "95%")),
                                                         
                                                         br(),
                                                         br(),
                                                         DTOutput("cuentas_votosi")%>% withSpinner(color="#6C0BA9"),
                                                         
                                                         
                                                ),
                                                                                               
                                                
                                    )
                            ),
                            tabItem(tabName = "votasi",
                                    
                                    tabsetPanel(type= "tabs",
                                                tabPanel("Cantidad de Tweets",br(),br(),
                                                         
                                                         fluidRow(valueBoxOutput("tweets_total_votasi",width = 4),
                                                                  valueBoxOutput("tweets_ori_votasi",width = 3),
                                                                  valueBoxOutput("retweets_total_votasi",width = 3)
                                                                  
                                                         ),
                                                         fluidRow(sliderInput("rango_votasi",
                                                                              label = "Seleccionar rango temporal",
                                                                              min = min(total_votasi$created_at),
                                                                              max = max(total_votasi$created_at),
                                                                              value=c(min(total_votasi$created_at),max(total_votasi$created_at)),
                                                                              timeFormat="%d-%m-%Y",width = "95%")),
                                                         
                                                         br(),
                                                         tags$h4("Evolución de Tweets #votasi",style="display:inline-block",
                                                         ),
                                                         div(style="display:inline-block", 
                                                             dropdown(
                                                                 style = "minimal",
                                                                 status = "royal",
                                                                 width = "150px",
                                                                 right = TRUE,
                                                                 icon = icon("info", lib = "font-awesome"),
                                                                 uiOutput("def_votasi"))
                                                         ),
                                                         br(),
                                                         br(),
                                                         fluidRow(
                                                             box("",
                                                                 status = "primary", solidHeader = TRUE,width = 12,
                                                                 
                                                                 plotly::plotlyOutput("plot_evolucion_votasi")%>% withSpinner(color="#6C0BA9",hide.ui = FALSE))
                                                             
                                                         ),
                                                         
                                                         
                                                         
                                                ),
                                                
                                                tabPanel("Comunidades",br(),br(),
                                                         br(),
                                                         tags$style(HTML(".js-irs-0 .irs-single, .js-irs-0 .irs-bar-edge, .js-irs-0 .irs-bar {background: purple;border-color: purple}")),
                                                         
                                                         # tags$h4("Análisis de comunidades",style="display:inline-block",
                                                         # ),
                                                         br(),
                                                         fluidRow(sliderInput("rango_votasi_comunidades",
                                                                              label = "Seleccionar rango temporal",
                                                                              min = min(total_votasi$created_at),
                                                                              max = max(total_votasi$created_at),
                                                                              value=c(min(total_votasi$created_at),max(total_votasi$created_at)),
                                                                              timeFormat="%d-%m-%Y",width = "95%")),
                                                         
                                                         br(),
                                                         br(),
                                                         fluidRow(
                                                             
                                                             visNetworkOutput("comunidades_votasi")%>%withSpinner(color="#6C0BA9",hide.ui = FALSE)
                                                             # box("",
                                                             #     status = "primary", solidHeader = TRUE,width = 12,
                                                             #     
                                                             #     plotOutput("comunidades")%>% withSpinner(color="#6C0BA9",hide.ui = FALSE))
                                                             
                                                         ),
                                                         
                                                ),
                                                
                                                tabPanel("Texto",br(),br(),
                                                         br(),
                                                         fluidRow(sliderInput("rango_votasi_texto",
                                                                              label = "Seleccionar rango temporal",
                                                                              min = min(total_votasi$created_at),
                                                                              max = max(total_votasi$created_at),
                                                                              value=c(min(total_votasi$created_at),max(total_votasi$created_at)),
                                                                              timeFormat="%d-%m-%Y",width = "95%")),
                                                         
                                                         br(),
                                                         br(),
                                                         tabsetPanel(tabPanel("Nubes de palabras",fluidRow(column(12, wordcloud2Output("nube_votasi")%>% withSpinner(color="#6C0BA9")))),
                                                                     tabPanel("Redes de co-ocurrencia", fluidRow(column(12, imageOutput("redes_votasi")%>% withSpinner(color="#6C0BA9")))))
                                                         
                                                ),
                                                tabPanel("Cuentas",br(),br(),
                                                         br(),
                                                         fluidRow(sliderInput("rango_votasi_cuentas",
                                                                              label = "Seleccionar rango temporal",
                                                                              min = min(total_votasi$created_at),
                                                                              max = max(total_votasi$created_at),
                                                                              value=c(min(total_votasi$created_at),max(total_votasi$created_at)),
                                                                              timeFormat="%d-%m-%Y",width = "95%")),
                                                         
                                                         br(),
                                                         br(),
                                                         DTOutput("cuentas_votasi")%>% withSpinner(color="#6C0BA9"),
                                                         
                                                         
                                                ),
                                                
                                                
                                    )
                            ),
                            tabItem(tabName = "votano",
                                    
                                    tabsetPanel(type= "tabs",
                                                tabPanel("Cantidad de Tweets",br(),br(),
                                                         
                                                         fluidRow(valueBoxOutput("tweets_total_votano",width = 4),
                                                                  valueBoxOutput("tweets_ori_votano",width = 3),
                                                                  valueBoxOutput("retweets_total_votano",width = 3)
                                                                  
                                                         ),
                                                         fluidRow(sliderInput("rango_votano",
                                                                              label = "Seleccionar rango temporal",
                                                                              min = min(total_votano$created_at),
                                                                              max = max(total_votano$created_at),
                                                                              value=c(min(total_votano$created_at),max(total_votano$created_at)),
                                                                              timeFormat="%d-%m-%Y",width = "95%")),
                                                         
                                                         br(),
                                                         tags$h4("Evolución de Tweets #votaNOderogar",style="display:inline-block",
                                                         ),
                                                         div(style="display:inline-block", 
                                                             dropdown(
                                                                 style = "minimal",
                                                                 status = "royal",
                                                                 width = "150px",
                                                                 right = TRUE,
                                                                 icon = icon("info", lib = "font-awesome"),
                                                                 uiOutput("def_votano"))
                                                         ),
                                                         br(),
                                                         br(),
                                                         fluidRow(
                                                             box("",
                                                                 status = "primary", solidHeader = TRUE,width = 12,
                                                                 
                                                                 plotly::plotlyOutput("plot_evolucion_votano")%>% withSpinner(color="#6C0BA9",hide.ui = FALSE))
                                                             
                                                         ),
                                                         
                                                         
                                                         
                                                ),
                                                
                                                tabPanel("Comunidades",br(),br(),
                                                         br(),
                                                         tags$style(HTML(".js-irs-0 .irs-single, .js-irs-0 .irs-bar-edge, .js-irs-0 .irs-bar {background: purple;border-color: purple}")),
                                                         
                                                         # tags$h4("Análisis de comunidades",style="display:inline-block",
                                                         # ),
                                                         br(),
                                                         fluidRow(sliderInput("rango_votano_comunidades",
                                                                              label = "Seleccionar rango temporal",
                                                                              min = min(total_votano$created_at),
                                                                              max = max(total_votano$created_at),
                                                                              value=c(min(total_votano$created_at),max(total_votano$created_at)),
                                                                              timeFormat="%d-%m-%Y",width = "95%")),
                                                         
                                                         br(),
                                                         br(),
                                                         fluidRow(
                                                             
                                                             visNetworkOutput("comunidades_votano")%>%withSpinner(color="#6C0BA9",hide.ui = FALSE)
                                                             # box("",
                                                             #     status = "primary", solidHeader = TRUE,width = 12,
                                                             #     
                                                             #     plotOutput("comunidades")%>% withSpinner(color="#6C0BA9",hide.ui = FALSE))
                                                             
                                                         ),
                                                         
                                                ),
                                                
                                                tabPanel("Texto",br(),br(),
                                                         br(),
                                                         fluidRow(sliderInput("rango_votano_texto",
                                                                              label = "Seleccionar rango temporal",
                                                                              min = min(total_votano$created_at),
                                                                              max = max(total_votano$created_at),
                                                                              value=c(min(total_votano$created_at),max(total_votano$created_at)),
                                                                              timeFormat="%d-%m-%Y",width = "95%")),
                                                         
                                                         br(),
                                                         br(),
                                                         tabsetPanel(tabPanel("Nubes de palabras",fluidRow(column(12, wordcloud2Output("nube_votano")%>% withSpinner(color="#6C0BA9")))),
                                                                     tabPanel("Redes de co-ocurrencia", fluidRow(column(12, imageOutput("redes_votano")%>% withSpinner(color="#6C0BA9")))))
                                                         
                                                ),
                                                tabPanel("Cuentas",br(),br(),
                                                         br(),
                                                         fluidRow(sliderInput("rango_votano_cuentas",
                                                                              label = "Seleccionar rango temporal",
                                                                              min = min(total_votano$created_at),
                                                                              max = max(total_votano$created_at),
                                                                              value=c(min(total_votano$created_at),max(total_votano$created_at)),
                                                                              timeFormat="%d-%m-%Y",width = "95%")),
                                                         
                                                         br(),
                                                         br(),
                                                         DTOutput("cuentas_votano")%>% withSpinner(color="#6C0BA9"),
                                                         
                                                         
                                                ),
                                                
                                                
                                                
                                                
                                    )
                            ),
                            tabItem(tabName = "luc",
                                    
                                    tabsetPanel(type= "tabs",
                                                tabPanel("Cantidad de Tweets",br(),br(),
                                                         
                                                         fluidRow(valueBoxOutput("tweets_total_luc",width = 4),
                                                                  valueBoxOutput("tweets_ori_luc",width = 3),
                                                                  valueBoxOutput("retweets_total_luc",width = 3)
                                                                  
                                                         ),
                                                         fluidRow(sliderInput("rango_luc",
                                                                              label = "Seleccionar rango temporal",
                                                                              min = min(total_luc$created_at),
                                                                              max = max(total_luc$created_at),
                                                                              value=c(min(total_luc$created_at),max(total_luc$created_at)),
                                                                              timeFormat="%d-%m-%Y",width = "95%")),
                                                         
                                                         br(),
                                                         tags$h4("Evolución de Tweets LUC",style="display:inline-block",
                                                         ),
                                                         div(style="display:inline-block", 
                                                             dropdown(
                                                                 style = "minimal",
                                                                 status = "royal",
                                                                 width = "150px",
                                                                 right = TRUE,
                                                                 icon = icon("info", lib = "font-awesome"),
                                                                 uiOutput("def_luc"))
                                                         ),
                                                         br(),
                                                         br(),
                                                         fluidRow(
                                                             box("",
                                                                 status = "primary", solidHeader = TRUE,width = 12,
                                                                 
                                                                 plotly::plotlyOutput("plot_evolucion_luc")%>% withSpinner(color="#6C0BA9",hide.ui = FALSE))
                                                             
                                                         ),
                                                         
                                                         
                                                         
                                                ),
                                                
                                                tabPanel("Comunidades",br(),br(),
                                                         br(),
                                                         tags$style(HTML(".js-irs-0 .irs-single, .js-irs-0 .irs-bar-edge, .js-irs-0 .irs-bar {background: purple;border-color: purple}")),
                                                         
                                                         # tags$h4("Análisis de comunidades",style="display:inline-block",
                                                         # ),
                                                         br(),
                                                         fluidRow(sliderInput("rango_luc_comunidades",
                                                                              label = "Seleccionar rango temporal",
                                                                              min = min(total_luc$created_at),
                                                                              max = max(total_luc$created_at),
                                                                              value=c(min(total_luc$created_at),max(total_luc$created_at)),
                                                                              timeFormat="%d-%m-%Y",width = "95%")),
                                                         
                                                         br(),
                                                         br(),
                                                         fluidRow(
                                                             
                                                             visNetworkOutput("comunidades_luc")%>%withSpinner(color="#6C0BA9",hide.ui = FALSE)
                                                             # box("",
                                                             #     status = "primary", solidHeader = TRUE,width = 12,
                                                             #     
                                                             #     plotOutput("comunidades")%>% withSpinner(color="#6C0BA9",hide.ui = FALSE))
                                                             
                                                         ),
                                                         
                                                ),
                                                
                                                tabPanel("Texto",br(),br(),
                                                         br(),
                                                         fluidRow(sliderInput("rango_luc_texto",
                                                                              label = "Seleccionar rango temporal",
                                                                              min = min(total_luc$created_at),
                                                                              max = max(total_luc$created_at),
                                                                              value=c(min(total_luc$created_at),max(total_luc$created_at)),
                                                                              timeFormat="%d-%m-%Y",width = "95%")),
                                                         
                                                         br(),
                                                         br(),
                                                         tabsetPanel(tabPanel("Nubes de palabras",fluidRow(column(12, wordcloud2Output("nube_luc")%>% withSpinner(color="#6C0BA9")))),
                                                                     tabPanel("Redes de co-ocurrencia", fluidRow(column(12, imageOutput("redes_luc")%>% withSpinner(color="#6C0BA9")))))
                                                         
                                                ),
                                                tabPanel("Cuentas",br(),br(),
                                                         br(),
                                                         fluidRow(sliderInput("rango_luc_cuentas",
                                                                              label = "Seleccionar rango temporal",
                                                                              min = min(total_luc$created_at),
                                                                              max = max(total_luc$created_at),
                                                                              value=c(min(total_luc$created_at),max(total_luc$created_at)),
                                                                              timeFormat="%d-%m-%Y",width = "95%")),
                                                         
                                                         br(),
                                                         br(),
                                                         DTOutput("cuentas_luc")%>% withSpinner(color="#6C0BA9"),
                                                         
                                                         
                                                ),
                                                
                                                
                                    )
                            ),
                            
                            tabItem(tabName = "luc_press",
                                    
                                    tabsetPanel(type= "tabs",
                                                tabPanel("Cantidad de artículos",br(),br(),
                                                         
                                                         fluidRow(valueBoxOutput("art_total",width = 4),
                                                                  # valueBoxOutput("tweets_ori",width = 3),
                                                                  # valueBoxOutput("retweets_total",width = 3)
                                                                  
                                                         ),
                                                         fluidRow(sliderInput("rango_prensa",
                                                                              label = "Seleccionar rango temporal",
                                                                              min = min(total_prensa$datetimeArticle),
                                                                              max = max(total_prensa$datetimeArticle),
                                                                              value=c(min(total_prensa$datetimeArticle),max(total_prensa$datetimeArticle)),
                                                                              timeFormat="%d-%m-%Y",width = "100%")),
                                                         
                                                         br(),
                                                         tags$h4("Evolución de artículos de prensa",style="display:inline-block",
                                                         ),
                                                         div(style="display:inline-block", 
                                                             dropdown(
                                                                 style = "minimal",
                                                                 status = "royal",
                                                                 width = "150px",
                                                                 right = TRUE,
                                                                 icon = icon("info", lib = "font-awesome"),
                                                                 uiOutput("def_prensa"))
                                                         ),
                                                         br(),
                                                         br(),
                                                         fluidRow(
                                                             box("",
                                                                 status = "primary", solidHeader = TRUE,width = 12,
                                                                 
                                                                 plotly::plotlyOutput("plot_evolucion_prensa")%>% withSpinner(color="#6C0BA9",hide.ui = FALSE))
                                                             
                                                         ),
                                                         
                                                         
                                                         
                                                ),
                                                tabPanel("Evolución de medios",br(),br(),
                                                         br(),

                                                          tags$h4("Evolución de artículos según medios de comunicación",style="display:inline-block",
                                                          ),
                                                         br(),
                                                         fluidRow(sliderInput("rango_prensa_medios",
                                                                              label = "Seleccionar rango temporal",
                                                                              min = min(total_prensa$datetimeArticle),
                                                                              max = max(total_prensa$datetimeArticle),
                                                                              value=c(min(total_prensa$datetimeArticle),max(total_prensa$datetimeArticle)),
                                                                              timeFormat="%d-%m-%Y",width = "100%")),
                                                         
                                                         br(),
                                                         br(),
                                                         fluidRow(
                                                             
                                                             plotly::plotlyOutput("plot_prensa")%>%withSpinner(color="#6C0BA9",hide.ui = FALSE)
                                                             # box("",
                                                             #     status = "primary", solidHeader = TRUE,width = 12,
                                                             #     
                                                             #     plotOutput("comunidades")%>% withSpinner(color="#6C0BA9",hide.ui = FALSE))
                                                             
                                                         ),
                                                         
                                                ),
                                                tabPanel("Nubes según medios",br(),br(),
                                                         br(),
                                                         
                                                          tags$h4("Nubes de palabras según medios de comunicación",style="display:inline-block",
                                                          ),
                                                         br(),
                                                         br(),
                                                         fluidRow(

                                                              box("El País",
                                                                  status = "primary", solidHeader = TRUE,width = 6,
                                                                  sliderInput("rango_prensa_medios_nubes_elpais",
                                                                              label = "Seleccionar rango temporal",
                                                                              min = min(total_prensa$fecha),
                                                                              max = max(total_prensa$fecha),
                                                                              value=c(min(total_prensa$fecha),max(total_prensa$fecha)),
                                                                              timeFormat="%d-%m-%Y",width = "100%"),
                                                                  
                                                                  wordcloud2Output("plot_prensa_elpais")%>% withSpinner(color="#6C0BA9"))
                                                             
                                                         ,
                                                         box("La Diaria",
                                                             status = "primary", solidHeader = TRUE,width = 6,
                                                             sliderInput("rango_prensa_medios_nubes_ladiaria",
                                                                         label = "Seleccionar rango temporal",
                                                                         min = min(total_prensa$fecha),
                                                                         max = max(total_prensa$fecha),
                                                                         value=c(min(total_prensa$fecha),max(total_prensa$fecha)),
                                                                         timeFormat="%d-%m-%Y",width = "100%"),
                                                             
                                                             wordcloud2Output("plot_prensa_ladiaria")%>% withSpinner(color="#6C0BA9")),
                                                         
                                                         box("Subrayado",
                                                             status = "primary", solidHeader = TRUE,width = 6,
                                                             sliderInput("rango_prensa_medios_nubes_subrayado",
                                                                         label = "Seleccionar rango temporal",
                                                                         min = min(total_prensa$fecha),
                                                                         max = max(total_prensa$fecha),
                                                                         value=c(min(total_prensa$fecha),max(total_prensa$fecha)),
                                                                         timeFormat="%d-%m-%Y",width = "100%"),
                                                             
                                                             wordcloud2Output("plot_prensa_subrayado")%>% withSpinner(color="#6C0BA9")),
                                                         
                                                         box("La República",
                                                             status = "primary", solidHeader = TRUE,width = 6,
                                                             sliderInput("rango_prensa_medios_nubes_larepublica",
                                                                         label = "Seleccionar rango temporal",
                                                                         min = min(total_prensa$fecha),
                                                                         max = max(total_prensa$fecha),
                                                                         value=c(min(total_prensa$fecha),max(total_prensa$fecha)),
                                                                         timeFormat="%d-%m-%Y",width = "100%"),
                                                             
                                                             wordcloud2Output("plot_prensa_larepublica")%>% withSpinner(color="#6C0BA9")),
                                                         
                                                         box("Brecha",
                                                             status = "primary", solidHeader = TRUE,width = 6,
                                                             sliderInput("rango_prensa_medios_nubes_brecha",
                                                                         label = "Seleccionar rango temporal",
                                                                         min = min(total_prensa$fecha),
                                                                         max = max(total_prensa$fecha),
                                                                         value=c(min(total_prensa$fecha),max(total_prensa$fecha)),
                                                                         timeFormat="%d-%m-%Y",width = "100%"),
                                                             
                                                             wordcloud2Output("plot_prensa_brecha")%>% withSpinner(color="#6C0BA9")),
                                                         
                                                         box("Otros",
                                                             status = "primary", solidHeader = TRUE,width = 6,
                                                             sliderInput("rango_prensa_medios_nubes_otros",
                                                                         label = "Seleccionar rango temporal",
                                                                         min = min(total_prensa$fecha),
                                                                         max = max(total_prensa$fecha),
                                                                         value=c(min(total_prensa$fecha),max(total_prensa$fecha)),
                                                                         timeFormat="%d-%m-%Y",width = "100%"),
                                                             
                                                             wordcloud2Output("plot_prensa_otros")%>% withSpinner(color="#6C0BA9"))
                                                         
                                                         )
                                                         
                                                
                                                         
                                                ),
                        ))))))



server <- function(session, input, output) {
    
    
    
    tweets_votosi <- reactive({

        req(input$rango_votosi)

        total_uni %>%
            filter(created_at >= input$rango_votosi[1] &
                       created_at <= input$rango_votosi[2])

    })
    

    
    
    
    output$tweets_total <- renderValueBox({
        
       

        valueBox(value = tags$p(nrow(tweets_votosi()), style = "font-size: 100%;text-align:center;"),
                 subtitle = tags$p("Tweets", style = "font-size: 100%;;text-align:center;"),
                 color = "purple",icon = tags$i(class = "fas fa-users", style="font-size: 30px"),width = 1.8)
    })
    
    output$tweets_ori <- renderValueBox({
        
        ori = tweets_votosi() %>%
            filter(is_retweet==FALSE) 
        
        valueBox(value = tags$p(nrow(ori), style = "font-size: 100%;text-align:center;"),
                 subtitle = tags$p("Tweets originales", style = "font-size: 100%;;text-align:center;"),
                 color = "purple",icon = tags$i(class = "fas fa-users", style="font-size: 30px"),width = 1.8)
    })
    
    
    
    output$retweets_total <- renderValueBox({
        
        a = tweets_votosi() %>%
            filter(is_retweet==TRUE) 
        
        valueBox(value = tags$p(nrow(a), style = "font-size: 100%;text-align:center;"),
                 subtitle = tags$p("Re-Tweets", style = "font-size: 100%;;text-align:center;"),
                 color = "purple",icon = tags$i(class = "fas fa-users", style="font-size: 30px"),width = 1.8)
    })
    

        # 
    output$plot_evolucion <- plotly::renderPlotly({


        g1 <- tweets_votosi() %>%
            group_by(fecha,is_retweet)%>%
            summarise(n=n())%>%
            mutate(is_retweet = ifelse(is_retweet == "TRUE","Re-tweets","Tweets"))%>%
            mutate(is_retweet = factor(is_retweet,levels=c("Tweets","Re-tweets")))%>%
            ggplot(aes(fecha, y = as.numeric(n),color=is_retweet,group = is_retweet,
                       text = paste("</br>Tipo:",is_retweet,"</br>Fecha:",as.Date(fecha,"%Y-%m-%d"),"</br>Conteo:",round(as.numeric(n),1))))+
            geom_line(size = 1) +
            geom_point(size = 1,color="#6C0BA9") +
            scale_color_manual(values=c("#6C0BA9","#D7A1F9"))+
            scale_x_date(date_breaks = "4 day",date_labels  = "%d-%m")+
            theme(axis.text = element_text(size = 6),legend.position = "bottom",
                  legend.title = element_blank())+
            theme_minimal() +
            labs(x = "",
                 y = "")


        plotly::ggplotly(g1, width = (0.60*as.numeric(input$dimension[1])), height = as.numeric(input$dimension[2]),
                         hoverinfo = 'text',tooltip = c("text"))%>%
            plotly::layout(legend = list(orientation = "h",
                                         xanchor = "center",
                                         x = 0.5,y=-0.2,title = list(text= ""))) %>%

            plotly::config(displayModeBar = TRUE,
                           modeBarButtonsToRemove = list(
                               "pan2d",
                               "autoScale2d",
                               "resetScale2d",
                               "hoverClosestCartesian",
                               "hoverCompareCartesian",
                               "sendDataToCloud",
                               "toggleHover",
                               "resetViews",
                               "toggleSpikelines",
                               "resetViewMapbox"
                           ),showLink = FALSE,
                           displaylogo = FALSE)





    })
    # 
    # 
    # 
    # 
    # Definición:
    output$def_votosi <- renderUI({
        helpText(HTML(paste("<b>Definición:</b>",
                            "Se incluyen todos los tweets con el hashtag #votosi, sin distinción de localización geográfica.")))
    })
    
    
    tweets_votosi_comunidades <- reactive({
        
        req(input$rango_votosi_comunidades)
        
        total_uni %>%
            filter(created_at >= input$rango_votosi_comunidades[1] &
                       created_at <= input$rango_votosi_comunidades[2])
        
    })
    
    
    output$comunidades <- renderVisNetwork({
    
        
        votosi_retweets_network <- tweets_votosi_comunidades() %>% 
            #filter(retweet_screen_name %in% votosi$screen_name) %>%     # <- This is a new line and important.
            gt_edges(screen_name, retweet_screen_name, text) %>%             # It only keep retweets of other votosi members
            gt_graph()
        
        
        votosi_retweets_nodes <- igraph::as_data_frame(votosi_retweets_network, what = "vertices")
        
        # This adds some additional info to the nodes, so we get the names on hover
        # and the size of the node is based on its degree, etc.
        votosi_retweets_nodes <- votosi_retweets_nodes %>% 
            mutate(id = name) %>% 
            mutate(label = name) %>% 
            mutate(title = name) %>% 
            mutate(degree = degree(votosi_retweets_network)) %>% 
            mutate(value = degree)
        
        # This gets the edges, similar to how we got the nodes above
        votosi_retweets_edges <- igraph::as_data_frame(votosi_retweets_network, what = "edges")
        
        # This puts the text of the tweet itself into the edge
        # so when you hover over a line in the diagram it will show the tweet
        votosi_retweets_edges <- votosi_retweets_edges %>% 
            mutate(title = text)
        
        # # Creates the diagram
        # visNetwork(votosi_retweets_nodes, votosi_retweets_edges, main = "US votosi 
        # retweet network") %>% 
        #   visIgraphLayout(layout = "layout_nicely") %>% 
        #   visEdges(arrows = "to")
        
        
        votosi_retweets_nodes <- votosi_retweets_nodes %>% 
            mutate(group = membership(infomap.community(votosi_retweets_network)))
        
        
        visNetwork(votosi_retweets_nodes, votosi_retweets_edges, main = "Análisis de redes: #votosi") %>% 
            visIgraphLayout(layout = "layout_nicely") %>% 
            visEdges(arrows = "to") %>%   
            visOptions(highlightNearest = T, nodesIdSelection = T)
    
    })
    
    
    
    tweets_votosi_texto <- reactive({
        
        req(input$rango_votosi_texto)
        
        total_uni %>%
            filter(created_at >= input$rango_votosi_texto[1] &
                       created_at <= input$rango_votosi_texto[2])
        
    })
    
    
    
    
    
    base_votosi_texto <- eventReactive(input$rango_votosi_texto,{
        
        dfm <- quanteda::dfm(quanteda::tokens(tweets_votosi_texto()$text),
                             tolower = TRUE,
                             verbose = FALSE)%>%
            quanteda::dfm_remove(c(stopwords("spanish"),"#votosi","#votasi","#votosí"),min_nchar=4)%>%
            quanteda::dfm_trim(min_docfreq = 4)
 
    })  
    
    output$nube_votosi <- renderWordcloud2({
        
        base_votosi_texto()%>%
            quanteda.textstats::textstat_frequency()%>%
            as.data.frame()%>%
            select(feature ,frequency)%>%
            rename(word=feature,freq=frequency)%>%
            wordcloud2(size=0.9,color=c("#6b3fa0","#7a52aa","#8965b3","#9779bd","#a68cc6","#b59fd0","#c4b2d9","#d3c5e3","#e1d9ec","#f0ecf6","#000000"),backgroundColor = "grey")
        

    })
    
    
    output$redes_votosi <- renderPlot({
        
        base_fcm= base_votosi_texto()%>%
            fcm(context = "document")
        
        feat <- names(topfeatures(base_fcm, 120))
        
        base_fcm_select <- fcm_select(base_fcm, pattern = feat, selection = "keep")
        size <- log(colSums(dfm_select(base_fcm, feat, selection = "keep")))
        
        set.seed(144)
        quanteda.textplots::textplot_network(base_fcm_select, min_freq = 0.8, vertex_size = size / max(size) * 3,
                                             edge_color="#a791bf")
        
    })
    
    
    ##CUENTAS
    
    
    tweets_votosi_cuentas <- reactive({
        
        req(input$rango_votosi_cuentas)
        
        total_uni %>%

            filter(created_at >= input$rango_votosi_cuentas[1] &
                       created_at <= input$rango_votosi_cuentas[2])
        
    })
    
    
    
    
    
    base_votosi_cuentas <- eventReactive(input$rango_votosi_cuentas,{
        
        
        cuentas_votosi<- tweets_votosi_cuentas() %>%
            filter(is_retweet==TRUE)%>%
            group_by(retweet_name)%>%
            summarise(conteo=n())%>%
            #top_n(70)%>%
            arrange(desc(conteo))
        
        
    })  
    
    
    output$cuentas_votosi <- renderDT({
        
        
        datatable(
            base_votosi_cuentas(),
            rownames = TRUE,
            extensions = 'Buttons',
            options = list(
                pageLength = 50,
                dom = 'Bfrtip',
                buttons = list(
                    list(extend = 'csv', title = "Cuentas - votosi"), 
                    list(extend = 'excel', title = "Cuentas - votosi"), 
                    list(extend = 'pdf', title = "Cuentas - votosi") 
                )
            )
        )
        
        
    })
    
    
    
    
    
    
    
    
    
    
    ####votaNOderogar
    
    tweets_votano <- reactive({
        
        req(input$rango_votano)
        
        total_votano %>%
            filter(created_at >= input$rango_votano[1] &
                       created_at <= input$rango_votano[2])
        
    })
    
    
    
    
    
    output$tweets_total_votano <- renderValueBox({
        
        
        
        valueBox(value = tags$p(nrow(tweets_votano()), style = "font-size: 100%;text-align:center;"),
                 subtitle = tags$p("Tweets", style = "font-size: 100%;;text-align:center;"),
                 color = "purple",icon = tags$i(class = "fas fa-users", style="font-size: 30px"),width = 1.8)
    })
    
    output$tweets_ori_votano <- renderValueBox({
        
        ori = tweets_votano() %>%
            filter(is_retweet==FALSE) 
        
        valueBox(value = tags$p(nrow(ori), style = "font-size: 100%;text-align:center;"),
                 subtitle = tags$p("Tweets originales", style = "font-size: 100%;;text-align:center;"),
                 color = "purple",icon = tags$i(class = "fas fa-users", style="font-size: 30px"),width = 1.8)
    })
    
    
    
    output$retweets_total_votano <- renderValueBox({
        
        a = tweets_votano() %>%
            filter(is_retweet==TRUE) 
        
        valueBox(value = tags$p(nrow(a), style = "font-size: 100%;text-align:center;"),
                 subtitle = tags$p("Re-Tweets", style = "font-size: 100%;;text-align:center;"),
                 color = "purple",icon = tags$i(class = "fas fa-users", style="font-size: 30px"),width = 1.8)
    })
    
    
    # 
    output$plot_evolucion_votano <- plotly::renderPlotly({
        
        
        g1 <- tweets_votano() %>%
            group_by(fecha,is_retweet)%>%
            summarise(n=n())%>%
            mutate(is_retweet = ifelse(is_retweet == "TRUE","Re-tweets","Tweets"))%>%
            mutate(is_retweet = factor(is_retweet,levels=c("Tweets","Re-tweets")))%>%
            ggplot(aes(fecha, y = as.numeric(n),color=is_retweet,group = is_retweet,
                       text = paste("</br>Tipo:",is_retweet,"</br>Fecha:",as.Date(fecha,"%Y-%m-%d"),"</br>Conteo:",round(as.numeric(n),1))))+
            geom_line(size = 1) +
            geom_point(size = 1,color="#6C0BA9") +
            scale_color_manual(values=c("#6C0BA9","#D7A1F9"))+
            scale_x_date(date_breaks = "4 day",date_labels  = "%d-%m")+
            theme(axis.text = element_text(size = 6),legend.position = "bottom",
                  legend.title = element_blank())+
            theme_minimal() +
            labs(x = "",
                 y = "")
        
        
        plotly::ggplotly(g1, width = (0.60*as.numeric(input$dimension[1])), height = as.numeric(input$dimension[2]),
                         hoverinfo = 'text',tooltip = c("text"))%>%
            plotly::layout(legend = list(orientation = "h",
                                         xanchor = "center",
                                         x = 0.5,y=-0.2,title = list(text= ""))) %>%
            
            plotly::config(displayModeBar = TRUE,
                           modeBarButtonsToRemove = list(
                               "pan2d",
                               "autoScale2d",
                               "resetScale2d",
                               "hoverClosestCartesian",
                               "hoverCompareCartesian",
                               "sendDataToCloud",
                               "toggleHover",
                               "resetViews",
                               "toggleSpikelines",
                               "resetViewMapbox"
                           ),showLink = FALSE,
                           displaylogo = FALSE)
        
        
        
        
        
    })
    # 
    # 
    # 
    # 
    # Definición:
    output$def_votano <- renderUI({
        helpText(HTML(paste("<b>Definición:</b>",
                            "Se incluyen todos los tweets con el hashtag #votaNOderogar, sin distinción de localización geográfica.")))
    })
    
    
    tweets_votano_comunidades <- reactive({
        
        req(input$rango_votano_comunidades)
        
        total_votano %>%
            filter(created_at >= input$rango_votano_comunidades[1] &
                       created_at <= input$rango_votano_comunidades[2])
        
    })
    
    
    output$comunidades_votano <- renderVisNetwork({
        
        
        votano_retweets_network <- tweets_votano_comunidades() %>% 
            #filter(retweet_screen_name %in% votosi$screen_name) %>%     # <- This is a new line and important.
            gt_edges(screen_name, retweet_screen_name, text) %>%             # It only keep retweets of other votosi members
            gt_graph()
        
        
        votano_retweets_nodes <- igraph::as_data_frame(votano_retweets_network, what = "vertices")
        
        # This adds some additional info to the nodes, so we get the names on hover
        # and the size of the node is based on its degree, etc.
        votano_retweets_nodes <- votano_retweets_nodes %>% 
            mutate(id = name) %>% 
            mutate(label = name) %>% 
            mutate(title = name) %>% 
            mutate(degree = degree(votano_retweets_network)) %>% 
            mutate(value = degree)
        
        # This gets the edges, similar to how we got the nodes above
        votano_retweets_edges <- igraph::as_data_frame(votano_retweets_network, what = "edges")
        
        # This puts the text of the tweet itself into the edge
        # so when you hover over a line in the diagram it will show the tweet
        votano_retweets_edges <- votano_retweets_edges %>% 
            mutate(title = text)
        
        # # Creates the diagram
        # visNetwork(votosi_retweets_nodes, votosi_retweets_edges, main = "US votosi 
        # retweet network") %>% 
        #   visIgraphLayout(layout = "layout_nicely") %>% 
        #   visEdges(arrows = "to")
        
        
        votano_retweets_nodes <- votano_retweets_nodes %>% 
            mutate(group = membership(infomap.community(votano_retweets_network)))
        
        
        visNetwork(votano_retweets_nodes, votano_retweets_edges, main = "Análisis de redes: #votaNOderogar") %>% 
            visIgraphLayout(layout = "layout_nicely") %>% 
            visEdges(arrows = "to") %>%   
            visOptions(highlightNearest = T, nodesIdSelection = T)
        
    })
    
    
    
    tweets_votano_texto <- reactive({
        
        req(input$rango_votano_texto)
        
        total_votano %>%
            filter(created_at >= input$rango_votano_texto[1] &
                       created_at <= input$rango_votano_texto[2])
        
    })
    
    
    
    
    
    base_votano_texto <- eventReactive(input$rango_votano_texto,{
        
        dfm <- quanteda::dfm(quanteda::tokens(tweets_votano_texto()$text),
                             tolower = TRUE,
                             verbose = FALSE)%>%
            quanteda::dfm_remove(c(stopwords("spanish"),"#votalaceleste","#votaNOderogar","luc"),min_nchar=4)%>%
            quanteda::dfm_trim(min_docfreq = 4)
        
    })  
    
    output$nube_votano <- renderWordcloud2({
        
        base_votano_texto()%>%
            quanteda.textstats::textstat_frequency()%>%
            as.data.frame()%>%
            select(feature ,frequency)%>%
            rename(word=feature,freq=frequency)%>%
            wordcloud2(size=0.9,color=c("#6b3fa0","#7a52aa","#8965b3","#9779bd","#a68cc6","#b59fd0","#c4b2d9","#d3c5e3","#e1d9ec","#f0ecf6","#000000"),backgroundColor = "grey")
        
        
    })
    
    
    output$redes_votano <- renderPlot({
        
        base_fcm= base_votano_texto()%>%
            fcm(context = "document")
        
        feat <- names(topfeatures(base_fcm, 120))
        
        base_fcm_select <- fcm_select(base_fcm, pattern = feat, selection = "keep")
        size <- log(colSums(dfm_select(base_fcm, feat, selection = "keep")))
        
        set.seed(144)
        quanteda.textplots::textplot_network(base_fcm_select, min_freq = 0.8, vertex_size = size / max(size) * 3,
                                             edge_color="#a791bf")
        
    })
    
    
    
    ##CUENTAS
    
    
    tweets_votano_cuentas <- reactive({
        
        req(input$rango_votano_cuentas)
        
        total_votano %>%
            filter(created_at >= input$rango_votano_cuentas[1] &
                       created_at <= input$rango_votano_cuentas[2])
        
    })
    
    
    
    
    
    base_votano_cuentas <- eventReactive(input$rango_votano_cuentas,{
        
        
        cuentas_votano<- tweets_votano_cuentas() %>%
            filter(is_retweet==TRUE)%>%
            group_by(retweet_name)%>%
            summarise(conteo=n())%>%
            #top_n(70)%>%
            arrange(desc(conteo))
        
        
    })  
    
    
    output$cuentas_votano <- renderDT({
        
        
        datatable(
            base_votano_cuentas(),
            rownames = TRUE,
            extensions = 'Buttons',
            options = list(
                pageLength = 50,
                dom = 'Bfrtip',
                buttons = list(
                    list(extend = 'csv', title = "Cuentas - votano"), 
                    list(extend = 'excel', title = "Cuentas - votano"), 
                    list(extend = 'pdf', title = "Cuentas - votano") 
                )
            )
        )
        
        
    })
    
    
    
    
    
    
    
    
    ####votasi
    
    tweets_votasi <- reactive({
        
        req(input$rango_votasi)
        
        total_votasi %>%
            filter(created_at >= input$rango_votasi[1] &
                       created_at <= input$rango_votasi[2])
        
    })
    
    
    
    
    
    output$tweets_total_votasi <- renderValueBox({
        
        
        
        valueBox(value = tags$p(nrow(tweets_votasi()), style = "font-size: 100%;text-align:center;"),
                 subtitle = tags$p("Tweets", style = "font-size: 100%;;text-align:center;"),
                 color = "purple",icon = tags$i(class = "fas fa-users", style="font-size: 30px"),width = 1.8)
    })
    
    output$tweets_ori_votasi <- renderValueBox({
        
        ori = tweets_votasi() %>%
            filter(is_retweet==FALSE) 
        
        valueBox(value = tags$p(nrow(ori), style = "font-size: 100%;text-align:center;"),
                 subtitle = tags$p("Tweets originales", style = "font-size: 100%;;text-align:center;"),
                 color = "purple",icon = tags$i(class = "fas fa-users", style="font-size: 30px"),width = 1.8)
    })
    
    
    
    output$retweets_total_votasi <- renderValueBox({
        
        a = tweets_votasi() %>%
            filter(is_retweet==TRUE) 
        
        valueBox(value = tags$p(nrow(a), style = "font-size: 100%;text-align:center;"),
                 subtitle = tags$p("Re-Tweets", style = "font-size: 100%;;text-align:center;"),
                 color = "purple",icon = tags$i(class = "fas fa-users", style="font-size: 30px"),width = 1.8)
    })
    
    
    # 
    output$plot_evolucion_votasi <- plotly::renderPlotly({
        
        
        g1 <- tweets_votasi() %>%
            group_by(fecha,is_retweet)%>%
            summarise(n=n())%>%
            mutate(is_retweet = ifelse(is_retweet == "TRUE","Re-tweets","Tweets"))%>%
            mutate(is_retweet = factor(is_retweet,levels=c("Tweets","Re-tweets")))%>%
            ggplot(aes(fecha, y = as.numeric(n),color=is_retweet,group = is_retweet,
                       text = paste("</br>Tipo:",is_retweet,"</br>Fecha:",as.Date(fecha,"%Y-%m-%d"),"</br>Conteo:",round(as.numeric(n),1))))+
            geom_line(size = 1) +
            geom_point(size = 1,color="#6C0BA9") +
            scale_color_manual(values=c("#6C0BA9","#D7A1F9"))+
            scale_x_date(date_breaks = "4 day",date_labels  = "%d-%m")+
            theme(axis.text = element_text(size = 6),legend.position = "bottom",
                  legend.title = element_blank())+
            theme_minimal() +
            labs(x = "",
                 y = "")
        
        
        plotly::ggplotly(g1, width = (0.60*as.numeric(input$dimension[1])), height = as.numeric(input$dimension[2]),
                         hoverinfo = 'text',tooltip = c("text"))%>%
            plotly::layout(legend = list(orientation = "h",
                                         xanchor = "center",
                                         x = 0.5,y=-0.2,title = list(text= ""))) %>%
            
            plotly::config(displayModeBar = TRUE,
                           modeBarButtonsToRemove = list(
                               "pan2d",
                               "autoScale2d",
                               "resetScale2d",
                               "hoverClosestCartesian",
                               "hoverCompareCartesian",
                               "sendDataToCloud",
                               "toggleHover",
                               "resetViews",
                               "toggleSpikelines",
                               "resetViewMapbox"
                           ),showLink = FALSE,
                           displaylogo = FALSE)
        
        
        
        
        
    })
    # 
    # 
    # 
    # 
    # Definición:
    output$def_votasi <- renderUI({
        helpText(HTML(paste("<b>Definición:</b>",
                            "Se incluyen todos los tweets con el hashtag #votasi, sin distinción de localización geográfica.")))
    })
    
    
    tweets_votasi_comunidades <- reactive({
        
        req(input$rango_votasi_comunidades)
        
        total_votasi %>%
            filter(created_at >= input$rango_votasi_comunidades[1] &
                       created_at <= input$rango_votasi_comunidades[2])
        
    })
    
    
    output$comunidades_votasi <- renderVisNetwork({
        
        
        votasi_retweets_network <- tweets_votasi_comunidades() %>% 
            #filter(retweet_screen_name %in% votosi$screen_name) %>%     # <- This is a new line and important.
            gt_edges(screen_name, retweet_screen_name, text) %>%             # It only keep retweets of other votosi members
            gt_graph()
        
        
        votasi_retweets_nodes <- igraph::as_data_frame(votasi_retweets_network, what = "vertices")
        
        # This adds some additional info to the nodes, so we get the names on hover
        # and the size of the node is based on its degree, etc.
        votasi_retweets_nodes <- votasi_retweets_nodes %>% 
            mutate(id = name) %>% 
            mutate(label = name) %>% 
            mutate(title = name) %>% 
            mutate(degree = degree(votasi_retweets_network)) %>% 
            mutate(value = degree)
        
        # This gets the edges, similar to how we got the nodes above
        votasi_retweets_edges <- igraph::as_data_frame(votasi_retweets_network, what = "edges")
        
        # This puts the text of the tweet itself into the edge
        # so when you hover over a line in the diagram it will show the tweet
        votasi_retweets_edges <- votasi_retweets_edges %>% 
            mutate(title = text)
        
        # # Creates the diagram
        # visNetwork(votosi_retweets_nodes, votosi_retweets_edges, main = "US votosi 
        # retweet network") %>% 
        #   visIgraphLayout(layout = "layout_nicely") %>% 
        #   visEdges(arrows = "to")
        
        
        votasi_retweets_nodes <- votasi_retweets_nodes %>% 
            mutate(group = membership(infomap.community(votasi_retweets_network)))
        
        
        visNetwork(votasi_retweets_nodes, votasi_retweets_edges, main = "Análisis de redes: #votasi") %>% 
            visIgraphLayout(layout = "layout_nicely") %>% 
            visEdges(arrows = "to") %>%   
            visOptions(highlightNearest = T, nodesIdSelection = T)
        
    })
    
    
    
    tweets_votasi_texto <- reactive({
        
        req(input$rango_votasi_texto)
        
        total_votasi %>%
            filter(created_at >= input$rango_votasi_texto[1] &
                       created_at <= input$rango_votasi_texto[2])
        
    })
    
    
    
    
    
    base_votasi_texto <- eventReactive(input$rango_votasi_texto,{
        
        dfm <- quanteda::dfm(quanteda::tokens(tweets_votasi_texto()$text),
                             tolower = TRUE,
                             verbose = FALSE)%>%
            quanteda::dfm_remove(c(stopwords("spanish"),"#votosi","#votási","#votasi","#votasí","#votásí","#votosí","#votasi","luc"),min_nchar=4)%>%
            quanteda::dfm_trim(min_docfreq = 4)
        
    })  
    
    output$nube_votasi <- renderWordcloud2({
        
        base_votasi_texto()%>%
            quanteda.textstats::textstat_frequency()%>%
            as.data.frame()%>%
            select(feature ,frequency)%>%
            rename(word=feature,freq=frequency)%>%
            wordcloud2(size=0.9,color=c("#6b3fa0","#7a52aa","#8965b3","#9779bd","#a68cc6","#b59fd0","#c4b2d9","#d3c5e3","#e1d9ec","#f0ecf6","#000000"),backgroundColor = "grey")
        
        
    })
    
    
    output$redes_votasi <- renderPlot({
        
        base_fcm= base_votasi_texto()%>%
            fcm(context = "document")
        
        feat <- names(topfeatures(base_fcm, 120))
        
        base_fcm_select <- fcm_select(base_fcm, pattern = feat, selection = "keep")
        size <- log(colSums(dfm_select(base_fcm, feat, selection = "keep")))
        
        set.seed(144)
        quanteda.textplots::textplot_network(base_fcm_select, min_freq = 0.8, vertex_size = size / max(size) * 3,
                                             edge_color="#a791bf")
        
    })
    
    
    
    
    tweets_votasi_cuentas <- reactive({
        
        req(input$rango_votasi_cuentas)
        
        total_votasi %>%
            filter(created_at >= input$rango_votasi_cuentas[1] &
                       created_at <= input$rango_votasi_cuentas[2])
        
    })
    
    
    
    
    
    base_votasi_cuentas <- eventReactive(input$rango_votasi_cuentas,{
        
        
        cuentas_votasi<- tweets_votasi_cuentas() %>%
            filter(is_retweet==TRUE)%>%
            group_by(retweet_name)%>%
            summarise(conteo=n())%>%
            #top_n(70)%>%
            arrange(desc(conteo))
        
        
    })  
    
    
    output$cuentas_votasi <- renderDT({
        
        
        datatable(
            base_votasi_cuentas(),
            rownames = TRUE,
            extensions = 'Buttons',
            options = list(
                pageLength = 50,
                dom = 'Bfrtip',
                buttons = list(
                    list(extend = 'csv', title = "Cuentas - votasi"), 
                    list(extend = 'excel', title = "Cuentas - votasi"), 
                    list(extend = 'pdf', title = "Cuentas - votasi") 
                )
            )
        )
        
        
    })
    
    
    
    
    
    
    
    
    
    
    
    
    
    #LUC
    
    
    
    
    tweets_luc <- reactive({
        
        req(input$rango_luc)
        
        total_luc %>%
            filter(created_at >= input$rango_luc[1] &
                       created_at <= input$rango_luc[2])
        
    })
    
    
    
    
    
    output$tweets_total_luc <- renderValueBox({
        
        
        
        valueBox(value = tags$p(nrow(tweets_luc()), style = "font-size: 100%;text-align:center;"),
                 subtitle = tags$p("Tweets", style = "font-size: 100%;;text-align:center;"),
                 color = "purple",icon = tags$i(class = "fas fa-users", style="font-size: 30px"),width = 1.8)
    })
    
    output$tweets_ori_luc <- renderValueBox({
        
        ori = tweets_luc() %>%
            filter(is_retweet==FALSE) 
        
        valueBox(value = tags$p(nrow(ori), style = "font-size: 100%;text-align:center;"),
                 subtitle = tags$p("Tweets originales", style = "font-size: 100%;;text-align:center;"),
                 color = "purple",icon = tags$i(class = "fas fa-users", style="font-size: 30px"),width = 1.8)
    })
    
    
    
    output$retweets_total_luc <- renderValueBox({
        
        a = tweets_luc() %>%
            filter(is_retweet==TRUE) 
        
        valueBox(value = tags$p(nrow(a), style = "font-size: 100%;text-align:center;"),
                 subtitle = tags$p("Re-Tweets", style = "font-size: 100%;;text-align:center;"),
                 color = "purple",icon = tags$i(class = "fas fa-users", style="font-size: 30px"),width = 1.8)
    })
    
    
    # 
    output$plot_evolucion_luc <- plotly::renderPlotly({
        
        
        g1 <- tweets_luc() %>%
            group_by(fecha,is_retweet)%>%
            summarise(n=n())%>%
            mutate(is_retweet = ifelse(is_retweet == "TRUE","Re-tweets","Tweets"))%>%
            mutate(is_retweet = factor(is_retweet,levels=c("Tweets","Re-tweets")))%>%
            ggplot(aes(fecha, y = as.numeric(n),color=is_retweet,group = is_retweet,
                       text = paste("</br>Tipo:",is_retweet,"</br>Fecha:",as.Date(fecha,"%Y-%m-%d"),"</br>Conteo:",round(as.numeric(n),1))))+
            geom_line(size = 1) +
            geom_point(size = 1,color="#6C0BA9") +
            scale_color_manual(values=c("#6C0BA9","#D7A1F9"))+
            scale_x_date(date_breaks = "4 day",date_labels  = "%d-%m")+
            theme(axis.text = element_text(size = 6),legend.position = "bottom",
                  legend.title = element_blank())+
            theme_minimal() +
            labs(x = "",
                 y = "")
        
        
        plotly::ggplotly(g1, width = (0.60*as.numeric(input$dimension[1])), height = as.numeric(input$dimension[2]),
                         hoverinfo = 'text',tooltip = c("text"))%>%
            plotly::layout(legend = list(orientation = "h",
                                         xanchor = "center",
                                         x = 0.5,y=-0.2,title = list(text= ""))) %>%
            
            plotly::config(displayModeBar = TRUE,
                           modeBarButtonsToRemove = list(
                               "pan2d",
                               "autoScale2d",
                               "resetScale2d",
                               "hoverClosestCartesian",
                               "hoverCompareCartesian",
                               "sendDataToCloud",
                               "toggleHover",
                               "resetViews",
                               "toggleSpikelines",
                               "resetViewMapbox"
                           ),showLink = FALSE,
                           displaylogo = FALSE)
        
        
        
        
        
    })
    # 
    # 
    # 
    # 
    # Definición:
    output$def_luc <- renderUI({
        helpText(HTML(paste("<b>Definición:</b>",
                            "Se incluyen todos los tweets que mencionen LUC, y que en localización mencionen Montevideo y/o Uruguay.")))
    })
    
    
    tweets_luc_comunidades <- reactive({
        
        req(input$rango_luc_comunidades)
        
        total_luc %>%
            filter(created_at >= input$rango_luc_comunidades[1] &
                       created_at <= input$rango_luc_comunidades[2])
        
    })
    
    
    output$comunidades_luc <- renderVisNetwork({
        
        
        luc_retweets_network <- tweets_luc_comunidades() %>% 
            #filter(retweet_screen_name %in% luc$screen_name) %>%     # <- This is a new line and important.
            gt_edges(screen_name, retweet_screen_name, text) %>%             # It only keep retweets of other luc members
            gt_graph()
        
        
        luc_retweets_nodes <- igraph::as_data_frame(luc_retweets_network, what = "vertices")
        
        # This adds some additional info to the nodes, so we get the names on hover
        # and the size of the node is based on its degree, etc.
        luc_retweets_nodes <- luc_retweets_nodes %>% 
            mutate(id = name) %>% 
            mutate(label = name) %>% 
            mutate(title = name) %>% 
            mutate(degree = degree(luc_retweets_network)) %>% 
            mutate(value = degree)
        
        # This gets the edges, similar to how we got the nodes above
        luc_retweets_edges <- igraph::as_data_frame(luc_retweets_network, what = "edges")
        
        # This puts the text of the tweet itself into the edge
        # so when you hover over a line in the diagram it will show the tweet
        luc_retweets_edges <- luc_retweets_edges %>% 
            mutate(title = text)
        
        # # Creates the diagram
        # visNetwork(luc_retweets_nodes, luc_retweets_edges, main = "US luc 
        # retweet network") %>% 
        #   visIgraphLayout(layout = "layout_nicely") %>% 
        #   visEdges(arrows = "to")
        
        
        luc_retweets_nodes <- luc_retweets_nodes %>% 
            mutate(group = membership(infomap.community(luc_retweets_network)))
        
        
        visNetwork(luc_retweets_nodes, luc_retweets_edges, main = "Análisis de redes: luc") %>% 
            visIgraphLayout(layout = "layout_nicely") %>% 
            visEdges(arrows = "to") %>%   
            visOptions(highlightNearest = T, nodesIdSelection = T)
        
    })
    
    
    
    tweets_luc_texto <- reactive({
        
        req(input$rango_luc_texto)
        
        total_luc %>%
            filter(created_at >= input$rango_luc_texto[1] &
                       created_at <= input$rango_luc_texto[2])
        
    })
    
    
    
    
    
    base_luc_texto <- eventReactive(input$rango_luc_texto,{
        
        dfm <- quanteda::dfm(quanteda::tokens(tweets_luc_texto()$text),
                             tolower = TRUE,
                             verbose = FALSE)%>%
            quanteda::dfm_remove(c(stopwords("spanish"),"luc","#luc","#votasi","#votosí"),min_nchar=4)%>%
            quanteda::dfm_trim(min_docfreq = 4)
        
    })  
    
    output$nube_luc <- renderWordcloud2({
        
        base_luc_texto()%>%
            quanteda.textstats::textstat_frequency()%>%
            as.data.frame()%>%
            select(feature ,frequency)%>%
            rename(word=feature,freq=frequency)%>%
            wordcloud2(size=0.9,color=c("#6b3fa0","#7a52aa","#8965b3","#9779bd","#a68cc6","#b59fd0","#c4b2d9","#d3c5e3","#e1d9ec","#f0ecf6","#000000"),backgroundColor = "grey")
        
        
    })
    
    
    output$redes_luc <- renderPlot({
        
        base_fcm= base_luc_texto()%>%
            fcm(context = "document")
        
        feat <- names(topfeatures(base_fcm, 120))
        
        base_fcm_select <- fcm_select(base_fcm, pattern = feat, selection = "keep")
        size <- log(colSums(dfm_select(base_fcm, feat, selection = "keep")))
        
        set.seed(144)
        quanteda.textplots::textplot_network(base_fcm_select, min_freq = 0.8, vertex_size = size / max(size) * 3,
                                             edge_color="#a791bf")
        
    })
    
    
  
    
    
    tweets_luc_cuentas <- reactive({
        
        req(input$rango_luc_cuentas)
        
        total_luc %>%
            filter(created_at >= input$rango_luc_cuentas[1] &
                       created_at <= input$rango_luc_cuentas[2])
        
    })
    
    
    
    
    
    base_luc_cuentas <- eventReactive(input$rango_luc_cuentas,{
        
        
        cuentas_luc<- tweets_luc_cuentas() %>%
            filter(is_retweet==TRUE)%>%
            group_by(retweet_name)%>%
            summarise(conteo=n())%>%
            #top_n(70)%>%
            arrange(desc(conteo))
        
        
    })  
    
    
    output$cuentas_luc <- renderDT({
        
        
        datatable(
            base_luc_cuentas(),
            rownames = TRUE,
            extensions = 'Buttons',
            options = list(
                pageLength = 50,
                dom = 'Bfrtip',
                buttons = list(
                    list(extend = 'csv', title = "Cuentas - luc"), 
                    list(extend = 'excel', title = "Cuentas - luc"), 
                    list(extend = 'pdf', title = "Cuentas - luc") 
                )
            )
        )
        
        
    })
    
    
    
      
    
    
    prensa_luc <- reactive({
        
        req(input$rango_prensa)
        
        total_prensa %>%
            filter(datetimeArticle >= input$rango_prensa[1] &
                       datetimeArticle <= input$rango_prensa[2])
        
    })
    
    
    output$art_total <- renderValueBox({
        
        
        
        valueBox(value = tags$p(nrow(prensa_luc()), style = "font-size: 100%;text-align:center;"),
                 subtitle = tags$p("Artículos", style = "font-size: 100%;;text-align:center;"),
                 color = "purple",icon = tags$i(class = "fas fa-users", style="font-size: 30px"),width = 1.8)
    })

    output$def_prensa <- renderUI({
        helpText(HTML(paste("<b>Definición:</b>",
                            "Se incluyen los artículos que mencionen LUC y cuyo dominio/fuente sea uruguaya.")))
    })
    
    
    output$plot_evolucion_prensa <- plotly::renderPlotly({
        
        
        g1 <- prensa_luc() %>%
            group_by(fecha,termSearch)%>%
            summarise(n=n())%>%
            ggplot(aes(fecha, y = as.numeric(n),color=termSearch,group = termSearch,
                       text = paste("</br>Fecha:",as.Date(fecha,"%Y-%m-%d"),"</br>Conteo:",round(as.numeric(n),1))))+
            geom_line(size = 1,color="#6C0BA9") +
            geom_point(size = 1,color="#6C0BA9") +
            scale_color_manual(values=c("#6C0BA9","#D7A1F9"))+
            scale_x_date(date_breaks = "4 day",date_labels  = "%d-%m")+
            theme(axis.text = element_text(size = 6),legend.position = "none",
                  legend.title = element_blank())+
            theme_minimal() +
            labs(x = "",
                 y = "")
        
        
        plotly::ggplotly(g1, width = (0.60*as.numeric(input$dimension[1])), height = as.numeric(input$dimension[2]),
                         hoverinfo = 'text',tooltip = c("text"))%>%
            plotly::layout(legend = list(orientation = "h",
                                         xanchor = "center",
                                         x = 0.5,y=-0.2)) %>%
            
            plotly::config(displayModeBar = TRUE,
                           modeBarButtonsToRemove = list(
                               "pan2d",
                               "autoScale2d",
                               "resetScale2d",
                               "hoverClosestCartesian",
                               "hoverCompareCartesian",
                               "sendDataToCloud",
                               "toggleHover",
                               "resetViews",
                               "toggleSpikelines",
                               "resetViewMapbox"
                           ),showLink = FALSE,
                           displaylogo = FALSE)
        
        
        
        
        
    })
    
    
    prensa_luc_medios <- reactive({
        
        req(input$rango_prensa_medios)
        
        total_prensa %>%
            filter(datetimeArticle >= input$rango_prensa_medios[1] &
                       datetimeArticle <= input$rango_prensa_medios[2])
        
    })
    
    
    
    output$plot_prensa <- plotly::renderPlotly({
        
        
        g1 <- prensa_luc_medios() %>%
            mutate(medio=ifelse(domainArticle=="elpais.com.uy", "El País",
                                ifelse(domainArticle=="ladiaria.com.uy","La Diaria",
                                       ifelse(domainArticle=="subrayado.com.uy","Subrayado",
                                              ifelse(domainArticle=="lr21.com.uy","La República",
                                                     ifelse(domainArticle=="brecha.com.uy","Brecha",
                                                            ifelse(domainArticle %in% c("elpais.com.uy",
                                                                                        "ladiaria.com.uy",
                                                                                        "subrayado.com.uy",
                                                                                        "lr21.com.uy",
                                                                                        "brecha.com.uy")==FALSE,"Otros",domainArticle)))))))%>%
            mutate(medio=factor(medio,levels = c("El País","La Diaria","Subrayado","La República","Brecha","Otros")))%>%
            group_by(fecha,medio)%>%
            summarise(n=n())%>%
            ggplot(aes(fecha, y = as.numeric(n),color=medio,group = medio,
                       text = paste("</br>Medio:",medio,"</br>Fecha:",as.Date(fecha,"%Y-%m-%d"),"</br>Conteo:",round(as.numeric(n),1))))+
            geom_line(size = 1) +
            #geom_point(size = 1,color="#6C0BA9") +
            scale_color_manual(values=rev(RColorBrewer::brewer.pal(6,name="Purples")))+
            scale_x_date(date_breaks = "4 day",date_labels  = "%d-%m")+
            theme(axis.text = element_text(size = 6),legend.position = "none",
                  legend.title = element_blank())+
            theme_minimal() +
            labs(x = "",
                 y = "")
        
        
        plotly::ggplotly(g1, width = (0.60*as.numeric(input$dimension[1])), height = as.numeric(input$dimension[2]),
                         hoverinfo = 'text',tooltip = c("text"))%>%
            plotly::layout(legend = list(orientation = "h",
                                         xanchor = "center",
                                         x = 0.5,y=-0.2,title = list(text= ""))) %>%
            
            plotly::config(displayModeBar = TRUE,
                           modeBarButtonsToRemove = list(
                               "pan2d",
                               "autoScale2d",
                               "resetScale2d",
                               "hoverClosestCartesian",
                               "hoverCompareCartesian",
                               "sendDataToCloud",
                               "toggleHover",
                               "resetViews",
                               "toggleSpikelines",
                               "resetViewMapbox"
                           ),showLink = FALSE,
                           displaylogo = FALSE)
        
        
        
        
        
    })
    
    
##EL PAIS
    
    
    prensa_medios_nubes_elpais <- reactive({

        req(input$rango_prensa_medios_nubes_elpais)
        

        total_prensa %>%
            filter(fecha >= input$rango_prensa_medios_nubes_elpais[1] &
                       fecha <= input$rango_prensa_medios_nubes_elpais[2])



    })
    
    
    base_prensa_nube_elpais <- reactive({
        
        
        a <- prensa_medios_nubes_elpais() %>%
            mutate(medio=ifelse(domainArticle=="elpais.com.uy", "El País",
                                ifelse(domainArticle=="ladiaria.com.uy","La Diaria",
                                       ifelse(domainArticle=="subrayado.com.uy","Subrayado",
                                              ifelse(domainArticle=="lr21.com.uy","La República",
                                                     ifelse(domainArticle=="brecha.com.uy","Brecha",
                                                            ifelse(domainArticle %in% c("elpais.com.uy",
                                                                                        "ladiaria.com.uy",
                                                                                        "subrayado.com.uy",
                                                                                        "lr21.com.uy",
                                                                                        "brecha.com.uy")==FALSE,"Otros",domainArticle)))))))%>%
            filter(medio=="El País")
        dfm = quanteda::dfm(quanteda::tokens(a$titleArticle),
                            tolower = TRUE,
                            verbose = FALSE)%>%
            quanteda::dfm_remove(c(stopwords("spanish"),"LUC","país","2021"),min_nchar=3)%>%
            quanteda::dfm_trim(min_docfreq = 1)
        
    })  
    
    
    
    output$plot_prensa_elpais <- renderWordcloud2({
        
        base_prensa_nube_elpais()%>%
            quanteda.textstats::textstat_frequency()%>%
            as.data.frame()%>%
            select(feature ,frequency)%>%
            rename(word=feature,freq=frequency)%>%
            wordcloud2(size=0.9,color=c("#6b3fa0","#7a52aa","#8965b3","#9779bd","#a68cc6","#b59fd0","#c4b2d9","#d3c5e3","#e1d9ec","#f0ecf6","#000000"),backgroundColor = "grey")
        
        
    })   
    
    
   
    ##LA DIARIA
    
    
    prensa_medios_nubes_ladiaria <- reactive({
        
        
        total_prensa %>%
            filter(fecha >= input$rango_prensa_medios_nubes_ladiaria[1] &
                       fecha <= input$rango_prensa_medios_nubes_ladiaria[2])
        
        
        
    })
    
    
    base_prensa_nube_ladiaria <- reactive({
        
        
        a <- prensa_medios_nubes_ladiaria() %>%
            mutate(medio=ifelse(domainArticle=="elpais.com.uy", "El País",
                                ifelse(domainArticle=="ladiaria.com.uy","La Diaria",
                                       ifelse(domainArticle=="subrayado.com.uy","Subrayado",
                                              ifelse(domainArticle=="lr21.com.uy","La República",
                                                     ifelse(domainArticle=="brecha.com.uy","Brecha",
                                                            ifelse(domainArticle %in% c("elpais.com.uy",
                                                                                        "ladiaria.com.uy",
                                                                                        "subrayado.com.uy",
                                                                                        "lr21.com.uy",
                                                                                        "brecha.com.uy")==FALSE,"Otros",domainArticle)))))))%>%
            filter(medio=="La Diaria")
        dfm = quanteda::dfm(quanteda::tokens(a$titleArticle),
                            tolower = TRUE,
                            verbose = FALSE)%>%
            quanteda::dfm_remove(c(stopwords("spanish"),"LUC","diaria","2021"),min_nchar=3)%>%
            quanteda::dfm_trim(min_docfreq = 1)
        
    })  
    
    
    
    output$plot_prensa_ladiaria <- renderWordcloud2({
        
        base_prensa_nube_ladiaria()%>%
            quanteda.textstats::textstat_frequency()%>%
            as.data.frame()%>%
            select(feature ,frequency)%>%
            rename(word=feature,freq=frequency)%>%
            wordcloud2(size=0.9,color=c("#6b3fa0","#7a52aa","#8965b3","#9779bd","#a68cc6","#b59fd0","#c4b2d9","#d3c5e3","#e1d9ec","#f0ecf6","#000000"),backgroundColor = "grey")
        
        
    })   
    
    
    ##Subrayado
    
    
    prensa_medios_nubes_subrayado <- reactive({
        
        
        total_prensa %>%
            filter(fecha >= input$rango_prensa_medios_nubes_subrayado[1] &
                       fecha <= input$rango_prensa_medios_nubes_subrayado[2])
        
        
        
    })
    
    
    base_prensa_nube_subrayado <- reactive({
        
        
        a <- prensa_medios_nubes_subrayado() %>%
            mutate(medio=ifelse(domainArticle=="elpais.com.uy", "El País",
                                ifelse(domainArticle=="ladiaria.com.uy","La Diaria",
                                       ifelse(domainArticle=="subrayado.com.uy","Subrayado",
                                              ifelse(domainArticle=="lr21.com.uy","La República",
                                                     ifelse(domainArticle=="brecha.com.uy","Brecha",
                                                            ifelse(domainArticle %in% c("elpais.com.uy",
                                                                                        "ladiaria.com.uy",
                                                                                        "subrayado.com.uy",
                                                                                        "lr21.com.uy",
                                                                                        "brecha.com.uy")==FALSE,"Otros",domainArticle)))))))%>%
            filter(medio=="Subrayado")
        dfm = quanteda::dfm(quanteda::tokens(a$titleArticle),
                            tolower = TRUE,
                            verbose = FALSE)%>%
            quanteda::dfm_remove(c(stopwords("spanish"),"LUC","2021"),min_nchar=3)%>%
            quanteda::dfm_trim(min_docfreq = 1)
        
    })  
    
    
    
    output$plot_prensa_subrayado <- renderWordcloud2({
        
        base_prensa_nube_subrayado()%>%
            quanteda.textstats::textstat_frequency()%>%
            as.data.frame()%>%
            select(feature ,frequency)%>%
            rename(word=feature,freq=frequency)%>%
            wordcloud2(size=0.9,color=c("#6b3fa0","#7a52aa","#8965b3","#9779bd","#a68cc6","#b59fd0","#c4b2d9","#d3c5e3","#e1d9ec","#f0ecf6","#000000"),backgroundColor = "grey")
        
        
    })   
    
    ##larepublica
    
    
    prensa_medios_nubes_larepublica <- reactive({
        
        
        total_prensa %>%
            filter(fecha >= input$rango_prensa_medios_nubes_larepublica[1] &
                       fecha <= input$rango_prensa_medios_nubes_larepublica[2])
        
        
        
    })
    
    
    base_prensa_nube_larepublica <- reactive({
        
        
        a <- prensa_medios_nubes_larepublica() %>%
            mutate(medio=ifelse(domainArticle=="elpais.com.uy", "El País",
                                ifelse(domainArticle=="ladiaria.com.uy","La Diaria",
                                       ifelse(domainArticle=="subrayado.com.uy","Subrayado",
                                              ifelse(domainArticle=="lr21.com.uy","La República",
                                                     ifelse(domainArticle=="brecha.com.uy","Brecha",
                                                            ifelse(domainArticle %in% c("elpais.com.uy",
                                                                                        "ladiaria.com.uy",
                                                                                        "subrayado.com.uy",
                                                                                        "lr21.com.uy",
                                                                                        "brecha.com.uy")==FALSE,"Otros",domainArticle)))))))%>%
            filter(medio=="La República")
        dfm = quanteda::dfm(quanteda::tokens(a$titleArticle),
                            tolower = TRUE,
                            verbose = FALSE)%>%
            quanteda::dfm_remove(c(stopwords("spanish"),"LUC","Brecha","2021"),min_nchar=3)%>%
            quanteda::dfm_trim(min_docfreq = 1)
        
    })  
    
    
    
    output$plot_prensa_larepublica <- renderWordcloud2({
        
        base_prensa_nube_larepublica()%>%
            quanteda.textstats::textstat_frequency()%>%
            as.data.frame()%>%
            select(feature ,frequency)%>%
            rename(word=feature,freq=frequency)%>%
            wordcloud2(size=0.9,color=c("#6b3fa0","#7a52aa","#8965b3","#9779bd","#a68cc6","#b59fd0","#c4b2d9","#d3c5e3","#e1d9ec","#f0ecf6","#000000"),backgroundColor = "grey")
        
        
    })   
    
    
    ##Brecha
    
    
    prensa_medios_nubes_brecha <- reactive({
        
        
        total_prensa %>%
            filter(fecha >= input$rango_prensa_medios_nubes_brecha[1] &
                       fecha <= input$rango_prensa_medios_nubes_brecha[2])
        
        
        
    })
    
    
    base_prensa_nube_brecha <- reactive({
        
        
        a <- prensa_medios_nubes_brecha() %>%
            mutate(medio=ifelse(domainArticle=="elpais.com.uy", "El País",
                                ifelse(domainArticle=="ladiaria.com.uy","La Diaria",
                                       ifelse(domainArticle=="subrayado.com.uy","Subrayado",
                                              ifelse(domainArticle=="lr21.com.uy","La República",
                                                     ifelse(domainArticle=="brecha.com.uy","Brecha",
                                                            ifelse(domainArticle %in% c("elpais.com.uy",
                                                                                        "ladiaria.com.uy",
                                                                                        "subrayado.com.uy",
                                                                                        "lr21.com.uy",
                                                                                        "brecha.com.uy")==FALSE,"Otros",domainArticle)))))))%>%
            filter(medio=="Brecha")
        dfm = quanteda::dfm(quanteda::tokens(a$titleArticle),
                            tolower = TRUE,
                            verbose = FALSE)%>%
            quanteda::dfm_remove(c(stopwords("spanish"),"LUC","Brecha","2021"),min_nchar=3)%>%
            quanteda::dfm_trim(min_docfreq = 1)
        
    })  
    
    
    
    output$plot_prensa_brecha <- renderWordcloud2({
        
        base_prensa_nube_brecha()%>%
            quanteda.textstats::textstat_frequency()%>%
            as.data.frame()%>%
            select(feature ,frequency)%>%
            rename(word=feature,freq=frequency)%>%
            wordcloud2(size=0.9,color=c("#6b3fa0","#7a52aa","#8965b3","#9779bd","#a68cc6","#b59fd0","#c4b2d9","#d3c5e3","#e1d9ec","#f0ecf6","#000000"),backgroundColor = "grey")
        
        
    })   
    
    
    ##Otros
    
    
    prensa_medios_nubes_otros <- reactive({
        
        
        total_prensa %>%
            filter(fecha >= input$rango_prensa_medios_nubes_otros[1] &
                       fecha <= input$rango_prensa_medios_nubes_otros[2])
        
        
        
    })
    
    
    base_prensa_nube_otros <- reactive({
        
        
        a <- prensa_medios_nubes_otros() %>%
            mutate(medio=ifelse(domainArticle=="elpais.com.uy", "El País",
                                ifelse(domainArticle=="ladiaria.com.uy","La Diaria",
                                       ifelse(domainArticle=="subrayado.com.uy","Subrayado",
                                              ifelse(domainArticle=="lr21.com.uy","La República",
                                                     ifelse(domainArticle=="brecha.com.uy","Brecha",
                                                            ifelse(domainArticle %in% c("elpais.com.uy",
                                                                                        "ladiaria.com.uy",
                                                                                        "subrayado.com.uy",
                                                                                        "lr21.com.uy",
                                                                                        "brecha.com.uy")==FALSE,"Otros",domainArticle)))))))%>%
            filter(medio=="Otros")
        dfm = quanteda::dfm(quanteda::tokens(a$titleArticle),
                            tolower = TRUE,
                            verbose = FALSE)%>%
            quanteda::dfm_remove(c(stopwords("spanish"),"LUC"),min_nchar=3)%>%
            quanteda::dfm_trim(min_docfreq = 1)
        
    })  
    
    
    
    output$plot_prensa_otros <- renderWordcloud2({
        
        base_prensa_nube_otros()%>%
            quanteda.textstats::textstat_frequency()%>%
            as.data.frame()%>%
            select(feature ,frequency)%>%
            rename(word=feature,freq=frequency)%>%
            wordcloud2(size=0.9,color=c("#6b3fa0","#7a52aa","#8965b3","#9779bd","#a68cc6","#b59fd0","#c4b2d9","#d3c5e3","#e1d9ec","#f0ecf6","#000000"),backgroundColor = "grey")
        
        
    })   
    
    
    
    
    
    
}




shinyApp(ui, server)
