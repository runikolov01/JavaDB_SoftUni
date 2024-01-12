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