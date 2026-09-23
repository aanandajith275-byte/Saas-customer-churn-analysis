# SaaS Customer Churn Analysis

## Project Overview

This project analyzes customer churn for a SaaS business to identify customer segments associated with higher churn, understand possible drivers of churn, and translate the analysis into retention-focused business insights.

The core workflow remains **SQL analysis + Power BI visualization**, but the SQL layer has been expanded to go beyond simple industry and plan-level churn counts.

## Business Objective

The analysis focuses on:

- Overall customer churn
- Churn by industry and plan tier
- Customer-size segments
- Acquisition / referral sources
- Billing and auto-renewal behaviour
- Revenue at risk from churn
- Churn reasons
- Feature adoption and churn
- Support-ticket behaviour
- Monthly churn trends
- Industry × plan retention segments

## Tools Used

- SQL
- SQLite / DB Browser for SQLite
- Microsoft Excel
- Power BI

## Dataset

The project uses a SaaS customer dataset containing account, subscription, product-usage, support, and churn-event information.

Main tables:

- **accounts** — customer profile and churn status
- **subscriptions** — plans, seats, MRR/ARR, billing and renewal information
- **feature_usage** — product feature usage
- **support_tickets** — support volume, response/resolution time and escalations
- **churn_events** — churn dates, reasons, refunds and customer feedback

The analysis contains 500 customer accounts.

## SQL Analysis

The expanded SQL analysis is available in:

`sql/churn_analysis.sql`

It includes:

1. Executive churn KPIs
2. Churn by industry
3. Churn by plan tier
4. Churn by referral source
5. Churn by customer-size band
6. Billing frequency × auto-renewal analysis
7. Churned MRR and ARR by plan
8. Churn reasons and their share of churn events
9. Feature usage vs churn
10. Support response, resolution and escalation behaviour
11. Monthly churn trend with a cumulative window calculation
12. Industry × plan retention segmentation

This adds more analytical depth while keeping the original project idea unchanged.

## Example SQL Techniques

The analysis uses practical SQL patterns that are useful for analyst interviews:

- `CASE WHEN` for segmentation
- `GROUP BY` and `HAVING`
- Multiple-table `JOIN`s
- Conditional aggregation
- CTEs
- Window functions
- Revenue aggregation
- Segment-level churn rates

For example, the project uses a window function to calculate cumulative churn over time:

```sql
SUM(churned_customers) OVER (
    ORDER BY churn_month
) AS cumulative_churn
```

## Dashboard

The Power BI dashboard presents the SQL findings visually.

### Executive Overview

![Executive Overview](dashboard/executive_overview.png)

The overview focuses on the main customer and churn KPIs and gives a quick view of the customer base.

### Churn Insights

![Churn Insights](dashboard/churn_insights.png)

The second page focuses on churn patterns across customer segments and supports the retention analysis.

## Key Analysis Areas

### Customer Segmentation

Churn is compared across:

- Industry
- Plan tier
- Customer size
- Referral source
- Billing frequency
- Auto-renewal status

This helps distinguish overall churn from segment-specific retention problems.

### Revenue at Risk

Instead of only counting churned customers, the SQL analysis also calculates churned MRR and ARR by plan tier.

This gives the analysis a revenue perspective:

**customer churn → recurring revenue at risk**

### Product Usage

Feature-level usage is joined to subscription and account data to compare churn rates across product features.

This can help identify areas where adoption and retention should be investigated further.

### Support Experience

Support tickets are connected back to customer churn status to compare:

- Ticket volume
- First-response time
- Resolution time
- Escalation rate

These are treated as relationships to investigate, not proof that support behaviour causes churn.

### Churn Reasons

The churn-event table is used to summarize reasons such as:

- Pricing
- Features
- Support
- Budget
- Competitor
- Unknown

This provides a direct view of the reasons recorded at churn.

## Business Interpretation

The project is designed to move from:

**Descriptive analysis → segmentation → retention action**

Examples of questions the analysis can answer:

- Which customer segments have elevated churn?
- Which plans contribute more churned recurring revenue?
- Are some acquisition channels associated with higher churn?
- Does auto-renewal behaviour differ between churned and retained customers?
- Which product features show different churn rates?
- How do support metrics differ between churned and active customers?
- Which recorded churn reasons occur most frequently?

The results can then be used to prioritize retention investigations and customer-engagement strategies.

## Limitations

- The dataset is a constructed/public analytical dataset rather than a live SaaS production database.
- Observed relationships do not establish causation.
- Feature usage and support metrics should be interpreted alongside customer context.
- Churn-event reasons depend on the recorded reason codes and feedback.
- The project is an analytical portfolio project and does not represent a production churn-prediction system.

## Project Structure

```text
Saas-customer-churn-analysis/
├── README.md
├── data/
│   ├── raw/
│   └── analysis/
├── sql/
│   ├── Churn Analysis.sqbpro
│   └── churn_analysis.sql
├── powerbi/
│   └── Customer Churn Analysis.pbix
└── dashboard/
    ├── executive_overview.png
    └── churn_insights.png
```

## How to Use

1. Open the database in SQLite / DB Browser for SQLite.
2. Run the queries in `sql/churn_analysis.sql`.
3. Review the grouped outputs for segment and retention analysis.
4. Open the Power BI file to explore the dashboard visuals.
5. Use the SQL results together with the dashboard to communicate the business implications.

## Author

Aanand Ajith  
B.Tech Mechanical Engineering, IIT Hyderabad
