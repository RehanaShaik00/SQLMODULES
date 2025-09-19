SELECT category,SUM(amount)
FROM sales
WHERE YEAR(order_date)='2022' AND MONTH(order_date)='2'
AND WEEKDAY(order_date) BETWEEN 0 AND 4
GROUP BY category
ORDER BY SUM(amount) ASC;