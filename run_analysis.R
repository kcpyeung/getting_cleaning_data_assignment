#prepare data

activity_name_lookup <- read.table("activity_labels.txt")
names(activity_name_lookup) <- c("id", "activity")

features <- read.table("features.txt")
feature_names <- t(features["V2"])
feature_names <- feature_names[,c(1:6,41:46,81:86,121:126,161:166,201:202,214:215,227:228,240:241,253:254,266:271,345:350,424:429,503:504,516:517,529:530,542:543)]
feature_names <- t(as.matrix(feature_names))
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

# compute average
subjects_activities <- unique(mean_std[, 1:2])
x <- data.frame()

compute_average <- function(subject_activity) {
  subject_activity_data_rows <- subset(mean_std, subject == subject_activity[1,1] & activity == subject_activity[1,2])
  subject_activity_data_rows <- subject_activity_data_rows[, 3:ncol(subject_activity_data_rows)]
  averaged <- apply(subject_activity_data_rows, 2, mean)
  averaged <- t(as.matrix(averaged))
  labelled_averaged <- cbind(subject_activity, averaged)
  x <- rbind(x, labelled_averaged)
}

subject_activity_averages <- by(subjects_activities, 1:nrow(subjects_activities), compute_average)
subject_activity_averages <- Reduce(function(...) merge(..., all=T), subject_activity_averages)

rm(x)
rm(subjects_activities)
rm(compute_average)

write.table(subject_activity_averages, file="subject_activity_averages.txt", row.names=FALSE)
