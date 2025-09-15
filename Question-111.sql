-- Start fresh
DROP TABLE IF EXISTS module.hierarchy;

-- Employee-manager mapping (letters as IDs)
CREATE TABLE hierarchy (
  e_id VARCHAR(1),
  m_id VARCHAR(1)
);

-- Data from the screenshot
INSERT INTO hierarchy (e_id, m_id) VALUES
('A','C'),
('B','C'),
('C','F'),
('D','E'),
('E','F'),
('G','E'),
('H','G'),
('I','F'),
('J','I'),
('K','I');

/*
Write a SQL query to find the number of reportees (both direct and indirect) under each manager. 
The output should include:
m_id: The manager ID.
num_of_reportees: The total number of unique reportees (both direct and indirect) under that manager.
Order the result by number of reportees in descending order.
*/

-- All direct + indirect reportees per manager
WITH RECURSIVE org AS (
  -- direct edges
  SELECT m_id AS manager, e_id AS emp
  FROM hierarchy
  UNION ALL
  SELECT o.manager, h.e_id
  FROM org o
  JOIN hierarchy h
    ON h.m_id = o.emp
)
SELECT
  manager AS m_id,
  COUNT(DISTINCT emp) AS num_of_reportees
FROM org
GROUP BY manager
ORDER BY num_of_reportees DESC, m_id;


