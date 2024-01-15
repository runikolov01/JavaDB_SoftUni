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
ORDER BY avg_s
LIMIT 1;

USE geography;
-- 12. Highest Peaks in Bulgaria
SELECT mountains_countries.country_code, mountains.mountain_range, peaks.peak_name, peaks.elevation
FROM mountains_countries
         JOIN mountains ON mountains_countries.mountain_id = mountains.id
         JOIN peaks ON mountains.id = peaks.mountain_id
WHERE mountains_countries.country_code = 'BG'
  AND elevation > 2835
ORDER BY elevation DESC;

-- 13. Count Mountain Ranges
SELECT mountains_countries.country_code, COUNT(mountains.mountain_range) AS `mountain_range`
FROM geography.mountains_countries
         JOIN mountains ON mountains_countries.mountain_id = mountains.id
WHERE mountains_countries.country_code IN ('US', 'RU', 'BG')
GROUP BY mountains_countries.country_code
ORDER BY `mountain_range` DESC;

-- 14. Countries with Rivers
SELECT countries.country_name, rivers.river_name
FROM countries
         LEFT JOIN countries_rivers ON countries.country_code = countries_rivers.country_code
         LEFT JOIN rivers ON countries_rivers.river_id = rivers.id
where continent_code = 'AF'
ORDER BY countries.country_name ASC
LIMIT 5;

-- 15. *Continents and Currencies
SELECT c.continent_code, currency_code, COUNT(*) AS 'currency_usage'
FROM countries AS c
GROUP BY c.continent_code, currency_code, c.currency_code
HAVING currency_usage > 1
   AND currency_usage = (SELECT COUNT(*) AS count_of_currencies
                         FROM countries AS c2
                         WHERE c2.continent_code = c.continent_code
                         GROUP BY c2.currency_code
                         ORDER BY count_of_currencies DESC
                         LIMIT 1)
ORDER BY c.continent_code, c.currency_code;

-- 16. Countries without any Mountains
SELECT COUNT(c.country_code) AS country_count
FROM countries AS c
         LEFT JOIN mountains_countries AS m_c ON c.country_code = m_c.country_code
WHERE m_c.mountain_id IS NULL;