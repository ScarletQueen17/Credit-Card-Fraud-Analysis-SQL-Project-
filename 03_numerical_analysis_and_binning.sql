-- Credit Card Fraud Analysis - Numerical Analysis and Binning
-- File 3: Statistical Analysis of Numerical Features and Binning Analysis

use creditcard;

-- Summary statistics for numeric columns
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

-- Outlier analysis - largest ratio_to_median_purchase_price
SELECT * FROM card_transdata
ORDER BY ratio_to_median_purchase_price DESC
LIMIT 20;

-- Outlier analysis - largest distance_from_home
SELECT * FROM card_transdata
ORDER BY distance_from_home DESC
LIMIT 20;

-- Fraud rate by distance_from_home bins
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

-- Fraud rate by ratio_to_median_purchase_price bins
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