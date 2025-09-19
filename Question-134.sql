SELECT u.user_id, u.uname, u.email, IFNULL(o.last_order_amount, 0) AS last_order_amount
FROM users u
LEFT JOIN (
SELECT o1.user_id, o1.order_amount AS last_order_amount, o1.order_date FROM orders o1
WHERE o1.order_date = (SELECT MAX(o2.order_date) FROM orders o2 WHERE o2.user_id = o1.user_id)
) o ON u.user_id = o.user_id
WHERE u.signup_date <= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)  -- registered > 6 months ago
  AND (o.order_date IS NULL   -- never ordered 
       OR o.order_date < DATE_SUB(CURDATE(), INTERVAL 3 MONTH) -- last order older than 3 months
      )
ORDER BY u.user_id;