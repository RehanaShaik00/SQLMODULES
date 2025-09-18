
DROP TABLE IF EXISTS sales;
DROP TABLE IF EXISTS categories;

CREATE TABLE categories (
  category_id   INT PRIMARY KEY,
  category_name VARCHAR(12) NOT NULL
);

INSERT INTO categories (category_id, category_name) VALUES
(1, 'Electronics'),
(2, 'Clothing'),
(3, 'Books'),
(4, 'Home Decor');

-- Sales
CREATE TABLE sales (
  sale_id     INT PRIMARY KEY,
  category_id INT NOT NULL,
  amount      INT NOT NULL,
  sale_date   DATE NOT NULL
);

INSERT INTO sales (sale_id, category_id, amount, sale_date) VALUES
(1, 1, 500, '2022-01-05'),
(2, 1, 800, '2022-02-10'),
(4, 3, 200, '2022-02-20'),
(5, 3, 150, '2022-03-01'),
(6, 4, 400, '2022-02-25'),
(7, 4, 600, '2022-03-05');


SELECT
  c.category_id,
  c.category_name,
  COALESCE(SUM(s.amount), 0) AS total_sales
FROM categories c
LEFT JOIN sales s
  ON s.category_id = c.category_id
GROUP BY c.category_id, c.category_name
ORDER BY total_sales ASC, c.category_id;

