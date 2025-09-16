DROP TABLE IF EXISTS assessments;

CREATE TABLE assessments (
  candidate_id INT PRIMARY KEY,
  experience   INT,
  sql_score    INT,
  algo         INT,
  bug_fixing   INT
);

INSERT INTO assessments (candidate_id, experience, sql_score, algo, bug_fixing) VALUES
(1,  3, 100, NULL,  50),
(2,  5, NULL, 100, 100),
(3,  1, 100, 100, 100),
(4,  5, 100,  50, NULL),
(5,  3,  50, NULL, NULL),
(6,  5, 100,  50, NULL),
(7, 10, 100, NULL, NULL),
(8, 10,  40, NULL, NULL),
(9, 10, 100, 100, NULL),
(10, 5, 100, 100, 100);


SELECT
  experience,
  COUNT(*) AS total_candidates,
  SUM(
    CASE
       WHEN (sql_score  IS NULL OR sql_score  = 100)
       AND (algo       IS NULL OR algo       = 100)
       AND (bug_fixing IS NULL OR bug_fixing = 100)
       THEN 1 ELSE 0
    END
  ) AS perfect_score_count
FROM assessments
GROUP BY experience
ORDER BY experience;
