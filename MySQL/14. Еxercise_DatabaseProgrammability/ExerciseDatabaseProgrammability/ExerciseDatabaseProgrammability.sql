USE soft_uni;
SET GLOBAL log_bin_trust_function_creators = 1; -- Приема  в себе си 0 или 1, защото тя съдържа в себе си boolean. Глобално слагаме променливата. Правим го, за да предотвратим бъдещи грешки при работа с функции/процедури и т.н.
SET SQL_SAFE_UPDATES = 0;

-- 01. Employees with Salary Above 35000
DELIMITER $$
CREATE PROCEDURE usp_get_employees_salary_above_35000()
BEGIN
    SELECT first_name, last_name
    FROM employees
    WHERE salary > 35000
    ORDER BY first_name ASC, last_name ASC, employee_id ASC;
END$$
DELIMITER ;

-- 02. Employees with Salary Above Number
DELIMITER $$
CREATE PROCEDURE usp_get_employees_salary_above(salary_number DECIMAL(19, 4))
BEGIN
    SELECT employees.first_name, employees.last_name
    FROM employees

    WHERE salary >= salary_number
    ORDER BY first_name ASC, last_name ASC, employee_id ASC;
END$$
DELIMITER ;

-- 03. Town Names Starting With
DELIMITER $$
CREATE PROCEDURE usp_get_towns_starting_with(string VARCHAR(50))
BEGIN
    SELECT towns.name
    FROM towns
    WHERE name LIKE CONCAT(string, '%')
    ORDER BY name ASC;
END$$
DELIMITER ;

-- 4. Employees from Town
DELIMITER $$
CREATE PROCEDURE usp_get_employees_from_town(town VARCHAR(50))
BEGIN
    SELECT employees.first_name, employees.last_name
    FROM employees
             JOIN addresses ON employees.address_id = addresses.address_id
             JOIN towns ON addresses.town_id = towns.town_id
    WHERE towns.name = town
    ORDER BY first_name ASC, last_name ASC, employee_id ASC;
END$$
DELIMITER ;