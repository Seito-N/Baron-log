library(shiny)
library(DT)

# Define UI for application that draws a histogram

shinyUI(fluidPage(

    # Application title
    titlePanel("Baron's toilet log"),
    
    # bar plot ----
    fluidRow(
        column(4,
               ## select the date
               dateRangeInput(inputId = "date", 
                              label = "集計期間", 
                              start = "2022-03-01", 
                              end = "2022-12-31",
                              min = "2021-11-15",
                              max = "2100-1-1",
                              weekstart = 0)
               ),
        
        column(12, 
               ## show bar plot for freqency
               mainPanel(plotOutput(outputId = "freqPlot"))
               ),
        
        column(12,
               ## show plot for doing
               mainPanel(plotOutput(outputId = "DoPlot"))
               ),
        
        column(12, 
               # show the data table
               mainPanel(DT::dataTableOutput("summary_table"))
               )
        )
    )
    )