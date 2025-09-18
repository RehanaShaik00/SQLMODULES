
DROP TABLE IF EXISTS transactions;
CREATE TABLE transactions (
  transaction_date DATE NOT NULL,
  amount           INT  NOT NULL,
  PRIMARY KEY (transaction_date, amount)  
);

INSERT INTO transactions (transaction_date, amount) VALUES
('2020-01-01', -30),
('2020-01-05', -80),
('2020-01-24',  30),
('2020-03-01', -40),
('2020-03-01',  30),
('2020-04-10',  70),
('2020-04-13',  40),
('2020-07-05', -30),
('2020-10-19',  60),
('2020-12-01', -40),
('2020-12-05', -30);

WITH RECURSIVE months AS (                              
  SELECT DATE('2020-01-01') AS m1
  UNION ALL
  SELECT DATE_ADD(m1, INTERVAL 1 MONTH) FROM months WHERE m1 < '2020-12-01'
),
monthly AS (                                              
  SELECT
    m.m1,
    COALESCE(SUM(CASE WHEN t.amount < 0 THEN 1 END),0)         AS neg_cnt,
    COALESCE(SUM(CASE WHEN t.amount < 0 THEN -t.amount END),0) AS neg_sum
  FROM months m
  LEFT JOIN transactions t
    ON t.transaction_date >= m.m1
   AND t.transaction_date <  DATE_ADD(m.m1, INTERVAL 1 MONTH)
  GROUP BY m.m1
)
SELECT
  COALESCE((SELECT SUM(amount) FROM transactions
            WHERE YEAR(transaction_date)=2020),0)
  - SUM(CASE WHEN neg_cnt >= 2 AND neg_sum >= 100 THEN 0 ELSE 5 END) AS year_end_balance
FROM monthly;
