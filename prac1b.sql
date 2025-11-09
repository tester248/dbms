DROP DATABASE IF EXISTS LibraryDML;
CREATE DATABASE LibraryDML;
USE LibraryDML;

CREATE TABLE Publisher (
    PID INT PRIMARY KEY AUTO_INCREMENT,
    Pub_Name VARCHAR(100) NOT NULL,
    PCity VARCHAR(50)
);

CREATE TABLE Author (
    AuthorID INT PRIMARY KEY AUTO_INCREMENT,
    AName VARCHAR(100) NOT NULL,
    Aemail VARCHAR(100) UNIQUE
);

CREATE TABLE Student (
    PRNNO VARCHAR(20) PRIMARY KEY,
    SName VARCHAR(100) NOT NULL,
    RollNo VARCHAR(20),
    Branch VARCHAR(50),
    Year INT
);

CREATE TABLE Book (
    ISBNNO VARCHAR(20) PRIMARY KEY,
    Title VARCHAR(255) NOT NULL,
    Edition VARCHAR(50),
    Price DECIMAL(10, 2),
    Quantity INT,
    PID INT,
    AID INT,
    FOREIGN KEY (PID) REFERENCES Publisher(PID),
    FOREIGN KEY (AID) REFERENCES Author(AuthorID)
);

CREATE TABLE BorrowedBy (
    TRXID INT PRIMARY KEY AUTO_INCREMENT,
    IssueDate DATE,
    RetDate DATE,
    Fine DECIMAL(8, 2) DEFAULT 0.00,
    PRN VARCHAR(20),
    ISBN VARCHAR(20),
    FOREIGN KEY (PRN) REFERENCES Student(PRNNO),
    FOREIGN KEY (ISBN) REFERENCES Book(ISBNNO)
);

-- Publishers
INSERT INTO Publisher (Pub_Name, PCity) VALUES
('TechKnowledge Publications', 'Pune'),
('Pearson', 'London'),
('O''Reilly Media', 'Sebastopol'),
('Springer', 'Berlin'),
('Wiley', 'Hoboken');

-- Authors
INSERT INTO Author (AName, Aemail) VALUES
('Abraham Silberschatz', 'silberschatz@yale.edu'),
('Henry F. Korth', 'korth@lehigh.edu'),
('Dennis Ritchie', 'dmr@bell-labs.com'),
('Herbert Schildt', 'herbert@example.com'),
('Kathy Sierra', 'kathy@example.com');

-- Students
INSERT INTO Student (PRNNO, SName, RollNo, Branch, Year) VALUES
('2201001', 'Ashwin Mathur', 'TA1', 'AI&DS', 2),
('2201002', 'Niranjan Borse', 'TA2', 'Computer', 2),
('2202001', 'Ankit Verma', 'TA3', 'ENTC', 3),
('2203001', 'Sneha Patil', 'TA4', 'Mechanical', 4),
('2201003', 'Vikram Rathod', 'TA5', 'Computer', 1);

-- Books (linking to original authors)
INSERT INTO Book (ISBNNO, Title, Edition, Price, Quantity, PID, AID) VALUES
('100041', 'Database System Concepts', '6th', 750.00, 50, 1, 1),
('100042', 'Introduction to Database System', '2nd', 450.00, 30, 2, 2),
('100043', 'The C Programming Language', '2nd', 550.00, 70, 2, 3),
('100044', 'Introduction to C programming', '1st', 280.00, 25, 1, 3),
('100045', 'Head First Java', '2nd', 600.00, 40, 3, 5),
('100046', 'Introduction to Database System', '1st', 320.00, 15, 2, 2);


-- BorrowedBy
INSERT INTO BorrowedBy (IssueDate, RetDate, PRN, ISBN) VALUES
('2025-07-01', '2025-07-15', '2201001', '100041'),
('2025-07-05', '2025-07-20', '2201002', '100043'),
('2025-07-10', NULL, '2202001', '100045'),
('2025-07-12', NULL, '2201001', '100042'),
('2025-08-01', NULL, '2203001', '100044');



SELECT * FROM Publisher;
SELECT * FROM Author;
SELECT * FROM Student;
SELECT * FROM Book;
SELECT * FROM BorrowedBy;


SET FOREIGN_KEY_CHECKS=0;
DELETE FROM Publisher WHERE Pub_Name = 'Pearson';
SET FOREIGN_KEY_CHECKS=1;


UPDATE Book SET Title = 'Modern Database Concepts' WHERE ISBNNO = '100041';

UPDATE Author SET Aemail = 'h.korth.new@lehigh.edu' WHERE AName = 'Henry F. Korth';

UPDATE Book SET Quantity = 100 WHERE Title = 'Introduction to Database System';


UPDATE Book SET Price = Price + 200 WHERE Title = 'Introduction to Database System' AND Edition = '2nd';
UPDATE Book SET Price = Price - 10 WHERE Title = 'Introduction to Database System' AND Edition = '1st';

SELECT * FROM Book WHERE Price BETWEEN 300 AND 500;


SET FOREIGN_KEY_CHECKS=0;
DELETE FROM Book WHERE Edition = '1st' AND Title = 'Introduction to C programming';
SET FOREIGN_KEY_CHECKS=1;
