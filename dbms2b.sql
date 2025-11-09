DROP DATABASE IF EXISTS Banking;
CREATE DATABASE Banking;
USE Banking;
-- Create Tables
CREATE TABLE Branch (
branch_id INT PRIMARY KEY,
branch_name VARCHAR(50),
branch_city VARCHAR(50),
assets DECIMAL(12,2)
);
CREATE TABLE Customer (
customer_id INT PRIMARY KEY,
customer_name VARCHAR(50),
customer_street VARCHAR(100),
customer_city VARCHAR(50)
);
CREATE TABLE Account (
account_number INT PRIMARY KEY,
balance DECIMAL(10,2),
customer_id INT,
FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
);
CREATE TABLE Loan (
loan_number INT PRIMARY KEY,
amount DECIMAL(10,2),
customer_id INT,
FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
);DESCRIBE Branch;
DESCRIBE Customer;
DESCRIBE Account;
DESCRIBE Loan;
-- Insert Sample Data
-- Branches
INSERT INTO Branch VALUES
(1, 'Pune_Main', 'Pune', 800000),
(2, 'Pune_West', 'Pune', 500000),
(3, 'Mumbai_Main', 'Mumbai', 1200000),
(4, 'Delhi_Central', 'Delhi', 1500000);
-- Customers
INSERT INTO Customer VALUES
(101, 'Ashwin Mathur', 'MG Road', 'Pune'),
(102, 'Neha Verma', 'FC Road', 'Pune'),
(103, 'Ravi Kumar', 'Bandra', 'Mumbai'),
(104, 'Sunita Patil', 'Andheri', 'Mumbai'),
(105, 'Manoj Singh', 'Connaught Place', 'Delhi');
-- Accounts
INSERT INTO Account VALUES
(2001, 50000, 101),
(2002, 75000, 102),
(2003, 120000, 103),
(2004, 30000, 104);
-- Loans
INSERT INTO Loan VALUES
(3001, 200000, 101),
(3002, 150000, 103),
(3003, 250000, 105);


SELECT DISTINCT c.customer_name
FROM Customer c
JOIN Account a ON c.customer_id = a.customer_id
JOIN Loan l ON c.customer_id = l.customer_id;


SELECT DISTINCT c.customer_name
FROM Customer c
JOIN Loan l ON c.customer_id = l.customer_id
WHERE c.customer_id NOT IN (SELECT customer_id FROM Account);

SELECT DISTINCT c.customer_name
FROM Customer c
JOIN Account a ON c.customer_id = a.customer_id
WHERE c.customer_id NOT IN (SELECT customer_id FROM Loan);

SELECT DISTINCT b1.branch_name, b1.assets
FROM Branch b1
WHERE b1.assets > ANY (SELECT b2.assets FROM Branch b2 WHERE b2.branch_city = 'Pune');


SELECT b1.branch_name, b1.assets
FROM Branch b1
WHERE b1.assets > ALL (SELECT b2.assets FROM Branch b2 WHERE b2.branch_city = 'Pune');

SELECT b1.branch_name, b1.assets
FROM Branch b1, Branch b2
WHERE b2.branch_city = 'Pune'
GROUP BY b1.branch_name, b1.assets
HAVING b1.assets > MAX(b2.assets);


SELECT c.customer_id, c.customer_name, a.account_number, a.balance
FROM Customer c
JOIN Account a ON c.customer_id = a.customer_id;

SELECT c.customer_id, c.customer_name, l.loan_number, l.amount
FROM Customer c
JOIN Loan l ON c.customer_id = l.customer_id;