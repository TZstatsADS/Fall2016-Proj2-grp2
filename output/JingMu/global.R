library(shiny)
library(ggmap)
library(maps)
library(sp)
library(plyr)
library(dplyr)
library(leaflet)

#setwd('C:/Users/Jing Mu/OneDrive/Fall 2016/5243 Applied Data Science/project2/Project2')
setwd('E:/onedrive/fall 2016/5243 Applied Data Science/project2/project2')
load('rest.RData')

#rest$year <- format(as.Date(rest$GRADE.DATE, format='%d/%m/%Y'),'%Y')
rest$GRADE.DATE<-as.Date(rest$GRADE.DATE,format='%m/%d/%Y')
#rest$ADDRESSS <- paste(as.character(rest$BUILDING),as.character(rest$STREET),as.character(rest$ZIPCODE),
#                       sep=" ")
#r <- distinct(rest, CUISINE.DESCRIPTION,DBA, GRADE, GRADE.DATE)
r <- subset(distinct(rest, CUISINE.DESCRIPTION,DBA, GRADE, GRADE.DATE),
            select =c(CUISINE.DESCRIPTION, DBA, GRADE, GRADE.DATE))
#r$GRADE[r$GRADE=='']=NA
#r_last <- r[!is.na(r$GRADE),] %>%
r_last <- r%>%
    group_by(DBA) %>%
    slice(which.max(GRADE.DATE))
colnames(r_last)[colnames(r_last)=='DBA'] <- 'name'

load('sub.RData')
bind <- merge(r_last, sub, by = 'name')
#bind$GRADE = droplevels(bind$GRADE)
#levels(bind$GRADE) = delevels('',bind$GRADE)
#bind$GRADE[bind$GRADE=='']=NA
#bind <- bind[na.omit(bind$GRADE),]
