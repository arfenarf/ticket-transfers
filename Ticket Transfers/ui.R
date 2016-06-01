
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
require(rCharts)

shinyUI(pageWithSidebar(
     headerPanel("Kate's Sankiness"),
     
     sidebarPanel(
          radioButtons(inputId = "tofrom", "To or From ITS", 
                        choices = c('To:' = 'to-its', 'From:' = 'from-its')),
          selectInput(inputId = "x",
                      label = "Choose X",
                      choices = c('SepalLength', 'SepalWidth', 'PetalLength', 'PetalWidth'),
                      selected = "SepalLength"),
          selectInput(inputId = "y",
                      label = "Choose Y",
                      choices = c('SepalLength', 'SepalWidth', 'PetalLength', 'PetalWidth'),
                      selected = "SepalWidth")
     ),
     mainPanel(
          showOutput("myChart", "polycharts"),
     )
))
