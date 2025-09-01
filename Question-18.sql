DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
  order_id   INT PRIMARY KEY,
  product_id VARCHAR(20) NOT NULL,
  category   VARCHAR(10) NOT NULL,
  unit_price INT NOT NULL,
  quantity   INT NOT NULL
);

INSERT INTO orders (order_id, product_id, category, unit_price, quantity) VALUES
(100, 'Chair-1221',   'Furniture', 1500, 1),
(101, 'Table-3421',   'Furniture', 2000, 3),
(102, 'Chair-1221',   'Furniture', 1500, 2),
(103, 'Table-9762',   'Furniture', 7000, 2),
(104, 'Shoes-1221',   'Footwear',  1700, 1),
(105, 'floaters-3421','Footwear',  2000, 1),
(106, 'floaters-3421','Footwear',  2000, 1),
(107, 'floaters-9875','Footwear',  1500, 2);

/*
Flipkart an ecommerce company wants to find out its top most selling product by quantity in each category.
In case of a tie when quantities sold are same for more than 1 product,
then we need to give preference to the product with higher sales value.
Display category and product in output with category in ascending order.
*/
SELECT category,product_id,SUM(quantity),SUM(quantity*unit_price)
FROM orders o1
GROUP BY category,product_id
HAVING SUM(quantity) IN (SELECT MAX(quantitycount) FROM (SELECT SUM(quantity) as quantitycount FROM orders o2 WHERE o1.category=o2.category GROUP BY category,product_id) as a)
AND SUM(quantity*unit_price) IN (SELECT MAX(pricecount) FROM (SELECT SUM(quantity*unit_price) as pricecount FROM orders o3 WHERE o1.category=o3.category GROUP BY category,product_id
HAVING SUM(quantity) IN (SELECT MAX(quantitycount) FROM (SELECT SUM(quantity) as quantitycount FROM orders o2 WHERE o1.category=o2.category GROUP BY category,product_id) as a)
) as b)
ORDER BY category ASC;
 