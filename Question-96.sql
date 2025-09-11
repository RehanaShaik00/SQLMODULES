SELECT CONCAT(origin,'-',destination) AS busiestroute,SUM(ticket_count)
FROM tickets
GROUP BY origin,destination
ORDER BY SUM(ticket_count) DESC
limit 1;