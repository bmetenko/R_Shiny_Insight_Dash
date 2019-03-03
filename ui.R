library(shiny)
library(shinydashboard)

## API Calls ----
nasa_api <- "https://mars.nasa.gov/rss/api/?feed=weather&category=insight&feedtype=json"

insight <- fromJSON(nasa_api, flatten=TRUE)

insight$validity_checks <- NULL

countDays <- length(names(insight))

insightdata <- NULL

insightdata$x <- as.numeric(names(insight)[-countDays])

at <- NULL

for (i in 1:7) {
  at2 <- insight[[i]][1][["AT"]][["mx"]]
  at <- c(at, at2)}

insightdata$y <- at

minDay <- min(as.numeric(insight$sol_keys))

maxDay <- max(as.numeric(insight$sol_keys))


# UI Calls ----
ui <- dashboardPage(skin = "red",
  dashboardHeader(title = "Mars Insight Weather Dashboard"),
  dashboardSidebar(collapsed = FALSE,
                   h3(" Mars weather for which Earth Days of the Sol year?"),
                   dateRangeInput( "dateUse",label = "Dates:", 
                                   end = Sys.Date(), start = Sys.Date() - 4, 
                                   separator = " to ", min = Sys.Date() -4, 
                                   max = Sys.Date(), autoclose = TRUE)),
  dashboardBody(
    plotOutput("plot1"),
    fluidRow(
    box(
      title = "Current Time Delay between the Earth and Mars",
      status = "warning", 
      solidHeader = T, 
      collapsible = TRUE,
      collapsed = FALSE,
      # width = 10,
      "3 to 4 days"
    ),
    box(
      img(src = "www/test.png")
    ),
    box(),
    box()
  )),
  
  sliderInput("myslider", "", min=minDay, max=maxDay, value=maxDay))




server <- function(input, output, session) {
  output$plot1 <- renderPlot({
    p <- ggplot() + 
      geom_line(mapping = aes(x = insightdata$x, y = insightdata$y), size = 2, color = "red") +
      theme_gray() + 
      ylab("Earth Day") +
      xlab("Temperature in degrees C") +
      ggtitle("Air Temperature") + 
      theme(title =  element_text(hjust = 0),
            plot.title = element_text(hjust = 0.5))
    print(p)
})}

shinyApp(ui, server)

