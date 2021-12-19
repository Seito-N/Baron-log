library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
    # Application title
    titlePanel("Baron's toilet log !!"),
    
    # select the date
    dateRangeInput(inputId = "date", 
                   label = "集計期間", 
                   start = "2021-11-15", 
                   end = "2022-12-31",
                   min = "2021-11-15",
                   max = "2100-1-1",
                   weekstart = 0),
    
    # show bar plot for freqency
    plotOutput(outputId = "freqPlot")
))