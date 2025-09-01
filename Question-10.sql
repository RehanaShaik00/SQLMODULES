DROP TABLE IF EXISTS sachin;
CREATE TABLE sachin (
  match_no    INT PRIMARY KEY,
  runs_scored INT NOT NULL,
  status      VARCHAR(10) NOT NULL  -- use 'out' or 'not out'
);

INSERT INTO sachin (match_no, runs_scored, status) VALUES
(1,  80, 'out'),
(2,  45, 'out'),
(3,  60, 'out'),
(4,  30, 'not out'),
(5,  75, 'out'),
(6,  90, 'out'),
(7,  50, 'not out'),
(8,  80, 'out'),      -- cumulative hits 510 here (first time ≥ 500)
(9,  40, 'not out'),
(10, 25, 'out');

/*
Sachin Tendulkar - Also known as little master. 
You are given runs scored by Sachin in his first 10 matches. 
You need to write an SQL to get match number when he completed 500 runs 
and his batting average at the end of 10 matches.
Batting Average = (Total runs scored) / (no of times batsman got out)
Round the result to 2 decimal places.
*/
SELECT
  ( SELECT MIN(match_no)
    FROM (
      SELECT match_no,
             SUM(runs_scored) OVER (ORDER BY match_no) AS cum_runs
      FROM sachin
    ) s
    WHERE cum_runs >= 500
  ) AS match_when_500,
  ROUND(SUM(runs_scored)/(SELECT COUNT(match_no) FROM sachin WHERE status='not out'),2) AS BattingAverage
  FROM sachin;