with cte as (
select *
, lead(created_at) over(partition by emp_id order by created_at) as next_created_at
from employee_record )
select count(*) as no_of_emp_inside
from cte
where action='in'
and '2019-04-01 19:05:00' between created_at and next_created_at;