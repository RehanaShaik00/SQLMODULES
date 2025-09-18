
DROP TABLE IF EXISTS candidates;
CREATE TABLE candidates (
  emp_id     INT PRIMARY KEY,
  experience VARCHAR(6) NOT NULL,  -- 'Senior' or 'Junior'
  salary     INT NOT NULL
);

INSERT INTO candidates (emp_id, experience, salary) VALUES
(1, 'Junior', 10000),
(2, 'Junior', 15000),
(3, 'Junior', 40000),
(4, 'Senior', 16000),
(5, 'Senior', 20000),
(6, 'Senior', 50000);


WITH seniors AS (
  SELECT emp_id, experience, salary,
         SUM(salary) OVER (ORDER BY salary, emp_id) AS run
  FROM candidates
  WHERE experience = 'Senior'
),
picked_seniors AS (
  SELECT emp_id, experience, salary
  FROM seniors
  WHERE run <= 70000
),
left_budget AS (
  SELECT 70000 - COALESCE(SUM(salary),0) AS rem FROM picked_seniors
),
juniors AS (
  SELECT emp_id, experience, salary,
         SUM(salary) OVER (ORDER BY salary, emp_id) AS run
  FROM candidates
  WHERE experience = 'Junior'
),
picked_juniors AS (
  SELECT j.emp_id, j.experience, j.salary
  FROM juniors j
  CROSS JOIN left_budget b
  WHERE j.run <= b.rem
)
SELECT * FROM picked_seniors
UNION ALL
SELECT * FROM picked_juniors
ORDER BY salary DESC;
