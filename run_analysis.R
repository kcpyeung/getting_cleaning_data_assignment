activity_name_lookup <- read.table("activity_labels.txt")
names(activity_name_lookup) <- c("id", "activity")

features <- read.table("features.txt")
feature_names <- t(features["V2"])
feature_names <- cbind(c("activity"), feature_names)
feature_names <- cbind(c("row_id"), feature_names)
feature_names <- cbind(c("activity_id"), feature_names)
feature_names <- cbind(c("subject"), feature_names)
rm(features)

test <- read.table("test/X_test.txt")
test_activity_labels <- read.table("test/y_test.txt")
names(test_activity_labels) <- c("id")
test_activity_labels <- data.frame(test_activity_labels,rowid=seq_len(nrow(test_activity_labels)))
test_activity_names <- merge(test_activity_labels, activity_name_lookup, sort=FALSE)
test_activity_names <- test_activity_names[order(test_activity_names$rowid),]
test_results <- cbind(test_activity_names, test)
rm(test)
rm(test_activity_labels)
rm(test_activity_names)
subject_test <- read.table("test/subject_test.txt")
names(subject_test) <- c("subject")
test_results <- cbind(subject_test, test_results)

train <- read.table("train/X_train.txt")
train_activity_labels <- read.table("train/y_train.txt")
names(train_activity_labels) <- c("id")
train_activity_labels <- data.frame(train_activity_labels,rowid=seq_len(nrow(train_activity_labels)))
train_activity_names <- merge(train_activity_labels, activity_name_lookup, sort=FALSE)
train_activity_names <- train_activity_names[order(train_activity_names$rowid),]
train_results <- cbind(train_activity_names, train)
rm(train)
rm(train_activity_labels)
rm(train_activity_names)
subject_train <- read.table("train/subject_train.txt")
names(subject_train) <- c("subject")
train_results <- cbind(subject_train, train_results)

names(test_results) <- feature_names
names(train_results) <- feature_names

all <- rbind(test_results, train_results)
rm(activity_name_lookup)

feature_names <- feature_names[, -(2:3)]
feature_names <- as.matrix(feature_names)
feature_names <- t(feature_names)

mean_std <- all[, feature_names]

rm(feature_names)
rm(all)
rm(test_results)
rm(train_results)
rm(subject_test)
rm(subject_train)

