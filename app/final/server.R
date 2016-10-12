library(shiny)

###########################Erica
shinyServer(function(input, output) {
  
  output$map <- renderLeaflet({
    leaflet(b) %>%
      addTiles(
        urlTemplate = "https://api.mapbox.com/v4/mapbox.streets/{z}/{x}/{y}.png?access_token=pk.eyJ1IjoiZnJhcG9sZW9uIiwiYSI6ImNpa3Q0cXB5bTAwMXh2Zm0zczY1YTNkd2IifQ.rjnjTyXhXymaeYG6r2pclQ",
        attribution = 'Maps by <a href="http://www.mapbox.com/">Mapbox</a>'
      ) %>% setView(lng = -73.97, lat = 40.75, zoom = 13)

  })

  # Filter bind data
  drawvalue <- reactive({
    #if (input$year == ' '){
    #  t <- filter(b, year %in% input$year)
    #  return(t)
    #}
    #else{
    t <- subset(b, INSPECTION.YEAR == input$year)
    return(t)
  })

  observe({
    draw <- drawvalue()

    radius <-  50
    if (length(draw) > 0) {
      leafletProxy("map", data = draw) %>%
        clearShapes() %>%
        addCircles(~long, ~lat, radius=radius,
                   stroke=FALSE, fillOpacity=0.8, color = cols_score)
    }
    else {
      leafletProxy("map", data = draw) %>%
        clearShapes()
    }
  })
#####################################Jing
  output$map2 <- renderLeaflet({
    leaflet() %>%
      addTiles(
        urlTemplate = "https://api.mapbox.com/v4/mapbox.streets/{z}/{x}/{y}.png?access_token=pk.eyJ1IjoiZnJhcG9sZW9uIiwiYSI6ImNpa3Q0cXB5bTAwMXh2Zm0zczY1YTNkd2IifQ.rjnjTyXhXymaeYG6r2pclQ",
        attribution = 'Maps by <a href="http://www.mapbox.com/">Mapbox</a>'
      ) %>% setView(lng = -73.97, lat = 40.75, zoom = 13)
  })

  # Filter bind data
  drawv <- reactive({
    if (input$GRADE == ""){
      k <- bind_jm
      return(k)
    }
    else{
      k <- subset(bind_jm, GRADE == input$GRADE)
      return(k)
    }
    })


  observe({
    colorBy1 <- 'GRADE'
    draw2 <- drawv()
    # pal <- colorFactor(col,domain = levels(bind$GRADE))
    colorData1 <- draw2[[colorBy1]]
    
    pal <- colorFactor("Set1", colorData1)

    radius2 <-  30
   # if (length(draw2) > 0) {
      leafletProxy("map2", data = draw2) %>%
        clearShapes() %>%
        hideGroup('Cluster') %>%
        addCircles(~long, ~lat, radius=radius2,
                   stroke=F, fillOpacity=0.8, fillColor=pal(colorData1))

    #}
    #else {
    #  leafletProxy("map2", data = draw2) %>%
    #    clearShapes()
    #}
  })
################### Han
  output$map3 <- renderLeaflet({
    leaflet() %>%
      addTiles(
        urlTemplate = "//{s}.tiles.mapbox.com/v3/jcheng.map-5ebohr46/{z}/{x}/{y}.png",
        attribution = 'Maps by <a href="http://www.mapbox.com/">Mapbox</a>'
      ) %>%
      setView(lng = -73.97, lat = 40.75, zoom = 13)
  })
  
  # Choose just one vehicle
  drawvalue1 <- reactive({if (input$type == ''){return(mydata)}else{
    t <- subset(mydata, VIOLATION.CODE == input$type)
    return(t)
  }})
  
  
  observe({
    colorBy <- 'VIOLATION.CODE' #input$type #mydata$
    draw1 <- drawvalue1()
    
    colorData <- draw1[[colorBy]]
    
    pal1 <- colorFactor("Set1", colorData)
    
    radius1 <- 30
    
    leafletProxy("map3", data = draw1) %>%
      clearShapes() %>%
      hideGroup('Cluster') %>%
      addCircles(~long, ~lat, radius=radius1, 
                 stroke=FALSE, fillOpacity=0.8, fillColor=pal1(colorData)) #%>%
      #addLegend("bottomleft", pal=pal1, values=colorData, title=colorBy,
                #layerId="colorLegend")
    
  })
  
###################Yifei & Yixin
  output$scater_plot<-renderPlot({
      if (input$BORO=="New York")
      {
          new_york$month<-factor(new_york$month)
          ggplot(new_york,aes(x = month, y = SCORE,fill=month))+stat_summary(fun.y = "mean",geom = "bar")+coord_cartesian(ylim=c(15,23))+ylab("score")

      }
      else if (input$BORO=="Manhattan"){
          man$month<-factor(man$month)
          ggplot(man,aes(x = month, y = SCORE,fill=month))+stat_summary(fun.y = "mean",geom = "bar")+coord_cartesian(ylim=c(15,23))+ylab("score")

      }
      else if (input$BORO=="Bronx"){
          bronx$month<-factor(bronx$month)
          ggplot(bronx,aes(x = month, y = SCORE,fill=month))+stat_summary(fun.y = "mean",geom = "bar")+coord_cartesian(ylim=c(15,23))+ylab("score")

      }
      else if (input$BORO=="Staten Island"){
          staten$month<-factor(staten$month)
          ggplot(staten,aes(x = month, y = SCORE,fill=month))+stat_summary(fun.y = "mean",geom = "bar")+coord_cartesian(ylim=c(15,23))+ylab("score")

      }
      else if (input$BORO=="Queens"){
          queens$month<-factor(queens$month)
          ggplot(queens,aes(x = month, y = SCORE,fill=month))+stat_summary(fun.y = "mean",geom = "bar")+coord_cartesian(ylim=c(15,23))+ylab("score")

      }
      else if (input$BORO=="Brooklyn"){
          brok$month<-factor(brok$month)
          ggplot(brok,aes(x = month, y = SCORE,fill=month))+stat_summary(fun.y = "mean",geom = "bar")+coord_cartesian(ylim=c(15,23))+ylab("score")

      }
  })
  output$heat_plot<-renderPlot({
      if (input$BORO=="New York")
      {
          ggplot(hm_df,aes(as.factor(month), as.factor(VIOLATION.CODE))) + stat_sum(aes(group = SCORE, colour = VIOLATION.DESCRIPTION),geom = "point")  + scale_fill_gradient(low = "LightSkyBlue", high = "LightCoral", na.value = "grey")+xlab("month")+ylab("Violation Code")

      }
      else if (input$BORO=="Manhattan"){
          ggplot(hm_man,aes(as.factor(month), as.factor(VIOLATION.CODE))) + stat_sum(aes(group = SCORE, colour = VIOLATION.DESCRIPTION),geom = "point")  + scale_fill_gradient(low = "LightSkyBlue", high = "LightCoral", na.value = "grey")+xlab("month")+ylab("Violation Code")
      }
      else if (input$BORO=="Bronx"){
          ggplot(hm_bronx,aes(as.factor(month), as.factor(VIOLATION.CODE))) + stat_sum(aes(group = SCORE, colour = VIOLATION.DESCRIPTION),geom = "point")  + scale_fill_gradient(low = "LightSkyBlue", high = "LightCoral", na.value = "grey")+xlab("month")+ylab("Violation Code")
      }
      else if (input$BORO=="Staten Island"){
          ggplot(hm_staten,aes(as.factor(month), as.factor(VIOLATION.CODE))) + stat_sum(aes(group = SCORE, colour = VIOLATION.DESCRIPTION),geom = "point")  + scale_fill_gradient(low = "LightSkyBlue", high = "LightCoral", na.value = "grey")+xlab("month")+ylab("Violation Code")
      }
      else if (input$BORO=="Queens"){
          ggplot(hm_queens,aes(as.factor(month), as.factor(VIOLATION.CODE))) + stat_sum(aes(group = SCORE, colour = VIOLATION.DESCRIPTION),geom = "point")  + scale_fill_gradient(low = "LightSkyBlue", high = "LightCoral", na.value = "grey")+xlab("month")+ylab("Violation Code")
      }
      else if (input$BORO=="Brooklyn"){
          ggplot(hm_brok,aes(as.factor(month), as.factor(VIOLATION.CODE))) + stat_sum(aes(group = SCORE, colour = VIOLATION.DESCRIPTION),geom = "point")  + scale_fill_gradient(low = "LightSkyBlue", high = "LightCoral", na.value = "grey")+xlab("month")+ylab("Violation Code")
      }
  })
})
