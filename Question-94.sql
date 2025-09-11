SELECT store_id,category,SUM(total_sales)
FROM gap_sales
WHERE YEAR(sale_date)='2023' AND MONTH(sale_date) BETWEEN 4 AND 7
GROUP BY category,store_id 
ORDER BY SUM(total_sales) ASC;