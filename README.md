# Predicting Sri Lanka's Gross Domestic Product Using Multiple Linear Regression with Macroeconomic Indicators

## Project Overview

This group research project investigates the relationship between Sri Lanka's GDP per capita and selected macroeconomic indicators using Multiple Linear Regression.

The study uses historical World Bank data to identify significant economic factors associated with GDP per capita and develop a statistical prediction model.

## Group Members

- H. Kavinduni Tharushika Handagala
- D. I. B. Samarasinghe
- J. M. D. R. L. Jayamaha
- K. Gokul

## Academic Information

- **University:** University of Ruhuna, Sri Lanka
- **Faculty:** Faculty of Science
- **Department:** Department of Mathematics
- **Degree:** BSc (Hons) in Financial Mathematics and Industrial Statistics
- **Course:** Level II Case Study I (MIS2231)
- **Supervisor:** Dr. K. D. Prasangika
- **Year:** 2025

## Research Objectives

- Identify macroeconomic indicators associated with Sri Lanka's GDP per capita.
- Examine the individual and combined effects of selected economic indicators.
- Develop a Multiple Linear Regression model.
- Evaluate model fit, statistical significance, and regression assumptions.

## Dataset

- **Source:** World Bank Open Data
- **Country:** Sri Lanka
- **Period:** 1970–2023
- **Data Type:** Annual macroeconomic indicators

### Variables

**Dependent Variable:**
- Natural logarithm of GDP per capita (ln GDP)

**Independent Variables:**
- Population Growth
- Gross Capital Formation
- Domestic Credit to the Private Sector
- Foreign Direct Investment (FDI)
- Trade

## Tools and Techniques

- **Programming Language:** R
- **Statistical Software:** RStudio
- **Statistical Method:** Multiple Linear Regression
- **Model Estimation:** Ordinary Least Squares
- **Variable Selection:** Best Subset Regression
- **Model Evaluation:** ANOVA, Partial F-Test, R-squared, and Regression Diagnostics

## Methodology

1. Collect macroeconomic data from the World Bank.
2. Perform data cleaning and missing-value treatment.
3. Conduct exploratory data analysis.
4. Examine correlations between variables.
5. Fit a multiple linear regression model.
6. Select a reduced model using significant predictors.
7. Evaluate model performance and regression assumptions.

## Key Findings

The full regression model explained approximately **85.02%** of the variation in the dependent variable (R-squared = 0.8502).

The analysis identified three statistically significant predictors:

| Variable | Relationship with ln GDP |
|---|---|
| Domestic Credit | Positive |
| Foreign Direct Investment | Positive |
| Trade | Negative |

Gross Capital Formation and Population Growth were not statistically significant at the 5% level in the full regression model.

A reduced model using Domestic Credit, FDI, and Trade explained approximately 83% of the variation in ln GDP.

These findings describe statistical associations within the study and do not, by themselves, establish causal relationships.

## Project Files

- Case_Study_Report.pdf – Research report
- GDP_Prediction_Multiple_Regression.R – R code for statistical analysis

**Note:** The R script requires the appropriate dataset and R packages. The report contains some inconsistencies in reported observation counts and results; refer to the original report for full details.

## Disclaimer

This project was conducted for academic and educational purposes. The findings are based on historical economic data and should not be interpreted as official economic forecasts or policy recommendations.
