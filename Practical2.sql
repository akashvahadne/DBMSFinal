-- **************************************
-- PRACTICAL 2: SQL DDL OBJECTS
-- **************************************

-- 1️⃣ Create Database
CREATE DATABASE CollegeDB2;
USE CollegeDB2;

-- 2️⃣ Create Department Table
CREATE TABLE Department (
    dept_id INT PRIMARY KEY AUTO_INCREMENT,
    dept_name VARCHAR(30) UNIQUE,
    location VARCHAR(20) NOT NULL
);

-- 3️⃣ Create Student Table with Constraints
CREATE TABLE Student (
    roll_no INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    dept_id INT,
    marks INT CHECK (marks BETWEEN 0 AND 100),
    city VARCHAR(30) DEFAULT 'Nashik',
    FOREIGN KEY (dept_id) REFERENCES Department(dept_id)
);

-- 4️⃣ Insert Data into Department Table
INSERT INTO Department (dept_name, location) VALUES
('Computer', 'Building A'),
('IT', 'Building B'),
('ENTC', 'Building C');

-- 5️⃣ Insert Data into Student Table
INSERT INTO Student (name, dept_id, marks, city) VALUES
('Akash', 1, 85, 'Nashik'),
('Neha', 2, 92, 'Pune'),
('Rohan', 1, 78, 'Nashik'),
('Meera', 3, 67, 'Mumbai'),
('Anjali', 2, 88, DEFAULT);

-- 6️⃣ Create a View
CREATE VIEW Student_View AS
SELECT s.roll_no, s.name, s.marks, d.dept_name
FROM Student s
JOIN Department d ON s.dept_id = d.dept_id;

-- 7️⃣ Create an Index for faster search
CREATE INDEX idx_marks ON Student(marks);

-- 8️⃣ Create a Sequence Equivalent (MySQL uses AUTO_INCREMENT)
-- Simulating a sequence table
CREATE TABLE roll_sequence (
    id INT AUTO_INCREMENT PRIMARY KEY
);
INSERT INTO roll_sequence VALUES (), (), ();

-- 9️⃣ Create a Synonym (Only in Oracle)
-- In MySQL, use an alias instead:
-- SELECT * FROM Student s;

-- **************************************
-- OUTPUT QUERIES
-- **************************************
-- View all Students
SELECT * FROM Student;

-- View Created View
SELECT * FROM Student_View;

-- Check Indexes
SHOW INDEX FROM Student;

-- Verify Foreign Key Relation
SELECT s.name, d.dept_name
FROM Student s
JOIN Department d ON s.dept_id = d.dept_id;

-- **************************************
-- END OF PRACTICAL 2
-- **************************************
