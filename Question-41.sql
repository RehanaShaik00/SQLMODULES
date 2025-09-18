
DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
  order_id     INT PRIMARY KEY,
  customer_id  INT NOT NULL,
  order_amount DECIMAL(10,2) NOT NULL,
  order_date   DATE NOT NULL
);

-- C1: qualifies (>=3 weekday & weekend; weekend avg ~40% higher than weekday)
INSERT INTO orders VALUES
(1, 1, 300.00, '2024-07-02'),  -- Tue
(2, 1, 250.00, '2024-07-03'),  -- Wed
(3, 1, 350.00, '2024-07-04'),  -- Thu
(4, 1, 400.00, '2024-07-06'),  -- Sat
(5, 1, 420.00, '2024-07-07'),  -- Sun
(6, 1, 440.00, '2024-07-13');  -- Sat

-- C2: NOT enough weekend orders (only 2)
INSERT INTO orders VALUES
(7,  2, 100.00, '2024-07-08'), -- Mon
(8,  2, 110.00, '2024-07-09'), -- Tue
(9,  2, 120.00, '2024-07-10'), -- Wed
(10, 2, 200.00, '2024-07-14'), -- Sun
(11, 2, 210.00, '2024-07-20'); -- Sat

-- C3: enough counts, but weekend avg is NOT ≥ 20% higher
INSERT INTO orders VALUES
(12, 3, 300.00, '2024-07-15'), -- Mon
(13, 3, 300.00, '2024-07-16'), -- Tue
(14, 3, 300.00, '2024-07-17'), -- Wed
(15, 3, 310.00, '2024-07-21'), -- Sun
(16, 3, 330.00, '2024-07-27'), -- Sat
(17, 3, 320.00, '2024-07-28'); -- Sun

-- C4: qualifies (weekend avg exactly 20% higher than weekday)
INSERT INTO orders VALUES
(18, 4, 200.00, '2024-08-05'), -- Mon
(19, 4, 200.00, '2024-08-06'), -- Tue
(20, 4, 200.00, '2024-08-07'), -- Wed
(21, 4, 240.00, '2024-08-10'), -- Sat
(22, 4, 240.00, '2024-08-11'), -- Sun
(23, 4, 240.00, '2024-08-17'); -- Sat

-- C5: enough counts, weekend avg LOWER than weekday
INSERT INTO orders VALUES
(24, 5, 150.00, '2024-09-02'), -- Mon
(25, 5, 140.00, '2024-09-03'), -- Tue
(26, 5, 160.00, '2024-09-04'), -- Wed
(27, 5, 140.00, '2024-09-07'), -- Sat
(28, 5, 130.00, '2024-09-08'), -- Sun
(29, 5, 120.00, '2024-09-14'); -- Sat

-- C6: only weekend orders (won’t qualify)
INSERT INTO orders VALUES
(30, 6, 500.00, '2024-07-06'), -- Sat
(31, 6, 510.00, '2024-07-07'), -- Sun
(32, 6, 520.00, '2024-07-13'); -- Sat



WITH agg AS (
  SELECT
    customer_id,
    AVG(CASE WHEN WEEKDAY(order_date) IN (5,6) THEN order_amount END) AS avg_weekend,
    AVG(CASE WHEN WEEKDAY(order_date) NOT IN (5,6) THEN order_amount END) AS avg_weekday,
    SUM(CASE WHEN WEEKDAY(order_date) IN (5,6) THEN 1 ELSE 0 END)      AS cnt_weekend,
    SUM(CASE WHEN WEEKDAY(order_date) NOT IN (5,6) THEN 1 ELSE 0 END)  AS cnt_weekday
  FROM orders
  GROUP BY customer_id
)
SELECT
  customer_id,
  ROUND(avg_weekend, 2) AS avg_weekend,
  ROUND(avg_weekday, 2) AS avg_weekday,
  ROUND(100 * (avg_weekend - avg_weekday) / avg_weekday, 2) AS pct_diff
FROM agg
WHERE cnt_weekend >= 3
  AND cnt_weekday >= 3
  AND avg_weekend >= 1.20 * avg_weekday
ORDER BY customer_id;
