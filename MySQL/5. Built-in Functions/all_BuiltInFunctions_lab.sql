-- 01. Find Book Titles
SELECT title 
FROM books
WHERE SUBSTRING(title, 1, 3) = 'The'
ORDER BY id;

-- 02. Replace Titles
SELECT REPLACE(title, 'The', '***') 
FROM books
WHERE SUBSTRING(title, 1, 3) = 'The'
ORDER BY id;