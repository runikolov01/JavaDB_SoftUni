-- 1. Mountains and Peaks
CREATE DATABASE mount_peaks;

CREATE TABLE mountains (
    id INT AUTO_INCREMENT NOT NULL,
    `name` VARCHAR(100) NOT NULL,
    CONSTRAINT pk_mountains_id PRIMARY KEY (id)
);

USE mount_peaks;
INSERT INTO mountains(`name`) VALUES ('Rila'), ('Pirin');

SELECT 
    *
FROM
    mountains;

CREATE TABLE peaks (
    id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    `name` VARCHAR(100) NOT NULL,
    mountain_id INT NOT NULL,
    CONSTRAINT fk_peaks_mpuntain_id_mountains_id FOREIGN KEY (mountain_id)
        REFERENCES mountains (id)
);

INSERT INTO peaks(`name`, mountain_id)
VALUES('Musala', 1), ('Vihren', 2);

SELECT 
    *
FROM
    peaks;
    
-- 2. Trip Organization
USE camp;
SELECT 
    driver_id,
    vehicle_type,
    CONCAT(first_name, ' ', last_name) AS 'driver_name'
FROM
    vehicles
        JOIN
    campers ON driver_id = campers.id;
    
-- 3. SoftUni Hiking


-- 4. Delete Mountains
USE mount_peaks;
DROP TABLE peaks;
DROP TABLE mountains;

CREATE TABLE mountains (
    id INT AUTO_INCREMENT NOT NULL,
    `name` VARCHAR(100) NOT NULL,
    CONSTRAINT pk_mountains_id PRIMARY KEY (id)
);

CREATE TABLE peaks (
    id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    `name` VARCHAR(100) NOT NULL,
    mountain_id INT NOT NULL,
    CONSTRAINT fk_peaks_mountain_id_mountains_id FOREIGN KEY (mountain_id)
        REFERENCES mountains (id)
        ON DELETE CASCADE
);