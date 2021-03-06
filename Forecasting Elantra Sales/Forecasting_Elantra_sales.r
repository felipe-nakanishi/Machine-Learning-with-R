
''' Loading the Data

We are loading the data and splitting it into a training and testing set as follows:
All observations for 2012 and earlier are in the training set, and all 
observations for 2013 and 2014 are into the testing set.
'''

# load the data:
data = read.csv('elantra.csv')
# split the data into training and testing set:
train = subset(data, Year <= 2012)
test = subset(data, Year > 2012)

'''  Building a Linear Regression Model

We are building a linear regression model to predict monthly Elantra sales using Unemployment,
CPI_all, CPI_energy and Queries as the independent variables.
'''
# building the model:
model=lm(ElantraSales~Unemployment + CPI_all + CPI_energy + Queries, data = train)
# Visualizating the R� and p-values:
summary(model)

'''We can conclude that none of this variables are significant at a significance level of 10%.
The adjusted R� is quite low in this case also.
'''

'''Including the month variable to the model
We are adding the variable month to the model, to do that we need to convert 
the variable as a factor variable.
'''

# we are adding a new column to the dataframe with the month variable as factor: 
train$Month1=as.factor(train$Month)
# recreate the model with this new variable:
model_seasonal=lm(ElantraSales ~ Month1+Unemployment+CPI_all+CPI_energy+Queries, data=train)
# visualize the model
summary(model_seasonal)

'''Now we can see that some variables have become relevant at a significance level of 10%,
our adjusted R� is much higher now.
'''

'''Multicolinearity
For our linear regression model, it is important for us to take care about Multicolinearity.
To visualize the possibility of this occurring, we are creating a correlation matrix.
'''

cor(train[,-8])

'''We can see that there are some variables with high correlation '>0.7' so we need to take care with them.
Multicolinearity can reduce our multiple r� and reduce our model relevance.
'''
''' adjusting the model
We are removing from the model the variables with the highest p-value so that we can remain with
only the significant variables.
'''

# recreating the model without the 'Queries' variable:
model_seasonal2=lm(ElantraSales ~ Month1+Unemployment+CPI_all+CPI_energy, data=train)
summary(model_seasonal2)

'''Using the model to make predictions on the test set

We are now going to use the model to predict the sales in the test set.
'''

# as we made in the training set we need to convert the month variable to factor:
test$Month1=as.factor(test$Month)
# using the predict function to predict the sales in the test set:
regression = predict(model_seasonal2, newdata=test)

'''Calculating the R�

To calculate the R� we need to calculate the SSE and SST of the predictions.
'''

# to calculate the SSE we need to calculate the difference between our prediction and the real sales.
SSE = sum((regression - test$ElantraSales)^2)
# to calculate the SST we need to compare the baseline prediction and the real sales.
SST = sum((mean(train$ElantraSales)-test$ElantraSales)^2)
#R2 calculus:
R2 = 1 - (SSE/SST)
R2

'''Absolute errors
We can see our biggest absolute error and identify in which month it occurred.
'''

# calculating the absolute differences:
test$dif = abs(test$ElantraSales - regression)
# Using the which.max function to get the row of the max diff value:
which.max(test$dif)
test[5,]

