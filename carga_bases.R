
##VOTOSI

my_list <- list.files("Bases_diarias/votosi", full.names=TRUE)
my_files <- lapply(my_list, load, envir=.GlobalEnv)
total_uni <- do.call(rbind, mget(sub('\\.RData', '', basename(unlist(my_files)))))

total_uni <- subset(total_uni,duplicated(total_uni$status_id)==FALSE)
total_uni$fecha=as.Date(substr(total_uni$created_at,1,10))
rm(list=setdiff(ls(), "total_uni"))


##VotaNOderogar

my_list <- list.files("Bases_diarias/votanoderogar", full.names=TRUE)
my_files <- lapply(my_list, load, envir=.GlobalEnv)
total_votano <- do.call(rbind, mget(sub('\\.RData', '', basename(unlist(my_files)))))
total_votano <- subset(total_votano,duplicated(total_votano$status_id)==FALSE)
total_votano$fecha=as.Date(substr(total_votano$created_at,1,10))
rm(list=setdiff(ls(), c("total_uni","total_votano")))


##VOTASI

my_list <- list.files("Bases_diarias/votasi", full.names=TRUE)
my_files <- lapply(my_list, load, envir=.GlobalEnv)
total_votasi <- do.call(rbind, mget(sub('\\.RData', '', basename(unlist(my_files)))))
total_votasi <- subset(total_votasi,duplicated(total_votasi$status_id)==FALSE)
total_votasi$fecha=as.Date(substr(total_votasi$created_at,1,10))
rm(list=setdiff(ls(), c("total_uni","total_votano","total_votasi")))

##LUC

my_list <- list.files("Bases_diarias/luc", full.names=TRUE)
my_files <- lapply(my_list, load, envir=.GlobalEnv)
total_luc <- do.call(rbind, mget(sub('\\.RData', '', basename(unlist(my_files)))))
total_luc <- subset(total_luc,duplicated(total_luc$status_id)==FALSE)
total_luc$fecha=as.Date(substr(total_luc$created_at,1,10))
rm(list=setdiff(ls(), c("total_uni","total_votano","total_votasi","total_luc")))


##PRENSA LUC

my_list <- list.files("Bases_diarias/prensa", full.names=TRUE)
my_files <- lapply(my_list, load, envir=.GlobalEnv)
total_prensa <- do.call(rbind, mget(sub('\\.RData', '', basename(unlist(my_files)))))
total_prensa <- subset(total_prensa,duplicated(total_prensa$titleArticle)==FALSE)
total_prensa$fecha=as.Date(substr(total_prensa$datetimeArticle,1,10))
rm(list=setdiff(ls(), c("total_uni","total_votano","total_votasi","total_luc","total_prensa")))




