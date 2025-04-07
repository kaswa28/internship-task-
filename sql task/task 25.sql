-- Create Database
CREATE DATABASE IF NOT EXISTS LibraryDB;
USE LibraryDB;

-- Create Books Table
CREATE TABLE IF NOT EXISTS books (
    book_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    author VARCHAR(255) NOT NULL,
    published_year INT
);

-- Create Members Table
CREATE TABLE IF NOT EXISTS members (
    member_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    join_date DATE NOT NULL
);

-- Create Reservations Table (Now it references existing tables)
CREATE TABLE IF NOT EXISTS reservations (
    reservation_id INT PRIMARY KEY AUTO_INCREMENT,
    book_id INT,
    member_id INT,
    reservation_date DATE NOT NULL,
    status ENUM('pending', 'fulfilled', 'canceled') DEFAULT 'pending',
    FOREIGN KEY (book_id) REFERENCES books(book_id) ON DELETE CASCADE,
    FOREIGN KEY (member_id) REFERENCES members(member_id) ON DELETE CASCADE
);

-- Insert Sample Data
INSERT INTO books (title, author, published_year) VALUES
('The Great Gatsby', 'F. Scott Fitzgerald', 1925),
('1984', 'George Orwell', 1949),
('To Kill a Mockingbird', 'Harper Lee', 1960);

INSERT INTO members (first_name, last_name, email, join_date) VALUES
('Alice', 'Smith', 'alice@example.com', '2024-01-15'),
('Bob', 'Johnson', 'bob@example.com', '2024-02-10');

INSERT INTO reservations (book_id, member_id, reservation_date, status) VALUES
(1, 1, '2024-03-20', 'pending'),
(2, 2, '2024-03-22', 'fulfilled');

-- Check inserted data
SELECT * FROM books;
SELECT * FROM members;
SELECT * FROM reservations;
-- Top 3 members with most overdue books
SELECT member_id, COUNT(*) AS overdue_books FROM loans WHERE due_date < CURDATE() GROUP BY member_id ORDER BY overdue_books DESC LIMIT 3;

-- Total fine amount for a specific member
SELECT SUM(fine_amount) AS total_fine FROM fines WHERE member_id = 101;

-- Books that have never been borrowed
SELECT * FROM books WHERE book_id NOT IN (SELECT DISTINCT book_id FROM loans);

-- Unfulfilled reservations older than 10 days
SELECT * FROM reservations WHERE status = 'pending' AND reservation_date < DATE_SUB(CURDATE(), INTERVAL 10 DAY);

-- Total fines collected in the last 6 months
SELECT SUM(fine_amount) FROM fines WHERE paid_status = 'paid' AND loan_id IN (SELECT loan_id FROM loans WHERE loan_date >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH));

-- Members who borrowed more than 10 books in the last year
SELECT member_id, COUNT(*) AS books_borrowed FROM loans WHERE loan_date >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR) GROUP BY member_id HAVING books_borrowed > 10;

-- Top 3 most active librarians
SELECT librarian_id, COUNT(*) AS processed_loans FROM loans GROUP BY librarian_id ORDER BY processed_loans DESC LIMIT 3;

-- Most reserved books but not borrowed
SELECT book_id, COUNT(*) AS reservations_count FROM reservations WHERE book_id NOT IN (SELECT DISTINCT book_id FROM loans) GROUP BY book_id ORDER BY reservations_count DESC;

-- 5. Trigger: Auto-Fine Calculation
DELIMITER $$
DELIMITER $$

CREATE TRIGGER auto_fine
AFTER UPDATE ON loans
FOR EACH ROW
BEGIN
    -- Check if the book is overdue and a fine is needed
    IF NEW.return_date IS NOT NULL AND NEW.return_date > NEW.due_date THEN
        INSERT INTO fines (member_id, loan_id, fine_amount, paid_status)
        VALUES (NEW.member_id, NEW.loan_id, TIMESTAMPDIFF(DAY, NEW.due_date, NEW.return_date) * 5, 'unpaid');
    END IF;
END $$

DELIMITER ;

-- 6. View: Member's Borrowing History
CREATE VIEW MemberBorrowingHistory AS
SELECT m.member_id, m.name, l.book_id, l.loan_date, l.due_date, l.return_date 
FROM members m
JOIN loans l ON m.member_id = l.member_id;

-- 7. Stored Procedure: Mark Overdue Books & Apply Fines
DELIMITER $$
CREATE PROCEDURE MarkOverdueBooks()
BEGIN
    UPDATE loans
    SET status = 'overdue'
    WHERE due_date < CURDATE() AND return_date IS NULL;
    
    INSERT INTO fines (member_id, loan_id, fine_amount, paid_status)
    SELECT member_id, loan_id, 10.00, 'unpaid' FROM loans
    WHERE due_date < CURDATE() AND return_date IS NULL;
END$$
DELIMITER ;

CALL MarkOverdueBooks();