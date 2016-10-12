library("reshape")
library("plotly")
library("shiny")
library("sp")
library("dplyr")
library("ggplot2")
load(file="df_final.rdata")
df<-subset(df1,select=c(BORO,year,month,VIOLATION.CODE,SCORE))
df<-na.omit(df)
#str(df)
#df$INSPECTION.DATE<-as.Date(df$INSPECTION.DATE,format = "%m/%d/%Y")
#df$new.year=strftime(df$INSPECTION.DATE, "%Y")
#df$new.month = strftime(df$INSPECTION.DATE, "%m")
#df$new.year.month = paste(df$new.year,df$new.month)
df$month = as.numeric(df$month)
df$year = as.numeric(df$year)
df$year<-df$year+2000
df$BORO<-as.character(df$BORO)

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

