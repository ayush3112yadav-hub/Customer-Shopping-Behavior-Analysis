# Customer Shopping Behavior Analysis

An end-to-end analysis of 3,900 retail transactions using **Python, SQL Server and Power BI**, turning raw shopping data into an interactive dashboard of business insights.

---

## Problem Statement

Retailers need to know who their customers are and which segments and products actually drive revenue. This project analyses customer shopping data to answer questions such as:

- Which product categories generate the most revenue?
- Which age groups and genders contribute the most to sales?
- Do subscribers spend more than non-subscribers?
- Do customers who pay for faster shipping spend more?
- Which products depend most on discounts, and which are rated highest?
- How do new, returning and loyal customers compare?

---

## Dataset

| Detail | Description |
|---|---|
| **File** | `customer_behavior.csv` |
| **Size** | 3,900 rows and 18 columns |
| **Customer details** | Customer ID, age, gender, location |
| **Purchase details** | Item purchased, category, purchase amount (USD), size, color, season |
| **Behaviour details** | Review rating, subscription status, shipping type, discount applied, promo code used, previous purchases, payment method, frequency of purchases |

---

## Tools Used

| Tool | Purpose |
|---|---|
| **Python (pandas, SQLAlchemy)** | Data cleaning, feature engineering and loading data into SQL Server (Jupyter notebook in VS Code) |
| **SQL Server (T-SQL)** | Stored the cleaned data and answered 8 business questions with aggregations, CTEs and window functions |
| **Power BI** | Interactive dashboard with KPIs, slicers (gender, category, season) and a key insights panel |

---

## Project Workflow

1. **Explore:** checked shape, data types, missing values and duplicates.
2. **Clean (Python):**
   - Standardised column names to lowercase with underscores and renamed `purchase_amount_(usd)` to `purchase_amount`.
   - Filled 37 missing review ratings with the median rating of each product category.
   - Checked for and removed duplicate rows.
   - Dropped `promo_code_used` because it was identical to `discount_applied`.
3. **Feature engineering:**
   - `age_group`: Young Adult (up to 25), Adult (26-40), Middle-aged (41-55), Senior (56+).
   - `purchase_frequency_days`: converted purchase frequency (weekly, monthly, etc.) into a number of days.
4. **Load:** wrote the cleaned data to SQL Server using SQLAlchemy.
5. **Analyse (SQL):** ran 8 queries covering revenue by gender and age group, shipping type, subscription impact, discount dependence, customer segments and top products per category.
6. **Visualise (Power BI):** built the dashboard on top of the SQL Server table.

---

## Key Findings

1. **Clothing and Accessories drive the business.** Clothing brings in about 45% of revenue ($104K) and Accessories add about 32% ($74K), so these two categories make up roughly three quarters of sales. Outerwear is the smallest at $19K.
2. **Young Adults (up to 25) contribute the least.** They generate about 15% of revenue ($35K), while Adults, Middle-aged and Senior customers each contribute around $65K-$67K.
3. **Subscribers do not spend more per order.** Average order value is $59.49 for subscribers vs. $59.87 for non-subscribers, and subscribers account for about 27% of revenue. The subscription programme is not yet translating into higher spend.
4. **Male customers generate about 68% of revenue** ($157.9K of $233.1K), but this comes from order volume (about 2,650 of 3,900 orders). Average order value is almost identical for both genders (about $60).
5. **Revenue is evenly spread across seasons and states.** Seasonal revenue ranges only from $56K to $60K, and the top 10 states each bring in about $5.2K-$5.8K, so there is no strong seasonal or regional pattern.

**Headline numbers:** Total revenue $233,081 | 3,900 customers | Average rating 3.75 | Average order value $59.76

---

## Dashboard Preview

![Customer Shopping Behavior Dashboard](images/dashboard.jpg)

---

## Repository Structure

```
├── customer_behavior.csv                # Raw dataset
├── Customer_Behavior.ipynb              # Data cleaning and feature engineering (Python)
├── C_B.sql                              # SQL analysis (8 business questions)
├── Customer_Shopping_Behavior.pbix      # Power BI dashboard
├── images/
│   └── dashboard.jpg                    # Dashboard screenshot
└── README.md
```

---

## How to Reproduce

1. Clone this repository.
2. Run `Customer_Behavior.ipynb` to clean the data and load it into SQL Server (update the connection string for your own server).
3. Run the queries in `C_B.sql` against your database.
4. Open `Customer_Shopping_Behavior.pbix` in Power BI Desktop and point the data source to your SQL Server table.

---

## Author

**Ayush Yadav**
Aspiring Data Analyst | SQL, Python, Tableau, Power BI
[www.linkedin.com/in/ayush-yadav-914246198]
# Customer-Shopping-Behavior-Analysis
End-to-end analysis of customer shopping behavior using Python, SQL Server and Power BI, with an interactive dashboard of sales and customer insights.
