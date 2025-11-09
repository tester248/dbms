DROP DATABASE IF EXISTS LIBRARY;
CREATE DATABASE LIBRARY;
USE LIBRARY;
-- Create Tables
CREATE TABLE Author (
    AuthorID INT PRIMARY KEY,
    AName VARCHAR(100),
    Aemail VARCHAR(100)
);

CREATE TABLE Publisher (
    PID INT PRIMARY KEY,
    PubName VARCHAR(100),
    PCity VARCHAR(50),
    PEmail VARCHAR(100)
);

CREATE TABLE Book (
    ISBNNO VARCHAR(20) PRIMARY KEY,
    Title VARCHAR(255),
    Edition INT,
    Price DECIMAL(10, 2),
    Quantity INT,
    PID INT,
    AID INT,
    FOREIGN KEY (PID) REFERENCES Publisher(PID),
    FOREIGN KEY (AID) REFERENCES Author(AuthorID)
);

CREATE TABLE Student (
    PRNNO VARCHAR(20) PRIMARY KEY,
    SName VARCHAR(100),
    RollNo INT,
    Branch VARCHAR(50),
    Year INT
);

CREATE TABLE BorrowedBy (
    TRXID INT PRIMARY KEY AUTO_INCREMENT,
    IssueDate DATE,
    RetDate DATE,
    Fine DECIMAL(10, 2),
    PRN VARCHAR(20),
    ISBN VARCHAR(20),
    FOREIGN KEY (PRN) REFERENCES Student(PRNNO),
    FOREIGN KEY (ISBN) REFERENCES Book(ISBNNO)
);

-- Insert Sample Data
INSERT INTO Author VALUES
(1, 'Korth', 'korth@db.com'),
(2, 'Galvin', 'galvin@os.com'),
(3, 'Cormen', 'cormen@algo.com'),
(4, 'Pressman', 'pressman@se.com'),
(5, 'Balagurusamy', NULL);

INSERT INTO Publisher VALUES
(101, 'TechKnowledge', 'Pune', 'contact@tk.com'),
(102, 'Oxford', 'Delhi', 'support@oxford.com'),
(103, 'Pearson', 'Mumbai', 'info@pearson.com');

INSERT INTO Book VALUES
('ISBN-001', 'Database System Concepts', 6, 850.00, 10, 101, 1),
('ISBN-002', 'Operating System Concepts', 9, 750.50, 8, 101, 2),
('ISBN-003', 'Introduction to Algorithms', 3, 1250.00, 5, 102, 3),
('ISBN-004', 'Software Engineering', 7, 600.00, 12, 103, 4),
('ISBN-005', 'Programming in ANSI C', 8, 450.00, 15, 102, 5),
('ISBN-006', 'Introduction to Databases', 1, 550.00, 4, 102, 1);

INSERT INTO Student VALUES
('PRN2023001', 'Riya Sharma', 10, 'IT', 3),
('PRN2023002', 'Amit Singh', 22, 'Comp', 3),
('PRN2022005', 'Sneha Patil', 35, 'IT', 4),
('PRN2024010', 'Varun Deshpande', 5, 'ENTC', 2);

INSERT INTO BorrowedBy (IssueDate, RetDate, Fine, PRN, ISBN) VALUES
('2025-08-10', '2025-08-20', 0.00, 'PRN2023001', 'ISBN-001'),
('2025-08-15', '2025-08-30', 75.00, 'PRN2022005', 'ISBN-004'),
('2025-09-24', NULL, NULL, 'PRN2023002', 'ISBN-002'),
('2025-09-24', NULL, NULL, 'PRN2023001', 'ISBN-003'), -- Issued Today
('2025-07-01', '2025-07-10', 0.00, 'PRN2023001', 'ISBN-005'),
('2025-08-05', '2025-08-05', 0.00, 'PRN2024010', 'ISBN-006'); -- Same day return


SELECT Title, Price
FROM Book
ORDER BY Price ASC;

SELECT Title, Price
FROM Book
ORDER BY Price DESC, Title ASC;

SELECT Title
FROM Book
WHERE Price = (SELECT MAX(Price) FROM Book);

SELECT Title
FROM Book
WHERE Price = (SELECT MIN(Price) FROM Book);


SELECT COUNT(*) AS TotalPublishers
FROM Publisher;

SELECT COUNT(*) AS TotalBooks
FROM Book;

SELECT b.Title, a.AName
FROM Book b
INNER JOIN Author a ON b.AID = a.AuthorID
WHERE a.AName = 'Galvin'; 


SELECT s.SName, COUNT(bb.ISBN) AS TotalBooksIssued
FROM Student s
LEFT JOIN BorrowedBy bb ON s.PRNNO = bb.PRN
GROUP BY s.PRNNO, s.SName;






SELECT b.Title, bb.IssueDate
FROM Book b
INNER JOIN BorrowedBy bb ON b.ISBNNO = bb.ISBN
WHERE bb.IssueDate = CURDATE();

SELECT SUM(Fine) AS TotalFineCollected
FROM BorrowedBy
WHERE Fine IS NOT NULL;

SELECT s.SName, SUM(COALESCE(bb.Fine, 0)) AS TotalFinePaid
FROM Student s
LEFT JOIN BorrowedBy bb ON s.PRNNO = bb.PRN
GROUP BY s.PRNNO, s.SName;




SELECT s.SName, s.RollNo, SUM(bb.Fine) AS TotalFine
FROM Student s
INNER JOIN BorrowedBy bb ON s.PRNNO = bb.PRN
WHERE bb.Fine IS NOT NULL
GROUP BY s.PRNNO, s.SName, s.RollNo
ORDER BY TotalFine DESC;


SELECT s.SName, SUM(bb.Fine) AS TotalFine
FROM Student s
INNER JOIN BorrowedBy bb ON s.PRNNO = bb.PRN
WHERE bb.Fine IS NOT NULL
GROUP BY s.PRNNO, s.SName
HAVING SUM(bb.Fine) > 50;

SELECT s.SName, bb.Fine
FROM Student s
INNER JOIN BorrowedBy bb ON s.PRNNO = bb.PRN
WHERE s.Branch = 'IT' AND bb.Fine IS NOT NULL
ORDER BY bb.Fine DESC;

SELECT SUM(bb.Fine) AS TotalFineIT
FROM Student s
INNER JOIN BorrowedBy bb ON s.PRNNO = bb.PRN
WHERE s.Branch = 'IT' AND bb.Fine IS NOT NULL;


SELECT p.PubName, AVG(b.Price) AS AvgPrice
FROM Publisher p
INNER JOIN Book b ON p.PID = b.PID
GROUP BY p.PID, p.PubName;


SELECT Title
FROM Book
WHERE Title LIKE 'Introduction%';


SELECT Title
FROM Book
WHERE Title LIKE '%database%';


SELECT Title
FROM Book
WHERE LENGTH(Title) >= 8;


SELECT DISTINCT SName
FROM Student;


SELECT COUNT(b.ISBNNO) AS BookCount
FROM Book b
INNER JOIN Publisher p ON b.PID = p.PID
WHERE p.PubName = 'Oxford';


SELECT AName
FROM Author
WHERE Aemail IS NULL OR Aemail = '';


SELECT DISTINCT s.SName
FROM Student s
INNER JOIN BorrowedBy bb ON s.PRNNO = bb.PRN
WHERE bb.Fine IS NOT NULL AND bb.Fine > 0;


SELECT s.SName
FROM Student s
WHERE s.PRNNO NOT IN (
    SELECT DISTINCT bb.PRN
    FROM BorrowedBy bb
    WHERE bb.Fine IS NOT NULL AND bb.Fine > 0
);


SELECT bb.PRN, b.Title
FROM BorrowedBy bb
INNER JOIN Book b ON bb.ISBN = b.ISBNNO
WHERE bb.IssueDate = bb.RetDate;


SELECT bb.PRN, b.Title
FROM BorrowedBy bb
INNER JOIN Book b ON bb.ISBN = b.ISBNNO
WHERE bb.RetDate IS NULL;

