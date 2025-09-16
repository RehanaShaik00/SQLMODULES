SELECT s.name,p.salary,ROUND(AVG(pf.salary)-p.salary,2) as saldiff
FROM students s
JOIN friends f
ON s.id=f.id
JOIN packages p 
ON s.id=p.id
JOIN packages AS pf     
ON pf.id = f.friend_id
-- WHERE  MIN(pf.salary)>p.salary
GROUP BY s.id,s.name,p.salary
HAVING  MIN(pf.salary)>p.salary
-- HAVING GROUP_CONCAT(salary)>actualpersonsal