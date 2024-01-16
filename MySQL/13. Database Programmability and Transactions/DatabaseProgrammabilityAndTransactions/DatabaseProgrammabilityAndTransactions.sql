USE soft_uni;
-- 13. Database Programmability and Transactions
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