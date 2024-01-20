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

-- 09. Parts of the day
SELECT flight_code,
       departure,
       CASE
           WHEN TIME(departure) >= '05:00:00' AND TIME(departure) <= '11:59:59' THEN 'Morning '
           WHEN TIME(departure) >= '12:00:00' AND TIME(departure) <= '16:59:59' THEN 'Afternoon '
           WHEN TIME(departure) >= '17:00:00' AND TIME(departure) <= '20:59:59' THEN 'Evening'
           WHEN TIME(departure) >= '21:00:00' OR TIME(departure) <= '04:59:59' THEN 'Night'
           END AS day_part
FROM flights
ORDER BY flight_code DESC;

-- 10. Number of flights
DELIMITER $$
CREATE FUNCTION udf_count_flights_from_country(country VARCHAR(50))
    RETURNS INT
    DETERMINISTIC
BEGIN
    DECLARE flight_count INT;

    SELECT COUNT(countries.id)
    INTO flight_count
    FROM countries
             JOIN flights f ON countries.id = f.departure_country
    WHERE countries.name = country;

    RETURN flight_count;
END$$
DELIMITER ;

-- 11. Delay flight
DELIMITER $$
CREATE PROCEDURE udp_delay_flight(code VARCHAR(50))
BEGIN
    UPDATE flights
    SET departure = DATE_ADD(departure, INTERVAL 30 MINUTE),
        has_delay = 1
    WHERE flight_code = code;
END $$

CALL udp_delay_flight('ZP-782')