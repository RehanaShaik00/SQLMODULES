SELECT SUM(price*quantity),product_name
FROM sales
JOIN products
ON sales.product_id = products.product_id
GROUP BY product_name
ORDER BY product_name;