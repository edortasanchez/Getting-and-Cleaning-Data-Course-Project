#
library(reshape2)
setwd ("/Users/Edorta/Documents/Data_Science/03. Getting and Cleaning Data/Week 4/Getting and Cleaning Data Course Project/UCI HAR Dataset/");

# 1. EXTRACTS THE MEAN AND STD_DEV FROM MEASUREMENTS
features <- read.table("./features.txt")
features[,2]<-as.character(features[,2])
m_s_features <- grep(".*mean.*|.*std.*", features[,2])
m_s_features.names <- features[m_s_features,2]

# 2. MERGE THE TRAINING AND TEST SETS
#2.1.Read the training set  
X_train <- read.table("train/X_train.txt")[m_s_features]
Y_train <- read.table("train/Y_train.txt")
subject_train <- read.table("train/subject_train.txt")

#2.2.Read the test set  
X_test <- read.table("test/X_test.txt")[m_s_features]
Y_test <- read.table("test/Y_test.txt")
subject_test <- read.table("test/subject_test.txt")

#2.3.Merge the sets  
train_merged <- cbind(subject_train, Y_train, X_train)
test_merged <- cbind(subject_test, Y_test, X_test)
merged <- rbind (train_merged, test_merged)

# 3. NAME THE ACTIVITIES IN THE DATA SET
activity_labels <- read.table("./activity_labels.txt")
activity_labels[,2] <- as.character(activity_labels[,2])
colnames(merged) <- c("Subject","Activity", m_s_features.names)
merged$Activity <- factor(merged$Activity, levels = activity_labels[,1],labels=activity_labels[,2])
merged$Subject <- as.factor(merged$Subject)
merged_melted <- melt(merged, id= c("Subject","Activity"))
merged_mean <- dcast(merged_melted, Subject + Activity ~ variable, mean)

# 4. CREATE THE FILE "tidy.txt"
write.table(merged_mean, "tidy.txt", row.names = FALSE, quote = FALSE)




