# - Preprocess the Data ----
prep = data[1:8]
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
write.csv(prep,"data/preprocessed_data.csv")
