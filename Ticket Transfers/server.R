
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
require(rCharts)

## server.r
    
     shinyServer(function(input, output) {
          output$myChart <- renderChart2({
               names(iris) = gsub("\\.", "", names(iris))
               p1 <- rPlot(input$x, input$y, data = iris, color = "Species", 
                           facet = "Species", type = 'point')
               p1$addParams(dom = 'myChart')
               return(p1)
          output$text <- renderText(input$tofrom)
          })
     })
