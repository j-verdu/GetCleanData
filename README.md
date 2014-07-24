
Human Activity Recognition Using Smartphones Dataset
===
*Tidy Data Generation*
==================================================================


# I. Original data

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. See 'features_info.txt' for more details. 

For each record it was provided:

- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.

The original dataset included the following files:

- 'features_info.txt': Shows information about the variables used on the feature vector.

- 'features.txt': List of all features.

- 'activity_labels.txt': Links the class labels with their activity name.

- 'train/X_train.txt': Training set.

- 'train/y_train.txt': Training labels.

- 'test/X_test.txt': Test set.

- 'test/y_test.txt': Test labels.

The following files were available for the train and test data. Their descriptions are equivalent. 

- 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 

**Details about input data are explained at the CodeBook.md file.**

# II. Data manipulation

All data manipulation was executed through the R code available at run_analysis.R, in a single script. It has basically 6 parts:

## 1. Read data
Using `read.table()` function, import original data mentioned at CodeBook.md

## 2. Merge the training and the test sets to create one data set

By first adding activity and subject values to data.frames values_train and values_test.

Then adding test/train information to data.frames values_train and values_test, although this information is not used in this case.

At last, merging test and train data using `rbind()` function to a new 'values' dataset, and deleting original data variables.

## 3. Extract only the measurements on the mean and standard deviation for each measurement

Using the original labels for measurement variables, using `grep()` function we select those measurements which include 'mean', and 'std' in its description.
Then, we built an index of pointers from this selection which can be directly applied to 'values' dataset, and perform the subsetting with a simple `values[,index]` operation.

## 4. Use descriptive activity names to name the activities in the data set

Since we have an 'activ' original dataset that related activity_id with activity description (e.g. 1=WALKING), we simply merge 'values' and 'activ' using `merge()` function. The common field to merge them is named 'activ' in both datasets.
As a result, a new descriptive field 'activ_label' is added to 'values' dataset.

## 5. Appropriately labels the data set with descriptive variable names

We start with a partially descriptive vector of labels, which was found with the original data, and stored at a 'labels' vector.
We basically modify chunck by chunk these labels, using ´gsub()` function, avoiding abbreviations(for instance, 'time' replacing 't'), and separating words with points.

New labels are assigned to 'values' dataset using `names()` function.

## 6. Create a second, independent tidy data set with the average of each variable for each activity and each subject

First we melt 'values' to 'values2', using `melt()` function, in order to group all 79 measurement variables in two columns ('variable','value'), and preserving 'subject' and 'activity'.

We order 'values2' by subject, activity and variable name, using `arrange()` function.

From the molten data 'values2', we extract the mean for each subject, activity and variable (79 measurements), using `ddply()` function. 'finalset' is generated.

We cast 'finalset' to tidy the data, using `cast()` function, restoring the averages of 79 measurement to independent columns. Thus, each row gives information of mean measurements of these 79 variables for a specfic combination of subject and activity. That's why it has 180 observations, as combination of 30 subjects and 6 activities.

At last, the output 'tidydata.txt' file is generated using `write.table()` function.


# III. Output data

The output is the 'tidydata.txt' file, whose generation process has been previously explained.

**Details about output and intermediate R data are explained at the CodeBook.md file.**

# IV. References

Original data come from:

Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012