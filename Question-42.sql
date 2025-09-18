
DROP TABLE IF EXISTS icc_world_cup;
CREATE TABLE icc_world_cup (
  team_1  VARCHAR(10) NOT NULL,
  team_2  VARCHAR(10) NOT NULL,
  winner  VARCHAR(10) NOT NULL   -- 'Draw' if match drawn, else winning team name
);

-- Sample data (as shown)
INSERT INTO icc_world_cup (team_1, team_2, winner) VALUES
('India', 'SL',    'India'),
('SL',    'Aus',   'Draw'),
('SA',    'Eng',   'Eng'),
('Eng',   'NZ',    'NZ'),
('Aus',   'India', 'India'),
('Eng',   'SA',    'Draw');

-- Points table (wins=2 pts, draw=1 pt each), MySQL
WITH all_teams AS (
  SELECT team_1 AS team, winner FROM icc_world_cup
  UNION ALL
  SELECT team_2 AS team, winner FROM icc_world_cup
)
SELECT
  team AS team_name,
  COUNT(*) AS matches_played,
  SUM(CASE WHEN winner = team       THEN 1 ELSE 0 END) AS wins,
  SUM(CASE WHEN winner <> 'Draw'
             AND winner <> team     THEN 1 ELSE 0 END) AS losses,
  SUM(CASE WHEN winner = team       THEN 2
           WHEN winner = 'Draw'     THEN 1
           ELSE 0 END) AS points
FROM all_teams
GROUP BY team
ORDER BY team_name;

