
# essential 
import pandas as pd
import numpy as np
import re
import os 
import tensorflow as tf 
from tensorflow import keras
import seaborn as sns

# scikit-learn and keras modules 
from keras.models import Sequential
from keras.layers import Dense
from tensorflow.keras.utils import to_categorical
from keras.layers import Dense, Dropout, Activation, BatchNormalization
from keras import callbacks
from keras import regularizers

# keras optimizer
from tensorflow.keras import layers 

from sklearn.metrics import r2_score
from sklearn.model_selection import KFold
from sklearn.model_selection import train_test_split
from sklearn.impute import SimpleImputer
from sklearn.preprocessing import StandardScaler

os.chdir("C:/Users/Pedro G/OneDrive/Desktop/final_project")

crypto = pd.read_csv("data/preprocessed_data.csv")
crypto["timestamp"] = pd.to_datetime(crypto['timestamp'])
# crypto['LAST_PRICE'] = stock['ACT_CLOSE_PRICE'].shift(periods=1, freq=None, axis=0)
# crypto['LAST_VOLUME'] = stock['ACT_VOLUME'].shift(periods=1, freq=None, axis=0)
# stock['5MED_VOLUME'] = stock['LAST_VOLUME'].rolling(5).median().reset_index(0,drop=True)
cryptotrain = crypto.loc[0:572]
cryptotest = crypto.loc[573:716]
crypto.to_csv("cryptoV2.csv")

# crypto = crypto.fillna(0)
# stock = stock.replace(np.inf, 0)
# stock = stock.round(decimals=2)
# stocktrain = stocktrain.fillna(0)
# stocktrain = stocktrain.replace(np.inf, 0)
# stocktrain = stocktrain.round(decimals=2)
# Train, Test Split highly correlated features from stock.
X_train, X_test, y_train, y_test = \
train_test_split(cryptotrain[["ETH_Close","BTC_Close","BTC_Energy","ETH_Energy"]], cryptotrain["breakeven_inflation"]            
            )    
ss = StandardScaler()
# Fit and transform the training data.

X_train = ss.fit_transform(X_train) # only fit the train, not the test
X_test = ss.transform(X_test)
# Setup the Keras model.
opt = keras.optimizers.Adam(learning_rate=0.001)
model = Sequential()
model.add(Dense(X_train.shape[1], input_dim=X_train.shape[1], activation='relu'))
model.add(Dense(9, activation='relu', kernel_initializer='VarianceScaling', kernel_regularizer=regularizers.l1_l2(l1=0.01, l2=0.01)))
model.add(Dense(6, activation='relu', kernel_initializer='VarianceScaling', kernel_regularizer=regularizers.l1_l2(l1=0.001, l2=0.001)))
model.add(Dense(3, activation='relu', kernel_initializer='VarianceScaling', kernel_regularizer=regularizers.l1_l2(l1=0.001, l2=0.001)))
model.add(Dense(9, activation='relu', kernel_initializer='VarianceScaling', kernel_regularizer=regularizers.l1_l2(l1=0.0001, l2=0.0001)))
model.add(Dense(6, activation='relu', kernel_initializer='VarianceScaling', kernel_regularizer=regularizers.l1_l2(l1=0.001, l2=0.001)))
model.add(Dense(3, activation='relu', kernel_initializer='VarianceScaling', kernel_regularizer=regularizers.l1_l2(l1=0.01, l2=0.01)))
model.add(Dense(1, activation='linear'))
model.compile(loss='mean_squared_error', optimizer=opt, metrics=['mae','mse'])
early_stop = callbacks.EarlyStopping(monitor='val_loss', patience= 50)
callback=[early_stop]
history = model.fit(X_train, y_train, validation_data=(X_test, y_test), epochs=2000, callbacks= callback, verbose=1)

y_pred = model.predict(X_test)
r2_score(y_test, y_pred)
X_new = cryptotest[["ETH_Close","BTC_Close","BTC_Energy","ETH_Energy"]]
X_new = ss.transform(X_new)
pred = model.predict(X_new)
Stock_Pred = pd.DataFrame(list(zip(cryptotest["timestamp"],pred,cryptotest["breakeven_inflation"])))

print(history.history['accuracy'])



