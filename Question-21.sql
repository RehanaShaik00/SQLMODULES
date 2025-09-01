DROP TABLE IF EXISTS drivers;
CREATE TABLE drivers (
  id         VARCHAR(10),
  start_loc  VARCHAR(1),
  start_time TIME,
  end_loc    VARCHAR(1),
  end_time   TIME
);

INSERT INTO drivers (id, start_loc, start_time, end_loc, end_time) VALUES
('dri_1','a','09:00:00','b','09:30:00'),
('dri_1','b','09:30:00','c','10:30:00'),
('dri_1','d','11:00:00','e','11:30:00'),
('dri_1','f','12:00:00','g','12:30:00'),
('dri_1','c','13:30:00','h','14:30:00'),
('dri_2','f','12:15:00','g','12:30:00'),
('dri_2','c','12:30:00','h','14:30:00');

/*
A profit ride for a Uber driver is considered when the start location and start time of a ride exactly
match with the previous ride's end location and end time. 
Write an SQL to calculate total number of rides and total profit rides by each driver,
display the output in ascending order of id.
*/
SELECT id,count(*),SUM(profitrides) FROM
(SELECT id,start_loc,start_time,end_loc,end_time,
(start_loc=lag(end_loc,1) over(partition by id ORDER BY start_time) AND
start_time=lag(end_time,1) over(partition by id ORDER BY start_time)) as profitrides
FROM drivers) T
GROUP BY id
ORDER BY id;
