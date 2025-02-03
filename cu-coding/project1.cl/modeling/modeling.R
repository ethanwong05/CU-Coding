################################################################################

dir = getwd()
setwd(dir)
libraries()

################################################################################

prep <- read_csv("data/prep.csv")
prep <- data.frame(prep[,-1])

################################################################################

index = createDataPartition(prep[,1], p =0.85, list = FALSE)
training = prep[index,]
valid = prep[-index,]
print(paste0("Training Data Dimensions...", dim(training)))
print(paste0("Validation Data Dimensions...",dim(valid)))
control <- trainControl(method="cv", number=10)
metric <- "Accuracy"
set.seed(7)
fit.rpart <- train(target~., data = training, method="rpart", metric=metric, trControl=control)
fit.rpart
plot(fit.rpart$finalModel, uniform=TRUE,
     main="Classification Tree")
text(fit.rpart$finalModel, use.n.=TRUE, all=TRUE, cex=.8)
data.pred = predict(fit.rpart, newdata = valid)
cm = confusionMatrix(as.factor(data.pred), reference = as.factor(valid$target), mode = "prec_recall")
print(cm)