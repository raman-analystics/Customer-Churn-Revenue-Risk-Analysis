📊 Customer Churn & Revenue Risk Analysis
SQL + Tableau | End-to-End Data Analytics Project

🧠 Project Overview
Customer retention is one of the most critical drivers of long-term revenue in e-commerce. This project analyzes customer behavior to identify churn risk, revenue concentration, and high-impact retention opportunities.
Using transactional data, I built a customer segmentation and churn analysis framework, and translated insights into a decision-oriented dashboard for business stakeholders.

🎯 Business Objective
* Identify which customers are at risk of churn
* Understand where revenue is concentrated
* Detect high-value customers likely to churn
* Provide actionable strategies to improve retention and maximize revenue

🛠️ Tools & Technologies
* SQL (MySQL) → Data cleaning, transformation, feature engineering
* Tableau Public → Dashboard design and visualization
* Excel/CSV → Data source

📂 Dataset
* Transaction-level e-commerce dataset
* Key fields:
    * CustomerID
    * InvoiceDate
    * Revenue
    * Quantity
    * Price

⚙️ Data Preparation & Feature Engineering
🔹 1. Customer-Level Aggregation
* Total Revenue per customer
* Total Orders
* Average Order Value (AOV)

🔹 2. Recency Calculation
* Calculated days since last purchase
* Used as a proxy for customer engagement

🔹 3. Customer Segmentation (Lifecycle-Based)
Customers were segmented into:
* Champions → Highly active, high-value
* Loyal → Consistent repeat buyers
* Potential → Moderate engagement
* At Risk → Declining activity
* Lost → Inactive for extended period

🔹 4. Churn Definition
Churn was defined as:
Customers inactive for more than 120 days
This threshold was selected based on observed behavioral patterns in the data.

📊 Dashboard Overview
The dashboard is designed for executive-level decision making, answering:
* What is the current business performance?
* Where is revenue coming from?
* Which customers are at risk?
* What actions should be taken?

🔑 Key Insights
📉 1. High Churn Rate Signals Retention Challenge
* ~47% of customers are inactive beyond 90–120 days
* Indicates significant drop-off in customer engagement

👥 2. Customer Base Dominated by Lost Segment
* Largest segment consists of inactive customers
* Suggests weak long-term retention

💰 3. Revenue is Highly Concentrated
* Champions contribute 60% of revenue around $11M. 
* Business is heavily dependent on a small group of high-value customers

⚠️ 4. At-Risk Segment is the Critical Opportunity
* ~60% churn rate in “At Risk” customers
* Represents the highest ROI intervention segment

⏱️ 5. Clear Churn Threshold Identified
* Churn probability increases sharply after 90–120 days of inactivity
* Defines a measurable behavioral tipping point

🎯 6. High-Value Customers at Risk of Churn
* Identified cluster of high-revenue but low-frequency customers
* These customers represent maximum revenue risk if lost

🚀 Strategic Recommendations
* Prioritize At-Risk Customers: Intervene before the 90-day inactivity threshold to prevent churn escalation
* Re-activate High-Value Lost Customers: Launch targeted win-back campaigns for previously high-revenue users
* Strengthen Champion Retention: Implement loyalty programs to protect core revenue drivers
* Trigger Early Re-engagement: Automate campaigns based on inactivity signals
* Optimize Retention Spend: Focus efforts on high-value and high-risk segments for maximum ROI

📈 Business Impact
If implemented, these strategies can:
* Reduce churn in high-risk segments
* Improve customer lifetime value (CLV)
* Protect and grow high-value customer base
* Increase overall revenue retention
