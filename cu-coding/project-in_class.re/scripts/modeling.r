################################################################################
setwd("C://Users//wongs//Desktop//cu-coding//project-in_class.re")# Load Libraries ----
dir = getwd()
setwd(dir)
libraries()

################################################################################

prep <- read_csv("data/prep.csv")
prep <- data.frame(prep[,-1])

################################################################################

control <- trainControl(method="cv", number=10)
metric <- "RMSE"
set.seed(7)
fit.LM <- train(retail~., data = train, method = "lm", trControl=control, metric=metric)
print(paste0("Results of Model 1~ LM."))
print(summary(fit.LM$resample))
print(fit.LM$results)
print(fit.LM$resample)
predictedValues<-predict(fit.LM, valid)
modelvalues<-data.frame(obs = valid$retail, pred=predictedValues)
print(postResample(pred = predictedValues, obs = valid$retail))
importance <- varImp(fit.LM, scale=TRUE)
print(importance)
vi.LM = plot(importance)
png("pictures/fit.lm_importance.png")
print(plot(importance))    
dev.off() 

################################################################################

control <- trainControl(method="cv", number=10)
metric <- "RMSE"
set.seed(7)
fit.bayesglm <- train(retail~., data = train, method = "bayesglm", trControl=control, metric=metric)
print(paste0("Results of Model 1~ bayesglm."))
print(summary(fit.bayesglm$resample))
print(fit.bayesglm$results)
print(fit.bayesglm$resample)
predictedValues<-predict(fit.bayesglm, valid)
modelvalues<-data.frame(obs = valid$retail, pred=predictedValues)
print(postResample(pred = predictedValues, obs = valid$retail))
importance <- varImp(fit.bayesglm, scale=TRUE)
print(importance)
vi.bayesglm = plot(importance)
png("pictures/fit.bayesglm_importance.png")
print(plot(importance))    
dev.off() 

