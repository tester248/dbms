DROP DATABASE IF EXISTS EmployeeDB;
CREATE DATABASE EmployeeDB;
USE EmployeeDB;

CREATE TABLE Employee (
    eid INT PRIMARY KEY AUTO_INCREMENT,
    ename VARCHAR(100) NOT NULL,
    dname VARCHAR(50),
    salary DECIMAL(10, 2),
    DOJ DATE,
    city VARCHAR(50) DEFAULT 'Mumbai',
    mob VARCHAR(15)
);

ALTER TABLE Employee ADD CONSTRAINT UQ_mob UNIQUE (mob);

INSERT INTO Employee (ename, dname, salary, DOJ, city, mob) VALUES
('Arun Kumar', 'HR', 60000, '2022-01-15', 'Pune', '9876543210'),
('Bhavna Singh', 'Technology', 95000, '2021-11-20', DEFAULT, '9876543211'),
('Niranjan Borse', 'Technology', 110000, '2020-05-10', 'Delhi', '9876543212'),
('Divya Mehta', 'Finance', 75000, '2023-02-01', DEFAULT, '9876543213'),
('Esha Gupta', 'HR', 62000, '2023-03-12', 'Pune', '9876543214');

CREATE VIEW emp1 AS
SELECT eid, ename, salary
FROM Employee;

CREATE VIEW emp2 AS
SELECT
    dname,
    COUNT(*) AS total_employees,
    MAX(salary) AS highest_salary,
    MIN(salary) AS lowest_salary
FROM Employee
GROUP BY dname;
SELECT * from emp2;

CREATE INDEX idx_ename ON Employee(ename);

EXPLAIN SELECT * FROM Employee WHERE ename = 'Niranjan Borse';

DROP INDEX idx_ename ON Employee;

INSERT INTO emp1 (ename, salary) VALUES ('Ashwin Mathur', 88000.00);
INSERT INTO emp1 (ename, salary) VALUES ('Some Body', 84000.00);
INSERT INTO emp1 (ename, salary) VALUES ('Demo Example', 78000.00);
SELECT * from emp1;

DROP VIEW emp1;

