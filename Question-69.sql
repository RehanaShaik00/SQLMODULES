
DROP TABLE IF EXISTS country_data;

-- Country indicators table
CREATE TABLE country_data (
  country_name    VARCHAR(15) NOT NULL,
  indicator_name  VARCHAR(25) NOT NULL,
  year_2010       DECIMAL(3,2) NOT NULL,
  year_2011       DECIMAL(3,2) NOT NULL,
  year_2012       DECIMAL(3,2) NOT NULL,
  year_2013       DECIMAL(3,2) NOT NULL,
  year_2014       DECIMAL(3,2) NOT NULL
);


INSERT INTO country_data
(country_name, indicator_name, year_2010, year_2011, year_2012, year_2013, year_2014) VALUES
('United States','Control of Corruption',    1.26, 1.51, 1.52, 1.55, 1.58),
('United States','Government Effectiveness', 1.27, 1.45, 1.28, 1.50, 1.47),
('United States','Regulatory Quality',       1.28, 1.63, 1.63, 1.66, 1.67),
('United States','Rule of Law',              1.32, 1.61, 1.60, 1.62, 1.64),
('United States','Voice and Accountability', 1.30, 1.11, 1.13, 1.20, 1.25),
('Canada','Control of Corruption',           1.46, 1.61, 1.71, 1.70, 1.73),
('Canada','Government Effectiveness',        1.47, 1.55, 1.38, 1.50, 1.52),
('Canada','Regulatory Quality',              1.38, 1.73, 1.63, 1.68, 1.70),
('Canada','Rule of Law',                     1.42, 1.71, 1.80, 1.76, 1.79),
('Canada','Voice and Accountability',        1.40, 1.19, 1.21, 1.22, 1.25);

-- Lowest year/value per country & indicator (MySQL 8+)
WITH unp AS (
  SELECT country_name, indicator_name, 2010 AS yr, year_2010 AS val FROM country_data
  UNION ALL SELECT country_name, indicator_name, 2011, year_2011 FROM country_data
  UNION ALL SELECT country_name, indicator_name, 2012, year_2012 FROM country_data
  UNION ALL SELECT country_name, indicator_name, 2013, year_2013 FROM country_data
  UNION ALL SELECT country_name, indicator_name, 2014, year_2014 FROM country_data
),
r AS (
  SELECT *,
         ROW_NUMBER() OVER (
           PARTITION BY country_name, indicator_name
           ORDER BY val ASC, yr ASC
         ) AS rn
  FROM unp
)
SELECT
  country_name,
  indicator_name,
  yr  AS min_year,
  val AS indicator_value
FROM r
WHERE rn = 1
ORDER BY country_name, indicator_name;
