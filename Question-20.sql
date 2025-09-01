DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
  order_month VARCHAR(6) NOT NULL,
  product_id  VARCHAR(5) NOT NULL,
  sales       INT NOT NULL,
  PRIMARY KEY (order_month, product_id)
);

INSERT INTO orders (order_month, product_id, sales) VALUES
('202301','p1',100),
('202301','p2',500),
('202302','p1',700),
('202302','p2',300),
('202303','p1',900),
('202303','p2',700),
('202304','p1',2000),
('202304','p2',1100),
('202305','p1',1500),
('202305','p2',1300),
('202306','p1',1700),
('202306','p2',1400);

/*
Amazon wants to find out the trending products for each month. 
Trending products are those for which any given month sales are more than the sum of previous 
2 months sales for that product.
Please note that for first 2 months of operations this metrics does not make sense.
So output should start from 3rd month only.  
Assume that each product has at least 1 sale each month, 
display order month and product id. Sort by order month.
*/
SELECT order_month, product_id,sales
FROM (
SELECT order_month,
			product_id,
            sales,
            LAG(sales, 1) OVER (PARTITION BY product_id ORDER BY order_month) AS prev1,
			LAG(sales, 2) OVER (PARTITION BY product_id ORDER BY order_month) AS prev2
FROM orders) a
 WHERE prev1 IS NOT NULL AND prev2 IS NOT NULL
 AND sales > prev1+prev2
ORDER BY order_month,product_id;
