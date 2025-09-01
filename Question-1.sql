CREATE DATABASE 150modules;
USE 150modules;

/*
An e-commerce company, has observed a notable surge in return orders recently. 
They suspect that a specific group of customers may be responsible for a significant portion 
of these returns. To address this issue, their initial goal is to identify customers who have 
returned more than 50% of their orders. 
This way, they can proactively reach out to these customers to gather feedback.
Write an SQL to find list of customers along with their return percent 
(Round to 2 decimal places), display the output in ascending order of customer name.*/

CREATE TABLE orders (
    customer_name VARCHAR(10),
    order_date DATE,
    order_id INT PRIMARY KEY,
    sales INT
);

-- Create returns table
CREATE TABLE returns (
    order_id INT PRIMARY KEY,
    return_date DATE
);

-- Insert sample data into orders
INSERT INTO orders (customer_name, order_date, order_id, sales) VALUES
('Alice',  '2025-07-01', 101, 500),
('Alice',  '2025-07-05', 102, 300),
('Alice',  '2025-07-10', 103, 200),
('Bob',    '2025-07-02', 104, 700),
('Bob',    '2025-07-08', 105, 400),
('Bob',    '2025-07-12', 106, 350),
('Carol',  '2025-07-03', 107, 150),
('Carol',  '2025-07-09', 108, 250),
('Carol',  '2025-07-11', 109, 300),
('David',  '2025-07-04', 110, 600),
('David',  '2025-07-06', 111, 450),
('Eve',    '2025-07-07', 112, 800),
('Carol',  '2025-07-11', 113, 300);

-- Insert sample data into returns
INSERT INTO returns (order_id, return_date) VALUES
(101, '2025-07-15'), -- Alice
(103, '2025-07-18'), -- Alice
(104, '2025-07-20'), -- Bob
(105, '2025-07-22'), -- Bob
(106, '2025-07-22'), -- Bob
(108, '2025-07-25'), -- Carol
(109, '2025-07-26'), -- Carol
(111, '2025-07-28'); -- David

SELECT customer_name,ROUND((100*(COUNT(r.order_id)/COUNT(o.order_id))),2) as returnpercentage
FROM orders o
LEFT JOIN returns r
ON o.order_id = r.order_id
GROUP BY customer_name
HAVING returnpercentage>50
ORDER BY customer_name ASC;
