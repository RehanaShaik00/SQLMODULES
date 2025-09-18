
DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
  order_id      INT PRIMARY KEY,
  order_date    DATE NOT NULL,
  customer_name VARCHAR(10) NOT NULL,
  product_name  VARCHAR(10) NOT NULL,
  sales         INT NOT NULL
);

INSERT INTO orders (order_id, order_date, customer_name, product_name, sales) VALUES
(1, '2023-01-01', 'Alexa',  'iphone', 100),
(2, '2023-01-02', 'Alexa',  'boAt',   300),
(3, '2023-01-03', 'Alexa',  'Rolex',  400),
(4, '2023-01-01', 'Ramesh', 'Titan',  200),
(5, '2023-01-02', 'Ramesh', 'Shirt',  300),
(6, '2023-01-03', 'Neha',   'Dress',  100);


WITH ranked AS (
  SELECT
    o.*,
    ROW_NUMBER() OVER (
      PARTITION BY customer_name
      ORDER BY order_date DESC, order_id DESC
    ) AS rn,
    COUNT(*) OVER (PARTITION BY customer_name) AS cnt
  FROM orders o
)
SELECT order_id, order_date, customer_name, product_name, sales
FROM ranked
WHERE rn = 2 OR (cnt = 1 AND rn = 1)
ORDER BY customer_name;
