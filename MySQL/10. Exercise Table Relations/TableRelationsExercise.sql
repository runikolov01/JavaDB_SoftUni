-- 1. One-To-One Relationship
CREATE TABLE people (
    person_id INT UNIQUE NOT NULL AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    salary DECIMAL(10 , 2 ) DEFAULT 0,
    passport_id INT UNIQUE
);

CREATE TABLE passports (
    passport_id INT PRIMARY KEY AUTO_INCREMENT,
    passport_number VARCHAR(8) UNIQUE
);

ALTER TABLE people
ADD CONSTRAINT pk_people
PRIMARY KEY (person_id),
ADD CONSTRAINT  fk_people_passport
FOREIGN KEY (passport_id)
REFERENCES passports(passport_id);

INSERT INTO passports(passport_id, passport_number)
VALUES(101, 'N34FG21B'), (102, 'K65LO4R7'), (103, 'ZE657QP2');

INSERT INTO people(first_name, salary, passport_id)
VALUES('Roberto', 43300.00, 102), ('Tom', 56100.00, 103), ('Yana', 60200.00, 101);


SELECT 
    *
FROM
    passports;
SELECT 
    *
FROM
    people;
    
-- 02. One-To-Many Relationship
CREATE TABLE manufacturers (
    manufacturer_id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    name VARCHAR(50) UNIQUE NOT NULL,
    established_on DATETIME NOT NULL
);

CREATE TABLE models (
    model_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    manufacturer_id INT,
    CONSTRAINT fk_model_manufacturers FOREIGN KEY (manufacturer_id)
        REFERENCES manufacturers (manufacturer_id)
);

ALTER TABLE models AUTO_INCREMENT = 101;

INSERT INTO manufacturers(name, established_on)
VALUES('BMW', '1916-03-01'), ('Tesla', '2003-01-01'), ('Lada', '1966-05-01');

INSERT INTO models(name, manufacturer_id)
VALUES ('X1', 1), ('i6', 1), ('Model S', 2), ('Model X', 2),  ('Model 3', 2), ('Nova', 3);

-- 3. Many-To-Many Relationship
CREATE TABLE students (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL
);

CREATE TABLE exams (
    exam_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL
)  AUTO_INCREMENT=101;


CREATE TABLE students_exams (
    student_id INT,
    exam_id INT,
    CONSTRAINT pk_students_exams PRIMARY KEY (student_id , exam_id),
    CONSTRAINT fk_students_exams FOREIGN KEY (exam_id)
        REFERENCES exams (exam_id),
    CONSTRAINT fk_exams_students FOREIGN KEY (student_id)
        REFERENCES students (student_id)
);

INSERT INTO students(name)
VALUES('Mila'), ('Toni'), ('Ron');

INSERT INTO exams(name)
VALUE('Spring MVC'), ('Neo4j'), ('Oracle 11g');

INSERT INTO students_exams
VALUES(1, 101), (1, 102), (2, 101), (3, 103), (2, 102), (2, 103);

SELECT 
    *
FROM
    students;
SELECT 
    *
FROM
    exams;
SELECT 
    *
FROM
    students_exams;