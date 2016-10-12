library(shiny)

  BORO <- c('New York','Manhattan','Brooklyn','Bronx','Staten Island', 'Queens')

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
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
))
