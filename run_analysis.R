setwd("C:/Users/Loko/Desktop/Coursera")
library(dplyr)

features <- read.table("./UCI HAR Dataset/features.txt")

####################		STEP 1		###########################
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
labels_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
set_test <- read.table("./UCI HAR Dataset/test/X_test.txt")

subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
labels_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
set_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
dataset <- rbind(cbind(subject_train,labels_train,set_train), 
		     cbind(subject_test,labels_test,set_test))
colnames(dataset)[1:2] <- c("subject", "activity")

#####################		STEP 2		########################
x <- grep("mean|std", features[,2], value=TRUE)
y <- grep("mean|std", features[,2])
datanames <- data.frame(y,x,stringsAsFactors=FALSE)
datasubset <- select(dataset,1,2,datanames[,1]+2)

##################### 		STEP 3		########################
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")
activity_labels[,2] <- as.character(activity_labels[,2])

for (i in 1:6){
	datasubset$activity[datasubset$activity==activity_labels[i,1]] <-
					activity_labels[i,2]
}

#####################		STEP 4 		########################
colnames(datasubset)[3:(dim(datasubset)[2])] <- datanames[,2]

#####################		STEP 5 		########################
index <- list(datasubset$subject, datasubset$activity)
tidydata <- aggregate(datasubset[,3:dim(datasubset)[2]], index, mean)

write.table(tidydata,"tidydata.txt", row.names=FALSE)

print(head(tidydata))

