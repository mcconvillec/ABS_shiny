###############################################################################
# UI for Occupation dashboard
#
# Author: Calum McConville
# Created 2020-07-15
###############################################################################

#Load data

data <- read_rds("raw_data/occ_education_aus.rds")
occs <- data %>% 
  filter(!is.na(occ_group)) %>% 
  pull(occ_group) %>% 
  unique()

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Educational make-up of jobs in Australia"),
  
  p(paste("The chart below uses ABS Census data to show the education levels of 25-64 year-olds",
          "who work in specific jobs. Occupations are sorted from most to least workers.")),
  
  p("Australian citizens who are not presently studying."),
  
  p("Greater opaqueness means more people in the occupation are within that particular age/gender group."),
  
  # Select
  fluidRow(
    column(3,
           selectInput("occ_group",
                       "Occupation group",
                       choices = occs, 
                       selected = "Managers")),
    
    column(3,
           selectInput("age",
                       "Age",
                       choices = c("25-34",
                                   "35-44",
                                   "45-54",
                                   "55-64",
                                   "Compare"),
                       selected = "Compare")),
    
    column(6,  
           sliderInput("occ_number", 
                       "Occupations to show",
                       min = 5, max = 10, value = 10))
    
  ),
  
  h2(textOutput("occ_title")),
  plotOutput("plotted_occs", height = "3600px"),
  
  
  # A bit of JS to record the window size
  tags$head(tags$script('
                        var width = 0;
                        $(document).on("shiny:connected", function(e) {
                          width = window.innerWidth;
                          Shiny.onInputChange("width", width);
                        });
                        $(window).resize(function(e) {
                          width = window.innerWidth;
                          Shiny.onInputChange("width", width);
                        });
                        '))
))