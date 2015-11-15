#Note:  To view this app on the web, go to:  https://kurlare.shinyapps.io/dashboard

To run the app, create a new directory (i.e. 'campdashboard app') and place the files there.
Open RStudio and set your working directory to "C:/.../campdashboard app".  
You may have to install the packages 'DT', 'Shiny', 'ggplot2', 'mice', and 'dplyr'.
Use 'install.packages("package_name") to install the packages, then library(package_name).

Finally, open server.R or ui.R in RStudio, and click on the drop down menu for the 'Run App' button.  Select 'Run External',
and the App should load.  Have fun!



Credits:
The download filtered data button was created using code from
Yihui Xie. 
Link here:  https://groups.google.com/forum/#!topic/shiny-discuss/r-4stY3xTy0

The regression model output code is from this answer on StackOverflow:
http://stackoverflow.com/questions/18762962/passing-variable-names-to-model-in-shiny-app

