# Getting and Cleaning Data C.Project

Peer Grader Assignment by Severino Herrera :D. This document explains how the scripts work and the connection between them.

---First off, it's important to install this package: 

> install.packages("dplyr")

---And to use it in the project: 

library(dplyr)

---Then to read the tables from a local folder, if you need to replicate this project, download the data and change the route of each file. 

features <- read.table("D:/R/Getting and Cl Data/UCI HAR Dataset/features.txt", col.names = c("num","functions"))
activities <- read.table("D:/R/Getting and Cl Data/UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
subject_test <- read.table("D:/R/Getting and Cl Data/UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("D:/R/Getting and Cl Data/UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("D:/R/Getting and Cl Data/UCI HAR Dataset/test/y_test.txt", col.names = "code")
subject_train <- read.table("D:/R/Getting and Cl Data/UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("D:/R/Getting and Cl Data/UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("D:/R/Getting and Cl Data/UCI HAR Dataset/train/y_train.txt", col.names = "code")

-- Then the script merges the created 'tables' with the following script

X <- rbind(x_train, x_test)
Y <- rbind(y_train, y_test)
Subject <- rbind(subject_train, subject_test)
Merged <- cbind(Subject, Y, X)

-- The next script uses the funcion 'select' that comes with the recently installed package: dplyr  (1st steps of this document)

Extract <- Merged %>% select(subject, code, contains("mean"), contains("std"))

-- We then proceed to name the activities based on the code.

Extract$code <- activities[Extract$code, 2]

-- We label the data based on the text observed in the data:

names(Extract)[2] = "activity"
names(Extract)<-gsub("Acc", "Accelerometer", names(Extract))
names(Extract)<-gsub("Gyro", "Gyroscope", names(Extract))
names(Extract)<-gsub("BodyBody", "Body", names(Extract))
names(Extract)<-gsub("Mag", "Magnitude", names(Extract))
names(Extract)<-gsub("^t", "Time", names(Extract))
names(Extract)<-gsub("^f", "Frequency", names(Extract))
names(Extract)<-gsub("tBody", "TimeBody", names(Extract))
names(Extract)<-gsub("-mean()", "Mean", names(Extract), ignore.case = TRUE)
names(Extract)<-gsub("-std()", "STD", names(Extract), ignore.case = TRUE)
names(Extract)<-gsub("-freq()", "Frequency", names(Extract), ignore.case = TRUE)
names(Extract)<-gsub("angle", "Angle", names(Extract))
names(Extract)<-gsub("gravity", "Gravity", names(Extract))

-- Finalyy we make an indepentend tidy set grouped by subject and activity and save it to a local folder

FTidyData <- Extract %>%
  group_by(subject, activity) %>%
  summarise_all(funs(mean))
write.table(FTidyData, "FinalTidyData.txt", row.name=FALSE)