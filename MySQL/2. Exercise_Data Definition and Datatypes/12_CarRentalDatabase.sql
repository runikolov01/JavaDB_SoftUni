USE soft_uni;

CREATE DATABASE car_rental;
CREATE TABLE caregories (
    id INT PRIMARY KEY AUTO_INCREMENT,
    category VARCHAR(50),
    daily_rate DOUBLE,
    weekly_rate DOUBLE,
    monthly_rate DOUBLE,
    weekend_rate DOUBLE
);


CREATE TABLE cars (
    id INT PRIMARY KEY AUTO_INCREMENT,
    plate_number INT,
    make VARCHAR(50),
    model VARCHAR(50),
    car_year YEAR,
    category_id INT,
    doors INT,
    picture BLOB,
    car_condition VARCHAR(10),
    available BOOLEAN
);

CREATE TABLE employees (
    id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    title VARCHAR(30),
    notes TEXT
);

CREATE TABLE customers (
    id INT PRIMARY KEY AUTO_INCREMENT,
    driver_licence_number INT,
    full_name VARCHAR(100),
    address VARCHAR(100),
    city VARCHAR(50),
    zip_code INT,
    notes TEXT
);

CREATE TABLE rental_orders (
    id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id INT,
    customer_id INT,
    car_id INT,
    car_condition VARCHAR(50),
    tank_level VARCHAR(50),
    kilometrage_start INT,
    kilometrage_end INT,
    total_kilometrage INT,
    start_date DATE,
    end_date DATE,
    total_days INT,
    rate_applied DOUBLE,
    tax_rate DOUBLE,
    order_status BOOLEAN,
    notes TEXT
);

