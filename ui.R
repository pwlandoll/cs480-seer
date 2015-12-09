library(shiny)

shinyUI(fluidPage(
  
  # Application title
  titlePanel("SEER Cancer Data"),
  
  # Sidebar with a slider input for the number of bins
  sidebarLayout(
    sidebarPanel(      
      selectInput("dataSelectX", label = "X Axis", choices = c()),
      selectInput("dataSelectY", label = "Y Axis", choices = c())
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      htmlOutput("gvisPlot")
    )
  )
))
