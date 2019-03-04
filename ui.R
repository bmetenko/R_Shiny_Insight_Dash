library(shiny)
library(shinydashboard)
library(ggplot2)
library(jsonlite)

source("Package_Check.R")
## API Calls ----
# nasa_api <- "https://mars.nasa.gov/rss/api/?feed=weather&category=insight&feedtype=json"
# 
# insight <- fromJSON(nasa_api, flatten=TRUE)
# 
# insight$validity_checks <- NULL
# 
# countDays <- length(names(insight))
# 
# insightdata <- NULL
# 
# insightdata$x <- as.numeric(names(insight)[-countDays])
# 
# at <- NULL
# 
# for (i in 1:7) {
#   at2 <- insight[[i]][1][["AT"]][["mx"]]
#   at <- c(at, at2)}
# 
# insightdata$y <- at
# 
# minDay <- min(as.numeric(insight$sol_keys))
# 
# maxDay <- max(as.numeric(insight$sol_keys))


# UI Calls ----
ui <- dashboardPage(skin = "red", 
  dashboardHeader(title = "Mars Insight Weather Dashboard"),
  dashboardSidebar(collapsed = TRUE,
                   h2("Place Info Here."),
                   menuItem("Weather", tabName = "weather", icon = icon("globe")),
                   menuItem("Pressure", tabName = "pressure", icon = icon("bars"))
                   ),
  dashboardBody(
    
    fluidRow(
      box(
        plotOutput("plot1"),
        h4("Day 87 corresponds to February 23rd"),
        align = "center",
        h2("Note: Mars weather for which Earth Days of the Sol year?"),
        dateRangeInput( "dateUse",label = "Dates:", 
                        end = Sys.Date(), start = Sys.Date() - 4, 
                        separator = " to ", min = Sys.Date() -4, 
                        max = Sys.Date(), autoclose = TRUE)
      ),
    box(
      title = "Current Time Delay between the Earth and Mars",
      status = "danger", 
      solidHeader = TRUE, 
      collapsible = FALSE,
      collapsed = FALSE,
      # width = 10,
      h3("3 to 4 days"),
      align = "center"
    ),
    box(
      title = "Temperature To Display",
      radioButtons("radio1",
                   label = "Currently Selected:",
                   choices = list("*C" = "C", "*F" = "F"),
                   inline = T), 
      solidHeader = TRUE,
      collapsible = FALSE,
      status = "success",
      align = "center"
    ),
    box(title = "Plot Settings",
      radioButtons("AveragesPlotted",label = "Plot Averages?",
                   choices = list("Yes!", "No..."), inline = T),
      radioButtons("MinsPlotted",label = "Plot Minimum Temps?",
                   choices = list("Yes!", "No..."), inline = T),
      radioButtons("MaxsPlotted",label = "Plot Maximum Temps?",
                   choices = list("Yes!", "No..."), inline = T),
      status = "primary"
    ),
    box(HTML("<iframe src='https://mars.nasa.gov/embed/22126/' width='25%' height='200'  scrolling='no' frameborder='0'></iframe>"))

  )),
  
  sliderInput("myslider", "", min=minDay, max=maxDay, value=maxDay))




server <- function(input, output, session) {
  output$plot1 <- renderPlot({
    p <- ggplot() + 
      geom_line(mapping = aes(x = insightdata$x, y = insightdata$yav), size = 2, color = "yellow") +
      theme_minimal() + 
      xlab("Earth Day") +
      ylab("Temperature in degrees C") +
      ggtitle("Air Temperature") + 
      scale_y_continuous(minor_breaks = seq(-20, 0, 1)) +
      scale_x_continuous(minor_breaks = seq(80, 100, 1)) +
      theme(title =  element_text(hjust = 0),
            plot.title = element_text(hjust = 0.5),
            axis.title = element_text(face = "bold", size = 12),
            axis.text = element_text(size = 15, angle = 45, face = "bold" ),
            panel.background = element_rect(fill = "maroon"))
    
    print(p)
    
    })}

shinyApp(ui, server)

