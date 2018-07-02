### Peer-graded Assignment: Getting and Cleaning Data Course Project

# Read feature names and activity labels into character vectors
features <- readLines("features.txt")
activity_labels <- readLines("activity_labels.txt")

# Clean features from leading numbers and space, e.g. "11 tBodyAcc-max()-Y" becomes "tBodyAcc-max()-Y"
features <- gsub("[0-9]+ ", "", features)

# Clean the activity_labels from leading numbers and space, e.g. "1 Walking" becomes "Walking"
activity_labels <- gsub("[0-9] ","", activity_labels)

## TEST DATA
# Read subject IDs, measured values and activity IDs into character vectors
test_subjects_IDs <- readLines("./test/subject_test.txt")
test_measurements <- readLines("./test/X_test.txt")
test_act_IDs <- readLines("./test/y_test.txt")

## TRAIN DATA
# Read subject IDs, measured values and activity IDs into character vectors
train_subjects_IDs <- readLines("./train/subject_train.txt")
train_measurements <- readLines("./train/X_train.txt")
train_act_IDs <- readLines("./train/y_train.txt")

# Create two data frames with 3 columns: subject_id, activity_id and measurements for test and train cases
testDF <- data.frame(subject_ID = test_subjects_IDs, activity_ID = test_act_IDs, measurements = test_measurements)
trainDF <- data.frame(subject_ID = train_subjects_IDs, activity_ID = train_act_IDs, measurements = train_measurements)

# Merge the two data frames together
mergedDF <- rbind(testDF, trainDF)

# Remove leading spaces of every row of the measurements variable
mergedDF[,3] <- gsub("^ +", "", mergedDF[,3])

# Load dplyr and tidyr packages
library(dplyr)
library(tidyr)

# Separate the measurements variable into the 561 different measurements
# and set the labels of these variables in accordance with features
mergedDF <- separate(mergedDF, measurements, into = features, sep = " +")

# Filter out the measurement variables that correspond to mean or standard deviation
mergedDF <- mergedDF[,c(TRUE, TRUE, grepl("[Mm][Ee][Aa][Nn]|[Ss][Tt][Dd]", names(mergedDF)[3:563]))]

# Convert the measurement values from factor to numeric
for(i in 3:ncol(mergedDF)) {
    mergedDF[,i] <- as.numeric(as.character(mergedDF[,i]))
}

# Convert the subject_ID variable from factor to integer
mergedDF[,1] <- as.integer(as.character(mergedDF[,1]))
    
# Convert the activity_ID variable from factor to integer
mergedDF[,2] <- as.integer(as.character(mergedDF[,2]))


# Create a new column in mergedDF and populate it with data from activity_labels
mergedDF <- mutate(mergedDF, activity = activity_labels[activity_ID])

# Move the new column activity to the spot of activity_id and remove activity_id
mergedDF <- cbind(mergedDF[,c(1,ncol(mergedDF),3:(ncol(mergedDF)-1))])

# Create a new tidy data set with the average of every measurement, grouped by subject_ID and activity.
averageDF <- group_by(mergedDF, subject_ID, activity) %>%
    summarise_all(mean)

# Create a .txt file with the output of averageDF
write.table(averageDF, "averageDF", row.names = FALSE)
