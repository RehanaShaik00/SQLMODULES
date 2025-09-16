use modules;
DROP TABLE IF EXISTS orders;

CREATE TABLE orders (
  customer_id INT,
  order_id    INT,
  order_date  DATE
);

INSERT INTO orders (customer_id, order_id, order_date) VALUES
(1, 101, '2023-01-15'),
(1, 102, '2023-02-10'),
(2, 201, '2023-01-20'),
(2, 202, '2023-02-25'),
(2, 203, '2023-03-30'),
(3, 301, '2023-01-01'),
(3, 302, '2023-02-01'),
(3, 303, '2023-03-01'),
(3, 304, '2023-05-01'),
(4, 401, '2023-01-05'),
(4, 402, '2023-01-10'),
(4, 403, '2023-01-15');

SELECT
  customer_id,
  COUNT(*) AS total_orders
FROM orders
GROUP BY customer_id
HAVING COUNT(DISTINCT DATE_FORMAT(order_date, '%Y-%m')) >= 3
ORDER BY customer_id;