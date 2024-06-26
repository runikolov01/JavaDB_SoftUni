-- 01. Table Design
CREATE DATABASE real_estate;
USE real_estate;
DROP DATABASE real_estate;

CREATE TABLE cities
(
    id   INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(60) NOT NULL UNIQUE
);

CREATE TABLE property_types
(
    id          INT PRIMARY KEY AUTO_INCREMENT,
    `type`      VARCHAR(40) NOT NULL UNIQUE,
    description TEXT
);

CREATE TABLE properties
(
    id               INT PRIMARY KEY AUTO_INCREMENT,
    address          VARCHAR(80)    NOT NULL UNIQUE,
    price            DECIMAL(19, 2) NOT NULL,
    area             DECIMAL(19, 2),
    property_type_id INT,
    CONSTRAINT fk_properties_property_types
        FOREIGN KEY (property_type_id)
            REFERENCES property_types (id),
    city_id          INT,
    CONSTRAINT fk_properties_cities
        FOREIGN KEY (city_id)
            REFERENCES cities (id)
);

CREATE TABLE agents
(
    id         INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(40) NOT NULL,
    last_name  VARCHAR(40) NOT NULL,
    phone      VARCHAR(20) NOT NULL UNIQUE,
    email      VARCHAR(50) NOT NULL UNIQUE,
    city_id    INT,
    CONSTRAINT fk_agents_cities
        FOREIGN KEY (city_id)
            REFERENCES cities (id)
);

CREATE TABLE buyers
(
    id         INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(40) NOT NULL,
    last_name  VARCHAR(40) NOT NULL,
    phone      VARCHAR(20) NOT NULL UNIQUE,
    email      VARCHAR(50) NOT NULL UNIQUE,
    city_id    INT,
    CONSTRAINT fk_buyers_cities
        FOREIGN KEY (city_id)
            REFERENCES cities (id)
);

CREATE TABLE property_offers
(
    property_id    INT,
    CONSTRAINT fk_property_offers_properties
        FOREIGN KEY (property_id)
            REFERENCES properties (id),
    agent_id       INT,
    CONSTRAINT fk_property_offers_agents
        FOREIGN KEY (agent_id)
            REFERENCES agents (id),
    price          DECIMAL(19, 2) NOT NULL,
    offer_datetime DATETIME
);

CREATE TABLE property_transactions
(
    id               INT PRIMARY KEY AUTO_INCREMENT,
    property_id      INT NOT NULL,
    CONSTRAINT fk_property_transactions_properties
        FOREIGN KEY (property_id)
            REFERENCES properties (id),
    buyer_id         INT,
    CONSTRAINT fk_property_transactions_buyers
        FOREIGN KEY (buyer_id)
            REFERENCES buyers (id),
    transaction_date DATE,
    bank_name        VARCHAR(30),
    iban             VARCHAR(40) UNIQUE,
    is_successful    TINYINT(1)
);

-- 02. Insert

INSERT INTO property_transactions(property_id, buyer_id, transaction_date, bank_name, iban, is_successful)
    (SELECT (agent_id + DAY(offer_datetime)),
            (agent_id + MONTH(offer_datetime)),
            DATE(offer_datetime),
            CONCAT('Bank ', agent_id),
            CONCAT('BG', price, agent_id),
            (1)
     FROM property_offers
     WHERE agent_id <= 2);

-- 03. Update
UPDATE properties
SET price = price - 50000
WHERE price >= 800000;

-- 04. Delete
DELETE property_transactions
FROM property_transactions
WHERE is_successful = 0;

-- 05. Agents
SELECT *
FROM agents
ORDER BY city_id DESC, phone DESC;

-- 06. Offers from 2021
SELECT *
FROM property_offers
WHERE YEAR(offer_datetime) = 2021
ORDER BY price ASC
LIMIT 10;

-- 07. Properties without offers
SELECT (SUBSTRING(address, 1, 6)) AS agent_name,
       (LENGTH(address) * 5430)   AS price
FROM properties
         LEFT JOIN property_offers po on properties.id = po.property_id
WHERE agent_id IS NULL
ORDER BY agent_name DESC, price DESC;

-- 08. Best Banks
SELECT bank_name, COUNT(iban) AS count
FROM property_transactions
GROUP BY bank_name
HAVING count >= 9
ORDER BY count DESC, bank_name ASC;

-- 09. Size of the area
SELECT address,
       area,
       CASE
           WHEN area <= 100 THEN 'small'
           WHEN area >= 101 AND area <= 200 THEN 'medium'
           WHEN area >= 201 AND area <= 500 THEN 'large'
           ELSE 'extra large'
           END AS size
FROM properties
ORDER BY area ASC, address DESC;

-- 10. Offers count in a city
DELIMITER $$
CREATE FUNCTION udf_offers_from_city_name(cityName VARCHAR(50))
    RETURNS INT
    DETERMINISTIC
BEGIN
    RETURN (SELECT COUNT(city_id)
            FROM cities
                     JOIN properties p on cities.id = p.city_id
                     JOIN property_offers po on p.id = po.property_id
            WHERE cities.name = cityName);
END $$
DELIMITER ;

-- 11. Special Offer
DELIMITER $$
CREATE PROCEDURE udp_special_offer(IN firstName VARCHAR(50))
BEGIN
    UPDATE property_offers
        JOIN agents a on property_offers.agent_id = a.id
    SET price = price * 0.9
    WHERE a.first_name = `firstName`;
END $$
DELIMITER ;