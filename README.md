# Getting-Clean-Data
#Credits, Many thanks to Google, without I would have been stuck!
This is there the R application begins. If you are on a MAc, you need to install RCurl from CRAN (install.oackages("RCurl"")
#Begin*************************************************************************************************************************

I decided due to the amount of files to be read, to break up the folder with Data and Output files.The DataWorkingDir sets a variable to read the location of the UCI raw data.

#****Set Working Directory*************************************************************
DataWorkingDir <- "~/Dropbox/R/Class3/Project/Data/UCI Data"

This is where you envoke the RCUL library after it has been installed
#*****Load Packages for Project********************************************************
library(RCurl)

First we ket the data into variables by using the read.table function. More information on read.table is avaliable by entering ?read.table. The information that is loaded is both the training sets and test data from the accelerometer and gyroscope outputs, as-well-as, the features and activities.
#*****Load files, train and test********************************************************
print("Loading Files")
x_train <- read.table(file.path(DataWorkingDir , "train", "X_train.txt" ))
x_test <- read.table(file.path(DataWorkingDir , "test", "X_test.txt"))
sub_train <- read.table(file.path(DataWorkingDir , "train", "subject_train.txt" ))
sub_test <- read.table(file.path(DataWorkingDir , "test", "subject_test.txt"))
y_train <- read.table(file.path(DataWorkingDir , "train", "y_train.txt" ))
y_test <- read.table(file.path(DataWorkingDir , "test", "y_test.txt"))
features <- read.table(file.path(DataWorkingDir ,"features.txt"))
activities <- read.table(file.path(DataWorkingDir ,"activity_labels.txt"))
print("Loaded Files")

We have to merge the x,y,and subject test and training data sets into thier respective groupings. This allows for both test and train data to coexist in each variable.
#*****Merge the data*******************************************************************
print("Merging Files")
merge_x <- rbind(x_train, x_test)
merge_subj <- rbind(sub_train, sub_test)
merge_y <- rbind(y_train, y_test)
print("Merged Files")

To save some memory, I remove the unneded variables needed to develop the merged groups.
#*****Remove unneeded files************************************************************
print("Removing Unnessesary Files")
rm("x_train")
rm("y_train")
rm("x_test")
rm("y_test")
rm("sub_train")
rm("sub_test")
print("Removed Unnessesary Files")

We have to select the data in the text needed for analysis. here we use the grep function to grab the information needed.
#*****SD & Mean***********************************************************************
print("Pulling Information")
sd_mean <- grep("-mean\\(\\)|-std\\(\\)", features[, 2])
sd_mean_x <- merge_x[, sd_mean]
print("Pulled Standard Deviation and Mean")
We need append and merge data together to process the requests, as-well-as, creating meaningful column names
#*****Condition names,Aggrigate Data and Rename Rows**********************************
print("Starting to Condition Data")
names(sd_mean_x) <- features[sd_mean, 2]
names(sd_mean_x) <- tolower(names(sd_mean_x)) 
names(sd_mean_x) <- gsub("\\(|\\)", "", names(sd_mean_x))
activities[, 2] <- tolower(as.character(activities[, 2]))
activities[, 2] <- gsub("_", " ", activities[, 2])
merge_y[, 1] = activities[merge_y[, 1], 2]
colnames(merge_y) <- 'ACTIVITY'
colnames(merge_subj) <- 'SUBJECT'
data <- cbind(merge_subj, sd_mean_x, merge_y)
average <- aggregate(x=data, by=list(activities=data$ACTIVITY, merge_subj=data$SUBJECT), FUN=mean)
average <- average[, !(colnames(average) %in% c("merge_subj", "activity"))]
print("Conditioned Data")

After the data is conditioned and the avarages are computated, we write results into a txt file
#*****Write the Data File*************************************************************
print("Writting Files to Folder")
write.table(average, "~/Dropbox/R/Class3/Project/Class Project/Output/tiny_average.txt")
print("R Script Complete")

**Note: I added the print statements to allow me to see where the application was in the process and troubleshooting. These can be removed.
#End****************************************************************************************************************************

The application can be run by typing source("run_analysys.R")