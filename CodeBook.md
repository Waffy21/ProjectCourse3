---
title: "CodeBook"
output: pdf_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

## R Markdown

The variables used in the script are:

```{r run_analysis}




activity_labels: import of activity_labels.txt

subject_test: import of subject_test.txt
X_test: import of X_test.txt
y_test: import of y_test.txt <- read.table("UCI HAR Dataset/test/y_test.txt")


subject_train: import of subject_train.txt
X_train: import of X_train.txt
y_train: import of y_train.txt 


features: import of features.txt <- read.table("UCI HAR Dataset/features.txt")


subject: data frame produced by the union of subject_test and subject_train
col_y: data frame produced by the union of y_test and y_train
activity: data frame produced by the merge of col_y and activity_labels 


X_body: data frame produced by the union of X_test and X_train <- rbind(X_test,X_train)

patterns: vector with the characters we want to filter by (std() and mean())
result: data frame created by the filtration of the data frame features by patterns

X_body_final: same data frame as X_body, but filtered with the columns we want (with means and std)

bodyWithActivity: data frame produced by the union of activity and X_body_final
main_body: data frame produced by the union of subject and bodyWithActivity


final_result: data frame with average calculated by subject and activity 

```
