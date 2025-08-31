-- Credit Card Fraud Analysis - Advanced Analysis and Risk Scoring
-- File 4: Feature Interactions, Correlation Analysis, and Risk Scoring Model

use creditcard;

-- Feature interaction analysis: used_chip x online_order
SELECT
  used_chip,
  online_order,
  COUNT(*) AS cnt,
  SUM(fraud) AS fraud_cnt,
  ROUND(AVG(fraud) * 100, 3) AS fraud_rate_pct
FROM card_transdata
GROUP BY used_chip, online_order
ORDER BY fraud_rate_pct DESC;

-- Correlation analysis between fraud and numeric features
SELECT
  (AVG(fraud * distance_from_home) - AVG(fraud) * AVG(distance_from_home))
   / (STDDEV_POP(fraud) * STDDEV_POP(distance_from_home)) AS corr_fraud_distance,
  (AVG(fraud * ratio_to_median_purchase_price) - AVG(fraud) * AVG(ratio_to_median_purchase_price))
   / (STDDEV_POP(fraud) * STDDEV_POP(ratio_to_median_purchase_price)) AS corr_fraud_ratio
FROM card_transdata;

-- Rule-based risk scoring model
SELECT
  -- Individual risk flags
  CASE WHEN ratio_to_median_purchase_price > 3 THEN 1 ELSE 0 END AS ratio_flag,
  CASE WHEN distance_from_home > 50 THEN 1 ELSE 0 END AS distance_flag,
  CASE WHEN online_order = 1 THEN 1 ELSE 0 END AS online_flag,
  CASE WHEN used_chip = 0 THEN 1 ELSE 0 END AS nochip_flag,
  CASE WHEN used_pin_number = 0 THEN 1 ELSE 0 END AS nopin_flag,
  
  -- Weighted risk score calculation
  (CASE WHEN ratio_to_median_purchase_price > 3 THEN 50 ELSE 0 END
   + CASE WHEN distance_from_home > 50 THEN 40 ELSE 0 END
   + CASE WHEN online_order = 1 THEN 30 ELSE 0 END
   + CASE WHEN used_chip = 0 THEN 20 ELSE 0 END
   + CASE WHEN used_pin_number = 0 THEN 20 ELSE 0 END
  ) AS risk_score,
  
  -- Actual fraud label for validation
  fraud
FROM card_transdata
ORDER BY risk_score DESC
LIMIT 100;