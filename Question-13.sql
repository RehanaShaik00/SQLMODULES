DROP TABLE IF EXISTS projects;
CREATE TABLE projects (
  project_id              INT PRIMARY KEY,
  employee_name           VARCHAR(10) NOT NULL,
  project_completion_date DATE NOT NULL
);

-- Sample data
-- Dec 2022
INSERT INTO projects VALUES
(100, 'Ankit',  '2022-12-15');

-- Jan 2023 (Shilpa leads this month)
INSERT INTO projects VALUES
(101, 'Shilpa', '2023-01-03'),
(102, 'Shilpa', '2023-01-15'),
(103, 'Shilpa', '2023-01-22'),
(104, 'Rahul',  '2023-01-05'),
(105, 'Rahul',  '2023-01-12'),
(106, 'Mukesh', '2023-01-23');

-- Feb 2023 (tie between Mukesh & Rahul)
INSERT INTO projects VALUES
(108, 'Mukesh', '2023-02-04'),
(109, 'Rahul',  '2023-02-10'),
(110, 'Rahul',  '2023-02-18'),
(111, 'Shilpa', '2023-02-20'),
(112, 'Ankit',  '2023-02-25'),
(113, 'Mukesh', '2023-02-28');

-- Mar 2023 (tie between Shilpa & Ankit)
INSERT INTO projects VALUES
(114, 'Shilpa', '2023-03-05'),
(115, 'Shilpa', '2023-03-08'),
(116, 'Shilpa', '2023-03-11'),
(117, 'Mukesh', '2023-03-14'),
(118, 'Ankit',  '2023-03-16'),
(119, 'Ankit',  '2023-03-20'),
(120, 'Rahul',  '2023-03-25'),
(121, 'Ankit',  '2023-03-28');
/*TCS wants to award employees based on number of projects completed by each individual each month.
  Write an SQL to find best employee for each month along with number of projects completed by him/her
  in that month, display the output in descending order of number of completed projects.
Table: projects*/

SELECT p1.employee_name,MONTH(project_completion_Date) as monthnum,COUNT(project_id) as projcount
FROM projects P1
GROUP BY p1.employee_name,MONTH(project_completion_Date)
HAVING COUNT(p1.project_id) IN (SELECT MAX(proj) FROM (SELECT p2.employee_name,MONTH(project_completion_Date) as monthno,COUNT(project_id) as proj FROM projects  p2
                            GROUP BY p2.employee_name,monthno) as a
                            WHERE monthno= monthnum);
