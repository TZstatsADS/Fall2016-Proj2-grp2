library(shiny)
library(leaflet)
library(shinythemes)

#GRADE <- levels(bind$GRADE)
GRADE <- c('All','','A','B','C','Not Yet Graded','P','Z')

shinyUI(fluidPage(
    titlePanel('Restaurant Grades'),
    
    tabPanel('Dynamic Map',
             div(class='outer',
                 tags$head(
                 includeCSS('styles.css')
                 ),
                 
                 leafletOutput('map'),
                 
                 absolutePanel(id = 'controls', class='panel panel-default', fixed = T,
                               draggable = T, top = 60, left = 'auto', right = 20, bottom='auto',
                               width='auto', height = 'auto',
                               h2('Restaurant Grades')),
                 selectInput(inputId = 'GRADE',label = 'Grade',
                             choices = GRADE,
                             selected = "All")

                 ))
))

# navbarPage('Grade', id = 'Grade',
#            tabPanel('Interactive map',
#                     div(class='outer',
#                         leafletOutput('map', width = '100%', height = '100%')))
#            )
