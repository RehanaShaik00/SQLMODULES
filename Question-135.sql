
DROP TABLE IF EXISTS user_sessions;

-- Logins (UTC timestamps)
CREATE TABLE user_sessions (
  user_id         INT NOT NULL,
  login_timestamp DATETIME NOT NULL,
  KEY (user_id, login_timestamp)
);

-- Sample data (as shown + a few extra rows to test)
INSERT INTO user_sessions (user_id, login_timestamp) VALUES
-- user 1: multiple logins every day from Jun 6 → Jun 13
(1,'2025-06-06 00:01:05'),
(1,'2025-06-06 03:01:05'),
(1,'2025-06-07 00:01:05'),
(1,'2025-06-07 05:01:05'),
(1,'2025-06-08 00:01:05'),
(1,'2025-06-08 02:01:05'),
(1,'2025-06-09 00:01:05'),
(1,'2025-06-10 00:01:05'),
(1,'2025-06-11 00:01:05'),
(1,'2025-06-12 00:01:05'),
(1,'2025-06-13 00:01:05'),

-- user 2: some days missing (not fully consistent)
(2,'2025-06-06 00:01:05'),
(2,'2025-06-08 00:01:05'),
(2,'2025-06-09 01:01:05'),
(2,'2025-06-11 02:01:05'),

-- user 3: a couple of scattered logins
(3,'2025-06-10 00:15:20'),
(3,'2025-06-10 12:34:56'),
(3,'2025-06-13 07:05:00');

SELECT user_id
FROM user_sessions
GROUP BY user_id
HAVING COUNT(DISTINCT DATE(login_timestamp)) =
       DATEDIFF(
         (SELECT DATE(MAX(login_timestamp)) FROM user_sessions),
         DATE(MIN(login_timestamp))
       ) + 1
ORDER BY user_id;
