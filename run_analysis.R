#Pointing to data and creating variable for files list
path_rf <- file.path("UCI HAR Dataset")
files<-list.files(path_rf, recursive=TRUE)

#Creating variables and reading data from files into them
ActivityTest  <- read.table(file.path(path_rf, "test" , "Y_test.txt" ),header = FALSE)
ActivityTrain <- read.table(file.path(path_rf, "train", "Y_train.txt"),header = FALSE)
SubjectTrain <- read.table(file.path(path_rf, "train", "subject_train.txt"),header = FALSE)
SubjectTest  <- read.table(file.path(path_rf, "test" , "subject_test.txt"),header = FALSE)
FeaturesTest  <- read.table(file.path(path_rf, "test" , "X_test.txt" ),header = FALSE)
FeaturesTrain <- read.table(file.path(path_rf, "train", "X_train.txt"),header = FALSE)

#Creating a data set by merging the test and training sets
##Binding the data tables by rows
Subject <- rbind(SubjectTrain, SubjectTest)
Activity<- rbind(ActivityTrain, ActivityTest)
Features<- rbind(FeaturesTrain, FeaturesTest)

##Naming variables
names(Subject)<-c("subject")
names(Activity)<- c("activity")
FeaturesNames <- read.table(file.path(path_rf, "features.txt"),head=FALSE)
names(Features)<- FeaturesNames$V2

##Creating data frame (Data) to consolidate all data
Combine <- cbind(Subject, Activity)
Data <- cbind(Features, Combine)

#Extracting the mean and standard deviation only for each measurement
##Creating subset of measurements on the mean and standard deviation
subFeaturesNames<-FeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", FeaturesNames$V2)]

##Subsetting data frame (Data) by selected names of Features
selectedNames<-c(as.character(subFeaturesNames), "subject", "activity" )
Data<-subset(Data,select=selectedNames)

#Naming the activities in the data set (Data) from "activity_labels.txt" file names
activityLabels <- read.table(file.path(path_rf, "activity_labels.txt"),header = FALSE)
activity <- factor(Data$activity, labels = c("WALKING","WALKING_UPTAIRS", "WALKING_DOWNSTAIRS", "SITTING","STANDING", "LAYING"))

#Changing labels to descriptive names
names(Data)<-gsub("^t", "time", names(Data))
names(Data)<-gsub("^f", "frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))

#Creating tidy data set 
library(plyr);
Data2<-aggregate(. ~subject + activity, Data, mean)
Data2<-Data2[order(Data2$subject,Data2$activity),]

#Writing output using write.table funtion to file
write.table(Data2, file = "tidydata.txt",row.name=FALSE)


