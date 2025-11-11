-- **************************************
-- PRACTICAL 4: Joins, Subqueries and Views
-- **************************************

-- 1️⃣ Create and Use Database
CREATE DATABASE CollegeDB4;
USE CollegeDB4;

-- 2️⃣ Create Department Table
CREATE TABLE Department (
    dept_id INT PRIMARY KEY AUTO_INCREMENT,
    dept_name VARCHAR(30),
    location VARCHAR(20)
);

-- 3️⃣ Create Student Table
CREATE TABLE Student (
    roll_no INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50),
    dept_id INT,
    marks INT,
    city VARCHAR(30),
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
('Anjali', 2, 88, 'Pune'),
('Kiran', NULL, 70, 'Delhi');  -- Student without department

-- **************************************
-- PART A: JOINS (All Types)
-- **************************************

-- 1️⃣ INNER JOIN: Students with their department
SELECT s.name, s.marks, d.dept_name
FROM Student s
INNER JOIN Department d ON s.dept_id = d.dept_id;

-- 2️⃣ LEFT JOIN: All students, including those without departments
SELECT s.name, d.dept_name
FROM Student s
LEFT JOIN Department d ON s.dept_id = d.dept_id;

-- 3️⃣ RIGHT JOIN: All departments, even if no student enrolled
SELECT s.name, d.dept_name
FROM Student s
RIGHT JOIN Department d ON s.dept_id = d.dept_id;

-- 4️⃣ FULL JOIN (MySQL does not support directly – use UNION)
SELECT s.name, d.dept_name
FROM Student s LEFT JOIN Department d ON s.dept_id = d.dept_id
UNION
SELECT s.name, d.dept_name
FROM Student s RIGHT JOIN Department d ON s.dept_id = d.dept_id;

-- 5️⃣ SELF JOIN Example (Not very useful here, so simulate mentorship)
SELECT s1.name AS Student1, s2.name AS Student2
FROM Student s1, Student s2
WHERE s1.city = s2.city AND s1.roll_no <> s2.roll_no;

-- **************************************
-- PART B: SUBQUERIES
-- **************************************

-- 6️⃣ Display students having marks greater than the average
SELECT name, marks
FROM Student
WHERE marks > (SELECT AVG(marks) FROM Student);

-- 7️⃣ Find students who belong to the same department as 'Akash'
SELECT name FROM Student
WHERE dept_id = (SELECT dept_id FROM Student WHERE name = 'Akash');

-- 8️⃣ Display department name for student ‘Neha’ using subquery
SELECT dept_name
FROM Department
WHERE dept_id = (SELECT dept_id FROM Student WHERE name = 'Neha');

-- 9️⃣ Find students who have the highest marks
SELECT name, marks
FROM Student
WHERE marks = (SELECT MAX(marks) FROM Student);

-- **************************************
-- PART C: VIEW CREATION
-- **************************************

-- 🔟 Create a view of student name, dept, and marks
CREATE VIEW StudentInfo AS
SELECT s.roll_no, s.name, s.marks, d.dept_name
FROM Student s
LEFT JOIN Department d ON s.dept_id = d.dept_id;

-- Display data from the view
SELECT * FROM StudentInfo;

-- **************************************
-- END OF PRACTICAL 4
-- **************************************
