# Credit Card Fraud Analysis (SQL Project)

##  Overview
This project analyzes **credit card transactions** to identify fraud patterns using SQL.  
The dataset contains ~70k transactions with information such as transaction location, chip usage, retailer type, and fraud labels.  

As a data analyst focusing on the **FinTech industry**, this project demonstrates how SQL can be used to:
- Explore raw transaction data
- Detect fraud rates across transaction features
- Generate insights that can help financial institutions reduce fraud risk

---

## 📂 Dataset - https://www.kaggle.com/datasets/dhanushnarayananr/credit-card-fraud
- **Name**: Credit Card Transactions Dataset  
- **Rows**: ~69,699  
- **Columns**:
  - `distance_from_home` – Distance of transaction from cardholder’s home  
  - `distance_from_last_transaction` – Distance from previous transaction  
  - `ratio_to_median_purchase_price` – Purchase amount vs. median purchase  
  - `repeat_retailer` – Whether the retailer has been visited before  
  - `used_chip` – Whether chip was used  
  - `used_pin_number` – Whether PIN was used  
  - `online_order` – Whether purchase was online  
  - `fraud` – Target label (1 = Fraud, 0 = Not Fraud)

---

##  Steps Performed
1. **Imported dataset** into MySQL Workbench  
2. **Basic checks** – row count, column preview  
3. **Fraud rate analysis** – total fraud cases and baseline fraud rate  
4. **Feature analysis** – grouped fraud rate by:
   - Chip usage (`used_chip`)
   - Retailer type (`repeat_retailer`)
   - Online order (`online_order`)
   - PIN usage (`used_pin_number`)  
5. **Statistical summary** – average distances, purchase amounts, etc.  
6. **Fraud patterns** – identified which conditions contribute to higher fraud probability  

---

##  Key Insights
- **Overall fraud rate** ≈ 2.13%  
- Transactions **without chip usage** have significantly higher fraud rates than chip-enabled transactions.  
- **Online orders** are riskier compared to offline transactions.  
- Fraud tends to occur more often when the **transaction distance is unusually high** or the **purchase value deviates strongly** from the median.  
- Using a **PIN** slightly reduces fraud probability.  

---

##  Files
- `sql/fraud_analysis.sql` → Contains all SQL queries used for analysis  
- `data/card_transdata.csv` → Dataset (if included; if too large, link to source)  
- `visuals/` → Will contain fraud rate charts and summary plots  

---

##  Next Steps
- Create **visualizations** (fraud rate by feature) using Excel / Power BI / Python  
- Extend the analysis by building a **predictive model** (Python + ML)  
- Document business recommendations for banks/fintech companies  

---

## Author
**Adekanye Mary Adeyinka** – Information Systems student & aspiring Data Analyst (FinTech focus).  

---
