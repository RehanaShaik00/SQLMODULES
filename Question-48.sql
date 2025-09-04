DROP TABLE IF EXISTS credit_card_transactions;

-- Table
CREATE TABLE credit_card_transactions (
  transaction_id   INT,
  city             VARCHAR(10),
  transaction_date DATE,
  card_type        VARCHAR(10),
  gender           VARCHAR(1),
  amount           INT
);

-- Data (sample matches the image)
INSERT INTO credit_card_transactions
(transaction_id, city, transaction_date, card_type, gender, amount) VALUES
(1 , 'Delhi',     '2024-01-13', 'Gold',     'F',  500),
(2 , 'Bengaluru', '2024-01-13', 'Silver',   'M', 1000),
(3 , 'Mumbai',    '2024-01-14', 'Silver',   'F', 1200),
(4 , 'Bengaluru', '2024-01-14', 'Gold',     'M',  900),
(5 , 'Bengaluru', '2024-01-14', 'Gold',     'F',  300),
(6 , 'Delhi',     '2024-01-15', 'Silver',   'M',  200),
(7 , 'Mumbai',    '2024-01-15', 'Gold',     'F',  700),
(8 , 'Delhi',     '2024-01-15', 'Gold',     'F',  800),
(9 , 'Mumbai',    '2024-01-15', 'Silver',   'M',  600),
(10, 'Mumbai',    '2024-01-16', 'Platinum', 'F', 1900),
(11, 'Bengaluru', '2024-01-16', 'Platinum', 'M', 1250);

/*
You are given a history of credit card transaction data for the people of India across cities. 
Write an SQL to find percentage contribution of spends by females in each city.  
Round the percentage to 2 decimal places. 
Display city, total spend , female spend and female contribution in ascending order of city.*/

SELECT city,
	   SUM(amount) AS totalspend,
       IFNULL(SUM(CASE WHEN gender='F' THEN amount END),0) AS Femalespend,
       ROUND(100*(SUM(CASE WHEN gender='F' THEN amount END)/SUM(amount)),2) as Femalecontribution
FROM credit_card_transactions
GROUP BY city
ORDER BY city ASC
