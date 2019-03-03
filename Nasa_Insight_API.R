library(jsonlite)

nasa_api <- "https://mars.nasa.gov/rss/api/?feed=weather&category=insight&feedtype=json"

insight <- fromJSON(nasa_api, flatten=TRUE)

insight$validity_checks <- NULL

minDay <- min(as.numeric(insight$sol_keys))

maxDay <- max(as.numeric(insight$sol_keys))


tempToF <- function(degreesC) {
  degreesF <- ((9/5*degreesC)+32)
  return(degreesF)
}
tempToC <- function(degreesF) {
  tryCatch(expr = (degreesC <- ((5/9*degreesF) - 32))
           
  )
  
  return(degreesC)
}

`$`(`$`(insight, `87`), `AT`)$`av`

# tempToF(degreesC =insight$`82`$AT$av[1])


write_json(insight,path = paste0("InsightOutput.", Sys.Date(),"-min,", minDay,"-max,",maxDay, ".json"))
