SELECT course_name,AVG(score)
FROM students
WHERE student_id IN (
  SELECT student_id
  FROM students
  GROUP BY student_id
  HAVING MIN(score) < 70          -- student has at least one score < 70
)
GROUP BY course_name
HAVING AVG(score)>70
ORDER BY AVG(score) DESC;