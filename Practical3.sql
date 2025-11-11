-- **************************************
-- PRACTICAL 3: SQL DML STATEMENTS
-- **************************************

-- 1️⃣ Create and Use Database
CREATE DATABASE CollegeDB3;
USE CollegeDB3;

-- 2️⃣ Create Tables
CREATE TABLE Department (
    dept_id INT PRIMARY KEY AUTO_INCREMENT,
    dept_name VARCHAR(30) UNIQUE,
    location VARCHAR(20)
);

CREATE TABLE Student (
    roll_no INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50),
    dept_id INT,
    marks INT,
    city VARCHAR(30),
    FOREIGN KEY (dept_id) REFERENCES Department(dept_id)
);

-- 3️⃣ Insert Data into Department Table
INSERT INTO Department (dept_name, location) VALUES
('Computer', 'Building A'),
('IT', 'Building B'),
('ENTC', 'Building C');

-- 4️⃣ Insert Data into Student Table
INSERT INTO Student (name, dept_id, marks, city) VALUES
('Akash', 1, 85, 'Nashik'),
('Neha', 2, 92, 'Pune'),
('Rohan', 1, 78, 'Nashik'),
('Meera', 3, 67, 'Mumbai'),
('Anjali', 2, 88, 'Pune');

-- **************************************
-- 10 SQL QUERIES USING DML STATEMENTS
-- **************************************

-- 1️⃣ Display all students
SELECT * FROM Student;

-- 2️⃣ Display students having marks greater than 80
SELECT name, marks FROM Student WHERE marks > 80;

-- 3️⃣ Display students from Nashik or Pune
SELECT name, city FROM Student WHERE city IN ('Nashik', 'Pune');

-- 4️⃣ Increase marks by 5 for Computer department students
UPDATE Student
SET marks = marks + 5
WHERE dept_id = (SELECT dept_id FROM Department WHERE dept_name = 'Computer');

-- 5️⃣ Delete students having marks less than 70
SET SQL_SAFE_UPDATES = 0;
DELETE FROM Student WHERE marks < 70;

-- 6️⃣ Display average marks of each department
SELECT d.dept_name, AVG(s.marks) AS avg_marks
FROM Student s
JOIN Department d ON s.dept_id = d.dept_id
GROUP BY d.dept_name;

-- 7️⃣ Display the highest marks among all students
SELECT MAX(marks) AS highest_marks FROM Student;

-- 8️⃣ Display students whose name starts with 'A'
SELECT * FROM Student WHERE name LIKE 'A%';

-- 9️⃣ Use ORDER BY to show students sorted by marks descending
SELECT name, marks FROM Student ORDER BY marks DESC;

-- 🔟 Display city-wise number of students
SELECT city, COUNT(*) AS total_students
FROM Student
GROUP BY city;

-- **************************************
-- END OF PRACTICAL 3
-- **************************************
