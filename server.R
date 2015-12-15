library(googleVis)
library(plyr)
library(shiny)

load("colon.R")

# Exclude records with unknown CSSize values.
preprocessedData = subset(colon, cssize < 999)

# Convert reg to google recognized names.
preprocessedData$reg = revalue(preprocessedData$reg, c("aG" = "Georgia",
                       "AK" = "Alaska",
                       "CA" = "California",
                       "CT" = "Connecticut",
                       "dM" = "Iowa",
                       "GA" = "Georgia",
                       "HI" = "Hawaii",
                       "IA" = "Iowa",
                       "KY" = "Kentucky",
                       "la" = "California",
                       "LA" = "California",
                       "NJ" = "New Jersey",
                       "NM" = "New Mexico",
                       "rG" = "Georgia",
                       "sf" = "California",
                       "sj" = "California",
                       "sW" = "Washington",
                       "UT" = "Utah"))

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
    # Check for strings
    if (is.character(input$pieVar)) {
      # Count instances of the variable
      dataCount = count(preprocessedData, vars = input$pieVar)
      # Convert numeric data to strings to make gVis happy
      dataCount[,c(input$pieVar)] = as.character(dataCount[,c(input$pieVar)])
      # Manually specifying pie chart height for readability
      gvisPieChart(dataCount, labelvar = input$pieVar, numvar = "freq",
                   options = list(height = 500))
    }
  })

  output$googleMotionChart = renderGvis({
    # Check for strings
    if (is.character(input$motionX) && is.character(input$motionY) && is.character(input$motionSize) && is.character(input$motionTime) && is.character(input$motionID)) {
      # Formula for selecting multiple variables, taking the mean of some
      formula = as.formula(paste("cbind(", input$motionSize, ", ", input$motionX, ", ", input$motionY, ") ~ ", input$motionID, " + ", input$motionTime))
      dataAggregate = aggregate(formula, data = preprocessedData, input$motionAggregateFunction)
      gvisMotionChart(dataAggregate, idvar = input$motionID, timevar = input$motionTime, xvar = input$motionX, yvar = input$motionY, sizevar = input$motionSize,
                      options = list(height = 500))
    }
  })
  
  output$googleMapChart = renderGvis({
    # Check for strings
    if (is.character(input$mapVar) && is.character(input$mapAggregate)) {
      # Always aggregate input variable against cancer registry
      formula = as.formula(paste(input$mapVar, " ~ reg"))
      dataAggregate = aggregate(formula, preprocessedData, input$mapAggregate)
      gvisGeoMap(dataAggregate, locationvar = "reg", numvar = input$mapVar,
                 options = list(region = "US",
                                resolution ="regions",
                                height = 400,
                                width = 600))
    }
  })
  
})
