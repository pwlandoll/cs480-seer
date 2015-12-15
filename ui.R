library(shiny)
library(googleVis)

standardChoices = c("Age of Diagnosis" = "agedx",
                    "Year of Birth" = "yrbrth",
                    "Sequence Number" = "seqnum",
                    "Year of Diagnosis" = "yrdx",
                    "Tumor Size" = "cssize",
                    "Survival (Months)" = "surv",
                    "Sex" = "sex",
                    "Cancer Registry" = "reg",
                    "Race" = "race",
                    "Stage" = "stage")

shinyUI(fluidPage(
  
  # Application title
  titlePanel("SEER Cancer Data"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("graphType", "Choose a graph type",
                  choices = c("Bar Graph" = "bar",
                              "Pie Graph" = "pie",
                              "Motion Bubble Chart" = "motion",
                              "Map" = "map")),
      conditionalPanel("input.graphType == 'bar'",
                       # X axis selection for bar chart. Can be any type.
                       selectInput("graphX", "Graph X Axis",
                                   choices = c("Year of Diagnosis" = "yrdx",
                                               "Age of Diagnosis" = "agedx",
                                               "Sex" = "sex",
                                               "Cancer Registry" = "reg",
                                               "Cancer Sequence Number" = "seqnum",
                                               "Race" = "race",
                                               "Stage" = "stage")),
                       # Y axis selection for bar chart. Needs to be numeric 
                       # data that makes sense (eg. no yrdx - average of years?).
                       selectInput("graphY", "Graph Y Axis",
                                   choices = c("Age of Diagnosis" = "agedx",
                                               "Tumor Size" = "cssize")),
                       # The function that will be passed in to aggregate.
                       selectInput("aggregateFunction", "Aggregate Function",
                                   choices = c("Mean" = "mean",
                                               "Count" = "length",
                                               "Standard Deviation" = "sd"))),
      conditionalPanel("input.graphType == 'pie'",
                       selectInput("pieVar", "Variable",
                                   choices = standardChoices)),
      conditionalPanel("input.graphType == 'motion'",
                       selectInput("motionID", "ID Variable",
                                   choices = standardChoices),
                       selectInput("motionSize", "Size Variable",
                                   choices = standardChoices),
                       selectInput("motionTime", "Time Variable",
                                   choices = c("Year of Diagnosis" = "yrdx",
                                               "Year of Birth" = "yrbrth")),
                       selectInput("motionX", "Graph X Axis",
                                   choices = standardChoices),
                       selectInput("motionY", "Graph Y Axis",
                                   choices = c("Age of Diagnosis" = "agedx",
                                               "Tumor Size" = "cssize")),
                       selectInput("motionAggregateFunction", "Aggregate Function",
                                   choices = c("Mean" = "mean",
                                               "Count" = "length",
                                               "Standard Deviation" = "sd"))),

      conditionalPanel("input.graphType == 'map'",
                       selectInput("mapVar", "Variable",
                                   choices = c("Age of Diagnosis" = "agedx",
                                               "Year of Birth" = "yrbrth",
                                               "Sequence Number" = "seqnum",
                                               "Year of Diagnosis" = "yrdx",
                                               "Tumor Size" = "cssize",
                                               "Survival (Months)" = "surv")),
                       selectInput("mapAggregate", "Aggregate Function",
                                   choices = c("Mean" = "mean",
                                               "Count" = "length",
                                               "Standard Deviation" = "sd")))
    ),

    mainPanel(
      # Google Vis bar chart.
      conditionalPanel("input.graphType == 'bar'",
                       htmlOutput("googleBarChart")),
      conditionalPanel("input.graphType == 'pie'",
                       htmlOutput("googlePieChart")),
      conditionalPanel("input.graphType == 'motion'",
                       htmlOutput("googleMotionChart")),
      conditionalPanel("input.graphType == 'map'",
                       htmlOutput("googleMapChart")),
      width = 8
    )
  )
))
