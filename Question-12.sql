DROP TABLE IF EXISTS orderfinal;
CREATE TABLE orderfinal(
  customer_id   INT       NOT NULL,
  delivery_time INT       NOT NULL,   -- minutes
  order_id      INT       PRIMARY KEY,
  restaurant_id INT       NOT NULL,
  total_cost    INT       NOT NULL    -- whole currency units for simplicity
);

-- Sample data (multiple orders per customer; includes a tie for top spender)
INSERT INTO orderfinal(customer_id, delivery_time, order_id, restaurant_id, total_cost) VALUES
(101, 32, 1001, 201, 23),
(102, 28, 1002, 201, 120),
(103, 45, 1003, 202, 80),
(104, 25, 1004, 203, 99),
(105, 40, 1005, 202, 16),
(106, 30, 1006, 204, 200),
(107, 22, 1007, 204, 90),
(108, 55, 1008, 201, 45),
(101, 20, 1009, 203, 45),
(102, 18, 1010, 203, 35),
(103, 60, 1011, 204, 50),
(104, 35, 1012, 203, 41),
(105, 25, 1013, 202, 12),
(106, 15, 1014, 202, 10),
(107, 18, 1015, 201, 90),
(108, 20, 1016, 203, 85),
(107, 35, 1017, 204, 30),
(103, 22, 1018, 201, 20),
(102, 25, 1019, 202, 0),   -- promo / free delivery
(101, 53, 1020, 204, 0);

-- You are provided with data from a food delivery service called Deliveroo. 
-- Each order has details about the delivery time, the rating given by the customer, 
-- and the total cost of the order. 
-- Write an SQL to find customer with highest total expenditure. 
-- Display customer id and total expense by him/her

SELECT customer_id,SUM(total_cost) as totalcost
FROM orderfinal
GROUP BY customer_id
HAVING SUM(total_cost) = (SELECT MAX(totalcost) FROM  (SELECT SUM(total_cost) as totalcost FROM orderfinal GROUP BY customer_id)as a);
