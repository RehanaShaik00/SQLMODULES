SELECT c.customer_id,customer_name,SUM(quantity*unit_price)
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
JOIN products1 p
ON p.product_id = o.product_id
GROUP BY c.customer_id,customer_name
-- HAVING GROUP_CONCAT(DISTINCT o.product_id) = (SELECT GROUP_CONCAT(product_id) FROM products1)
HAVING COUNT(DISTINCT o.product_id) = (SELECT COUNT(*) FROM products1)
ORDER BY SUM(quantity*unit_price) DESC;