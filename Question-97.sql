SELECT
  CustomerID,
  Email,
  SUBSTRING_INDEX(Email, '@', -1) AS domain
FROM Customers;