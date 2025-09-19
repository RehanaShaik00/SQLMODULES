
DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
  order_id    INT PRIMARY KEY,
  customer_id INT NOT NULL,
  order_date  DATE NOT NULL,
  product_id  INT NOT NULL,
  sales       INT NOT NULL
);

INSERT INTO orders VALUES
(  1,201,'2022-01-02',1,200),
(  2,202,'2022-01-04',2, 50),
(  3,203,'2022-01-10',3, 70),
(  4,204,'2022-02-01',1,300),
(  5,205,'2022-02-06',2, 60),
(  6,206,'2022-02-09',3, 25),
(  7,207,'2022-03-01',2, 30);

INSERT INTO orders VALUES
(  8,101,'2023-01-01',1,100),
(  9,102,'2023-01-03',2, 75),
( 10,103,'2023-01-05',3, 90),
( 11,104,'2023-01-08',1,250),
( 12,105,'2023-01-10',2,150),
( 13,106,'2023-02-02',3, 30),
( 14,107,'2023-02-05',1,420),
( 15,108,'2023-02-08',2, 75),
( 16,109,'2023-02-12',3, 60),
( 17,110,'2023-02-15',1,100),
( 18,101,'2023-03-01',2, 75);

INSERT INTO orders VALUES
( 19,301,'2024-01-05',1,400),
( 20,302,'2024-01-07',2,180),
( 21,303,'2024-01-09',3, 80),
( 22,304,'2024-02-03',1,600),
( 23,305,'2024-02-08',2, 80),
( 24,306,'2024-02-10',3,120),
( 25,307,'2024-03-02',2, 90);

WITH monthly AS (
  SELECT
    product_id,
    DATE_FORMAT(order_date,'%m') AS mon,
    YEAR(order_date) AS yr,
    SUM(sales) AS amt
  FROM orders
  GROUP BY product_id, mon, yr
),
pivoted AS (
  SELECT
    product_id,
    mon,
    SUM(CASE WHEN yr=2022 THEN amt END) AS s_2022,
    SUM(CASE WHEN yr=2023 THEN amt END) AS s_2023,
    SUM(CASE WHEN yr=2024 THEN amt END) AS s_2024
  FROM monthly
  GROUP BY product_id, mon
)
SELECT product_id, mon AS month, s_2022, s_2023, s_2024
FROM pivoted
WHERE s_2022 IS NOT NULL AND s_2023 IS NOT NULL AND s_2024 IS NOT NULL
  AND s_2022 < s_2023 AND s_2023 < s_2024
ORDER BY product_id, mon;
