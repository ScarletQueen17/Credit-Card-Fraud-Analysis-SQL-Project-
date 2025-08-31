-- Credit Card Fraud Analysis - Database Setup and Initial Exploration
-- File 1: Database Setup and Basic Data Exploration

 -- Create Database creditcard;
use creditcard;

-- Basic data exploration
select * from card_transdata limit 10;
select count(*) from card_transdata;
select distinct fraud from card_transdata;

-- Overall fraud distribution
select fraud, count(*) as total
from card_transdata
group by fraud;

-- Check table structure
show columns from card_transdata;

-- Basic statistical overview
select avg(distance_from_home) as avg_distance
from card_transdata
group by fraud;