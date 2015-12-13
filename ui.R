library(shiny)

dataset <- source('algebra_df.R', local=TRUE)

shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel("Common Core Algebra Regents"),
  
  sidebarPanel(
    selectInput('test_name', 'Test Date', unique(algebra_df$test_name))),#,
    #selectInput('concept', 'Conceptual Category', unique(algebra_df$concept))),

  mainPanel(
    plotOutput("distPlot"))
  
))
