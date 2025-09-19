
DROP TABLE IF EXISTS revenue;
CREATE TABLE revenue (
  company_id INT NOT NULL,
  year       INT NOT NULL,
  revenue    DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (company_id, year)
);

INSERT INTO revenue (company_id, year, revenue) VALUES
(1, 2018, 100000.00),
(1, 2019, 125000.00),
(1, 2020, 156250.00),
(1, 2021, 200000.00),
(1, 2022, 260000.00),
(2, 2018,  80000.00),
(2, 2019, 100000.00),
(2, 2020, 130000.00),
(2, 2021, 156000.00);

SELECT
  r.company_id,
  ROUND(SUM(r.revenue), 2) AS lifetime_revenue
FROM revenue r
LEFT JOIN revenue p
  ON p.company_id = r.company_id
 AND p.year       = r.year - 1                
GROUP BY r.company_id
HAVING
  SUM(p.company_id IS NOT NULL) = COUNT(*) - 1
  AND SUM(p.company_id IS NOT NULL AND r.revenue >= 1.25 * p.revenue) = COUNT(*) - 1
ORDER BY r.company_id;
