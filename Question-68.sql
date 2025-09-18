
DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
  order_id               INT PRIMARY KEY,
  restaurant_id          INT NOT NULL,
  order_time             TIME NOT NULL,
  expected_delivery_time TIME NOT NULL,
  actual_delivery_time   TIME NOT NULL,
  rider_delivery_mins    INT NOT NULL
);

INSERT INTO orders VALUES
(1, 101, '12:00:00', '12:30:00', '12:25:00', 12),  -- on time overall
(2, 102, '12:15:00', '12:40:00', '12:55:00', 28),  -- rider-only delay
(3, 103, '12:30:00', '13:05:00', '13:10:00', 25),  -- rider-only delay
(4, 101, '12:45:00', '13:12:00', '13:21:00', 23),  -- rider-only delay
(5, 102, '13:00:00', '13:30:00', '13:36:00', 21),  -- rider-only delay
(6, 103, '13:15:00', '13:45:00', '13:58:00', 30),  -- rider-only delay
(7, 101, '13:30:00', '14:00:00', '14:12:00', 27),  -- rider-only delay
(8, 102, '13:45:00', '14:20:00', '14:25:00', 23),  -- rider-only delay
(9, 103, '14:00:00', '14:32:00', '14:32:00', 15),  -- on time
(10,101, '14:15:00', '14:50:00', '15:05:00', 33);  -- rider-only delay

SELECT
  t.order_id,
  t.exp_mins  AS expected_delivery_mins,
  t.rider_delivery_mins,
  (t.act_mins - t.rider_delivery_mins) AS food_prep_mins
FROM (
  SELECT
    order_id,
    TIMESTAMPDIFF(MINUTE, order_time, expected_delivery_time) AS exp_mins,
    TIMESTAMPDIFF(MINUTE, order_time, actual_delivery_time)   AS act_mins,
    rider_delivery_mins
  FROM orders
) t
WHERE t.act_mins > t.exp_mins                 -- overall delayed
  AND t.rider_delivery_mins >  t.exp_mins/2   -- rider exceeded rider’s expected time
  AND (t.act_mins - t.rider_delivery_mins) <= t.exp_mins/2  -- kitchen within expected
ORDER BY t.order_id;