DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS loans;

-- Loans
CREATE TABLE loans (
  loan_id      INT PRIMARY KEY,
  customer_id  INT NOT NULL,
  loan_amount  INT NOT NULL,
  due_date     DATE NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO loans (loan_id, customer_id, loan_amount, due_date) VALUES
  (1, 1,  5000, '2023-01-15'),
  (2, 2,  8000, '2023-02-20'),
  (3, 3, 10000, '2023-03-10'),
  (4, 4,  6000, '2023-04-05'),
  (5, 5,  7000, '2023-05-01');

-- Payments
CREATE TABLE payments (
  payment_id   INT PRIMARY KEY,
  loan_id      INT NOT NULL,
  payment_date DATE NOT NULL,
  amount_paid  INT NOT NULL,
  CONSTRAINT fk_payments_loans
    FOREIGN KEY (loan_id) REFERENCES loans(loan_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO payments (payment_id, loan_id, payment_date, amount_paid) VALUES
  (1, 1, '2023-01-10', 2000),
  (2, 1, '2023-02-10', 1500),
  (3, 2, '2023-02-20', 8000);
  
/*
Write an SQL to create 2 flags for each loan as per below rules. 
Display loan id, loan amount , due date and the 2 flags.
1- fully_paid_flag: 1 if the loan was fully repaid irrespective of payment date else it should be 0.
2- on_time_flag : 1 if the loan was fully repaid on or before due date else 0.
*/

SELECT loans.loan_id,
	   loan_amount,
       due_date,
       CASE WHEN COALESCE(SUM(amount_paid),0)>=loan_amount THEN 1 ELSE 0 END AS fully_paid_flag,
       CASE WHEN COALESCE(SUM(CASE
                        WHEN payment_date <= due_date
                        THEN amount_paid
                      END), 0) >= loans.loan_amount THEN  1 ELSE 0 END AS on_time_flag
FROM loans
JOIN payments
ON loans.loan_id=payments.loan_id
GROUP BY loan_id

