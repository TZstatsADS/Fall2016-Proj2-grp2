temp <- subset(finaldata, select = c('CUISINE.DESCRIPTION','VIOLATION.CODE'))
temp <- na.omit(temp)
temp <- subset(finaldata, select = c('CUISINE.DESCRIPTION','BORO','VIOLATION.CODE'))
temp <- subset(finaldata, select = c('CUISINE.DESCRIPTION','VIOLATION.CODE'))
temp$VIOLATION.CODE <- apply(matrix(as.character(temp$VIOLATION.CODE)),1,
                             function(x) substring(x,1,2))
temp$VIOLATION.CODE <- as.factor(temp$VIOLATION.CODE)
temp2 <- temp%>%group_by(CUISINE.DESCRIPTION,VIOLATION.CODE)%>%summarize(count=n())
temp3 <- temp2 %>% group_by(VIOLATION.CODE)%>% summarize(violation_count = sum(count))
temp4 <- left_join(temp2, temp3, by = 'VIOLATION.CODE')
temp4$percentage <- temp4$count / temp4$violation_count *100

r <- restaurant %>%
  group_by(CUISINE.DESCRIPTION) %>%
  summarise( x= n())

temp5 <- r %>% group_by(x) %>% summarize( restaurants = n())
temp5$total <- sum(temp5$restaurants)
temp5$rest_p <- temp5$restaurants / temp5$total


temp6 <- left_join(temp4,temp5)
temp6 <- na.omit(temp6)
temp6 <- filter(temp6, VIOLATION.CODE != " ")

ggplot(temp6,aes(as.factor(month), as.factor(VIOLATION.CODE))) +
  stat_sum(aes(group = SCORE, colour = VIOLATION.DESCRIPTION, weight = restaurants),geom = "point")  + 
  scale_fill_gradient(low = "LightSkyBlue", high = "LightCoral", na.value = "grey")+
  xlab("month")+ylab("Violation Code")

ggplot(temp6,aes(as.factor(VIOLATION.CODE),as.factor(CUISINE.DESCRIPTION))) + 
  stat_sum(aes(group = percentage, colour = VIOLATION.CODE,weight=1/rest_p),geom = "point", position = position_jitter(width = 0.0, height = 0.0))  +
  scale_fill_gradient(low = "LightSkyBlue", high = "LightCoral", na.value = "grey")+
  xlab("month")+ylab("Violation Code") + theme(axis.text = element_text(size = 6))
###############
hm = c("VIOLATION.CODE", "VIOLATION.DESCRIPTION","CUISINE.DESCRIPTION","SCORE")
hm_man <- df_man[hm]
hm_brok <- df_brok[hm]
> hm_bronx <- df_bronx[hm]
> hm_queens <- df_queens[hm]
> hm_staten <- df_staten[hm]
> hm_df <- df[hm]
> hm_df$SCORE = 1
> hm_man$SCORE = 1
> hm_brok$SCORE = 1
> hm_bronx$SCORE = 1
> hm_staten$SCORE = 1
> hm_queens$SCORE = 1
ggplot(hm_df,aes(as.factor(VIOLATION.CODE),as.factor(CUISINE.DESCRIPTION))) + stat_sum(aes(group = SCORE, colour = VIOLATION.DESCRIPTION),geom = "point")  + scale_fill_gradient(low = "LightSkyBlue", high = "LightCoral", na.value = "grey")+xlab("month")+ylab("Violation Code")
