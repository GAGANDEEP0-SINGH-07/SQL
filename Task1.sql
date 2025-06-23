-- Create and use the database

CREATE DATABASE LibraryDB;
USE LibraryDB;

-- Authors Table
CREATE TABLE Authors (
    author_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    bio TEXT
);

-- Books Table
CREATE TABLE Books (
    book_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(150) NOT NULL,
    publication_year YEAR,
    genre VARCHAR(50),
    total_copies INT DEFAULT 1
);

-- Junction Table for Many-to-Many (Books ↔ Authors)
CREATE TABLE BookAuthors (
    book_id INT,
    author_id INT,
    PRIMARY KEY (book_id, author_id),
    FOREIGN KEY (book_id) REFERENCES Books(book_id),
    FOREIGN KEY (author_id) REFERENCES Authors(author_id)
);

-- Members Table
CREATE TABLE Members (
    member_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    join_date DATE
);

-- Librarians Table
CREATE TABLE Librarians (
    librarian_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    email VARCHAR(100) UNIQUE
);

-- Loans Table (Book issue/return log)
CREATE TABLE Loans (
    loan_id INT PRIMARY KEY AUTO_INCREMENT,
    book_id INT,
    member_id INT,
    issue_date DATE,
    return_date DATE,
    FOREIGN KEY (book_id) REFERENCES Books(book_id),
    FOREIGN KEY (member_id) REFERENCES Members(member_id)
);

-- Insert sample data into Authors
INSERT INTO Authors (name, bio) VALUES
('J.K. Rowling', 'British author of the Harry Potter series.'),
('George Orwell', 'English novelist and essayist, known for 1984.'),
('J.R.R. Tolkien', 'Author of The Lord of the Rings.'),
('Agatha Christie', 'Famous for detective novels.'),
('Dan Brown', 'Known for thrillers like The Da Vinci Code.');

-- Insert sample data into Books
INSERT INTO Books (title, publication_year, genre, total_copies) VALUES
('Harry Potter and the Philosopher''s Stone', 1997, 'Fantasy', 5),
('1984', 1949, 'Dystopian', 3),
('The Hobbit', 1937, 'Fantasy', 4),
('Murder on the Orient Express', 1934, 'Mystery', 2),
('The Da Vinci Code', 2003, 'Thriller', 3),
('Animal Farm', 1945, 'Satire', 4);

-- Insert sample data into BookAuthors
INSERT INTO BookAuthors (book_id, author_id) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 2);

-- Insert sample data into Members
INSERT INTO Members (name, email, join_date) VALUES
('Alice Johnson', 'alice@example.com', '2023-01-15'),
('Bob Smith', 'bob@example.com', '2023-02-10'),
('Charlie Lee', 'charlie@example.com', '2023-03-05'),
('Diana Watts', 'diana@example.com', '2023-04-20'),
('Ethan Blake', 'ethan@example.com', '2023-05-25');

-- Insert sample data into Librarians
INSERT INTO Librarians (name, email) VALUES
('Sarah Clark', 'sarah.clark@library.com'),
('David Harris', 'david.harris@library.com');

-- Insert sample data into Loans
INSERT INTO Loans (book_id, member_id, issue_date, return_date) VALUES
(1, 1, '2024-05-01', '2024-05-15'),
(2, 2, '2024-05-03', '2024-05-17'),
(3, 3, '2024-05-04', '2024-05-18'),
(1, 4, '2024-06-01', NULL),
(5, 5, '2024-06-10', NULL),
(4, 1, '2024-06-15', NULL),
(6, 2, '2024-06-20', NULL);

SELECT * FROM Books;