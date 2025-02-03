# Crypto Regression ----

# Essential 
import sklearn
import numpy as np
import pandas as pd
import os

# Scikit-learn modules
from sklearn.model_selection import train_test_split
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import confusion_matrix
from sklearn.metrics import accuracy_score
from sklearn import utils
from sklearn import preprocessing

# Setting working directory
os.chdir("C:/Users/wongs/Desktop/final_project")

# Reading csv data 
data = pd.read_csv("data/preprocessed_data.csv")

data['timestamp'] = pd.to_datetime(data['timestamp'])

breakeven_inflation = data['']
data = data.drop(columns = ['ETH_Energy', 'timestamp'])

# defining target variable and data 
X = data
y = breakeven_inflation

X_train, X_test, y_train, y_test = train_test_split(X, y, random_state=1)
y_test = y_test.astype('int')
y_train = y_train.astype('int')
X_train = X_train.astype('int')
X_test = X_test.astype('int')

# Regression model 
model = LogisticRegression(solver='lbfgs',
multi_class ='multinomial')
model.fit(X_train, y_train)

# Test result
y_predict = model.predict(X_test)
confusion_matrix(y_test, y_predict)

# Accuracy result
print(f"\n- accuracy: {accuracy_score(y_test, y_predict)*100:.1f}% -\n")
