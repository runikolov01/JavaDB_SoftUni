-- 1. Managers
SELECT 
    employee_id,
    CONCAT(first_name, ' ', last_name) AS 'full_name',
    d.department_id,
    d.name AS 'department_name'
FROM
    departments AS d
        INNER JOIN
    employees AS e ON d.manager_id = e.employee_id
ORDER BY employee_id
LIMIT 5;

SELECT 
    *
FROM
    employees
WHERE
    manager_id IS NOT NULL;

SELECT 
    *
FROM
    departments;
    
-- 2. Towns and Addresses
SELECT 
    t.town_id, t.name AS 'town_name', a.address_text
FROM
    towns AS t
        JOIN
    addresses AS a ON t.town_id = a.town_id
WHERE
    t.name IN ('San Francisco' , 'Sofia', 'Carnation')
ORDER BY t.town_id , a.address_id;

-- 3. Employees Without Managers
SELECT 
    employee_id, first_name, last_name, department_id, salary
FROM
    employees
WHERE
    manager_id IS NULL; 
    
-- 4. High Salary
SELECT 
    COUNT(*) AS 'count'
FROM
    employees
WHERE
    salary > (SELECT 
            AVG(salary)
        FROM
            employees);