library(shiny)
library(shinydashboard)
library(ggplot2)
library(jsonlite)



nasa_api <- "https://mars.nasa.gov/rss/api/?feed=weather&category=insight&feedtype=json"

insight <- fromJSON(nasa_api, flatten=TRUE)

insight$validity_checks <- NULL

countDays <- length(names(insight))

minDay <- min(as.numeric(insight$sol_keys))

maxDay <- max(as.numeric(insight$sol_keys))

insightdata <- NULL

insightdata$x <- as.numeric(names(insight)[-countDays])

at <- NULL

for (i in 1:6) {
  message(i)
  at2 <- insight[[i]][["AT"]][["av"]]
  at <- c(at, at2)}

insightdata$y <- at

# at1 <- NULL
# 
# for (i in 1:6) {
#   at1.1 <- insight[[i]][1][["AT"]][["mn"]]
#   at1 <- c(at1, at1.1)}
# 
# insightdata$ymin <- at2


# UI Calls ----
ui <- dashboardPage(skin = "red", 
  dashboardHeader(title = "Mars Insight Weather Dashboard"),
  dashboardSidebar(collapsed = TRUE,
                   helpText("This is a simple dashboard application for graphically viewing conditions on Mars recently experienced by the NASA InSight rover."),
                   helpText("The InSight rover was launched on May 5th, 2018 and landed on November 26th, 2018.",
                            helpText(" It was manufactured for NASA's Jet Propulsion Laboratory by Lockheed Martin and uses a 600 watt lithium ion battery maintained by the rover's solar cells."))
                   
                   # menuItem("Weather", tabName = "weather", icon = icon("globe")),
                   # menuItem("Pressure", tabName = "pressure", icon = icon("bars"))
                   ),
  dashboardBody(
    
    fluidRow(
      box(
        plotOutput("plot1"),
        h4("Day 87 corresponds to February 23rd"),
        align = "center",
        h2("Note: Mars weather for which Earth Days of the Sol year?"),
        dateRangeInput( "dateUse",label = "Dates:", 
                        end = Sys.Date() - 2, start = Sys.Date() - 9, 
                        separator = " to ", min = Sys.Date() - 9, 
                        max = Sys.Date() -2 , autoclose = TRUE)
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
        solidHeader = TRUE,
      radioButtons("AveragesPlotted",label = "Plot Averages?",
                   choices = list("Yes!", "No..."), inline = T),
      radioButtons("MinsPlotted",label = "Plot Minimum Temps?",
                   choices = list("Yes!", "No..."), inline = T),
      radioButtons("MaxsPlotted",label = "Plot Maximum Temps?",
                   choices = list("Yes!", "No..."), inline = T),
      status = "primary",
      align = "center",
      helpText("Temperatures are graphed by minimum (red), maximum (blue), and average (yellow)")
    ),
    box(HTML("<iframe src='https://mars.nasa.gov/embed/22126/' width='25%' scrolling='no' frameborder='0'></iframe>"), align = "center", collapsible = FALSE)

  )),
  
  sliderInput("myslider", "", min=minDay, max=maxDay, value=maxDay))




# server <- function(input, output, session) {
#   output$plot1 <- renderPlot({
#     print(p + theme_bw())
# 
#     })}


Sys.Date() - as.Date(x = "2019-02-23")

shinyApp(ui, server, options = list(height = 1080))

