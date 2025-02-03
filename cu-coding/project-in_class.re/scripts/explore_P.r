plot = na.omit(sub)
cor = cor(plot) # correlation 
png("pictures/cor_prep.png")
print(corrplot::corrplot(cor))    
dev.off()