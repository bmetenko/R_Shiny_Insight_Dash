required_pkg = c("shiny", "ggplot2", "dplyr", "httr", "jsonlite", "shinydashboard")

packages_to_add = required_pkg[!(required_pkg %in% installed.packages()[, 1])]

if (length(packages_to_add) > 0) {
  install.packages(packages_to_add, repos = "https://cran.rstudio.com")
}

# runGitHub("R_Shiny_Insight_Dash","bmetenko")
