
DROP TABLE IF EXISTS employee_record;
CREATE TABLE employee_record (
  emp_id     INT NOT NULL,
  action     VARCHAR(3) NOT NULL,   -- 'in' or 'out'
  created_at DATETIME NOT NULL,
  KEY(emp_id, created_at)
);

INSERT INTO employee_record VALUES
(1,'in','2019-04-01 09:00:00'),
(1,'out','2019-04-01 16:00:00'),
(1,'in','2019-04-01 18:00:00'),
(1,'out','2019-04-01 23:00:00'),
(1,'in','2019-04-01 23:30:00'),
(1,'out','2019-04-02 08:30:00'),
(1,'in','2019-04-02 09:30:00'),
(1,'out','2019-04-02 11:00:00');
INSERT INTO employee_record VALUES
(2,'in','2019-04-01 13:00:00'),
(2,'out','2019-04-01 13:30:00'),
(2,'in','2019-04-01 14:15:00'),
(2,'out','2019-04-01 15:00:00'),
(2,'in','2019-04-01 22:00:00'),
(2,'out','2019-04-02 01:00:00'),
(2,'in','2019-04-02 09:50:00'),
(2,'out','2019-04-02 10:05:00');
INSERT INTO employee_record VALUES
(3,'in','2019-03-31 22:00:00'),
(3,'out','2019-04-01 14:10:00'),
(3,'in','2019-04-02 07:00:00'),
(3,'out','2019-04-02 12:00:00');
INSERT INTO employee_record VALUES
(4,'in','2019-04-02 11:00:00'),
(4,'out','2019-04-02 12:00:00');

-- Time (in minutes) each employee spent inside between
-- '2019-04-01 14:00:00' and '2019-04-02 10:00:00'  (MySQL 8+)

WITH ev AS (
  SELECT
    emp_id, action, created_at,
    LEAD(created_at) OVER (PARTITION BY emp_id ORDER BY created_at) AS next_time
  FROM employee_record
),
stints AS (                   -- in→out intervals
  SELECT emp_id, created_at AS in_time, next_time AS out_time
  FROM ev
  WHERE action = 'in'
),
clamped AS (                  -- overlap with the window
  SELECT
    emp_id,
    GREATEST(in_time,  TIMESTAMP('2019-04-01 14:00:00')) AS st,
    LEAST(out_time,    TIMESTAMP('2019-04-02 10:00:00')) AS en
  FROM stints
)
SELECT
  e.emp_id,
  COALESCE(SUM(CASE WHEN c.en > c.st
                    THEN TIMESTAMPDIFF(MINUTE, c.st, c.en)
                    ELSE 0 END), 0) AS minutes_inside
FROM (SELECT DISTINCT emp_id FROM employee_record) e
LEFT JOIN clamped c ON c.emp_id = e.emp_id
GROUP BY e.emp_id
ORDER BY e.emp_id;

