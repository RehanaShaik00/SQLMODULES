
DROP TABLE IF EXISTS daily_time;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS dept;

CREATE TABLE dept (
  dept_id     INT PRIMARY KEY,
  hourly_rate INT NOT NULL
);

INSERT INTO dept (dept_id, hourly_rate) VALUES
(10, 10),
(20, 12),
(30, 15);

CREATE TABLE employees (
  emp_id   INT PRIMARY KEY,
  emp_name VARCHAR(20) NOT NULL,
  dept_id  INT NOT NULL,
  FOREIGN KEY (dept_id) REFERENCES dept(dept_id)
);

INSERT INTO employees (emp_id, emp_name, dept_id) VALUES
(1, 'Alice',   10),
(2, 'Bob',     10),
(3, 'Charlie', 20),
(4, 'David',   20),
(5, 'Eve',     30);

CREATE TABLE daily_time (
  emp_id     INT NOT NULL,
  entry_time DATETIME NOT NULL,
  exit_time  DATETIME NOT NULL,
  KEY(emp_id),
  FOREIGN KEY (emp_id) REFERENCES employees(emp_id)
);

INSERT INTO daily_time (emp_id, entry_time, exit_time) VALUES
(1, '2023-01-01 09:00:00', '2023-01-01 17:00:00'),
(2, '2023-01-01 08:00:00', '2023-01-01 15:00:00'),
(3, '2023-01-01 08:30:00', '2023-01-01 18:30:00'),
(4, '2023-01-01 09:00:00', '2023-01-01 16:00:00'),
(5, '2023-01-01 08:00:00', '2023-01-01 18:00:00');


SELECT
  e.emp_id,
  e.emp_name,
  ROUND(
    SUM(
      d.hourly_rate * LEAST(TIMESTAMPDIFF(MINUTE, dt.entry_time, dt.exit_time)/60.0, 8) +
      d.hourly_rate * 1.5 * GREATEST(TIMESTAMPDIFF(MINUTE, dt.entry_time, dt.exit_time)/60.0 - 8, 0)
    ), 2
  ) AS total_payout
FROM daily_time dt
JOIN employees e ON e.emp_id = dt.emp_id
JOIN dept d ON d.dept_id = e.dept_id
GROUP BY e.emp_id, e.emp_name
ORDER BY total_payout DESC;

