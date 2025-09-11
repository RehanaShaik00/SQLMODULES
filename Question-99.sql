-- Clean start
DROP TABLE IF EXISTS entries;

CREATE TABLE entries (
  emp_name  VARCHAR(10) NOT NULL,
  address   VARCHAR(10) NOT NULL,
  floor     INT NOT NULL,
  resources VARCHAR(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO entries (emp_name, address, floor, resources) VALUES
  ('Ankit' , 'Bangalore', 1, 'CPU'),
  ('Ankit' , 'Bangalore', 1, 'CPU'),
  ('Ankit' , 'Bangalore', 2, 'DESKTOP'),
  ('Bikaas', 'Bangalore', 2, 'DESKTOP'),
  ('Bikaas', 'Bangalore', 2, 'DESKTOP'),
  ('Bikaas', 'Bangalore', 1, 'MONITOR');

-- Optional peek
-- SELECT * FROM entries ORDER BY emp_name, floor, resources;
/*
You are a facilities manager at a corporate office building, 
responsible for tracking employee visits, floor preferences, 
and resource usage within the premises. The office building has multiple floors, 
each equipped with various resources such as desks, computers, monitors, 
and other office supplies. You have a database table “entries” that stores information 
about employee visits to the office building. Each record in the table represents 
a visit by an employee and includes details such as their name, the floor they visited, 
and the resources they used during their visit.
Write an SQL query to retrieve the total visits, most visited floor, 
and resources used by each employee, display the output in ascending order of employee name.
*/
SELECT e.emp_name,
	   COUNT(e.floor),
       GROUP_CONCAT(DISTINCT e.resources),
       (
			SELECT t.floor
			FROM entries AS t
			WHERE t.emp_name = e.emp_name
			GROUP BY t.floor
			ORDER BY COUNT(floor) DESC, t.floor ASC
			LIMIT 1
  ) AS most_visited_floor
FROM entries e
GROUP BY emp_name
ORDER BY emp_name;

