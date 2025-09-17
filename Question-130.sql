-- Reset
DROP TABLE IF EXISTS emp_2020;
DROP TABLE IF EXISTS emp_2021;

-- Employees in 2020
CREATE TABLE emp_2020 (
  emp_id      INT PRIMARY KEY,
  designation VARCHAR(20)
);

INSERT INTO emp_2020 (emp_id, designation) VALUES
(1, 'Trainee'),
(2, 'Developer'),
(3, 'Developer'),
(4, 'Manager'),
(5, 'Trainee'),
(6, 'Developer');

-- Employees in 2021
CREATE TABLE emp_2021 (
  emp_id      INT PRIMARY KEY,
  designation VARCHAR(20)
);

INSERT INTO emp_2021 (emp_id, designation) VALUES
(1, 'Developer'),
(2, 'Developer'),
(3, 'Manager'),
(5, 'Trainee'),
(6, 'Developer'),
(7, 'Manager');

/*
You work in the Human Resources (HR) department of a growing company that tracks the status of its 
employees year over year. The company needs to analyze employee status changes between two 
consecutive years: 2020 and 2021.
The company's HR system has two separate tables of employees for the years 2020 and 2021, 
which include each employee's unique identifier (emp_id) and their corresponding designation (role) 
within the organization.
The task is to track how the designations of employees have changed over the year. 
Specifically, you are required to identify the following changes:

Promoted: If an employee's designation has changed (e.g., from Trainee to Developer, or from Developer to Manager).
Resigned: If an employee was present in 2020 but has left the company by 2021.
New Hire: If an employee was hired in 2021 but was not present in 2020.
Assume that employees can only be promoted and cannot be demoted.
*/

WITH joined AS (
  SELECT e20.emp_id, e20.designation AS d2020, e21.designation AS d2021
  FROM emp_2020 e20
  LEFT JOIN emp_2021 e21 
  ON e21.emp_id = e20.emp_id

  UNION ALL

  SELECT e21.emp_id, e20.designation AS d2020, e21.designation AS d2021
  FROM emp_2021 e21
  LEFT JOIN emp_2020 e20 
  ON e20.emp_id = e21.emp_id
  WHERE e20.emp_id IS NULL
)
SELECT
  emp_id,
  CASE
    WHEN d2020 IS NULL THEN 'New Hire'
    WHEN d2021 IS NULL THEN 'Resigned'
    WHEN d2020 <> d2021 THEN 'Promoted'
    ELSE 'No Change'
  END AS status,
  d2020 AS designation_2020,
  d2021 AS designation_2021
FROM joined
ORDER BY emp_id;
