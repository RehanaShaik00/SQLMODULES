
DROP TABLE IF EXISTS promotions;
DROP TABLE IF EXISTS employees;

-- Employees
CREATE TABLE employees (
  id   INT PRIMARY KEY,
  name VARCHAR(50) NOT NULL
);

INSERT INTO employees (id, name) VALUES
(1,'Alice'),
(2,'Bob'),
(3,'Charlie'),
(4,'David'),
(5,'Eva'),
(6,'Frank'),
(7,'Grace'),
(8,'Hank'),
(9,'Ivy'),
(10,'Jack'),
(11,'Lily'),
(12,'Megan');

-- Promotions (an employee can have multiple promotions)
CREATE TABLE promotions (
  emp_id         INT NOT NULL,
  promotion_date DATE NOT NULL,
  PRIMARY KEY (emp_id, promotion_date)
);

-- Data as shown
INSERT INTO promotions (emp_id, promotion_date) VALUES
(1, '2025-04-13'),
(2, '2025-01-13'),
(3, '2024-07-13'),
(4, '2023-12-13'),
(5, '2023-10-13'),
(6, '2023-06-13'),
(6, '2024-12-13'),
(7, '2023-08-13'),
(7, '2022-12-13'),
(8, '2022-12-13'),
(9, '2024-04-13');

-- Employees NOT promoted in the last 1 year (show latest promotion if any)
SELECT
  e.id,
  e.name,
  p.latest_promotion_date
FROM employees e
LEFT JOIN (
  SELECT emp_id, MAX(promotion_date) AS latest_promotion_date
  FROM promotions
  GROUP BY emp_id
) p
  ON p.emp_id = e.id
WHERE p.latest_promotion_date IS NULL
   OR p.latest_promotion_date < (CURDATE() - INTERVAL 1 YEAR)
ORDER BY e.id;
