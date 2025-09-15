DROP TABLE IF EXISTS goal;
DROP TABLE IF EXISTS game;
DROP TABLE IF EXISTS team;

-- Teams
CREATE TABLE team (
  id    INT PRIMARY KEY,
  name  VARCHAR(20),
  coach VARCHAR(20)
);

INSERT INTO team (id, name, coach) VALUES
(1, 'Mumbai FC',    'Sunil Chhetri'),
(2, 'Delhi Dynamos','Sandesh Jhingan'),
(3, 'Bengaluru FC', 'Gurpreet Singh'),
(4, 'Goa FC',       'Brandon Fernandes');

-- Games (fixtures)
CREATE TABLE game (
  match_id   INT PRIMARY KEY,
  match_date DATE,
  stadium    VARCHAR(20),
  team1      INT,
  team2      INT
);

INSERT INTO game (match_id, match_date, stadium, team1, team2) VALUES
(1, '2024-09-01', 'Wankhede',         1, 2),
(2, '2024-09-02', 'Jawaharlal Nehru', 3, 4),
(3, '2024-09-03', 'Sree Kanteerava',  1, 3),
(4, '2024-09-04', 'Wankhede',         1, 4);

-- Goals (scored events)
CREATE TABLE goal (
  match_id  INT,
  team_id   INT,
  player    VARCHAR(20),
  goal_time TIME
);

INSERT INTO goal (match_id, team_id, player, goal_time) VALUES
(1, 1, 'Anirudh Thapa',  '18:23:00'),
(1, 1, 'Sunil Chhetri',  '67:12:00'),
(2, 3, 'Udanta Singh',    '22:45:00'),
(2, 4, 'Ferran Corominas','55:21:00'),
(2, 3, 'Sunil Chhetri',   '78:34:00'),
(2, 3, 'Sunil Chhetri',   '80:34:00'),
(3, 1, 'Bipin Singh',     '11:08:00'),
(3, 3, 'Cleiton Silva',   '41:20:00'),
(3, 1, 'Sunil Chhetri',   '59:45:00'),
(3, 3, 'Cleiton Silva',   '62:56:00');

/*
Please refer to the 3 tables below from a football tournament. 
Write an SQL which lists every game with the goals scored by each team. 
The result set should show: match id, match date, team1, score1, team2, score2. 
Sort the result by match id.
Please note that score1 and score2 should be number of goals scored by team1 and team2 respectively.
*/

-- Goals per game for each team
SELECT
  g.match_id,
  g.match_date,
  t1.name AS team1,
  COALESCE(s1.goals, 0) AS score1,
  t2.name AS team2,
  COALESCE(s2.goals, 0) AS score2
FROM game g
JOIN team t1 ON t1.id = g.team1
JOIN team t2 ON t2.id = g.team2
LEFT JOIN (
  SELECT match_id, team_id, COUNT(*) AS goals
  FROM goal
  GROUP BY match_id, team_id
) s1 ON s1.match_id = g.match_id AND s1.team_id = g.team1
LEFT JOIN (
  SELECT match_id, team_id, COUNT(*) AS goals
  FROM goal
  GROUP BY match_id, team_id
) s2 ON s2.match_id = g.match_id AND s2.team_id = g.team2
ORDER BY g.match_id;
