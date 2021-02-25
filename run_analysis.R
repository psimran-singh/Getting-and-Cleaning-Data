#Setup
library(dplyr)
library(reshape2)

#Get Data from the Internet and Unzip
filename <- "Datasets.zip"
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

if (!file.exists(filename)){
  download.file(url,filename,method="curl")
}

if (!file.exists("UCI HAR Dataset")) { 
  unzip(filename) 
}

#Read all tables into R
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")


#Merge the Datasets
x <- rbind(x_test,x_train)
y <- rbind(y_test,y_train)
subject <- rbind(subject_test,subject_train)

test_train_merged <- cbind(subject,x,y)


#Keep only mean and std variables
tidydata <- test_train_merged %>% 
  select(subject,code,contains("mean"),contains("std"))


#Name the activities explicitly rather than use codes
tidydata$code <- activities[tidydata$code, 2]


#Rename all variables to be descriptive
names(tidydata)[1] = "Subject"
names(tidydata)[2] = "Activity"
names(tidydata)<-gsub("Acc", "Accelerometer", names(tidydata))
names(tidydata)<-gsub("Gyro", "Gyroscope", names(tidydata))
names(tidydata)<-gsub("BodyBody", "Body", names(tidydata))
names(tidydata)<-gsub("Mag", "Magnitude", names(tidydata))
names(tidydata)<-gsub("^t", "Time", names(tidydata))
names(tidydata)<-gsub("^f", "Frequency", names(tidydata))
names(tidydata)<-gsub("tBody", "TimeBody", names(tidydata))
names(tidydata)<-gsub("-mean()", "Mean", names(tidydata), ignore.case = T)
names(tidydata)<-gsub("-std()", "STD", names(tidydata), ignore.case = T)
names(tidydata)<-gsub("-freq()", "Frequency", names(tidydata), ignore.case = T)
names(tidydata)<-gsub("angle", "Angle", names(tidydata))
names(tidydata)<-gsub("gravity", "Gravity", names(tidydata))


#Create final data set with summary data at the subject and activity level
melteddata <- melt(tidydata, id = c("Subject", "Activity"))
finaldata <- dcast(melteddata, Subject + Activity ~ variable, mean)

write.table(finaldata, "./final_tidy_dataset.txt", row.names = FALSE, quote = FALSE)
