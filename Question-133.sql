-- Start fresh
DROP TABLE IF EXISTS projects;

CREATE TABLE projects (
  id             INT PRIMARY KEY,
  project_number INT,
  source_system  VARCHAR(20)
);

-- Sample data from the screenshot
INSERT INTO projects (id, project_number, source_system) VALUES
(1 , 1001, 'EagleEye'),
(2 , 1001, 'SwiftLink'),
(3 , 1001, 'DataVault'),
(4 , 1002, 'SwiftLink'),
(5 , 1003, 'DataVault'),
(6 , 1004, 'EagleEye'),
(7 , 1004, 'SwiftLink'),
(8 , 1005, 'DataVault'),
(9 , 1005, 'EagleEye'),
(10, 1006, 'EagleEye'),
(11, 1007, 'DataVault');

SELECT id, project_number, source_system
FROM (
  SELECT p.*,
         ROW_NUMBER() OVER (
           PARTITION BY project_number
           ORDER BY CASE source_system
                      WHEN 'EagleEye' THEN 1
                      WHEN 'SwiftLink' THEN 2
                      ELSE 3
                    END, id
         ) AS rn
  FROM projects p
) t
WHERE rn = 1
ORDER BY project_number;