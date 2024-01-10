-- 01. Find Names of All Employees by First Name
SELECT first_name, last_name FROM employees
WHERE first_name REGEXP '^Sa';

-- 02. Find Names of All Employees by Last Name
SELECT first_name, last_name FROM employees
WHERE last_name REGEXP 'ei'
ORDER BY employee_id;

-- 03. Find First Names of All Employess
SELECT first_name
FROM employees
WHERE department_id IN (3, 10)
AND YEAR(hire_date) BETWEEN 1995 AND 2005
ORDER BY employee_id ASC;

-- 04. Find All Employees Except Engineers
SELECT first_name, last_name 
FROM employees
WHERE job_title NOT LIKE '%engineer%'
ORDER BY employee_id;

-- 05. Find Towns with Name Length
SELECT `name`
FROM `towns`
WHERE LENGTH(`name`) = 5 OR LENGTH(`name`) = 6
ORDER BY name ASC;

-- 06. Find Towns Starting With
SELECT `town_id`, `name`
FROM `towns`
WHERE `name` REGEXP('^[M|K|B|E]')
ORDER BY name ASC;

-- 07. Find Towns Not Starting With
SELECT `town_id`, `name`
FROM `towns`
WHERE `name` REGEXP('^[^R|B|D]')
ORDER BY name ASC;

-- 08. Create View Employees Hired After
CREATE VIEW v_employees_hired_after_2000 AS
SELECT 
    first_name, last_name
FROM
    employees
WHERE YEAR(hire_date) > 2000;

SELECT * FROM v_employees_hired_after_2000;

-- 09. Length of Last Name
SELECT first_name, last_name
FROM employees
WHERE character_length(last_name) = 5;

USE geography;
-- 10. Countries Holding 'A'
SELECT country_name, iso_code
FROM countries
WHERE country_name REGEXP '(a.*){3}'
ORDER BY iso_code;

-- 11. Mix of Peak and River Names
SELECT 
	p.peak_name, 
	r.river_name,
	LOWER(CONCAT(LEFT(p.peak_name, LENGTH(p.peak_name) - 1), r.river_name)) AS mix
FROM 
	rivers as r, 
	peaks as p
WHERE 
	UPPER(RIGHT(p.peak_name, 1)) = UPPER(LEFT(r.river_name, 1))
ORDER BY mix;

-- 12. Games From 2011 and 2012 Year
-- USE diablo
SELECT `name`, DATE_FORMAT(`start`, '%Y-%m-%d') AS `start`
FROM `games`
WHERE YEAR(`start`) IN (2011, 2012)
ORDER BY `start`, `name`
LIMIT 50;

-- 13. User Email Providers
SELECT 
	user_name,
	-- SUBSTRING_INDEX(email, '@', -1) AS `email provider`
	REGEXP_REPLACE(email, '.*@', '') AS `email provider`
FROM 
	users
ORDER BY
	`email provider`, user_name;

-- 14. Get Users with IP Address Like Pattern
SELECT user_name, ip_address
FROM users
WHERE ip_address LIKE '___.1%.%.___'
ORDER BY user_name;

-- 15. Show All Games with Duration
SELECT 
	name AS games,
	CASE 
	WHEN HOUR(start) BETWEEN 0 AND 11 THEN 'Morning'
	WHEN HOUR(start) BETWEEN 12 AND 17 THEN 'Afternoon'
	ELSE 'Evening' 
	END AS 'Part of the day',

	CASE
	WHEN duration <= 3 THEN 'Extra Short'
	WHEN duration BETWEEN 4 AND 6 THEN 'Short'
	WHEN duration BETWEEN 7 AND 10  THEN 'Long'
	ELSE 'Extra Long'
	END AS 'Duration'
FROM games
ORDER BY name;

-- 16. Orders Table
SELECT 
	product_name, 
	order_date, 
	DATE_ADD(order_date, INTERVAL 3 DAY) AS pay_due, 
	DATE_ADD(order_date, INTERVAL 1 MONTH) AS deliver_due
FROM orders;