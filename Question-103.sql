SELECT e.name,e.id,m.id
FROM employees e
LEFT JOIN employees m
ON e.mentor_id=m.id
WHERE m.id<>3 OR e.mentor_id IS NULL;