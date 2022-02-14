###############################################################################
# Script to create Shiny app
#
# Author: Calum McConville
# Created 2020-07-15
###############################################################################

library(shiny)
library(shiny)
library(tidyverse)
library(grattantheme)
library(plotly)

#Load data
data <- read_rds("raw_data/occ_education_aus.rds")
occs <- data %>% 
  filter(!is.na(occ_group)) %>% 
  pull(occ_group) %>% 
  unique()

# Define UI and server logic
source("ui.R")
source("server.R")

# Run the application 
shinyApp(ui = ui, server = server)
