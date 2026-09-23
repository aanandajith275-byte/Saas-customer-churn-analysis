-- SaaS Customer Churn Analysis
-- SQLite / DB Browser for SQLite
-- Core idea: understand where churn is concentrated and what customer
-- characteristics can be used for retention analysis.

-- 1. Executive KPIs
SELECT
    COUNT(*) AS total_customers,
    SUM(CASE WHEN churn_flag = 'TRUE' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        100.0 * SUM(CASE WHEN churn_flag = 'TRUE' THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS churn_rate,
    ROUND(AVG(seats), 1) AS avg_seats,
    ROUND(
        100.0 * SUM(CASE WHEN is_trial = 'TRUE' THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS trial_share
FROM accounts;


-- 2. Churn by industry with customer volume
SELECT
    industry,
    COUNT(*) AS customers,
    SUM(CASE WHEN churn_flag = 'TRUE' THEN 1 ELSE 0 END) AS churned,
    ROUND(
        100.0 * SUM(CASE WHEN churn_flag = 'TRUE' THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS churn_rate
FROM accounts
GROUP BY industry
HAVING COUNT(*) >= 20
ORDER BY churn_rate DESC;


-- 3. Churn by plan tier
SELECT
    plan_tier,
    COUNT(*) AS customers,
    SUM(CASE WHEN churn_flag = 'TRUE' THEN 1 ELSE 0 END) AS churned,
    ROUND(
        100.0 * SUM(CASE WHEN churn_flag = 'TRUE' THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS churn_rate,
    ROUND(AVG(seats), 1) AS avg_seats
FROM accounts
GROUP BY plan_tier
ORDER BY churn_rate DESC;


-- 4. Churn by acquisition / referral source
SELECT
    referral_source,
    COUNT(*) AS customers,
    SUM(CASE WHEN churn_flag = 'TRUE' THEN 1 ELSE 0 END) AS churned,
    ROUND(
        100.0 * SUM(CASE WHEN churn_flag = 'TRUE' THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS churn_rate
FROM accounts
GROUP BY referral_source
ORDER BY churn_rate DESC;


-- 5. Churn by customer size
WITH customer_size AS (
    SELECT
        account_id,
        churn_flag,
        CASE
            WHEN seats <= 10 THEN '1-10'
            WHEN seats <= 25 THEN '11-25'
            WHEN seats <= 50 THEN '26-50'
            ELSE '51+'
        END AS seat_band
    FROM accounts
)
SELECT
    seat_band,
    COUNT(*) AS customers,
    SUM(CASE WHEN churn_flag = 'TRUE' THEN 1 ELSE 0 END) AS churned,
    ROUND(
        100.0 * SUM(CASE WHEN churn_flag = 'TRUE' THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS churn_rate
FROM customer_size
GROUP BY seat_band
ORDER BY
    CASE seat_band
        WHEN '1-10' THEN 1
        WHEN '11-25' THEN 2
        WHEN '26-50' THEN 3
        ELSE 4
    END;


-- 6. Billing and auto-renewal behaviour
SELECT
    billing_frequency,
    auto_renew_flag,
    COUNT(*) AS subscriptions,
    SUM(CASE WHEN churn_flag = 'TRUE' THEN 1 ELSE 0 END) AS churned,
    ROUND(
        100.0 * SUM(CASE WHEN churn_flag = 'TRUE' THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS churn_rate,
    ROUND(SUM(mrr_amount), 2) AS mrr
FROM subscriptions
GROUP BY billing_frequency, auto_renew_flag
ORDER BY churn_rate DESC;


-- 7. Revenue at risk from churned subscriptions
SELECT
    plan_tier,
    COUNT(*) AS churned_subscriptions,
    ROUND(SUM(mrr_amount), 2) AS churned_mrr,
    ROUND(SUM(arr_amount), 2) AS churned_arr
FROM subscriptions
WHERE churn_flag = 'TRUE'
GROUP BY plan_tier
ORDER BY churned_arr DESC;


-- 8. Churn reasons
SELECT
    reason_code,
    COUNT(*) AS churn_events,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS share_of_churn_events,
    ROUND(AVG(refund_amount_usd), 2) AS avg_refund
FROM churn_events
GROUP BY reason_code
ORDER BY churn_events DESC;


-- 9. Feature usage and churn
SELECT
    f.feature_name,
    COUNT(DISTINCT a.account_id) AS customers,
    COUNT(DISTINCT CASE WHEN a.churn_flag = 'TRUE' THEN a.account_id END) AS churned_customers,
    ROUND(
        100.0 * COUNT(DISTINCT CASE WHEN a.churn_flag = 'TRUE' THEN a.account_id END)
        / COUNT(DISTINCT a.account_id),
        2
    ) AS churn_rate
FROM feature_usage f
JOIN subscriptions s
    ON f.subscription_id = s.subscription_id
JOIN accounts a
    ON s.account_id = a.account_id
GROUP BY f.feature_name
HAVING COUNT(DISTINCT a.account_id) >= 20
ORDER BY churn_rate DESC;


-- 10. Support experience by customer status
SELECT
    CASE
        WHEN a.churn_flag = 'TRUE' THEN 'Churned'
        ELSE 'Active'
    END AS customer_status,
    COUNT(s.ticket_id) AS tickets,
    ROUND(AVG(s.resolution_time_hours), 2) AS avg_resolution_hours,
    ROUND(AVG(s.first_response_hours), 2) AS avg_first_response_hours,
    ROUND(
        100.0 * SUM(CASE WHEN s.escalation_flag = 'TRUE' THEN 1 ELSE 0 END)
        / COUNT(s.ticket_id),
        2
    ) AS escalation_rate
FROM accounts a
JOIN support_tickets s
    ON a.account_id = s.account_id
GROUP BY a.churn_flag
ORDER BY customer_status;


-- 11. Monthly churn trend
WITH monthly AS (
    SELECT
        substr(churn_date, 7, 4) || '-' || substr(churn_date, 4, 2) AS churn_month,
        COUNT(*) AS churned_customers
    FROM churn_events
    GROUP BY churn_month
)
SELECT
    churn_month,
    churned_customers,
    SUM(churned_customers) OVER (ORDER BY churn_month) AS cumulative_churn
FROM monthly
ORDER BY churn_month;


-- 12. Segment-level retention view
WITH segment AS (
    SELECT
        industry,
        plan_tier,
        COUNT(*) AS customers,
        SUM(CASE WHEN churn_flag = 'TRUE' THEN 1 ELSE 0 END) AS churned
    FROM accounts
    GROUP BY industry, plan_tier
)
SELECT
    industry,
    plan_tier,
    customers,
    churned,
    ROUND(100.0 * churned / customers, 2) AS churn_rate,
    CASE
        WHEN 100.0 * churned / customers >= 30 THEN 'High churn segment'
        WHEN 100.0 * churned / customers >= 20 THEN 'Watch segment'
        ELSE 'Lower churn segment'
    END AS segment_status
FROM segment
WHERE customers >= 10
ORDER BY churn_rate DESC;
