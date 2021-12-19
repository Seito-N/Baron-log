library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
    # Application title
    titlePanel("Baron's toilet log !!"),
    
    # select the date
    dateRangeInput(inputId = "date", 
                   label = "集計期間", 
                   start = min(dat2_long$date), 
                   end = max(dat2_long$date),
                   weekstart = 0),
    
    # show bar plot for freqency
    plotOutput(outputId = "freqPlot")
))