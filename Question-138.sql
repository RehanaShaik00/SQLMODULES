
DROP TABLE IF EXISTS customers;
CREATE TABLE customers (
  customer_id    INT PRIMARY KEY,
  customer_name  VARCHAR(100),
  email          VARCHAR(255),
  phone          VARCHAR(50),
  address        VARCHAR(255)
);

INSERT INTO customers (customer_id, customer_name, email, phone, address) VALUES
(1 , '  John Doe  ',          '  JOHN.DOE@GMAIL.COM  ',          '(123)-456-7890',    ' 123 Main St '),
(2 , '  Jane Smith',          'Jane.Smith@Yahoo.com',            '987 654 3210',      ' Los Angeles '),
(3 , 'JOHN DOE ',             'JOHN.DOE@GMAIL.COM',              '123-456-7890',      NULL),
(4 , 'Alex White',            'Alex.White@Outlook.com',          '111-222-3333',      'Chicago'),
(5 , ' Bob Brown',            'Bob.Brown@Gmail.Com',              '+1 (555) 888-9999', NULL),
(6 , 'Emily Davis',           '  EMILY.DAVIS@GMAIL.COM ',        '555 666 7777',      NULL),
(7 , 'Michael Johnson',       'Michael.Johnson@Hotmail.com',     '444-555-6666',      '  Phoenix  '),
(8 , 'David Miller',          '  DAVID.MILLER@YAHOO.COM ',       '(777) 888-9999',    'San Jose'),
(9 , 'David M',               'david.miller@yahoo.com',          '999.888.7777',      NULL),
(10, ' William Taylor ',      ' WILLIAM.TAYLOR@OUTLOOK.COM ',    '+1 123-456-7890',   '  Dallas  '),
(11, 'Michael Johnson',       'Michael.Johnson@Hotmail.com',     '444-555-6666',      NULL),
(12, 'Olivia Brown',          'Olivia.Brown@Yahoo.com',          '333 222 1111',      'Seattle');

WITH cleaned AS (
  SELECT
    customer_id,
    TRIM(customer_name)                           AS customer_name,
    LOWER(TRIM(email))                            AS email_norm,
    REGEXP_REPLACE(phone, '[^0-9]', '')           AS phone,      -- keep digits only
    COALESCE(address, 'Unknown')                  AS address
  FROM customers
),
ranked AS (
  SELECT
    *,
    ROW_NUMBER() OVER (PARTITION BY email_norm ORDER BY customer_id) AS rn
  FROM cleaned
)
SELECT
  customer_id,
  customer_name,
  email_norm AS email,
  phone,
  address
FROM ranked
WHERE rn = 1         -- keep lowest customer_id per (normalized) email
ORDER BY customer_id;
