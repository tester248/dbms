DROP DATABASE IF EXISTS EmployeeDB;
CREATE DATABASE EmployeeDB;
USE EmployeeDB;

-- Create the Department table
CREATE TABLE Department (
    did INT PRIMARY KEY,
    dname VARCHAR(50),
    location VARCHAR(50)
);

-- Create the Employee table
CREATE TABLE Employee (
    eid INT PRIMARY KEY,
    ename VARCHAR(50),
    address VARCHAR(100),
    designation VARCHAR(50),
    salary DECIMAL(10, 2),
    manager_id INT,
    did INT,
    FOREIGN KEY (did) REFERENCES Department(did)
);

-- Insert data into Department
INSERT INTO Department (did, dname, location) VALUES
(10, 'HR', 'Mumbai'),
(20, 'IT', 'Pune'),
(30, 'Sales', 'Delhi'),
(40, 'Marketing', 'Bengaluru');

-- Insert data into Employee
INSERT INTO Employee (eid, ename, address, designation, salary, manager_id, did) VALUES
(201, 'Vikram Singh', 'Koregaon Park, Pune', 'IT Director', 150000.00, NULL, 20),
(101, 'Anjali Sharma', 'Bandra, Mumbai', 'HR Manager', 90000.00, NULL, 10),
(202, 'Priya Reddy', 'Baner, Pune', 'Sr. Developer', 110000.00, 201, 20),
(203, 'Suresh Kumar', 'Hinjawadi, Pune', 'Developer', 80000.00, 201, 20),
(102, 'Rohan Patel', 'Andheri, Mumbai', 'HR Associate', 60000.00, 101, 10),
(301, 'Raj Malhotra', 'CP, Delhi', 'Sales Rep', 70000.00, NULL, 30),
(501, 'Sunita Joshi', 'Indiranagar, Bengaluru', 'Consultant', 100000.00, NULL, NULL);


SELECT * FROM Employee CROSS JOIN Department;

SELECT
    e.ename AS EmployeeName,
    e.designation,
    d.dname AS DepartmentName
FROM
    Employee e
INNER JOIN
    Department d ON e.did = d.did;
    
    
    
    


SELECT
    e.ename AS EmployeeName,
    d.dname AS DepartmentName
FROM
    Employee e
LEFT JOIN
    Department d ON e.did = d.did;
    
    
    SELECT
    e.ename AS EmployeeName,
    d.dname AS DepartmentName
FROM
    Employee e
LEFT JOIN
    Department d ON e.did = d.did;
    


SELECT
    d.dname AS DepartmentName,
    e.ename AS EmployeeName
FROM
    Employee e
RIGHT JOIN
    Department d ON e.did = d.did
ORDER BY
    d.dname
    
    

SELECT
    d.dname AS DepartmentName,
    e.ename AS EmployeeName
FROM
    Employee e
RIGHT JOIN
    Department d ON e.did = d.did
ORDER BY
    d.dname;
    
    
    SELECT
    E.ename AS EmployeeName,
    M.ename AS ManagerName
FROM
    Employee E
JOIN
    Employee M ON E.manager_id = M.eid;
    
    
    
SELECT 
    d.dname AS DepartmentName,
    COUNT(e.eid) AS EmployeeCount
FROM 
    Department d
LEFT JOIN 
    Employee e ON d.did = e.did
GROUP BY 
    d.did, d.dname
HAVING 
    COUNT(e.eid) > 5;
    
    
SELECT 
    e.ename AS EmployeeName,
    m.ename AS ManagerName
FROM 
    Employee e
LEFT JOIN 
    Employee m ON e.manager_id = m.eid
ORDER BY 
    e.ename;
    
    
SELECT 
    e.ename AS EmployeeName,
    e.designation,
    m.ename AS ManagerName
FROM 
    Employee e
INNER JOIN 
    Employee m ON e.manager_id = m.eid
WHERE 
    m.ename = 'Vikram Singh';
    
    
SELECT 
    m.ename AS ManagerName,
    COUNT(e.eid) AS TotalEmployees
FROM 
    Employee m
INNER JOIN 
    Employee e ON m.eid = e.manager_id
GROUP BY 
    m.eid, m.ename
ORDER BY 
    TotalEmployees DESC;
