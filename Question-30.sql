DROP TABLE IF EXISTS Employees;

-- Table
CREATE TABLE Employees (
  employee_id    INT,
  employee_name  VARCHAR(20),
  salary         INT
);

-- Data (as shown)
INSERT INTO Employees (employee_id, employee_name, salary) VALUES
(1 , 'John Doe',         45000),
(2 , 'Jane Smith',       60000),
(3 , 'Michael Johnson', 100000),
(4 , 'Emily Brown',      75000),
(5 , 'Christopher Lee',  48000),
(6 , 'Amanda Wilson',    90000),
(7 , 'Ankit Bansal',    110000),
(8 , 'Sarah Davis',      50000),
(9 , 'David Martinez',   85000),
(10, 'James Anderson',   95000),
(11, 'Patricia Thomas',  68000);
/*
Write an SQL query to find the average salaries of employees at each salary level. 
"Salary Level" are defined as per below conditions:
If the salary is less than 50000, label it as "Low".
If the salary is between 50000 and 100000 (inclusive), label it as "Medium".
If the salary is greater than 100000, label it as "High".
Round the average to nearest integer. Display the output in ascending order of salary level.
*/
SELECT CASE WHEN salary<50000 THEN "Low" 
			 WHEN salary BETWEEN 50000 AND 100000 THEN "Medium"
             WHEN salary>100000 THEN "High"
		END AS salarylevel,
        ROUND(AVG(salary))
FROM employees
GROUP BY salarylevel
ORDER BY salarylevel ASC;