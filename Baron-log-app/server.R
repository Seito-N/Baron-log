library(shiny)
library(tidyverse)
library(lubridate)

# Define server logic required to draw a histogram

shinyServer(function(input, output) {
    
    ## in data
    dat <- readxl::read_xlsx("C:/Users/seito/Documents/Baron-log/baron_log.xlsx")
    
    ## make data
    dat2 <- dat %>% 
        mutate(date = ymd(date)) %>% 
        mutate(time = hms::as_hms(time)) %>% 
        mutate(date_time = ymd_hms(paste(date, time))) %>% 
        mutate(Oshikko = case_when(Oshikko_suc == 1 ~ 1, 
                                   Oshikko_suc == 0 ~ 0, 
                                   TRUE ~ NA_real_)) %>% 
        mutate(Unchi = case_when(Unchi_suc == 1 ~ 1, 
                                 Unchi_suc == 0 ~ 0, 
                                 TRUE ~ NA_real_))
    
    ## make long data
    dat2_long <- dat2 %>% 
        select(date, time, Oshikko, Unchi) %>% 
        pivot_longer(cols = c(Oshikko, Unchi), 
                     names_to = "Peeing", 
                     values_to = "toilet_flag") %>%
        na.omit() %>% 
        mutate(time = as_datetime(time))
    
    baron_data <- reactive({
        filter(dat2_long, between(date ,input$date[1], input$date[2]))
    })
    
    output$freqPlot <- renderPlot({
        
        # bar plot
        ggplot(data = baron_data(), 
               mapping = aes(x = date, colour = Peeing)) + 
            geom_bar(alpha = 0.5) +
            scale_x_date(date_breaks = "1 days", date_labels = "%m-%d") + 
            facet_wrap(~ Peeing) + 
            scale_y_continuous(breaks = seq(0, 100, by = 1))
            
    })
    
})