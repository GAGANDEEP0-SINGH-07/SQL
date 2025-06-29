-- TASK 3 SOLUTION: BASIC SELECT QUERIES
-- Using the LibraryDB database

USE LibraryDB;


SELECT * FROM Authors;

SELECT title, publication_year FROM Books;

SELECT * FROM Books WHERE genre = 'Fantasy';

SELECT * FROM Books 
WHERE genre = 'Fantasy' AND publication_year > 1940;

SELECT * FROM Books 
WHERE genre = 'Fantasy' OR genre = 'Thriller';

SELECT * FROM Books 
WHERE title LIKE '%Potter%';

SELECT * FROM Books 
WHERE publication_year BETWEEN 1900 AND 2000;


SELECT * FROM Books 
ORDER BY title;


SELECT * FROM Books 
ORDER BY publication_year DESC;

SELECT * FROM Books 
ORDER BY genre, publication_year DESC;


SELECT * FROM Books 
LIMIT 3;

SELECT * FROM Books 
LIMIT 3 OFFSET 2;




SELECT * FROM Books 
WHERE genre IN ('Fantasy', 'Thriller');

SELECT DISTINCT genre FROM Books;

SELECT 
    title AS 'Book Title', 
    publication_year AS 'Year Published'
FROM Books;