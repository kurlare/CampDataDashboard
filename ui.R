

shinyUI(fluidPage(theme = "bootstrap.css",
                  titlePanel(strong("Camp Data Dashboard")),
                  
                  sidebarLayout(
                      sidebarPanel(
                          
                          selectInput("dataset", "Choose a dataset:", 
                                      choices = c("Full", "Reduced")
                          ),
                          
                          #selectInput("camper", label = "Choose a camper:", 
                                     # choices = c("All", unique(campdata$Name))
                         # ),
                          
                          selectInput("x", label = "Select X Variable:", 
                                      choices = c(colnames(campdata)),
                                      selected = "Day"
                          ),
                          
                          selectInput("y", label = "Select Y Variable:", 
                                      choices = c(colnames(campdata)),
                                      selected = "Daily_Total_Points_Earned"
                          ),
                         
                          checkboxGroupInput('show_cols', 'Display Columns:',
                                                                  names(campdata), 
                                                                  selected = names(campdata)
                                                                  
                          ),

                          
                          downloadButton('downloadData', 'Download Filtered Data')
                          
                      ),
                      mainPanel(
                          tabsetPanel(type = "tabs", 
                                      tabPanel("Table", 
                                               
                                               dataTableOutput('data_table')),
                                      
                                      tabPanel("Plot",
                                               radioButtons("plot_type", "Select Plot Type:",
                                                            c("point", "boxplot", "line"),
                                                            inline = TRUE),
                                               #actionButton("move_filtered", "Send Filtered Data to Main Table"),
                                               conditionalPanel(
                                                   condition = "input.plot_type == 'point'", 
                                                   plotOutput("plot1",
                                                              click = "plot_click",
                                                              brush = "plot_brush"),
                                                   dataTableOutput('position')),
                                               conditionalPanel(
                                                   condition = "input.plot_type == 'boxplot'",
                                                   plotOutput("plot2",
                                                              click = "plot_click",
                                                              brush = "plot_brush"),
                                                   dataTableOutput('position2')),
                                               conditionalPanel(
                                                   condition = "input.plot_type == 'line'",
                                                   plotOutput("plot3",
                                                              click = "plot_click",
                                                              brush = "plot_brush"),
                                                   dataTableOutput('position3')
                                               )
                                               
                                      ),
                                      
                                      tabPanel("Model",
                                               checkboxInput("residcheck", "Show Residual Plot", FALSE),
                                               h4("Regression Model"),
                                               verbatimTextOutput("regression"),
                                               plotOutput('residplot'),
                                               h4("Summary"),
                                               verbatimTextOutput("summary"))
                                      

                          ))
                      
                      
                  )))