SELECT pr.category,
CASE WHEN MIN(CASE WHEN p.stars >= 4 THEN pr.price END) IS NULL
	THEN 0 
	ELSE MIN(CASE WHEN p.stars >= 4 THEN pr.price END)
END AS low_price
from products pr
left join purchases p on pr.id=p.id
group by category
order by category;