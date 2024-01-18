USE soft_uni;
SET GLOBAL log_bin_trust_function_creators = 1; -- Приема  в себе си 0 или 1, защото тя съдържа в себе си boolean. Глобално слагаме променливата. Правим го, за да предотвратим бъдещи грешки при работа с функции/процедури и т.н.
SET SQL_SAFE_UPDATES = 0;

-- 01. Employees with Salary Above 35000
DELIMITER $$
CREATE PROCEDURE usp_get_employees_salary_above_35000()
    BEGIN
SELECT first_name, last_name FROM employees
WHERE salary > 35000
ORDER BY first_name ASC, last_name ASC, employee_id ASC;
END$$