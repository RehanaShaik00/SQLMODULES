
DROP TABLE IF EXISTS bookings;
DROP TABLE IF EXISTS listings;

-- Listings
CREATE TABLE listings (
  listing_id     INT PRIMARY KEY,
  host_id        INT NOT NULL,
  location       VARCHAR(20) NOT NULL,
  room_type      VARCHAR(20) NOT NULL,
  price          DECIMAL(10,2) NOT NULL,
  minimum_nights INT NOT NULL
);

INSERT INTO listings (listing_id, host_id, location, room_type, price, minimum_nights) VALUES
(1, 101, 'Downtown', 'Entire home/apt', 150.00, 2),
(2, 101, 'Downtown', 'Private room',     80.00, 1),
(3, 101, 'Downtown', 'Entire home/apt', 200.00, 3),
(4, 102, 'Downtown', 'Entire home/apt', 120.00, 2),
(5, 102, 'Downtown', 'Private room',    100.00, 1),
(6, 102, 'Midtown',  'Entire home/apt', 250.00, 2),
(7, 103, 'Midtown',  'Entire home/apt',  70.00, 1),
(8, 103, 'Midtown',  'Private room',     90.00, 1),
(9, 104, 'Midtown',  'Private room',    170.00, 1);

-- Bookings
CREATE TABLE bookings (
  booking_id    INT PRIMARY KEY,
  listing_id    INT NOT NULL,
  checkin_date  DATE NOT NULL,
  checkout_date DATE NOT NULL
);

INSERT INTO bookings (booking_id, listing_id, checkin_date, checkout_date) VALUES
(1 , 1, '2023-01-05', '2023-01-10'),
(2 , 1, '2023-01-11','2023-01-13'),
(3 , 2, '2023-01-15','2023-01-25'),
(4 , 3, '2023-01-10','2023-01-17'),
(5 , 3, '2023-01-19','2023-01-21'),
(6 , 3, '2023-01-22','2023-01-23'),
(7 , 4, '2023-01-03','2023-01-05'),
(8 , 5, '2023-01-10','2023-01-12'),
(9 , 6, '2023-01-15','2023-01-20'),
(10, 6, '2023-01-20','2023-01-22'),
(11, 7, '2023-01-25','2023-01-29');

-- Best room type per location by highest AVG occupied days in Jan-2023
WITH occ AS (
  SELECT
    l.location,
    l.room_type,
    l.listing_id,
    COALESCE(SUM(
      GREATEST(
        0,
        DATEDIFF(LEAST(b.checkout_date,'2023-02-01'),
                 GREATEST(b.checkin_date,'2023-01-01'))
      )
    ),0) AS days_booked
  FROM listings l
  LEFT JOIN bookings b ON b.listing_id = l.listing_id
  GROUP BY l.location, l.room_type, l.listing_id
),
avg_room AS (
  SELECT location, room_type, AVG(days_booked) AS avg_days
  FROM occ
  GROUP BY location, room_type
)
SELECT
  location,
  room_type AS best_room_type,
  ROUND(avg_days, 2) AS avg_occupancy_days
FROM (
  SELECT *,
         ROW_NUMBER() OVER (PARTITION BY location ORDER BY avg_days DESC, room_type) AS rn
  FROM avg_room
) x
WHERE rn = 1
ORDER BY avg_occupancy_days DESC;
