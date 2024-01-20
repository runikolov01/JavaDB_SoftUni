-- 01. Table Design
CREATE DATABASE airlines;
USE airlines;
-- DROP DATABASE airlines;

CREATE TABLE countries
(
    id          INT PRIMARY KEY AUTO_INCREMENT,
    name        VARCHAR(30) NOT NULL UNIQUE,
    description TEXT,
    currency    VARCHAR(5)  NOT NULL
);

CREATE TABLE airplanes
(
    id                  INT PRIMARY KEY AUTO_INCREMENT,
    model               VARCHAR(50)    NOT NULL UNIQUE,
    passengers_capacity INT            NOT NULL,
    tank_capacity       DECIMAL(19, 2) NOT NULL,
    cost                DECIMAL(19, 2) NOT NULL
);

CREATE TABLE passengers
(
    id         INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(30) NOT NULL,
    last_name  VARCHAR(30) NOT NULL,
    country_id INT         NOT NULL,
    CONSTRAINT fk_passengers_countries
        FOREIGN KEY (country_id)
            REFERENCES countries (id)
);

CREATE TABLE flights
(
    id                  INT PRIMARY KEY AUTO_INCREMENT,
    flight_code         VARCHAR(30) NOT NULL UNIQUE,
    departure_country   INT         NOT NULL,
    CONSTRAINT fk_flight_country
        FOREIGN KEY (departure_country)
            REFERENCES countries (id),
    destination_country INT         NOT NULL,
    CONSTRAINT fk_flight_destination FOREIGN KEY (destination_country)
        REFERENCES countries (id),
    airplane_id         INT         NOT NULL,
    CONSTRAINT fk_flight_airplane FOREIGN KEY (airplane_id)
        REFERENCES airplanes (id),
    has_delay           TINYINT(1),
    departure           DATETIME
);

CREATE TABLE flights_passengers
(
    flight_id    INT,
    CONSTRAINT FOREIGN KEY (flight_id)
        REFERENCES flights (id),
    passenger_id INT,
    CONSTRAINT FOREIGN KEY (passenger_id)
        REFERENCES passengers (id)
);

-- 02. Insert
INSERT INTO airplanes (model, passengers_capacity, tank_capacity, cost)
SELECT
    CONCAT(REVERSE(first_name), '797') AS model,
    (LENGTH(last_name) * 17) AS passengers_capacity,
    (id * 790) AS tank_capacity,
    (LENGTH(first_name) * 50.6) AS cost
FROM passengers
WHERE id <= 5;

-- 03. Update
UPDATE flights
SET airplane_id = airplane_id + 1
WHERE departure_country = 22;