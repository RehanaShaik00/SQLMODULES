
DROP TABLE IF EXISTS bookings;
DROP TABLE IF EXISTS calendar_dim;

CREATE TABLE bookings (
  room_id        INT NOT NULL,
  customer_id    INT NOT NULL,
  check_in_date  DATE NOT NULL,
  check_out_date DATE NOT NULL
);

INSERT INTO bookings (room_id, customer_id, check_in_date, check_out_date) VALUES
(1, 101, '2024-04-01', '2024-04-04'),
(2, 102, '2024-04-02', '2024-04-05'),
(1, 103, '2024-04-02', '2024-04-06'),
(3, 104, '2024-04-03', '2024-04-05'),
(2, 105, '2024-04-04', '2024-04-07'),
(1, 106, '2024-04-05', '2024-04-08'),
(3, 107, '2024-04-05', '2024-04-09');

CREATE TABLE calendar_dim (
  cal_date DATE PRIMARY KEY
);

INSERT INTO calendar_dim (cal_date) VALUES
('2024-04-01'),('2024-04-02'),('2024-04-03'),('2024-04-04'),('2024-04-05'),
('2024-04-06'),('2024-04-07'),('2024-04-08'),('2024-04-09'),('2024-04-10');

WITH occ AS (
  SELECT b.room_id, b.customer_id, d.cal_date
  FROM bookings b
  JOIN calendar_dim d
    ON d.cal_date >= b.check_in_date
   AND d.cal_date <  b.check_out_date          -- exclusive checkout
)
SELECT
  room_id,
  cal_date AS booking_date,
  GROUP_CONCAT(DISTINCT customer_id ORDER BY customer_id) AS customers_affected
FROM occ
GROUP BY room_id, cal_date
HAVING COUNT(DISTINCT customer_id) > 1          -- true overlaps
ORDER BY room_id, booking_date;
