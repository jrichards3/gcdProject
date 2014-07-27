CodeBook

Assumptions
	It is assumed that the Samsung data is unzipped into the working directory. The data therefore resides in the same folder as run_analysis.R


These commands run the functions to create the dataset.
	mergedData <- merge_data("UCI HAR Dataset")
	extractedMeanStdDataSet <- extractMeanAndStd(merged_data, "UCI HAR Dataset")
	meltDataAndWriteTidySet(extractedMeanStdDataSet, "./tidyset.txt")

mergedData: the data table containing the merged training and test dataset from X_test.txt and X_train.txt. This amounts to 10299 observations with 564 columns. The columns include the 561 features stated in features.txt and added Subject, Activity Id, and Activity columns which are taken from the various activities.txt and y labels. Column headers are included.
extractedMeanStdDataSet: the data table containing 10299 observations of 69 columns. This is derived by subsetting the merged_data from above. The 69 columns include the subject, activity, activity id columns. The other 66 columns are the columns with either the characters mean() or std() in the column headers. Column headers are included.

mergeData(directory):
	
		test/X_test.txt will give us the local variable, testDataX containing all the 541 columns of raw data in the test set
		train/X_train.txt will give us the local variable, trainDataX containing all the 541 columns of raw data in the training set
		activities.txt will give us the local variable, activityLabels containing all the different types of activities: WALKING, WALKING_UPSTAIRS, SITTING, etc
		train/subject_train.txt will give us the local variable, subjectTrain containing all the possible subject data inside the training set.
		test/subject_test.txt will give us the local variable, subjectTest containing all the possible subject data inside the test set.
		train/y_train.txt will give us the local variable, yTrain containing all the possible label data inside the training set.
		test/y_test.txt will give us the local variable, yTest containing all the possible label data inside the test set.
	
	Transformations inside mergeData
	
		yTrainLabels is the merged data table of the label data based on the activity labels for training set because y_train alone tells us just 1, 2,3 when we want to have tha actual labels displayed as WALKING, etc.
		yTestLabels is the merged data table of the label data based on the activity labels for test set because y_test alone tells us just 1, 2,3 when we want to have tha actual labels displayed as WALKING, etc.
	
	trainData is the merged data table of the training data with the subject, activity, activity id, and the other 541 variables
	
	testData is the merged data table of the test data with the subject, activity, activity id, and the other 541 variables
	
	masterData is the merged version of trainData and testData

extractMeanAndStd

	features.txt will give us the local variable, featuresData containing all the 541 features and their names
	Transformations inside extractMeanAndStd
	
	meanStdRows is the subset data from the features_data where just the mean() and std() columns are extracted.
	perform a colnames() on the giant data set to have the 3 new columns and the column headers for subject, activity, and activity id
	meanColumns is the extracted data from the dataSet where the mean() columns are extracted.
	stdColumns is the extracted data from the dataSet where the std() columns are extracted.
	meanStdColumnVector is the vector containing the mean_columns and stdColumns and sorted.
	extractedDataSet is the final data table containing the mean and std columns and the 3 additional columns of Suject, Activity, and Activity Id
	
meltDataAndWriteTidySet


	meltedData is the data after performing melt on the dataSet parameter so that we can isolate down to just 66 observations.
	tidyData is the data after performing dcast on the meltedData so that we can get the mean of the related activities across the different variables of the data.
	colNamesVector is the data vector containing new formatted column headers where we replace mean() with Mean, std() with Std, and BodyBody with Body
	tidyData will then be given new column headers from colNamesVector
