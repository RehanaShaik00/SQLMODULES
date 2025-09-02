DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS phones;

-- Tables
CREATE TABLE users (
  user_name      VARCHAR(10) NOT NULL,
  monthly_salary INT         NOT NULL,
  savings        INT         NOT NULL
);

CREATE TABLE phones (
  cost       INT         NOT NULL,
  phone_name VARCHAR(15) NOT NULL
);

-- Data (from the image)
INSERT INTO users (user_name, monthly_salary, savings) VALUES
('Rahul', 40000, 15000),
('Vivek', 70000, 10000);

INSERT INTO phones (cost, phone_name) VALUES
(60000, 'iphone-12'),
(50000, 'oneplus-12'),
(70000, 'iphone-14');

/*
an influential figure in Indian social media, 
shares a guideline in one of his videos called the 20-6-20 rule for determining whether 
one can afford to buy a phone or not. The rule for affordability entails three conditions:
1. Having enough savings to cover a 20 percent down payment.
2. Utilizing a maximum 6-month EMI plan (no-cost) for the remaining cost.
3. Monthly EMI should not exceed 20 percent of one's monthly salary.
Given the salary and savings of various users, along with data on phone costs,
 the task is to write an SQL to generate a list of phones (comma-separated) 
 that each user can afford based on these criteria, 
 display the output in ascending order of the user name.
*/

SELECT DISTINCT user_name,GROUP_CONCAT(phone_name)
FROM users u
JOIN phones p
WHERE savings>=(cost)*0.2
AND (cost*0.8)/6<=monthly_salary*0.2
GROUP BY user_name;