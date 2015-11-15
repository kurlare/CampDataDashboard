### Make sure dataset is in your working directory before running.
### This script will read in the data, select specific columns,
### impute missing values, create a bunk column, and also create
### a reduced data set with camper outliers removed.  

library(dplyr)
library(mice)

campdata <- read.csv("dataset1.csv", 
                     na.strings = c("#N/A", "#DIV/0!", "#VALUE!"), 
                     header = TRUE)
campdata <- campdata[, c(1, 2, 3, 4, 5, 23, 24, 35, 38, 39, 40, 59, 60, 61)]
colnames(campdata) <- c("Week", "Weekday", "Day", "Child_Number",
                        "Name", "Daily_Total_Points_Earned", 
                        "Daily_Total_Points_Lost", "Total_Std_Attn_Corr",
                        "Total_Helping", "Total_Sharing", 
                        "Total_Cont_to_Discuss", "Total_Positive_Peer",
                        "Total_Conduct", "Total_Negative_Verbal")

##  Multiple imputation with mice package.
tempData <- mice(campdata,m=5,maxit=10,meth='pmm',seed=500)

## Camp Data with imputed values.
campdata <- complete(tempData, 1)  

## Scramble names
campdata$Name <- sample(campdata$Name, nrow(campdata))
campdata$Child_Number <- sample(campdata$Child_Number, nrow(campdata))

## Add bunk variable and associated values
campdata$Bunk <- campdata$Name
campdata$Bunk[campdata$Bunk > 15100 & campdata$Bunk < 15200] <- 1
campdata$Bunk[campdata$Bunk > 15200 & campdata$Bunk < 15300] <- 2
campdata$Bunk[campdata$Bunk > 15300 & campdata$Bunk < 15400] <- 3
campdata$Bunk[campdata$Bunk > 15400 & campdata$Bunk < 15500] <- 4
campdata$Bunk[campdata$Bunk > 15500 & campdata$Bunk < 15600] <- 5
campdata$Bunk[campdata$Bunk > 15600 & campdata$Bunk < 15700] <- 6
campdata$Bunk[campdata$Bunk > 15700 & campdata$Bunk < 15800] <- 7

leave_out <- c( 15101,15103, 15104, 15108, 15111, 15112, 15204,15205, 15209, 15210,  15212,
                15301, 15307, 15308,15309, 15310, 15403, 15405,15503, 15504,15611,
                15701, 15707, 15708, 15709, 15712)

reduced <- filter(campdata, ! Name %in% leave_out)

write.csv(campdata, file = "dataset1.csv")
