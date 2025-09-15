SELECT sc.student_id,sc.course_id
FROM student_courses AS sc
WHERE major_flag='Y' OR (SELECT COUNT(*) FROM student_courses s WHERE s.student_id=sc.student_id) =1
ORDER BY sc.student_id;