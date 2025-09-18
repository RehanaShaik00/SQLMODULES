
DROP TABLE IF EXISTS transactions;
DROP TABLE IF EXISTS stores;

-- Stores
CREATE TABLE stores (
  store_id   INT PRIMARY KEY,
  store_name VARCHAR(20) NOT NULL,
  location   VARCHAR(20) NOT NULL
);

INSERT INTO stores (store_id, store_name, location) VALUES
(1, 'Store A', 'New York'),
(2, 'Store B', 'New York'),
(3, 'Store C', 'Los Angeles'),
(4, 'Store D', 'Los Angeles'),
(5, 'Store E', 'Chicago'),
(6, 'Store F', 'Chicago');

-- Transactions
CREATE TABLE transactions (
  transaction_id   INT PRIMARY KEY,
  customer_id      INT NOT NULL,
  store_id         INT NOT NULL,
  transaction_date DATE NOT NULL,
  amount           INT  NOT NULL,
  FOREIGN KEY (store_id) REFERENCES stores(store_id)
);

INSERT INTO transactions (transaction_id, customer_id, store_id, transaction_date, amount) VALUES
(1, 101, 1, '2023-01-05', 100),
(2, 102, 1, '2023-01-10', 150),
(3, 103, 3, '2023-01-15', 200),
(4, 104, 3, '2023-01-20', 250),
(5, 105, 5, '2023-01-25', 800),
(6, 101, 2, '2023-02-05', 120),
(7, 102, 2, '2023-02-10', 160),
(8, 103, 4, '2023-02-15', 180),
(9, 104, 4, '2023-02-20', 230);


-- Highest & lowest sales month per location in 2023 (latest month wins ties)
WITH monthly AS (
  SELECT
    s.location,
    DATE_FORMAT(t.transaction_date, '%Y-%m') AS ym,
    SUM(t.amount) AS sales
  FROM transactions t
  JOIN stores s ON s.store_id = t.store_id
  WHERE t.transaction_date >= '2023-01-01' AND t.transaction_date < '2024-01-01'
  GROUP BY s.location, ym
),
ranked AS (
  SELECT *,
         ROW_NUMBER() OVER (PARTITION BY location ORDER BY sales DESC, ym DESC) AS r_hi,
         ROW_NUMBER() OVER (PARTITION BY location ORDER BY sales ASC,  ym DESC) AS r_lo
  FROM monthly
)
SELECT
  location,
  MAX(CASE WHEN r_hi = 1 THEN ym    END) AS highest_month,
  MAX(CASE WHEN r_hi = 1 THEN sales END) AS highest_sales,
  MAX(CASE WHEN r_lo = 1 THEN ym    END) AS lowest_month,
  MAX(CASE WHEN r_lo = 1 THEN sales END) AS lowest_sales
FROM ranked
GROUP BY location
ORDER BY location;
