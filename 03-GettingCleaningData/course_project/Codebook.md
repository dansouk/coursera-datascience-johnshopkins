

Codebook
Getting and Cleaning Data Course Project
Coursera

Data Source
Data for this project is the http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones, hosted by the University of California - Irvine.

The data consists of 561 features with just over 10,000 data points from smartphone accelerometer and gyroscope signals.

The data will be downloaded and extracted automatically if it does not exist in the specified directory

Required library(ies) (Other than base R)
reshape2

Processing
A single R script, run_analysis.R, processes the raw data in several steps in order to create a single tidy output file, per the instructions below.

A. Merges the training and the test sets to create one data set.
   
   Test and training data consist of three subsets - the raw data points, activities and subjects. These are combined in pairs to form three complete subsets

B. Extracts only the measurements on the mean and standard deviation for each measurement.

   A simple regular expression, -(mean|std)\\(\\), retains all features with the strings 'mean' or 'std' in their name. All other features are ignored for purposes of this analysis.

C. Uses descriptive activity names to name the activities in the data set

   The script applies the labels in the activity_labels.txt file to provide activity names

D. Appropriately labels the data set with descriptive variable names.
    
   Extraneous characters -, ( and ) are removed using simple substitution 

E. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

   The melt function from the reshape2 package creates these values, which are then written to a new output file, 'tidy.txt'



