DROP TABLE IF EXISTS orders;

-- Create table
CREATE TABLE orders (
  order_id      INT PRIMARY KEY,
  order_date    DATETIME NOT NULL,
  customer_name VARCHAR(20) NOT NULL,
  order_value   INT NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Sample data
INSERT INTO orders (order_id, order_date, customer_name, order_value) VALUES
  (1 , '2023-01-13 12:30:00', 'Rahul' , 250),
  (2 , '2023-01-13 08:30:00', 'Rahul' , 350),
  (3 , '2023-01-13 09:00:00', 'Mudit' , 230),
  (4 , '2023-01-14 08:30:00', 'Rahul' , 150),
  (5 , '2023-01-14 12:03:00', 'Suresh', 130),
  (6 , '2023-01-15 09:34:00', 'Mudit' , 250),
  (7 , '2023-01-15 12:03:00', 'Mudit' , 300),
  (8 , '2023-01-15 09:30:00', 'Rahul' , 250),
  (9 , '2023-01-15 12:35:00', 'Rahul' , 300),
  (10, '2023-01-15 12:03:00', 'Suresh', 130);
/*
Your task is to write a SQL to find those customers who have placed multiple orders in a single day
 at least once , 
 total order value generate by those customers and 
 order value generated only by those orders, 
 display the results in ascending order of total order value.
*/

WITH a AS
(SELECT customer_name,SUM(order_value) AS totalvalue
FROM orders
GROUP BY customer_name
HAVING COUNT(DATE(order_date))>=2)

SELECT DISTINCT orders.customer_name,SUM(order_value) AS onlyonthosedaysvalue,totalvalue
FROM orders
JOIN a
ON a.customer_name = orders.customer_name
GROUP BY customer_name,DATE(order_date)
HAVING COUNT(DATE(order_date))>=2
ORDER BY totalvalue ASC;




