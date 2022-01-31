library(rtweet)
library(tidyverse)
library(tidytext)
library(lubridate)
library(igraph)
library("stringr")
library("stringi")
library("tm")

# Comunidades

author<-paste("@",total_uni$screen_name, sep="")
retweets<-total_uni$retweet_count
handles<-str_extract_all(total_uni$text,'@[A-Za-z]+[A-Za-z0-9_]+')
author.retweeted<- sapply(handles,function(x) x[1]) #Collect the first author's screenname
date<-total_uni$created_at
text<-total_uni$text


##Let's now create the network
data <- cbind(author,author.retweeted) #Collect dyads with Hub (screen-retw) and authority (handle-original)
net <- graph.empty() #open an empty network graph
net <- add.vertices(net, length(unique(c(data))),name=as.character(unique(c(data)))) #Load vertices
net <- add.edges(net, t(data)) #Add edges
E(net)$text <- text #add as an edge variable the texts of the tweets 
summary(net) 


##Create a layout for the network
l <- layout_with_fr(net, grid = c("nogrid"))
##Estimate community membership
my.com.fast <- walktrap.community(net)

#Plot your layout
plot(l, col=my.com.fast$membership, pch=16, cex=.5)

table(my.com.fast$membership)
V(net)$new.membership<-my.com.fast$membership


# Make a table of the number of tweets Most active Authorities in top Opposition subgroups1
d <- degree(graph=net, mode="in")
d <- as.data.frame(sort(d,decreasing = FALSE))
#d <- d[order(d$Freq, decreasing=T), ]
colnames(d) <- c("Tweets")
tail(d)

d <- degree(induced.subgraph(graph=net, vids=which(V(net)$new.membership==3)), mode="in")
d <- as.data.frame(sort(d,decreasing = FALSE))
#d <- d[order(d$Freq, decreasing=T), ]
colnames(d) <- c("Tweets")
head(d)



ind<-degree(net, mode="in") #arrows in
outd<-degree(net, mode="out") #arrows out
my.label<- names(ind) #names to the object

comm <- my.com.fast$membership #My community id's


plot.igraph(net, layout=l,vertex.label=my.label, vertex.size=(log(ind+1)), vertex.label.color="grey10", vertex.color=my.com.fast$membership, 
            edge.width= .01, edge.arrow.size=.2,  edge.curved=TRUE, vertex.label.cex=.3, mark.groups=list(which(comm==1), which(comm==4),which(comm==5),which(comm==6),which(comm==11), which(comm==30)), mark.col=terrain.colors(6, alpha = 0.2))




## With labels

pdf(file = "luc-labels.pdf", 40, 40, pointsize=12, compress=FALSE)
plot.igraph(net, layout=l,vertex.label=my.label, vertex.size=(log(ind+1)), vertex.label.color="grey10", vertex.color=my.com.fast$membership, edge.width= .01, edge.arrow.size=.2,  edge.curved=TRUE, vertex.label.cex=.3)
dev.off()

png(file = "luc_low.png", 40, 40, units="cm",res=300)
plot.igraph(net, layout=l,vertex.label=my.label, vertex.size=(log(ind+1)), vertex.label.color="grey10", vertex.color=my.com.fast$membership, 
            edge.width= .01, edge.arrow.size=.2,  edge.curved=TRUE, vertex.label.cex=.3, mark.groups=list(which(comm==1), which(comm==4),which(comm==5),which(comm==6),which(comm==11), which(comm==30)), mark.col=terrain.colors(6, alpha = 0.2))
dev.off()

png(file = "luc.png", 40, 40, units="cm",res=500)
plot.igraph(net, layout=l,vertex.label=my.label, vertex.size=(log(ind+1)), vertex.label.color="grey10", vertex.color=my.com.fast$membership, 
            edge.width= .01, edge.arrow.size=.2,  edge.curved=TRUE, vertex.label.cex=.3, mark.groups=list(which(comm==1), which(comm==4),which(comm==5),which(comm==6),which(comm==11), which(comm==30)), mark.col=terrain.colors(6, alpha = 0.2))
dev.off()
