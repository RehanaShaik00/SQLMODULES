-- Start clean
DROP TABLE IF EXISTS sales_amount;
DROP TABLE IF EXISTS exchange_rate;

-- Sales transactions (amounts in various currencies)
CREATE TABLE sales_amount (
  sale_date     DATE,
  sales_amount  INT,
  currency      VARCHAR(20)
);

INSERT INTO sales_amount (sale_date, sales_amount, currency) VALUES
('2020-01-01',  500, 'INR'),
('2020-01-01',  100, 'GBP'),
('2020-01-02', 1000, 'INR'),
('2020-01-02',  500, 'GBP'),
('2020-01-03',  500, 'INR'),
('2020-01-17',  200, 'GBP'),
('2020-01-18',  200, 'Ringgit'),
('2020-01-05',  800, 'INR'),
('2020-01-06',  150, 'GBP'),
('2020-01-10',  300, 'INR'),
('2020-01-15',  100, 'INR');

-- Exchange rates to USD with effective dates
CREATE TABLE exchange_rate (
  from_currency  VARCHAR(20),
  to_currency    VARCHAR(10),
  exchange_rate  DECIMAL(8,4),
  effective_date DATE
);

INSERT INTO exchange_rate (from_currency, to_currency, exchange_rate, effective_date) VALUES
('INR',     'USD', 0.14, '2019-12-31'),
('INR',     'USD', 0.15, '2020-01-02'),
('GBP',     'USD', 1.32, '2019-12-20'),
('GBP',     'USD', 1.30, '2020-01-01'),
('GBP',     'USD', 1.35, '2020-01-16'),
('GBP',     'USD', 1.35, '2020-01-25'),
('Ringgit', 'USD', 0.30, '2020-01-10'),
('INR',     'USD', 0.16, '2020-01-10'),
('GBP',     'USD', 1.33, '2020-01-05');

/*
You are given two tables, sales_amount and exchange_rate. 
The sales_amount table contains sales transactions in various currencies, 
and the exchange_rate table provides the exchange rates for converting different currencies into USD, 
along with the dates when these rates became effective.
Your task is to write an SQL query that converts all sales amounts into USD 
using the most recent applicable exchange rate that was effective on or before the sale date. 
Then, calculate the total sales in USD for each sale date*/

SELECT
  s.sale_date,
  ROUND(SUM(s.sales_amount * r.exchange_rate), 2) AS total_usd_sales
FROM sales_amount s
JOIN exchange_rate r
  ON r.from_currency = s.currency
 AND r.to_currency   = 'USD'
 AND r.effective_date = (
       SELECT MAX(e.effective_date)
       FROM exchange_rate e
       WHERE e.from_currency = s.currency
         AND e.to_currency   = 'USD'
         AND e.effective_date <= s.sale_date
     )
GROUP BY s.sale_date
ORDER BY s.sale_date;
