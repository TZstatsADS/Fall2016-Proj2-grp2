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
b <- subset(bb, !is.na(bb$score))
b <- subset(b, b$score >= 0)
b <- subset(b, b$score <= 100)
b <- subset(b, !is.na(b$year))

b$score <- round(b$score, digits = 0)
b$score_pt <- (b$score/max(b$score))


col_fun_score <- colorRamp(c("yellow", "red"))
rgb_cols_score <- col_fun_score(b$score_pt)
cols_score <- rgb(rgb_cols_score, maxColorValue = 255)



cuisine <- c("American", "Asian", "Bakery", "Fast_Food", "Middle_Eastern")
regexes <- list(c("(American|Barbecue|Tex-Mex|Californian)","American"),
                c("(Asian|Chinese|Vietnames
                  Cambodian|Vietnamese|Thai|Indonesian|Indian|Filipino)","Asian"),
                c("(Donald|Trump|DonaldTrump)","Bakery"),
                c("(Hamburgers|Hotdogs|Sandwich|Pizza|Soup|Salad)","Fast_Food"),
                c("(Iranian|Armenian|Afghan|HRC|Pakistani)","Middle_Eastern"),
                c("(Czech|European|English|French|German|Greek|Irish|Mediterranean|Moroccan|Italian|Tapas|Scandanavian|Kosher)","European"),
                c("(Vegetarian)","Vegetarian"))
#Create a vector, the same length as the df
output_v <- character(nrow(b))
#For each regex..
for(i in seq_along(regexes)){
  
  #Grep through d$name, and when you find maBShes, insert the relevant 'tag' into
  #The output vector
  output_v[grepl(x = b$cuisine,ignore.case = TRUE, pattern = regexes[[i]][1])] <- regexes[[i]][2]
}

output_v
#Insert that now-filled output vector into the dataframe
b$cuisine <- output_v


######################Jing Mu
rest$GRADE.DATE<-as.Date(rest$GRADE.DATE,format='%m/%d/%Y')
r_jm <- subset(distinct(rest, CUISINE.DESCRIPTION,DBA, GRADE, GRADE.DATE),
            select =c(CUISINE.DESCRIPTION, DBA, GRADE, GRADE.DATE))
r_jm <- r_jm%>%
    group_by(DBA) %>%
    slice(which.max(GRADE.DATE))
r_jm$name <- r_jm$DBA
bind_jm <- merge(r_jm, df, by = 'name')
