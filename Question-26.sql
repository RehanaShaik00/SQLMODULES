
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS product;

-- Products price history
CREATE TABLE product (
  product_id INT NOT NULL,
  price_date DATE NOT NULL,
  price      INT  NOT NULL,
  PRIMARY KEY (product_id, price_date)
);

INSERT INTO product (product_id, price_date, price) VALUES
(100, '2024-01-01', 150),
(100, '2024-01-21', 170),
(100, '2024-02-01', 190),
(101, '2024-01-01', 1000),
(101, '2024-01-27', 1200),
(101, '2024-02-05', 1250);

-- Orders
CREATE TABLE orders (
  order_id   INT PRIMARY KEY,
  order_date DATE NOT NULL,
  product_id INT NOT NULL
);

INSERT INTO orders (order_id, order_date, product_id) VALUES
(1, '2024-01-05', 100),
(2, '2024-01-21', 100),
(3, '2024-02-20', 100),
(4, '2024-01-07', 101),
(5, '2024-02-04', 101),
(6, '2024-02-05', 101),
(7, '2024-02-10', 101);

-- Total sales at the price effective on each order date (MySQL)
SELECT
  o.product_id,
  SUM(p.price) AS total_sales_value
FROM orders o
JOIN product p
  ON p.product_id = o.product_id
 AND p.price_date = (
       SELECT MAX(p2.price_date)
       FROM product p2
       WHERE p2.product_id = o.product_id
         AND p2.price_date <= o.order_date
     )
GROUP BY o.product_id
ORDER BY o.product_id;
