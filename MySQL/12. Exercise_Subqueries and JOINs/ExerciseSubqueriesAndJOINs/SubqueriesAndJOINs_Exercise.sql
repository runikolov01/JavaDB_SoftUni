-- 01. Employee Address
USE soft_uni;
SELECT employees.employee_id, employees.job_title, addresses.address_id, addresses.address_text
FROM employees
         JOIN addresses ON employees.address_id = addresses.address_id
ORDER BY address_id ASC
LIMIT 5;