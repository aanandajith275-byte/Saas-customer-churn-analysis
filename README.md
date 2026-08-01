# SaaS Customer Churn Analysis

## Project Overview

This project analyzes customer churn for a SaaS business to identify customer segments associated with higher churn and provide actionable business recommendations.

The analysis was performed using SQL and visualized using Power BI.

## Business Objective

The primary objective of this project is to understand:

- Overall customer churn
- Churn patterns across industries
- Churn patterns across subscription plan tiers
- Customer distribution across industries
- Potential areas for improving customer retention

## Tools Used

- SQL
- SQLite / DB Browser for SQLite
- Microsoft Excel
- Power BI

## Dataset

The project uses a SaaS customer dataset containing customer account information and churn-related data.

Key fields include:

- Account ID
- Account Name
- Industry
- Country
- Signup Date
- Referral Source
- Plan Tier
- Number of Seats
- Trial Status
- Churn Flag

## Analysis Performed

SQL was used to analyze customer-level data and calculate churn metrics.

The analysis included:

- Total number of customer accounts
- Number of churned customers
- Overall churn rate
- Churn rate by industry
- Churn rate by plan tier
- Analysis of customer segments and churn patterns

## Key Findings

- The overall customer churn rate was approximately 22%.
- Churn rates varied across industries.
- Churn rates also differed across plan tiers.
- Customer distribution varied across industries, highlighting differences in the composition of the customer base.

## Business Recommendations

Based on the analysis:

1. Prioritize retention strategies for customer segments with above-average churn.
2. Investigate the reasons behind higher churn in specific industries and plan tiers.
3. Develop targeted customer engagement strategies for high-risk segments.
4. Monitor churn metrics regularly to identify changes in customer retention.

## Dashboard

The Power BI dashboard contains two pages:

### Executive Overview

Provides a high-level summary of customer churn using KPI cards and visualizations.

### Churn Insights

Presents key findings, business recommendations, and customer distribution analysis.

## Project Structure

```text
data/        - Raw and processed datasets
sql/         - SQL analysis queries
powerbi/     - Power BI dashboard
reports/     - Project report
screenshots/ - Dashboard screenshots

