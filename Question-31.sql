DROP TABLE IF EXISTS employee;

-- Schema
CREATE TABLE employee (
  emp_id     INT         PRIMARY KEY,
  salary     INT         NOT NULL,
  department VARCHAR(15) NOT NULL
);

-- Data from the image
INSERT INTO employee (emp_id, salary, department) VALUES
(100, 40000, 'Analytics'),
(101, 30000, 'Analytics'),
(102, 50000, 'Analytics'),
(103, 45000, 'Engineering'),
(104, 48000, 'Engineering'),
(105, 51000, 'Engineering'),
(106, 46000, 'Science'),
(107, 38000, 'Science'),
(108, 37000, 'Science'),
(109, 42000, 'Analytics'),
(110, 55000, 'Engineering');

-- Write an SQL to find list of employees who have salary greater than average employee salary of the 
-- company.  However, while calculating the company average salary to compare with an employee salary 
-- do not consider salaries of that employee's department, 
-- display the output in ascending order of employee ids.

SELECT e.emp_id 
FROM employee e
WHERE e.salary >( SELECT AVG(salary) FROM employee WHERE department <> e.department)
ORDER BY e.emp_id ASC;





