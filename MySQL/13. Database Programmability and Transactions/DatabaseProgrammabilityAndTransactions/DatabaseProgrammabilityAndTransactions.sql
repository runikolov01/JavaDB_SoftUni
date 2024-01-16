USE soft_uni;
-- 1. Count Employees by Town
DELIMITER $$
CREATE FUNCTION ufn_count_employees_by_town(`town_name` VARCHAR(50))
    RETURNS INT
    DETERMINISTIC
BEGIN
    DECLARE e_count INT;
    SET e_count := (SELECT COUNT(
                                   addresses.address_id)
                    FROM addresses
                             JOIN employees e on addresses.address_id = e.address_id
                             JOIN towns ON addresses.town_id = towns.town_id
                    WHERE towns.name = `town_name`);
    RETURN e_count;
END$$

-- 2. Employees Promotion
DELIMITER $$
CREATE PROCEDURE usp_raise_salaries(department_name VARCHAR(50))
BEGIN
    UPDATE employees
    SET salary = salary * 1.05
    WHERE department_id = (SELECT department_id
                           FROM departments
                           WHERE `name` = department_name);
END$$
DELIMITER ;

-- 3. Employees Promotion By ID
CREATE PROCEDURE usp_raise_salary_by_id(id INT)
BEGIN
    DECLARE employee_id_count INT;
    SET employee_id_count := (SELECT COUNT(*) FROM employees WHERE employee_id = id);
    IF (employee_id_count = 1)
    THEN
        UPDATE employees SET salary = salary * 1.05 WHERE employee_id = id;
    END IF;
END;