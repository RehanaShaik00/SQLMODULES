
DROP TABLE IF EXISTS salary;
DROP TABLE IF EXISTS employee;

-- Employees (as in the image)
CREATE TABLE employee (
  emp_id    INT PRIMARY KEY,
  emp_name  VARCHAR(20) NOT NULL,
  job_title VARCHAR(20) NOT NULL
);

INSERT INTO employee (emp_id, emp_name, job_title) VALUES
(1,  'John Doe',        'Software Engineer'),
(2,  'Jane Smith',      'Software Engineer'),
(3,  'Michael Johnson', 'Software Engineer'),
(4,  'Emily Brown',     'Software Engineer'),
(5,  'David Lee',       'Software Engineer'),
(6,  'Sarah Jones',     'Software Engineer'),
(7,  'Kevin Davis',     'Software Engineer'),
(8,  'Emma Wilson',     'Software Engineer'),
(9,  'Matthew Taylor',  'Software Engineer'),
(10, 'Olivia Martinez', 'Software Engineer'),
(11, 'Liam Miller',     'Data Scientist');

-- Salary components
CREATE TABLE salary (
  emp_id        INT PRIMARY KEY,
  base_pay      INT NOT NULL,
  overtime_pay  INT NOT NULL,
  other_pay     INT NOT NULL,
  FOREIGN KEY (emp_id) REFERENCES employee(emp_id)
);

INSERT INTO salary (emp_id, base_pay, overtime_pay, other_pay) VALUES
(1,  120000, 10000, 15000),  -- total 145000
(2,  110000,  8000, 20000),  -- 138000
(3,  130000, 10000, 20000),  -- 160000  (top 3)
(4,  118000, 12000, 20000),  -- 150000  (above avg, not top 3)
(5,  115000,  7000, 20000),  -- 142000
(6,  105000, 10000, 20000),  -- 135000
(7,  125000, 10000, 20000),  -- 155000  (top 3)
(8,  116000, 12000, 20000),  -- 148000  (above avg, not top 3)
(9,  112000,  8000, 20000),  -- 140000
(10, 122000, 10000, 20000),  -- 152000  (top 3)
(11, 140000, 10000, 20000);  -- 170000 (Data Scientist)

-- Above-average in title but NOT top 3 (ties by higher base pay)
SELECT emp_id, emp_name, job_title, total_salary
FROM (
  SELECT
    e.emp_id, e.emp_name, e.job_title,
    s.base_pay,
    (s.base_pay + s.overtime_pay + s.other_pay) AS total_salary,
    AVG(s.base_pay + s.overtime_pay + s.other_pay)
      OVER (PARTITION BY e.job_title) AS avg_title_salary,
    ROW_NUMBER() OVER (
      PARTITION BY e.job_title
      ORDER BY (s.base_pay + s.overtime_pay + s.other_pay) DESC, s.base_pay DESC
    ) AS rnk
  FROM employee e
  JOIN salary s USING (emp_id)
) t
WHERE total_salary > avg_title_salary
  AND rnk > 3
ORDER BY total_salary DESC;
