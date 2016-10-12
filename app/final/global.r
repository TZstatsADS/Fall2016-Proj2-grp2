library(ggmap)
library(maps)
library(sp)
library(plyr)
library(dplyr)
library(leaflet)
library(ggplot2)

setwd('E:/onedrive/fall 2016/5243 Applied Data Science/project2/Final')
#setwd('C:/Users/Jing Mu/onedrive/fall 2016/5243 Applied Data Science/project2/Final')
load(file = 'finaldata.RData')
############################
#rest$year <- format(as.Date(rest$INSPECTION.DATE, format="%d/%m/%Y"),"%Y")

#rest$ADDRESSS <- paste(as.character(rest$BUILDING), as.character(rest$STREET), as.character(rest$ZIPCODE), sep = " ")
r <-  finaldata%>% group_by(DBA, INSPECTION.YEAR, lat, long) %>% 
  summarise(score = mean(SCORE), cuisine = first(CUISINE.DESCRIPTION))

#restaurant <- rest %>% group_by(ADDRESSS, DBA) %>% summarise(name = DBA)
r$name <- r$DBA

#bb <- right_join(r, df, by = "name")
b <- subset(r, !is.na(r$score))
b <- subset(b, b$score >= 0)
b <- subset(b, b$score <= 100)
b <- subset(b, !is.null(b$INSPECTION.YEAR))
b <- subset(b, !is.na(b$lat))

b$score <- round(b$score, digits = 0)
b$score_pt <- (b$score/max(b$score))



col_fun_score <- colorRamp(c("yellow", "red"))
rgb_cols_score <- col_fun_score(b$score_pt)
cols_score <- rgb(rgb_cols_score, maxColorValue = 255)
###############################################
bind_jm <- subset(distinct(finaldata, DBA, GRADE, GRADE.DATE,lat,long),
                  select =c(DBA, GRADE, GRADE.DATE, lat, long))

bind_jm <- bind_jm%>%
  group_by(DBA) %>%
  slice(which.max(GRADE.DATE))
bind_jm$GRADE <- droplevels(bind_jm$GRADE)
bind_jm <- bind_jm[!is.na(bind_jm$lat),]
########
df<-subset(finaldata,select=c(BORO,INSPECTION.YEAR,INSPECTION.MONTH,
                              VIOLATION.CODE,SCORE))
df<-na.omit(df)
#str(df)
#df$INSPECTION.DATE<-as.Date(df$INSPECTION.DATE,format = "%m/%d/%Y")
#df$new.year=strftime(df$INSPECTION.DATE, "%Y")
#df$new.month = strftime(df$INSPECTION.DATE, "%m")
#df$new.year.month = paste(df$new.year,df$new.month)
df$SCORE <- as.numeric(df$SCORE)
df$month <- as.numeric(df$INSPECTION.MONTH)
df$year <- as.numeric(df$INSPECTION.YEAR)
df$year<-df$year
df$BORO<-as.character(df$BORO)
df$VIOLATION.CODE <- apply(matrix(as.character(df$VIOLATION.CODE)),1,
                           function(x) substring(x,1,2))
df$VIOLATION.CODE <- as.numeric(df$VIOLATION.CODE)

df$VIOLATION.DESCRIPTION <- NA
df$VIOLATION.DESCRIPTION[which(df$VIOLATION.CODE=="2")]<- "02-Food Temperature"
df$VIOLATION.DESCRIPTION[which(df$VIOLATION.CODE=="3")]<- "03-Food Source"
df$VIOLATION.DESCRIPTION[which(df$VIOLATION.CODE=="4")]<- "04-Food Protection"
df$VIOLATION.DESCRIPTION[which(df$VIOLATION.CODE=="5")]<- "05-Working Environment Safety"
df$VIOLATION.DESCRIPTION[which(df$VIOLATION.CODE=="6")]<- "06-Workers Cleanliness"
df$VIOLATION.DESCRIPTION[which(df$VIOLATION.CODE=="7")]<- "07-Duties of Officer"
df$VIOLATION.DESCRIPTION[which(df$VIOLATION.CODE=="8")]<- "08-Facility Issues"
df$VIOLATION.DESCRIPTION[which(df$VIOLATION.CODE=="9")]<- "09-Food Storage"
df$VIOLATION.DESCRIPTION[which(df$VIOLATION.CODE=="10")]<- "10-Utility Issues"
df$VIOLATION.DESCRIPTION[which(df$VIOLATION.CODE=="15")]<- "15-Tabacco Issues"
df$VIOLATION.DESCRIPTION[which(df$VIOLATION.CODE=="16")]<- "16-Food Nuitrition/Calories"
df$VIOLATION.DESCRIPTION[which(df$VIOLATION.CODE=="18")]<- "18-Documents Not Present"
df$VIOLATION.DESCRIPTION[which(df$VIOLATION.CODE=="20")]<- "20-Information Not Posted"
df$VIOLATION.DESCRIPTION[which(df$VIOLATION.CODE=="22")]<- "22-Facility Issues 2"
df$VIOLATION.DESCRIPTION[which(df$VIOLATION.CODE=="99")]<- "99-Other General Violation"

df_man<-df[which(df$BORO=="MANHATTAN"),]
df_brok<-df[which(df$BORO=="BROOKLYN"),]
df_bronx<-df[which(df$BORO=="BRONX"),]
df_queens<-df[which(df$BORO=="QUEENS"),]
df_staten<-df[which(df$BORO=="STATEN ISLAND"),]
#data sets for bar chart
new_york<-df
man<-df_man
brok<-df_brok
bronx<-df_bronx
queens<-df_queens
staten<-df_staten

#data sets for heatmap
hm = c("VIOLATION.CODE", "VIOLATION.DESCRIPTION","month","SCORE")
hm_man <- df_man[hm]
hm_brok <- df_brok[hm]
hm_bronx <- df_bronx[hm]
hm_queens <- df_queens[hm]
hm_staten <- df_staten[hm]
hm_df <- df[hm]
hm_df$SCORE = 1
hm_man$SCORE = 1
hm_brok$SCORE = 1
hm_bronx$SCORE = 1
hm_staten$SCORE = 1
hm_queens$SCORE = 1