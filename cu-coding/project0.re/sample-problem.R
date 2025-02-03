# - [Title] - Sample Problem ----

# - [1] - Load Libraries ----
library(datasets)
library(pastecs)
library(Hmisc)
library(psych)
library(ggplot2)
install.packages('GGally')
library(GGally)
install.packages('AppliedPredictiveModeling')
library(AppliedPredictiveModeling)
install.packages('cowplot')
library(cowplot)
library(corrplot)
library(caret)
library(outlieR)
library(magrittr)

# - [2] - Importing the Data ----
data(iris)
data = iris

# - [3] - Explore the Original Data ----
## - [a] - Summary of Stats ----
#Capture Summary Stats — breakdown on all of the data in the dataset:
summary(data) 

#Different data analysis methods:
stat.desc(data)

Hmisc::describe(data)
#Represents that there is no missing, and that the proportions are right
#This means that you don't have to balance or impute missing

psych::describe(data)
#This double colon shows which package we're calling when we are using the function

## - [b] - Correlation ----
cor = cor(data[,c(1:4)])
print(cor)
#Creates a correlation matrix, from a scale of -1 to 1
#Greater than 0.90 = High correlation, you can subset that out

## - [c] - Visualizing the Original Data ----
### - Main Scatterplot ----
p = ggplot(data, aes(Sepal.Width, Sepal.Length)) +
  geom_jitter(aes(color = Species)) +
  geom_smooth(method = 'lm', color = 'black') +
  xlab('X Variable') +
  ylab('Y Variable')
p

cleanup = theme(panel.grid.major = element_blank(),
                panel.grid.minor = element_blank(),
                panel.background = element_blank(),
                axis.line.x = element_line(color = 'black'),
                axis.line.y = element_line(color = 'black'),
                legend.key = element_rect(fill = 'white'),
                text = element_text(size = 15))
p + cleanup

png("./pictures/mainscatter.png")
print(p)
dev.off()

### - Optional Scatterplot
with(data, qplot(data[,1], data[,2], colour=data[,ncol(data)], cex=0.2))

### - Optional Scatterplot Matrix ----
ggpairs(data, title = 'Sample Iris Data')
#Has a limitation: Cannot handle too many variables.

# - (Other) Optional Scatterplot Matrix ----
transparentTheme(trans = .4)
featurePlot(x = data[, 1:4], 
            y = data$Species, 
            plot = "pairs",
            ## Add a key at the top
            auto.key = list(columns = 3))

#### - Histogram ----
# - HSW
p1 = ggplot(data, aes(Sepal.Width,color = Species)) + 
  geom_histogram(binwidth = 0.4) + 
  xlab("X Variable") + 
  ylab("Frequency")
p1

# - HPW
p2 = ggplot(data, aes(Petal.Width,color = Species)) + 
  geom_histogram(binwidth = 0.4) + 
  xlab("Petal.Width") + 
  ylab("Frequency")
p2
# - HPL
p3 = ggplot(data, aes(Petal.Length,color = Species)) + 
  geom_histogram(binwidth = 0.4) + 
  xlab("Petal.Length") + 
  ylab("Frequency")
p3
# - HSL
p4 = ggplot(data, aes(Sepal.Length,color = Species)) + 
  geom_histogram(binwidth = 0.4) + 
  xlab("Sepal.Length") + 
  ylab("Frequency")
p4
plot_grid(p1,p2,p3,p4)

### - Correlation Plot
cor = cor(data[,c(1:4)]) # inputs must be in numeric data type...
#install.packages('corrplot')
corrplot::corrplot(cor)

# - Bar plot ----
p1 = ggplot(data, aes(Species, Sepal.Length)) +
  stat_summary(fun.y = mean,
               geom = "bar",
               fill = "White", 
               color = "Black") + 
  stat_summary(fun.data = mean_cl_normal, 
               geom = "errorbar", 
               position = position_dodge(width = 0.90), 
               width = 0.2) + 
  xlab('X Variable')+
  ylab('Y Variable')
p1
p2 = ggplot(data, aes(Species, Sepal.Width)) +
  stat_summary(fun.y = mean,
               geom = "bar",
               fill = "White", 
               color = "Black") + 
  stat_summary(fun.data = mean_cl_normal, 
               geom = "errorbar", 
               position = position_dodge(width = 0.90), 
               width = 0.2) + 
  xlab('X Variable')+
  ylab('Y Variable')
p2

p3 = ggplot(data, aes(Species, Petal.Length)) +
  stat_summary(fun.y = mean,
               geom = "bar",
               fill = "White", 
               color = "Black") + 
  stat_summary(fun.data = mean_cl_normal, 
               geom = "errorbar", 
               position = position_dodge(width = 0.90), 
               width = 0.2) + 
  xlab('X Variable')+
  ylab('Y Variable')
p3

p4 = ggplot(data, aes(Species, Petal.Width)) +
  stat_summary(fun.y = mean,
               geom = "bar",
               fill = "White", 
               color = "Black") + 
  stat_summary(fun.data = mean_cl_normal, 
               geom = "errorbar", 
               position = position_dodge(width = 0.90), 
               width = 0.2) + 
  xlab('X Variable')+
  ylab('Y Variable')
p4
plot_grid(p1,p2,p3,p4)

# - Box plot ----
featurePlot(x = data[, 1:4], 
            y = data$Species, 
            plot = "box", 
            ## Pass in options to bwplot() 
            scales = list(y = list(relation="free"),
                          x = list(rot = 90)),  
            layout = c(4,1 ), 
            auto.key = list(columns = 2))

# - Density plot ---- 
#Kinda like a histogram that shows distribution, but cooler
transparentTheme(trans = .9)
featurePlot(x = data[, 1:4], 
            y = data$Species,
            plot = "density", 
            ## Pass in options to xyplot() to 
            ## make it prettier
            scales = list(x = list(relation="free"), 
                          y = list(relation="free")), 
            adjust = 1.5, 
            pch = "|", 
            layout = c(4, 1), 
            auto.key = list(columns = 3))

# - Line Plots ----
#To show trends
p1 = ggplot(data, aes(Species, Sepal.Length)) +
  stat_summary(fun.y = mean, ##adds the points
               geom = "point") +
  stat_summary(fun.y = mean, ##adds the line
               geom = "line",
               aes(group=1)) +
  stat_summary(fun.data = mean_cl_normal, ##adds the error bars
               geom = "errorbar", 
               width = .2) +
  xlab('X Variable')+
  ylab('Y Variable')
p1
p2 = ggplot(data, aes(Species, Sepal.Width)) +
  stat_summary(fun.y = mean, ##adds the points
               geom = "point") +
  stat_summary(fun.y = mean, ##adds the line
               geom = "line",
               aes(group=1)) +
  stat_summary(fun.data = mean_cl_normal, ##adds the error bars
               geom = "errorbar", 
               width = .2) +
  xlab('X Variable')+
  ylab('Y Variable')
p2
plot_grid(p1,p2)

# - [] - Preprocessing ----
#Needs: Imputing Outliers, Data normalization 

## - Imputing Outliers ----
out = data[,1:4]
out = out %>% outlieR::impute(flag = NULL, fill = "mean", 
                                level = 0.1, nmax = NULL,
                                side = NULL, crit = "lof", 
                                k = 5, metric = "euclidean", q = 3)
data = data.frame(out, Species = data[,5])
print(str(data))

## - Normalizing data ----
preProClean <- preProcess(x = data, method = c("scale", "center"))
data <- predict(preProClean, data %>% na.omit)
print(str(data))

# - [] - Exploring the Processed Data ----
## - [a] - Visualizing the Processed Data ----
### - Main Scatterplot ----
p = ggplot(data, aes(Sepal.Width, Sepal.Length)) +
  geom_jitter(aes(color = Species)) +
  geom_smooth(method = 'lm', color = 'black') +
  xlab('X Variable') +
  ylab('Y Variable')
p

cleanup = theme(panel.grid.major = element_blank(),
                panel.grid.minor = element_blank(),
                panel.background = element_blank(),
                axis.line.x = element_line(color = 'black'),
                axis.line.y = element_line(color = 'black'),
                legend.key = element_rect(fill = 'white'),
                text = element_text(size = 15))
p + cleanup

### - Optional Scatterplot
with(data, qplot(data[,1], data[,2], colour=data[,ncol(data)], cex=0.2))

### - Optional Scatterplot Matrix ----
ggpairs(data, title = 'Sample Iris Data')
#Has a limitation: Cannot handle too many variables.

# - (Other) Optional Scatterplot Matrix ----
transparentTheme(trans = .4)
featurePlot(x = data[, 1:4], 
            y = data$Species, 
            plot = "pairs",
            ## Add a key at the top
            auto.key = list(columns = 3))

#### - Histogram ----
# - HSW
p1 = ggplot(data, aes(Sepal.Width,color = Species)) + 
  geom_histogram(binwidth = 0.4) + 
  xlab("X Variable") + 
  ylab("Frequency")
p1

# - HPW
p2 = ggplot(data, aes(Petal.Width,color = Species)) + 
  geom_histogram(binwidth = 0.4) + 
  xlab("Petal.Width") + 
  ylab("Frequency")
p2
# - HPL
p3 = ggplot(data, aes(Petal.Length,color = Species)) + 
  geom_histogram(binwidth = 0.4) + 
  xlab("Petal.Length") + 
  ylab("Frequency")
p3
# - HSL
p4 = ggplot(data, aes(Sepal.Length,color = Species)) + 
  geom_histogram(binwidth = 0.4) + 
  xlab("Sepal.Length") + 
  ylab("Frequency")
p4
plot_grid(p1,p2,p3,p4)

### - Correlation Plot
cor = cor(data[,c(1:4)]) # inputs must be in numeric data type...
#install.packages('corrplot')
corrplot::corrplot(cor)

# - Bar plot ----
p1 = ggplot(data, aes(Species, Sepal.Length)) +
  stat_summary(fun.y = mean,
               geom = "bar",
               fill = "White", 
               color = "Black") + 
  stat_summary(fun.data = mean_cl_normal, 
               geom = "errorbar", 
               position = position_dodge(width = 0.90), 
               width = 0.2) + 
  xlab('X Variable')+
  ylab('Y Variable')
p1
p2 = ggplot(data, aes(Species, Sepal.Width)) +
  stat_summary(fun.y = mean,
               geom = "bar",
               fill = "White", 
               color = "Black") + 
  stat_summary(fun.data = mean_cl_normal, 
               geom = "errorbar", 
               position = position_dodge(width = 0.90), 
               width = 0.2) + 
  xlab('X Variable')+
  ylab('Y Variable')
p2

p3 = ggplot(data, aes(Species, Petal.Length)) +
  stat_summary(fun.y = mean,
               geom = "bar",
               fill = "White", 
               color = "Black") + 
  stat_summary(fun.data = mean_cl_normal, 
               geom = "errorbar", 
               position = position_dodge(width = 0.90), 
               width = 0.2) + 
  xlab('X Variable')+
  ylab('Y Variable')
p3

p4 = ggplot(data, aes(Species, Petal.Width)) +
  stat_summary(fun.y = mean,
               geom = "bar",
               fill = "White", 
               color = "Black") + 
  stat_summary(fun.data = mean_cl_normal, 
               geom = "errorbar", 
               position = position_dodge(width = 0.90), 
               width = 0.2) + 
  xlab('X Variable')+
  ylab('Y Variable')
p4
plot_grid(p1,p2,p3,p4)

# - Box plot ----
featurePlot(x = data[, 1:4], 
            y = data$Species, 
            plot = "box", 
            ## Pass in options to bwplot() 
            scales = list(y = list(relation="free"),
                          x = list(rot = 90)),  
            layout = c(4,1 ), 
            auto.key = list(columns = 2))

# - Density plot ---- 
#Kinda like a histogram that shows distribution, but cooler
transparentTheme(trans = .9)
featurePlot(x = data[, 1:4], 
            y = data$Species,
            plot = "density", 
            ## Pass in options to xyplot() to 
            ## make it prettier
            scales = list(x = list(relation="free"), 
                          y = list(relation="free")), 
            adjust = 1.5, 
            pch = "|", 
            layout = c(4, 1), 
            auto.key = list(columns = 3))

# - Line Plots ----
#To show trends
p1 = ggplot(data, aes(Species, Sepal.Length)) +
  stat_summary(fun.y = mean, ##adds the points
               geom = "point") +
  stat_summary(fun.y = mean, ##adds the line
               geom = "line",
               aes(group=1)) +
  stat_summary(fun.data = mean_cl_normal, ##adds the error bars
               geom = "errorbar", 
               width = .2) +
  xlab('X Variable')+
  ylab('Y Variable')
p1
p2 = ggplot(data, aes(Species, Sepal.Width)) +
  stat_summary(fun.y = mean, ##adds the points
               geom = "point") +
  stat_summary(fun.y = mean, ##adds the line
               geom = "line",
               aes(group=1)) +
  stat_summary(fun.data = mean_cl_normal, ##adds the error bars
               geom = "errorbar", 
               width = .2) +
  xlab('X Variable')+
  ylab('Y Variable')
p2

#Make a pdf of the line graph
pdf("grid.pdf")
plot_grid(p1,p2)
dev.off()

#Make a png of the line graph
pdf("grid.pdf")
plot_grid(p1,p2)
dev.off()

# - [] - We are now ready for Modelling! ----

