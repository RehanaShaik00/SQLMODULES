DROP TABLE IF EXISTS transactions;

-- Table
CREATE TABLE transactions (
  order_id           INT,
  user_id            INT,
  transaction_amount DECIMAL(5,2),
  transaction_date   DATE
);

-- Data (as shown)
INSERT INTO transactions (order_id, user_id, transaction_amount, transaction_date) VALUES
(1, 101,  50.00, '2024-02-24'),
(2, 102,  75.00, '2024-02-24'),
(3, 103, 100.00, '2024-02-25'),
(4, 104,  30.00, '2024-02-26'),
(5, 105, 200.00, '2024-02-27'),
(6, 106,  50.00, '2024-02-27'),
(7, 107, 150.00, '2024-02-27'),
(8, 108,  80.00, '2024-02-29');

/*
Write an SQL query to determine the transaction date with the lowest average order value 
(AOV) among all dates recorded in the transaction table. Display the transaction date, 
its corresponding AOV, and the difference between the AOV for that date and the highest AOV 
for any day in the dataset. Round the result to 2 decimal places.*/

SELECT
  d.transaction_date,
  ROUND(d.aov, 2) AS aov,
  ROUND((
    (SELECT MAX(aov)
     FROM (SELECT AVG(transaction_amount) AS aov
           FROM transactions
           GROUP BY transaction_date) mx)
    - d.aov
  ), 2) AS diff_from_highest
FROM (
  SELECT transaction_date, AVG(transaction_amount) AS aov
  FROM transactions
  GROUP BY transaction_date
) AS d
WHERE d.aov = (
  SELECT MIN(aov)
  FROM (SELECT AVG(transaction_amount) AS aov
        FROM transactions
        GROUP BY transaction_date) mn
)
ORDER BY d.transaction_date;
