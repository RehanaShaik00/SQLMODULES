
DROP TABLE IF EXISTS transactions;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
  user_id         INT PRIMARY KEY,
  username        VARCHAR(10) NOT NULL,
  opening_balance INT NOT NULL
);

INSERT INTO users (user_id, username, opening_balance) VALUES
(100, 'Ankit', 1000),
(101, 'Rahul', 9000),
(102, 'Amit',  5000),
(103, 'Agam',  7500);

CREATE TABLE transactions (
  id          INT PRIMARY KEY,
  from_userid INT NOT NULL,
  to_userid   INT NOT NULL,
  amount      INT NOT NULL
);

INSERT INTO transactions (id, from_userid, to_userid, amount) VALUES
(1, 100, 102,  500),
(2, 102, 101,  700),
(3, 101, 102,  600),
(4, 102, 100, 1500),
(5, 102, 101,  800),
(6, 102, 101,  300);

-- Final balances (simple scalar subqueries), MySQL
SELECT
  u.user_id,
  u.username,
  u.opening_balance
    + COALESCE((SELECT SUM(t.amount) FROM transactions t
                WHERE t.to_userid = u.user_id), 0)
    - COALESCE((SELECT SUM(t.amount) FROM transactions t
                WHERE t.from_userid = u.user_id), 0) AS final_balance
FROM users u
ORDER BY final_balance ASC, u.user_id;
