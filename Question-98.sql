-- Drop and recreate table
DROP TABLE IF EXISTS credit_card_transactions;
CREATE TABLE credit_card_transactions (
  transaction_id   INT,
  city             VARCHAR(10),
  transaction_date DATE,
  card_type        VARCHAR(12),
  gender           VARCHAR(1),
  amount           INT
);

-- Insert sample data
INSERT INTO credit_card_transactions (transaction_id, city, transaction_date, card_type, gender, amount) VALUES
(1, 'Delhi',     '2024-01-13', 'Gold',     'F',  500),
(2, 'Bengaluru', '2024-01-13', 'Silver',   'M', 1000),
(3, 'Mumbai',    '2024-01-14', 'Silver',   'F', 1200),
(4, 'Bengaluru', '2024-01-14', 'Gold',     'M',  900),
(5, 'Bengaluru', '2024-01-14', 'Gold',     'F',  300),
(6, 'Delhi',     '2024-01-15', 'Silver',   'M',  200),
(7, 'Mumbai',    '2024-01-15', 'Gold',     'F',  900),
(8, 'Delhi',     '2024-01-15', 'Gold',     'F',  800),
(9, 'Mumbai',    '2024-01-15', 'Silver',   'F',  150),
(10,'Mumbai',    '2024-01-16', 'Platinum', 'F', 1900),
(11,'Bengaluru', '2024-01-16', 'Platinum', 'M', 1250);

/*
You are given a history of credit card transaction data for the people of India across cities as below. 
Your task is to find out highest spend card type and lowest spent card type for each city, 
display the output in ascending order of city.*/

WITH sums AS (
  SELECT city, card_type, SUM(amount) AS total_amt
  FROM credit_card_transactions
  GROUP BY city, card_type
),
max_by_city AS (
  SELECT city, MAX(total_amt) AS mx_amt
  FROM sums
  GROUP BY city
),
min_by_city AS (
  SELECT city, MIN(total_amt) AS min_amt
  FROM sums
  GROUP BY city
)
SELECT
  s.city,
  -- Highest spend card type(s) per city (ties allowed)
  GROUP_CONCAT(
    CASE WHEN s.total_amt = m.mx_amt THEN s.card_type END
    ORDER BY s.card_type
  ) AS highest_spend_card_type,
  -- Lowest spend card type(s) per city via subquery (ties allowed)
  GROUP_CONCAT(
    CASE WHEN s.total_amt = mm.min_amt THEN s.card_type END
    ORDER BY s.card_type
  ) AS lowest_spend_card_type
FROM sums s
JOIN max_by_city m
  ON m.city = s.city
JOIN min_by_city mm
  ON mm.city = s.city  
GROUP BY s.city
ORDER BY s.city;





