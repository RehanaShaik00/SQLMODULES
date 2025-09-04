USE modules;
DROP TABLE IF EXISTS malware;

-- Table
CREATE TABLE malware (
  software_id      INT,
  run_date         DATETIME,
  malware_detected INT
);

-- Data (as shown)
INSERT INTO malware (software_id, run_date, malware_detected) VALUES
(100, '2024-01-01 02:00:01', 12),
(100, '2024-01-01 03:12:01', 15),
(100, '2024-01-01 16:00:00',  9),

(101, '2024-01-01 12:00:00',  9),
(101, '2024-01-01 16:00:00', 10),
(101, '2024-01-01 18:00:00', 12),

(102, '2024-01-01 12:00:00', 14),
(102, '2024-01-01 14:00:00', 13),

(103, '2024-01-01 15:00:00', 16),
(103, '2024-01-01 17:00:00', 11),

(104, '2024-01-01 18:30:00',  8);

/*
There are multiple antivirus software which are running on the system and 
you have the data of how many malware they have detected in each run.  
You need to find out how many malwares each software has detected in their latest run 
and what is the difference between the number of malwares detected in latest run and the 
second last run for each software. 
Please note that list only the software which have run for at least 2 times 
and have detected at least 10 malware in the latest run.
*/

 



-- SELECT software_id,malware_detected
-- FROM malware m
-- WHERE malware_detected IN (SELECT malware_detected FROM malware m1 WHERE m.software_id = m1.software_id AND run_date IN (SELECT MAX(run_date) FROM malware m2 WHERE m.software_id = m2.software_id GROUP BY software_id HAVING malware_detected >= 10 AND COUNT(run_date)>=2));

WITH r AS (
  SELECT
      software_id,
      run_date,
      malware_detected,
      LAG(malware_detected) OVER (
        PARTITION BY software_id ORDER BY run_date
      ) AS prev_detected,
      ROW_NUMBER() OVER (
        PARTITION BY software_id ORDER BY run_date DESC
      ) AS rn,
      COUNT(*) OVER (PARTITION BY software_id) AS run_cnt
  FROM malware
)
SELECT
    software_id,
    malware_detected AS latest_detected,
    (malware_detected - prev_detected) AS diff_from_prev
FROM r
WHERE rn = 1          -- latest run per software
  AND run_cnt >= 2    -- ran at least twice
  AND malware_detected >= 10
ORDER BY software_id;