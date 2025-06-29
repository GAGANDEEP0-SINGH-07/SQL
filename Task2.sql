-- TASK 2 SOLUTION: DATA INSERTION AND HANDLING NULLS
-- Using the LibraryDB database from Task 1

USE LibraryDB;

INSERT INTO Authors (name, bio) VALUES
('Jane Austen', NULL),  -- Explicit NULL bio
('Mark Twain', 'American writer and humorist');  -- With bio

ALTER TABLE Books MODIFY COLUMN publication_year INT;

INSERT INTO Books (title, publication_year) VALUES
('Pride and Prejudice', 1813),
('The Adventures of Tom Sawyer', 1876);

INSERT INTO Members (name, join_date) VALUES
('Emma Woodhouse', '2023-07-01');

INSERT INTO Librarians (email) VALUES
('librarian.jane@library.com');

SET SQL_SAFE_UPDATES = 0;

UPDATE Books 
SET genre = 'Classic' 
WHERE genre IS NULL;

UPDATE Loans
SET return_date = CURDATE()
WHERE return_date IS NULL AND issue_date < CURDATE();

SET SQL_SAFE_UPDATES = 1;

UPDATE Librarians
SET name = 'Jane Smith'
WHERE email = 'librarian.jane@library.com';

DELETE FROM Members
WHERE email IS NULL 
AND member_id NOT IN (SELECT member_id FROM Loans);

INSERT INTO Books (title, publication_year) VALUES
('Partial Book Insert', 2023);

INSERT INTO Books (title, publication_year, genre)
SELECT CONCAT(title, ' - Copy'), publication_year, genre
FROM Books
WHERE book_id = 1;

SELECT * FROM Authors WHERE bio IS NULL;
SELECT book_id, title, genre FROM Books WHERE genre = 'Classic';
SELECT loan_id, book_id, return_date FROM Loans WHERE return_date = CURDATE();
SELECT * FROM Members WHERE email IS NULL;
select * from Books;