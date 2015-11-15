

options(shiny.error=browser)

shinyUI(fluidPage(theme = "bootstrap.css",
                  titlePanel(strong("Camp Data Dashboard")),
                  
                  sidebarLayout(
                      sidebarPanel(
                          helpText("Note: Reactive calculations are done under",
                                   "the 'model' tab.  The coefficients of a linear",
                                   "model will change based on your selection",
                                   "for the X and Y variables."),
                          
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
                          tags$style(type="text/css",
                                           ".shiny-output-error { visibility: hidden; }",
                                           ".shiny-output-error:before { visibility: hidden; }"
                      ),
                          tabsetPanel(type = "tabs", 
                                      tabPanel("Table", 
                                               
                                               DT::dataTableOutput('data_table')),
                                      
                                      tabPanel("Plot",
                                               radioButtons("plot_type", "Select Plot Type:",
                                                            c("point", "boxplot", "line"),
                                                            inline = TRUE),
                                               #actionButton("move_filtered", "Send Filtered Data to Main Table"),
                                               conditionalPanel(
                                                   condition = "input.plot_type == 'point'", 
                                                   plotOutput("plot1",
                                                              brush = "plot_brush"),
                                                   DT::dataTableOutput('position')),
                                               conditionalPanel(
                                                   condition = "input.plot_type == 'boxplot'",
                                                   plotOutput("plot2",
                                                              brush = "plot_brush"),
                                                   DT::dataTableOutput('position2')),
                                               conditionalPanel(
                                                   condition = "input.plot_type == 'line'",
                                                   plotOutput("plot3",
                                                              brush = "plot_brush"),
                                                   DT::dataTableOutput('position3')
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