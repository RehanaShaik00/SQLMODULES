
DROP TABLE IF EXISTS watch_history;

CREATE TABLE watch_history (
  user_id        INT,
  show_id        INT,
  watch_date     DATE,
  watch_duration INT
);

INSERT INTO watch_history (user_id, show_id, watch_date, watch_duration) VALUES
(1,  101, '2024-11-01', 120),
(2,  101, '2024-11-01', 100),
(3,  101, '2024-11-02', 130),
(4,  102, '2024-11-01',  60),
(4,  102, '2024-11-02',  70),
(4,  102, '2024-11-03',  80),
(5,  103, '2024-11-01',  90),
(6,  103, '2024-11-02', 200),
(7,  103, '2024-11-03',  90),
(8,  105, '2024-11-01', 1000),
(9,  106, '2024-11-01', 150),
(10, 106, '2024-11-02', 140);

WITH per_show AS (
  SELECT
    show_id,
    COUNT(DISTINCT user_id) AS unique_watchers,
    SUM(watch_duration)     AS total_duration
  FROM watch_history
  GROUP BY show_id
),
ranked AS (
  SELECT
    *,
    ROW_NUMBER() OVER (
      ORDER BY unique_watchers DESC, total_duration DESC
    ) AS rn
  FROM per_show
)
SELECT show_id, unique_watchers, total_duration
FROM ranked
WHERE rn <= 3
ORDER BY show_id;
