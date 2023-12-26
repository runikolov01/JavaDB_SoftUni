CREATE TABLE users(
	id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(30) UNIQUE NOT NULL,
    password VARCHAR(26) NOT NULL,
    prifile_picture BLOB,
    last_login_time DATETIME,
    is_deleted BOOLEAN
);

INSERT INTO users(username, password)
VALUES('rumenhco2', 'rumek232'),
('test', 'emmdd'),
('fkfd', 'ddffd'),
('fdfd', 'fdfd'),
('dffdfd', 'dokkokog')