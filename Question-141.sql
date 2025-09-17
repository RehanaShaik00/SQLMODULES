
DROP TABLE IF EXISTS passenger_flights;
DROP TABLE IF EXISTS flight_details;

CREATE TABLE passenger_flights (
  passenger_id   VARCHAR(10) NOT NULL,
  flight_id      VARCHAR(10) NOT NULL,
  departure_date DATE        NOT NULL
);

CREATE TABLE flight_details (
  flight_id                VARCHAR(10) PRIMARY KEY,
  departure_airport_code   VARCHAR(10) NOT NULL,
  arrival_airport_code     VARCHAR(10) NOT NULL
);

-- Data from the screenshots
INSERT INTO passenger_flights (passenger_id, flight_id, departure_date) VALUES
('P001','F101','2025-03-02'),
('P001','F102','2025-04-02'),
('P001','F103','2025-05-10'),
('P001','F104','2025-06-09'),
('P001','F105','2024-08-02'),
('P004','F106','2024-05-19'),
('P004','F107','2024-09-20'),
('P004','F108','2024-04-29'),
('P004','F109','2024-05-01'),
('P004','F110','2024-12-04'),
('P004','F111','2025-01-07'),
('P002','F112','2025-03-06');

INSERT INTO flight_details (flight_id, departure_airport_code, arrival_airport_code) VALUES
('F101','JFK','LAX'),
('F102','JFK','ORD'),
('F103','JFK','ATL'),
('F104','JFK','LAX'),
('F105','JFK','SEA'),
('F106','JFK','MIA'),
('F107','JFK','DFW'),
('F108','JFK','SFO'),
('F109','JFK','LAS'),
('F110','JFK','BOS'),
('F111','JFK','DEN'),
('F112','JFK','PHX');  -- any valid code is fine

-- Passengers with >5 flights from the same airport in the last year
SELECT
  pf.passenger_id,
  fd.departure_airport_code,
  COUNT(*) AS num_flights
FROM passenger_flights pf
JOIN flight_details fd
  ON fd.flight_id = pf.flight_id
WHERE pf.departure_date >= CURDATE() - INTERVAL 1 YEAR
GROUP BY pf.passenger_id, fd.departure_airport_code
HAVING COUNT(*) > 5
ORDER BY pf.passenger_id, fd.departure_airport_code;

