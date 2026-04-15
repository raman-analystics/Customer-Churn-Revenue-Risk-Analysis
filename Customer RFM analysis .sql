-- Raw data file.   (retail_data).

-- base table....
CREATE VIEW sales_all AS
SELECT 
    Invoice,
    `Customer ID` AS CustomerID,
    StockCode,
    InvoiceDate,
    Quantity,
    Price,
    Quantity * Price AS revenue
FROM retail_data;

-- customer data only...
CREATE VIEW base_sales AS
SELECT *
FROM sales_all
WHERE CustomerID IS NOT NULL;

-- customer summary table for behavioural analysis....
CREATE VIEW customer_summary AS
SELECT
    CustomerID,
    COUNT(DISTINCT Invoice) AS total_orders,
    SUM(revenue) AS total_revenue,
    AVG(revenue) AS avg_transaction_value,
    MIN(InvoiceDate) AS first_purchase,
    MAX(InvoiceDate) AS last_purchase
FROM base_sales
GROUP BY CustomerID;

-- Purchase frequency....
CREATE VIEW customer_frequency AS
SELECT
    CustomerID,
    COUNT(DISTINCT Invoice) AS frequency,
    SUM(revenue) / COUNT(DISTINCT Invoice) AS avg_order_value
FROM base_sales
GROUP BY CustomerID;

-- time gap between puchases...
CREATE VIEW purchase_gaps AS
SELECT
    CustomerID,
    InvoiceDate,
    LAG(InvoiceDate) OVER (
        PARTITION BY CustomerID 
        ORDER BY InvoiceDate
    ) AS prev_date,
    
    DATEDIFF(
        InvoiceDate,
        LAG(InvoiceDate) OVER (
            PARTITION BY CustomerID 
            ORDER BY InvoiceDate
        )
    ) AS days_between
FROM base_sales;

-- avg purchase velocity...
CREATE VIEW customer_velocity AS
SELECT
    CustomerID,
    AVG(days_between) AS avg_days_between_purchases
FROM purchase_gaps
WHERE days_between IS NOT NULL
GROUP BY CustomerID;

--  RFM BASE....
CREATE VIEW rfm_base AS
SELECT
    CustomerID,
    DATEDIFF(CURDATE(), MAX(InvoiceDate)) AS recency,
    COUNT(DISTINCT Invoice) AS frequency,
    SUM(revenue) AS monetary
FROM base_sales
GROUP BY CustomerID;

-- RFM scoring...
CREATE VIEW rfm_scores AS
SELECT *,
    NTILE(5) OVER (ORDER BY recency ASC) AS r_score,
    NTILE(5) OVER (ORDER BY frequency DESC) AS f_score,
    NTILE(5) OVER (ORDER BY monetary DESC) AS m_score
FROM rfm_base;

-- customer segmentation...
CREATE VIEW customer_segments AS
SELECT *,
    CASE 
        WHEN r_score >= 4 AND f_score >= 4 THEN 'Champions'
        WHEN r_score >= 4 AND f_score <= 2 THEN 'New Customers'
        WHEN r_score <= 2 AND f_score >= 4 THEN 'At Risk Loyal'
        WHEN r_score <= 2 THEN 'Churn Risk'
        ELSE 'Potential Loyalists'
    END AS segment
FROM rfm_scores;

-- Customer lifetime value...
CREATE VIEW clv AS
SELECT
    CustomerID,
    SUM(revenue) AS total_clv,
    COUNT(DISTINCT Invoice) AS total_orders,
    SUM(revenue) / COUNT(DISTINCT Invoice) AS avg_order_value
FROM base_sales
GROUP BY CustomerID;

-- churn risk .....
CREATE VIEW churn_risk AS
SELECT
    CustomerID,
    recency,
    CASE 
        WHEN recency > 180 THEN 'High Risk'
        WHEN recency BETWEEN 90 AND 180 THEN 'Medium Risk'
        ELSE 'Active'
    END AS churn_status
FROM rfm_base;

-- revenue concentration pareto...
CREATE VIEW revenue_rank AS
SELECT
    CustomerID,
    SUM(revenue) AS total_revenue,
    SUM(SUM(revenue)) OVER (ORDER BY SUM(revenue) DESC) AS running_total
FROM base_sales
GROUP BY CustomerID;


-- Customer survival span calculations in following tables.
CREATE VIEW customer_lifetime AS
SELECT
    CustomerID,
    MIN(InvoiceDate) AS first_purchase,
    MAX(InvoiceDate) AS last_purchase,

    DATEDIFF(MAX(InvoiceDate), MIN(InvoiceDate)) AS lifespan_days
FROM base_sales
GROUP BY CustomerID;

CREATE VIEW customer_recency AS
SELECT
    CustomerID,
    MAX(InvoiceDate) AS last_purchase,
    DATEDIFF(CURDATE(), MAX(InvoiceDate)) AS days_inactive
FROM base_sales
GROUP BY CustomerID;


CREATE VIEW survival_base AS
SELECT
    CustomerID,
    DATEDIFF(MAX(InvoiceDate), MIN(InvoiceDate)) AS lifespan_days,
    DATEDIFF(CURDATE(), MAX(InvoiceDate)) AS days_inactive,

    CASE 
        WHEN DATEDIFF(CURDATE(), MAX(InvoiceDate)) > 90 THEN 1
        ELSE 0
    END AS churn_event
FROM base_sales
GROUP BY CustomerID;


CREATE VIEW survival_buckets AS
SELECT
    CASE 
        WHEN lifespan_days <= 30 THEN '0-30 days'
        WHEN lifespan_days <= 90 THEN '30-90 days'
        WHEN lifespan_days <= 180 THEN '90-180 days'
        WHEN lifespan_days <= 365 THEN '180-365 days'
        ELSE '365+ days'
    END AS lifespan_group,

    COUNT(*) AS total_customers,
    SUM(churn_event) AS churned_customers
FROM survival_base
GROUP BY lifespan_group;

CREATE VIEW survival_rate AS
SELECT
    lifespan_group,
    total_customers,
    churned_customers,

    (total_customers - churned_customers) / total_customers AS survival_rate
FROM survival_buckets;

CREATE VIEW customer_risk AS
SELECT
    s.CustomerID,
    s.days_inactive,

    CASE 
        WHEN s.days_inactive > 180 THEN 'Critical Risk'
        WHEN s.days_inactive > 90 THEN 'High Risk'
        WHEN s.days_inactive > 30 THEN 'Medium Risk'
        ELSE 'Active'
    END AS churn_risk
FROM survival_base s;


-- Master table ....
CREATE OR REPLACE VIEW retail_master AS
SELECT
    r.CustomerID,

    -- RFM FEATURES
    r.recency,
    r.frequency,
    r.monetary,
    s.r_score,
    s.f_score,
    s.m_score,

    -- CLV
    c.total_clv,

    -- SURVIVAL / CHURN
    ch.churn_status,

    -- BEHAVIOUR
    v.avg_days_between_purchases,

    -- SURVIVAL SPAN
    sv.lifespan_days,
    sv.churn_event

FROM rfm_base r
LEFT JOIN rfm_scores s 
    ON r.CustomerID = s.CustomerID

LEFT JOIN clv c 
    ON r.CustomerID = c.CustomerID

LEFT JOIN churn_risk ch 
    ON r.CustomerID = ch.CustomerID

LEFT JOIN customer_velocity v 
    ON r.CustomerID = v.CustomerID

LEFT JOIN survival_base sv
    ON r.CustomerID = sv.CustomerID;























