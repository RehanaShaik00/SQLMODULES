
DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
  order_id    INT        NOT NULL,
  customer_id INT        NOT NULL,
  product_id  VARCHAR(2) NOT NULL
);

-- Sample data (exactly as shown)
INSERT INTO orders (order_id, customer_id, product_id) VALUES
(1, 1, 'p1'),
(1, 1, 'p2'),
(1, 1, 'p3'),
(2, 2, 'p1'),
(2, 2, 'p2'),
(2, 2, 'p4'),
(3, 1, 'p5'),
(3, 1, 'p6'),
(4, 3, 'p1'),
(4, 3, 'p3'),
(4, 3, 'p5');

-- Product pairs bought together + frequency (first id > second id)
WITH ord AS (
  SELECT DISTINCT order_id, product_id
  FROM orders
)
SELECT
  GREATEST(o1.product_id, o2.product_id) AS product_1,
  LEAST(o1.product_id,  o2.product_id)   AS product_2,
  COUNT(*) AS purchase_frequency
FROM ord o1
JOIN ord o2
  ON o1.order_id = o2.order_id
 AND o1.product_id < o2.product_id      -- one combo per order
GROUP BY product_1, product_2
ORDER BY purchase_frequency DESC, product_1 DESC, product_2 DESC;

