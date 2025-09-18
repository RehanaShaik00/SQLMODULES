
DROP TABLE IF EXISTS dashboard_visit;
CREATE TABLE dashboard_visit (
  user_id    VARCHAR(10) NOT NULL,
  visit_time DATETIME    NOT NULL,
  PRIMARY KEY (user_id, visit_time)
);

INSERT INTO dashboard_visit (user_id, visit_time) VALUES
('Alice',   '2021-12-04 10:44:56'),
('Alice',   '2021-12-04 10:55:56'),
('Alice',   '2021-12-04 12:56:56'),
('Bob',     '2021-12-05 12:55:56'),
('Bob',     '2021-12-06 14:55:56'),
('Charlie', '2021-11-06 17:35:50'),
('Charlie', '2021-11-06 17:56:50'),
('David',   '2021-11-29 13:53:50'),
('David',   '2021-12-01 10:53:50'),
('David',   '2021-12-06 23:53:50'),
('David',   '2021-12-07 00:20:50');

WITH v AS (
  SELECT
    user_id,
    visit_time,
    LAG(visit_time) OVER (PARTITION BY user_id ORDER BY visit_time) AS prev_time
  FROM dashboard_visit
)
SELECT
  user_id,
  SUM(CASE WHEN prev_time IS NULL OR visit_time >= prev_time + INTERVAL 60 MINUTE
           THEN 1 ELSE 0 END) AS total_visits,
  COUNT(DISTINCT DATE(visit_time)) AS distinct_days
FROM v
GROUP BY user_id
ORDER BY user_id;
