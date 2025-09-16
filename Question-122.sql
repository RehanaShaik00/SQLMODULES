DROP TABLE IF EXISTS employees;

CREATE TABLE employees (
  employee_id   INT PRIMARY KEY,
  department_id INT,
  salary        INT
);

INSERT INTO employees (employee_id, department_id, salary) VALUES
(1,  1,  5000),
(2,  1,  4000),
(3,  1,  3000),
(4,  2,  5000),
(5,  3,  3500),
(6,  3,  4000),
(7,  3,  3000),
(8,  3,  5000),
(9,  4,  5000),
(10, 4, 10000),
(11, 5,  3000),
(12, 5,  4200);

SELECT
  department_id,
  MAX(CASE WHEN ths = 3 THEN salary END) AS third_highest_salary
FROM (
  SELECT
    department_id,
    salary,
    DENSE_RANK() OVER (PARTITION BY department_id ORDER BY salary DESC) AS ths
  FROM employees
) t
GROUP BY department_id
ORDER BY department_id;