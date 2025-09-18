
DROP TABLE IF EXISTS orders;

-- Orders (includes rider_delivery_mins so prep time = (actual - order) - rider mins)
CREATE TABLE orders (
  order_id              INT PRIMARY KEY,
  restaurant_id         INT NOT NULL,
  order_time            TIME NOT NULL,
  expected_delivery_time TIME NOT NULL,
  actual_delivery_time  TIME NOT NULL,
  rider_delivery_mins   INT  NOT NULL
);

-- Data as shown (times) + sensible rider minutes
INSERT INTO orders VALUES
(1, 101, '12:00:00', '12:30:00', '12:45:00', 20),  -- total 45 → prep 25
(2, 102, '12:15:00', '12:45:00', '12:55:00', 20),  -- prep 20
(3, 103, '12:30:00', '13:00:00', '13:10:00', 18),  -- prep 22
(4, 101, '12:45:00', '13:15:00', '13:21:00', 18),  -- prep 18
(5, 102, '13:00:00', '13:30:00', '13:36:00', 16),  -- prep 20
(6, 103, '13:15:00', '13:45:00', '13:58:00', 20),  -- prep 23
(7, 101, '13:30:00', '14:00:00', '14:12:00', 22);  -- prep 20

-- Average food preparation time (minutes) per restaurant
SELECT
  restaurant_id,
  ROUND(
    AVG((TIME_TO_SEC(actual_delivery_time) - TIME_TO_SEC(order_time))/60 - rider_delivery_mins),
    2
  ) AS avg_prep_mins
FROM orders
GROUP BY restaurant_id
ORDER BY avg_prep_mins ASC, restaurant_id;

