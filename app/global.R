library(shiny)
require(ggmap)
require(maps)
require(sp)
require(plyr)
require(dplyr)
setwd("~/GitHub/Fall2016-Proj2-grp2/data")
load(file = "df.RData")  
load(file = "rest.Rdata")
#rest <-na.omit(rest)

rest$year <- format(as.Date(rest$INSPECTION.DATE, format="%d/%m/%Y"),"%Y")


rest$ADDRESSS <- paste(as.character(rest$BUILDING), as.character(rest$STREET), as.character(rest$ZIPCODE), sep = " ")
r <- rest %>% group_by(DBA, ADDRESSS, year) %>% summarise(score = mean(SCORE), cuisine = first(CUISINE.DESCRIPTION))

#restaurant <- rest %>% group_by(ADDRESSS, DBA) %>% summarise(name = DBA)
r$name <- r$DBA

bb <- right_join(r, df, by = "name")
b <- subset(bb, !is.na(bind$score))
b <- subset(b, b$score >= 0)
b <- subset(b, b$score <= 100)
b <- subset(b, !is.na(b$year))

b$score <- round(b$score, digits = 0)
b$score_pt <- (b$score/max(b$score))


col_fun_score <- colorRamp(c("yellow", "red"))
rgb_cols_score <- col_fun(b$score_pt)
cols_score <- rgb(rgb_cols, maxColorValue = 255)

######################Jing Mu
rest$GRADE.DATE<-as.Date(rest$GRADE.DATE,format='%m/%d/%Y')
r_jm <- subset(distinct(rest, CUISINE.DESCRIPTION,DBA, GRADE, GRADE.DATE),
            select =c(CUISINE.DESCRIPTION, DBA, GRADE, GRADE.DATE))
r_jm <- r_jm%>%
    group_by(DBA) %>%
    slice(which.max(GRADE.DATE))
colnames(r_jm)[colnames(r_last)=='DBA'] <- 'name'
bind_jm <- merge(r_jm, df, by = 'name')
