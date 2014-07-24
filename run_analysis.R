## Course Project, Getting and cleaning data
## Data Science Specialization, Coursera

## Data reference: [1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. 
## Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. 
## International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

## load some libraries
library(plyr)
library(reshape)

## Read data

# read training set
subj_train<-read.table("subject_train.txt")
activ_train<-read.table("y_train.txt")
values_train<-read.table("X_train.txt")

#read test set
subj_test<-read.table("subject_test.txt")
activ_test<-read.table("y_test.txt")
values_test<-read.table("X_test.txt")

#read features and activities
features<-read.table("features.txt")
activ<-read.table("activity_labels.txt")
names(activ)<-c("activ","activ_label")



## 1. Merge the training and the test sets to create one data set
# adding activity and subject values
values_test$subj<-subj_test$V1
values_train$subj<-subj_train$V1
values_test$activ<-activ_test$V1
values_train$activ<-activ_train$V1
# adding test/train information
values_test$test<-rep(TRUE,len=length(values_test$activ))
values_train$test<-rep(FALSE,len=length(values_train$activ)) #if test field=FALSE means it's training
# merge both sets
values<-rbind(values_test,values_train)
# remove separate tests
rm(values_test,values_train,subj_test,subj_train,activ_test,activ_train)


## 2. Extract only the measurements on the mean and standard deviation for each measurement

#point to mean() and std() fields
mean_stdv_index<-grep("*mean*|*std*",features$V2) 

# add 'activ' and 'test' fields to the pointer vector
index<-c(length(values)-2,length(values)-1,length(values),mean_stdv_index)

# extract measurements
values<-values[,index]


## 3. Use descriptive activity names to name the activities in the data set

values<-merge(values,activ) # merged by the only common field, 'activ'
# as result, new field 'activ_label' is added to values

## 4. Appropriately labels the data set with descriptive variable names

#extracts original labels of mean and std variables
labels<-as.character(features$V2[mean_stdv_index]) 

# improve label for 'time' and 'frequency' measures
labels<-gsub("^t","Time.",labels)
labels<-gsub("^f","Frequency.",labels)

# improve label for 'body' and 'gravity' measures
labels<-gsub(".Body",".Body.",labels)
labels<-gsub(".Gravity",".Gravity.",labels)
labels<-gsub(".Body.Bod.",".Body.",labels)

# improve label for 'accelerometer' and 'gyroscope' measures
labels<-gsub(".Acc",".Accelerometer.",labels)
labels<-gsub(".Gyro",".Gyroscope.",labels)

labels<-gsub(".Jerk",".Jerk.",labels)
labels<-gsub(".Mag",".Magnitude.",labels)
labels<-gsub("-mean\\()","Mean",labels)
labels<-gsub("-std\\()","StandardDeviation",labels)
labels<-gsub("-meanFreq\\()","MeanFrequency",labels)
labels<-gsub("-X",".Xaxis",labels)
labels<-gsub("-Y",".Yaxis",labels)
labels<-gsub("-Z",".Zaxis",labels)

# improve label for 'mean' and 'standarddeviation' measures

names(values)<-c("activity_id","subject","test_data",labels,"activity")


## 5. Create a second, independent tidy data set with the average of each variable for each activity and each subject


#melt data to group all variables in two columns ('variable','value')
values2<-melt(values,id=c("subject","activity"),measure.vars=labels) 
#order by subject,activity and variable name
values2<-arrange(values2,subject,activity,variable)
# extract mean for each subject, activity and variable
finalset<-ddply(values2,.(subject,activity,variable),summarize,mean=mean(value))
# make it a tidy dataset, each variable in a separate column
finalset<-cast(finalset,subject+activity~variable)
# write to a txt table
write.table(finalset,"tidydata.txt")
