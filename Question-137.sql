DROP TABLE IF EXISTS transactions;
CREATE TABLE transactions (
  transaction_id   INT PRIMARY KEY,
  customer_id      INT NOT NULL,
  transaction_date DATE NOT NULL,
  amount           INT  NOT NULL
);

INSERT INTO transactions (transaction_id, customer_id, transaction_date, amount) VALUES
(1 , 1, '2025-01-13', 100),
(2 , 5, '2025-02-13', 200),
(3 , 5, '2025-05-13', 200),
(4 , 1, '2025-03-13', 150),
(5 , 3, '2025-04-13', 120),
(6 , 4, '2025-03-10', 130),
(7 , 4, '2025-04-13', 230),
(8 , 6, '2025-05-09', 110),
(9 , 2, '2025-05-29', 180),
(10, 6, '2025-06-01',  90),
(11, 7, '2025-05-13', 110),
(12, 7, '2025-05-13', 180);

SELECT
  customer_id,
  MIN(transaction_date) AS first_purchase_date
FROM transactions
GROUP BY customer_id
HAVING MIN(transaction_date) >= DATE_FORMAT(CURDATE(), '%Y-%m-01') - INTERVAL 3 MONTH
   AND MIN(transaction_date) <  DATE_FORMAT(CURDATE(), '%Y-%m-01')
ORDER BY customer_id;