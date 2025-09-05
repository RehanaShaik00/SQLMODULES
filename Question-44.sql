DROP TABLE IF EXISTS inventory;
DROP TABLE IF EXISTS products;

-- Products master
CREATE TABLE products (
  product_id INT PRIMARY KEY,
  unit_cost  DECIMAL(5,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO products (product_id, unit_cost) VALUES
  (101, 51.50),
  (102, 55.50),
  (103, 59.00),
  (104, 50.00);

-- Inventory per location/product
CREATE TABLE inventory (
  location_id      INT NOT NULL,
  product_id       INT NOT NULL,
  inventory_level  INT NOT NULL,
  inventory_target INT NOT NULL,
  PRIMARY KEY (location_id, product_id),
  FOREIGN KEY (product_id) REFERENCES products(product_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO inventory (location_id, product_id, inventory_level, inventory_target) VALUES
  (1, 101,  90,  80),
  (1, 102, 100,  85),
  (2, 102,  90,  80),
  (2, 103,  70,  95),
  (2, 104,  50,  60),
  (3, 103, 120, 100),
  (4, 104,  90, 102);
  
/*
Your task is to identify excess and insufficient inventory at various Flipkart warehouses in terms 
of no of units and cost.  
Excess inventory is when inventory levels are greater than inventory targets 
else its insufficient inventory.
Write an SQL to derive excess/insufficient Inventory volume and 
value in cost for each location as well as at overall company level, 
display the results in ascending order of location id.
*/
WITH a AS 
(
SELECT SUM(CASE WHEN inventory_level>inventory_target THEN (inventory_level-inventory_target)*unit_cost
								   WHEN inventory_level<inventory_target THEN (inventory_target-inventory_level)*unit_cost
                                   END) AS totalcost,
				   CASE WHEN inventory_level>inventory_target THEN "excess"
								   WHEN inventory_level<inventory_target THEN "insufficient"
                                   END AS inventorylevel
FROM inventory i
JOIN products p
ON i.product_id = p.product_id
GROUP BY inventorylevel
)

SELECT location_id,CASE WHEN inventory_level>inventory_target THEN "excess"
								   WHEN inventory_level<inventory_target THEN "insufficient"
                                   END AS inventorylevel,
							  SUM(CASE WHEN inventory_level>inventory_target THEN inventory_level-inventory_target
								   WHEN inventory_level<inventory_target THEN inventory_target-inventory_level
                                   END) AS inventoryvolume,
							 SUM(CASE WHEN inventory_level>inventory_target THEN (inventory_level-inventory_target)*unit_cost
								   WHEN inventory_level<inventory_target THEN (inventory_target-inventory_level)*unit_cost
                                   END) AS inventorycost,
							a.totalcost
FROM inventory 
JOIN products 
ON inventory.product_id=products.product_id
JOIN a
  ON a.inventorylevel = CASE
                          WHEN inventory.inventory_level > inventory.inventory_target THEN 'excess'
                          WHEN inventory.inventory_level < inventory.inventory_target THEN 'insufficient'
                        END
GROUP BY location_id,CASE
                          WHEN inventory.inventory_level > inventory.inventory_target THEN 'excess'
                          WHEN inventory.inventory_level < inventory.inventory_target THEN 'insufficient'
                        END,a.totalcost
ORDER BY location_id ASC;

