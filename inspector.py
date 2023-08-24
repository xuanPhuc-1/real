import pandas as pd
import joblib
import warnings

filename = 'ann.pkl'
ann_model = joblib.load(filename)
dataset = pd.read_csv('realtime.csv')

#read the second row data and convert it into 2D array
sample = dataset.iloc[:, :].values
print(sample)

prediction = ann_model.predict(sample)
#approximate the result to the nearest integer

print(prediction)
if prediction[0] > 0.5:
    result = 1
else:
    result = 0

with open('result.txt', 'w') as f:
    f.write(str(result))