# Exploration of the Processed ----

# Import the Processed Data
process_data <- read_csv("data/preprocessed_data.csv")

# Inspect the Processed Data ----
print(head(process_data))

# Subset Ignoble Variables ----
sub = process_data[2:8]
str(sub)

summary(sub) # summary stats 

cor_sub = process_data[3:8]

cor = cor(cor_sub) # correlation 
png("pictures/preprocessed/cor_P.png")
print(corrplot::corrplot(cor))    
dev.off() 

p1 = ggplot(data, aes(timestamp, ETH_Close)) +
  stat_summary(fun.y = mean, ##adds the points
               geom = "point") +
  stat_summary(fun.y = mean, ##adds the line
               geom = "line",
               aes(group=1)) +
  stat_summary(fun.data = mean_cl_normal, ##adds the error bars
               geom = "errorbar", 
               width = .2) +
  xlab('Time')+
  ylab('ETH Close Price')

png("pictures/preprocessed/ETH_Close_ggplot.png")
print(p1)    
dev.off()

p2 = ggplot(data, aes(timestamp, BTC_Close)) +
  stat_summary(fun.y = mean, ##adds the points
               geom = "point") +
  stat_summary(fun.y = mean, ##adds the line
               geom = "line",
               aes(group=1)) +
  stat_summary(fun.data = mean_cl_normal, ##adds the error bars
               geom = "errorbar", 
               width = .2) +
  xlab('Time')+
  ylab('BTC Close Price')

png("pictures/preprocessed/BTC_Close_ggplot.png")
print(p2)    
dev.off()

p3 = ggplot(data, aes(timestamp, ETH_Energy)) +
  stat_summary(fun.y = mean, ##adds the points
               geom = "point") +
  stat_summary(fun.y = mean, ##adds the line
               geom = "line",
               aes(group=1)) +
  stat_summary(fun.data = mean_cl_normal, ##adds the error bars
               geom = "errorbar", 
               width = .2) +
  xlab('Time')+
  ylab('ETH Energy Consumption (TWh)')

png("pictures/preprocessed/ETH_Energy_ggplot.png")
print(p3)    
dev.off()

p4 = ggplot(data, aes(timestamp, BTC_Energy)) +
  stat_summary(fun.y = mean, ##adds the points
               geom = "point") +
  stat_summary(fun.y = mean, ##adds the line
               geom = "line",
               aes(group=1)) +
  stat_summary(fun.data = mean_cl_normal, ##adds the error bars
               geom = "errorbar", 
               width = .2) +
  xlab('Time')+
  ylab('BTC Energy Consumption (TWh)')

png("pictures/preprocessed/BTC_Energy_ggplot.png")
print(p4)    
dev.off()

p5 = ggplot(data, aes(timestamp, breakeven_inflation)) +
  stat_summary(fun.y = mean, ##adds the points
               geom = "point") +
  stat_summary(fun.y = mean, ##adds the line
               geom = "line",
               aes(group=1)) +
  stat_summary(fun.data = mean_cl_normal, ##adds the error bars
               geom = "errorbar", 
               width = .2) +
  xlab('Time')+
  ylab('Breakeven Inflation')

png("pictures/preprocessed/breakeven_inflation_ggplot.png")
print(p5)    
dev.off()

p6 = ggplot(data, aes(timestamp, BTC_Volume)) +
  stat_summary(fun.y = mean, ##adds the points
               geom = "point") +
  stat_summary(fun.y = mean, ##adds the line
               geom = "line",
               aes(group=1)) +
  stat_summary(fun.data = mean_cl_normal, ##adds the error bars
               geom = "errorbar", 
               width = .2) +
  xlab('Time')+
  ylab('Bitcoin Volume')

png("pictures/preprocessed/BTC_Volume_ggplot.png")
print(p6)    
dev.off()

p7 = ggplot(data, aes(timestamp, ETH_Volume)) +
  stat_summary(fun.y = mean, ##adds the points
               geom = "point") +
  stat_summary(fun.y = mean, ##adds the line
               geom = "line",
               aes(group=1)) +
  stat_summary(fun.data = mean_cl_normal, ##adds the error bars
               geom = "errorbar", 
               width = .2) +
  xlab('Time')+
  ylab('Ethereum Volume')

png("pictures/preprocessed/ETH_Volume_ggplot.png")
print(p7)    
dev.off()

png("pictures/preprocessed/grid_line_P.png")
print(plot_grid(p1, p2, p3, p4, p5, p6, p7))
dev.off()

