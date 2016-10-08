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

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
   


output$map <- renderLeaflet({
  leaflet(sub3) %>%
    addTiles(
      urlTemplate = "https://api.mapbox.com/v4/mapbox.streets/{z}/{x}/{y}.png?access_token=pk.eyJ1IjoiZnJhcG9sZW9uIiwiYSI6ImNpa3Q0cXB5bTAwMXh2Zm0zczY1YTNkd2IifQ.rjnjTyXhXymaeYG6r2pclQ",
      attribution = 'Maps by <a href="http://www.mapbox.com/">Mapbox</a>'
    ) %>%
    setView(lng = -73.97, lat = 40.75, zoom = 13) 
})

# Select violation type, multiple selections are allowed
vtype <- reactive({
  v <- violation
  if (input$handicap == TRUE){
    t <- filter(t, Handicap == "Yes")
  }
  if (input$yearround == TRUE){
    t <- filter(t, Yearround == "Yes")
  }
  return(t)
})


  })
  
#})
