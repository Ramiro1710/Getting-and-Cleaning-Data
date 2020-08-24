#load Libraries
library(dplyr)
library(reshape2)

#load X data (train and test)
xTest <- read.table("UCI HAR Dataset/test/X_test.txt")
xTrain <- read.table("UCI HAR Dataset/train/X_train.txt")
#1 Merging the training and the test sets to create one data set.
xAll <- rbind(xTest, xTrain)

#load Y data (train and test)
yTest <- read.table("UCI HAR Dataset/test/y_test.txt")
yTrain <- read.table("UCI HAR Dataset/train/y_train.txt")
#1 Merging the training and the test sets to create one data set.
y <- rbind(yTest, yTrain)

#load features names and activity names
namesFeatures <- read.table("UCI HAR Dataset/features.txt")
namesActivity <- read.table("UCI HAR Dataset/activity_labels.txt")

#2 Extracting only the measurements on the mean and standard deviation for each measurement.
indKeep <- grep("^(.*)mean|std(.*)$", namesFeatures$V2)
x <- xAll[indKeep]

#cleaning features names
nameFeatures <- tolower(namesFeatures$V2[indKeep])
nameFeatures <- gsub("[-()]", "", nameFeatures)
namesActivity$V2 <- tolower(namesActivity$V2)

#3 Using descriptive activity names to name the activities in the data set

y <- rename(y, YActivity = V1)

#4 Appropriately labeling the data set with descriptive variable names.
colnames(x) <- nameFeatures

#load subject data
subjectTest <- read.table("UCI HAR Dataset/test/subject_test.txt")
subjectTrain <- read.table("UCI HAR Dataset/train/subject_train.txt")
subject <- rbind(subjectTest, subjectTrain)
subject <- rename(subject, subject=V1)

#merge all data
dataSet <- cbind(x, y, subject)
dataSet$YActivity <- factor(dataSet$YActivity, levels = namesActivity$V1, labels = namesActivity$V2)
dataSet$subject <- as.factor(dataSet$subject)

#5 Creating a second, independent tidy data set with the average of each variable for each activity and each subject.
melted <- melt(dataSet, id = c("subject", "YActivity"))
tidyData <- dcast(melted, subject + YActivity ~ variable, mean)

write.table(tidyData, "tidyData.txt", row.names = FALSE)