-- TASK 4 SOLUTION: AGGREGATE FUNCTIONS AND GROUPING
-- Using the LibraryDB database

USE LibraryDB;

SELECT COUNT(*) AS total_books FROM Books;

SELECT COUNT(genre) AS books_with_genres FROM Books;

SELECT COUNT(DISTINCT genre) AS unique_genres FROM Books;

SELECT ROUND(AVG(publication_year), 2) AS avg_publication_year FROM Books;

SELECT SUM(total_copies) AS total_copies_available FROM Books;

SELECT 
    MIN(publication_year) AS oldest_book,
    MAX(publication_year) AS newest_book
FROM Books;

SELECT 
    genre,
    COUNT(*) AS number_of_books
FROM Books
GROUP BY genre;

SELECT 
    genre,
    ROUND(AVG(publication_year), 0) AS avg_publication_year
FROM Books
GROUP BY genre
ORDER BY avg_publication_year DESC;

SELECT 
    CONCAT(FLOOR(publication_year / 10) * 10, 's') AS decade,
    COUNT(*) AS books_published
FROM Books
GROUP BY decade  
ORDER BY decade;

SELECT 
    genre,
    COUNT(*) AS book_count
FROM Books
GROUP BY genre
HAVING COUNT(*) > 1;

SELECT 
    a.name AS author,
    COUNT(ba.book_id) AS books_in_library
FROM Authors a
JOIN BookAuthors ba ON a.author_id = ba.author_id
GROUP BY a.name
HAVING COUNT(ba.book_id) > 1;

SELECT 
    genre,
    ROUND(AVG(publication_year), 0) AS avg_year
FROM Books
GROUP BY genre
HAVING AVG(publication_year) > 1950;