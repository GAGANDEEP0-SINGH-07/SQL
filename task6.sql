USE LibraryDB;

-- 1. Subquery in SELECT: Show book titles with average publication year as a new column
SELECT 
    title,
    publication_year,
    (SELECT ROUND(AVG(publication_year), 0) FROM Books) AS avg_year
FROM Books;

-- 2. Subquery in WHERE using IN: List authors who have written at least one book
SELECT name
FROM Authors
WHERE author_id IN (
    SELECT author_id
    FROM BookAuthors
);

-- 3. Subquery in WHERE using EXISTS: List members who have borrowed at least one book
SELECT name
FROM Members m
WHERE EXISTS (
    SELECT 1
    FROM Loans l
    WHERE l.member_id = m.member_id
);

-- 4. Scalar subquery with = : Find books published in the latest year
SELECT title, publication_year
FROM Books
WHERE publication_year = (
    SELECT MAX(publication_year)
    FROM Books
);

-- 5. Correlated subquery in WHERE: Show members who borrowed more than one book
SELECT name
FROM Members m
WHERE (
    SELECT COUNT(*)
    FROM Loans l
    WHERE l.member_id = m.member_id
) > 1;

-- 6. Subquery in FROM clause (derived table): Count number of books per genre with alias
SELECT genre, total
FROM (
    SELECT genre, COUNT(*) AS total
    FROM Books
    GROUP BY genre
) AS genre_counts;
