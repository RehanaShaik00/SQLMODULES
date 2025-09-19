
DROP TABLE IF EXISTS matches;
DROP TABLE IF EXISTS players;

CREATE TABLE players (
  player_id INT PRIMARY KEY,
  group_id  INT NOT NULL
);

INSERT INTO players (player_id, group_id) VALUES
(1,1),(2,1),(3,1),(4,1),
(5,2),(6,2),(7,2),(8,2),
(9,3),(10,3),(11,3),(12,3);

CREATE TABLE matches (
  match_id      INT PRIMARY KEY,
  first_player  INT NOT NULL,
  second_player INT NOT NULL,
  first_score   INT NOT NULL,
  second_score  INT NOT NULL
);

INSERT INTO matches VALUES
(1, 1, 2, 3, 0),
(2, 2, 3, 2, 5),
(3, 3, 4, 7, 4),
(4, 4, 1, 1, 1);
INSERT INTO matches VALUES
(5, 5, 6, 3, 3),
(6, 6, 7, 0, 2),
(7, 7, 8, 6, 1),
(8, 8, 5, 4, 5);
INSERT INTO matches VALUES
(9,  9, 10, 1, 0),
(10,10, 11, 2, 2),
(11,11, 12, 3, 4),
(12,12,  9, 5, 3);

WITH pts AS (
  SELECT p.group_id, u.player_id, SUM(u.pts) AS tp
  FROM (
    SELECT first_player  AS player_id, first_score  AS pts FROM matches
    UNION ALL
    SELECT second_player AS player_id, second_score AS pts FROM matches
  ) u
  JOIN players p ON p.player_id = u.player_id
  GROUP BY p.group_id, u.player_id
)
SELECT group_id, player_id AS winner_id
FROM (
  SELECT *, ROW_NUMBER() OVER (PARTITION BY group_id ORDER BY tp DESC, player_id DESC) AS rn
  FROM pts
) x
WHERE rn = 1
ORDER BY group_id;
