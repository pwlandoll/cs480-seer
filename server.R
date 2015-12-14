library(googleVis)
library(plyr)
library(shiny)

load("colon.R")

# Exclude records with unknown CSSize values.
preprocessedData = subset(colon, cssize < 999)

shinyServer(function(input, output) {
  
  output$googleBarChart = renderGvis({
    # Make sure the input strings actually have values in them.
    if (is.character(input$graphX) && is.character(input$graphY) && is.character(input$aggregateFunction)) {
      # Concatenate strings to make an aggregation formula.
      formula = as.formula(paste(input$graphY, " ~ ", input$graphX))
      # Aggregate the data.
      dataAggregate = aggregate(formula, preprocessedData, input$aggregateFunction)
      # Display the data.
      gvisColumnChart(dataAggregate, input$graphX, input$graphY) 
    }
  })

  output$googlePieChart = renderGvis({
    if (is.character(input$var)) {
     dataCount = count(preprocessedData, vars = input$var)
     gvisPieChart(dataCount, labelvar = input$var, numvar = "freq")
    }
  })
  
})
