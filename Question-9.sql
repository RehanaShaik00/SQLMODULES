DROP TABLE IF EXISTS customer_orders;

CREATE TABLE customer_orders (
  order_id     INT PRIMARY KEY,
  customer_id  INT NOT NULL,
  order_date   DATE NOT NULL,
  order_amount INT NOT NULL
);

-- Sample data: includes first-time buyers and repeats across days.
-- Also contains one customer (108) placing two orders on the same day
-- to test de-duplication by customer per day.
INSERT INTO customer_orders (order_id, customer_id, order_date, order_amount) VALUES
-- 2025-07-01
(1,  101, '2025-07-01', 120),
(2,  102, '2025-07-01',  80),

-- 2025-07-02
(3,  103, '2025-07-02', 150),  -- new
(4,  101, '2025-07-02',  60),  -- repeat

-- 2025-07-03
(5,  104, '2025-07-03', 200),  -- new
(6,  102, '2025-07-03',  50),  -- repeat
(7,  101, '2025-07-03',  75),  -- repeat

-- 2025-07-04
(8,  105, '2025-07-04', 300),  -- new
(9,  106, '2025-07-04', 220),  -- new
(10, 101, '2025-07-04',  40),  -- repeat

-- 2025-07-05
(11, 101, '2025-07-05',  55),  -- repeat
(12, 103, '2025-07-05',  95),  -- repeat
(13, 107, '2025-07-05', 180),  -- new

-- 2025-07-06
(14, 107, '2025-07-06',  70),  -- repeat
(15, 108, '2025-07-06', 260),  -- new
(16, 108, '2025-07-06', 140),  -- same-day second order (still "new" customer for the day)

-- 2025-07-07
(17, 109, '2025-07-07', 210),  -- new
(18, 110, '2025-07-07', 115),  -- new
(19, 103, '2025-07-07', 105),  -- repeat

-- 2025-07-08
(20, 102, '2025-07-08',  65),  -- repeat
(21, 104, '2025-07-08', 130),  -- repeat
(22, 105, '2025-07-08',  95),  -- repeat
(23, 106, '2025-07-08', 160),  -- repeat
(24, 110, '2025-07-08', 125),  -- repeat

-- 2025-07-09
(25, 109, '2025-07-09',  90),  -- repeat only day (0 new)

-- 2025-07-10
(26, 111, '2025-07-10', 175),  -- new
(27, 101, '2025-07-10',  85); 

/*
Flipkart wants to build a very important business metrics where they want to track on daily basis
how many new and repeat customers are purchasing products from their website.
A new customer is defined when he purchased anything for the first time from the website
and repeat customer is someone who has done at least one purchase in the past.
Display order date , new customers , repeat customers  in ascending order of repeat customers.
*/
SELECT o.order_date,
GROUP_CONCAT(DISTINCT CASE WHEN  o.order_date=(SELECT MIN(order_date) 
						FROM customer_orders as c 
						WHERE o.customer_id=c.customer_id)
                        THEN o.customer_id END) as newcustomers,
GROUP_CONCAT(DISTINCT CASE WHEN  o.order_date>(SELECT MIN(order_date) 
						FROM customer_orders c 
						WHERE o.customer_id=c.customer_id)
                        THEN o.customer_id END) as oldcustomers
FROM customer_orders o
GROUP BY o.order_date
ORDER BY oldcustomers ASC;
