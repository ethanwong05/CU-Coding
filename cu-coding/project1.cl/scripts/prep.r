# Remove Ignoble Variables ----
sub = data[, c("Close", "Volume")]
list_close = list(sub$Close)
sma.20 <- SMA(sub$Close, n=20)

print(paste0('Post-Subsetted values'))
print(head(sub))

#No missing Data, skipping Impute Missing
#Imputing Outliers ----
target = ifelse(sub$Close > data$Open, "Up", "Down")
sub = sub %>% outlieR::impute(flag = NULL, fill = "mean", 
                              level = 0.1, nmax = NULL,
                              side = NULL, crit = "lof", 
                              k = 5, metric = "euclidean", q = 3)
print(paste0('Values After Imputing Outliers:'))
print(head(sub))

prep = data.frame(sub, target)
colnames(prep) = c("close", "volume", "target")
print(paste0('Prepared data:'))
head(prep)
print(paste0('Now, all we have to do is balance it.'))
#Auto Balancing ----
target = c("target") # choose the target variable...
prep[,c(target)] = as.factor(prep[,c(target)])
formula = as.formula(paste(target, "~."))
noise = GE(formula, data = prep, k = 5, kk = ceiling(5/2))
data = noise$cleanData

#Normalizing Data ----
preProClean <- preProcess(x = prep, method = c("scale", "center", "corr"))
data <- predict(preProClean, prep %>% na.omit)
print(paste0('Final Values Written into the csv file:'))
print(head(prep))

#Creating a csv file ----
write.csv(prep,"data/prep.csv")