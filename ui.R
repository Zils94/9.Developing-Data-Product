#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinydashboard)
library(DT)
df <- read.csv("./Data/winequality-red.csv")
# Define UI for application that draws a histogram
shinyUI(
  dashboardPage(skin = 'purple',
                dashboardHeader(title = 'Scoring Wines'),
            dashboardSidebar(
              sidebarMenu(
              menuItem("Data", tabName = "data", icon = icon("database")),
              menuItem("Quality", tabName = "manipulate", icon = icon("cog"))
            )),
            
            dashboardBody(
              
              tabItems(
                tabItem(tabName = "data",
                        
                        # Boxes need to be put in a row (or column)
                        
                        fluidRow(box(title = "Explore",width = 6,
                                     
                                selectizeInput('feature','Select features to display', choices = colnames(df), multiple = TRUE),
                                selectizeInput('filters', 'Select filters to display', choices = colnames(df), multiple = TRUE,options = list(maxItems = 3))),
                                box(title = "Help", width = 6,
                                    textOutput("Help1"))),
                                # Put informative box here
                        fluidRow(        
                               valueBoxOutput("Rows"),
                               valueBoxOutput("Col"),
                               valueBoxOutput("Target")
                                
                                #

                        ),
                        fluidRow(
                            column(4,
                                    selectizeInput("filt1","Filter 1",choices = "", multiple = TRUE)),
                            column(4,
                                    selectizeInput("filt2","Filter 2",choices = "", multiple = TRUE)),
                            column(4,
                                    selectizeInput("filt3","Filter 3",choices = "", multiple = TRUE))
                        ),
                        fluidRow(
                          box(title = "View",width = 12,
                              
                              # Output : Data file ---
                              
                              dataTableOutput("contents"))
                        )
                        ),
                
                # Second Tab "2. Manipulate"
                
                tabItem(tabName = "manipulate",
                        fluidRow(box(title = "Parameters",
                                     textOutput("Help2"),
                                     sliderInput("facidity","Fixed Acidity",min = min(df$fixed.acidity), 
                                                 max = max(df$fixed.acidity),value = median(df$fixed.acidity)),
                                     sliderInput("resugar","Residual Sugar",min = min(df$residual.sugar), 
                                                 max = max(df$residual.sugar),value = median(df$residual.sugar)),
                                     sliderInput("pH","pH",min = min(df$pH), 
                                                 max = max(df$pH),value = median(df$pH)),
                                     sliderInput("alcohol","Alcohol",min = min(df$alcohol), 
                                                 max = max(df$alcohol),value = median(df$alcohol)),
                                     textOutput("Quality")
                                     ))
                        )
              )
            )
            )
)
                

