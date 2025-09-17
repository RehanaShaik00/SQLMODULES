-- Reset
DROP TABLE IF EXISTS employees;

-- One table with both 2020 and 2021 records
CREATE TABLE employees (
  emp_id      INT,
  year        INT,
  designation VARCHAR(20)
);

-- Data from the screenshot
INSERT INTO employees (emp_id, year, designation) VALUES
-- 2020
(1, 2020, 'Trainee'),
(2, 2020, 'Developer'),
(3, 2020, 'Developer'),
(4, 2020, 'Manager'),
(5, 2020, 'Trainee'),
(6, 2020, 'Developer'),
-- 2021
(1, 2021, 'Developer'),
(2, 2021, 'Developer'),
(3, 2021, 'Manager'),
(5, 2021, 'Trainee'),
(6, 2021, 'Developer');

/*
You work in the Human Resources (HR) department of a growing company that tracks the status of its 
employees year over year. The company needs to analyze employee status changes between two consecutive 
years: 2020 and 2021.
The company's HR system has two separate records of employees for the years 2020 and 2021 in the same 
table, which include each employee's unique identifier (emp_id) and their corresponding designation 
(role) within the organization for each year.
The task is to track how the designations of employees have changed over the year. 
Specifically, you are required to identify the following changes:
Promoted: If an employee's designation has changed (e.g., from Trainee to Developer, or from Developer to Manager).
Resigned: If an employee was present in 2020 but has left the company by 2021.
New Hire: If an employee was hired in 2021 but was not present in 2020.
Assume that employees can only be promoted and cannot be demoted.
*/

WITH by_emp AS (
  SELECT
    emp_id,
    MAX(CASE WHEN year = 2020 THEN designation END) AS d2020,
    MAX(CASE WHEN year = 2021 THEN designation END) AS d2021
  FROM employees
  WHERE year IN (2020, 2021)
  GROUP BY emp_id
)
SELECT
  emp_id,
  d2020  AS designation_2020,
  d2021  AS designation_2021,
  CASE
    WHEN d2020 IS NULL THEN 'New Hire'
    WHEN d2021 IS NULL THEN 'Resigned'
    WHEN d2020 <> d2021 THEN 'Promoted'
    ELSE 'No Change'
  END AS status
FROM by_emp
ORDER BY emp_id;