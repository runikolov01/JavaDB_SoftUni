-- 01. Table Design
CREATE
    DATABASE universities;

USE
    universities;

CREATE TABLE countries
(
    id   INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(40) NOT NULL UNIQUE
);

CREATE TABLE cities
(
    id         INT PRIMARY KEY AUTO_INCREMENT,
    name       VARCHAR(40) NOT NULL UNIQUE,
    population INT,
    country_id INT         NOT NULL,
    CONSTRAINT fk_cities_countries
        FOREIGN KEY (country_id)
            REFERENCES countries (id)
);

CREATE TABLE universities
(
    id              INT PRIMARY KEY AUTO_INCREMENT,
    name            VARCHAR(60) UNIQUE,
    address         VARCHAR(80)    NOT NULL UNIQUE,
    tuition_fee     DECIMAL(19, 2) NOT NULL,
    number_of_staff INT,
    city_id         INT,
    CONSTRAINT fk_universities_cities
        FOREIGN KEY (city_id)
            REFERENCES cities (id)
);

CREATE TABLE students
(
    id           INT PRIMARY KEY AUTO_INCREMENT,
    first_name   VARCHAR(40)  NOT NULL,
    last_name    VARCHAR(40)  NOT NULL,
    age          INT,
    phone        VARCHAR(20)  NOT NULL UNIQUE,
    email        VARCHAR(255) NOT NULL UNIQUE,
    is_graduated TINYINT(1)   NOT NULL,
    city_id      INT,
    CONSTRAINT fk_students_cities
        FOREIGN KEY (city_id)
            REFERENCES cities (id)
);

CREATE TABLE courses
(
    id             INT PRIMARY KEY AUTO_INCREMENT,
    name           VARCHAR(40) NOT NULL UNIQUE,
    duration_hours DECIMAL(19, 2),
    start_date     DATE,
    teacher_name   VARCHAR(60) NOT NULL UNIQUE,
    description    TEXT,
    university_id  INT,
    CONSTRAINT fk_courses_universities
        FOREIGN KEY (university_id)
            REFERENCES universities (id)
);

CREATE TABLE students_courses
(
    grade      DECIMAL(19, 2) NOT NULL,
    student_id INT            NOT NULL,
    CONSTRAINT fk_students_courses
        FOREIGN KEY (student_id)
            REFERENCES students (id),
    course_id  INT            NOT NULL,
    CONSTRAINT fk_courses_students
        FOREIGN KEY (course_id)
            REFERENCES courses (id)
);

-- 02. Insert
INSERT INTO courses (name, duration_hours, start_date, teacher_name, description, university_id)
SELECT CONCAT(teacher_name, ' course'),
       (LENGTH(name) / 10),
       DATE_ADD(start_date, INTERVAL 5 DAY),
       REVERSE(teacher_name),
       CONCAT('Course ', teacher_name, REVERSE(description)),
       DAY(start_date)
FROM courses
WHERE id <= 5;

-- 03. Update
UPDATE universities
SET tuition_fee = tuition_fee + 300
WHERE id BETWEEN 5 AND 12;

-- 04. Delete
DELETE
FROM universities
WHERE number_of_staff IS NULL;

-- 05. Cities
SELECT *
FROM cities
ORDER BY population DESC;

-- 06. Students age
SELECT first_name, last_name, age, phone, email
FROM students
WHERE age >= 21
ORDER BY first_name DESC, email ASC, id ASC
LIMIT 10;

-- 07. New students
SELECT CONCAT(s.first_name, ' ', s.last_name) AS full_name,
       SUBSTRING(email, 2, 10)                AS username,
       reverse(phone)                         AS password
FROM students s
         LEFT JOIN students_courses sc ON s.id = sc.student_id
WHERE sc.student_id IS NULL
ORDER BY password DESC;

-- 08.	Students count
SELECT
    COUNT(students_courses.student_id) AS students_count,
    universities.name AS university_name
FROM students_courses
         JOIN courses ON students_courses.course_id = courses.id
         JOIN universities ON courses.university_id = universities.id
GROUP BY universities.name
HAVING students_count >= 8
ORDER BY students_count DESC, university_name DESC;

-- 09.	Price rankings
SELECT
    u.name AS university_name,
    c.name AS city_name,
    address,
    CASE
        WHEN tuition_fee < 800 THEN 'cheap'
        WHEN tuition_fee >= 800 AND tuition_fee < 1200 THEN 'normal'
        WHEN tuition_fee >= 1200 AND tuition_fee < 2500 THEN 'high'
        ELSE 'expensive'
        END AS price_rank,
    tuition_fee
FROM universities u
JOIN cities c on u.city_id = c.id
ORDER BY tuition_fee ASC;