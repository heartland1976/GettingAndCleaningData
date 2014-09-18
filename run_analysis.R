#
# Author: Jeroen
#

##########
# NOTES
# -decided not to read in all the files in the inertial folder - also per suggestion 
#  of the forum post from David (https://class.coursera.org/getdata-007/forum/thread?thread_id=49)
##########

##########
### Step 0 - Initial work
##########

# Set the working directory - as we're lazy
setwd("~/Documents/Coursera/datascience/[3] Cleaning Data/Course Project/UCI HAR Dataset")

# We're using the funky plyr library for doing our aggregations
library(plyr)

# Load features and activities
features <- read.table("features.txt")
activities <- read.table("activity_labels.txt")

##########
## Step 1 - Merges the training and the test sets to create one data set.
##########

# Load the test files - subject, x, and y
subject_test <- read.table("test/subject_test.txt")
x_test <- read.table("test/X_test.txt")
y_test <- read.table("test/y_test.txt")

# Load the training files - subject, x and y
subject_train <- read.table("train/subject_train.txt")
x_train <- read.table("train/X_train.txt")
y_train <- read.table("train/y_train.txt")

# Combine the train and test data for the subjects into a single data set by using rbind to concatenate the two
subject_data <- rbind(subject_test, subject_train)

# Combine the train and test data for 'x' into a single data set by using rbind to concatenate the two
x_data <- rbind(x_test, x_train)

# Combine the train and test data for 'y' into a single data set by using rbind to concatenate the two
y_data <- rbind(y_test, y_train)

##########
## Step 2 - Extract only the measurements on the mean and standard deviation for each measurement
##########

# Filter just the mean / standard columns
mean_std_features <- grep("-(mean|std)", features[, 2])

# Subset the desired columns by splitting of just the columns for mean and standard 
x_data <- x_data[, mean_std_features]

##########
## Step 3 - Use descriptive activity names to name the activities in the data set
##########

# Change values to include activity names
y_data[,1] <- activities[y_data[, 1], 2]

##########
## Step 4 -  Appropriately label the data set with descriptive variable names
##########

# Add column names to the data set for all the mean and standard columns
names(x_data) <- features[mean_std_features, 2]

# Add friendly column name for the activity data
names(y_data) <- "Activity"

# Add friendly column name for the subject data
names(subject_data) <- "Subject"

##########
## Step 5 - Create a second, independent tidy data set with the average of each variable for each activity and each subject
##########

# Merge all the data in a single data set by using cbind to glue everything together as new columns
combined <- cbind(x_data, y_data, subject_data)

# Calculate means for all columns except for the last two (Activity & Subject). 
tidy <- ddply(combined, .(Subject, Activity), function(x) colMeans(x[, 1:length(mean_std_features)]))

# Last, write the tidy.txt file, separate columns with a comma, containing the clean data set
write.table(tidy, "tidy.txt", sep=",", row.names=FALSE)

# Return to upper directory
setwd("..")
