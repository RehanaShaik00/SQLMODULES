
DROP TABLE IF EXISTS post_likes;
DROP TABLE IF EXISTS user_follows;

-- Who follows whom
CREATE TABLE user_follows (
  follows_user_id INT NOT NULL,
  user_id         INT NOT NULL
);

INSERT INTO user_follows (follows_user_id, user_id) VALUES
(2, 1),
(3, 1),
(4, 1),
(1, 2),
(3, 2);

-- Post likes (one row per user like)
CREATE TABLE post_likes (
  post_id INT NOT NULL,
  user_id INT NOT NULL
);

INSERT INTO post_likes (post_id, user_id) VALUES
(100, 1),
(100, 2),
(200, 3),
(300, 4),
(300, 5),
(300, 1);


WITH counts AS (
  SELECT
    uf.user_id,              -- viewer
    pl.post_id,
    COUNT(*) AS like_count   -- likes from people they follow
  FROM user_follows uf
  JOIN post_likes pl
    ON pl.user_id = uf.follows_user_id
  LEFT JOIN post_likes me          -- exclude posts already liked by the user
    ON me.user_id = uf.user_id AND me.post_id = pl.post_id
  WHERE me.post_id IS NULL
  GROUP BY uf.user_id, pl.post_id
),
best AS (
  SELECT user_id, MAX(like_count) AS like_count
  FROM counts
  GROUP BY user_id
)
SELECT
  c.user_id,
  MIN(c.post_id) AS post_id,             -- smallest post_id if tied
  c.like_count   AS no_of_likes
FROM counts c
JOIN best b
  ON b.user_id = c.user_id AND b.like_count = c.like_count
GROUP BY c.user_id, c.like_count
ORDER BY c.user_id;

