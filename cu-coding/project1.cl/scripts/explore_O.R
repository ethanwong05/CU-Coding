#Summarizing data ----
summary(data)

#Visualizing the data ----
#Line Plot

p1 = ggplot(data, aes(x =index(data), y= Close)) + geom_line() + ggtitle("Close Price")
p2 = ggplot(data, aes(x = index(data), y = Open)) + geom_line() + ggtitle("Open Price")
p3 = ggplot(data, aes(x = index(data), y = Low)) + geom_line() + ggtitle("Low Price")
p4 = ggplot(data, aes(x = index(data), y = High)) + geom_line() + ggtitle("High Price")
png("pictures/Grid_Line.png")
print(plot_grid(p1, p2, p3, p4))    
dev.off()

#Correlation Matrix
cor = cor(data) # inputs must be in numeric data type...
png("pictures/cor_O.png")
print(corrplot::corrplot(cor))    
dev.off()