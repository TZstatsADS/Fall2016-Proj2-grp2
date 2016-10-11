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
hm = c("VIOLATION.CODE", "month","SCORE")
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
sub_df <- cast(hm_df, VIOLATION.CODE~month, sum)
#submatr <- sub_df[,2:13]
#submatr <- replace(submatr, is.na(submatr),0)
sub_man <- cast(hm_man, VIOLATION.CODE~month, sum)
sub_brok <- cast(hm_brok, VIOLATION.CODE~month, sum)
sub_bronx <- cast(hm_bronx, VIOLATION.CODE~month, sum)
sub_staten <- cast(hm_staten, VIOLATION.CODE~month, sum)
sub_queens <- cast(hm_queens, VIOLATION.CODE~month, sum)


#overall
rownames(sub_df) <- sub_df[,4]                  
# assign row names
sub_df_1 = as.matrix(sub_df)
#heamp_1 = heatmap(sub_df_1,Rowv =NA, Colv=NA, col=cm.colors(256),scale = "column",margins=c(5,10))

#manhattan
rownames(sub_man) <- sub_man[,4]                  
# assign row names
sub_man_1 = as.matrix(sub_man)
#heamp_man = heatmap(sub_man_1,Rowv =NA, Colv=NA, col=cm.colors(256),scale = "column",margins=c(5,10))

#brooklyn
rownames(sub_brok) <- sub_brok[,4]                  
# assign row names
sub_brok_1 = as.matrix(sub_brok)
#heamp_brok = heatmap(sub_brok_1,Rowv =NA, Colv=NA, col=cm.colors(256),scale = "column",margins=c(5,10))

#bronx
rownames(sub_bronx) <- sub_bronx[,4]                  
# assign row names
sub_bronx_1 = as.matrix(sub_bronx)
#heamp_brok = heatmap(sub_bronx_1,Rowv =NA, Colv=NA, col=cm.colors(256),scale = "column",margins=c(5,10))

#staten island
rownames(sub_staten) <- sub_staten[,4]                  
# assign row names
sub_staten_1 = as.matrix(sub_staten)
#heamp_staten = heatmap(sub_staten_1,Rowv =NA, Colv=NA, col=cm.colors(256),scale = "column",margins=c(5,10))

#queens
rownames(sub_queens) <- sub_queens[,4]                  
# assign row names
sub_queens_1 = as.matrix(sub_queens)
#heamp_queens = heatmap(sub_queens_1,Rowv =NA, Colv=NA, col=cm.colors(256),scale = "column",margins=c(5,10))



#ggplot(df[which(df$BORO=="MANHATTAN"),],aes(x = factor(new.date), y = SCORE))+stat_summary(fun.y = "mean",geom = "bar")
#ggplotly(ggplot(df[which(df$BORO=="MANHATTAN"),],aes(x = factor(new.date), y = SCORE))+stat_summary(fun.y = "mean",geom = "bar"))
