library(shiny)
require(ggmap)
require(maps)
require(sp)
require(plyr)
require(dplyr)
setwd("~/GitHub/Fall2016-Proj2-grp2/data")
load(file = "rest.RData")  
#rest <-na.omit(rest)

r <- rest %>% group_by(DBA, GRADE.DATE) %>% summarise(score = mean(SCORE), cuisine = first(CUISINE.DESCRIPTION))

rest$ADDRESSS <- paste(as.character(rest$BUILDING), as.character(rest$STREET), as.character(rest$ZIPCODE), sep = " ")
restaurant <- rest %>% group_by(ADDRESSS) %>% summarise(DBA = first(DBA))

#r_s <- rest %>% group_by(ADDRESSS, GRADE.DATE) %>% summarise(n = SCORE)

sub1 <- read.csv("sub1.csv")
sub3 <- read.csv("sub3.csv")
require(leaflet)

r$name <- r$DBA

bind <- right_join(r, sub3, by = "name")
bind <- filter(bind, name != " ")
