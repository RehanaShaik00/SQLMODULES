DROP TABLE IF EXISTS orders;

-- Table
CREATE TABLE orders (
  order_id      INT,
  order_date    DATE,
  customer_id   INT,
  delivery_date DATE,
  cancel_date   DATE
);

-- Data (as shown)
INSERT INTO orders (order_id, customer_id, order_date, delivery_date, cancel_date) VALUES
(1, 101, '2023-01-05', '2023-01-10', NULL),
(2, 102, '2023-01-10', '2023-01-15', '2023-01-16'),
(3, 103, '2023-01-15', NULL,          '2023-01-20'),
(4, 104, '2023-01-07', '2023-01-10', NULL),
(5, 105, '2023-01-13', '2023-01-17', '2023-01-19'),
(6, 106, '2023-02-15', '2023-02-20', NULL),
(7, 107, '2023-02-05', '2023-02-05', '2023-02-08'),
(8, 108, '2023-02-10', NULL,          '2023-02-15');

/*
calculate both the cancellation rate and the return rate for each month 
based on the order date.
Definitions:
An order is considered cancelled if it is cancelled before delivery 
(i.e., cancel_date is not null, and delivery_date is null). 
If an order is cancelled, no delivery will take place.
An order is considered a return if it is cancelled after it has already been delivered
(i.e., cancel_date is not null, and cancel_date > delivery_date).
Metrics to Calculate:
Cancel Rate = (Number of orders cancelled / Number of orders placed but not returned) * 100
Return Rate = (Number of orders returned / Number of orders placed but not cancelled) * 100
Write an SQL query to calculate the cancellation rate and return rate for each month 
(based on the order_date).Round the rates to 2 decimal places. 
Sort the output by year and month in increasing order.
*/

SELECT
  YEAR(order_date)  AS yr,
  MONTH(order_date) AS mo,
  ROUND(
    100.0 * 
    COUNT(CASE WHEN cancel_date IS NOT NULL AND delivery_date IS NULL THEN order_id END)
    / NULLIF(
        COUNT(*) 
        - COUNT(CASE WHEN cancel_date IS NOT NULL AND delivery_date IS NOT NULL AND cancel_date > delivery_date THEN order_id END),
        0
      )
  , 2) AS cancel_rate,
  ROUND(
    100.0 *
    COUNT(CASE WHEN cancel_date IS NOT NULL AND delivery_date IS NOT NULL AND cancel_date > delivery_date THEN order_id END)
    / NULLIF(
        COUNT(*)
        - COUNT(CASE WHEN cancel_date IS NOT NULL AND delivery_date IS NULL THEN order_id END),
        0
      )
  , 2) AS return_rate
FROM orders
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY yr, mo;