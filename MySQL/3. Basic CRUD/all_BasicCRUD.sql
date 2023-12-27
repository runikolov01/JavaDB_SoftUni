USE hotel;

-- Problem 1: Select Employee Information:
SELECT 
    id AS 'ID',
    first_name AS 'First Name',
    last_name AS 'Last Name',
    job_title AS 'Job Title'
FROM
    employees AS e
ORDER BY id;

-- Problem 2: Select Employees with Filter:
SELECT id, CONCAT_WS(' ', first_name, last_name) AS full_name, job_title, salary FROM employees 
WHERE salary > 1000
ORDER BY id;

-- Problem 3: Update Employees Salary:
UPDATE employees
SET salary = salary + 100
WHERE job_title = 'Manager';
SELECT salary FROM employees;

-- Problem 4: Top Paid Employee
CREATE VIEW `v_top_paid_employee` AS
SELECT * 
FROM employees
ORDER BY salary DESC
LIMIT 1;
SELECT * FROM v_top_paid_employee;

-- Problem 5: Select Employees by Multiple Filters:
SELECT * 
FROM employees
WHERE department_id = 4 AND (salary > 1000 OR salary = 1000)
ORDER BY id;

-- Problem 6: Delete from Table
DELETE FROM employees WHERE (department_id = 2 OR department_id = 1);
SELECT * FROM employees
ORDER BY id;