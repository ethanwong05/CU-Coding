# Research the Data & Problem ----
# Set WD ----
setwd("C:/Users/jonat/Desktop/project.hsp")
# Load Libraries ----
library(readxl)
library(GGally)
library(AppliedPredictiveModeling)
library(mice)
library(magrittr)
library(outlieR)
# Source Functions ----
# Import the Data
data <- read_excel("data/FinalData.xlsx")
# Inspect the Data ----
str(data)
#View(data)
# Subset Ignoble Variables ----
sub = data[, !colnames(data) %in% c('...1','doc.id','location','population','text')]
str(sub)
# Explore the Original Data ----
summary(sub) # summary stats 
plot = na.omit(sub)
cor = cor(plot) # correlation 
png("pictures/cor.png")
print(corrplot::corrplot(cor))    
dev.off() 
# - Preprocess the Data ----
prep = sub[, !colnames(sub) %in% c('infectioncount')]
str(prep)
missing = prep %>% mice::mice(m=5,maxit=50,meth="sample",seed=500,print = FALSE)
missing <- mice::complete(missing, action=as.numeric(2))
prep = na.omit(missing)
prep = prep %>% outlieR::impute(flag = NULL, fill = "mean", 
                                level = 0.1, nmax = NULL,
                                side = NULL, crit = "lof", 
                                k = 5, metric = "euclidean", q = 3)
preProClean <- preProcess(x = prep, method = c("scale", "center"))
prep <- predict(preProClean, prep %>% na.omit)
print(str(prep))
write.csv(prep,"data/prep.csv")
# Exploration of the Processed ----
summary(prep) # summary stats 
plot = na.omit(prep)
cor = cor(plot) # correlation 
png("pictures/cor_prep.png")
print(corrplot::corrplot(cor))    
dev.off() 
# Modeling ----