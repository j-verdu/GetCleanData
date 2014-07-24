CodeBook for Human Activity Recognition using Samsung Galaxy
===
*Tidy Dataset generation*
========================================================================

# I. Original data sets

## subject_train.txt (imported to 'subj_train')
Code to idendify the subject related to variable measurements, that can be found in x_train.txt following the same order. Belong to a subset of measurements labeled as **training set**.

'data.frame':    7352 obs. of  1 variable:

$ V1: int  1 digits
    
## x_train.txt (imported to 'values_train')
Each row is an observation of a particular subject (defined in subject_train.txt), doing a particular activity (coded in y_train.txt). For each observation there are 561 measurements (variables) of gyroscope and accelerometer variables from the smartphone related to a particular subject. One can identify these variables following 
features.txt description, in the same order.
Belong to a subset of measurements labeled as **training set**.

'data.frame':    7352 obs. of  561 variables:

All variables are numeric, and named as follows

$V1     : num

$V2     : num

$V3     : num

...

$V561   : num

## y_train.txt (imported to 'activ_train')
Code to idendify the activity that the subject was doing (laying, sitting, etc.) related to variable measurements, that can be found in x_train.txt following the same order. Belong to a subset of measurements labeled as **training set**.

'data.frame':    7352 obs. of  1 variable:

 $ V1: int


## subject_test.txt (imported to 'subj_test')
Code to idendify the subject related to variable measurements, that can be found in x_test.txt following the same order. Belong to a subset of measurements labeled as **test set**.

'data.frame':    2947 obs. of  1 variable:

$ V1: int  1 digits
    
## x_test.txt (imported to 'values_test')
Each row is an observation of a particular subject (defined in subject_test.txt), doing a particular activity (coded in y_test.txt). For each observation there are 561 measurements (variables) of gyroscope and accelerometer variables from the smartphone related to a particular subject. One can identify these variables following 
features.txt description, in the same order.
Belong to a subset of measurements labeled as **test set**.

'data.frame':    2947 obs. of  561 variables:

All variables are numeric, and named as follows

$V1     : num

$V2     : num

$V3     : num

...

$V561   : num

## y_test.txt (imported to 'activ_test')
Code to idendify the activity that the subject was doing (laying, sitting, etc.) related to variable measurements, that can be found in x_test.txt following the same order. Belong to a subset of measurements labeled as **test set**.

'data.frame':    2947 obs. of  1 variable:

 $ V1: int

## features.txt (imported to 'features')
Labels of measurement variables that can be found in x_train.txt and x_test.txt. They are partially descriptive. Labels are included in $V2 of the data.frame as a factor variable. $V1 is just an ordered integer index.

'data.frame':    561 obs. of  2 variables:

$ V1: int  1 2 3 4 5 6 7 8 9 10 ...

$ V2: Factor


## activity_labels.txt (imported to 'activ')
Labels of types of activities that can be found in y_train.txt and y_test.txt. 
$V1 is the index that can be related to values found at y_train.txt and y_test.txt.
$V2 is the vector of labels, as factor variable, related to the vector of indexes $V1.
Variables are renamed $V1=activ, $V2=activ_label after importing to 'activ'.

data.frame':    6 obs. of  2 variables:

$ V1: int  1 2 3 4 5 6

$ V2: Factor with 6 levels


# II. Intermediate data sets

## 'values'
Data frame with merged observations related to train and test original datasets, showing only variables of mean and standard deviation of measurements(79 variables), by subsetting the original 561 variables. Its labels have been modified to be more descriptive.
It also has 4 additional variables: activity_id, activity_label (by merging 'activ' with 'activ_test' and 'activ_train), test_data (logical, TRUE if belong to test dataset, FALSE if belongs to train dataset), and subject id. 

'data.frame':    10299 obs. of  82 variables:

    $ activity_id                           : int
    $ subject                               : int
    $ test_data                             : logi
    $ Time.Body.Accelerometer.Mean.Xaxis    : num
    $ Time.Body.Accelerometer.Mean.Yaxis    : num
     ...
    $ activity_label                        : factor with 6 levels

## 'values2'
Data frame of molten data derived from 'values'. 'subject' and 'activity' have been preserved as variables, whereas all 79 types of measurements have been molten to two columns, the 'variable' one (factor variable with the labels of measurements), and the 'value' one (specific value for each subject, activity, and measurement). Thus, although is almost the same data, 'values2' is *longer* than 'values', its has more observations and less variables.

'data.frame':    813621 obs. of  4 variables:
     $ subject : int  
     $ activity: Factor w/ 6 levels 
     $ variable: Factor w/ 79 levels
     $ value   : num 


# III. Final output: Tidy data set

## 'finalset'

Tidy data set, list of 81 variables (subject, activity, and 79 measurements). Each row has mean values of measurements for each combination of subject and activity.
This data set is derived from 'values2' by extracting the mean for each factor (measurement), subject and activity, and then casting the data to reformat and have again an independent variable for each column (avoid molten variables). 
There are 180 observations (rows), corresponding to combinations of 30 subjects with 6 activities.

List of 81
     $ subject                              : int
     $ activity                             : Factor w/ 6 levels
     $ Time.Body.Accelerometer.Mean.Xaxis   : num
        ...    
    $ Frequency.Body.Gyroscope.Jerk.Magnitude.MeanFrequency     : num