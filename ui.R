library(shiny)
library(googleVis)

shinyUI(fluidPage(
  
  # Application title
  titlePanel("SEER Cancer Data"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("graphType", "Choose a graph type",
                  choices = c("Bar Graph" = "bar",
                              "Pie Graph" = "pie")),
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
                       selectInput("var", "Variable",
                                   choices = c("Age of Diagnosis" = "agedx",
                                               "Year of Birth" = "yrbrth",
                                               "Sequence Number" = "seqnum",
                                               "Year of Diagnosis" = "yrdx",
                                               "Tumor Size" = "cssize",
                                               "Survival (Months)" = "surv",
                                               ###
                                               "Sex" = "sex",
                                               "Cancer Registry" = "reg",
                                               "Race" = "race",
                                               "Stage" = "stage")))
    ),
    
    mainPanel(
      # Google Vis bar chart.
      conditionalPanel("input.graphType == 'bar'",
                       htmlOutput("googleBarChart")),
      conditionalPanel("input.graphType == 'pie'",
                       htmlOutput("googlePieChart"))
    )
  )
))
