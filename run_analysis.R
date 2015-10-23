activity_name_lookup <- read.table("activity_labels.txt")
names(activity_name_lookup) <- c("id", "activity")

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

all <- rbind(test_results, train_results)
#all <- merge(test_results, train_results, all=TRUE)
rm(activity_name_lookup)

mean_std <- all[,c("activity", "V1","V2","V3","V4","V5","V6","V41","V42","V43","V44","V45","V46","V81","V82","V83","V84","V85","V86","V121","V122","V123","V124","V125","V126","V161","V162","V163","V164","V165","V166","V201","V202","V214","V215","V227","V228","V240","V241","V253","V254","V266","V267","V268","V269","V270","V271","V345","V346","V347","V348","V349","V350","V424","V425","V426","V427","V428","V429","V503","V504","V516","V517","V529","V530","V542","V543")]

rm(all)
rm(test_results)
rm(train_results)


