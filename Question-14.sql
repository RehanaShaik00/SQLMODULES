DROP TABLE IF EXISTS employees;
CREATE TABLE employees (
  emp_id INT,
  login  DATETIME,
  logout DATETIME
);

INSERT INTO employees (emp_id, login, logout) VALUES
(100, '2024-02-19 09:15:00', '2024-02-19 18:20:00'),
(100, '2024-02-20 09:05:00', '2024-02-20 17:00:00'),
(100, '2024-02-21 09:00:00', '2024-02-21 17:10:00'),
(100, '2024-02-22 10:00:00', '2024-02-22 16:55:00'),
(100, '2024-02-23 10:30:00', '2024-02-23 19:15:00'),
(200, '2024-02-19 08:00:00', '2024-02-19 18:20:00'),
(200, '2024-02-20 09:00:00', '2024-02-20 16:30:00');

/*
Workaholics employees are those who satisfy at least one of the given criterions:
1- Worked for more than 8 hours a day for at least 3 days in a week. 
2- worked for more than 10 hours a day for at least 2 days in a week. 
You are given the login and logout timings of all the employees for a given week. 
Write a SQL to find all the workaholic employees along with the criterion that they are satisfying 
(1,2 or both), display it in the order of increasing employee id
*/

SELECT
  emp_id,
  SUM(HOUR(TIMEDIFF(logout, login)) >= 8)                 AS days_ge_8h,
  SUM(HOUR(TIMEDIFF(logout, login)) >= 10)                AS days_ge_10h
FROM employees
GROUP BY emp_id
HAVING days_ge_8h >= 3 OR days_ge_10h >= 2 OR (days_ge_8h >= 3 AND days_ge_10h >= 2)
ORDER BY emp_id;
