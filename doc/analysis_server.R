library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
  #borough <- levels(df$BORO)
  
  output$scater_plot<-renderPlot({
    if (input$BORO=="New York")
      {
      month<-factor(new_york$month)
      ggplot(new_york,aes(x = month, y = SCORE,fill=month))+stat_summary(fun.y = "mean",geom = "bar")+coord_cartesian(ylim=c(15,23))
      
      }
    else if (input$BORO=="Manhattan"){
      month<-factor(man$month)
      ggplot(man,aes(x = month, y = SCORE,fill=month))+stat_summary(fun.y = "mean",geom = "bar")+coord_cartesian(ylim=c(15,23))
      
      }
    else if (input$BORO=="Bronx"){
      month<-factor(bronx$month)
      ggplot(bronx,aes(x = month, y = SCORE,fill=month))+stat_summary(fun.y = "mean",geom = "bar")+coord_cartesian(ylim=c(15,23))
      
      }
    else if (input$BORO=="Staten Island"){
      month<-factor(staten$month)
      ggplot(staten,aes(x = month, y = SCORE,fill=month))+stat_summary(fun.y = "mean",geom = "bar")+coord_cartesian(ylim=c(15,23))
      
      }
    else if (input$BORO=="Queens"){
      month<-factor(queens$month)
      ggplot(queens,aes(x = month, y = SCORE,fill=month))+stat_summary(fun.y = "mean",geom = "bar")+coord_cartesian(ylim=c(15,23))
      
      }
    else if (input$BORO=="Brooklyn"){
      month<-factor(brok$month)
      ggplot(brok,aes(x = month, y = SCORE,fill=month))+stat_summary(fun.y = "mean",geom = "bar")+coord_cartesian(ylim=c(15,23))
      
    }
  })
    output$heat_plot<-renderPlot({
      if (input$BORO=="New York")
      {
        ggplot(hm_df,aes(as.factor(month), as.factor(VIOLATION.CODE))) + stat_sum(aes(group = SCORE, colour = VIOLATION.DESCRIPTION),geom = "point")  + scale_fill_gradient(low = "LightSkyBlue", high = "LightCoral", na.value = "grey")+xlab("Month")+ylab("Violation Code")
        
      }
      else if (input$BORO=="Manhattan"){
        ggplot(hm_man,aes(as.factor(month), as.factor(VIOLATION.CODE))) + stat_sum(aes(group = SCORE, colour = VIOLATION.DESCRIPTION),geom = "point")  + scale_fill_gradient(low = "LightSkyBlue", high = "LightCoral", na.value = "grey")+xlab("Month")+ylab("Violation Code")
      }
      else if (input$BORO=="Bronx"){
        ggplot(hm_bronx,aes(as.factor(month), as.factor(VIOLATION.CODE))) + stat_sum(aes(group = SCORE, colour = VIOLATION.DESCRIPTION),geom = "point")  + scale_fill_gradient(low = "LightSkyBlue", high = "LightCoral", na.value = "grey")+xlab("Month")+ylab("Violation Code")
      }
      else if (input$BORO=="Staten Island"){
        ggplot(hm_staten,aes(as.factor(month), as.factor(VIOLATION.CODE))) + stat_sum(aes(group = SCORE, colour = VIOLATION.DESCRIPTION),geom = "point")  + scale_fill_gradient(low = "LightSkyBlue", high = "LightCoral", na.value = "grey")+xlab("Month")+ylab("Violation Code")
      }
      else if (input$BORO=="Queens"){
        ggplot(hm_queens,aes(as.factor(month), as.factor(VIOLATION.CODE))) + stat_sum(aes(group = SCORE, colour = VIOLATION.DESCRIPTION),geom = "point")  + scale_fill_gradient(low = "LightSkyBlue", high = "LightCoral", na.value = "grey")+xlab("Month")+ylab("Violation Code")
      }
      else if (input$BORO=="Brooklyn"){
        ggplot(hm_brok,aes(as.factor(month), as.factor(VIOLATION.CODE))) + stat_sum(aes(group = SCORE, colour = VIOLATION.DESCRIPTION),geom = "point")  + scale_fill_gradient(low = "LightSkyBlue", high = "LightCoral", na.value = "grey")+xlab("Month")+ylab("Violation Code")
      }
      
    
  }) 
    
    
   
  
    
})
