library(dplyr)

features <- read.table("D:/R/Getting and Cl Data/UCI HAR Dataset/features.txt", col.names = c("num","functions"))
activities <- read.table("D:/R/Getting and Cl Data/UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
subject_test <- read.table("D:/R/Getting and Cl Data/UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("D:/R/Getting and Cl Data/UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("D:/R/Getting and Cl Data/UCI HAR Dataset/test/y_test.txt", col.names = "code")
subject_train <- read.table("D:/R/Getting and Cl Data/UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("D:/R/Getting and Cl Data/UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("D:/R/Getting and Cl Data/UCI HAR Dataset/train/y_train.txt", col.names = "code")


# 1.  Merges the training and the test sets to create one data set.

X <- rbind(x_train, x_test)
Y <- rbind(y_train, y_test)
Subject <- rbind(subject_train, subject_test)
Merged <- cbind(Subject, Y, X)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.

Extract <- Merged %>% select(subject, code, contains("mean"), contains("std"))

# 3. Uses descriptive activity names to name the activities in the data set.

Extract$code <- activities[Extract$code, 2]

# 4. Appropriately labels the data set with descriptive variable names.

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

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

FTidyData <- Extract %>%
  group_by(subject, activity) %>%
  summarise_all(funs(mean))
write.table(FTidyData, "FinalTidyData.txt", row.name=FALSE)

