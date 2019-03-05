library(shiny)

# source("helpers.R")

library(ggplot2)
library(jsonlite)


source("Package_Check.R")
source("Nasa_Insight_API.R")

server <- function(input, output, session) {
  output$plot1 <- renderPlot({
    message("Selected = ", input$radio1)
    message("S2 = ", input$dateUse[1], " and ", input$dateUse[2])
    tempNeed <- input$radio1
    
    dstrt <- (as.Date(input$dateUse[1]) - as.Date("2019-02-23"))[[1]] + 87
    dndng <- (as.Date(input$dateUse[2]) - as.Date("2019-02-23"))[[1]] + 87
    
    
    
    st1 <- insightdata$x[[1]]
      end <- insightdata$x[[length(insightdata$x)]]
    
    var1 <- dstrt - st1
    var2 <- dndng - st1
      
    if (tempNeed == "F") {
      p <- ggplot(data = insightdataF[(var1:var2),])
      y1min = -150
      y1max = -50
    } else {
      p <- ggplot(data = insightdataC[(var1:var2),])
      y1min = -50
      y1max = -100
    }
    
    avShow <- input$AveragesPlotted
    mnShow <- input$MinsPlotted
    mxShow <- input$MaxsPlotted
    
    # Graphing ----
    p <- p + 
    annotation_custom(g, xmin=imgMin, xmax=imgMax, ymin= y1min, ymax= y1max)+
    {if(avShow == "Yes!") geom_line(mapping = aes(x = x, y = yav), 
                          size = 2, color = "yellow", alpha = 0.75)} + 
    {if(mnShow == "Yes!") geom_line(mapping = aes(x = x, y = ymn),
                          size = 2, color = "red", alpha = 0.75)} + 
    {if(mxShow == "Yes!") geom_line(mapping = aes(x = x, y = ymx),
                            size = 2, color = "blue", alpha =0.75)} + 
      theme_minimal() + 
      xlab("Earth Day") +
      ylab("Temperature in degrees chosen") +
      ggtitle("Air Temperature") + 
      # scale_y_continuous(minor_breaks = seq(-20, 0, 1)) +
      # scale_x_continuous(minor_breaks = seq(80, 100, 1)) +
      theme(title =  element_text(hjust = 0),
            plot.title = element_text(hjust = 0.5),
            axis.title = element_text(face = "bold", size = 12),
            axis.text = element_text(size = 15, 
                                     angle = 45, face = "bold" ),
            panel.background = element_rect(fill = "maroon"))
    
    print(p)
    }
  )
}
