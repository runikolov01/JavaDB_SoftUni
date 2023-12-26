CREATE TABLE people (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(200) NOT NULL,
    picture BLOB,
    height DOUBLE(10 , 2 ),
    weight DOUBLE(10 , 2 ),
    gender CHAR(1) NOT NULL,
    birthdate DATE NOT NULL,
    biography TEXT
);

INSERT INTO people(name, gender, birthdate)
VALUES('Test', 'm', '20.08.2001'),
('dfdfdf', 'f', '20.08.2001'),
('ddffdf', 'm', '20.08.2001'),
('Rume4', 'm', '20.08.2001'),
('sdffdf', 'f', '20.08.2001');