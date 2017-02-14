# load the reshape2 package

library(reshape2)

# load the training set,labels and activities and merge them into single training dataset

train_set <- read.table("C:/Users/I321508/Desktop/R Practice/C3W4/assignment/UCI HAR Dataset/train/X_train.txt")
train_label <- read.table("C:/Users/I321508/Desktop/R Practice/C3W4/assignment/UCI HAR Dataset/train/y_train.txt")
train_activity <- read.table("C:/Users/I321508/Desktop/R Practice/C3W4/assignment/UCI HAR Dataset/train/subject_train.txt")
train <- cbind(train_activity,train_label,train_set)

# load the test set,labels and activities and merge them into single test dataset

test_set <- read.table("C:/Users/I321508/Desktop/R Practice/C3W4/assignment/UCI HAR Dataset/test/X_test.txt")
test_label <- read.table("C:/Users/I321508/Desktop/R Practice/C3W4/assignment/UCI HAR Dataset/test/y_test.txt")
test_activity <- read.table("C:/Users/I321508/Desktop/R Practice/C3W4/assignment/UCI HAR Dataset/test/subject_test.txt")
test <- cbind(test_activity,test_label,test_set)

#Merge the training and test set

merged_set <- rbind(train,test)


#Load activity labels and features and convert them from factor to character class
activity <- read.table("C:/Users/I321508/Desktop/R Practice/C3W4/assignment/UCI HAR Dataset/activity_labels.txt")
activity[,2] <- as.character(activity[,2])
features <- read.table("C:/Users/I321508/Desktop/R Practice/C3W4/assignment/UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2])

#Extracting mean and std for each measurement

requiredfeatures <-grep(".*mean.*|.*std.*", features[,2])
requiredfeaturenames <- features[requiredfeatures,2]
requiredfeaturenames = gsub('-mean', 'Mean', requiredfeaturenames)
requiredfeaturenames = gsub('-std', 'Std', requiredfeaturenames)
requiredfeaturenames <- gsub('[-()]', '', requiredfeaturenames)

#Use descriptive activity names to label the dataset and give descriptive variable names

colnames(merged_set) <- c("subject","activity",requiredfeaturenames)
merged_set$activity <- factor(merged_set$activity, levels = activity[,1], labels = activity[,2])
merged_set$subject <- as.factor(merged_set$subject)

#Create an independent tidy data set and save it as tidy.txt

new_set <- melt(merged_set, id = c("subject", "activity"))
averaged_tidy_set <- dcast(new_set, subject + activity ~ variable, mean)

write.table(averaged_tidy_set, "tidy.txt", row.names = FALSE, quote = FALSE)