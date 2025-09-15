DROP TABLE IF EXISTS reel;

CREATE TABLE reel (
  reel_id INT,
  record_date DATE,
  state VARCHAR(32),
  cumulative_views INT
);

-- Sample data (from the screenshot)
INSERT INTO reel (reel_id, record_date, state, cumulative_views) VALUES
-- reel 1 – California
(1,'2024-08-01','california',1000),
(1,'2024-08-02','california',1500),
(1,'2024-08-03','california',2000),
(1,'2024-08-04','california',2500),
(1,'2024-08-05','california',3000),
(1,'2024-08-01','nevada', 800),
(1,'2024-08-02','nevada',1200),
(1,'2024-08-03','nevada',1600),
(1,'2024-08-04','nevada',2000),
(1,'2024-08-05','nevada',2400),
(1,'2024-08-06','nevada',2800),
(1,'2024-08-07','nevada',3200);

/*
Meta (formerly Facebook) is analyzing the performance of Instagram Reels across different states 
in the USA. You have access to a table named REEL that tracks the cumulative views of each reel over time.
Write an SQL to get average daily views for each Instagram Reel in each state. 
Round the average to 2 decimal places and sort the result by average is descending order.*/

SELECT
  state,
  reel_id,
  ROUND(AVG(daily_views), 2) AS avg_daily_views
FROM (
  SELECT
    state,
    reel_id,
    record_date,
    cumulative_views
      - COALESCE(
          LAG(cumulative_views) OVER (
            PARTITION BY state, reel_id
            ORDER BY record_date
          ), 0
        ) AS daily_views
  FROM reel
) x
GROUP BY state, reel_id
ORDER BY avg_daily_views DESC;
