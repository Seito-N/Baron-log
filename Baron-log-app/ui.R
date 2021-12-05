# 指定した期間におけるおしっことうんちの回数を棒グラフで表示するアプリ

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("The Baron's toilet frequency !!"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            sliderInput("bins",
                        "Number of bins:",
                        min = 1,
                        max = 50,
                        value = 30), # initial value
            selectInput("color", "select color",
                        c("red", "blue", "green", "black"))
        ),

        # Show a plot of the generated distribution
        mainPanel(
            plotOutput("distPlot")
        )
    )
))
