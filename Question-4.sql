CREATE TABLE q3orders (
    order_id      INT PRIMARY KEY,
    order_date    DATE,
    customer_name VARCHAR(20),
    sales         INT
);

-- Sample data
INSERT INTO q3orders (order_id, order_date, customer_name, sales) VALUES
-- Alice: 5 orders
(1001, '2025-06-01', 'Alice', 250),
(1002, '2025-06-05', 'Alice', 180),
(1003, '2025-06-10', 'Alice', 320),
(1004, '2025-06-15', 'Alice', 210),
(1005, '2025-06-20', 'Alice', 275),

-- Bob: 3 orders
(1006, '2025-06-02', 'Bob', 150),
(1007, '2025-06-11', 'Bob', 220),
(1008, '2025-06-19', 'Bob', 190),

-- Carol: 2 orders
(1009, '2025-06-03', 'Carol', 130),
(1010, '2025-06-18', 'Carol', 160),

-- David: 6 orders
(1011, '2025-06-04', 'David', 400),
(1012, '2025-06-08', 'David', 350),
(1013, '2025-06-12', 'David', 280),
(1014, '2025-06-16', 'David', 300),
(1015, '2025-06-21', 'David', 260),
(1016, '2025-06-25', 'David', 330),

-- Eve: 1 order
(1017, '2025-06-06', 'Eve', 500),

-- Frank: 4 orders
(1018, '2025-06-07', 'Frank', 225),
(1019, '2025-06-13', 'Frank', 195),
(1020, '2025-06-22', 'Frank', 410),
(1021, '2025-06-26', 'Frank', 205),

-- Grace: 3 orders
(1022, '2025-06-09', 'Grace', 140),
(1023, '2025-06-14', 'Grace', 175),
(1024, '2025-06-24', 'Grace', 210),

-- Heidi: 2 orders
(1025, '2025-06-17', 'Heidi', 160),
(1026, '2025-06-27', 'Heidi', 180),

-- Ivan: 5 orders
(1027, '2025-06-01', 'Ivan', 320),
(1028, '2025-06-05', 'Ivan', 210),
(1029, '2025-06-11', 'Ivan', 245),
(1030, '2025-06-20', 'Ivan', 260),
(1031, '2025-06-29', 'Ivan', 300),

-- Judy: 1 order
(1032, '2025-06-30', 'Judy', 120);
 
/*"An e-commerce company want to start special reward program for their premium customers.
The customers who have placed a greater number of orders than the 
average number of orders placed by customers are considered as premium customers.
Write an SQL to find the list of premium customers along with 
the number of orders placed by each of them, 
display the results in highest to lowest no of orders.*/

SELECT customer_name,COUNT(*)
FROM q3orders
GROUP BY customer_name
HAVING COUNT(*)>(SELECT COUNT(*)*1.0/COUNT(DISTINCT customer_name) FROM q3orders)
ORDER BY COUNT(*) DESC;
