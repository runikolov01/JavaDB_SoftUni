CREATE
    DATABASE online_store;
USE online_store;
DROP DATABASE online_store;

CREATE TABLE brands
(
    id   INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(40) NOT NULL UNIQUE
);

CREATE TABLE categories
(
    id   INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(40) NOT NULL UNIQUE
);

CREATE TABLE reviews
(
    id           INT PRIMARY KEY AUTO_INCREMENT,
    content      TEXT,
    rating       DECIMAL(10, 2) NOT NULL,
    picture_url  VARCHAR(80)    NOT NULL,
    published_at DATETIME       NOT NULL
);

CREATE TABLE products
(
    id                INT PRIMARY KEY AUTO_INCREMENT,
    name              VARCHAR(40)    NOT NULL,
    price             DECIMAL(19, 2) NOT NULL,
    quantity_in_stock INT,
    description       TEXT,
    brand_id          INT            NOT NULL,
    CONSTRAINT fk_products_brands
        FOREIGN KEY (brand_id)
            REFERENCES brands (id),
    category_id       INT            NOT NULL,
    CONSTRAINT fk_producs_categories
        FOREIGN KEY (category_id)
            REFERENCES categories (id),
    review_id         INT,
    CONSTRAINT fk_products_reviews
        FOREIGN KEY (review_id)
            REFERENCES reviews (id)
);

CREATE TABLE customers
(
    id            INT PRIMARY KEY AUTO_INCREMENT,
    first_name    VARCHAR(20) NOT NULL,
    last_name     VARCHAR(20) NOT NULL,
    phone         VARCHAR(30) NOT NULL UNIQUE,
    address       VARCHAR(60) NOT NULL,
    discount_card BIT(1)      NOT NULL
);

CREATE TABLE orders
(
    id             INT PRIMARY KEY AUTO_INCREMENT,
    order_datetime DATETIME NOT NULL,
    customer_id    INT      NOT NULL,
    CONSTRAINT fk_order_customers
        FOREIGN KEY (customer_id)
            REFERENCES customers (id)
);

CREATE TABLE orders_products
(
    order_id   INT,
    CONSTRAINT fk_orders_products_orders
        FOREIGN KEY (order_id)
            REFERENCES orders (id),
    product_id INT,
    CONSTRAINT fk_orders_products_products
        FOREIGN KEY (product_id)
            REFERENCES products (id)
);

-- 02. Insert
INSERT INTO reviews (content, rating, picture_url, published_at)
SELECT SUBSTRING(description, 1, 15),
       (price / 8),
       REVERSE(name),
       '2010-10-10'
FROM products
WHERE id >= 5;

-- 03. Update
UPDATE products
SET quantity_in_stock = quantity_in_stock - 5
WHERE quantity_in_stock >= 60
  AND quantity_in_stock <= 70;

-- 04. Delete
DELETE customers
FROM customers
         LEFT JOIN orders o on customers.id = o.customer_id
WHERE customer_id IS NULL;

-- 05. Categories
SELECT *
FROM categories
ORDER BY name DESC;

-- 06. Quantity
SELECT id, brand_id, name, quantity_in_stock
FROM products
WHERE price > 1000
  AND quantity_in_stock < 30
ORDER BY quantity_in_stock, id;

-- 07. Review
SELECT *
FROM reviews
WHERE content LIKE 'My%'
  AND LENGTH(content) > 61
ORDER BY rating DESC;

-- 08. First customers
SELECT CONCAT_WS(' ', first_name, last_name) AS full_name,
       address,
       order_datetime                        AS order_date
FROM customers
         JOIN orders o on customers.id = o.customer_id
WHERE YEAR(order_datetime) <= 2018
ORDER BY full_name DESC;

-- 09. Best categories
SELECT COUNT(p.id)              AS items_count,
       c.name,
       SUM(p.quantity_in_stock) AS total_quantity
FROM products p
         JOIN categories c ON c.id = p.category_id
GROUP BY c.id, c.name
ORDER BY items_count DESC, total_quantity ASC
LIMIT 5;

-- 10. Extract client cards count
DELIMITER $$
CREATE FUNCTION udf_customer_products_count(name VARCHAR(30))
    RETURNS INT
    DETERMINISTIC
BEGIN
    RETURN (SELECT COUNT(o.order_datetime)
            FROM customers
                     JOIN orders o on customers.id = o.customer_id
                     JOIN orders_products op on o.id = op.order_id
            WHERE customers.first_name = name
            GROUP BY customer_id);
END $$
DELIMITER ;

-- 11. Reduce price
DELIMITER $$
CREATE PROCEDURE udp_reduce_price(category_name VARCHAR(50))
BEGIN
    UPDATE categories
        JOIN products p ON categories.id = p.category_id
        JOIN reviews r ON p.review_id = r.id
    SET price = price * 0.7
    WHERE categories.name = category_name
      AND rating < 4;
END $$