

library(data.table)

#Reading raw data
test <- read.table("UCI HAR Dataset/test/X_test.txt")
trai <- read.table("UCI HAR Dataset/train/X_train.txt")

#Adding columns for activities and subjects
test["y"] <- NA
trai["y"] <- NA
test["subject"] <- NA
trai["subject"] <- NA

#Reading activities codes
test.y <- read.table("UCI HAR Dataset/test/y_test.txt")
trai.y <- read.table("UCI HAR Dataset/train/y_train.txt")

#Adding the activity codes data
test$y <- test.y[,1]
trai$y <- trai.y[,1]

#Reading subject codes
test.subj <- read.table("UCI HAR Dataset//test//subject_test.txt")
trai.subj <- read.table("UCI HAR Dataset//train//subject_train.txt")

#Adding the subject codes data
test$subject <- test.subj[,1]
trai$subject <- trai.subj[,1]

#Parsing data.frames to data tables
test <- as.data.table(test)
trai <- as.data.table(trai)

#1
#Binding all data together to the same data set
all.data <- rbind(test,trai)

#2
#Filtering data just to keep mean and standard deviation measurements
len <- length(all.data)
attr.features <- read.table("UCI HAR Dataset/features.txt")
col.nums <- attr.features[(grep("mean\\(",attr.features$V2)),]$V1
col.nums <- c(col.nums,attr.features[(grep("std\\(",attr.features$V2)),]$V1,len-1,len)
print(length(col.nums))
all.data <- all.data[,col.nums,with=F]

#3 and #4
#Reading activity description labels
activity.labels <- read.table("UCI HAR Dataset/activity_labels.txt")

#Modifying activity codes with they label
all.data$y = as.character(activity.labels[all.data$y,2])

#5
#Average the data by activity and subject
all.data <- all.data[, lapply(.SD, mean, na.rm=TRUE), by=c("y","subject") ]
all.data <- all.data[order(subject),]

#Writing the tidy data output
write.table(all.data,"tidy_UCI_HAR_Dataset.txt",quote = F, row.names = F, col.names = F)

