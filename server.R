#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinydashboard)
library(DT)

df <- read.csv("./Data/winequality-red.csv")
# Define server logic required to draw a histogram
shinyServer(function(input, output,session) {
  
  filtered <- eventReactive({
    input$feature
  },{
    if(is.null(input$feature) || input$feature == "" || length(input$feature)<2)
      df else
        df[,colnames(df) %in% input$feature]
  }) 
  
observeEvent(input$feature,{
  updateSelectizeInput(session, inputId = "filters", choices = colnames(df[,colnames(df)%in%input$feature]))
})

observeEvent(input$filters,{
  if(is.null(input$filters) || input$filters == ""){
    updateSelectizeInput(session, inputId = "filt1", choices = "")
    updateSelectizeInput(session, inputId = "filt2", choices = "")
    updateSelectizeInput(session, inputId = "filt3", choices = "")
  }else if(length(input$filters)==1){
    updateSelectizeInput(session, inputId = "filt1", choices = sort(unique(df[,input$filters[1]])))
    updateSelectizeInput(session, inputId = "filt2", choices = "")
    updateSelectizeInput(session, inputId = "filt3", choices = "")
  }else if(length(input$filters)==2){
    updateSelectizeInput(session, inputId = "filt1", choices = sort(unique(df[,input$filters[1]])))
    updateSelectizeInput(session, inputId = "filt2", choices = sort(unique(df[,input$filters[2]])))
    updateSelectizeInput(session, inputId = "filt3", choices = "")
  }else{
    updateSelectizeInput(session, inputId = "filt1", choices = sort(unique(df[,input$filters[1]])))
    updateSelectizeInput(session, inputId = "filt2", choices = sort(unique(df[,input$filters[2]])))
    updateSelectizeInput(session, inputId = "filt3", choices = sort(unique(df[,input$filters[3]])))
  }
    
})
  
  
  output$contents <- renderDataTable({
    
    if(is.null(input$feature)||input$feature == ""){
      df
    }else{
    df <- filtered()
    
    if(length(input$filt1) != 0){
      df <- df[df[,input$filters[1]] %in% input$filt1,]
    }
    
    if(length(input$filt2) != 0){
      df <- df[df[,input$filters[2]] %in% input$filt2,]
    }
    
    if(length(input$filt3) != 0){
      df <- df[df[,input$filters[3]] %in% input$filt3,]
    }
    
    df}
  })
  
  output$Help1 <- renderText("Here you can have a quick look at the data and play with filter. Click on the Quality tab to estimate the quality of your wine. Try to find a 7 !")
  
  output$Rows<- renderValueBox({valueBox(nrow(df),h2("Rows"),icon = icon("align-justify"))})
  output$Col<- renderValueBox({valueBox(ncol(df),h2("Features"),icon = icon("align-justify"))})
  output$Target<- renderValueBox({valueBox(1,h2("Target"),icon = icon("align-justify"))})
  
  
  output$Help2 <- renderText({"You can change those parameters to estimate the quality of the wine"})
  output$Quality <- renderText({
    
    fit <- lm(quality ~fixed.acidity + residual.sugar + pH + alcohol, data = df)
    pred <- predict(fit, newdata = data.frame(fixed.acidity = input$facidity,
                                              residual.sugar = input$resugar,
                                              pH = input$pH,
                                              alcohol = input$alcohol))
    if(pred > 7){
      paste("Woah that is a great wine, quality ",round(pred,digits = 1))
    }else if(pred <3){
      paste("Ugh don't drink that ! Quality ",round(pred, digits = 1))
    }else{
      paste("That's an average wine, quality ",round(pred,digits = 1))
    }
    
  })
})
