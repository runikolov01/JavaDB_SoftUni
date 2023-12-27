CREATE DATABASE car_rental;
USE car_rental;

CREATE TABLE categories (
    id INT PRIMARY KEY AUTO_INCREMENT,
    category VARCHAR(50) NOT NULL,
    daily_rate DECIMAL(10 , 2 ) NOT NULL,
    weekly_rate DECIMAL(10 , 2 ) NOT NULL,
    monthly_rate DECIMAL(10 , 2 ) NOT NULL,
    weekend_rate DECIMAL(10 , 2 ) NOT NULL
);

CREATE TABLE cars (
    id INT PRIMARY KEY AUTO_INCREMENT,
    plate_number VARCHAR(20) NOT NULL,
    make VARCHAR(50) NOT NULL,
    model VARCHAR(50) NOT NULL,
    car_year YEAR NOT NULL,
    category_id INT,
    doors INT NOT NULL,
    picture BLOB,
    car_condition VARCHAR(10),
    available BOOLEAN NOT NULL
);

CREATE TABLE employees (
    id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    title VARCHAR(30) NOT NULL,
    notes TEXT
);

CREATE TABLE customers (
    id INT PRIMARY KEY AUTO_INCREMENT,
    driver_license_number VARCHAR(20) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    address VARCHAR(100) NOT NULL,
    city VARCHAR(50) NOT NULL,
    zip_code VARCHAR(20) NOT NULL,
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
    rate_applied DECIMAL(10 , 2 ),
    tax_rate DECIMAL(5 , 2 ),
    order_status BOOLEAN,
    notes TEXT
);

INSERT INTO categories (category, daily_rate, weekly_rate, monthly_rate, weekend_rate) VALUES
('Economy', 30.00, 150.00, 500.00, 40.00),
('Compact', 35.00, 175.00, 550.00, 45.00),
('SUV', 40.00, 200.00, 600.00, 50.00);

INSERT INTO cars (plate_number, make, model, car_year, category_id, doors, car_condition, available) VALUES
('ABC123', 'Toyota', 'Corolla', 2022, 1, 4, 'Good', TRUE),
('XYZ789', 'Honda', 'Civic', 2021, 2, 4, 'Excellent', TRUE),
('123DEF', 'Ford', 'Escape', 2020, 3, 5, 'Fair', TRUE);

INSERT INTO employees (first_name, last_name, title, notes) VALUES
('John', 'Doe', 'Manager', 'Responsible for car rentals'),
('Jane', 'Smith', 'Sales Associate', 'Handles customer inquiries'),
('Bob', 'Johnson', 'Mechanic', 'Performs car maintenance');

INSERT INTO customers (driver_license_number, full_name, address, city, zip_code, notes) VALUES
('DL123456', 'Alice Johnson', '123 Main St', 'Cityville', '12345', 'Regular customer'),
('DL654321', 'Bob Anderson', '456 Oak St', 'Townsville', '67890', 'Corporate client'),
('DL789012', 'Charlie Brown', '789 Pine St', 'Villagetown', '54321', 'Frequent renter');

INSERT INTO rental_orders (employee_id, customer_id, car_id, car_condition, tank_level,
    kilometrage_start, kilometrage_end, total_kilometrage, start_date, end_date,
    total_days, rate_applied, tax_rate, order_status, notes) VALUES
(1, 1, 1, 'Clean', 'Full', 10000, 10200, 200, '2023-01-01', '2023-01-03', 2, 35.00, 0.1, TRUE, 'First rental'),
(2, 2, 2, 'Excellent', 'Full', 20000, 20450, 450, '2023-02-15', '2023-02-20', 5, 40.00, 0.12, TRUE, 'Corporate rental'),
(3, 3, 3, 'Fair', 'Three-quarters', 15000, 15250, 250, '2023-03-10', '2023-03-15', 5, 30.00, 0.08, TRUE, 'Regular customer rental');
