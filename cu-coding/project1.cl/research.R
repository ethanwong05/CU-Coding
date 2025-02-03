# - Research Classifier Project ----

# - [1] - Setting Working Directory ----
setwd("~/Desktop/project1.cl")

# - [2] - Load the Libraries ----
library(quantmod)
library(remotes)
library(corrplot)
library(cowplot)
library(ggplot2)
library(outlieR)
library(magrittr)
library(NoiseFiltersR)
library(caret)
library(TTR)


# - [3] - Import the Data ----
source("data/api.instructions/src/gquote.R")

# Making a daily request
start <- as.Date(Sys.Date()-(365*5)) # start date. 
end <- as.Date(Sys.Date()) # current date. 
getSymbols("GOOG", src = "yahoo", from = start, to = end) # Feed symbol from s&p500. 
data = GOOG # call xts object into env. 
colnames(data) = c("Open", "High", "Low", "Close", "Volume", "Adjusted") # set column names in xts object. 
str(data)

# - [4] - Explore the Original ----
#Summarizing data ----
summary(data)

#Visualizing the data ----
#Line Plot

p1 = ggplot(data, aes(x =index(data), y= Close)) + geom_line() + ggtitle("Close Price")
p2 = ggplot(data, aes(x = index(data), y = Open)) + geom_line() + ggtitle("Open Price")
p3 = ggplot(data, aes(x = index(data), y = Low)) + geom_line() + ggtitle("Low Price")
p4 = ggplot(data, aes(x = index(data), y = High)) + geom_line() + ggtitle("High Price")
png("pictures/grid_line.png")
print(plot_grid(p1, p2, p3, p4))    
dev.off()

#Correlation Matrix
cor = cor(data) # inputs must be in numeric data type...
png("pictures/cor_original.png")
print(corrplot::corrplot(cor))    
dev.off()
#Oop, everything is very correlated.
#We should subset some of these...

# - [5] - Preprocess the Data ----
# Remove Ignoble Variables ----
sub = data[, c("Close", "Volume")]
str(sub)
head(sub)

sub = data[,c("Close", "Volume")]
sma.20 <- SMA(sub, n=20)


#No missing Data, skipping Impute Missing
#Imputing Outliers ----
sub = sub %>% outlieR::impute(flag = NULL, fill = "mean", 
                                level = 0.1, nmax = NULL,
                                side = NULL, crit = "lof", 
                                k = 5, metric = "euclidean", q = 3)
print(str(sub))

target = ifelse(sub$Close > data$Open, "Up", "Down")
prep = data.frame(sub, target)
colnames(prep) = c("close", "volume", "target")
str(prep)
head(prep)

#Auto Balancing ----
target = c("target") # choose the target variable...
prep[,c(target)] = as.factor(prep[,c(target)])
formula = as.formula(target, ".")
noise = GE(formula, data = prep, k = 5, kk = ceiling(5/2))
data = noise$cleanData
str(prep)

#Normalizing Data ----
preProClean <- preProcess(x = prep, method = c("scale", "center", "corr"))
data <- predict(preProClean, prep %>% na.omit)
print(str(prep))

# - [6] - Explore the Prep ----
Dates = index(prep)
p1 = ggplot(data, aes(x =index(data), y= close)) + geom_line() + ggtitle("Close Price")
p2 = ggplot(data, aes(x =index(data), y= volume)) + geom_line() + ggtitle("Volume Price")
png("pictures/grid_line_P.png")
print(plot_grid(p1, p2))
dev.off()

cor = cor(prep[,c(-3)])
png("pictures/cor_P.png")
print(corrplot::corrplot(cor))
dev.off()