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
USE camp;
SELECT 
    starting_point AS 'route_starting_point',
    end_point AS 'route_ending_point',
    leader_id,
    CONCAT(first_name, ' ', last_name) AS 'leader_name'
FROM
    routes
        JOIN
    campers ON routes.leader_id = campers.id;

SELECT * FROM campers;
SELECT * FROM routes;

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


-- 5. Project Management DB*
CREATE TABLE clients (
    id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    client_name VARCHAR(100)
);

CREATE TABLE projects (
    id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    client_id INT,
    project_lead_id INT,
    CONSTRAINT fk_projects_client_id_clients_id FOREIGN KEY (client_id)
        REFERENCES clients (id)
);

CREATE TABLE employees (
    id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    first_name VARCHAR(30),
    last_name VARCHAR(30),
    project_id INT,
    CONSTRAINT fk_employees_project_id_projects_id FOREIGN KEY (project_id)
        REFERENCES projects (id)
);

ALTER TABLE projects
ADD CONSTRAINT fk_projects_project_lead_id_employees_id
FOREIGN KEY(project_lead_id)
REFERENCES employees(id);