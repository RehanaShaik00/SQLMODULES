-- Schema
DROP TABLE IF EXISTS elections;
CREATE TABLE elections (
  district_name VARCHAR(20),
  candidate_id  INT,
  party_name    VARCHAR(10),
  votes         INT
);

-- Data
-- Delhi North (tie between Congress and BJP at 1500)
INSERT INTO elections VALUES
('Delhi North', 101, 'Congress', 1500),
('Delhi North', 102, 'BJP',      1500),
('Delhi North', 103, 'AAP',      1100);

-- Mumbai South (Congress leads)
INSERT INTO elections VALUES
('Mumbai South', 106, 'Congress', 2000),
('Mumbai South', 107, 'BJP',      1800),
('Mumbai South', 110, 'AAP',      1500);

-- Kolkata East (BJP leads)
INSERT INTO elections VALUES
('Kolkata East', 111, 'Congress', 2200),
('Kolkata East', 113, 'BJP',      2300),
('Kolkata East', 114, 'AAP',      2000);

-- Chennai Central (BJP leads; only two candidates provided)
INSERT INTO elections VALUES
('Chennai Central', 116, 'Congress', 1600),
('Chennai Central', 117, 'BJP',      1700);

/*
You are provided with election data from multiple districts in India. 
Each district conducted elections for selecting a representative from various political parties. 
Your task is to analyze the election results to determine the winning party at national levels.  
Here are the steps to identify winner:
1- Determine the winning party in each district based on the candidate with the highest number of votes.
2- If multiple candidates from different parties have the same highest number of votes in a district
  , consider it a tie, and all tied candidates are declared winners for that district.
3- Calculate the total number of seats won by each party across all districts
4- A party wins the election if it secures more than 50% of the total seats available nationwide.
Display the total number of seats won by each party and a result column specifying Winner or Loser. Order the output by total seats won in descending order.
*/
with districtmaxvotes as
(select district_name,Max(votes) as maxvotes
from elections
group by district_name),
winners as
(select e.district_name,e.party_name
from elections e
join districtmaxvotes d
on d.district_name = e.district_name
and e.votes = d.maxvotes
),
party_seats AS (
  SELECT party_name, COUNT(*) AS seats
  FROM winners
  GROUP BY party_name
),
tot AS (
  SELECT COUNT(DISTINCT district_name) AS total_districts
  FROM elections
)
SELECT
  p.party_name,
  p.seats,
  CASE WHEN p.seats > 0.5 * t.total_districts THEN 'Winner' ELSE 'Loser' END AS result
FROM party_seats p
CROSS JOIN tot t
ORDER BY p.seats DESC, p.party_name;


