DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS income_tax_dates;

-- Master table of filing window per financial year
CREATE TABLE income_tax_dates (
  financial_year  VARCHAR(4),
  file_start_date DATE,
  file_due_date   DATE
);

-- User filings by year
CREATE TABLE users (
  user_id          INT,
  financial_year   VARCHAR(4),
  return_file_date DATE
);

-- Data: income_tax_dates
INSERT INTO income_tax_dates (financial_year, file_start_date, file_due_date) VALUES
('FY20', '2020-05-01', '2020-08-31'),
('FY21', '2021-06-01', '2021-09-30'),
('FY22', '2022-05-05', '2022-08-29'),
('FY23', '2023-05-05', '2023-08-31');

-- Data: users
INSERT INTO users (user_id, financial_year, return_file_date) VALUES
(1, 'FY20', '2020-05-10'),
(1, 'FY21', '2021-10-10'),
(1, 'FY23', '2023-08-20'),
(2, 'FY20', '2020-05-15'),
(2, 'FY21', '2021-09-10'),
(2, 'FY22', '2022-08-20'),
(2, 'FY23', '2023-10-10');

/*
write a query to identify users who either filed their income tax returns late or 
completely skipped filing for certain financial years.
A return is considered late if the return_file_date is after the file_due_date.
A return is considered missed if there is no entry for the user in the users table for a 
given financial year (i.e., the user did not file at all).
Your task is to generate a list of users along with the financial year 
for which they either filed late or missed filing, and 
also include a comment column specifying whether it is a 'late return' 
or 'missed'. The result should be sorted by financial year in ascending order.
*/

SELECT du.user_id,
	   d.financial_year,
       CASE WHEN return_file_date>file_due_Date THEN "late return"
            WHEN return_file_date IS NULL THEN "missed"  ELSE "on time return" END AS comments
FROM (SELECT DISTINCT user_id FROM users) du
JOIN income_tax_dates d ON 1=1
LEFT JOIN users f
  ON f.user_id = du.user_id
 AND f.financial_year = d.financial_year
ORDER BY d.financial_year ASC;
