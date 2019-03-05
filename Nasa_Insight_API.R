library(jsonlite)
library(ggplot2)
library(readxl)
library(jpeg)
library(grid)
library(png)

nasa_api <- "https://mars.nasa.gov/rss/api/?feed=weather&category=insight&feedtype=json"

insight <- fromJSON(nasa_api, flatten=TRUE)

insight$validity_checks <- NULL

minDay <- min(as.numeric(insight$sol_keys))

maxDay <- max(as.numeric(insight$sol_keys))

insight$sol_keys <- NULL

tempToF <- function(degreesC) {
  degreesF <- ((9/5*degreesC)+32)
  return(degreesF)
}

# tempToC <- function(degreesF) {
#   tryCatch(expr = (degreesC <- ((5/9*degreesF) - 32))
#            
#   )
#   
#   return(degreesC)
# }

# `$`(`$`(insight, `87`), `AT`)$`av`

# tempToF(degreesC =insight$`82`$AT$av[1])

countDays <- length(names(insight))

insightdata <- NULL

insightdata$x <- as.numeric(names(insight))


for (j in 1:4) {
  at <- NULL
  for (i in 1:countDays) {
    # message(paste0(j, ":", i))
    at2 <- insight[[i]][["AT"]][[j]]
    at <- c(at, at2)}
  
  varNames <- names(insight[[1]][["AT"]])
  eval(parse(text = paste0("insightdata$y",varNames[j],"<- at")))
  # insightdata$y <- at
}

insightdata <- as.data.frame(insightdata)

insightdataC <- insightdata

insightdataF <- as.data.frame(cbind(insightdata$x, 
                      tempToF(insightdata$yav),
                      tempToF(insightdata$yct),
                      tempToF(insightdata$ymn),
                      tempToF(insightdata$ymx)))

names(insightdataF) <- names(insightdataC)




avShow = TRUE
mnShow = TRUE
mxShow = TRUE

# imageParameters ----

z <- "logo.jpg"
img <- readJPEG("logo.jpg")
g <- rasterGrob(img, interpolate = T, gp = gpar(alpha = 0.5))

imgMin <- (minDay + maxDay)/2 - 1
imgMax <- (minDay + maxDay)/2 + 1


tempNeed = "C"

if (tempNeed == "F") {
  p <- ggplot(data = insightdataF)
} else {
  p <- ggplot(data = insightdataC)
}

# Graphing ----
p <- p + 
{if(avShow) geom_line(mapping = aes(x = x, y = yav), 
                      size = 2, color = "yellow", alpha = 0.75)} + 
{if(mnShow) geom_line(mapping = aes(x = x, y = ymn),
                      size = 2, color = "red", alpha = 0.75)} + 
{if(mxShow) geom_line(mapping = aes(x = x, y = ymx),
                      size = 2, color = "blue", alpha =0.75)} + 
  theme_minimal() + 
  annotation_custom(g, xmin=imgMin, xmax=imgMax, ymin=-50, ymax=-25)+ 
  xlab("Earth Day") +
  ylab("Temperature in degrees C") +
  ggtitle("Air Temperature") + 
  # scale_y_continuous(minor_breaks = seq(-20, 0, 1)) +
  # scale_x_continuous(minor_breaks = seq(80, 100, 1)) +
  theme(title =  element_text(hjust = 0),
        plot.title = element_text(hjust = 0.5),
        axis.title = element_text(face = "bold", size = 12),
        axis.text = element_text(size = 15, angle = 45, face = "bold" ),
        panel.background = element_rect(fill = "maroon"))

print(p)


# Json Output ----
write_json(insight,path = paste0("InsightOutput.", Sys.Date(),"-min,", minDay,"-max,",maxDay, ".json"))
