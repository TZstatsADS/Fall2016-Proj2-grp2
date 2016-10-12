#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
require(ggmap)
require(maps)
require(sp)
require(leaflet)

# Define server logic required to draw a histogram
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
 if (input$cuisine == " "){
   t <- filter(b, year %in% input$year)
   return(t)
 }
 else{
    t <- filter(b, cuisine %in% input$cuisine, year %in% input$year)
    return(t)
  }})

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


output$map2 <- renderLeaflet({
  leaflet(bind_jm) %>%
    addTiles(
      urlTemplate = "https://api.mapbox.com/v4/mapbox.streets/{z}/{x}/{y}.png?access_token=pk.eyJ1IjoiZnJhcG9sZW9uIiwiYSI6ImNpa3Q0cXB5bTAwMXh2Zm0zczY1YTNkd2IifQ.rjnjTyXhXymaeYG6r2pclQ",
      attribution = 'Maps by <a href="http://www.mapbox.com/">Mapbox</a>'
    ) %>% setView(lng = -73.97, lat = 40.75, zoom = 13) 
  
})

# Filter bind data
drawv <- reactive({
  if (input$GRADE == "All"){
    k <- bind_jm
    return(k)
  }
  else{
    k <- filter(bind_jm, GRADE == input$GRADE)
    return(k)
  }})


observe({
  draw2 <- drawv()
  
  radius <-  50
  if (length(draw2) > 0) {
    leafletProxy("map2", data = draw2) %>%
      clearShapes() %>%
      addCircles(~long, ~lat, radius=radius,
                 stroke=F, fillOpacity=0.8, popup=~name) 
    
  }
  else {
    leafletProxy("map2", data = draw2) %>%
      clearShapes()
  }
})
})




#})
