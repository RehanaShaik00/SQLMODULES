WITH monthly_balance AS (
    SELECT 
        e.employee_id,
        e.name,
        e.leave_balance_from_2023,
        -- Add 1.5 leaves for each month
        (e.leave_balance_from_2023 + (MONTH(l.leave_start_date) - 1) * 1.5) AS available_balance,
        l.request_id,
        l.leave_start_date,
        l.leave_end_date,
        DATEDIFF(l.leave_end_date, l.leave_start_date) + 1 AS leave_days
    FROM employees e
    JOIN leave_requests l 
      ON e.employee_id = l.employee_id
)
SELECT 
    request_id,
    employee_id,
    name,
    leave_start_date,
    leave_end_date,
    leave_days,
    available_balance,
    CASE 
        WHEN available_balance >= leave_days THEN 'Approved'
        ELSE 'Rejected'
    END AS status
FROM monthly_balance
ORDER BY request_id;