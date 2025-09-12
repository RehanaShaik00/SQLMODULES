-- Top-3 products inside the overall top-selling category
WITH cat_sales AS (
  SELECT category, SUM(amount) AS cat_total
  FROM module.orders
  GROUP BY category
),
top_cat AS (
  SELECT cs.category
  FROM cat_sales cs
  ORDER BY cs.cat_total DESC
  LIMIT 1
),
prod_sales AS (
  SELECT product_id, category, SUM(amount) AS prod_total
  FROM module.orders
  GROUP BY product_id, category
),
ranked AS (
  SELECT
    ps.product_id,
    ps.category,
    ps.prod_total,
    DENSE_RANK() OVER (ORDER BY ps.prod_total DESC) AS rnk
  FROM prod_sales ps
  WHERE ps.category = (SELECT category FROM top_cat)
)
SELECT
  product_id,
  category,
  prod_total AS total_sales
FROM ranked
WHERE rnk <= 3
ORDER BY total_sales DESC, product_id;
