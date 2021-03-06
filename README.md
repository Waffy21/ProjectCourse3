---
title: "README"
output: pdf_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

## R Markdown


```{r README}

library(plyr)
library(dplyr)

##First of all, we import the data from the textfiles

activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
X_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
X_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
features <- read.table("UCI HAR Dataset/features.txt")

##Combine the data frames in order to reduce the number of data frames to work with
subject <- rbind(subject_test, subject_train)
col_y <- rbind(y_test,y_train)
activity <- join(col_y, activity_labels)

##Eliminate the first column of activity because it is not neccesary
activity$V1 <- NULL

##Rename the first column of activity as activities
names(activity)[1]<-"activities"

##Put together the two files of X
X_body <- rbind(X_test,X_train)

##Change the class of the second column of features to character in order to filter it easily
features$V2 <- as.character(features$V2)

##Filter the second column of features with the vector patterns
patterns <- c("std()", "mean()")
result <- filter(features, grepl(paste(patterns, collapse="|"), V2))

##Rename the columns of X_body that match in number with the rows of features, so we have now
##the columns with mean() and std() values
for(i in 1:ncol(X_body)){
  if((i %in% result$V1)==TRUE){
    names(X_body)[i] <- result[result$V1==i,]$V2
  }
}

##If we do not need the column, we fill it with NA
for(i in 1:ncol(X_body)){
  if((sum(sapply(patterns, grepl, names(X_body)[i])))==0){
    X_body[,i]<-NA
  }else{
    
  }
}


##Delete the columns we do not need (because does not have mean() or std())
X_body_final <- X_body[, colSums(is.na(X_body)) != nrow(X_body)]

##Combine the data frames, adding the column activity to the data frame X_body_final
bodyWithActivity<-cbind(activity,X_body_final)

##Combine the data frames, adding the column subject to the data frame bodyWithActivity
main_body <- cbind(subject,bodyWithActivity)

##Rename the first column to make it understandable
names(main_body)[1]<-"subject"


##Calculate the mean by subject and activity
final_result <- aggregate(x = main_body[c(3:81)],
                          by = main_body[c("subject", "activities")],
                          FUN = mean)

write.table(final_result, file= "final_table.txt",row.names = FALSE)

```

