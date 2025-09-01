CREATE TABLE business_operations (
  business_date DATE NOT NULL,
  city_id       INT  NOT NULL
);       

INSERT INTO business_operations (business_date, city_id) VALUES
('2020-01-02', 3),
('2020-02-10', 3),
('2020-07-01', 7),
('2020-12-31', 7),

('2021-01-01', 3),
('2021-02-03', 19),
('2021-06-15', 7),
('2021-12-25', 19),

('2022-02-28', 12),
('2022-12-01', 3),
('2022-12-15', 3),

('2023-03-01', 25),
('2023-11-20', 42),
('2023-12-31', 12),

('2024-01-15', 9),
('2024-05-05', 25),

('2025-04-12', 77),
('2025-04-13', 3);                 

-- Write a SQL to find year wise number of new cities added to the business, 
-- display the output in increasing order of year.

SELECT YEAR(first_date),COUNT(*)
FROM (SELECT city_id, MIN(business_date) AS first_date
FROM business_operations
GROUP BY city_id) as t
GROUP BY YEAR(first_date)
ORDER BY YEAR(first_date);