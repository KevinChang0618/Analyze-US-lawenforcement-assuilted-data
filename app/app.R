library(tidyverse)
library(shiny)
library(leaflet)
library(maps)
library(sf)
library(broom)
library(tools)
library(rbokeh)

state_assault <- read_csv("../output/state_assault.csv") #1
us_assault <- read_csv("../output/US_assault.csv") #1
state_name <- unique(state_assault$state) # each state abbrviation
state_name[length(state_name)+1] <- c("ALL US")
state_assault_timezone <- read_csv("../output/state_assault_timezone.csv") #2
us_assault_timezone <- read_csv("../output/US_assault_timezone.csv") #2
us_timecount <- read_csv("../output/US_timecount.csv") #3
state_timecount <- read_csv("../output/state_timecount.csv") #3
us_injury <- read_csv("../output/us_injury.csv") #4
us_safe <- read_csv("../output/us_safe.csv") #4
state_injury <- read_csv("../output/state_injury.csv") #4
state_safe <- read_csv("../output/state_safe.csv") #4
gi<-read_csv("../output/geo_info_us.csv") # map
as <-full_join(gi, state_assault, by ="state") # map


ui <- fluidPage(
  titlePanel("Assaults on Law Enforcement Officers Data"),
  tabsetPanel(
    tabPanel(title = "Relation between Crime numbers and Years",
             sidebarLayout(
               sidebarPanel = sidebarPanel( 
                 selectInput("state","what state ?", choices = state_name),
               ),
               mainPanel = mainPanel(
                 plotOutput("crimenumber_line_chart")
               )
             )
             ),
    tabPanel(title = "Relation between Crime numbers and Time. Compared to All US",
             fluidRow(
               column(4,
                      sliderInput("year","which year ?", min =1995, max=2018, value=1995)
                      ),
               column(4,
                      selectInput("state2","what state ?", choices = state_name)
                      ),
               column(4,
                      actionButton("random","Start the Random Year & State"))
              ),
             fluidRow(
               column(6,
                      plotOutput("timezone_line_chart")),
               column(6,
                      plotOutput("timezone_line_chart2"))
              )
             ),
    tabPanel(title = "T.test Statistics",
                 selectInput("state3","what state ?", choices = state_name),
                 tableOutput("tour"),
             textOutput("text")
             ),
    tabPanel(title = "Weapon and officer injury relation",
             fluidRow(
               column(4,
                      selectInput("injurystate","what state ?", choices = state_name)
               ),
               column(4,
                      selectInput("safestate","what state ?", choices = state_name)
               ),
               column(4,
                      actionButton("random2","Start the Random State"))
             ),
             fluidRow(
               column(6,
                      plotOutput("injuryplot")),
               column(6,
                      plotOutput("not_injuryplot"))
             )
             ),
    tabPanel(title = "United Stated Lawenforcment Assulted Map",
             fluidRow(
               column(6,
                      sliderInput("year_2","which year ?", min =1995, max=2018, value=1995)
               ),
               column(6,
                      actionButton("year_button","random year?")),
               fluidRow(
                 column(12,
                        rbokehOutput("map")  
                 )))
    
   )
))

server <- function(input, output, session) {

  output$crimenumber_line_chart <- renderPlot({
   
    if(input$state=="ALL US"){
    pl<- us_assault %>% 
           ggplot(aes(x= year, y= crime_numbers))+
             geom_line(col=2, size=2.5)+
             geom_point(col="black",size=2.5)+
             geom_smooth(method="lm" , se= FALSE)+
             theme_bw()+
             ggtitle("All U.S crime number trend")
    }else{
      pl<- state_assault %>% 
        filter(state == input$state) %>%
        ggplot(aes(x= year, y= crime_numbers, group=1))+
        geom_line(col=2, size=2.5)+
        geom_point(col="black", size=2.5)+
        geom_smooth(method="lm" , se= FALSE)+
        theme_bw()+
        ggtitle(str_c(input$state," state crime number trend"))
    }
    pl
  }) # tab1
  
  timer <- reactiveTimer(intervalMs = 4000)
  x <- reactive({
    timer()
    sample(1995:2018,size = 1)
  })
  y <- reactive({
    timer()
    sample(state_name,size = 1)
  })
  
  output$timezone_line_chart <- renderPlot({ 
    if(input$random==TRUE){
      pl <- state_assault_timezone %>%
              filter(year == x()) %>%
              filter(state == y()) %>%
              ggplot(aes(x= Time, y= count, group= 1))+
                geom_point()+
                geom_line()+
                geom_vline(xintercept = 4, lty= 2, col= 2 )+
                geom_vline(xintercept = 9, lty= 2, col= 2 )+
                theme_bw()+
                ggtitle(str_c(y(), " crime number trend in time / ", x(), ". 06~18 is day time, 18~06 us night time"))
      pl}else{
        state_assault_timezone %>%
                filter(year == input$year) %>%
                filter(state == input$state) %>%
                ggplot(aes(x= Time, y= count, group= 1))+
                  geom_point()+
                  geom_line()+
                  geom_vline(xintercept = 4, lty= 2, col= 2 )+
                  geom_vline(xintercept = 9, lty= 2, col= 2 )+
                  theme_bw()+
                  ggtitle(str_c(input$state2, " crime number trend in time / ", input$year, ". 06~18 is day time, 18~06 us night time")) -> pl
        pl
      }
  }) # tab2-1
  
  output$timezone_line_chart2 <- renderPlot({
    if(input$random==TRUE){
    pl <- us_assault_timezone %>%
      filter(year== x()) %>%
      ggplot(aes(x= Time, y= count, group= 1))+
       geom_point()+
       geom_line()+
       geom_vline(xintercept = 4, lty= 2, col= 2 )+
       geom_vline(xintercept = 9, lty= 2, col= 2 )+
       theme_bw()+
       ggtitle(str_c("All U.S crime number trend in time / ", x(), ". 06~18 is day time, 18~06 us night time"))
    pl}else{
      pl <- us_assault_timezone %>%
        filter(year== input$year) %>%
        ggplot(aes(x= Time, y= count, group= 1))+
        geom_point()+
        geom_line()+
        geom_vline(xintercept = 4, lty= 2, col= 2 )+
        geom_vline(xintercept = 9, lty= 2, col= 2 )+
        theme_bw()+
        ggtitle(str_c("All U.S crime number trend in time / ", input$year, ". 06~18 is day time, 18~06 us night time"))
      pl
      
    }
  }) # tab2-2
  
  output$tour <- renderTable({
    if(input$state3 =="ALL US"){
      table <- t.test(us_timecount$daycount,us_timecount$nightcount)%>%
        tidy()
    }else{
       state_timecount %>% 
            filter(state == input$state3) -> state_timecount
       table <- t.test(state_timecount$daycount,state_timecount$nightcount) %>% 
         tidy()
    }
     table 
  }) # tab3
  
  output$text <- renderText({
    "If p.value < 0.05, we have evidence that the mean number of crimes in the day is different from the mean number of crimes at night"
  }) # tab3
  
  output$injuryplot <- renderPlot({
    if(input$random2==TRUE & input$injurystate == "ALL US"){
      pl <- us_injury %>%
        ggplot(aes(x= year, y=`sum(count)`,color = weaponkind))+
        geom_line()+
        labs(y = "count") +
        ggtitle("All US Injury Number")
        theme_bw()
      pl}else if (input$random2==TRUE & input$injurystate != "ALL US"){
        pl <- state_injury %>%
          filter(state== y()) %>%
          ggplot(aes(x= year, y= `sum(count)`, color = weaponkind))+
          geom_line()+
          labs(y = "count")+
          theme_bw()+
          ggtitle(str_c(y()," Injury Number"))
        pl
        
      }else if (input$injurystate == "ALL US"){
        pl <- us_injury %>%
          ggplot(aes(x= year, y=`sum(count)`,color = weaponkind))+
          geom_line()+
          labs(y = "count") +
          ggtitle("All US Injury Number")+
          theme_bw()
        pl
      }else{
        pl <- state_injury %>%
          filter(state== input$injurystate) %>%
          ggplot(aes(x= year, y= `sum(count)`, color = weaponkind))+
          geom_line()+
          theme_bw()+
          ggtitle(str_c(input$injurystate," Injury Number"))
        pl
      }
  }) # tab4-injury
  
  output$not_injuryplot <- renderPlot({
    if(input$random2==TRUE & input$safestate == "ALL US"){
      pl <- us_safe %>%
        ggplot(aes(x= year, y=`sum(count)`,color = weaponkind))+
        geom_line()+
        labs(y = "count") +
        ggtitle("All US Safe Number")
      theme_bw()
      pl}else if (input$random2==TRUE & input$safestate != "ALL US"){
        pl <- state_safe %>%
          filter(state== y()) %>%
          ggplot(aes(x= year, y= `sum(count)`, color = weaponkind))+
          geom_line()+
          labs(y = "count")+
          theme_bw()+
          ggtitle(str_c(y()," Safe Number"))
        pl
        
      }else if ( input$safestate == "ALL US"){
        pl <- us_safe %>%
          ggplot(aes(x= year, y=`sum(count)`,color = weaponkind))+
          geom_line()+
          labs(y = "count") +
          ggtitle("All US Safe Number")+
          theme_bw()
        pl
      }else{
        pl <- state_safe %>%
          filter(state== input$safestate) %>%
          ggplot(aes(x= year, y= `sum(count)`, color = weaponkind))+
          geom_line()+
          theme_bw()+
          labs(y = "count") +
          ggtitle(str_c(input$safestate," Safe Number"))
        pl
      }
  }) # tab4-safe
  
  output$map <- renderRbokeh({
    
    if(input$year_button == TRUE){
      caps <- dplyr::filter(as, year == x())
      
      mymap <-   suppressWarnings(figure(width = 900, height = 350,xlim = range(-150,-50), ylim = range(20,50), padding_factor = 0) %>%
                                    ly_map("world",regions = "usa", col = "gray") %>%
                                    ly_points(lon, lat, data = caps, size = 10,
                                              hover = c(state, crime_numbers)))
    }
    else{
      caps <- dplyr::filter(as, year == input$year_2)
      mymap <-  suppressWarnings(figure(width = 900, height = 350,xlim = range(-150,-50), ylim = range(20,50), padding_factor = 0) %>%
                                   ly_map("world",regions = "usa", col = "gray") %>%
                                   ly_points(lon, lat, data = caps, size = 10,
                                             hover = c(state, crime_numbers)))
      
    }
    mymap
  })
}

shinyApp(ui, server)
