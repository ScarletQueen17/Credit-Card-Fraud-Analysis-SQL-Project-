use creditcard;
select * from card_transdata limit 10;
select count(*) from card_transdata;
select distinct fraud from card_transdata;

select fraud, count(*) as total
from card_transdata
group by fraud;

show columns from card_transdata;

select avg(distance_from_home) as avg_distance
from card_transdata
group by fraud;

-- Step 1: Distribution for repeat_retailer
SELECT repeat_retailer, COUNT(*) AS n_transactions
FROM card_transdata
GROUP BY repeat_retailer
ORDER BY repeat_retailer;

-- Distribution for used_chip
SELECT used_chip, COUNT(*) AS n_transactions
FROM card_transdata
GROUP BY used_chip
ORDER BY used_chip;

-- Distribution for used_pin_number
SELECT used_pin_number, COUNT(*) AS n_transactions
FROM card_transdata
GROUP BY used_pin_number
ORDER BY used_pin_number;

-- Distribution for online_order
SELECT online_order, COUNT(*) AS n_transactions
FROM card_transdata
GROUP BY online_order
ORDER BY online_order;

-- Distribution for fraud
SELECT fraud, COUNT(*) AS n_transactions
FROM card_transdata
GROUP BY fraud
ORDER BY fraud;

-- Step 2: Fraud rate by online_order
SELECT online_order,
       COUNT(*) AS n_transactions,
       SUM(fraud) AS fraud_count,
       ROUND(AVG(fraud) * 100, 3) AS fraud_rate_pct
FROM card_transdata
GROUP BY online_order
ORDER BY fraud_rate_pct DESC;

-- Fraud rate by repeat_retailer
SELECT repeat_retailer,
       COUNT(*) AS n_transactions,
       SUM(fraud) AS fraud_count,
       ROUND(AVG(fraud) * 100, 3) AS fraud_rate_pct
FROM card_transdata
GROUP BY repeat_retailer;

-- Fraud rate by used_chip
SELECT used_chip,
       COUNT(*) AS n_transactions,
       SUM(fraud) AS fraud_count,
       ROUND(AVG(fraud) * 100, 3) AS fraud_rate_pct
FROM card_transdata
GROUP BY used_chip
ORDER BY fraud_rate_pct DESC;

-- Fraud rate by used_pin_number
SELECT used_pin_number,
       COUNT(*) AS n_transactions,
       SUM(fraud) AS fraud_count,
       ROUND(AVG(fraud) * 100, 3) AS fraud_rate_pct
FROM card_transdata
GROUP BY used_pin_number
ORDER BY fraud_rate_pct DESC;

-- Step 3: summary stats for numeric columns
SELECT
  COUNT(*) AS n_rows,
  SUM(CASE WHEN distance_from_home IS NULL THEN 1 ELSE 0 END) AS nulls_distance,
  MIN(distance_from_home) AS min_distance,
  ROUND(AVG(distance_from_home),3) AS avg_distance,
  ROUND(STDDEV_POP(distance_from_home),3) AS sd_distance,
  MAX(distance_from_home) AS max_distance,
  MIN(ratio_to_median_purchase_price) AS min_ratio,
  ROUND(AVG(ratio_to_median_purchase_price),3) AS avg_ratio,
  ROUND(STDDEV_POP(ratio_to_median_purchase_price),3) AS sd_ratio,
  MAX(ratio_to_median_purchase_price) AS max_ratio
FROM card_transdata;


-- Step 4a: largest ratio_to_median_purchase_price
SELECT * FROM card_transdata
ORDER BY ratio_to_median_purchase_price DESC
LIMIT 20;

-- Step 4b: largest distance_from_home
SELECT * FROM card_transdata
ORDER BY distance_from_home DESC
LIMIT 20;

-- Step 5: fraud rate by distance_from_home bins
SELECT
  CASE
    WHEN distance_from_home < 5 THEN '<5'
    WHEN distance_from_home < 20 THEN '5-20'
    WHEN distance_from_home < 50 THEN '20-50'
    WHEN distance_from_home < 200 THEN '50-200'
    ELSE '>200'
  END AS distance_bin,
  COUNT(*) AS cnt,
  SUM(fraud) AS fraud_cnt,
  ROUND(AVG(fraud) * 100, 3) AS fraud_rate_pct
FROM card_transdata
GROUP BY distance_bin
ORDER BY FIELD(distance_bin, '<5','5-20','20-50','50-200','>200');

-- Step 6: fraud rate by ratio_to_median_purchase_price bins
SELECT
  CASE
    WHEN ratio_to_median_purchase_price <= 1 THEN '<=1'
    WHEN ratio_to_median_purchase_price <= 3 THEN '1-3'
    WHEN ratio_to_median_purchase_price <= 10 THEN '3-10'
    WHEN ratio_to_median_purchase_price <= 100 THEN '10-100'
    ELSE '>100'
  END AS ratio_bin,
  COUNT(*) AS cnt,
  SUM(fraud) AS fraud_cnt,
  ROUND(AVG(fraud) * 100, 3) AS fraud_rate_pct
FROM card_transdata
GROUP BY ratio_bin
ORDER BY FIELD(ratio_bin, '<=1','1-3','3-10','10-100','>100');

-- Step 7: interaction used_chip x online_order
SELECT
  used_chip,
  online_order,
  COUNT(*) AS cnt,
  SUM(fraud) AS fraud_cnt,
  ROUND(AVG(fraud) * 100, 3) AS fraud_rate_pct
FROM card_transdata
GROUP BY used_chip, online_order
ORDER BY fraud_rate_pct DESC;

-- Step 8: crude Pearson correlation between fraud and two numeric features
SELECT
  (AVG(fraud * distance_from_home) - AVG(fraud) * AVG(distance_from_home))
   / (STDDEV_POP(fraud) * STDDEV_POP(distance_from_home)) AS corr_fraud_distance,
  (AVG(fraud * ratio_to_median_purchase_price) - AVG(fraud) * AVG(ratio_to_median_purchase_price))
   / (STDDEV_POP(fraud) * STDDEV_POP(ratio_to_median_purchase_price)) AS corr_fraud_ratio
FROM card_transdata;


-- Step 9: simple rule-based risk score (tunable)
SELECT
  CASE WHEN ratio_to_median_purchase_price > 3 THEN 1 ELSE 0 END AS ratio_flag,
  CASE WHEN distance_from_home > 50 THEN 1 ELSE 0 END AS distance_flag,
  CASE WHEN online_order = 1 THEN 1 ELSE 0 END AS online_flag,
  CASE WHEN used_chip = 0 THEN 1 ELSE 0 END AS nochip_flag,
  CASE WHEN used_pin_number = 0 THEN 1 ELSE 0 END AS nopin_flag,
  (CASE WHEN ratio_to_median_purchase_price > 3 THEN 50 ELSE 0 END
   + CASE WHEN distance_from_home > 50 THEN 40 ELSE 0 END
   + CASE WHEN online_order = 1 THEN 30 ELSE 0 END
   + CASE WHEN used_chip = 0 THEN 20 ELSE 0 END
   + CASE WHEN used_pin_number = 0 THEN 20 ELSE 0 END
  ) AS risk_score,
  fraud
FROM card_transdata
ORDER BY risk_score DESC
LIMIT 100;

-- Step 9: simple rule-based risk score (tunable)
SELECT
  CASE WHEN ratio_to_median_purchase_price > 3 THEN 1 ELSE 0 END AS ratio_flag,
  CASE WHEN distance_from_home > 50 THEN 1 ELSE 0 END AS distance_flag,
  CASE WHEN online_order = 1 THEN 1 ELSE 0 END AS online_flag,
  CASE WHEN used_chip = 0 THEN 1 ELSE 0 END AS nochip_flag,
  CASE WHEN used_pin_number = 0 THEN 1 ELSE 0 END AS nopin_flag,
  (CASE WHEN ratio_to_median_purchase_price > 3 THEN 50 ELSE 0 END
   + CASE WHEN distance_from_home > 50 THEN 40 ELSE 0 END
   + CASE WHEN online_order = 1 THEN 30 ELSE 0 END
   + CASE WHEN used_chip = 0 THEN 20 ELSE 0 END
   + CASE WHEN used_pin_number = 0 THEN 20 ELSE 0 END
  ) AS risk_score,
  fraud
FROM card_transdata
ORDER BY risk_score DESC
LIMIT 100;


