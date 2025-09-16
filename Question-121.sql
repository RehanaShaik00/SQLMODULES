DROP TABLE IF EXISTS items;

CREATE TABLE items (
  id INT PRIMARY KEY,
  weight INT
);

INSERT INTO items (id, weight) VALUES
(1,  1),
(2,  3),
(3,  5),
(4,  3),
(5,  2),
(6,  1),
(7,  4),
(8,  1),
(9,  2),
(10, 5),
(11, 1),
(12, 3);

SELECT
  id,
  weight,
  FLOOR( (SUM(weight) OVER (ORDER BY id) - 1) / 5 ) + 1 AS box_no
FROM items
ORDER BY id;