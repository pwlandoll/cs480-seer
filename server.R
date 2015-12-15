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
      gvisColumnChart(dataAggregate, input$graphX, input$graphY,
                      options = list(title = paste(input$graphX, " VS ", input$graphY)))
    }
  })

  output$googlePieChart = renderGvis({
    if (is.character(input$var)) {
     dataCount = count(preprocessedData, vars = input$var)
     dataCount[,c(input$var)] = as.character(dataCount[,c(input$var)])
     gvisPieChart(dataCount, labelvar = input$var, numvar = "freq",
                  options = list(height = 500))
    }
  })

#   output$googleMotionChart = renderGvis({dataCount[,c(input$var)] = as.character(dataCount[,c(input$var)])
#     if (is.character(input$motionX) && is.character(input$motionY) && is.character(input$motionSize) && is.character(input$motionTime)) {
#       formula = as.formula(paste(input$one, " ~ ", input$two))
#       dataAggregate = aggregate(formula, preprocessedData, input$aggregateFunction)
#       gvisMotionChart(dataAggregate, idvar = , timevar = , xvar = , yvar = , sizevar = , colorvar = ,
#                       options = list())
#     }
#   })
  
})
