library(shiny)
library(ggplot2)

shinyServer(function(input, output, session) {
  
  getData <- source('algebra_df.R', local=TRUE)
  
  dataset <- reactive({ 
    validate(
      need(input$test_name != "", "Please select a test...")
    )
    subset(algebra_df, algebra_df$test_name == input$test_name)
    #algebra_df
  })
  
  output$distPlot <- renderPlot({
    ggplot(data=dataset(), aes(concept, fill=domain)) + 
      geom_histogram() +
      #facet_wrap(~ test_name) +
      xlab("Concept") +
      ylab("Frequency") +
      ggtitle("Concept Breakdown") +
      theme(axis.text.x = element_text(angle = 45, hjust = 1))
  })
  
})
