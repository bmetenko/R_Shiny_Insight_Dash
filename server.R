library(shiny)

# source("helpers.R")

library(ggplot2)
library(jsonlite)


source("Package_Check.R")
source("Nasa_Insight_API.R")





server <- function(input, output, session) {
  output$plot1 <- renderPlot({
    print(p)
    }
  )
}
