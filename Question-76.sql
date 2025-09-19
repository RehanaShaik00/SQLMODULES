
DROP TABLE IF EXISTS purchases;
DROP TABLE IF EXISTS notifications;

CREATE TABLE notifications (
  notification_id INT PRIMARY KEY,
  product_id      VARCHAR(2) NOT NULL,
  delivered_at    DATETIME   NOT NULL
);

CREATE TABLE purchases (
  user_id            INT        NOT NULL,
  product_id         VARCHAR(2) NOT NULL,
  purchase_timestamp DATETIME   NOT NULL
);

INSERT INTO notifications (notification_id, product_id, delivered_at) VALUES
(1, 'p1', '2024-01-01 08:00:00'),
(2, 'p2', '2024-01-01 10:30:00'),
(3, 'p3', '2024-01-01 11:30:00');

INSERT INTO purchases (user_id, product_id, purchase_timestamp) VALUES
(1, 'p1', '2024-01-01 09:00:00'),
(2, 'p2', '2024-01-01 09:00:00'),
(3, 'p2', '2024-01-01 09:30:00'),
(3, 'p1', '2024-01-01 10:20:00'),
(4, 'p2', '2024-01-01 10:40:00'),
(1, 'p2', '2024-01-01 10:50:00'),
(5, 'p2', '2024-01-01 11:45:00'),
(2, 'p3', '2024-01-01 11:45:00'),
(2, 'p3', '2024-01-01 12:30:00'),
(3, 'p3', '2024-01-01 14:30:00');

WITH w AS (
  SELECT
    n.*,
    LEAD(delivered_at) OVER (ORDER BY delivered_at) AS next_dt
  FROM notifications n
),
win AS (
  SELECT
    notification_id,
    product_id,
    delivered_at                                       AS start_dt,
    CASE
      WHEN next_dt IS NULL THEN delivered_at + INTERVAL 2 HOUR
      ELSE LEAST(next_dt, delivered_at + INTERVAL 2 HOUR)
    END                                                AS end_dt
  FROM w
)
SELECT
  win.notification_id,
  SUM(CASE WHEN p.product_id = win.product_id THEN 1 ELSE 0 END) AS same_product_purchases,
  SUM(CASE WHEN p.product_id IS NOT NULL AND p.product_id <> win.product_id THEN 1 ELSE 0 END)
    AS other_product_purchases
FROM win
LEFT JOIN purchases p
  ON p.purchase_timestamp >= win.start_dt
 AND p.purchase_timestamp <  win.end_dt
GROUP BY win.notification_id
ORDER BY win.notification_id;
