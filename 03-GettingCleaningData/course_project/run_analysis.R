library(reshape2)
# Review criteria
# The submitted data set is tidy.
# The Github repo contains the required scripts.
# GitHub contains a code book that modifies and updates the available codebooks with the data to indicate all the variables and summaries calculated, along with units, and any other relevant information.
# The README that explains the analysis files is clear and understandable.
# The work submitted for this project is the work of the student who submitted it.

# Getting and Cleaning Data Course Project
# The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. 
# The goal is to prepare tidy data that can be used for later analysis. 
# You will be graded by your peers on a series of yes/no questions related to the project. 
# You will be required to submit: 
#  1) a tidy data set as described below
#  2) a link to a Github repository with your script for performing the analysis
#  3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. 
#     You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.
# One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:
#  http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
# Here are the data for the project:
#  https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

# You should create one R script called run_analysis.R that does the following.
# A. Merges the training and the test sets to create one data set.
# B. Extracts only the measurements on the mean and standard deviation for each measurement.
# C. Uses descriptive activity names to name the activities in the data set
# D. Appropriately labels the data set with descriptive variable names.
# E. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# A. Merge data sets
setwd('C:/Users/dansouk/Source/Repos/coursera-datascience-johnshopkins/03-GettingCleaningData/course_project/')

basePath <- getwd()
dlPath = paste(basePath, '/UCI HAR Dataset/', sep = '')
sourceData <- 'getdata_projectfiles_UCI HAR Dataset.zip'

# Go get the file if needed
if(!file.exists(dlPath)) {
  if(!file.exists('getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip')) {
    download.file(
      'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip',
      sourceData
    )
  }

  # By default, this will create a directory under the current directory named 'UCI HAR Dataset'  
  unzip(sourceData)
}

# Change the basePath to reference the full path to the source files
basePath = dlPath

# Read in the data into the test and training sets
# Each train dataset should have 7352 observations
# Each test dataset should have 2947 observations
# Total of 10,299 observations
# I'm ignoring the extraneous data in the 'Inertial Signals' subfolders, since that seems to be just noise.
# We'd drop it anyway, since the requirements call for only mean/stdev
data.test <- read.table(paste(basePath, '/test/', 'X_test.txt', sep = ''), header = FALSE)
activities.test <- read.table(paste(basePath, '/test/', 'y_test.txt', sep = ''), header = FALSE)
subjects.test <- read.table(paste(basePath, '/test/', 'subject_test.txt', sep = ''), header = FALSE)

data.train <- read.table(paste(basePath, '/train/', 'X_train.txt', sep = ''), header = FALSE)
activities.train <- read.table(paste(basePath, '/train/', 'y_train.txt', sep = ''), header = FALSE)
subjects.train <- read.table(paste(basePath, '/train/', 'subject_train.txt', sep = ''), header = FALSE)

# Combine each subset
data.both <- rbind(data.test, data.train)
activities.both <- rbind(activities.test, activities.train)
subjects.both <- rbind(subjects.test, subjects.train)

# Combine these into a single table
# This works because each set has the same number of records (observations)
data.full <- cbind(subjects.both, activities.both, data.both)

# B. Extracts only the measurements on the mean and standard deviation for each measurement. 
features <- read.table(paste(basePath, '/features.txt', sep = ''), header = FALSE)

# Remove extraneous features, which is really everything except 
# mean and stdev. As implemented, this is all features with the strings
# 'mean' and 'std' in their name
requiredFeatures <- features[grep('-(mean|std)\\(\\)', features[, 2 ]), 2]
data.full <- data.full[, c(1, 2, requiredFeatures)]

# C. Uses descriptive activity names to name the activities in the data set
# Pull in the activity labels
activities <- read.table(file.path(basePath, '/activity_labels.txt', sep=''))

# Update the activity name
# and force the activity labels to strings
data.full[, 2] <- as.character(activities[data.full[,2], 2])

# D. Appropriately label the data set with descriptive variable names. 
colnames(data.full) <- c(
  'subject',
  'activity',
  # Remove hyphens and brackets to create readable names
  gsub('\\-|\\(|\\)', '', as.character(requiredFeatures))
)

# E. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
# Create a unique combination of subject and acitivites
final.melted <- melt(data.full, id = c('subject', 'activity'))

# Calculate the means
# Note that this seems to take a mean of means, which is not statistically valid.
final.mean <- dcast(final.melted, subject + activity ~ variable, mean)

# Dump results to a file
write.table(final.mean, file=paste(basePath, '/tidy.txt', sep=''), row.names = FALSE, quote = FALSE)


