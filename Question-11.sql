CREATE TABLE Students (
    class_id     INT,
    student_id   INT PRIMARY KEY,
    student_name VARCHAR(20)
);

CREATE TABLE Grades (
    student_id INT,
    subject    VARCHAR(20),
    grade      INT,
    PRIMARY KEY (student_id, subject),
    FOREIGN KEY (student_id) REFERENCES Students(student_id)
);

-- ========= Seed data (matches what's shown) =========
-- Students
INSERT INTO Students (class_id, student_id, student_name) VALUES
(1, 1, 'John Doe'),
(2, 2, 'Jane Smith'),
(1, 3, 'Alice Johnson'),
(3, 4, 'Bob Brown'),
(2, 5, 'Emily Clark'),
(1, 6, 'Michael Lee'),
(2, 7, 'Sarah Taylor');

-- Math grades
INSERT INTO Grades (student_id, subject, grade) VALUES
(1, 'Math', 85),
(2, 'Math', 78),
(3, 'Math', 92),
(4, 'Math', 79),
(5, 'Math', 88),
(6, 'Math', 95),
(7, 'Math', 83);

-- You are provided with two tables: Students and Grades. 
--  Write a SQL query to find students who have higher grade in Math 
-- than the average grades of all the students together in Math.
-- Display student name and grade in Math order by grades.

SELECT student_name,grade
FROM students s
JOIN grades g
ON s.student_id=g.student_id
WHERE subject='Math' AND grade>(SELECT AVG(grade) FROM grades WHERE subject='Math')
ORDER BY grade DESC;
