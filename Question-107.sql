DROP TABLE IF EXISTS logs;

CREATE TABLE logs (
  log_id INT PRIMARY KEY
);

INSERT INTO logs (log_id) VALUES
(1),
(2),
(3),
(7),
(8),
(10),
(12),
(13),
(14),
(15),
(16);

/*
Write an SQL query to find all the contiguous ranges of log_id values.
*/

SELECT
  MIN(log_id) AS start_id,
  MAX(log_id) AS end_id
FROM (
  SELECT
    log_id,
    log_id - ROW_NUMBER() OVER (ORDER BY log_id) AS grp
  FROM module.logs
) t
GROUP BY grp
ORDER BY start_id;