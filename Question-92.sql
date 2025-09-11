/*
A pizza eating competition is organized. All the participants are organized into different groups. 
In a contest , A participant who eat the most pieces of pizza is the winner and recieves their original bet 
plus 30% of all losing participants bets. 
In case of a tie all winning participants will get equal share (of 30%) divided among them .
Return the winning participants' 
names for each group and amount of their payout(round to 2 decimal places) . 
ordered ascending by group_id , participant_name.*/


WITH max_slices AS (
  SELECT group_id, MAX(slice_count) AS mx
  FROM Competition
  GROUP BY group_id
),
winners AS (
  SELECT c.group_id, c.participant_name, c.bet
  FROM Competition c
  JOIN max_slices m
    ON c.group_id = m.group_id
   AND c.slice_count = m.mx
),
winner_counts AS (
  SELECT group_id, COUNT(*) AS win_cnt
  FROM winners
  GROUP BY group_id
),
loser_bets AS (
  SELECT c.group_id, SUM(c.bet) AS losing_total
  FROM Competition c
  JOIN max_slices m
    ON c.group_id = m.group_id
   AND c.slice_count < m.mx          -- only losers
  GROUP BY c.group_id
)
SELECT
  w.group_id,
  w.participant_name,
  ROUND(w.bet + 0.30 * COALESCE(l.losing_total, 0) / wc.win_cnt, 2) AS payout
FROM winners w
JOIN winner_counts wc
  ON wc.group_id = w.group_id
LEFT JOIN loser_bets l
  ON l.group_id = w.group_id
ORDER BY w.group_id, w.participant_name;
