-- reset
DROP TABLE IF EXISTS rating_table;

CREATE TABLE rating_table (
  trip_time  DATETIME,
  driver_id  VARCHAR(1),
  trip_id    INT,
  rating     INT
);

INSERT INTO rating_table (trip_time, driver_id, trip_id, rating) VALUES
('2023-04-24 10:15:00','a',0, 4),
('2023-04-24 15:20:27','a',1, 5),
('2023-04-24 22:32:27','a',2, 5),
('2023-04-25 08:00:00','a',3, 3),
('2023-04-25 12:00:00','a',4, 4),
('2023-04-25 12:30:00','a',5, 5),
('2023-04-24 09:15:00','b',6, 4),
('2023-04-24 13:20:00','b',7, 4),
('2023-04-25 09:45:00','b',8, 3),
('2023-04-25 11:30:00','b',9, 4),
('2023-04-25 14:00:00','b',10,5),
('2023-04-24 08:30:00','c',11,5);

/*
A Cab booking company has a dataset of its trip ratings, each row represents a single trip of a driver. 
A trip has a positive rating if it was rated 4 or above, 
a streak of positive ratings is when a driver has a rating of 4 and above in consecutive trips. 
example: If there are 3 consecutive trips with a rating of 4 or above then the streak is 2.
Find out the maximum streak that a driver has had and sort the output in descending order 
of their maximum streak and then by descending order of driver_id.
Note: only users who have at least 1 streak should be included in the output.
*/

-- Max streak = longest run of consecutive ratings >= 4 (run length - 1)
WITH s AS (
  SELECT
    driver_id,
    trip_time,
    rating,
    SUM(CASE WHEN rating < 4 THEN 1 ELSE 0 END) 
      OVER (PARTITION BY driver_id ORDER BY trip_time) AS grp   -- break groups
  FROM rating_table
),
runs AS (
  SELECT driver_id, grp, COUNT(*) AS run_len
  FROM s
  WHERE rating >= 4
  GROUP BY driver_id, grp
)
SELECT
  driver_id,
  MAX(run_len - 1) AS max_streak
FROM runs
GROUP BY driver_id
HAVING MAX(run_len) >= 2                 -- at least one streak (run_len ≥ 2)
ORDER BY max_streak DESC, driver_id DESC;
