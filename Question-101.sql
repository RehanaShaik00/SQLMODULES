DROP TABLE IF EXISTS module.gmail_data;

CREATE TABLE gmail_data (
  from_user  VARCHAR(20),
  to_user    VARCHAR(20),
  email_day  DATE
);

INSERT INTO gmail_data (from_user, to_user, email_day) VALUES
('a84065b7933ad01019','75d295377a46f83236','2023-11-28'),
('6b503743a13d778200','32ded68d89443e808','2023-12-20'),
('32ded68d89443e808','55e60cfc c9dc49c17e','2023-08-20'),
('157e3e9278e32aba3e','e0e0defbb9ec47f6f7','2023-08-04'),
('114bafadff2d882864','47be2887786891367e','2023-07-04'),
('406539987dd9b679c0','2813e59cf6c1ff698e','2023-04-10'),
('6edf0be4b2267df1fa','a84065b7933ad01019','2023-02-10'),
('a84065b7933ad01019','850badf89ed8f6854','2023-11-27'),
('d63386c884aeb9f71d','6b503743a13d778200','2023-11-28'),
('32ded68d89443e808','d63386c884aeb9f71d','2023-01-28'),
('6edf0be4b2267df1fa','5b8754928306a18b68','2023-05-20');

/*
Given a sample table with emails sent vs. received by the users, 
calculate the response rate (%) which is given as emails sent/ emails received. 
For simplicity consider sent emails are delivered. List all the users that fall under the top 25 percent 
based on the highest response rate.
Please consider users who have sent at least one email and have received at least one email.
*/
SELECT
  user_id,
  sent_cnt,
  recv_cnt,
  ROUND(100 * sent_cnt / recv_cnt, 2) AS response_rate_pct
FROM (
  SELECT
    user_id,
    sent_cnt,
    recv_cnt,
    NTILE(4) OVER (ORDER BY 1.0 * sent_cnt / recv_cnt DESC) AS quartile
  FROM (
    SELECT
      user_id,
      SUM(sent) AS sent_cnt,
      SUM(recv) AS recv_cnt
    FROM (
      SELECT from_user AS user_id, 1 AS sent, 0 AS recv FROM module.gmail_data
      UNION ALL
      SELECT to_user   AS user_id, 0 AS sent, 1 AS recv FROM module.gmail_data
    ) u
    GROUP BY user_id
    HAVING SUM(sent) > 0 AND SUM(recv) > 0
  ) s
) r
WHERE quartile = 1
ORDER BY response_rate_pct DESC, user_id;