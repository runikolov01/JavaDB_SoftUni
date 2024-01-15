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
SELECT e.employee_id, e.first_name, e.salary, d.name AS 'department_name'
FROM employees AS e
         JOIN departments AS d ON e.department_id = d.department_id
WHERE e.salary > 15000
ORDER BY d.department_id DESC
LIMIT 5;

-- 05. Employees Without Project
SELECT e.employee_id, e.first_name
FROM employees AS e
         LEFT OUTER JOIN employees_projects AS ep ON e.employee_id = ep.employee_id
WHERE ep.project_id IS NULL
ORDER BY e.employee_id DESC
LIMIT 3;

-- 06. Employees Hired After
SELECT employees.first_name, employees.last_name, employees.hire_date, departments.name AS 'dept_name'
FROM employees
         JOIN departments ON employees.department_id = departments.department_id
WHERE departments.name IN ('Finance', 'Sales')
  AND hire_date > '1999-01-01'
ORDER BY hire_date ASC;

-- 07. Employees with Project
SELECT ep.employee_id, e.first_name, projects.name AS 'project_name'
FROM employees_projects AS ep
         JOIN projects ON ep.project_id = projects.project_id
         JOIN employees AS e ON ep.employee_id = e.employee_id
WHERE DATE(projects.start_date) > '2002-08-13'
  AND end_date IS NULL
ORDER BY first_name, project_name ASC
LIMIT 5;

-- ВТОРИ НАЧИН:
SELECT e.employee_id, e.first_name, p.name AS 'project_name'
FROM employees e
         JOIN employees_projects AS ep ON e.employee_id = ep.employee_id
         JOIN projects AS p ON ep.project_id = p.project_id
WHERE DATE(p.start_date) > '2002-08-13'
  AND p.end_date IS NULL
ORDER BY e.first_name, p.name
LIMIT 5;

-- 08. Employee 24
SELECT e.employee_id,
       e.first_name,
       IF(YEAR(p.start_date) >= 2005, NULL, p.name) AS 'project_name'
FROM employees AS e
         JOIN employees_projects AS ep ON e.employee_id = ep.employee_id
         JOIN projects AS p ON ep.project_id = p.project_id
WHERE e.employee_id = 24
ORDER BY e.first_name, p.name
LIMIT 5;

-- 9. Employee Manager
SELECT
    e.employee_id,
    e.first_name,
    e.manager_id,
    m.first_name AS manager_name
FROM
    employees e
        JOIN
    employees m ON e.manager_id = m.employee_id
WHERE
    e.manager_id IN (3, 7)
ORDER BY
    e.first_name ASC;

-- 10. Employee Summary
SELECT employees.employee_id,
       CONCAT(employees.first_name, ' ', employees.last_name) AS 'employee_name',
       CONCAT(m.first_name, ' ', m.last_name)                 AS 'manager_name',
       departments.name
FROM employees
         JOIN
     employees m ON employees.manager_id = m.employee_id
         JOIN departments ON employees.department_id = departments.department_id
ORDER BY employee_id ASC
LIMIT 5;

-- 11. Min Average Salary
SELECT AVG(e.salary) AS 'avg_salary'
FROM employees AS e
GROUP BY e.department_id
LIMIT 1;