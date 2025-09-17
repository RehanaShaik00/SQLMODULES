
DROP TABLE IF EXISTS airbnb_listings;
CREATE TABLE airbnb_listings (
  property_id     INT PRIMARY KEY,
  neighborhood    VARCHAR(50),
  cost_per_night  INT,
  room_type       VARCHAR(50),
  amenities       TEXT
);

INSERT INTO airbnb_listings (property_id, neighborhood, cost_per_night, room_type, amenities) VALUES
(101,'Manhattan',80,'Entire home','tv; INTERNET; Kitchen'),
(102,'Manhattan',80,'Entire home','TV; internet; Kitchen'),
(103,'Brooklyn', 65,'Apartment'  ,'TV; Internet; Air Conditioner'),
(104,'Queens',   50,'Entire home','TV; Internet; WiFi; Balcony'),
(105,'Bronx',    90,'Apartment'  ,'TV; Internet; Parking'),
(106,'Bronx',    80,'Entire home','TV; Internet'),
(107,'Bronx',    85,'Entire home','TV; Internet; Pool'),
(201,'Manhattan',70,'Private room','TV; Internet; Heating'),
(202,'Manhattan',75,'Shared room' ,'TV; Internet'),
(203,'Brooklyn', 60,'Entire home','Internet; Heating'),
(204,'Brooklyn', 55,'Apartment'  ,'TV; Kitchen'),
(205,'Queens',   45,'Entire home','WiFi; Balcony; Garden');

WITH filt AS (
  SELECT
    property_id,
    neighborhood,
    cost_per_night,
    (LENGTH(amenities) - LENGTH(REPLACE(amenities,';','')) + 1) AS amen_count
  FROM airbnb_listings
  WHERE room_type IN ('Entire home','Apartment')
    AND LOWER(amenities) LIKE '%tv%'
    AND LOWER(amenities) LIKE '%internet%'
),
ranked AS (
  SELECT
    *,
    ROW_NUMBER() OVER (
      PARTITION BY neighborhood
      ORDER BY cost_per_night ASC, amen_count DESC, property_id ASC
    ) AS rn
  FROM filt
)
SELECT neighborhood, property_id, cost_per_night
FROM ranked
WHERE rn = 1
ORDER BY neighborhood;
