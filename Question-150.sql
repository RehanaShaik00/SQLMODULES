
DROP TABLE IF EXISTS promotions;
DROP TABLE IF EXISTS employees;

CREATE TABLE employees (
  id             INT PRIMARY KEY,
  name           VARCHAR(50) NOT NULL,
  joining_salary INT NOT NULL
);

INSERT INTO employees (id, name, joining_salary) VALUES
(1, 'Alice',   50000),
(2, 'Bob',     60000),
(3, 'Charlie', 70000),
(4, 'David',   55000),
(5, 'Eva',     65000),
(6, 'Frank',   48000),
(7, 'Grace',   72000),
(8, 'Henry',   51000);

CREATE TABLE promotions (
  emp_id           INT NOT NULL,
  promotion_date   DATE NOT NULL,
  percent_increase INT  NOT NULL,
  PRIMARY KEY (emp_id, promotion_date)
);

INSERT INTO promotions (emp_id, promotion_date, percent_increase) VALUES
(1, '2021-01-15', 10),
(1, '2022-03-20', 20),
(2, '2023-01-01',  5),
(2, '2024-01-01', 10),
(3, '2022-05-10',  5),
(3, '2023-07-01', 10),
(3, '2024-10-10',  5),
(4, '2021-09-21', 15),
(4, '2022-09-25', 15),
(4, '2023-09-01', 10),
(4, '2024-09-30', 15);

-- Current salary after compounding all promotions (MySQL 8+)
SELECT
  e.id,
  e.name,
  ROUND(
    e.joining_salary *
    COALESCE(EXP(SUM(LOG(1 + p.percent_increase/100))), 1),
    2
  ) AS current_salary
FROM employees e
LEFT JOIN promotions p
  ON p.emp_id = e.id
GROUP BY e.id, e.name, e.joining_salary
ORDER BY e.id;
