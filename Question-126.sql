DROP TABLE IF EXISTS orders;

CREATE TABLE orders (
  customer_id  INT,
  order_id     INT,
  product_name VARCHAR(40)
);

INSERT INTO orders (customer_id, order_id, product_name) VALUES
(1, 101, 'Laptop'),
(1, 102, 'Mouse'),
(1, 103, 'Phone Case'),
(1, 104, 'Headphones'),
(2, 105, 'Laptop'),
(2, 106, 'Mouse'),
(3, 107, 'Laptop'),
(4, 108, 'Mouse'),
(5, 109, 'Laptop'),
(5, 110, 'Phone Case'),
(6, 111, 'Laptop'),
(6, 112, 'Mouse');

SELECT
  customer_id,
  COUNT(DISTINCT product_name) AS distinct_products
FROM orders
GROUP BY customer_id
HAVING SUM(product_name = 'Laptop') > 0
   AND SUM(product_name = 'Mouse')  > 0
   AND SUM(product_name = 'Phone Case') = 0
ORDER BY customer_id;