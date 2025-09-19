
DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
  order_id      INT PRIMARY KEY,
  rider_id      INT NOT NULL,
  pickup_time   DATETIME NOT NULL,
  delivery_time DATETIME NOT NULL
);

-- Sample data (as shown)
INSERT INTO orders (order_id, rider_id, pickup_time, delivery_time) VALUES
(1, 101, '2024-01-01 10:00:00', '2024-01-01 10:30:00'),
(2, 102, '2024-01-01 23:50:00', '2024-01-02 00:10:00'),
(3, 103, '2024-01-01 13:45:00', '2024-01-01 14:15:00'),
(4, 101, '2024-01-01 23:45:00', '2024-01-02 00:15:00'),
(5, 102, '2024-01-02 01:30:00', '2024-01-02 02:00:00'),
(6, 103, '2024-01-02 23:59:00', '2024-01-03 00:31:00'),
(7, 101, '2024-01-03 09:00:00', '2024-01-03 09:30:00');

WITH parts AS (
  -- time on the pickup day
  SELECT
    rider_id,
    DATE(pickup_time) AS ride_date,
    TIMESTAMPDIFF(
      MINUTE,
      pickup_time,
      CASE
        WHEN DATE(pickup_time) = DATE(delivery_time)
          THEN delivery_time
        ELSE DATE_ADD(DATE(pickup_time), INTERVAL 1 DAY)   -- until midnight
      END
    ) AS mins
  FROM orders

  UNION ALL

  SELECT
    rider_id,
    DATE(delivery_time) AS ride_date,
    CASE
      WHEN DATE(pickup_time) = DATE(delivery_time) THEN 0
      ELSE TIMESTAMPDIFF(MINUTE, DATE(delivery_time), delivery_time)
    END AS mins
  FROM orders
)
SELECT
  rider_id,
  ride_date,
  SUM(mins) AS minutes_spent
FROM parts
WHERE mins > 0
GROUP BY rider_id, ride_date
ORDER BY rider_id, ride_date;

