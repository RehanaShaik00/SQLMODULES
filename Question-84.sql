DROP TABLE IF EXISTS trips;
CREATE TABLE trips (
  trip_id     INT PRIMARY KEY,
  driver_id   INT NOT NULL,
  fare        INT NOT NULL,
  rating      DECIMAL(3,2) NOT NULL
);

-- 2) Sample data
-- Driver 1: will cross into 20% and 23% brackets after first 3 trips
INSERT INTO trips VALUES
  (101, 1, 200, 4.80),
  (102, 1, 150, 4.70),
  (103, 1, 100, 4.90),
  (104, 1, 300, 4.75),  -- avg prev3 = (4.80+4.70+4.90)/3 = 4.80 => 20%
  (105, 1, 120, 4.60),  -- avg prev3 = (4.70+4.90+4.75)/3 = 4.78 => 20%
  (106, 1, 180, 4.55);  -- avg prev3 = (4.90+4.75+4.60)/3 = 4.75 => 20%

-- Driver 2: middling ratings → often 23% after first 3
INSERT INTO trips VALUES
  (201, 2, 220, 4.40),
  (202, 2, 180, 4.60),
  (203, 2, 160, 4.50),
  (204, 2, 140, 4.55),  -- avg prev3 = (4.40+4.60+4.50)/3 = 4.50 => 23%
  (205, 2, 260, 4.65),  -- avg prev3 = (4.60+4.50+4.55)/3 = 4.55 => 23%
  (206, 2, 130, 4.70);  -- avg prev3 = (4.50+4.55+4.65)/3 = 4.57 => 23%

-- Driver 3: mostly low → default 24% after first 3
INSERT INTO trips VALUES
  (301, 3, 250, 4.20),
  (302, 3, 190, 4.30),
  (303, 3, 210, 4.40),
  (304, 3, 170, 4.10),  -- avg prev3 = (4.20+4.30+4.40)/3 = 4.30 => 24%
  (305, 3, 200, 4.25),  -- avg prev3 = (4.30+4.40+4.10)/3 = 4.27 => 24%
  (306, 3, 160, 4.35);
  
WITH
-- 1) Order trips per driver
ordered AS (
  SELECT
    t.*,
    ROW_NUMBER() OVER (PARTITION BY driver_id ORDER BY trip_id) AS rn
  FROM trips t
),
-- 2) Compute rolling avg of the LAST 3 trips BEFORE the current one
avg_prev3 AS (
  SELECT
    driver_id,
    trip_id,
    fare,
    rating,
    rn,
    AVG(rating) OVER (
      PARTITION BY driver_id
      ORDER BY trip_id
      ROWS BETWEEN 3 PRECEDING AND 1 PRECEDING
    ) AS avg_last3_before
  FROM ordered
),
-- 3) Tag the first 3 trips (always 24% commission)
first3_flag AS (
  SELECT
    driver_id,
    trip_id,
    fare,
    rating,
    rn,
    avg_last3_before,
    CASE WHEN rn <= 3 THEN 1 ELSE 0 END AS is_first3
  FROM avg_prev3
),
-- 4) Map to commission rates using the rules
commission_map AS (
  SELECT
    driver_id,
    trip_id,
    fare,
    rating,
    rn,
    avg_last3_before,
    is_first3,
    CASE
      WHEN is_first3 = 1 THEN 0.24
      ELSE CASE
        WHEN avg_last3_before >= 4.70 THEN 0.20
        WHEN avg_last3_before >= 4.50 THEN 0.23
        ELSE 0.24
      END
    END AS commission_rate
  FROM first3_flag
),
-- 5) Compute per-trip earnings after commission
per_trip_earnings AS (
  SELECT
    driver_id,
    trip_id,
    ROUND(fare * (1 - commission_rate), 2) AS net_earning
  FROM commission_map
),
-- 6) Aggregate to per-driver totals
per_driver_totals AS (
  SELECT
    driver_id,
    ROUND(SUM(net_earning), 2) AS total_earnings_after_commission
  FROM per_trip_earnings
  GROUP BY driver_id
)
SELECT
  driver_id,
  total_earnings_after_commission
FROM per_driver_totals
ORDER BY driver_id;