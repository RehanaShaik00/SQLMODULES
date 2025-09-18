
DROP TABLE IF EXISTS product_ratings;
CREATE TABLE product_ratings (
  rating_id  INT PRIMARY KEY,
  product_id INT NOT NULL,
  user_id    INT NOT NULL,
  rating     DECIMAL(2,1) NOT NULL
);

-- Data (as shown)
INSERT INTO product_ratings (rating_id, product_id, user_id, rating) VALUES
(1, 101, 1001, 4.5),
(2, 101, 1002, 4.8),
(3, 101, 1003, 4.9),
(4, 101, 1004, 5.0),
(5, 101, 1005, 3.2),
(6, 102, 1006, 4.7),
(7, 102, 1007, 4.0);


WITH a AS (
  SELECT r.*,
         AVG(rating) OVER (PARTITION BY product_id) AS avg_rating
  FROM product_ratings r
),
b AS (
  SELECT a.*,
         ROW_NUMBER() OVER (
           PARTITION BY product_id
           ORDER BY ABS(a.rating - a.avg_rating) DESC, rating_id
         ) AS rn
  FROM a
)
SELECT rating_id, product_id, user_id, rating
FROM b
WHERE rn = 1
ORDER BY rating_id;
