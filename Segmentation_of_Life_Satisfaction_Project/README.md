# Segmentation of Life Satisfaction Project

## Overview
This project involves segmenting survey respondents based on their life satisfaction levels using Principal Component Analysis (PCA) and K-Means Clustering (KMC). The goal is to group individuals with similar attitudes toward life satisfaction while ensuring distinct separations between the clusters. Hierarchical clustering was also explored as an alternative for better handling ordinal data.

## Repository Structure
- Segmentation of Life Satisfaction.pptx: Presentation summarizing the methodology, results, and key insights from the life satisfaction segmentation.
- hierarchical.R: R script for conducting Hierarchical Clustering using Ward’s Method.
- kmeans.R: R script used for data cleaning, PCA, and K-Means Clustering.
- data.csv: The dataset of survey responses from 700 participants, including variables related to health, energy, living conditions, personal relationships, and more.

## Methodology
1. Data Cleaning
- Two approaches were used to handle missing data:
  - Qualitative Imputation: Replace missing values with means based on related questions.
  - Dropping Incomplete Data: Remove respondents with incomplete responses, preserving 95.4% of the data.
2. Principal Component Analysis (PCA)
- PCA was applied to reduce dimensionality, ensuring that variables least correlated with each other were separated.
- Focused on key life satisfaction questions like enjoyment of life and energy for daily activities.
3. K-Means Clustering (KMC)
- Used to segment respondents into distinct clusters based on PCA results.
- Optimal number of clusters was determined using the Elbow Method and Silhouette Score.
- 3 Clusters were identified:
  - Cluster 1 (Hopeful): High energy but low personal relations and enjoyment of life.
  - Cluster 2 (Confident/Optimist): High body appearance, but low support from friends and leisure.
  - Cluster 3 (Pessimists working on themselves): High income, living conditions, and bodily appearance, but low enjoyment of life.
4. Hierarchical Clustering
- Hierarchical clustering using Ward’s method was explored as an alternative to KMC, especially for handling ordered categorical data.
- 10 clusters were identified, with 3 closely resembling the original KMC clusters.

## Key Findings
Cluster Characteristics
- Cluster 1 (Hopeful): High energy and satisfaction with living space, but lower personal relationships and life enjoyment.
- Cluster 2 (Confident/Optimist): High satisfaction with body appearance and health, but lower leisure opportunities and daily activity performance.
- Cluster 3 (Pessimists working on themselves): High satisfaction across multiple dimensions (health, living conditions, income), but lower personal relationships and enjoyment of life.
Method Comparison
- While K-Means Clustering identified 3 key groups, Hierarchical Clustering provided more granularity with 10 clusters, though the 3 largest clusters were aligned with the KMC results.

## Conclusion
This project highlights the application of clustering techniques to segment respondents based on life satisfaction. Both K-Means and Hierarchical Clustering provide valuable insights, with K-Means offering simplicity and Hierarchical Clustering delivering more detailed groupings. These findings can inform policies and interventions aimed at improving life satisfaction across different demographic groups.
