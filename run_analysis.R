#Setup
library(dplyr)

filename <- "Datasets.zip"
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

if (!file.exists(filename)){
  download.file(url,filename,method="curl")
}

if (!file.exists("UCI HAR Dataset")) { 
  unzip(filename) 
}

features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")


# str(features) 
# str(activities)
# str(subject_test)
# str(x_test)
# str(y_test)
# str(subject_train)
# str(x_train)
# str(y_train)

x <- rbind(x_test,x_train)
y <- rbind(y_test,y_train)
subject <- rbind(subject_test,subject_train)

test_train_merged <- cbind(subject,x,y)

tidydata <- test_train_merged %>% 
  select(subject,code,contains("mean"),contains("std"))

# str(tidydata)

