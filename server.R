library(shiny)
library(googleVis)

load("allcancers.RData")
cancerNames = names(cancer)

shinyServer(function(input, output, session) {
  
  # Dynamic loading of the data axes.
  updateSelectInput(session, "dataSelectX", choices = cancerNames, selected = cancerNames[2])
  updateSelectInput(session, "dataSelectY", choices = cancerNames, selected = cancerNames[3])
  
  # Track changes to the selected x and y columns.
  reactX <- reactive({
    input$dataSelectX
  })
  
  reactY <- reactive({
    input$dataSelectY
  })
  
  # Output a GoogleVIS plot to the client.
  output$gvisPlot <- renderGvis({
    gvisScatterChart(cancer[,c(reactX(), reactY())])
  })
  
})
