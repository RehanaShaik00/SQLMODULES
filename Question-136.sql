SELECT
  CASE WHEN c.is_promoted = 1 THEN CONCAT('[PROMOTED] ', c.name) ELSE c.name END AS name,
  c.phone AS phone,
  CASE
    WHEN c.is_promoted = 1 THEN NULL
    ELSE CONCAT(FLOOR(a.avg_rating), ' (', ROUND(a.avg_rating,1), ', based on ',
                a.total_reviews, ' reviews)')
  END AS rating
FROM companies c
LEFT JOIN (
  SELECT company_id, AVG(rating) AS avg_rating, COUNT(*) AS total_reviews
  FROM categories
  GROUP BY company_id
) a ON a.company_id = c.id
WHERE c.is_promoted = 1 OR a.avg_rating >= 1
ORDER BY c.is_promoted DESC, a.avg_rating DESC, a.total_reviews DESC;