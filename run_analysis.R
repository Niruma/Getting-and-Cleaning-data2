
# 1. Merge the training and the test sets to create one data set.

#set working directory 
setwd("~/R/R_lectures/Data_cousera/Cleaning/UCI HAR Dataset/");

# Read in the data 
features<-read.table('./features.txt',header=FALSE); 
activity<-read.table('./activity_labels.txt',header=FALSE); 


#Read data from training set
subject_train<-read.table('./train/subject_train.txt',header=FALSE); 
xtrain<-read.table('./train/X_train.txt',header=FALSE); 
ytrain<-read.table('./train/Y_train.txt',header=FALSE); 

# Set the Column names
colnames(activity)  = c('activityId','activityType');
colnames(subject_train)  = "subjectId";
colnames(xtrain)        = features[,2]; 
colnames(ytrain)        = "activityId";

#Create training data by merging ytrain, subject_train, and xtrain
trainingData = cbind(ytrain,subject_train,xtrain);
View(trainingData)

# Read test data
subject_test<- read.table('./test/subject_test.txt',header=FALSE); 
xtest<- read.table('./test/x_test.txt',header=FALSE); 
ytest<-read.table('./test/y_test.txt',header=FALSE); 

# Set Column names for test data
colnames(subject_test) = "subjectId";
colnames(xtest)       = features[,2]; 
colnames(ytest)       = "activityId";


# Create test set by merging the xTest, yTest and subjectTest 
testData = cbind(ytest,subject_test,xtest);
View(testData)


# Create final data by merging test and training data
final = rbind(trainingData,testData);
View(final)
dim(final)

# Create vector to extract id, mean, std for each measurement

# to select the desired mean() & stddev() columns
colNames  = colnames(final); 
View(colNames)

Vector=(grepl("activity",colNames)|grepl("subject",colNames)|grepl("mean",colNames)|grepl("std",colNames))

View(Vector)

final = final[Vector==TRUE];
View(final)
final = merge(final,activity,by='activityId',all.x=TRUE);
colNames  = colnames(final); 


# Cleaning up the variable names

names(final) <- gsub('-mean()', 'Mean', names(final));
names(final) <- gsub('-mean', 'Mean', names(final));
names(final) <- gsub('-std()', 'Std', names(final));
names(final) <- gsub('-std', 'Std', names(final));
names(final) <- gsub('BodyBody','Body', names(final));
View(final)

# tidy data set with the average of each variable for each activity and each subject
tidyData = aggregate(final[,names(final) != c('activityId','subjectId')],by=list(activityId=final$activityId,subjectId = final$subjectId),mean);
tidyData    = merge(tidyData,activityType,by='activityId',all.x=TRUE);
View(tidyData)

# Export the tidyData set 
write.table(tidyData, './tidyData.txt',row.names=TRUE,sep='\t');