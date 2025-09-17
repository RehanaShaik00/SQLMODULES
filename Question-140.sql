
DROP TABLE IF EXISTS teams;
CREATE TABLE teams (
  team_id   INT PRIMARY KEY,
  team_name VARCHAR(50) NOT NULL
);

INSERT INTO teams (team_id, team_name) VALUES
(10, 'Give'),
(20, 'Never'),
(30, 'You'),
(40, 'Up'),
(50, 'Gonna');

DROP TABLE IF EXISTS matches;
CREATE TABLE matches (
  match_id    INT PRIMARY KEY,
  host_team   INT NOT NULL,
  guest_team  INT NOT NULL,
  host_goals  INT NOT NULL,
  guest_goals INT NOT NULL
);

INSERT INTO matches (match_id, host_team, guest_team, host_goals, guest_goals) VALUES
(1, 30, 20, 1, 0),
(2, 10, 20, 1, 2),
(3, 20, 50, 2, 2),
(4, 10, 30, 1, 0),
(5, 30, 50, 0, 1);


SELECT
  t.team_id,
  t.team_name,
  COALESCE(SUM(p.pts), 0) AS num_points
FROM teams t
LEFT JOIN (
  SELECT host_team AS team_id,
         CASE
           WHEN host_goals > guest_goals THEN 3
           WHEN host_goals = guest_goals THEN 1
           ELSE 0
         END AS pts
  FROM matches
  UNION ALL
  SELECT guest_team AS team_id,
         CASE
           WHEN guest_goals > host_goals THEN 3
           WHEN guest_goals = host_goals THEN 1
           ELSE 0
         END AS pts
  FROM matches
) p ON p.team_id = t.team_id
GROUP BY t.team_id, t.team_name
ORDER BY num_points DESC, t.team_id ASC;
