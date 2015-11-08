
shinyUI(fluidPage(theme = "bootstrap.css",
    titlePanel(strong("Camp Data Dashboard")),
    
    sidebarLayout(
        sidebarPanel(
            
            selectInput("dataset", "Choose a dataset:", 
                        choices = c("Full", "Reduced")),
            
            selectInput("camper", label = "Choose a camper", 
                        choices = c("All", unique(campdata$Name))
            ),
            br(),
            selectInput("x", label = "Select X Variable", 
                        choices = c(colnames(campdata)),
                        selected = "Day"
            ),
            
            selectInput("y", label = "Select Y Variable", 
                        choices = c(colnames(campdata)),
                        selected = "Daily_Total_Points_Earned"
            ),
           
            downloadButton('downloadData', 'Download Filtered Data')
        
        ),
        mainPanel(
            tabsetPanel(type = "tabs", 
                        tabPanel("Table", DT::dataTableOutput(outputId ="data_table")),
                        tabPanel("Summary",
                                 h4("Regression Model"),
                                 verbatimTextOutput("regression"),
                                 
                                 h4("Summary"),
                                 verbatimTextOutput("summary")),
                        
                        tabPanel("Plot",
                                 radioButtons("plot_type", "Select Plot Type:",
                                              c("point", "boxplot")),
                                 conditionalPanel(
                                     condition = "input.plot_type == 'point'", plotOutput("plot1")),
                                 conditionalPanel(
                                     condition = "input.plot_type == 'boxplot'", plotOutput("plot2"))
                                 
                                 
                        
                        
            )
        ))
    
    
)))

