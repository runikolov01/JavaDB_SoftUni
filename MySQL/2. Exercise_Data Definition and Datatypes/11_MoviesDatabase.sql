CREATE DATABASE movies;
USE movies;

CREATE TABLE directors (
    id INT PRIMARY KEY AUTO_INCREMENT,
    director_name VARCHAR(50) NOT NULL,
    notes TEXT
);
INSERT INTO directors(director_name)
VALUES ('test1'),('test2'),('test3'),('test4'),('test5');

CREATE TABLE genres (
    id INT PRIMARY KEY AUTO_INCREMENT,
    genre_name VARCHAR(50) NOT NULL,
    notes TEXT
);
INSERT INTO genres(genre_name)
VALUES ('test1'),('test2'),('test3'),('test4'),('test5');

CREATE TABLE categories (
    id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(20) NOT NULL,
    notes TEXT
);
INSERT INTO categories(category_name)
VALUES ('test1'),('test2'),('test3'),('test4'),('test5');

CREATE TABLE movies (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(50) NOT NULL,
    director_id INT,
    copyright_year YEAR,
    length DOUBLE(10 , 2 ),
    genre_id INT,
    category_id INT,
    rating DOUBLE(3 , 2 ),
    notes TEXT,
    FOREIGN KEY (director_id)
        REFERENCES directors (id),
    FOREIGN KEY (genre_id)
        REFERENCES genres (id),
    FOREIGN KEY (category_id)
        REFERENCES categories (id)
);
INSERT INTO movies(title, director_id, genre_id, category_id)
VALUES ('test1', 1, 2, 3),('test2', 1, 2, 5),('test3', 1, 2, 4),('test4', 1, 2, 3),('test5', 1, 2, 3);