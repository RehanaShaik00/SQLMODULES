use modules;
-- Clean start
DROP TABLE IF EXISTS ott_viewership;

-- Create table
CREATE TABLE ott_viewership (
  viewer_id    INT,
  show_id      INT,
  show_name    VARCHAR(50),
  genre        VARCHAR(20),
  country      VARCHAR(30),
  view_date    DATE,
  duration_min INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Sample data (U.S. + a few non-U.S. rows)
INSERT INTO ott_viewership
(viewer_id, show_id, show_name, genre, country, view_date, duration_min) VALUES
-- Drama
(1 ,101,'Stranger Things',       'Drama',   'United States','2023-05-01', 60),
(2 ,102,'The Crown',             'Drama',   'United States','2023-05-01', 50),
(3 ,103,'Breaking Bad',          'Drama',   'United States','2023-05-02', 55),
(11,111,'Stranger Things',       'Drama',   'United States','2023-05-03', 45),
(12,112,'The Crown',             'Drama',   'United States','2023-05-04', 40),
(13,113,'Breaking Bad',          'Drama',   'United States','2023-05-05', 65),

-- Fantasy
(4 ,104,'Game of Thrones',       'Fantasy', 'United States','2023-05-02', 70),
(6 ,106,'The Witcher',           'Fantasy', 'United States','2023-05-03', 65),
(14,114,'Game of Thrones',       'Fantasy', 'United States','2023-05-04', 80),
(15,115,'The Witcher',           'Fantasy', 'United States','2023-05-05', 60),

-- Sci-Fi
(5 ,105,'The Mandalorian',       'Sci-Fi',  'United States','2023-05-03', 50),
(16,116,'The Mandalorian',       'Sci-Fi',  'United States','2023-05-04', 55),

-- Comedy (include one non-US row that should be ignored)
(7 ,107,'Friends',               'Comedy',  'United States','2023-05-01', 30),
(8 ,108,'Brooklyn Nine-Nine',    'Comedy',  'Canada',       '2023-05-01', 45),
(9 ,109,'The Office',            'Comedy',  'United States','2023-05-02', 35),
(10,110,'Parks and Recreation',  'Comedy',  'United States','2023-05-02', 25),
(17,117,'Friends',               'Comedy',  'United States','2023-05-03', 40),
(18,118,'The Office',            'Comedy',  'United States','2023-05-03', 45),
(19,119,'Parks and Recreation',  'Comedy',  'United States','2023-05-04', 30),
(20,120,'Brooklyn Nine-Nine',    'Comedy',  'United States','2023-05-05', 60);

-- (Optional) quick peek
-- SELECT * FROM ott_viewership ORDER BY genre, show_name, view_date;
/*
You have a table named ott_viewership. 
Write an SQL query to find the top 2 most-watched shows in each genre in the United States. 
Return the show name, genre, and total duration watched for each of the top 2 most-watched shows 
in each genre. sort the result by genre and total duration.*/

SELECT genre,show_name,total_min
FROM (SELECT genre,
			 show_name,
             SUM(duration_min) AS total_min,
             DENSE_RANK() OVER (
			 PARTITION BY genre
             ORDER BY SUM(duration_min) DESC
             ) AS rnk
  FROM ott_viewership
  WHERE country = 'United States'
  GROUP BY genre, show_name
 ) t
WHERE rnk <= 2
ORDER BY genre, total_min DESC;
