# 
#  The purpose is to collect, merge and produce a clean set of data
#
#  Data to be processed should be in  \UCI HAR Dataset from run_analysis.R
#
#

# merge the data
mergeData <- function(directory) {
    # read the X datasets
    path <- paste("./", directory, "/test/X_test.txt", sep="")
    testDataX <- read.table(path)
    path <- paste("./", directory, "/train/X_train.txt", sep="")
    trainDataX <- read.table(path)
    
    # read the activity labels
    path <- paste("./", directory, "/activity_labels.txt", sep="")
    activityLabels <- read.table(path)
    
    # read the subject labels
    path <- paste("./", directory, "/train/subject_train.txt", sep="")
    subjectTrain <- read.table(path)
    path <- paste("./", directory, "/test/subject_test.txt", sep="")
    subjectTest <- read.table(path)
    
    # read the y labels
    path <- paste("./", directory, "/train/y_train.txt", sep="")
    trainDataY <- read.table(path)
    path <- paste("./", directory, "/test/y_test.txt", sep="")
    testDataY <- read.table(path)
    
    # merge y activity labels
    trainDataYLabels <- merge(trainDataY,activityLabels,by="V1")
    testDataYLabels <- merge(testDataY,activityLabels,by="V1")
    
    # merge the data and the respective labels together
    trainDataX <- cbind(subjectTrain,trainDataYLabels,trainDataX)
    testDataX <- cbind(subjectTest,testDataYLabels,testDataX)
    
    # now then we'll merge the test and training data together
    masterData <- rbind(trainDataX,testDataX)
    
    return (masterData)
}

# Extract only the mean and standard deviation for each measurement

extractMeanAndStd <- function(dataSet, directory) {
    path <- paste("./", directory, "/features.txt", sep="")
    featuresData <- read.table(path)
    meanAndStdRows <- subset(featuresData,  grepl("(mean\\(\\)|std\\(\\))", featuresData$V2) )
    
    # set the column headers
    colnames(dataSet) <- c("Subject","Activity_Id","Activity",as.vector(featuresData[,2]))
    
    # extract the data from the merged data where the column names are mean OR std
    meanColumns <- grep("mean()", colnames(dataSet), fixed=TRUE)
    stdColumns <- grep("std()", colnames(dataSet), fixed=TRUE)
    
    # put both mean and std columns into single vector
    meanStdColumnVector <- c(meanColumns, stdColumns)
    
    # sort the vector 
    meanStdColumnVector <- sort(meanStdColumnVector)
    
    # extract the columns with std and mean in their column headers
    extractedDataSet <- dataSet[,c(1,2,3,meanStdColumnVector)]
    return (extractedDataSet)
}


meltDataAndWriteTidySet <- function(dataSet, pathToTidysetFile) {
    # let's melt the data
    require(reshape2)
    meltedData <- melt(dataSet, id=c("Subject","Activity_Id","Activity"))
    
    # cast the data back to the tidyData format
    tidyData <- dcast(meltedData, formula = Subject + Activity_Id + Activity ~ variable, mean)
    
    # format the column names
    colNamesVector <- colnames(tidyData)
    colNamesVector <- gsub("-mean()","Mean",colNamesVector,fixed=TRUE)
    colNamesVector <- gsub("-std()","Std",colNamesVector,fixed=TRUE)
    colNamesVector <- gsub("BodyBody","Body",colNamesVector,fixed=TRUE)
    
    # put back in the tidy column names
    colnames(tidyData) <- colNamesVector
    
    # write the output into a file
    write.table(tidyData, file=pathToTidysetFile, sep="\t", row.names=FALSE)
}

mergedData <- mergeData("UCI HAR Dataset")
extractedMeanStdDataSet <- extractMeanAndStd(mergedData, "UCI HAR Dataset")
meltDataAndWriteTidySet(extractedMeanStdDataSet, "./tidyset.txt")
