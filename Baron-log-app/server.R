#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
    bins <- reactive({
        x = faithful[, 2]
        return(seq(min(x), max(x), length.out = input$bins + 1))
    })

    output$distPlot <- renderPlot({

        # draw the histogram with the specified number of bins
        hist(faithful[, 2], breaks = bins(), col = isolate(input$color), border = 'white')

    })

})
