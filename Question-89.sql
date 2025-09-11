DROP TABLE IF EXISTS viewing_history;
CREATE TABLE viewing_history (
  user_id      INT,
  title        VARCHAR(20),
  device_type  VARCHAR(10)
);

-- Sample data

-- User 101: multi=3 (Stranger Things, Dark, You), single=1 (The Crown)  -> qualifies
INSERT INTO viewing_history VALUES
(101,'Stranger Things','phone'),
(101,'Stranger Things','tv'),
(101,'The Crown','tv'),
(101,'Dark','phone'),
(101,'Dark','tablet'),
(101,'You','phone'),
(101,'You','tv');

-- User 102: multi=1 (Money Heist), single=2 (Breaking Bad, Dark) -> does NOT qualify
INSERT INTO viewing_history VALUES
(102,'Breaking Bad','tv'),
(102,'Dark','tv'),
(102,'Money Heist','tv'),
(102,'Money Heist','phone');

-- User 103: multi=2 (Narcos, Ozark), single=2 (Narcos Mexico, Queen''s Gambit) -> tie, does NOT qualify
INSERT INTO viewing_history VALUES
(103,'Narcos','phone'),
(103,'Narcos','tv'),
(103,'Narcos Mexico','tablet'),
(103,'Ozark','laptop'),
(103,'Ozark','tv'),
(103,'Queen''s Gambit','laptop');

-- User 104: multi=3 (Lucifer, Friends, House of Cards), single=2 (Suit, Wednesday) -> qualifies
INSERT INTO viewing_history VALUES
(104,'Lucifer','phone'),
(104,'Lucifer','tv'),
(104,'Suit','tv'),
(104,'Friends','phone'),
(104,'Friends','tv'),
(104,'Friends','tablet'),
(104,'Wednesday','phone'),
(104,'House of Cards','tablet'),
(104,'House of Cards','laptop');

-- User 105: multi=0, single=2 -> does NOT qualify
INSERT INTO viewing_history VALUES
(105,'Peaky Blinders','tv'),
(105,'Sherlock','phone');

/*
In the Netflix viewing history dataset, 
you are tasked with identifying viewers who have a consistent viewing pattern across multiple devices. 
Specifically, viewers who have watched the same title on more than 1 device type. 
Write an SQL query to find users who have watched more number of titles on multiple devices 
than the number of titles they watched on single device. 
Output the user id , no of titles watched on multiple devices and no of titles watched on single device, 
display the output in ascending order of user_id.
*/

with multipledevices as
(select user_id,title
from viewing_history
group by user_id,title
having count(device_type)>=2),

singledevices as
(select user_id,title
from viewing_history
group by user_id,title
having count(device_type)=1),

multidev as
(select user_id,count(*) as nooftitlesmultipledevice
from multipledevices
group by user_id),

singledev as
(select user_id,count(*) as nooftitlesingledevice
from singledevices
group by user_id)

select vh.user_id,
COALESCE(nooftitlesmultipledevice,0)AS no_of_titles_multiple_device,
COALESCE(nooftitlesingledevice,0)AS no_of_titles_single_device
from (SELECT DISTINCT user_id FROM viewing_history) vh
left join multidev m
on m.user_id = vh.user_id
left join singledev s
on s.user_id = vh.user_id
where COALESCE(nooftitlesmultipledevice,0)>COALESCE(nooftitlesingledevice,0)
order by vh.user_id asc;

