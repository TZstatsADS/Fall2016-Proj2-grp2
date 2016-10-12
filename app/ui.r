#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(leaflet)

# Choices for drop-downs
cuisine <- c(
  "All Crime" = "",
  "Italian" = "Italian",
  "Afghan" = "Afghan",
  "African" = "African",
  "American" = "American",
  "Armenian" = "Armenian",
  "Asian" = "Asian",
  "Australian" = "Australian"
)
#cuisine <- levels(b$cuisine)

year <- unique(as.numeric(b$year))

GRADE <- c("All" ,"A", "B", "C", "Z")

# Define UI for application that draws a histogram
shinyUI(fluidPage(navbarPage("Restaurant Violations", id="nav",
  

  tabPanel("Dynamic Map of Scores",
           div(class="outer",
               
             tags$head(
             #   # Include our custom CSS
              includeCSS("styles.css")
             ),
               
               leafletOutput("map"),
               
               # Shiny versions prior to 0.11 should use class="modal" instead.
              absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                            draggable = TRUE, top = 60, left = "auto", right = 20, bottom = "auto",
                            width = "auto", height = "auto",
                            
                            h2("Restaurant Scores"),
                            
                          
                            # Simple integer interval
                                          sliderInput(inputId="year", label="Filter Years", min=min(year), max=max(year),
                           value=2015, step=1),
                                      animate=animationOptions(interval = 500)),
                            helpText("Representation of average score by year. Note, restaurants that receive a low grade are inspected more often.")
              )#
           
  ),
tabPanel('Dynamic Map of Grades',
         div(class='outer',
             tags$head(
               includeCSS('styles.css')
             ),
             
             leafletOutput('map2'),
             
             absolutePanel(id = 'controls', class='panel panel-default', fixed = T,
                           draggable = T, top = 60, left = 'auto', right = 20, bottom='auto',
                           width='auto', height = 'auto',
                           h2('Restaurant Grades')),
             selectInput(inputId = 'GRADE',label = 'Grade',
                         choices = GRADE,
                         selected = "All")
             
         ))
  )
))
