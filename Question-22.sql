DROP TABLE IF EXISTS survey;

-- Schema exactly as given
CREATE TABLE survey (
  country          VARCHAR(20),
  job_satisfaction INT,
  name             VARCHAR(10)
);

-- Sample data (USA-only respondents, but with messy country spellings)
INSERT INTO survey (country, job_satisfaction, name) VALUES
-- Rating 1 (mode should be 'US')
('US',              1, 'Ava'),
('US',              1, 'Liam'),
('USA',             1, 'Mia'),
('United States',   1, 'Noah'),
('U.S.A.',          1, 'Ivy'),

-- Rating 2 (mode should be 'United States')
('United States',   2, 'Zoe'),
('United States',   2, 'Owen'),
('US',              2, 'Ian'),
('USA',             2, 'Amy'),
('United States',   2, 'Max'),

-- Rating 3 (mode should be 'USA')
('USA',             3, 'Eli'),
('USA',             3, 'Nia'),
('United States',   3, 'Leo'),
('US',              3, 'Gia'),
('USA',             3, 'Kai'),

-- Rating 4 (mode should be 'United States')
('United States',   4, 'Ben'),
('United States',   4, 'Joy'),
('USA',             4, 'Ari'),
('US',              4, 'Eva'),
('United States',   4, 'Roy'),

-- Rating 5 (mode should be 'USA')
('USA',             5, 'Ada'),
('USA',             5, 'Sam'),
('USA',             5, 'Ira'),
('United States',   5, 'Tia'),
('US',              5, 'Jax');

/*
In some poorly designed UI applications, there's often a lack of data input restrictions.
For instance, in a free text field for the country, users might input variations such as 'USA,' 
'United States of America,' or 'US.'
Suppose we have survey data from individuals in the USA about their job satisfaction,
rated on a scale of 1 to 5. 
Write a SQL query to count the number of respondents for each rating on the scale.
Additionally, include the country name in the format that occurs most frequently in that scale,
display the output in ascending order of job satisfaction.
*/

SELECT
  s.job_satisfaction,
  COUNT(*) AS respondent_count,
  (
    SELECT s2.country
    FROM survey AS s2
    WHERE s2.job_satisfaction = s.job_satisfaction
    GROUP BY s2.country
    ORDER BY COUNT(*) DESC, s2.country ASC   -- tie-break alphabetically
    LIMIT 1
  ) AS country_mode
FROM survey AS s
GROUP BY s.job_satisfaction
ORDER BY s.job_satisfaction;
