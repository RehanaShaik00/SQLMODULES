
DROP TABLE IF EXISTS lift_passengers;
DROP TABLE IF EXISTS lifts;

-- Lifts
CREATE TABLE lifts (
  id          INT PRIMARY KEY,
  capacity_kg INT NOT NULL
);

INSERT INTO lifts (id, capacity_kg) VALUES
(1, 300),
(2, 350);

-- Passengers (with gender)
CREATE TABLE lift_passengers (
  passenger_name VARCHAR(50) NOT NULL,
  weight_kg      INT NOT NULL,
  gender         VARCHAR(1) NOT NULL,   -- 'F' or 'M'
  lift_id        INT NOT NULL,
  KEY (lift_id),
  FOREIGN KEY (lift_id) REFERENCES lifts(id)
);

-- Lift 1
INSERT INTO lift_passengers (passenger_name, weight_kg, gender, lift_id) VALUES
('Adarsh',  73, 'M', 1),
('Dheeraj', 80, 'M', 1),
('Rahul',   85, 'M', 1),
('Riti',    95, 'F', 1);

-- Lift 2
INSERT INTO lift_passengers (passenger_name, weight_kg, gender, lift_id) VALUES
('Nina',   50, 'F', 2),
('Sara',   60, 'F', 2),
('Karan',  70, 'M', 2),
('Vimal',  83, 'M', 2);

-- Max people per lift with FEMALES first, without exceeding capacity (MySQL 8+)
WITH ranked AS (
  SELECT
    l.id,
    l.capacity_kg,
    lp.passenger_name,
    lp.weight_kg,
    CASE WHEN UPPER(lp.gender)='F' THEN 0 ELSE 1 END AS gpri,
    SUM(lp.weight_kg) OVER (
      PARTITION BY lp.lift_id
      ORDER BY CASE WHEN UPPER(lp.gender)='F' THEN 0 ELSE 1 END,
               lp.weight_kg, lp.passenger_name
    ) AS running_kg
  FROM lifts l
  JOIN lift_passengers lp ON lp.lift_id = l.id
),
fit AS (
  SELECT id, passenger_name, weight_kg, gpri
  FROM ranked
  WHERE running_kg <= capacity_kg
)
SELECT
  id,
  GROUP_CONCAT(passenger_name
               ORDER BY gpri, weight_kg, passenger_name SEPARATOR ', ') AS people_list
FROM fit
GROUP BY id
ORDER BY id;
