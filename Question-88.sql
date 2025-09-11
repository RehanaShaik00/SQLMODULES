DROP TABLE IF EXISTS viewing_history;
CREATE TABLE viewing_history (
  user_id     INT,
  title       VARCHAR(20),
  device_type VARCHAR(10),
  watch_mins  INT
);

-- Insert rows (as shown)
INSERT INTO viewing_history (user_id, title, device_type, watch_mins) VALUES
(1, 'Stranger Things', 'Mobile',   60),
(1, 'The Crown',       'Mobile',   45),
(1, 'Narcos',          'Smart TV', 90),

(2, 'Stranger Things', 'Mobile',  100),
(2, 'The Crown',       'Tablet',   55),
(2, 'Narcos',          'Mobile',   95),

(3, 'Stranger Things', 'Mobile',   40),
(3, 'The Crown',       'Mobile',   60),
(3, 'Narcos',          'Mobile',   70),

(4, 'Stranger Things', 'Mobile',   70),
(4, 'The Crown',       'Smart TV', 65),
(4, 'Narcos',          'Tablet',   80);

/*
In the Netflix dataset containing information about viewers and their viewing history, 
devise a query to identify viewers who primarily use mobile devices for viewing, 
but occasionally switch to other devices. Specifically, 
find viewers who have watched at least 75% of their total viewing time on mobile devices 
but have also used at least one other devices such as tablets or smart TVs for viewing. 
Provide the user ID and the percentage of viewing time spent on mobile devices. 
Round the result to nearest integer.*/

with mobilewatchmins as (
select user_id,SUM(watch_mins) as mobwatchmins
from viewing_history
where device_type = 'Mobile'
GROUP BY user_id),
totalwatchmins as (
select user_id,SUM(watch_mins) as totalwatchmins,
COUNT(DISTINCT device_type) AS device_types
from viewing_history
GROUP BY user_id)

select distinct m.user_id,round((100*(mobwatchmins/totalwatchmins))) as percentageofmobilewatchtime
from totalwatchmins t
join mobilewatchmins m
on m.user_id = t.user_id
where mobwatchmins >= totalwatchmins*0.75 
and t.device_types>=2
group by t.user_id







