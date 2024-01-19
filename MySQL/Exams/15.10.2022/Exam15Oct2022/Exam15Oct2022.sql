-- 01. Table Design


CREATE
    DATABASE restaurants;


CREATE TABLE products
(
    id    INT PRIMARY KEY AUTO_INCREMENT,
    name  VARCHAR(30)    NOT NULL UNIQUE,
    type  VARCHAR(30)    NOT NULL,
    price DECIMAL(10, 2) NOT NULL
);

CREATE TABLE clients
(
    id         INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name  VARCHAR(50) NOT NULL,
    birthdate  DATE        NOT NULL,
    card       VARCHAR(50),
    review     TEXT
);

CREATE TABLE `tables`
(
    id       INT PRIMARY KEY AUTO_INCREMENT,
    floor    INT NOT NULL,
    reserved TINYINT(1),
    capacity INT NOT NULL
);

CREATE TABLE waiters
(
    id         INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name  VARCHAR(50) NOT NULL,
    email      VARCHAR(50) NOT NULL,
    phone      VARCHAR(50),
    salary     DECIMAL(10, 2)
);

CREATE TABLE orders
(
    id           INT PRIMARY KEY AUTO_INCREMENT,
    table_id     INT  NOT NULL,
    waiter_id    INT  NOT NULL,
    order_time   TIME NOT NULL,
    payed_status TINYINT(1),
    FOREIGN KEY (table_id)
        REFERENCES `tables` (id),
    FOREIGN KEY (waiter_id)
        REFERENCES waiters (id)
);

CREATE TABLE orders_clients
(
    order_id  INT,
    FOREIGN KEY (order_id)
        REFERENCES orders (id),
    client_id INT,
    FOREIGN KEY (client_id)
        REFERENCES clients (id)
);

CREATE TABLE orders_products
(
    order_id   INT,
    FOREIGN KEY (order_id)
        REFERENCES orders (id),
    product_id INT,
    FOREIGN KEY (product_id)
        REFERENCES products (id)
);

USE restaurants;

-- 02. Insert

INSERT INTO products(name, type, price)
    (SELECT CONCAT(last_name, ' specialty'),
            'Cocktail',
            CEILING(0.01 * salary)
     FROM waiters
     WHERE id > 6);

-- 03. Update
UPDATE orders
SET table_id = table_id - 1
WHERE id BETWEEN 12 AND 23;

-- 04. Delete
DELETE
FROM waiters AS w
WHERE (SELECT COUNT(*) FROM orders WHERE waiter_id = w.id) = 0;

-- 05. Clients
SELECT *
FROM clients
ORDER BY birthdate DESC, id DESC;

-- 06. Birthdate
SELECT first_name, last_name, birthdate, review
FROM clients
WHERE card IS NULL
  AND YEAR(birthdate) BETWEEN 1978 AND 1993
ORDER BY last_name DESC, id ASC
LIMIT 5;

-- 07. Accounts
SELECT CONCAT(last_name, first_name, LENGTH(first_name), 'Restaurant') AS username,
       REVERSE(SUBSTRING(email, 2, 12))                                AS password
FROM waiters
WHERE salary IS NOT NULL
ORDER BY password DESC;

-- 08. Top from menu
SELECT id, name, COUNT(product_id) AS count
FROM products
         JOIN orders_products op on products.id = op.product_id
GROUP BY product_id, name
HAVING count > 4
ORDER BY count DESC, name ASC;

-- 09. Availability
SELECT t.id                AS table_id,
       t.capacity,
       COUNT(oc.client_id) AS count_clients,
       (
           IF(capacity > COUNT(oc.client_id), 'Free seats',
              IF(capacity = COUNT(oc.client_id), 'Full', 'Extra seats'))
           )               AS Availability
FROM tables AS t
         JOIN orders o on t.id = o.table_id
         JOIN orders_clients oc on o.id = oc.order_id
WHERE floor = 1
GROUP BY t.id
ORDER BY t.id DESC;

-- 10. Extract bill
DELIMITER $$
CREATE FUNCTION udf_client_bill(full_name VARCHAR(50))
    RETURNS DECIMAL(19, 2)
    DETERMINISTIC
BEGIN
    DECLARE space_index INT;
    SET space_index := LOCATE(' ', full_name);

    RETURN (SELECT SUM(p.price) AS bill
            FROM clients
                     JOIN orders_clients oc on clients.id = oc.client_id
                     JOIN orders o on oc.order_id = o.id
                     JOIN orders_products op on o.id = op.order_id
                     JOIN products p on op.product_id = p.id
            WHERE clients.first_name = SUBSTRING(full_name, 1, space_index - 1)
              AND clients.last_name = SUBSTRING(full_name, space_index + 1));
END$$

-- 11. Happy hour
DELIMITER $$
CREATE PROCEDURE udp_happy_hour(`type` VARCHAR(50))
BEGIN
    UPDATE products
    SET price = price * 0.8
    WHERE price >= 10
      AND products.type = `type`;
END$$