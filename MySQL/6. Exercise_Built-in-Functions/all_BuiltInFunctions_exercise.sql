-- 01. Find Names of All Employees by First Name
SELECT first_name, last_name FROM employees
WHERE first_name REGEXP '^Sa';

-- 02. Find Names of All Employees by Last Name
SELECT first_name, last_name FROM employees
WHERE last_name REGEXP 'ei'
ORDER BY employee_id;