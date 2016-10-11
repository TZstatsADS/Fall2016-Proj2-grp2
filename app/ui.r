#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

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

score_bucket <- unique(b$score_bucket)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Restaurant Scores"),
  
  # Sidebar with a slider input for number of bins 
 
    
#    # Show a plot of the generated distribution
#    tabPanel("Inspection Grades",
#      leafletOutput("map")
#    ),
  tabPanel("Dynamic Map",
           div(class="outer",
               
               tags$head(
                 # Include our custom CSS
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
                           value=c(min(year), max(year)), step=1),
                                      animate=animationOptions(interval = 500)),
                            helpText("Click to see dynamic crime data")
              )#
           
  )
  )
)
