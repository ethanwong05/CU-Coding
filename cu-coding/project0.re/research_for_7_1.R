# Research the Data & Problem ----
# Set WD ----
setwd("~/Desktop/cu-hsp-learning-main")

# - [] - Load Libraries ----
library(readxl)
library(corrplot)
library(ggplot2)
library(GGally)
library(caret)
library(AppliedPredictiveModeling)
library(magrittr)
library(mice)
library(outlieR)
# - [] - Source Funnctions ----
#Import the Data
data <- read_excel("data/FinalData.xlsx")

# - [] - Inspect the Data ----
str(data)

# - [] - Subset Ignoble Variables ----
sub = data[, !colnames(data) %in% c('...1', 'doc.id', 'location', 'population', 'text')]
str(sub)

# - [] - Explore the Original Data ----
summary(sub) #Summary Stats
#What we see: NA's mean impute missing,
plotter = na.omit(sub)

## - Correlation ----
cor = cor(plotter) #Omitting NA's
png("pictures/cor.png")
print(corrplot::corrplot(cor))
dev.off()

# - [] - Preprocess the Data ----
prep = sub[, !colnames(sub) %in% c('infectioncount')]
str(prep)

# - Imputing Missing ----
missing = prep %>% mice::mice(m=5,maxit=50,meth="sample",seed=500,print = FALSE)
missing <- mice::complete(missing, action=as.numeric(2))
prep = na.omit(missing)
str(prep)

# - Imputing Outliers ----
prep = prep %>% outlieR::impute(flag = NULL, fill = "mean", 
                                level = 0.1, nmax = NULL,
                                side = NULL, crit = "lof", 
                                k = 5, metric = "euclidean", q = 3)
print(str(prep))

# - Normalizing Data ----
preProClean <- preProcess(x = prep, method = c("scale", "center"))
prep <- predict(preProClean, prep %>% na.omit)
print(str(prep))
write.csv(prep, "data/prep.csv")

# - [] - Exploring the Processed Data ----
summary(prep) #Summary Stats
#What we see: NA's mean impute missing,
plotter = na.omit(prep)

## - Correlation ----
cor = cor(plotter) #Omitting NA's
png("pictures/cor_prep.png")
print(corrplot::corrplot(cor))
dev.off()

