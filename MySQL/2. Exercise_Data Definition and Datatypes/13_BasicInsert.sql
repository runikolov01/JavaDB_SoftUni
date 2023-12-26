CREATE DATABASE soft_uni;

CREATE TABLE towns (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL
);

INSERT INTO towns (name) VALUES
('Sofia'),
('Plovdiv'),
('Varna'),
('Burgas');

CREATE TABLE addresses (
    id INT PRIMARY KEY AUTO_INCREMENT,
    address_text TEXT,
    town_id INT,
    FOREIGN KEY (town_id)
        REFERENCES towns (id)
);

CREATE TABLE departments (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL
);

INSERT INTO departments (name) VALUES
('Engineering'),
('Sales'),
('Marketing'),
('Software Development'),
('Quality Assurance');

CREATE TABLE employees (
    id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    middle_name VARCHAR(50),
    last_name VARCHAR(50) NOT NULL,
    job_title VARCHAR(50) NOT NULL,
    department_id INT,
    FOREIGN KEY (department_id)
        REFERENCES departments (id),
    hire_date DATE,
    salary DOUBLE,
    address_id INT,
    FOREIGN KEY (address_id)
        REFERENCES addresses (id)
);
INSERT INTO employees (first_name, middle_name, last_name, job_title, department_id, hire_date, salary, address_id) VALUES
('Ivan', 'Ivanov', 'Ivanov', '.NET Developer', 4, '2013-02-01', 3500.00, NULL),
('Petar', 'Petrov', 'Petrov', 'Senior Engineer', 1, '2004-03-02', 4000.00, NULL),
('Maria', 'Petrova', 'Ivanova', 'Intern', 5, '2016-08-28', 525.25, NULL),
('Georgi', 'Terziev', 'Ivanov', 'CEO', 2, '2007-12-09', 3000.00, NULL),
('Peter', 'Pan', 'Pan', 'Intern', 3, '2016-08-28', 599.88, NULL);