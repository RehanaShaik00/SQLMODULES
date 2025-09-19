with all_bills as (
select customer_id,loan_id as bill_id,loan_due_date as due_date,0 as bill_amount
from loans
union all
select customer_id,bill_id,bill_due_date as due_date, bill_amount
from credit_card_bills
)
, on_time_calc as
(select b.customer_id,sum(b.bill_amount) as bill_amount
,count(*) as total_bills , sum(case when ct.transaction_date<=due_date then 1 else 0 end) as on_time_payments
from all_bills b
inner join customer_transactions ct on b.bill_id=ct.loan_bill_id
group by b.customer_id)
select c.customer_id , ROUND((ot.on_time_payments*1.0/ot.total_bills)*70 +
(case when ot.bill_amount*1.0/c.credit_limit < 0.3 then 1
when ot.bill_amount*1.0/c.credit_limit < 0.5 then 0.7
else 0.5 end) * 30 , 1 ) as cibil_score
from customers c
inner join on_time_calc ot on c.customer_id=ot.customer_id
ORDER BY c.customer_id ASC;