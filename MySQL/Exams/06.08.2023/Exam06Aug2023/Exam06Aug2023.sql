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