#!/usr/bin/env python
# coding: utf-8

# In[1]:


import tensorflow as tf
import pandas as pd
import seaborn as sns
import sklearn

from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Dense
from tensorflow.keras.optimizers import Adam,RMSprop,Adadelta,Adamax,SGD
from tensorflow.keras.callbacks import ModelCheckpoint,EarlyStopping

from sklearn import preprocessing
from sklearn.preprocessing import RobustScaler
from sklearn.preprocessing import StandardScaler
from sklearn.preprocessing import MinMaxScaler
from sklearn.model_selection import train_test_split
from sklearn.metrics import r2_score
from matplotlib import pyplot as plt

get_ipython().run_line_magic('matplotlib', 'inline')
get_ipython().run_line_magic('config', "InlineBackend.figure_format='retina'")


# In[2]:


#read the data
df = pd.read_excel('data2.xlsx')
# df = pd.read_csv('data1.xlsx')
df.head()


# In[3]:


#indexing for selection by position
df1 = df.iloc[0:-1, 2:9]
df2 = df.iloc[0:-1, 0:2]


# In[4]:


#Standardize features

# scaler = RobustScaler()
scalerx = StandardScaler()
scalery = StandardScaler()

df1 = scalerx.fit_transform(df1)
df2 = scalery.fit_transform(df2)


# In[5]:


#display mean value
scalerx.mean_


# In[6]:


#display scale value
scalerx.scale_


# In[7]:


#display mean value
scalery.mean_


# In[8]:


#display scale value
scalery.scale_


# In[9]:


#split data into training and testing data
X_train, X_test, y_train, y_test = train_test_split(df1, df2, test_size=0.2)


# In[10]:


# visualize distribution of data
sns.displot(X_train[:,0])
plt.show()


# In[11]:


# visualize distribution of data
sns.displot(y_train[:,1], kind="kde",bw_adjust=.25)
plt.show()


# In[12]:


# Build sequential model
model = Sequential()
model.add(Dense(8,activation = 'sigmoid', input_shape=(7,)))
model.add(Dense(5, activation = 'sigmoid'))
model.add(Dense(2))

#Compile model
model.compile(Adam(lr=0.0005),loss='mse')
# model.compile(RMSprop(learning_rate=0.0005, rho=0.75),loss='mean_absolute_error')
# model.compile(Adadelta(learning_rate=0.0015, rho=0.95),loss='mse')
# model.compile(Adamax(learning_rate=0.001),loss='mse')
# model.compile(SGD(learning_rate=0.001),loss='mse')

#create callback
path = 'Jordan.h5'
checkpoint = ModelCheckpoint(path, monitor="val_loss", verbose=1, save_best_only=True, mode='min')
callbacks_list = [checkpoint]


# show model summary
model.summary()


# In[13]:


#Train the model
history = model.fit(X_train, y_train, epochs = 100, validation_split = 0.25,callbacks = callbacks_list, batch_size =16,shuffle = True,verbose = 1)



# In[14]:


#Plots model's training cost/loss and model's validation split cost/loss
history_dict=history.history
loss_values = history_dict['loss']
val_loss_values=history_dict['val_loss']

fig, ax = plt.subplots()
plt.plot(loss_values,'b',label='training loss')
plt.plot(val_loss_values,'r',label='validation loss')
plt.ylabel('loss')
plt.xlabel('epoch')
plt.legend(loc='upper right')
plt.show()
#fig.savefig('loss.png', format='png', dpi=1200)


# In[15]:


# Runs model with its current weights on the training and testing data
y_train_pred = model.predict(X_train)
y_test_pred = model.predict(X_test)

# Calculates and prints r2 score of training and testing data
print("The R2 score on the Train set is:\t{:0.3f}".format(r2_score(y_train, y_train_pred)))
print("The R2 score on the Test set is:\t{:0.3f}".format(r2_score(y_test, y_test_pred)))


# In[16]:




# Scale back the prediction data to the original representation
y_test = scalery.inverse_transform(y_test)
y_test_pred = scalery.inverse_transform(y_test_pred)


# In[17]:


#plot real predictions
fig, ax = plt.subplots()

plt.title('Predictions VS Ground_truth')
plt.scatter(y_test[:,0],y_test_pred[:,0])
plt.ylabel('Predictions')
plt.xlabel('True value Predictions')
#plt.legend(['Ground_truth', 'Predictions'], loc='upper left')
plt.show()
#fig.savefig('predVStruth.png', format='png', dpi=1200)


# In[18]:


# Define function to plot predictions against true data
def chart_regression(pred,y,sort=True):
    fig, ax = plt.subplots()
    a = plt.plot(y.tolist(),label='expected')
    b = plt.plot(pred.tolist(),label='prediction')
    plt.ylabel('output')
    plt.xlabel('datapoint  output')
    plt.legend(loc='upper left')
    plt.show()
    fig.savefig('pred_expect.png', format='png', dpi=1200)


# In[94]:


# plot predictions against true data
chart_regression(y_test_pred[120:180,0],y_test[120:180,0],sort=True)

