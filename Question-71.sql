SELECT d.department_name,ROUND(AVG(e.salary),2)
  FROM employees e
  JOIN departments d
  ON e.department_id=d.department_id
  GROUP BY d.department_id,d.department_name
  HAVING COUNT(DISTINCT employee_id)>2
  ORDER BY ROUND(AVG(e.salary),2) DESC;
