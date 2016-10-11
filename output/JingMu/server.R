library(shiny)
library(leaflet)
library(RColorBrewer)
library(scales)
library(lattice)
library(dplyr)
library(data.table)
library(plotrix)
library(ggplot2)
library(RColorBrewer)

shinyServer(function(input, output, session){
    col=c('darkred','yellow','red','darkseagreen')
    #col=c('darkred','yellow','red','darkseagreen','deepskyblue','khaki','orange')
    
    output$map <- renderLeaflet({
        leaflet() %>%
            addTiles(
                urlTemplate = "//{s}.tiles.mapbox.com/v3/jcheng.map-5ebohr46/{z}/{x}/{y}.png",
                attribution = 'Maps by <a href="http://www.mapbox.com/">Mapbox</a>'
            ) %>%
            setView(lng = -73.958, lat = 40.801453, zoom = 12)
            
    })
    
    
    # Filter bind data
    drawvalue <- reactive({
      if (input$GRADE == ''){
        t <- filter(bind)
        return(t)
      }
      else{
        t <- filter(bind, GRADE %in% input$GRADE)
        return(t)
      }})
    
    
    observe({
      draw <- drawvalue()
      
      radius <-  50
      if (length(draw) > 0) {
        leafletProxy("map", data = draw) %>%
          clearShapes() %>%
          addCircles(~long, ~lat, radius=radius,
                     stroke=FALSE, fillOpacity=0.8, color = cols, popup=~name) 
      }
      else {
        leafletProxy("map", data = draw) %>%
          clearShapes()
      }
    })
})




