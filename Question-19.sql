DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;

-- Tables
CREATE TABLE products (
  product_id         INT,
  product_name       VARCHAR(10),
  available_quantity INT
);

CREATE TABLE orders (
  order_id           INT,
  product_id         INT,
  order_date         DATE,
  quantity_requested INT
);

-- Products (as shown)
INSERT INTO products (product_id, product_name, available_quantity) VALUES
(1, 'Product A', 10),
(2, 'Product B', 20),
(3, 'Product C', 15),
(4, 'Product D', 10);

-- Orders (as shown)
INSERT INTO orders (order_id, product_id, order_date, quantity_requested) VALUES
(1,  1, '2024-01-01', 5),
(2,  1, '2024-01-02', 7),

(3,  2, '2024-01-03', 10),
(4,  2, '2024-01-04', 10),
(5,  2, '2024-01-05', 5),

(6,  3, '2024-01-06', 4),
(7,  3, '2024-01-07', 5),

(8,  4, '2024-01-08', 4),
(9,  4, '2024-01-09', 5),
(10, 4, '2024-01-10', 8);

/*
The products table contains information about each product, including the product ID and 
available quantity in the warehouse. 
The orders table contains details about customer orders, including the order ID, product ID, 
order date, and quantity requested by the customer.
Write an SQL query to generate a report listing the orders that can be fulfilled 
based on the available inventory in the warehouse, 
following a first-come-first-serve approach based on the order date. 
Each row in the report should include the order ID, product name, quantity requested by the customer, 
quantity actually fulfilled, and a comments column as below:
If the order can be completely fulfilled then 'Full Order'.
If the order can be partially fulfilled then 'Partial Order'.
If order can not be fulfilled at all then 'No Order' .
Display the output in ascending order of order id.
*/
SELECT
  q.order_id,
  q.product_name,
  q.quantity_requested,
  /* how many units we can actually ship now */
  CASE
    WHEN q.rem_before <= 0 THEN 0
    WHEN q.rem_before >= q.quantity_requested THEN q.quantity_requested
    ELSE q.rem_before
  END AS quantity_actually_fulfilled,
  /* comment */
  CASE
    WHEN q.rem_before <= 0 THEN 'No Order'
    WHEN q.rem_before >= q.quantity_requested THEN 'Full Order'
    ELSE 'Partial Order'
  END AS comments
FROM (
  SELECT
    o.order_id,
    o.product_id,
    o.order_date,
    o.quantity_requested,
    p.product_name,
    p.available_quantity,
    /* remaining stock before this order = stock - sum of earlier requests */
    CASE
      WHEN SUM(o.quantity_requested) OVER (
             PARTITION BY o.product_id
             ORDER BY o.order_date, o.order_id
             ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING
           ) IS NULL
      THEN p.available_quantity
      ELSE p.available_quantity -
           SUM(o.quantity_requested) OVER (
             PARTITION BY o.product_id
             ORDER BY o.order_date, o.order_id
             ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING
           )
    END AS rem_before
  FROM orders o
  JOIN products p ON p.product_id = o.product_id
) AS q
ORDER BY q.order_id;


