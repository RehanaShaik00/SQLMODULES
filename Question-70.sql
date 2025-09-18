

DROP TABLE IF EXISTS employee;
CREATE TABLE employee (
  employeeid INT PRIMARY KEY,
  fullname   VARCHAR(50) NOT NULL
);

INSERT INTO employee VALUES
(1,'Doe,John Michael'),
(2,'Smith,Alice'),
(3,'Johnson,Robert Lee'),
(4,'Alex'),
(5,'White,Sarah');

-- Split fullname → first / middle / last (3 formats handled)
SELECT
  e.employeeid,
  TRIM(SUBSTRING_INDEX(rest, ' ', 1))                                           AS first_name,
  CASE WHEN rest LIKE '% %' THEN TRIM(SUBSTRING(rest, LOCATE(' ', rest)+1)) END AS middle_name,
  CASE WHEN fullname LIKE '%,%' THEN TRIM(SUBSTRING_INDEX(fullname, ',', 1)) END AS last_name
FROM (
  SELECT employeeid, fullname,
         TRIM(SUBSTRING_INDEX(fullname, ',', -1)) AS rest   -- part after comma or whole string
  FROM employee
) e
ORDER BY employeeid;
