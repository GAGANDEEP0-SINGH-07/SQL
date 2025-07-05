USE LibraryDB;

-- 1. View for currently available books (not checked out)
CREATE VIEW AvailableBooks AS
SELECT 
    b.book_id,
    b.title,
    b.genre,
    (b.total_copies - COUNT(l.loan_id)) AS available_copies
FROM Books b
LEFT JOIN Loans l ON b.book_id = l.book_id AND l.return_date IS NULL
GROUP BY b.book_id, b.title, b.genre, b.total_copies;

-- 2. View for books currently checked out
CREATE VIEW CheckedOutBooks AS
SELECT 
    b.book_id,
    b.title,
    m.name AS borrower_name,
    l.issue_date,
    DATEDIFF(CURDATE(), l.issue_date) AS days_borrowed
FROM Books b
JOIN Loans l ON b.book_id = l.book_id
JOIN Members m ON l.member_id = m.member_id
WHERE l.return_date IS NULL;

-- 3. View for author book counts
CREATE VIEW AuthorBookCounts AS
SELECT 
    a.author_id,
    a.name,
    COUNT(ba.book_id) AS book_count
FROM Authors a
LEFT JOIN BookAuthors ba ON a.author_id = ba.author_id
GROUP BY a.author_id, a.name;

-- 4. View for member borrowing activity
CREATE VIEW MemberBorrowingActivity AS
SELECT 
    m.member_id,
    m.name,
    m.join_date,
    COUNT(l.loan_id) AS total_loans,
    COUNT(CASE WHEN l.return_date IS NULL THEN 1 END) AS current_loans
FROM Members m
LEFT JOIN Loans l ON m.member_id = l.member_id
GROUP BY m.member_id, m.name, m.join_date;

-- 5. View for genre statistics
CREATE VIEW GenreStatistics AS
SELECT 
    genre,
    COUNT(*) AS book_count,
    MIN(publication_year) AS oldest_year,
    MAX(publication_year) AS newest_year,
    ROUND(AVG(publication_year), 0) AS avg_year
FROM Books
GROUP BY genre;

-- 6. View for overdue books
CREATE VIEW OverdueBooks AS
SELECT 
    b.title,
    m.name AS borrower,
    l.issue_date,
    DATEDIFF(CURDATE(), l.issue_date) AS days_checked_out
FROM Loans l
JOIN Books b ON l.book_id = b.book_id
JOIN Members m ON l.member_id = m.member_id
WHERE l.return_date IS NULL 
AND DATEDIFF(CURDATE(), l.issue_date) > 30;  -- Assuming 30 days is the loan period

-- 7. View for books with multiple authors
CREATE VIEW MultiAuthorBooks AS
SELECT 
    b.title,
    GROUP_CONCAT(a.name SEPARATOR ', ') AS authors
FROM Books b
JOIN BookAuthors ba ON b.book_id = ba.book_id
JOIN Authors a ON ba.author_id = a.author_id
GROUP BY b.title
HAVING COUNT(a.author_id) > 1;

-- 8. View for simplified book information
CREATE VIEW BookCatalog AS
SELECT 
    b.book_id,
    b.title,
    b.publication_year,
    b.genre,
    GROUP_CONCAT(a.name SEPARATOR ', ') AS authors
FROM Books b
LEFT JOIN BookAuthors ba ON b.book_id = ba.book_id
LEFT JOIN Authors a ON ba.author_id = a.author_id
GROUP BY b.book_id, b.title, b.publication_year, b.genre;

-- 1. Query available books
SELECT * FROM AvailableBooks WHERE available_copies > 0;

-- 2. Find books checked out by specific member
SELECT * FROM CheckedOutBooks WHERE borrower_name = 'Alice Johnson';

-- 3. Get prolific authors (with many books)
SELECT * FROM AuthorBookCounts ORDER BY book_count DESC;

-- 4. Find active members
SELECT * FROM MemberBorrowingActivity ORDER BY total_loans DESC;

-- 5. Get statistics for a specific genre
SELECT * FROM GenreStatistics WHERE genre = 'Fantasy';

-- 6. List all overdue books
SELECT * FROM OverdueBooks;

-- 7. Find books with multiple authors
SELECT * FROM MultiAuthorBooks;

-- 8. Search the book catalog
SELECT * FROM BookCatalog WHERE title LIKE '%Potter%';