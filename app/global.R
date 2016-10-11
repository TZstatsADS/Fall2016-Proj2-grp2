library(shiny)
require(ggmap)
require(maps)
require(sp)
require(plyr)
require(dplyr)
setwd("~/GitHub/Fall2016-Proj2-grp2/data")
load(file = "rest.RData")  
#rest <-na.omit(rest)

rest$year <- format(as.Date(rest$INSPECTION.DATE, format="%d/%m/%Y"),"%Y")
r <- rest %>% group_by(DBA, year) %>% summarise(score = mean(SCORE), cuisine = first(CUISINE.DESCRIPTION))

rest$ADDRESSS <- paste(as.character(rest$BUILDING), as.character(rest$STREET), as.character(rest$ZIPCODE), sep = " ")
restaurant <- rest %>% group_by(ADDRESSS) %>% summarise(DBA = first(DBA))

#r_s <- rest %>% group_by(ADDRESSS, GRADE.DATE) %>% summarise(n = SCORE)

load(file = "sub5.Rdata")
load(file = "sub1.RData")
subs <- rbind(sub1,sub5)
require(leaflet)

r$name <- r$DBA

bind <- right_join(r, subs, by = "name")



b <- subset(bind, !is.na(bind$score))
b <- subset(b, b$score >= 0)
b <- subset(b, b$score <= 100)
b <- subset(b, !is.na(b$year))

b$score <- round(b$score, digits = 0)
b$score_pt <- (b$score/max(b$score))


col_fun <- colorRamp(c("yellow", "red"))
rgb_cols <- col_fun(b$score_pt)
cols <- rgb(rgb_cols, maxColorValue = 255)

