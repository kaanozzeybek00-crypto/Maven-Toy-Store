# Maven Toys | SQL Sales, Profit & Inventory Analysis

End-to-end exploratory analysis of the **Maven Toys** dataset using **SQL Server (T-SQL)**. The project goes beyond basic reporting and focuses on one question: **where does the business actually make (and lose) money?**

> **Key insight:** the best-selling product is not the most profitable product, and some of the most profitable products are the ones that run out of stock most often.

---

## Dataset

The Maven Toys dataset represents a toy retail chain operating stores in multiple cities in Mexico. It contains four tables:

| Table | Description |
|---|---|
| `Products` | Product name, category, cost and price |
| `Sales` | Transaction-level sales (date, store, product, units) |
| `Stores` | Store city, location type and open date |
| `Inventory` | Current stock on hand per store and product |

---

## Business Questions

1. What are total revenue, profit, units sold and overall profit margin?
2. How do revenue and profit change by year, month and season?
3. Which products and categories drive revenue vs. profit?
4. How do stores perform by city, location type and age?
5. Which products are suffering from stockouts, and what is the cost of that?
6. Which inventory is overstocked (dead stock) and which is moving too fast (star)?

---

## SQL Techniques Used

- `INNER JOIN` / `LEFT JOIN` across multiple tables
- Aggregations: `SUM`, `COUNT(DISTINCT ...)`, `ROUND`
- Calculated metrics: revenue, profit, profit margin %
- `CASE WHEN` for season, store age and stock health classification
- Subqueries / derived tables
- `NULLIF`, `ISNULL`, `CAST` for safe division and null handling
- Date functions: `YEAR()`, `MONTH()`
- `TOP N` ranking and `ORDER BY` on calculated columns

**Metric definitions**

```
Revenue = Units x Product_Price
Profit  = Units x (Product_Price - Product_Cost)
Margin  = Profit / Revenue x 100
```

---

## Key Findings

### Overall performance
| Metric | Value |
|---|---|
| Total revenue | ~144.4M |
| Total profit | ~40.1M |
| Overall profit margin | **27.7%** |

### 1. Revenue does not equal profit
- **Lego Bricks** ranks #1 in revenue but drops to #3 in profit (lower margin).
- **Colorbuds** is #2 in revenue but #1 in profit (strong margin performer).
- **Splash Balls** and **Magic Sand** are in the revenue top 10 but fall out of the profit top 10 (high volume, thin margin).
- **Glass Marbles**, **Barrel O' Slime** and **Dart Gun** are not in the revenue top 10 but are in the profit top 10 (low volume, high margin, worth promoting).

### 2. Stockouts are a hidden profit leak
- **Playfoam** is out of stock in **13 of 50 stores (26%)** and **Hot Wheels 5-Pack** in **12 of 50 (24%)**.
- Playfoam has a **63.7% margin**, one of the highest in the catalog, so frequent stockouts mean direct lost profit.

### 3. Beware of misleading year-over-year comparisons
- 2022 has 12 months of data, but 2023 only covers **January to September**.
- Raw annual totals make 2023 look like a decline, but a **like-for-like monthly comparison** shows 2023 outperformed 2022 in every matching month (~**46% growth**).
- Seasonal analysis has the same issue: 2023 Winter (2 of 3 months) and Autumn (1 of 3 months) are partial and should not be compared directly.

### 4. Store performance
- Store revenue ranges from about **20.6M** (Campeche) to **55.5M** (Ciudad de Mexico).
- Normalizing by store count shows **Airport** locations have strong per-store economics.
- Newer stores (opened 2010+) were compared against established ones (pre-2010) on a per-store average basis.

### 5. Stock health classification
Using `Stock_On_Hand / Total_Units_Sold`:
- **Dead Stock:** ratio > 0.5, or never sold
- **Star:** ratio < 0.05 (fast-moving, stockout risk)
- **Normal:** in between

---

## Recommendations

1. **Restock Playfoam and Hot Wheels 5-Pack first.** High stockout frequency and high margin means the highest opportunity cost.
2. **Review pricing and cost structure** for high-revenue, low-margin items (Splash Balls, Magic Sand).
3. **Promote low-volume, high-margin products** (Glass Marbles, Barrel O' Slime, Dart Gun).
4. **Weight future expansion toward Airport locations** given their per-store economics.
5. **Always compare equal time periods** before drawing conclusions from yearly totals.

---

## Repository Structure

```
.
├── README.md
└── maven_toys_analysis.sql    # All queries, with comments and findings
```

## How to Run

1. Import the Maven Toys CSV files into SQL Server as `dbo.Products`, `dbo.Sales`, `dbo.Stores` and `dbo.Inventory`.
2. Open `maven_toys_analysis.sql` in SQL Server Management Studio (SSMS) or Azure Data Studio.
3. Run the queries section by section. Each block has a comment explaining its purpose and findings.

## Tools

- Microsoft SQL Server (T-SQL)
- SSMS / Azure Data Studio

---

## About

Built as a portfolio project to practice turning raw data into business decisions with SQL.

Feedback and suggestions are welcome. Feel free to open an issue or connect with me on [LinkedIn](#).
