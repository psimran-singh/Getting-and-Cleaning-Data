#Setup

urlA <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
locationA <- "./Dataset.zip"

download.file(urlA,locationA,method="curl")

