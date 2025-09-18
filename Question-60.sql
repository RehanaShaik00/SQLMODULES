
DROP TABLE IF EXISTS posts;
DROP TABLE IF EXISTS influencers;

CREATE TABLE influencers (
  influencer_id INT PRIMARY KEY,
  username      VARCHAR(10) NOT NULL,
  join_date     DATE NOT NULL
);

INSERT INTO influencers VALUES
(1,'Ankit','2023-02-01'),
(2,'Rahul','2023-03-05'),
(3,'Suresh','2023-05-20');

CREATE TABLE posts (
  influencer_id INT NOT NULL,
  post_id       INT NOT NULL,
  post_date     DATE NOT NULL,
  likes         INT  NOT NULL,
  comments      INT  NOT NULL,
  PRIMARY KEY (influencer_id, post_id)
);

INSERT INTO posts VALUES
(1,1,'2023-01-05',100,20),
(1,2,'2023-01-10',150,30),
(1,3,'2023-02-05',200,45),
(1,4,'2023-02-10',120,25);

INSERT INTO posts VALUES
(2,1,'2023-02-15',150,30),
(2,2,'2023-02-20',200,25),
(2,3,'2023-03-10',250,15),
(2,4,'2023-03-15',200,35);

SELECT
  i.influencer_id,
  i.username,
  ROUND(
    100 * (
      AVG(CASE WHEN p.post_date >= i.join_date THEN (p.likes + p.comments) END) -
      AVG(CASE WHEN p.post_date <  i.join_date THEN (p.likes + p.comments) END)
    ) / NULLIF(AVG(CASE WHEN p.post_date < i.join_date THEN (p.likes + p.comments) END), 0)
  , 2) AS growth_rate_pct
FROM influencers i
LEFT JOIN posts p
  ON p.influencer_id = i.influencer_id
GROUP BY i.influencer_id, i.username
HAVING COUNT(CASE WHEN p.post_date <  i.join_date THEN 1 END) > 0
   AND COUNT(CASE WHEN p.post_date >= i.join_date THEN 1 END) > 0
ORDER BY growth_rate_pct DESC;


