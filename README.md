# 🍕 Fauget Pizza: Sales Performance Dashboard 2015

An end-to-end analytics project for Fauget Pizza that turns one year of orders into an interactive Excel dashboard, then checks every number again with SQL. It answers a simple question for the shop owner: **when do we sell, what do we sell, and what should we do about it?** Built with Excel (pivot tables, pivot charts, timeline) and SQL Server (SSMS).

📊 [View Dashboard Screenshot](https://github.com/SahilBhowad/fauget-pizza-sales-dashboard/blob/main/images/dashboard.png) | 🗄️ [View SQL Queries](https://github.com/SahilBhowad/fauget-pizza-sales-dashboard/blob/main/sql/pizza_sales_analysis.sql) | 📥 [Download Excel File](https://github.com/SahilBhowad/fauget-pizza-sales-dashboard/tree/main/dashboard) | 🧾 **48,620 order lines analyzed**

---

## The story in short

Imagine you own Fauget Pizza. You have a full year of orders but no clear picture of them. You want to know:

> **When are we busiest, which pizzas and sizes make the money, and is the business steady through the year?**

The short answer from the data:

- Revenue was **$817,860** from **21,350 orders** and **49,574 pizzas**. The average order is **$38.31** with **2.32 pizzas** in it.
- There are **two daily rush hours**: 12 PM ($111,878) and 6 PM ($89,297).
- **Friday is the strongest day** ($136,074). Sunday is the slowest ($99,204).
- **Large pizzas bring 46% of revenue** ($375,319), far ahead of Medium (30%).
- **The Thai Chicken Pizza is the top seller** (about $43k). The Brie Carre Pizza is the weakest (about $12k).
- **Revenue is steady all year.** Every month sits between $64k and $73k.

These are patterns in one year of sales, not proof of why they happen.

---

## About the data

| | |
|---|---|
| **Size** | 48,620 rows (one row per pizza on an order), 21,350 orders |
| **Period** | 1 Jan 2015 to 31 Dec 2015 |
| **Original columns** | 12: `pizza_id`, `order_id`, `pizza_name_id`, `quantity`, `order_date`, `order_time`, `unit_price`, `total_price`, `pizza_size`, `pizza_category`, `pizza_ingredients`, `pizza_name` |
| **Columns I added in Excel** | `order_day`, `order_month`, `new_order` |

The data has one row per pizza, not per order, so counting rows would overcount orders (48,620 rows vs 21,350 orders). I handled this carefully in both tools (see below).

---

## What I did, step by step

1. **Loaded the data** into Excel and checked the columns and formats.
2. **Added helper columns** for the day name and month name (from the date), plus `new_order`, which marks the first row of each order with a 1 and the others with a 0.
3. **Built the Analysis sheet** with 9 pivot tables: headline KPIs, monthly trend, daily trend, hourly trend, revenue by category, revenue by size, revenue for all 32 pizzas, and Top 5 and Bottom 5 pizzas.
4. **Built the Validation sheet** with checks on row count, blank cells, unique pizza IDs, quantity and price. Every check passed.
5. **Designed the dashboard background** from a food photo, a dark layer on top, and rectangles as placeholders for charts and KPI cards.
6. **Added the KPI cards, 7 charts and one timeline.** Everything is connected to the pivot tables, so if the data changes, the Analysis sheet and the dashboard update too. Clicking a month in the timeline filters the dashboard.
7. **Added the Insights sheet** with a table of findings, evidence and recommendations.
8. **Repeated the numbers in SQL** and compared them with the dashboard.

---

## The Excel workbook

| Sheet | What it does |
|---|---|
| **Dashboard** | The final report: 3 KPI cards, 7 charts, a timeline filter |
| **Insights** | 5 findings, each with evidence and a recommendation |
| **Analysis** | The calculation layer: 9 pivot tables that feed the dashboard |
| **Validation** | Data quality checks (result vs expected) |
| **Data** | The raw data plus the helper columns |

Sheet order tells the story: what happened (Dashboard), what it means (Insights), how it was calculated (Analysis), proof it is clean (Validation), and the source (Data).

---

## The findings

| # | Finding | Evidence | Recommendation |
|---|---|---|---|
| 1 | Two daily rush hours | 12 PM and 6 PM have the highest revenue of the day | Prepare dough and add staff before 12 PM and 6 PM |
| 2 | Friday is the strongest day | Friday $136,074 vs Sunday $99,204 | Run offers on slower days like Sunday and Monday |
| 3 | Large size leads | 46% of total revenue comes from Large | Push Large combos and upsell Medium to Large |
| 4 | Top vs bottom pizzas | Thai Chicken $43k vs Brie Carre $12k | Promote top sellers, review the bottom 5 |
| 5 | Steady all year | Monthly revenue stays between $64k and $73k | Plan stock evenly through the year |

The recommendations are ideas from the numbers, not tested actions.

---

## SQL part

I loaded the original source file (no Excel edits) into SQL Server as `pizza_sales` and wrote 10 queries. Because SQL did not use my Excel helper columns, it works as an independent check of the dashboard.

- Row count and headline KPIs (revenue, orders, pizzas, average order value)
- Revenue by month, weekday and hour
- Revenue share by pizza size and category
- Top 5 and bottom 5 pizzas by revenue
- The same data quality checks as the Validation sheet

Each query has a short insight line under it. The numbers match the dashboard.

**How SQL handles the "orders vs rows" problem:** `COUNT(DISTINCT order_id)` gives 21,350 orders directly. In Excel, pivot tables cannot do a distinct count without the Data Model, so I used the `new_order` helper column instead. Both give the same answer.

File: `sql/pizza_sales_analysis.sql`

---

## The dashboard

![Pizza Sales Dashboard](https://github.com/SahilBhowad/fauget-pizza-sales-dashboard/blob/main/images/dashboard.png)


- **KPI cards:** Total Revenue, Total Orders, Pizzas Sold, with average order value and pizzas per order underneath
- **Charts:** monthly trend, hourly trend, revenue by category, revenue share by size, revenue by weekday, Top 5 pizzas, Bottom 5 pizzas
- **Timeline:** pick a month and the whole dashboard updates

Tip: click a single month in the timeline to see how the KPIs and charts change, then reset it to All Periods.

---

## Things to keep in mind

- It is **one year** of data from **one shop**, so the patterns may not hold for other years or places.
- The data has **revenue only**, with no cost or profit, so "best selling" means most revenue, not most profit.
- The findings show **patterns, not causes**.
- The Insights sheet text is typed, so it describes the full year and does not change with the timeline.
- The dataset in `data/` belongs to its original publisher. The MIT License covers my code and analysis only.

---

## Tools

Excel (pivot tables, pivot charts, timeline, shapes, linked text boxes) | SQL Server (SSMS) | Data validation checks

---

## Folder structure

```
fauget-pizza-sales-dashboard/
├── dashboard/
│   └── Fauget_Pizza_Sales_Dashboard.xlsx
├── data/
│   └── pizza_sales.csv
├── images/
│   ├── sql_result/            (q1.png ... q10.png)
│   └── dashboard.png
├── sql/
│   └── pizza_sales_analysis.sql
├── LICENSE
└── README.md
```

---

## How to run it

1. Download `Fauget_Pizza_Sales_Dashboard.xlsx` and open it in desktop Excel. The timeline and pivot charts need a recent desktop version.
2. Go to the **Dashboard** sheet and click a month in the timeline.
3. To refresh after changing the data: **Data > Refresh All**.
4. **SQL:** import `data/pizza_sales.csv` into SQL Server as `pizza_sales` with the SSMS Import Flat File wizard, then run `pizza_sales_analysis.sql`.
5. If your dates import as text in `dd-mm-yyyy` format, the queries already convert them with `CONVERT(DATE, order_date, 105)`.

---

## What I learned

- How to build a dashboard where the pivot tables, charts, KPI cards and filter all stay connected.
- Why rows are not the same as orders, and how to count unique orders in both Excel and SQL.
- How to link shapes to cells so KPI cards update by themselves.
- How to check my own work: the validation sheet in Excel and a second check in SQL.
- How to turn numbers into findings with evidence and a recommendation.

---

## About me

**Sahil Bhowad**

Data Analyst | Excel, SQL, Power BI, Python | Mumbai

LinkedIn - [linkedin.com/in/sahil-bhowad-7a915934a](https://www.linkedin.com/in/sahil-bhowad-7a915934a/)

GitHub - [github.com/SahilBhowad](https://github.com/SahilBhowad)
