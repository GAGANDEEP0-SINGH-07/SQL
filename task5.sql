USE LibraryDB;

-- INNER JOIN: Get book titles and their authors
SELECT 
    b.title AS book_title,
    a.name AS author_name
FROM Books b
INNER JOIN BookAuthors ba ON b.book_id = ba.book_id
INNER JOIN Authors a ON ba.author_id = a.author_id;

-- LEFT JOIN: Show all books, including those that have no authors
SELECT 
    b.title AS book_title,
    a.name AS author_name
FROM Books b
LEFT JOIN BookAuthors ba ON b.book_id = ba.book_id
LEFT JOIN Authors a ON ba.author_id = a.author_id;

-- RIGHT JOIN: Show all authors, including those who haven't written any books
SELECT 
    b.title AS book_title,
    a.name AS author_name
FROM Books b
RIGHT JOIN BookAuthors ba ON b.book_id = ba.book_id
RIGHT JOIN Authors a ON ba.author_id = a.author_id;

-- FULL JOIN: Combine LEFT and RIGHT JOIN to show all books and all authors
SELECT 
    b.title AS book_title,
    a.name AS author_name
FROM Books b
LEFT JOIN BookAuthors ba ON b.book_id = ba.book_id
LEFT JOIN Authors a ON ba.author_id = a.author_id

UNION

SELECT 
    b.title AS book_title,
    a.name AS author_name
FROM Authors a
LEFT JOIN BookAuthors ba ON a.author_id = ba.author_id
LEFT JOIN Books b ON ba.book_id = b.book_id;
