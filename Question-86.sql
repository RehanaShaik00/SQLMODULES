-- Drop & create table
DROP TABLE IF EXISTS Matches;
CREATE TABLE Matches (
  away_team   VARCHAR(10),
  home_team   VARCHAR(10),
  match_id    INT,
  winner_team VARCHAR(10)
);

-- Insert rows (explicit column order to match the screenshot)
INSERT INTO Matches (match_id, home_team, away_team, winner_team) VALUES
(1, 'CSK',     'MI',      'MI'),
(2, 'GL',      'RR',      'GL'),
(3, 'SRH',     'Kings11', 'SRH'),
(4, 'DD',      'KKR',     'KKR'),
(5, 'MI',      'CSK',     'MI'),
(6, 'RR',      'GL',      'GL'),
(7, 'Kings11', 'SRH',     'Kings11'),
(8, 'KKR',     'DD',      'DD');

/*
In the Indian Premier League (IPL), each team plays two matches against every other team: 
one at their home venue and one at their opponent's venue. 
We want to identify team combinations where each team wins the away match 
but loses the home match against the same opponent. 
Write an SQL query to find such team combinations, where each team wins at the opponent's venue 
but loses at their own home venue.*/

select m1.match_id,
	   LEAST(m1.home_team, m1.away_team)   AS team_a,
       GREATEST(m1.home_team, m1.away_team) AS team_b
from matches m1
join matches m2
ON m1.home_team = m2.away_team
AND m1.away_team = m2.home_team
where m1.away_team = m1.winner_team
AND m2.away_team = m2.winner_team;


