-- 01. Employee Address
USE soft_uni;
SELECT employees.employee_id, employees.job_title, addresses.address_id, addresses.address_text
FROM employees
         JOIN addresses ON employees.address_id = addresses.address_id
ORDER BY address_id ASC
LIMIT 5;

-- 2. Addresses with Towns
SELECT e.first_name, e.last_name, t.name AS town, a.address_text
FROM employees AS e
         JOIN addresses a on e.address_id = a.address_id
         JOIN towns AS t ON a.town_id = t.town_id
ORDER BY e.first_name, e.last_name
LIMIT 5;

-- 3. Sales Employee
SELECT e.employee_id, e.first_name, e.last_name, d.name AS 'department_ name'
FROM employees AS e
         JOIN departments AS d
              ON e.department_id = d.department_id
WHERE d.name = 'Sales'
ORDER BY employee_id DESC;

-- 04. Employee Departments
