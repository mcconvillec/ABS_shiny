###############################################################################
# Server Logic for Occupation dashboard
#
# Author: Calum McConville
# Created 2020-07-15
###############################################################################

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  output$occ_title <- renderText({
    paste0(
      "Education breakdown of '", input$occ_group, "' occupations (per cent of group)"
    )
  })
  
  
  output$plotted_occs <- renderPlot({ 
    
    
    
    rotate <- 90
    just   <- 0
    
    
    max <- data %>% 
      filter(occ_group == input$occ_group) %>% 
      pull(occ_total) %>% 
      max()
    
    if (nrow(data)==0) stop(paste0("There are no occupations for this group"))
    
    if (input$age == "Compare") {
      agecol <- c(
        "darkgoldenrod1",
        "darkorange",
        "darkorange3",
        "red",
        "darkred"
      )
    } 
    
    if (input$age != "Compare") {
      data <- data %>% filter(age == input$age)
      agecol <- case_when(
        input$age == "25-34"   ~ "darkgoldenrod1",
        input$age == "35-44"   ~ "darkorange",
        input$age == "45-54"   ~ "darkorange3",
        input$age == "55-64"   ~ "red",
        input$age == "Over 65" ~ "darkred"
      )
    }
    
    data <- 
      data %>% filter(occ_group == input$occ_group) 
    
    #Define top occ_number occupations to show
    top_occ <- 
      data %>% 
      group_by(occ) %>%
      summarise(occ_total = mean(occ_total))
    
    top_occ <- 
      top_occ[order(top_occ$occ_total, decreasing=TRUE), ]
    
    top_occ <- top_occ[1:input$occ_number, "occ"]
    
    #Filter for only those occ_number occupations with top number of employees
    data <- inner_join(data, top_occ, by="occ")
    
    data %>% 
      ggplot(aes(
        x = qual,
        y = pc,
        fill = age,
        alpha = observation_weight)) +
      geom_col(position = "dodge") +
      facet_grid(reorder(occ, -occ_total) ~ sex, switch = "y") +
      scale_x_continuous() + 
      scale_x_discrete(position = "top") +
      scale_alpha_continuous(range = c(.3, 1)) +
      scale_fill_manual(values = agecol) + 
      theme(strip.placement = "outside",
            strip.text.y = element_text(size = 14, angle = 180, hjust = 1),
            strip.text.x = element_text(size = 14),
            panel.spacing.x = unit(10, "mm"),
            panel.spacing.y = unit(3, "mm"),
            axis.text = element_text(size = 14),
            axis.text.x = element_text(angle = rotate, hjust = just),
            legend.position = "top",
            legend.text = element_text(size = 14),
            legend.key.size = unit(10, "mm"),
            legend.title = element_text(size = 14)) +
      labs(fill = "Age",
           x = "",
           y = "") +
      guides(alpha = FALSE)
  })
  
})

