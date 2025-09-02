DROP TABLE IF EXISTS employee;

-- Schema
CREATE TABLE employee (
  emp_id       INT         PRIMARY KEY,
  emp_name     VARCHAR(10) NOT NULL,
  joining_date DATE        NOT NULL,
  salary       INT         NOT NULL,
  manager_id   INT         NULL  -- refers to employee.emp_id
  -- (FK omitted to keep insert order simple)
);

-- Data from the image
INSERT INTO employee (emp_id, emp_name, joining_date, salary, manager_id) VALUES
(1 , 'Ankit' , '2021-01-01', 10000, 4),
(2 , 'Mohit' , '2022-05-01', 15000, 5),
(3 , 'Vikas' , '2023-06-01', 10000, 4),
(4 , 'Rohit' , '2022-02-01',  5000, 2),
(5 , 'Mudit' , '2021-03-01', 12000, 6),
(6 , 'Agam'  , '2024-02-01', 12000, 2),
(7 , 'Sanjay', '2024-02-21',  9000, 2),
(8 , 'Ashish', '2023-01-05',  5000, 2),
(9 , 'Mukesh', '2020-02-03',  6000, 6),
(10, 'Rakesh', '2022-08-01',  7000, 6);

/*You are given the table of employee details.
 Write an SQL to find details of employee with salary more than their manager salary
 but they joined the company after the manager joined.
Display employee name, salary and joining date along with their manager's salary 
and joining date, sort the output in ascending order of employee name.
Please note that manager id in the employee table referring to emp id of the same table.*/

 SELECT e.emp_name,e.salary,e.joining_Date,m.salary,m.joining_date
 FROM employee e 
JOIN employee m
 -- ON e.emp_id = m.manager_id
 ON m.emp_id = e.manager_id
 WHERE e.salary>m.salary
 AND e.joining_date > m.joining_date
 ORDER BY e.emp_name ASC;