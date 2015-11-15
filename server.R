
library(shiny)
library(DT)
library(ggplot2)
library(dplyr)


options(shiny.error=browser)

#source("read_clean_campdata.R", local = T)
#options(shiny.error=browser)
#campdata
#reduced
# Define server logic 
shinyServer(function(input, output) {
    campdata <- read.csv("dataset1.csv", header = TRUE)
    campdata <- campdata[, -1]
    leave_out <- c( 15101,15103, 15104, 15108, 15111, 15112, 15204,15205, 15209, 15210,  15212,
                    15301, 15307, 15308,15309, 15310, 15403, 15405,15503, 15504,15611,
                    15701, 15707, 15708, 15709, 15712)
    
    reduced <- filter(campdata, ! Name %in% leave_out)
             
    # Return the requested dataset
    datasetInput <- reactive({
        switch(input$dataset,
               "Full" = campdata[, input$show_cols],
               "Reduced" = reduced[, input$show_cols])
    })
    
    # Generate an HTML table view of the data
    output$data_table <- DT::renderDataTable({
        datasetInput()
        }, filter = 'top', rownames = FALSE)
    
    # download the filtered data
    output$downloadData = downloadHandler(filename = 
                                              paste('campdata-filtered', Sys.Date(), '.csv', sep = ''),
                                          content = function(file) {
                                              s = input$data_table_rows_all
                                              data <- datasetInput()
                                              data <- data[s,]
                                              write.csv(data, file)
                                          })
    
    ## Code for regression model
    runRegression <- reactive({
        
        regmod <- summary(lm(as.formula(paste(input$y," ~ ",paste(input$x,collapse="+"))),
                   datasetInput()))
        regmod

    })
    
    
    ## Regression output
    output$regression <- renderPrint({
        runRegression()
        
        
    })
    
    ## Plot residuals
    output$residplot <- renderPlot({
        data <- as.data.frame(datasetInput())
        regmod <- summary(lm(as.formula(paste(input$y," ~ ",paste(input$x,collapse="+"))),
                             datasetInput()))
        data <- data[, input$y]
        if(input$residcheck){
        plot(data, regmod$residuals, xlab = input$y, ylab = 'Residuals')
            abline(0, 0)                  # the horizon
        }
        
    })
    
    # Generate a summary of the data
    output$summary <- renderPrint({
        data <- datasetInput()
        summary(data[, -c(1,2,3,4,5)])
        
    })

    ## Generate Plots using x and y inputs from UI
    output$plot1 <- renderPlot({
        data <- as.data.frame(datasetInput())
        ggplot(data, aes_string(x = input$x, y = input$y)) +
               geom_point(aes(color = factor(Name))) + 
               geom_smooth(method = lm) 
    })
    
    ## Boxplot
    output$plot2 <- renderPlot({
        data <- as.data.frame(datasetInput())

        ggplot(data = data, aes_string(x = input$x, y = input$y)) +
               geom_point(aes(color = factor(Name))) + facet_grid(. ~ Bunk) + 
               geom_boxplot(aes(color = factor(Bunk)),
                                alpha = 0.3, outlier.colour = 'red', outlier.size = 2.5)
    })
    
    
    ## Lineplot
    output$plot3 <- renderPlot({
        data <- as.data.frame(datasetInput())
        ggplot(data = data, aes_string(x = input$x, y = input$y)) +
               geom_line(aes(group = Name, color = factor(Name))) +
               geom_point(aes(color = factor(Name)))
    })
    
    
    ## Identify row of outlier
    output$position <- DT::renderDataTable({
        nearPoints(datasetInput(), input$plot_click)
        brushedPoints(datasetInput(), input$plot_brush)
        
    })
    
    output$position2 <- DT::renderDataTable({
        nearPoints(datasetInput(), input$plot_click)
        brushedPoints(datasetInput(), input$plot_brush)
            
    })
    
    output$position3 <- DT::renderDataTable({
        nearPoints(datasetInput(), input$plot_click)
        brushedPoints(datasetInput(), input$plot_brush)
        
    })
    
    


})