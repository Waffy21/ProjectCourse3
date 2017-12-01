library(plyr)
library(dplyr)

activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")

subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
X_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")


subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
X_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")


features <- read.table("UCI HAR Dataset/features.txt")


subject <- rbind(subject_test, subject_train)
col_y <- rbind(y_test,y_train)
activity <- join(col_y, activity_labels)
activity$V1 <- NULL
names(activity)[1]<-"activities"
X_body <- rbind(X_test,X_train)

features$V2 <- as.character(features$V2)

patterns <- c("std()", "mean()")
result <- filter(features, grepl(paste(patterns, collapse="|"), V2))

for(i in 1:ncol(X_body)){
  if((i %in% result$V1)==TRUE){
    names(X_body)[i] <- result[result$V1==i,]$V2
  }
}

for(i in 1:ncol(X_body)){
  if((sum(sapply(patterns, grepl, names(X_body)[i])))==0){
    X_body[,i]<-NA
  }else{
    
  }
}


X_body_final <- X_body[, colSums(is.na(X_body)) != nrow(X_body)]


bodyWithActivity<-cbind(activity,X_body_final)
main_body <- cbind(subject,bodyWithActivity)
names(main_body)[1]<-"subject"



final_result <- aggregate(x = main_body[c(3:81)],
                          by = main_body[c("subject", "activities")],
                          FUN = mean)

write.table(final_result, file= "final_table.txt",row.names = FALSE)