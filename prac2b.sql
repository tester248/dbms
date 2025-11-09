-- Create Tables
CREATE TABLE Branch (
    branch_id INT PRIMARY KEY,
    branch_name VARCHAR(100),
    branch_city VARCHAR(50),
    assets DECIMAL(15, 2)
);

CREATE TABLE Customer (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    customer_street VARCHAR(100),
    customer_city VARCHAR(50)
);

CREATE TABLE Loan (
    loan_number INT PRIMARY KEY,
    amount DECIMAL(12, 2),
    customer_id INT,
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
);

CREATE TABLE Account (
    account_number INT PRIMARY KEY,
    balance DECIMAL(12, 2),
    customer_id INT,
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
);

-- Insert Sample Data
INSERT INTO Branch VALUES
(1, 'Deccan', 'Pune', 75000000),
(2, 'Kothrud', 'Pune', 90000000),
(3, 'Andheri', 'Mumbai', 80000000),
(4, 'Connaught Place', 'Delhi', 120000000),
(5, 'Shivajinagar', 'Pune', 60000000);

INSERT INTO Customer VALUES
(101, 'Rahul Deshpande', 'FC Road', 'Pune'),
(102, 'Priya Singh', 'MG Road', 'Mumbai'),
(103, 'Anjali Mehta', 'Lajpat Nagar', 'Delhi'),
(104, 'Sameer Khan', 'Koregaon Park', 'Pune');

INSERT INTO Loan VALUES
(5001, 250000, 101), -- Rahul has a loan
(5002, 500000, 102); -- Priya has a loan

INSERT INTO Account VALUES
(9001, 150000, 101), -- Rahul has an account
(9002, 75000, 103);  -- Anjali has an account

SELECT c.customer_name
FROM Customer c
WHERE c.customer_id IN (SELECT l.customer_id FROM Loan l)
  AND c.customer_id IN (SELECT a.customer_id FROM Account a);
  
  SELECT c.customer_name
FROM Customer c
WHERE c.customer_id IN (SELECT l.customer_id FROM Loan l)
  AND c.customer_id NOT IN (SELECT a.customer_id FROM Account a);
  
  SELECT c.customer_name
FROM Customer c
WHERE c.customer_id IN (SELECT a.customer_id FROM Account a)
  AND c.customer_id NOT IN (SELECT l.customer_id FROM Loan l);
  

SELECT branch_name, assets
FROM Branch
WHERE assets > SOME (SELECT assets FROM Branch WHERE branch_city = 'Pune');

SELECT b.branch_name, b.assets
FROM Branch b
WHERE b.assets > ALL (SELECT assets FROM Branch WHERE branch_city = 'Pune');

SELECT branch_name, assets
FROM Branch
WHERE assets > (SELECT MAX(assets) FROM Branch WHERE branch_city = 'Pune');

SELECT c.customer_id, c.customer_name, a.account_number, a.balance
FROM Customer c
JOIN Account a ON c.customer_id = a.customer_id;

SELECT c.customer_id, c.customer_name, l.loan_number, l.amount AS loan_amount
FROM Customer c
JOIN Loan l ON c.customer_id = l.customer_id;