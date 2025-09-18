
DROP TABLE IF EXISTS lift_passengers;
DROP TABLE IF EXISTS lifts;

CREATE TABLE lifts (
  id          INT PRIMARY KEY,
  capacity_kg INT NOT NULL
);

INSERT INTO lifts (id, capacity_kg) VALUES
(1, 300),
(2, 350);

CREATE TABLE lift_passengers (
  passenger_name VARCHAR(50) NOT NULL,
  weight_kg      INT NOT NULL,
  lift_id        INT NOT NULL,
  KEY (lift_id),
  FOREIGN KEY (lift_id) REFERENCES lifts(id)
);

INSERT INTO lift_passengers (passenger_name, weight_kg, lift_id) VALUES
('Rahul',   85, 1),
('Adarsh',  73, 1),
('Riti',    95, 1),
('Dheeraj', 80, 1),
('Vimal',   83, 2);

-- Max people per lift without exceeding capacity (lightest-first), MySQL 8+
WITH ranked AS (
  SELECT
    l.id,
    l.capacity_kg,
    lp.passenger_name,
    lp.weight_kg,
    SUM(lp.weight_kg) OVER (
      PARTITION BY lp.lift_id
      ORDER BY lp.weight_kg, lp.passenger_name
    ) AS running_kg
  FROM lifts l
  JOIN lift_passengers lp
    ON lp.lift_id = l.id
),
fit AS (
  SELECT id, passenger_name, weight_kg
  FROM ranked
  WHERE running_kg <= capacity_kg
)
SELECT
  id,
  GROUP_CONCAT(passenger_name ORDER BY weight_kg, passenger_name SEPARATOR ', ') AS people_list
FROM fit
GROUP BY id
ORDER BY id;
