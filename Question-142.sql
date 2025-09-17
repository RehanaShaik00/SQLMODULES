
DROP TABLE IF EXISTS employees;
CREATE TABLE employees (
  id         INT PRIMARY KEY,
  name       VARCHAR(50),
  department VARCHAR(50),
  salary     INT
);

-- Data (matches the screenshot)
INSERT INTO employees (id, name, department, salary) VALUES
(1 , 'Alice',   'Marketing',   80000),
(2 , 'Bob',     'Marketing',   60000),
(3 , 'Charlie', 'Marketing',   80000),
(4 , 'David',   'Marketing',   60000),
(5 , 'Eve',     'Engineering', 90000),
(6 , 'Frank',   'Engineering', 85000),
(7 , 'Grace',   'Engineering', 90000),
(8 , 'Hank',    'Engineering', 70000),
(9 , 'Ivy',     'HR',          50000),
(10, 'Jack',    'Finance',     95000),
(11, 'Kathy',   'Finance',     95000),
(12, 'Leo',     'Finance',     95000);

-- Difference between highest and second-highest salary per department
WITH uniq AS (
  SELECT DISTINCT department, salary
  FROM employees
),
ranked AS (
  SELECT
    department,
    salary,
    DENSE_RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS r
  FROM uniq
)
SELECT
  department AS department_name,
  CASE
    WHEN MAX(r) = 1 THEN NULL
    ELSE MAX(CASE WHEN r = 1 THEN salary END)
       - MAX(CASE WHEN r = 2 THEN salary END)
  END AS salary_difference
FROM ranked
GROUP BY department
ORDER BY department;
