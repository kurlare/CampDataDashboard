
library(shiny)
library(DT)
library(ggplot2)


source("read_clean_campdata.R")

#Plot type selection
plotType <- function(x, type) {
    switch(type,
           D = hist(x),
           B = barplot(x),
           C = pie(x))
}

# Define server logic 
shinyServer(function(input, output) {
    
    # Return the requested dataset
    datasetInput <- reactive({
        switch(input$dataset,
               "Full" = campdata,
               "Reduced" = reduced)
    })
    

    
    runRegression <- reactive({
        summary(lm(as.formula(paste(input$y," ~ ",paste(input$x,collapse="+"))),
                   datasetInput()))
    })
   
    ## Generate Plot using x and y inputs from UI
    output$plot1 <- renderPlot({
        data <- as.data.frame(datasetInput())
        ggplot(data, aes_string(x = input$x, y = input$y)) +
            geom_point(aes(color = Name)) + 
            geom_smooth(method = lm) 
    })
    
    output$plot2 <- renderPlot({
        data <- as.data.frame(datasetInput())
        #data$Bunk <- as.factor(data$Bunk)
        ggplot(data = data, aes_string(x = input$x, y = input$y, color = factor(data$Bunk))) +
            #geom_boxplot(outlier.colour = 'red', outlier.size = 2.5) + 
            #geom_point(fill = data$Bunk, alpha = 0.3)
        geom_point() + facet_grid(. ~ Bunk) + 
            geom_boxplot(alpha = 0.3, outlier.colour = 'red', outlier.size = 2.5)
    })
    
    
    # Generate a summary of the data
    output$summary <- renderPrint({
        data <- datasetInput()
        summary(data[, -c(1,2,3,4,5)])
        
    })
    
    output$regression <- renderPrint({
        runRegression()
        
    })
    
    # Generate an HTML table view of the data
    output$data_table <- DT::renderDataTable(datasetInput(), filter = "bottom", 
                                             class = 'cell-border stripe')
    
    # download the filtered data
    output$downloadData = downloadHandler(filename = 
        paste('campdata-filtered', Sys.Date(), '.csv', sep = ''),
        content = function(file) {
        s = input$data_table_rows_all
        data <- datasetInput()
        data <- data[s,]
        write.csv(data, file)
    })
    
        
    

    
})