-- Credit Card Fraud Analysis - Categorical Feature Analysis
-- File 2: Distribution Analysis and Fraud Rates by Categorical Features

use creditcard;

-- Distribution analysis for categorical features
-- Distribution for repeat_retailer
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

-- Fraud rate analysis by categorical features
-- Fraud rate by online_order
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