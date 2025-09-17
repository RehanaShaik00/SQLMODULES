
DROP TABLE IF EXISTS sales;
CREATE TABLE sales (
  id          INT PRIMARY KEY,
  product_id  INT NOT NULL,
  sale_date   DATE NOT NULL,
  sale_amount INT  NOT NULL
);

INSERT INTO sales (id, product_id, sale_date, sale_amount) VALUES
(1 ,101,'2025-03-05', 500),
(2 ,101,'2025-03-15', 700),
(3 ,101,'2025-03-25', 600),
(4 ,101,'2025-04-04', 400),
(5 ,101,'2025-04-14', 300),
(6 ,101,'2025-05-14', 900),
(7 ,101,'2025-05-24', 850),
(8 ,101,'2025-05-29', 700),
(9 ,101,'2025-06-03', 950),
(10,101,'2025-06-08',1100),
(11,102,'2025-03-05', 800),
(12,102,'2025-03-15', 850);

SELECT
  product_id,
  SUM(CASE
        WHEN sale_date >= DATE_ADD(MAKEDATE(YEAR(CURDATE()),1), INTERVAL (QUARTER(CURDATE())-2)*3 MONTH)
         AND sale_date <  DATE_ADD(MAKEDATE(YEAR(CURDATE()),1), INTERVAL (QUARTER(CURDATE())-1)*3 MONTH)
        THEN sale_amount ELSE 0 END) AS last_quarter_sales,
  SUM(CASE
        WHEN sale_date >= DATE_ADD(MAKEDATE(YEAR(CURDATE()),1), INTERVAL (QUARTER(CURDATE())-1)*3 MONTH)
         AND sale_date <= CURDATE()
        THEN sale_amount ELSE 0 END) AS qtd_sales
FROM sales
GROUP BY product_id
ORDER BY product_id;