# Explanation of what the script "run_analysis.R" does

 ## Requirements
 The script requires you to have the samsung data folder (also called "UCI HAR Dataset") as your working directory
 
 ## Steps
 - Reads files in the UCI HAR Data set folder and subfolders and stores these into R objects
 - Cleans the read elements from unnecessary characters, such as extra spaces and leading numbers.
 - Merges the test and train datasets together
 - Separates the 561 measurements from 1 to 561 different columns and names these in accordance with the feature names
 - Filters out the measurements that has to do with mean or standard deviation.
 - Creates a new column, named "activity" and replaces the activity IDs with corresponding activity names.
 - Creates a new data frame from the above, which holds the averages of all measurements per individual and activity.

For further details, please follow along the comments in the script.
