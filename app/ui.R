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

year <- unique(as.numeric(b$INSPECTION.YEAR))

GRADE <- c("Not Yet Graded" ,"A", "B", "C","P", "Z")

vars1 <- c(
  'All type' = '',
  'Food Temperature' = 2,
  'Food Source' = 3,
  'Food Protection' = 4,
  'Working Environment Safety' = 5,
  'Workers Cleanliness' = 6,
  'Duties of Officer' = 7,
  'Facility Issues' = 8,
  'Food Storage' = 9,
  'Utility Issues' = 10,
  'Tobacco Issues' = 15,
  'Food Nutrition/Calories' = 16,
  'Documents Not Present' = 18,
  'Information Not Posted' = 20,
  'Facility Issues 2' = 22,
  'Other General Violation' = 99
)

BORO <- c('New York','Manhattan','Brooklyn','Bronx','Staten Island', 'Queens')

# Define UI for application that draws a histogram
shinyUI(fluidPage(navbarPage("Restaurant Violations", id="nav",
                             
                             
                             tabPanel("Dynamic Map of Scores",
                                      div(class="outer",

                                          tags$head(
                                            #   # Include our custom CSS
                                            includeCSS("styles.css")
                                          ),

                                          leafletOutput("map",width='100%', height='95%'),

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
                                            includeCSS('styles.css'),
                                            includeScript('gomap.js')
                                          ),

                                          leafletOutput('map2',width='100%', height='95%'),

                                          absolutePanel(id = 'controls', class='panel panel-default', fixed = T,
                                                        draggable = T, top = 60, left = 'auto', right = 20, bottom='auto',
                                                        width=330, height = 'auto',
                                                        h2('Restaurant Grades'),
                                                        selectInput('GRADE','Restaurant Grades', GRADE,selected = 'B')),
                                          helpText('This map shows the latest grade for every restaurant.
                                                   It is for inspectors designing routes to visit certain grade levels.')

                                      )),
                             ############################
                             tabPanel('Dynamic Map of Violation',
                                      div(class='outer',
                                          
                                          tags$head(
                                            #includeCSS('~/Desktop/ADS/project2/finalapp/styles.css'),
                                            #includeScript('~/Desktop/ADS/project2/finalapp/gomap.js')),
                                            includeCSS('styles.css'),
                                            includeScript('gomap.js')),
                                          
                                          leafletOutput('map3', width='100%', height='100%'),
                                          # Shiny versions prior to 0.11 should use class='modal' instead.
                                          
                                          absolutePanel(id = 'controls', class = 'panel panel-default', fixed = TRUE,
                                                        draggable = TRUE, top = 60, left = 'auto', right = 20, bottom = 'auto',
                                                        width = 330, height = 'auto', h2('Violation Type'),
                                                        
                                                        #radioButtons("color", "violation", vars, selected = 'Violation Type'),
                                                        
                                                        #sliderInput('date', 'Animation duration', min = as.Date('2015-01-01'),
                                                        #            max = as.Date('2015-12-31'), value = as.Date('2015-06-30'), 
                                                        #            step = 1,format='## Days'),
                                                        
                                                        
                                                        selectInput('type', 'Violation Example', vars1)
                                                        # radioButtons("color", "Violation Type", vars, selected = '')
                                          ))
                             ),
                             ############################
                             tabPanel("Scores Detection",
                                      sidebarLayout(
                                        sidebarPanel(
                                          helpText("scores of restaurants of every month"),

                                          selectInput("BORO",
                                                      label = "Choose a borough to display",
                                                      #choices = c("New York", "Manhattan", "Brooklyn", #"Bronx", "Staten Island", "Queens"
                                                      #                           ),
                                                      choices = levels(factor(BORO)),
                                                      selected = "Overall")

                                        ),

                                        mainPanel(
                                          plotOutput("scater_plot",click="plot_click")
                                          
                                          #verbatimTextOutput("info")
                                        )
                                      )

                             ),
                             
                             tabPanel("Relationship of Cuisine Types and Violations",
                                      
                                      mainPanel(
                                        plotOutput("heat_plot", width='90%',height='90%')
                                      )
                                      )
)
))