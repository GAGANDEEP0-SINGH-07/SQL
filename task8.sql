USE LibraryDB;

-- 1. Procedure to check out a book
DELIMITER //
CREATE PROCEDURE CheckOutBook(
    IN p_book_id INT,
    IN p_member_id INT,
    OUT p_result VARCHAR(100)
)
BEGIN
    DECLARE available_copies INT;
    DECLARE current_loans INT;
    
    -- Check available copies
    SELECT (total_copies - COUNT(loan_id)) INTO available_copies
    FROM Books b
    LEFT JOIN Loans l ON b.book_id = l.book_id AND l.return_date IS NULL
    WHERE b.book_id = p_book_id
    GROUP BY b.book_id, b.total_copies;
    
    -- Check if member has too many current loans (limit to 3)
    SELECT COUNT(*) INTO current_loans
    FROM Loans
    WHERE member_id = p_member_id AND return_date IS NULL;
    
    IF available_copies > 0 THEN
        IF current_loans < 3 THEN
            INSERT INTO Loans (book_id, member_id, issue_date)
            VALUES (p_book_id, p_member_id, CURDATE());
            SET p_result = 'Book checked out successfully';
        ELSE
            SET p_result = 'Error: Member has reached maximum loan limit (3 books)';
        END IF;
    ELSE
        SET p_result = 'Error: No available copies of this book';
    END IF;
END //
DELIMITER ;

-- 2. Procedure to return a book
DELIMITER //
CREATE PROCEDURE ReturnBook(
    IN p_loan_id INT,
    OUT p_result VARCHAR(100)
)
BEGIN
    DECLARE book_exists INT;
    
    -- Check if loan exists and isn't already returned
    SELECT COUNT(*) INTO book_exists
    FROM Loans
    WHERE loan_id = p_loan_id AND return_date IS NULL;
    
    IF book_exists > 0 THEN
        UPDATE Loans
        SET return_date = CURDATE()
        WHERE loan_id = p_loan_id;
        SET p_result = 'Book returned successfully';
    ELSE
        SET p_result = 'Error: Loan not found or book already returned';
    END IF;
END //
DELIMITER ;

-- 3. Procedure to add a new book with optional author
DELIMITER //
CREATE PROCEDURE AddNewBook(
    IN p_title VARCHAR(150),
    IN p_publication_year INT,
    IN p_genre VARCHAR(50),
    IN p_author_id INT,
    IN p_total_copies INT,
    OUT p_book_id INT
)
BEGIN
    -- Insert the new book
    INSERT INTO Books (title, publication_year, genre, total_copies)
    VALUES (p_title, p_publication_year, p_genre, p_total_copies);
    
    -- Get the new book ID
    SET p_book_id = LAST_INSERT_ID();
    
    -- Link to author if provided
    IF p_author_id IS NOT NULL THEN
        INSERT INTO BookAuthors (book_id, author_id)
        VALUES (p_book_id, p_author_id);
    END IF;
END //
DELIMITER ;

-- 4. Procedure to get books by genre with pagination
DELIMITER //
CREATE PROCEDURE GetBooksByGenre(
    IN p_genre VARCHAR(50),
    IN p_limit INT,
    IN p_offset INT
)
BEGIN
    SELECT 
        b.book_id,
        b.title,
        b.publication_year,
        GROUP_CONCAT(a.name SEPARATOR ', ') AS authors
    FROM Books b
    LEFT JOIN BookAuthors ba ON b.book_id = ba.book_id
    LEFT JOIN Authors a ON ba.author_id = a.author_id
    WHERE b.genre = p_genre OR (p_genre IS NULL AND b.genre IS NULL)
    GROUP BY b.book_id, b.title, b.publication_year
    LIMIT p_limit OFFSET p_offset;
END //
DELIMITER ;

-- 1. Function to calculate days a book has been checked out
DELIMITER //
CREATE FUNCTION GetDaysCheckedOut(p_loan_id INT) 
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE days_out INT;
    
    SELECT DATEDIFF(IFNULL(return_date, CURDATE()), issue_date) INTO days_out
    FROM Loans
    WHERE loan_id = p_loan_id;
    
    RETURN days_out;
END //
DELIMITER ;

-- 2. Function to check if a book is available
DELIMITER //
CREATE FUNCTION IsBookAvailable(p_book_id INT) 
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE available INT;
    
    SELECT (total_copies - COUNT(loan_id)) INTO available
    FROM Books b
    LEFT JOIN Loans l ON b.book_id = l.book_id AND l.return_date IS NULL
    WHERE b.book_id = p_book_id
    GROUP BY b.book_id, b.total_copies;
    
    RETURN available > 0;
END //
DELIMITER ;

-- 3. Function to count books by an author
DELIMITER //
CREATE FUNCTION CountBooksByAuthor(p_author_id INT) 
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE book_count INT;
    
    SELECT COUNT(*) INTO book_count
    FROM BookAuthors
    WHERE author_id = p_author_id;
    
    RETURN book_count;
END //
DELIMITER ;

-- 4. Function to get most popular genre
DELIMITER //
CREATE FUNCTION GetMostPopularGenre() 
RETURNS VARCHAR(50)
READS SQL DATA
BEGIN
    DECLARE popular_genre VARCHAR(50);
    
    SELECT genre INTO popular_genre
    FROM Books
    GROUP BY genre
    ORDER BY COUNT(*) DESC
    LIMIT 1;
    
    RETURN popular_genre;
END //
DELIMITER ;

-- 1. Check out a book
CALL CheckOutBook(1, 3, @result);
SELECT @result;

-- 2. Return a book
CALL ReturnBook(4, @result);
SELECT @result;

-- 3. Add a new book
CALL AddNewBook('New SQL Guide', 2023, 'Technical', 5, 2, @new_book_id);
SELECT @new_book_id;

-- 4. Get books by genre with pagination
CALL GetBooksByGenre('Fantasy', 5, 0);

-- 5. Use functions
SELECT GetDaysCheckedOut(1) AS days_checked_out;
SELECT IsBookAvailable(1) AS is_available;
SELECT CountBooksByAuthor(2) AS books_by_author;
SELECT GetMostPopularGenre() AS most_popular_genre;