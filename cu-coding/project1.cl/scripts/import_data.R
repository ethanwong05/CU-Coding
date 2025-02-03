start <- as.Date(Sys.Date()-(365*5)) # start date. 
end <- as.Date(Sys.Date()) # current date. 
getSymbols("GOOG", src = "yahoo", from = start, to = end) # Feed symbol from s&p500. 
data = GOOG # call xts object into env. 
colnames(data) = c("Open", "High", "Low", "Close", "Volume", "Adjusted") # set column names in xts object. 
print(head(data))