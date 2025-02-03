# - [] - Fixing up energy_data ----

BTC_Energy[['Date']] <- as.Date(BTC_Energy[['Date']], tryFormats = '%Y/%m/%d')
ETH_Energy[['Date']] <- as.Date(ETH_Energy[['Date']], tryFormats = '%Y/%m/%d')

remove = c("Minimum TWh per Year")
BTC_Energy = BTC_Energy[, !colnames(BTC_Energy) %in% c(remove)] # conditionally select the variables to remove from the dataframe. 

remove = c("Minimum TWh per Year")
ETH_Energy = ETH_Energy[, !colnames(ETH_Energy) %in% c(remove)] # conditionally select the variables to remove from the dataframe. 

# - [] - Subsetting Stuff ----

remove = c("open (USD)", "high (USD)", 'low (USD)', 'market cap (USD)')
BTC_data = BTC_data[, !colnames(BTC_data) %in% c(remove)] # conditionally select the variables to remove from the dataframe. 
colnames(BTC_data) <- c('timestamp', 'BTC_Close', 'BTC_Volume')

ETH_data = ETH_data[, !colnames(ETH_data) %in% c(remove)] # conditionally select the variables to remove from the dataframe. 
colnames(ETH_data) <- c('timestamp', 'ETH_Close', 'ETH_Volume')

data0 = ETH_data %>% inner_join(BTC_data, by="timestamp")

colnames(inflation_data) <- c('timestamp', 'breakeven_inflation')

# - Fixing up breakeven inflation values ----
inflation_data[['breakeven_inflation']] <- as.numeric(inflation_data[['breakeven_inflation']])

data1 = data0 %>% inner_join(inflation_data, by= 'timestamp')

colnames(BTC_Energy) <- c('timestamp', 'BTC_Energy')

data2 = data1 %>% inner_join(BTC_Energy, by= 'timestamp')

colnames(ETH_Energy) <- c('timestamp', 'ETH_Energy')

data = data2 %>% inner_join(ETH_Energy, by= 'timestamp')

print('Made the following DataFrame:')
print(head(data))

write.csv(data, "data/data.csv")
