WITH cte AS (
SELECT DISTINCT
YEAR(order_date) AS year,
MONTH(order_date) AS month,
customer_id
FROM orders
)
SELECT
cm.year AS current_year,
cm.month AS current_month,
fm.year AS future_year,
fm.month AS future_month,
COUNT(DISTINCT cm.customer_id) AS total_customers,
COUNT(DISTINCT CASE WHEN fm.customer_id = cm.customer_id THEN fm.customer_id END) AS retained_customers
FROM cte cm
INNER JOIN cte fm
ON (fm.year > cm.year OR (fm.year = cm.year AND fm.month > cm.month))
GROUP BY cm.year, cm.month, fm.year, fm.month
ORDER BY cm.year, cm.month, fm.year, fm.month;