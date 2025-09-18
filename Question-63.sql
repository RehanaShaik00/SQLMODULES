
DROP TABLE IF EXISTS events;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
  user_id INT PRIMARY KEY,
  name    VARCHAR(15) NOT NULL
);

CREATE TABLE events (
  user_id     INT NOT NULL,
  type        VARCHAR(15) NOT NULL,
  access_date DATE NOT NULL,
  KEY (user_id, access_date)
);

INSERT INTO users (user_id, name) VALUES
(1, 'Saurabh'),
(2, 'Amit'),
(3, 'Ankit');

INSERT INTO events (user_id, type, access_date) VALUES
(1, 'Amazon Music', '2024-01-05'),
(1, 'Amazon Video', '2024-01-07'),
(1, 'Prime',        '2024-01-08'),
(1, 'Amazon Video', '2024-01-09'),
(2, 'Amazon Pay',   '2024-01-08'),
(2, 'Prime',        '2024-01-09'),
(3, 'Amazon Pay',   '2024-01-07'),
(3, 'Amazon Music', '2024-01-09');

-- Prime date + last service just before it (or last ever if never Prime)
WITH prime AS (
  SELECT user_id, MIN(access_date) AS prime_date
  FROM events
  WHERE LOWER(type) = 'prime'
  GROUP BY user_id
),
last_before AS (
  SELECT
    e.user_id,
    e.type AS last_service,
    e.access_date AS last_service_date,
    ROW_NUMBER() OVER (
      PARTITION BY e.user_id
      ORDER BY e.access_date DESC
    ) AS rn
  FROM events e
  LEFT JOIN prime p ON p.user_id = e.user_id
  WHERE e.type <> 'Prime'
    AND e.access_date < COALESCE(p.prime_date, '9999-12-31')   -- if never prime, take last ever
)
SELECT
  u.user_id,
  p.prime_date,
  lb.last_service,
  lb.last_service_date
FROM users u
LEFT JOIN prime p       ON p.user_id = u.user_id
LEFT JOIN last_before lb ON lb.user_id = u.user_id AND lb.rn = 1
ORDER BY lb.last_service_date ASC;
