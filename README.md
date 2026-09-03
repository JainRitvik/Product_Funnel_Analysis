# E-commerce Product Funnel & Conversion Analysis

## Project Overview

This project analyzes e-commerce website sessions, pageviews, and orders to understand **conversion performance, landing-page effectiveness, traffic sources, customer behavior, and revenue performance**.

The objective was to identify areas of the customer journey that could represent opportunities for improving website conversion and business performance.

The analysis was performed using **PostgreSQL for data analysis and SQL** and **Power BI for interactive visualization and reporting**.

---

## Business Problem

An e-commerce business wants to better understand how website traffic converts into orders.

The analysis focuses on questions such as:

* What percentage of website sessions result in an order?
* How does conversion differ between desktop and mobile users?
* Which traffic sources generate the most sessions and orders?
* How has conversion changed over time?
* Which landing pages perform best and worst?
* Do repeat sessions convert better than new sessions?
* What is the overall revenue, average order value, and profit generated?

---

## Dataset

The project uses the **Maven Analytics Toy Store E-Commerce Database**, a multi-table e-commerce dataset containing website session, pageview, and order information.

For this analysis, three tables were used:

* `website_sessions` — website traffic and session information
* `website_pageviews` — pages viewed during each session
* `orders` — completed purchases and order-level financial information

Source: Maven Analytics Data Playground

---

## Tools & Technologies

* **PostgreSQL** — data validation, transformation, and SQL analysis
* **SQL** — joins, aggregations, CTEs, CASE statements, subqueries, and window functions
* **Power BI** — dashboard development and data visualization

---

## Data Validation

Before beginning the analysis, the dataset was checked for:

* Row counts
* Duplicate primary keys
* Missing values
* Date ranges
* Basic data consistency

The three tables contained no missing values in the fields analyzed and no duplicate primary-key records were identified.

### Dataset Size

| Table             |      Rows |
| ----------------- | --------: |
| Website Sessions  |   472,871 |
| Website Pageviews | 1,188,124 |
| Orders            |    32,313 |

---

## Key Analysis

### Overall Conversion

The website generated:

* **472,871 sessions**
* **32,313 orders**
* **6.83% overall session-to-order conversion rate**

### Conversion by Device

| Device  | Sessions | Conversion Rate |
| ------- | -------: | --------------: |
| Desktop |  327,027 |       **8.50%** |
| Mobile  |  145,844 |       **3.09%** |

Desktop sessions converted at substantially higher rates than mobile sessions, making mobile conversion an important area for further investigation.

### Conversion by Traffic Source

| Traffic Source        | Sessions | Conversion Rate |
| --------------------- | -------: | --------------: |
| Unattributed / Direct |   83,328 |       **7.34%** |
| bsearch               |   62,823 |       **7.19%** |
| gsearch               |  316,035 |       **6.75%** |
| socialbook            |   10,685 |       **3.21%** |

Unattributed/direct traffic and bsearch showed the highest conversion rates, while socialbook had the lowest conversion rate.

### Landing Page Performance

Landing-page performance varied considerably:

| Landing Page | Sessions | Conversion Rate |
| ------------ | -------: | --------------: |
| `/lander-5`  |   68,166 |      **10.17%** |
| `/lander-2`  |  131,170 |       **7.72%** |
| `/lander-4`  |    9,385 |       **7.54%** |
| `/home`      |  137,576 |       **7.06%** |
| `/lander-1`  |   47,574 |       **4.53%** |
| `/lander-3`  |   79,000 |       **3.39%** |

`/lander-5` was the strongest-performing landing page, while `/lander-3` had the lowest conversion rate despite receiving substantial traffic.

### New vs Repeat Sessions

| Session Type | Sessions | Conversion Rate |
| ------------ | -------: | --------------: |
| New          |  394,318 |       **6.64%** |
| Repeat       |   78,553 |       **7.83%** |

Repeat sessions converted at a higher rate than new sessions.

### Revenue & Profitability

* **Total Revenue:** $1,938,509.75
* **Total Orders:** 32,313
* **Average Order Value:** $59.99
* **Total Profit:** $1,216,139.50
* **Approx. Gross Margin:** 62.7%

---

## Power BI Dashboard

The Power BI dashboard contains two pages.

### Page 1 — Overview

The overview dashboard provides a high-level view of:

* Total sessions
* Total orders
* Conversion rate
* Total revenue
* Average order value
* Monthly conversion trend
* Conversion by device
* Traffic-source distribution
* Traffic-source volume
* Landing-page traffic vs conversion
* Landing-page performance
* Date-range filtering

### Page 2 — Landing Page & Revenue

The second page focuses on:

* Total revenue
* Average order value
* Total profit
* New vs repeat conversion
* Revenue by device
* Landing-page conversion performance
* Key insights and recommendations

---

## Key Business Insights

### 1. Mobile conversion is significantly lower

Mobile sessions converted at **3.09%**, compared with **8.50% on desktop**.

This suggests that the mobile customer journey should be investigated for potential usability, performance, or checkout issues.

### 2. Landing-page performance varies significantly

Conversion rates ranged from **3.39% to 10.17%** across the analyzed landing pages.

High-traffic, low-conversion pages represent potential opportunities for further investigation and optimization.

### 3. Repeat sessions convert better

Repeat sessions achieved a **7.83% conversion rate**, compared with **6.64% for new sessions**.

This indicates that returning visitors were more likely to complete a purchase.

### 4. Conversion improved over time

Monthly conversion increased from approximately **3.19% in March 2012** to **8.31% in March 2015**, more than doubling over the analysis period.

The trend indicates a substantial improvement in conversion performance over time, although the analysis does not establish the specific causes.

---

## Recommendations

Based on the analysis:

1. **Investigate mobile conversion performance**
   Review the mobile user journey, page experience, and checkout process to identify potential conversion barriers.

2. **Investigate underperforming landing pages**
   Prioritize high-traffic pages with below-average conversion rates for further analysis and testing.

3. **Study high-performing landing pages**
   Examine the content, traffic mix, and user behavior associated with higher-converting landing pages.

4. **Understand repeat-user behavior**
   Analyze what differentiates repeat sessions from new sessions and identify opportunities to improve retention and conversion.

5. **Prioritize optimization using both traffic and conversion**
   High-volume pages with low conversion can represent larger potential opportunities than low-volume pages with similar conversion issues.

> These findings represent associations observed in the available data. Further experimentation, such as A/B testing, would be required to establish causality.

---

## SQL Techniques Demonstrated

The analysis includes practical SQL techniques commonly used by data analysts:

* `SELECT`
* `WHERE`
* `GROUP BY`
* `HAVING`
* `CASE WHEN`
* `COUNT`
* `COUNT(DISTINCT)`
* `SUM`
* `AVG`
* `COALESCE`
* Date functions
* `JOIN`
* Subqueries
* CTEs
* `ROW_NUMBER()` window function

The SQL was intentionally kept focused on practical business questions rather than unnecessary complexity.

---

## Project Structure

```text
ecommerce-product-funnel-analysis/
│
├── README.md
│
├── SQL/
│   ├── 01_data_validation.sql
│   ├── 02_funnel_analysis.sql
│   └── 03_business_analysis.sql
│
├── PowerBI/
│   └── ecommerce_product_funnel_analysis.pbix
│
└── Dashboard/
    ├── overview.png
    └── landing_page_revenue.png
```

---

## Conclusion

The analysis provides a practical view of e-commerce conversion performance across devices, traffic sources, landing pages, and customer session types.

The strongest opportunities identified were the **large conversion gap between desktop and mobile**, the **significant variation in landing-page performance**, and the **higher conversion rate among repeat sessions**.

The project demonstrates an end-to-end analytics workflow from **data validation and SQL analysis to business-focused Power BI reporting**.
