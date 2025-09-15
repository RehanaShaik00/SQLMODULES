DROP TABLE IF EXISTS covid_tests;

CREATE TABLE covid_tests (
  name        VARCHAR(10),
  id          INT PRIMARY KEY,
  age         INT,
  corad_score INT
);

INSERT INTO covid_tests (name,id,age,corad_score) VALUES
('Aarav',1,25,-1),
('Vivaan',2,30,3),
('Aditya',3,42,6),
('Vihaan',4,21,-1),
('Arjun',5,38,5),
('Kabir',6,48,7),
('Rohan',7,29,-1),
('Sai',8,56,9),
('Krishna',9,33,4),
('Siddharth',10,44,2),
('Isha',11,24,-1),
('Nisha',12,37,5);

SELECT
  CASE
    WHEN age BETWEEN 18 AND 30 THEN '18-30'
    WHEN age BETWEEN 31 AND 45 THEN '31-45'
    WHEN age BETWEEN 46 AND 60 THEN '46-60'
  END AS age_group,
  SUM(CASE WHEN corad_score = -1 THEN 1 ELSE 0 END) AS count_negative,
  SUM(CASE WHEN corad_score BETWEEN 2 AND 5 THEN 1 ELSE 0 END) AS count_mild,
  SUM(CASE WHEN corad_score BETWEEN 6 AND 10 THEN 1 ELSE 0 END) AS count_serious
FROM covid_tests
WHERE age BETWEEN 18 AND 60
GROUP BY age_group
ORDER BY CASE age_group WHEN '18-30' THEN 1 WHEN '31-45' THEN 2 ELSE 3 END;
