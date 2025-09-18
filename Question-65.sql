
DROP TABLE IF EXISTS service_status;
CREATE TABLE service_status (
  service_name  VARCHAR(20) NOT NULL,
  status        VARCHAR(4)  NOT NULL,   -- 'up' or 'down'
  updated_time  DATETIME    NOT NULL,
  PRIMARY KEY (service_name, updated_time)
);

-- hdfs: down from 10:02 to 10:07 (6 straight minutes)
INSERT INTO service_status VALUES
('hdfs','up',   '2024-03-06 10:01:00'),
('hdfs','down', '2024-03-06 10:02:00'),
('hdfs','down', '2024-03-06 10:03:00'),
('hdfs','down', '2024-03-06 10:04:00'),
('hdfs','down', '2024-03-06 10:05:00'),
('hdfs','down', '2024-03-06 10:06:00'),
('hdfs','down', '2024-03-06 10:07:00'),
('hdfs','up',   '2024-03-06 10:08:00');

-- api: no long outages
INSERT INTO service_status VALUES
('api','up',   '2024-03-06 10:00:00'),
('api','down', '2024-03-06 10:01:00'),
('api','up',   '2024-03-06 10:02:00'),
('api','down', '2024-03-06 10:05:00'),
('api','up',   '2024-03-06 10:06:00');

-- db: down from 10:30 to 10:34 (5 straight minutes)
INSERT INTO service_status VALUES
('db','up',   '2024-03-06 10:29:00'),
('db','down', '2024-03-06 10:30:00'),
('db','down', '2024-03-06 10:31:00'),
('db','down', '2024-03-06 10:32:00'),
('db','down', '2024-03-06 10:33:00'),
('db','down', '2024-03-06 10:34:00'),
('db','up',   '2024-03-06 10:35:00');

-- Consecutive down streaks ≥ 5 minutes (simple MySQL 8+)
SELECT
  service_name,
  MIN(updated_time) AS down_start,
  MAX(updated_time) AS down_end,
  COUNT(*)          AS down_minutes
FROM (
  SELECT
    service_name,
    updated_time,
    -- same value within a consecutive-per-minute run
    TIMESTAMPDIFF(MINUTE, '2000-01-01', updated_time)
      - ROW_NUMBER() OVER (PARTITION BY service_name ORDER BY updated_time) AS grp
  FROM service_status
  WHERE status = 'down'
) t
GROUP BY service_name, grp
HAVING COUNT(*) >= 5
ORDER BY down_minutes DESC, service_name, down_start;
