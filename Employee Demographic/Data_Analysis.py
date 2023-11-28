import numpy as np
import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LinearRegression
from sklearn.preprocessing import StandardScaler
import statsmodels.api as sm
from statsmodels.stats.outliers_influence import variance_inflation_factor
from sklearn import metrics
from sklearn.linear_model import Ridge
from sklearn.metrics import mean_squared_error
from itertools import combinations
from sklearn.preprocessing import LabelEncoder
from sklearn.linear_model import LogisticRegressionCV
from imblearn.over_sampling import SMOTE
import matplotlib.pyplot as plt

recruitment_costs = pd.read_csv("C:/Users/isaac/OneDrive/Documents/Work/Companies/Glints/Data Source 2 - recruitment_costs.csv")
salary_grid = pd.read_csv("C:/Users/isaac/OneDrive/Documents/Work/Companies/Glints/Data Source 2 - salary_grid.csv")
staff_particulars = pd.read_csv("C:/Users/isaac/OneDrive/Documents/Work/Companies/Glints/Data Source 2 - staff_particulars.csv")
#print(staff_particulars.head(9))

#Q1 What are the key employee characteristics and demographic factors to take note of, and are there any trends to highlight? (exploratory analysis, staff_particulars)

#Composition
def composition(col):
    result = pd.DataFrame()
    for i in col.unique():
        values = col == i
        result[i] = values
    return result.sum()

#Quantify Performance Score
score_mapping = {
    'N/A- too early to review' : 0,
    'Fully Meets': 1,
    'Exceeds': 2,
    'Exceptional': 3,
    '90-day meets': -1,
    'Needs Improvement': -2,
    'PIP': -3
}

#Quantify Reason For Termination
term_mapping = {
    'N/A - still employed': 0,
    'career change': 0,
    'medical issues': 0,
    'N/A - Has not started yet': 0,
    'Another position': 0,
    'retiring': 0,
    'return to school': 0,
    'relocation out of area': 0,
    'military': 0,
    'more money': 0,
    'maternity leave - did not return': 0,
    'gross misconduct': 0,
    'attendance': -1,
    'performance': -1,
    'no-call, no-show': -1,
    'hours': -1,
    'unhappy': -1,
}

# Create a new column "Categorical Performance Score" based on the mapping
staff_particulars['Categorical Performance Score'] = staff_particulars['Performance Score'].map(score_mapping)
# Create a new column "Categorical Reason For Term" based on the mapping
staff_particulars['Categorical Reason For Term'] = staff_particulars['Reason For Term'].map(term_mapping)

#Race
staff_particulars_race = staff_particulars["RaceDesc"]
print("Race Composition\n")
print(composition(staff_particulars_race))
#Results show whites being 193/310 of the employees, making up 62.3% of the composition, with the next largest being blacks, at 57/310 = 18.4%
#Granted those numbers are the general expected numbers, and thus does not raise any concerns. With prelimnary research showing that about 59.3% of US Citizens being White.
#Source: https://en.wikipedia.org/wiki/Race_and_ethnicity_in_the_United_States

#Marital Status
staff_particulars_marriage = staff_particulars["MaritalDesc"]
print("Marriage Composition\n")
print(composition(staff_particulars_marriage))
#Results show that Singles take on 137/310 of the employees, being 44.2% of the composition, with the next largest being married couples at 123/310 = 39.7%
#Granted those numbers are the general expected numbers, and thus does not raise any concerns. With prelimnary research showing that about 42% of US Citizens being Single.
#Source: https://www.census.gov/newsroom/stories/unmarried-single-americans-week.html#:~:text=From%20nationalsinglesday.us%2C%20%E2%80%9CDid,those%20who%20have%20never%20married.

#State
staff_particulars_state = staff_particulars["State"]
print("State Composition\n")
print(composition(staff_particulars_state))
#Results shows an overwhelming number of employees coming from the MA state, being 275/310 = 85.5%.
#This shows that the company is likely to have more on-site employees than remote employees, having a large majority coming from the same state.

#Department
staff_particulars_department = staff_particulars["Department"]
print("Department Composition\n")
print(composition(staff_particulars_department))
#Results show a majority of employees being in the Production Department, at 208/310 = 67.1%
#This shows that the company is likely to be rather Brick and Mortar, requiring significant on-site physical work.

#Employee Source
staff_particulars_source = staff_particulars["Employee Source"]
print("Employee Source Composition\n")
print(composition(staff_particulars_source))
#Results provide an even spread across multiple sources, with the most being Employee Referral at 31/310 = 10%, and the next largest being Diversity Job Fair at 29/319 = 9.35%.

#Performance Score
staff_particulars_pef_score = staff_particulars["Categorical Performance Score"]
print("Performance Score Composition\n")
print(composition(staff_particulars_pef_score))
#Results show Information session is the highest performance score on average, 
#granted the standard deviation is relatively low, the statistics makes sense as those who're passionate enough to go for information sessions tend to be more interested in their work
#this leads to a form of selection bias for their higher categorical performacne score


#Q2 What are the best recruitment sources for this company to use? (You may define the criteria for what "Best" is)
#Compare recruitment cost for each source with the percentage that are recruited, finally include performance for each/price
cost_per_source = pd.concat([recruitment_costs["Employment Source"], recruitment_costs.sum(axis=1)], axis=1)
cost_per_source.columns = ["Employee Source", "Total Cost"]
cost_per_source.set_index("Employee Source", inplace=True)
print("Cost for each Source\n")
print(cost_per_source)
#Certain sources require 0 cost, I will be analyzing them first as they have the greatest potential with little to no opportunity cost
#These sources include Company Intranet - Partner, Employee Referral, Glassdoor, Information Session, Internet Search, On-line Web application, Vendor Referral, Word of Mouth
'''
As seen in Q1, the biggest recruitment sources (above 20) we should take note of is from 
Employee Referral, the Diversity Job Fair, Search Engine - Google Bing Yahoo, Monster.com, Pay Per Click - Google, Professional Society
'''
merged_df = staff_particulars_source.to_frame().merge(cost_per_source, left_on="Employee Source", right_index=True, how="left")
grouped_df = merged_df.groupby("Employee Source").agg({"Total Cost": "sum", "Employee Source": "count"})
grouped_df.columns = ["Total Cost", "No of Employees"]
sorted_df = grouped_df.sort_values(by="No of Employees", ascending=False)
print(sorted_df)
'''
Sorting based on total number of employees in descending order shows that Employee Referral is the only $0 cost Employee Source that has a large number of employees
With the next highest number of employees being Vendor Referral and Glassdoor.
The best recruitment source for this company to use would then be Employee Referrals. However it isn't sustainable and may breed a certain stagnant culture.
Considering the next highest number of employees being Diversity Job Fairs being significantly higher than Search Engines and Monster.com,
I would prioritize search engines or monster.com as the next best in order to reap as much benefit from each cost.
However, it still is good to have diversity within the company, so although I would deprioritize diveristy job fairs, 
I would mostly use it if the race/gender composition of the company isn't good.
'''

#Including Pay Rate and Performance Score
merged_df = pd.merge(sorted_df, staff_particulars, on="Employee Source", how="left")
result_df = merged_df[["Employee Source", "Pay Rate", "Categorical Performance Score", "Total Cost", "No of Employees"]]
grouped_avg = result_df.groupby("Employee Source").agg({
    "Pay Rate": "mean",
    "Categorical Performance Score": "mean",
    "No of Employees": "first",
    "Total Cost": "first"
}).reset_index()
#print(grouped_avg)
sorted_grouped_avg = grouped_avg.sort_values(by="Categorical Performance Score", ascending=False)
print(sorted_grouped_avg)

'''
When including performance score, I would rate information session as the "best" as they command the highest categorical performance score (with 0.0 total cost)
However, the standard deviation is low, with only 4 employees included
I would recommend looking out more for people in information sessions as there's room for expansion and hiring more, 
however, I would still hold employee referral generally the highest with as they're still in the top 3.
This time, I would include professional society as well, since they do have 20 employees, rather low total cost and a very good performance score
'''

#Q3 Who is the best manager? (define "best", staff_particulars, group manager name, rate based on performance score and low termination)
#Including Pay Rate and Performance Score
merged_df = pd.merge(sorted_df, staff_particulars, on="Employee Source", how="left")
result_df = merged_df[["Employee Source", "Pay Rate", "Categorical Performance Score", "Total Cost", "No of Employees", "Manager Name", "Categorical Reason For Term"]]
print(result_df)
grouped_avg = result_df.groupby("Manager Name").agg({
    "Pay Rate": "mean",
    "Categorical Performance Score": "mean",
    "No of Employees": "first",
    "Total Cost": "first",
    "Categorical Reason For Term" : "mean"
}).reset_index()
#print(grouped_avg)
sorted_grouped_avg = grouped_avg.sort_values(by="Categorical Performance Score", ascending=False)
print(sorted_grouped_avg)
'''
Grouping based on Manager Name, I would use a similar metrics to define the best manager through performance score of their surbordinates
This would lead to Eric Dougall to be the best with the highest performance score.
This is further supported by a low average pay rate (which saves the company money), 
high number of employees to show his capabilities of managing a large number,
and a Reason For Termination that doesnt contain too many unhappy individuals
'''

#Q3a Who is a low-performing manager
'''
A general low-performing manager would be considered those with below -0.3 categorical performance score and a categorical reason for term of below -0.1
'''

#Q4 Which factors drive the pay rate the most? (staff_particulars, linear regression against pay rate find highest coeff)
# Perform one-hot encoding for categorical columns
df_encoded = pd.get_dummies(staff_particulars, columns=['Sex', 'MaritalDesc', 'CitizenDesc', 'Hispanic/Latino', 'RaceDesc', 'Department', 
                                                        'Position', 'Manager Name', 'Employee Source', 'Performance Score'], drop_first=True)

'''
df_encoded = pd.get_dummies(staff_particulars, columns=['Sex', 'Hispanic/Latino'], drop_first=True)
label_encoder = LabelEncoder()
columns_to_encode = ['MaritalDesc', 'CitizenDesc', 'RaceDesc', 'Department', 'Position', 'Manager Name', 'Employee Source', 'Performance Score']

# Fit and transform the categorical column
for column in columns_to_encode:
        df_encoded[column + '_encoded'] = label_encoder.fit_transform(df_encoded[column])

df_encoded = df_encoded.drop(columns=columns_to_encode)
# Drop the original categorical columns
df_encoded = df_encoded.drop(columns=columns_to_encode + ['Employee Number', 'Employee Name', 'Zip', 'DOB', 'Date of Hire', 
                                                            'Date of Termination', 'Employment Status', 'State', 'Reason For Term'])
'''
df_encoded = df_encoded.drop(columns=['Employee Number', 'Employee Name', 'Zip', 'DOB', 'Date of Hire', 
                                        'Date of Termination', 'Employment Status', 'State', 'Reason For Term'])

# Separate predictors (X) and the target variable (y)
X = df_encoded.drop(['Pay Rate'], axis=1)
y = df_encoded['Pay Rate']

# Split the data into training and testing sets
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# Create a linear regression model
model = LinearRegression()

# Fit the model on the training data
model.fit(X_train, y_train)

# Make predictions on the test data
y_pred = model.predict(X_test)

# Evaluate the model
print('Mean Absolute Error:', metrics.mean_absolute_error(y_test, y_pred))
print('Mean Squared Error:', metrics.mean_squared_error(y_test, y_pred))
print('Root Mean Squared Error:', metrics.mean_squared_error(y_test, y_pred, squared=False))

# Print the coefficients of the model
coefficients = pd.DataFrame({'Variable': X.columns, 'Coefficient': model.coef_})
sorted_coefficients = coefficients.sort_values(by='Coefficient', key=abs, ascending=False)
print(sorted_coefficients)

# Intercept of the model
intercept = model.intercept_
print('Intercept:', intercept)

'''
From the above code, it is clear that having Peter Monroe as your manager significantly affects your pay rate the most, having the lowest of -1.23e+13
The next being in the sales department, providing a -9.75e+12 in pay rate.
For generalized factors, it is clear that Position affects employees pay rate the most

Reruning the code dropping Position would give us Hispanic/Latino as the largest coefficient, followed by various manager names.
Iterating through this once more would show the departments as the largest coefficient.

Thus, the factors that drive the pay rate the most are Position, followed by Manager, and next, Departments
'''

#Q5 What are the characteristics and demography of employees that have a high probability of leaving the company in the next 3 Months? (Probit/Logit on staff_particulars)

#Settle Categorical data
staff_particulars = pd.get_dummies(staff_particulars, columns=['Sex', 'Hispanic/Latino'], drop_first=True)
label_encoder = LabelEncoder()
columns_to_encode = ['MaritalDesc', 'CitizenDesc', 'RaceDesc', 'Department', 'Position', 'Manager Name', 'Employee Source', 'Performance Score']

# Fit and transform the categorical column
for column in columns_to_encode:
        staff_particulars[column + '_encoded'] = label_encoder.fit_transform(staff_particulars[column])

# Before encoding
print(staff_particulars.columns)
print("Unique values before encoding:")
print(staff_particulars['RaceDesc'].unique())

# Label encoding
label_encoder = LabelEncoder()
staff_particulars['RaceDesc_encoded'] = label_encoder.fit_transform(staff_particulars['RaceDesc'])

# After encoding
print("\nUnique values after encoding:")
print(staff_particulars['RaceDesc_encoded'].unique())

# Before encoding
print("Unique values before encoding:")
print(staff_particulars['CitizenDesc'].unique())

# Label encoding
label_encoder = LabelEncoder()
staff_particulars['CitizenDesc_encoded'] = label_encoder.fit_transform(staff_particulars['CitizenDesc'])

# After encoding
print("\nUnique values after encoding:")
print(staff_particulars['CitizenDesc_encoded'].unique())

staff_particulars = staff_particulars.drop(columns=columns_to_encode)

# Convert 'Date of Termination' and 'Date of Hire' to datetime objects
staff_particulars['Date of Termination'] = pd.to_datetime(staff_particulars['Date of Termination'], format='%m/%d/%Y')
staff_particulars['Date of Hire'] = pd.to_datetime(staff_particulars['Date of Hire'], format='%m/%d/%Y')

# Separate predictors (X) and the target variable (y)
# Drop irrelevant columns and the target variable from predictors
staff_particulars['Leaving'] = ((staff_particulars['Date of Termination'] - staff_particulars['Date of Hire']).dt.days < 90).astype(int)
X = staff_particulars.drop(['Leaving', 'Employee Name', 'Employee Number', 'State', 'Zip', 'DOB', 'Date of Hire', 
                            'Date of Termination', 'Reason For Term', 'Employment Status', 'Performance Score_encoded'], axis=1)
y = staff_particulars['Leaving']

# Split the data into training and testing sets
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# Function to fit a model and calculate performance metric (e.g., MSE)
def fit_and_evaluate(X_train, X_test, y_train, y_test, features):
    model = sm.OLS(y_train, sm.add_constant(X_train[features])).fit()
    y_pred = model.predict(sm.add_constant(X_test[features]))
    mse = mean_squared_error(y_test, y_pred)
    return mse

# Forward Stepwise Selection
def forward_stepwise_selection(X_train, X_test, y_train, y_test, max_features=None):
    selected_features = []
    all_features = list(X_train.columns)

    for _ in range(len(all_features)):
        remaining_features = list(set(all_features) - set(selected_features))
        best_feature = None
        best_mse = float('inf')

        for feature in remaining_features:
            current_features = selected_features + [feature]
            mse = fit_and_evaluate(X_train, X_test, y_train, y_test, current_features)

            if mse < best_mse:
                best_mse = mse
                best_feature = feature

        selected_features.append(best_feature)

        if max_features and len(selected_features) >= max_features:
            break

    return selected_features

# View Stepwise Selected Features
selected_features_forward = forward_stepwise_selection(X_train, X_test, y_train, y_test)
print("Forward Stepwise Selection:", selected_features_forward)

# Isolate Selected Features
X = staff_particulars[selected_features_forward]
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# Standardize the predictor variables
scaler = StandardScaler()
X_train_scaled = scaler.fit_transform(X_train)
X_test_scaled = scaler.transform(X_test)

# Apply SMOTE to the training data
smote = SMOTE(random_state=42)
X_train_resampled, y_train_resampled = smote.fit_resample(X_train_scaled, y_train)

# Create a logistic regression model with L2 regularization
model = LogisticRegressionCV(penalty='l2', solver='lbfgs', max_iter=1000, cv=5)

# Fit the model on the training data
#model.fit(X_train_scaled, y_train)
model.fit(X_train_resampled, y_train_resampled)

# Make predictions on the test data
y_pred = model.predict(X_test_scaled)

# Evaluate the model with adjusted threshold
print('Accuracy:', metrics.accuracy_score(y_test, y_pred))
print('Precision:', metrics.precision_score(y_test, y_pred))
print('Recall:', metrics.recall_score(y_test, y_pred))
print('F1 Score:', metrics.f1_score(y_test, y_pred))
print('AUC-ROC:', metrics.roc_auc_score(y_test, y_pred))
print('AUC-PR:', metrics.average_precision_score(y_test, y_pred))

# Access the coefficients and corresponding feature names
coefficients = model.coef_[0]
feature_names = X_train.columns

# Create a DataFrame to display coefficients
coef_df = pd.DataFrame({'Feature': feature_names, 'Coefficient': coefficients})
coef_df = coef_df.sort_values(by='Coefficient', ascending=False)
print(coef_df)

# Predict probabilities for the entire dataset
all_probabilities = model.predict_proba(scaler.transform(X))[:, 1]

# Add predicted probabilities to the original DataFrame
staff_particulars['Predicted_Probability_Leaving'] = all_probabilities

threshold = 0.5  # Adjust the threshold as needed
staff_particulars['Predicted_Leaving'] = (all_probabilities > threshold).astype(int)

'''
In terms of highest magnitude:
Pay Rate (-1.307221): A one-unit increase in "Pay Rate" is associated with a decrease of approximately 1.31 in the log-odds of leaving. In simpler terms, higher pay is associated with a lower probability of leaving.
Categorical Reason For Term (-1.420358): Having a specific reason for termination (as encoded in the "Categorical Reason For Term") is associated with a decrease of approximately 1.42 in the log-odds of leaving. This suggests that employees with certain reasons for termination are less likely to leave.
'''
