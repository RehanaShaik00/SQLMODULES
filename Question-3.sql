-- Create creators table
CREATE TABLE creators (
    creator_id INT PRIMARY KEY,
    creator_name VARCHAR(20),
    followers INT
);

-- Create posts table
CREATE TABLE posts (
    creator_id INT,
    post_id VARCHAR(3) PRIMARY KEY,
    publish_date DATE,
    impressions INT
);

-- Insert sample data into creators
INSERT INTO creators (creator_id, creator_name, followers) VALUES
(1, 'Alice',   60000),
(2, 'Bob',     55000),
(3, 'Carol',   70000),
(4, 'David',   40000),
(5, 'Eve',     80000),
(6, 'Frank',   65000);

-- Insert sample data into posts
INSERT INTO posts (creator_id, post_id, publish_date, impressions) VALUES
-- Alice: 3 posts in Dec-2023, >100k impressions total
(1, 'P01', '2023-12-05', 40000),
(1, 'P02', '2023-12-15', 35000),
(1, 'P03', '2023-12-25', 45000),
-- Bob: 4 posts in Dec-2023, but total impressions < 100k
(2, 'P04', '2023-12-02', 20000),
(2, 'P05', '2023-12-10', 25000),
(2, 'P06', '2023-12-20', 15000),
(2, 'P07', '2023-12-28', 18000),
-- Carol: 5 posts in Dec-2023, >100k impressions
(3, 'P08', '2023-12-03', 30000),
(3, 'P09', '2023-12-09', 25000),
(3, 'P10', '2023-12-14', 30000),
(3, 'P11', '2023-12-21', 20000),
(3, 'P12', '2023-12-30', 15000),
-- David: followers < 50k
(4, 'P13', '2023-12-06', 50000),
(4, 'P14', '2023-12-19', 60000),
(4, 'P15', '2023-12-27', 70000),
-- Eve: 2 posts in Dec-2023 only
(5, 'P16', '2023-12-05', 60000),
(5, 'P17', '2023-12-15', 50000),
-- Frank: 3 posts in Dec-2023, but total impressions just at 100k (doesn’t qualify since needs >100k)
(6, 'P18', '2023-12-07', 40000),
(6, 'P19', '2023-12-18', 30000),
(6, 'P20', '2023-12-22', 30000);
/*
LinkedIn is a professional social networking app.
They want to give top voice badge to their best creators to encourage them to create more quality content.
A creator qualifies for the badge if he/she satisfies following criteria.
1- Creator should have more than 50k followers.
2- Creator should have more than 100k impressions on the posts that they published in the month 
of Dec-2023.
3- Creator should have published atleast 3 posts in Dec-2023.
Write a SQL to get the list of top voice creators name along with no of posts and impressions by them 
in the month of Dec-2023.
*/
SELECT creator_name,COUNT(post_id),SUM(impressions)
FROM creators c
JOIN posts p
ON c.creator_id=p.creator_id
WHERE c.followers>50000 AND YEAR(publish_date)='2023' AND MONTH(publish_date)=12
GROUP BY creator_name
HAVING SUM(impressions)>100000 AND COUNT(post_id)>=3;
