# Analysis of Employee Demographic

## Overview
This project focuses on analyzing employee demographics, recruitment costs, and factors influencing key performance indicators (KPIs) like pay rates and employee retention. Using real-world employee data, the analysis identifies trends, the best recruitment sources, key performance drivers, and demographic factors linked to employee turnover. The insights provided are designed to inform data-driven decisions on recruitment strategies and workforce management.

## Repository Structure
- Data Analysis.pptx: Presentation summarizing the key findings and visualizations of the employee demographic and recruitment study.
- Data Visualization.pdf: A visual dashboard summarizing employee characteristics and recruitment cost analysis.
- Data_Analysis.py: Python script for data preprocessing and analysis, including data cleaning, linear regression, and logistic regression models.
- recruitment_costs.csv: Dataset containing recruitment costs per source, including company referrals, job fairs, and online platforms.
- staff_particulars.csv: Employee data, including demographic information, performance scores, termination reasons, and more.

## Key Findings
1. Employee Demographics:
- Race: The majority of employees are white (62.3%), followed by black employees (18.4%), reflecting U.S. national trends.
- Marital Status: 44.2% of employees are single, while 39.7% are married. These are consistent with national statistics.
- State: A significant majority (85.5%) of employees are from the state of Massachusetts, suggesting a large number of on-site staff.
- Department: 67.1% of employees work in production, indicating the company operates in a physical, brick-and-mortar environment.

2. Recruitment Sources:
- Top Source: Employee referrals account for 10% of the workforce at no cost, making it the most cost-effective recruitment source.
- Diversity Job Fairs: Another significant source, but costly, providing good diversity and lower retention rates compared to referrals.
- Recommendation: Prioritize employee referrals and cost-effective sources, but ensure diversity by leveraging job fairs when needed.

3. Factors Influencing Pay Rate:
- Manager Impact: Having Peter Monroe as a manager significantly lowers pay rates.
- Department: Employees in sales and production departments see higher pay adjustments.
- Key Drivers: Position, manager, and department are the main factors driving pay rates.

4. Employee Turnover Prediction:
- Key Contributors to Turnover:
  - Low pay rates
  - Negative reasons for termination
  - Poor performance scores
- High-Risk Groups: Women, non-Hispanic/Latino, U.S. citizens are more likely to leave within the next 3 months.

## How to Use
1. Data Analysis: Use the data_analysis.py script to run your own analysis or modify the existing models. Ensure you have the required dependencies (listed below).
2. Data Sources: The analysis is performed on two main datasets:
  - recruitment_costs.csv: For recruitment cost analysis.
  - staff_particulars.csv: For demographic and performance data.
3. Visualization: View the detailed analysis and findings in the Data Analysis.pptx file or the Dashboard.pdf for quick insights.

## Requirements
- Python 3.x
- Pandas: For data manipulation
- Matplotlib: For generating visualizations
- Scikit-learn: For applying regression and classification models

## Powerpoint includes
1. Exploratory Data Analysis
2. Linear Regression Model for Identifying Impactful Characteristics
3. Logistic Regression Model acting as a Supervised Classifier to identify characteristics and demographics of high probability individuals who may be terminated

## Conclusion
This analysis provides insights into employee demographics, recruitment cost efficiency, pay rate determinants, and turnover risk factors. The findings offer actionable recommendations for optimizing recruitment strategies and workforce management to improve retention and performance outcomes.
