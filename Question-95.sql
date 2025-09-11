SELECT category,ROUND(AVG(price),2)
FROM electronic_items
WHERE warranty_months>=12
GROUP BY category
HAVING AVG(price)> 500
AND SUM(quantity)>=20
ORDER BY ROUND(AVG(price),2) DESC;