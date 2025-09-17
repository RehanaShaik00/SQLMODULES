
-- Reset tables
DROP TABLE IF EXISTS usages;
DROP TABLE IF EXISTS users;

-- Users (registration cohort)
CREATE TABLE users (
  user_id           VARCHAR(10) NOT NULL PRIMARY KEY,
  registration_date DATE        NOT NULL
);

INSERT INTO users (user_id, registration_date) VALUES
('aaa','2019-01-03'),
('bbb','2019-01-02'),
('ccc','2019-01-15'),
('ddd','2019-02-07'),
('eee','2019-02-08');

-- App usage logs
CREATE TABLE usages (
  user_id    VARCHAR(10) NOT NULL,
  usage_date DATE        NOT NULL,
  location   VARCHAR(40) NOT NULL,
  time_spent INT         NOT NULL
);

-- Rows match the screenshots (mix of locations and minutes)
INSERT INTO usages (user_id, usage_date, location, time_spent) VALUES
('aaa','2019-01-03','US',      38),
('aaa','2019-02-01','US',      12),
('aaa','2019-03-04','US',      30),
('bbb','2019-01-03','US',      20),
('bbb','2019-02-04','Canada',  31),
('ccc','2019-01-16','US',      40),
('ddd','2019-02-08','US',      45),
('eee','2019-02-10','US',      21),
('eee','2019-02-20','CANADA',  12),
('eee','2019-03-15','US',      10),
('eee','2019-04-25','US',      12);

WITH per_user AS (
  SELECT
    u.user_id,
    DATE_FORMAT(u.registration_date, '%Y-%m') AS registration_month,
    SUM(CASE
          WHEN us.usage_date >= u.registration_date
           AND us.usage_date <  DATE_ADD(u.registration_date, INTERVAL 1 MONTH)
          THEN us.time_spent ELSE 0 END) AS m1_mins,
    SUM(CASE
          WHEN us.usage_date >= DATE_ADD(u.registration_date, INTERVAL 1 MONTH)
           AND us.usage_date <  DATE_ADD(u.registration_date, INTERVAL 2 MONTH)
          THEN us.time_spent ELSE 0 END) AS m2_mins,
    SUM(CASE
          WHEN us.usage_date >= DATE_ADD(u.registration_date, INTERVAL 2 MONTH)
           AND us.usage_date <  DATE_ADD(u.registration_date, INTERVAL 3 MONTH)
          THEN us.time_spent ELSE 0 END) AS m3_mins
  FROM users u
  LEFT JOIN usages us
    ON us.user_id = u.user_id
  GROUP BY u.user_id, registration_month
)
SELECT
  registration_month,
  COUNT(*) AS total_users,
  ROUND(100 * AVG(CASE WHEN m1_mins >= 30 THEN 1 ELSE 0 END), 2) AS m1_retention,
  ROUND(100 * AVG(CASE WHEN m2_mins >= 30 THEN 1 ELSE 0 END), 2) AS m2_retention,
  ROUND(100 * AVG(CASE WHEN m3_mins >= 30 THEN 1 ELSE 0 END), 2) AS m3_retention
FROM per_user
GROUP BY registration_month
ORDER BY registration_month;