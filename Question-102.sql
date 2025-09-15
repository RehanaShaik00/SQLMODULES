SELECT user_id,password
FROM user_passwords
WHERE LENGTH(password) >=8
AND password REGEXP '[a-zA-Z]'
AND password REGEXP '[0-9]'
AND password REGEXP '[@#$%^&*]'
AND password NOT LIKE '% %';