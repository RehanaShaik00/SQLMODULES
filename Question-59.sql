
DROP TABLE IF EXISTS holidays;
DROP TABLE IF EXISTS orders;

CREATE TABLE orders (
  order_id   INT PRIMARY KEY,
  order_date DATE NOT NULL,
  ship_date  DATE NOT NULL
);

CREATE TABLE holidays (
  holiday_id   INT PRIMARY KEY,
  holiday_date DATE NOT NULL
);

INSERT INTO orders (order_id, order_date, ship_date) VALUES
(1, '2024-03-14', '2024-03-20'),
(2, '2024-03-10', '2024-03-16'),
(3, '2024-03-04', '2024-03-12'),
(4, '2024-03-05', '2024-03-07'),
(5, '2024-03-03', '2024-03-08'),
(6, '2024-03-07', '2024-03-24');

INSERT INTO holidays (holiday_id, holiday_date) VALUES
(1, '2024-03-10'),
(2, '2024-03-18'),
(3, '2024-03-21');

WITH a AS (
  SELECT
    order_id,
    CASE
      WHEN DAYOFWEEK(order_date)=7 THEN DATE_ADD(order_date, INTERVAL 2 DAY)   -- Sat -> Mon
      WHEN DAYOFWEEK(order_date)=1 THEN DATE_ADD(order_date, INTERVAL 1 DAY)   -- Sun -> Mon
      ELSE order_date
    END AS od,
    CASE
      WHEN DAYOFWEEK(ship_date)=1 THEN DATE_SUB(ship_date, INTERVAL 2 DAY)     -- Sun -> Fri
      WHEN DAYOFWEEK(ship_date)=7 THEN DATE_SUB(ship_date, INTERVAL 1 DAY)     -- Sat -> Fri
      ELSE ship_date
    END AS sd
  FROM orders
)
SELECT
  a.order_id,
  DATEDIFF(a.sd, a.od) - COUNT(h.holiday_date) AS lead_time_days
FROM a
LEFT JOIN holidays h
  ON h.holiday_date BETWEEN a.od AND a.sd
GROUP BY a.order_id, a.od, a.sd
ORDER BY a.order_id;
