library(tidyverse)
library(lubridate)
library(shiny)

# Define server logic

shinyServer(function(input, output) {
    
    ## in data
    dat <- readxl::read_xlsx("C:/Users/seito/Documents/Baron-log/baron_log.xlsx")
    
    ## make data
    dat2 <- dat %>% 
        mutate(date = ymd(date),
               time = hms::as_hms(time),
               date_time = ymd_hms(paste(date, time)), 
               Oshikko = case_when(Oshikko_suc == 1 ~ 1, 
                                   Oshikko_suc == 0 ~ 0, 
                                   TRUE ~ NA_real_),
               Unchi = case_when(Unchi_suc == 1 ~ 1, 
                                 Unchi_suc == 0 ~ 0, 
                                 TRUE ~ NA_real_),
               out = case_when(out == 1 ~ "out",
                               TRUE ~ "in")
               )
    
    ## make long data
    dat2_long <- dat2 %>% 
        select(date, time, Oshikko, Unchi, out) %>% 
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
               mapping = aes(x = date, fill = out)) + 
            geom_bar(alpha = 0.5) +
            scale_x_date(date_breaks = "1 days", date_labels = "%m-%d") + 
            scale_y_continuous(breaks = seq(0, 10, by = 1)) +
            theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
            facet_wrap(~ Peeing)
            
    })
    
    output$DoPlot <- renderPlot({
        
        ggplot(data = baron_data(), 
               mapping = aes(x = date, y = time, 
                             group = interaction(Peeing, out),
                             colour = Peeing, shape = out)) + 
            geom_point(size = 6) + 
            scale_x_date(date_breaks = "1 days", date_labels = "%m-%d") + 
            scale_y_datetime(breaks = scales::date_breaks("1 hour"),
                             date_labels = "%H:%M") + 
            theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
            facet_wrap(~ Peeing)
    })
    
    summary_table <- reactive({
        filter(dat2_long, between(date, input$date[1], input$date[2])) %>% 
            group_by(Peeing) %>% 
            summarise(
                Frequency = n(), 
                Out_freq = sum(out == "out"), 
                Out_rate = sum(out == "out")/n(),
                Success_rate = sum(toilet_flag)/n()
                )
    })
    
    output$summary_table <- DT::renderDataTable({
        summary_table() %>% 
            mutate(across(where(is.numeric), round, digits = 3))})
    })