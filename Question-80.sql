WITH jan_calendar AS (
  SELECT cal_date
  FROM module.calendar_dim
  WHERE cal_date BETWEEN '2024-01-01' AND '2024-01-31'
),
products AS (
  SELECT DISTINCT product_id
  FROM module.orders
  WHERE order_date BETWEEN '2024-01-01' AND '2024-01-31'
),
daily AS (
  SELECT
    product_id,
    order_date AS cal_date,
    SUM(amount) AS daily_sales
  FROM module.orders
  WHERE order_date BETWEEN '2024-01-01' AND '2024-01-31'
  GROUP BY product_id, order_date
),
grid AS (
  SELECT p.product_id, c.cal_date
  FROM products p
  CROSS JOIN jan_calendar c
),
series AS (
  SELECT
    g.product_id,
    g.cal_date,
    COALESCE(d.daily_sales, 0) AS daily_sales
  FROM grid g
  LEFT JOIN daily d
    ON d.product_id = g.product_id
   AND d.cal_date   = g.cal_date
)
SELECT
  product_id,
  cal_date,
  daily_sales,
  SUM(daily_sales) OVER (
    PARTITION BY product_id
    ORDER BY cal_date
    ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
  ) AS rolling_3day_sales
FROM series
ORDER BY product_id, cal_date;