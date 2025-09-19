WITH events AS (
  SELECT station_id, arrival_time AS event_time, 1 AS chge
  FROM train_schedule
  UNION ALL
  SELECT station_id, departure_time AS event_time, -1 AS chge
  FROM train_schedule
)
SELECT station_id,MAX(running_total) AS min_platforms FROM (
SELECT station_id, event_time,
SUM(chge) OVER (PARTITION BY station_id ORDER BY event_time, chge DESC) AS running_total
FROM events
) t
GROUP BY station_id
ORDER BY station_id;