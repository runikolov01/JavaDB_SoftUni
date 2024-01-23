-- 01. Table Design
CREATE DATABASE softuni_imdb;
USE softuni_imdb;
DROP DATABASE softuni_imdb;


CREATE TABLE countries
(
    id        INT PRIMARY KEY AUTO_INCREMENT,
    name      VARCHAR(30) NOT NULL UNIQUE,
    continent VARCHAR(30) NOT NULL,
    currency  VARCHAR(5)  NOT NULL
);

CREATE TABLE genres
(
    id   INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE actors
(
    id         INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name  VARCHAR(50) NOT NULL,
    birthdate  DATE        NOT NULL,
    height     INT,
    awards     INT,
    country_id INT         NOT NULL,
    CONSTRAINT fk_actors_countries
        FOREIGN KEY (country_id)
            REFERENCES countries (id)
);

CREATE TABLE movies_additional_info
(
    id            INT PRIMARY KEY AUTO_INCREMENT,
    rating        DECIMAL(10, 2) NOT NULL,
    runtime       INT            NOT NULL,
    picture_url   VARCHAR(80)    NOT NULL,
    budget        DECIMAL(10, 2),
    release_date  DATE           NOT NULL,
    has_subtitles TINYINT(1),
    description   TEXT
);

CREATE TABLE movies
(
    id            INT PRIMARY KEY AUTO_INCREMENT,
    title         VARCHAR(70) NOT NULL UNIQUE,
    country_id    INT,
    CONSTRAINT fk_movies_countries
        FOREIGN KEY (country_id)
            REFERENCES countries (id),
    movie_info_id INT         NOT NULL UNIQUE,
    CONSTRAINT fk_movies_additional_info
        FOREIGN KEY (movie_info_id)
            REFERENCES movies_additional_info (id)
);

CREATE TABLE movies_actors
(
    movie_id INT,
    CONSTRAINT fk_movies_actors_movies
        FOREIGN KEY (movie_id)
            REFERENCES movies (id),
    actor_id INT,
    CONSTRAINT fk_movies_actors_movies_actors
        FOREIGN KEY (actor_id)
            REFERENCES actors (id)
);

CREATE TABLE genres_movies
(
    genre_id INT,
    CONSTRAINT fk_genres_movies_genres
        FOREIGN KEY (genre_id)
            REFERENCES genres (id),
    movie_id INT,
    CONSTRAINT fk_genres_movies_movies
        FOREIGN KEY (movie_id)
            REFERENCES movies (id)
);

-- 02. Insert
INSERT INTO actors(first_name, last_name, birthdate, height, awards, country_id)
    (SELECT REVERSE(first_name),
            REVERSE(last_name),
            DATE_SUB(birthdate, INTERVAL 2 DAY),
            (height + 10),
            country_id,
            (3)
     FROM actors
     WHERE actors.id <= 10);

-- 03.	Update
UPDATE movies_additional_info
SET runtime = runtime - 10
WHERE id >= 15
  AND id <= 25;

-- 04. Delete
DELETE countries
FROM countries
         LEFT JOIN movies m on countries.id = m.country_id
WHERE country_id IS NULL;

-- 05. Countries
SELECT *
FROM countries
ORDER BY currency DESC, id;

-- 06. Old movies
SELECT movies_additional_info.id, title, runtime, budget, release_date
FROM movies_additional_info
         JOIN movies m on movies_additional_info.id = m.movie_info_id
WHERE YEAR(release_date) BETWEEN 1996 AND 1999
ORDER BY runtime, id
LIMIT 20;

-- 07. Movie casting
SELECT CONCAT(first_name, ' ', last_name)                                AS full_name,
       CONCAT(REVERSE(last_name), LENGTH(actors.last_name), '@cast.com') AS email,
       (2022 - YEAR(birthdate))                                          AS age,
       height
FROM actors
         LEFT JOIN movies_actors ma on actors.id = ma.actor_id
WHERE movie_id IS NULL
ORDER BY height ASC;

-- 08. International festival
SELECT name, COUNT(m.id) AS movies_count
FROM countries
         JOIN movies m on countries.id = m.country_id
GROUP BY countries.id
HAVING movies_count >= 7
ORDER BY name DESC;

-- 09. Rating system
SELECT title,
       CASE
           WHEN (rating) <= 4 THEN 'poor'
           WHEN (rating) > 4 and rating <= 7 THEN 'good'
           ELSE 'excellent'
           END AS rating,
       CASE
           WHEN (has_subtitles) = 0 THEN '-'
           ELSE 'english'
           END AS subtitles,
       budget
FROM movies
         JOIN movies_additional_info mai on movies.movie_info_id = mai.id
ORDER BY budget DESC;

-- 10. History movies
DELIMITER $$
CREATE FUNCTION udf_actor_history_movies_count(full_name VARCHAR(50))
    RETURNS INT
    DETERMINISTIC
BEGIN
    RETURN (SELECT COUNT(a.id)
            FROM movies
                     JOIN movies_actors ma on movies.id = ma.movie_id
                     JOIN actors a on ma.actor_id = a.id
                     JOIN genres_movies gm on movies.id = gm.movie_id
                     JOIN genres g on gm.genre_id = g.id
            WHERE first_name = SUBSTRING_INDEX(full_name, ' ', 1)
              AND g.name = 'History');
END $$
DELIMITER ;

-- 11. Movie awards
DELIMITER $$
CREATE PROCEDURE udp_award_movie(movie_title VARCHAR(50))
BEGIN
    UPDATE actors
        JOIN movies_actors ma on actors.id = ma.actor_id
        JOIN movies m on ma.movie_id = m.id
    SET awards = awards + 1
    WHERE m.title = movie_title;
END $$
DELIMITER ;