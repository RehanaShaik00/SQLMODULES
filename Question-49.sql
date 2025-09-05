DROP TABLE IF EXISTS credit_card_transactions;

-- Create table
CREATE TABLE credit_card_transactions (
  transaction_id   INT PRIMARY KEY,
  transaction_date DATE NOT NULL,
  amount           INT  NOT NULL,
  card_type        VARCHAR(12) NOT NULL,
  city             VARCHAR(20) NOT NULL,
  gender           VARCHAR(1)  NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Sample data
INSERT INTO credit_card_transactions
(transaction_id, transaction_date, amount, card_type, city, gender) VALUES
-- Mumbai: reaches 1500 on 2023-01-04
(1, '2023-01-01', 200, 'Visa',      'Mumbai',    'F'),
(2, '2023-01-02', 300, 'MasterCard','Mumbai',    'M'),
(3, '2023-01-03', 400, 'RuPay',     'Mumbai',    'F'),
(4, '2023-01-04', 700, 'Amex',      'Mumbai',    'M'),

-- Delhi: reaches 1500 on 2023-01-06
(5, '2023-01-02', 500, 'Visa',      'Delhi',     'F'),
(6, '2023-01-03', 200, 'Amex',      'Delhi',     'M'),
(7, '2023-01-05', 600, 'MasterCard','Delhi',     'F'),
(8, '2023-01-06', 250, 'RuPay',     'Delhi',     'F'),

-- Bangalore: reaches 1500 on 2023-01-05
(9,  '2023-01-01', 1000,'Visa',      'Bangalore','M'),
(10, '2023-01-02', 200, 'Amex',      'Bangalore','F'),
(11, '2023-01-05', 400, 'MasterCard','Bangalore','M'),

-- Hyderabad: reaches 1500 on 2023-01-07
(12, '2023-01-03', 300, 'Visa',      'Hyderabad','F'),
(13, '2023-01-04', 300, 'MasterCard','Hyderabad','M'),
(14, '2023-01-05', 500, 'RuPay',     'Hyderabad','F'),
(15, '2023-01-06', 300, 'Amex',      'Hyderabad','F'),
(16, '2023-01-07', 200, 'Visa',      'Hyderabad','M'),

-- Chennai: reaches 1500 on 2023-01-12
(17, '2023-01-01', 800, 'MasterCard','Chennai',  'F'),
(18, '2023-01-10', 500, 'Visa',      'Chennai',  'M'),
(19, '2023-01-12', 300, 'Amex',      'Chennai',  'F'),

-- Kolkata: reaches 1500 on 2023-01-04
(20, '2023-01-01', 600, 'Visa',      'Kolkata',  'F'),
(21, '2023-01-02', 400, 'Amex',      'Kolkata',  'M'),
(22, '2023-01-04', 550, 'MasterCard','Kolkata',  'F'),

-- Ahmedabad: reaches 1500 on 2023-01-06
(23, '2023-01-03', 700, 'RuPay',     'Ahmedabad','M'),
(24, '2023-01-04', 300, 'Visa',      'Ahmedabad','F'),
(25, '2023-01-06', 600, 'MasterCard','Ahmedabad','M');

/*
Write an SQL to find how many days each city took to reach cumulative spend of 1500 from its first day 
of transactions. 
Display city, first transaction date , date of 1500 spend and # of days in the ascending order of city.
*/
WITH r AS (
  SELECT
    city,
    transaction_date,
    SUM(SUM(amount)) OVER (
      PARTITION BY city
      ORDER BY transaction_date
      ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cum_spend
  FROM credit_card_transactions
  GROUP BY city, transaction_date
)
SELECT
  city,
  MIN(transaction_date) AS first_txn_date,
  MIN(CASE WHEN cum_spend >= 1500 THEN transaction_date END) AS date_1500,
  DATEDIFF(
    MIN(CASE WHEN cum_spend >= 1500 THEN transaction_date END),
    MIN(transaction_date)
  ) AS days_to_1500
FROM r
GROUP BY city
ORDER BY city;
