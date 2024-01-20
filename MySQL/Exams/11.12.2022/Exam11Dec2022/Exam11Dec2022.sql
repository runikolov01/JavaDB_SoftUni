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
SELECT CONCAT(REVERSE(first_name), '797') AS model,
       (LENGTH(last_name) * 17)           AS passengers_capacity,
       (id * 790)                         AS tank_capacity,
       (LENGTH(first_name) * 50.6)        AS cost
FROM passengers
WHERE id <= 5;

-- 03. Update
UPDATE flights
SET airplane_id = airplane_id + 1
WHERE departure_country = 22;

-- 04. Delete
DELETE flights
FROM flights
         LEFT JOIN flights_passengers fp ON flights.id = fp.flight_id
WHERE fp.flight_id IS NULL;

-- 05. Airplanes
SELECT *
FROM airplanes
ORDER BY cost DESC, id DESC;

-- 06. Flights from 2022
SELECT flight_code, departure_country, airplane_id, departure
FROM flights
WHERE YEAR(departure) = 2022
ORDER BY airplane_id ASC, flight_code ASC
LIMIT 20;

-- 07. Private flights
SELECT UPPER(CONCAT(SUBSTRING(passengers.last_name, 1, 2), country_id)) AS flight_code,
       CONCAT(first_name, ' ', last_name)                               AS full_name,
       country_id
FROM passengers
         LEFT JOIN flights_passengers fp on passengers.id = fp.passenger_id
WHERE fp.flight_id IS NULL
ORDER BY country_id ASC;

-- 08. Leading destinations
SELECT c.name, c.currency, COUNT(flights_passengers.flight_id) AS booked_tickets
FROM flights
         JOIN flights_passengers ON flights.id = flights_passengers.flight_id
         JOIN countries c ON flights.destination_country = c.id
GROUP BY c.name, c.currency
HAVING booked_tickets >= 20
ORDER BY booked_tickets DESC;