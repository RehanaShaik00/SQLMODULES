DROP TABLE IF EXISTS product_reviews;

-- Schema
CREATE TABLE product_reviews (
  review_id   INT PRIMARY KEY,
  product_id  INT NOT NULL,
  review_text VARCHAR(40) NOT NULL
);

-- Data from the image
INSERT INTO product_reviews (review_id, product_id, review_text) VALUES
(1 , 101, 'The product is excellent!'),
(2 , 102, 'This product is Amazing.'),
(3 , 103, 'Not an excellent product.'),
(4 , 104, 'The quality is Excellent.'),
(5 , 105, 'An amazing product!'),
(6 , 106, 'This is not an amazing product.'),
(7 , 107, 'This product is not Excellent.'),
(8 , 108, 'This is a not excellent product.'),
(9 , 109, 'The product is not amazing.'),
(10, 110, 'An excellent product, not amazing.'),
(11, 101, 'A good product');

/* Your task is to write an SQL query to find all product reviews containing the word "excellent" 
or "amazing" in the review text. However, you want to exclude reviews that contain the word "not" 
immediately before "excellent" or "amazing". 
Please note that the words can be in upper or lower case or combination of both. */
 
 SELECT review_text 
 FROM product_reviews
 WHERE (LOWER(review_text) LIKE '%excellent%'
 OR LOWER(review_text) LIKE '%amazing%')
 AND LOWER(review_text) NOT LIKE '%not excellent%'
 AND LOWER(review_text) NOT LIKE '%not amazing%';
 