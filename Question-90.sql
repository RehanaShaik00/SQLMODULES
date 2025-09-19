with cte as (
SELECT
customer_id,
transaction_date,
SUM(sum(amount)) OVER (PARTITION BY customer_id ORDER BY transaction_date) AS net_amount
FROM transactions
group by customer_id,transaction_date),
cte2 AS (
SELECT
customer_id,
transaction_date,
net_amount,
LEAD(transaction_date, 1, '2024-04-01') OVER (PARTITION BY customer_id ORDER BY transaction_date) AS next_trans_date
FROM cte
)
SELECT
cte2.customer_id,
SUM(
DATEDIFF(next_trans_date, transaction_date) * net_amount * ir.interest_rate
) AS interest_earned
FROM cte2
INNER JOIN InterestRates ir
ON cte2.net_amount BETWEEN ir.min_balance AND ir.max_balance
GROUP BY cte2.customer_id
ORDER BY cte2.customer_id;