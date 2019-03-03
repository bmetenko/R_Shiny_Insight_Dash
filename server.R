library(shiny)

source("helpers.R")

library(ggplot2)
library(jsonlite)



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

# at1 <- NULL
# 
# for (i in 1:6) {
#   at1.1 <- insight[[i]][1][["AT"]][["mn"]]
#   at1 <- c(at1, at1.1)}
# 
# insightdata$ymin <- at2


minDay <- min(as.numeric(insight$sol_keys))

maxDay <- max(as.numeric(insight$sol_keys))

server <- function(input, output, session) {
  output$plot1 <- renderPlot({
    p <- ggplot() + geom_line(mapping = aes(x = insightdata$x, y = insightdata$y))
    print(p)
    }
  )
}
