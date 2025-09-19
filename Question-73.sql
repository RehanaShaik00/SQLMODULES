select category, LENGTH(products) - LENGTH(REPLACE(products, ',', '')) + 1 as productnos
from categories
order by productnos;