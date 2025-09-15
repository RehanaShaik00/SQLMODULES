-- reset
DROP TABLE IF EXISTS events;

CREATE TABLE events (
  user_id    INT,
  event_type VARCHAR(20),
  event_time TIMESTAMP
);

INSERT INTO events (user_id, event_type, event_time) VALUES
(1, 'click',  '2023-09-10 09:00:00'),
(1, 'click',  '2023-09-10 10:00:00'),
(1, 'scroll', '2023-09-10 10:20:00'),
(1, 'click',  '2023-09-10 10:50:00'),
(1, 'scroll', '2023-09-10 11:40:00'),
(1, 'click',  '2023-09-10 12:40:00'),
(1, 'scroll', '2023-09-10 12:50:00'),
(2, 'click',  '2023-09-10 09:00:00'),
(2, 'scroll', '2023-09-10 09:20:00'),
(2, 'click',  '2023-09-10 10:30:00');

/*
1. Identify user sessions. A session is defined as a sequence of activities by a user where the time difference between consecutive events is less than or equal to 30 minutes. If the time between two events exceeds 30 minutes, it's considered the start of a new session.
2. For each session, calculate the following metrics:
session_id : a unique identifier for each session.
session_start_time : the timestamp of the first event in the session.
session_end_time : the timestamp of the last event in the session.
session_duration : the difference between session_end_time and session_start_time.
event_count : the number of events in the session.  */

-- Sessionize (30-min gap) and aggregate per session
SELECT
  CONCAT(user_id, '-', session_no)                  AS session_id,
  user_id,
  MIN(event_time)                                   AS session_start_time,
  MAX(event_time)                                   AS session_end_time,
  TIMESTAMPDIFF(MINUTE, MIN(event_time), MAX(event_time)) AS session_duration_minutes,
  COUNT(*)                                          AS event_count
FROM (
  SELECT
    user_id,
    event_time,
    -- running sum of "is_new" marks the session number
    SUM(is_new) OVER (PARTITION BY user_id ORDER BY event_time) AS session_no
  FROM (
    -- mark a new session when gap > 30 minutes (or first event)
    SELECT
      user_id,
      event_time,
      CASE
        WHEN LAG(event_time) OVER (PARTITION BY user_id ORDER BY event_time) IS NULL
          OR TIMESTAMPDIFF(
               MINUTE,
               LAG(event_time) OVER (PARTITION BY user_id ORDER BY event_time),
               event_time
             ) > 30
        THEN 1 ELSE 0
      END AS is_new
    FROM events
  ) e
) s
GROUP BY user_id, session_no
ORDER BY user_id, session_start_time;
