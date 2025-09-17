-- Schema


DROP TABLE IF EXISTS events;
DROP TABLE IF EXISTS users;

-- users: one row per (user_id, platform)
CREATE TABLE users (
  user_id  INT NOT NULL,
  name     VARCHAR(50) NOT NULL,
  platform VARCHAR(20) NOT NULL,
  PRIMARY KEY (user_id, platform)
);

-- events: user interactions on a specific platform
CREATE TABLE events (
  event_id   INT PRIMARY KEY,
  user_id    INT NOT NULL,
  action     VARCHAR(20) NOT NULL,    -- 'like','comment','post'
  platform   VARCHAR(20) NOT NULL,    -- 'LinkedIn','Meta','Instagram'
  created_at DATETIME NOT NULL
);

-- Data (from screenshots)
INSERT INTO users (user_id, name, platform) VALUES
(1, 'Alice',  'LinkedIn'),
(1, 'Alice',  'Meta'),
(2, 'Bob',    'LinkedIn'),
(2, 'Bob',    'Instagram'),
(3, 'Charlie','Meta'),
(3, 'Charlie','Instagram'),
(4, 'David',  'Meta'),
(4, 'David',  'LinkedIn'),
(5, 'Eve',    'Instagram'),
(5, 'Eve',    'LinkedIn'),
(6, 'Frank',  'Instagram'),
(6, 'Frank',  'Meta');

INSERT INTO events (event_id, user_id, action, platform, created_at) VALUES
(101, 1, 'like',    'LinkedIn',  '2024-03-20 10:00:00'),
(102, 1, 'comment', 'Meta',      '2024-03-21 11:00:00'),
(103, 2, 'post',    'LinkedIn',  '2024-03-22 12:00:00'),
(104, 2, 'post',    'Instagram', '2024-03-22 13:00:00'),
(105, 3, 'like',    'Meta',      '2024-03-23 13:00:00'),
(106, 3, 'comment', 'Instagram', '2024-03-24 14:00:00'),
(107, 4, 'post',    'Meta',      '2024-03-25 15:00:00'),
(108, 4, 'like',    'LinkedIn',  '2024-03-26 16:00:00'),
(109, 5, 'post',    'Instagram', '2024-03-27 17:00:00'),
(110, 5, 'like',    'LinkedIn',  '2024-03-28 18:00:00'),
(111, 6, 'comment', 'Instagram', '2024-03-29 19:00:00');


SELECT
  platform,
  ROUND(100.0 * SUM(CASE WHEN has_like_or_comment = 0 THEN 1 ELSE 0 END) / COUNT(*), 2)
    AS pct_never_liked_or_commented
FROM (
  SELECT
    u.platform,
    u.user_id,
    CASE WHEN COUNT(e.event_id) > 0 THEN 1 ELSE 0 END AS has_like_or_comment
  FROM users u
  LEFT JOIN events e
    ON e.user_id = u.user_id
   AND e.platform = u.platform
   AND e.action IN ('like','comment')
  GROUP BY u.platform, u.user_id
) x
GROUP BY platform
ORDER BY platform;
