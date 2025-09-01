/*
 Write a SQL query to count number 
 of products in each category based on its price into three categories below. 
 Display the output in descending order of no of products.
1- "Low Price" for products with a price less than 100
2- "Medium Price" for products with a price between 100 and 500 (inclusive)
3- "High Price" for products with a price greater than 500.
Tables: Products
+--------------+-------------+
| COLUMN_NAME  | DATA_TYPE   |
+--------------+-------------+
| product_id   | int         |
| product_name | varchar(20) |
| price        | int         |
+--------------+-------------+  */

DROP TABLE IF EXISTS products2;
CREATE TABLE products2 (
  product_id   INT PRIMARY KEY,
  product_name VARCHAR(20) NOT NULL,
  price        INT NOT NULL
);

-- Sample data
-- Low (<100): ids 1–4
-- Medium (100–500): ids 5–9  (note: includes 100 and 500)
-- High (>500): ids 10–12
INSERT INTO products2 (product_id, product_name, price) VALUES
(1,  'Pen',          20),
(2,  'Notebook',     15),
(3,  'USB Cable',    99),
(4,  'Water Bottle', 80),
(5,  'Headphones',   100),
(6,  'Keyboard',     150),
(7,  'Desk Lamp',    299),
(8,  'Power Bank',   500),
(9,  'Blender',      450),
(10, 'Monitor',      1200),
(11, 'Smartphone',   899),
(12, 'Gaming Mouse', 650);

SELECT COUNT(product_id),
CASE WHEN price<100 THEN 'low Price' 
     WHEN price>500 THEN 'High price' 
     WHEN price BETWEEN 100 AND 500 THEN 'midprice' END AS category
FROM products2
GROUP BY category
ORDER BY COUNT(product_id) DESC;