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
-- 05. Salary Level Function
CREATE FUNCTION ufn_get_salary_level(salaryNumber DECIMAL(19, 4))
    RETURNS VARCHAR(7)
    DETERMINISTIC
    RETURN (
        CASE
            WHEN salaryNumber < 30000 THEN 'Low'
            WHEN salaryNumber <= 50000 THEN 'Average'
            ELSE 'High'
            END
        );

-- 06. Employees by Salary Level
DELIMITER $$
CREATE PROCEDURE usp_get_employees_by_salary_level(level_salary VARCHAR(7))
BEGIN
    SELECT employees.first_name, employees.last_name
    FROM employees
    WHERE (salary < 30000 AND level_salary = 'Low')
       OR (salary >= 30000 AND salary <= 50000 AND level_salary = 'Average')
       OR (salary > 50000 AND level_salary = 'High')
    ORDER BY first_name DESC, last_name DESC;
END$$
DELIMITER ;

-- 07. Define Function
DELIMITER $$
CREATE FUNCTION ufn_is_word_comprised(set_of_letters varchar(50), word varchar(50))
    RETURNS VARCHAR(10)
BEGIN
    DECLARE result INT;
    set RESULT := (
        word REGEXP (CONCAT('^[', set_of_letters, ']+$'))
        );
    RETURN result;
END$$
DELIMITER ;

-- 8. Find Full Name
DELIMITER $$
CREATE PROCEDURE usp_get_holders_full_name()
BEGIN
    SELECT CONCAT_WS(' ', first_name, last_name) AS full_name
    FROM account_holders
    ORDER BY full_name;
END$$
DELIMITER ;

-- 09. People with Balance Higher Than
DELIMITER $$
CREATE PROCEDURE usp_get_holders_with_balance_higher_than(money DECIMAL(19, 4))
BEGIN
    SELECT account_holders.first_name, account_holders.last_name
    FROM account_holders
             JOIN accounts ON account_holders.id = accounts.account_holder_id
    GROUP BY account_holders.id
    HAVING SUM(balance) > money
    ORDER BY account_holders.id;
END$$
DELIMITER ;

-- 10. Future Value Function
CREATE FUNCTION ufn_calculate_future_value(initial_sum DECIMAL(19, 4), interest_rate_per_yeat DECIMAL(19, 4),
                                           number_of_years INT)
    RETURNS DECIMAL(19, 4)
    RETURN initial_sum * POW((1 + interest_rate_per_yeat), number_of_years);