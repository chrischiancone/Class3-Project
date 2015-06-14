#Credits, Google!
#Begin*************************************************************************************************************************

#****Set Working Directory*************************************************************
DataWorkingDir <- "~/Dropbox/R/Class3/Project/Class Project/Data/UCI Data"

#*****Load Packages for Project********************************************************
library(RCurl)

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
#*****Merge the data*******************************************************************
print("Merging Files")
merge_x <- rbind(x_train, x_test)
merge_subj <- rbind(sub_train, sub_test)
merge_y <- rbind(y_train, y_test)
print("Merged Files")
#*****Remove unneeded files************************************************************
print("Removing Unnessesary Files")
rm("x_train")
rm("y_train")
rm("x_test")
rm("y_test")
rm("sub_train")
rm("sub_test")
print("Removed Unnessesary Files")
#*****SD & Mean***********************************************************************
print("Pulling the SD & Mean")
sd_mean <- grep("-mean\\(\\)|-std\\(\\)", features[, 2])
sd_mean_x <- merge_x[, sd_mean]
print("Pulled Standard Deviation and Mean")

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

#*****Write the Data File*************************************************************
print("Writting Files to Folder")
#write.table(data, "~/Dropbox/R/Class3/Project/Data/Output/data.txt", row.names = F)
write.table(average, "~/Dropbox/R/Class3/Project/Class Project/Output/tiny_average.txt", row.names = F)
print("R Script Complete")

#End****************************************************************************************************************************

