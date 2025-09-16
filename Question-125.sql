-- Start fresh
DROP TABLE IF EXISTS project_employees;
DROP TABLE IF EXISTS projects;
DROP TABLE IF EXISTS employees;

-- Employees
CREATE TABLE employees (
  id     INT PRIMARY KEY,
  name   VARCHAR(40),
  salary INT            -- annual salary
);

INSERT INTO employees (id, name, salary) VALUES
(1,'Alice',   100000),
(2,'Bob',     120000),
(3,'Charlie',  90000),
(4,'David',   110000),
(5,'Eva',      95000),
(6,'Frank',   105000),
(7,'Grace',    98000),
(8,'Helen',   115000);

-- Projects
CREATE TABLE projects (
  id         INT PRIMARY KEY,
  title      VARCHAR(60),
  start_date DATE,
  end_date   DATE,
  budget     INT
);

INSERT INTO projects (id, title, start_date, end_date, budget) VALUES
(1, 'Website Redesign',  '2024-01-15', '2024-07-15',  50000),
(2, 'App Development',   '2024-02-01', '2024-05-31', 100000),
(3, 'Cloud Migration',   '2024-03-01', '2024-04-30',  20000),
(4, 'Analytics Platform','2024-05-05', '2024-08-05',  80000);

-- Project ↔ Employees
CREATE TABLE project_employees (
  project_id  INT,
  employee_id INT
);

INSERT INTO project_employees (project_id, employee_id) VALUES
(1,1),
(2,2),
(2,3),
(2,4),
(3,5),
(3,6),
(3,7),
(3,8),
(4,6),
(4,7);

SELECT
  p.title,
  p.budget,
  ROUND(SUM(e.salary) * (DATEDIFF(p.end_date, p.start_date) + 1) / 365.0, 2) AS forecast_cost,
  CASE
    WHEN SUM(e.salary) * (DATEDIFF(p.end_date, p.start_date) + 1) / 365.0 > p.budget
      THEN 'overbudget'
    ELSE 'within budget'
  END AS status
FROM projects p
JOIN project_employees pe ON pe.project_id = p.id
JOIN employees e          ON e.id = pe.employee_id
GROUP BY p.id, p.title, p.start_date, p.end_date, p.budget
ORDER BY p.title;