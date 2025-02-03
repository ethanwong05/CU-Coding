plot = na.omit(sub)
cor = cor(plot) # correlation 
png("pictures/cor.png")
print(corrplot::corrplot(cor))    
dev.off()