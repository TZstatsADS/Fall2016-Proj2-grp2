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

GRADE <- c("Not Yet Graded" ,"A", "B", "C", "Z")

BORO <- c('New York','Manhattan','Brooklyn','Bronx','Staten Island', 'Queens')

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
                                                      selected = "A")

                                      )),
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
                                          plotOutput("scater_plot",click="plot_click"),
                                          plotOutput("heat_plot")
                                          #verbatimTextOutput("info")
                                        )
                                      )

                             )
)
))