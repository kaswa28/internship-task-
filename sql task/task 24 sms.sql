-- Step 1: Create the Database
CREATE DATABASE student_mgmt_system;
USE student_mgmt_system;

-- Step 2: Create Tables
CREATE TABLE students (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    birth_date DATE,
    enrollment_date DATE
);

CREATE TABLE courses (
    course_id INT PRIMARY KEY AUTO_INCREMENT,
    course_name VARCHAR(100),
    course_code VARCHAR(20),
    credits INT
);

CREATE TABLE instructors (
    instructor_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100)
);

CREATE TABLE enrollments (
    enrollment_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    course_id INT,
    grade VARCHAR(2) NULL,
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

CREATE TABLE course_instructors (
    course_id INT,
    instructor_id INT,
    PRIMARY KEY (course_id, instructor_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id),
    FOREIGN KEY (instructor_id) REFERENCES instructors(instructor_id)
);

-- Step 3: Insert Sample Data
INSERT INTO students (first_name, last_name, email, birth_date, enrollment_date) VALUES
('Amit', 'Sharma', 'amit@example.com', '2001-05-14', '2024-02-01'),
('Pooja', 'Rao', 'pooja@example.com', '2002-07-23', '2024-02-01'),
('Rahul', 'Verma', 'rahul@example.com', '2001-09-10', '2024-02-01'),
('Simran', 'Kaur', 'simran@example.com', '2002-01-05', '2024-02-01'),
('Raj', 'Patel', 'raj@example.com', '2003-03-15', '2024-02-01');

INSERT INTO courses (course_name, course_code, credits) VALUES
('Database Systems', 'DB101', 3),
('Operating Systems', 'OS102', 4),
('Computer Networks', 'CN103', 3),
('Data Structures', 'DS104', 3),
('Machine Learning', 'ML105', 4);

INSERT INTO instructors (first_name, last_name, email) VALUES
('Dr. Neha', 'Mishra', 'neha@example.com'),
('Prof. Kunal', 'Joshi', 'kunal@example.com'),
('Dr. Meera', 'Kapoor', 'meera@example.com');

INSERT INTO enrollments (student_id, course_id, grade) VALUES
(1, 1, 'A'), (1, 2, 'B'), (2, 3, NULL), (2, 1, 'A'), (3, 4, 'B'),
(3, 5, NULL), (4, 2, 'C'), (4, 5, 'A'), (5, 3, 'B'), (5, 4, 'A');

INSERT INTO course_instructors (course_id, instructor_id) VALUES
(1, 1), (2, 2), (3, 3), (4, 1), (5, 2);

-- Step 4: Query Tasks
-- 1. Retrieve All Students
SELECT * FROM students;

-- 2. Find Students Enrolled in a Specific Course
SELECT s.* FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id
WHERE c.course_name = 'Database Systems';

-- 3. Retrieve Students with No Grades Yet
SELECT s.* FROM students s
JOIN enrollments e ON s.student_id = e.student_id
WHERE e.grade IS NULL;

-- 4. Get the Average Grade for a Course
SELECT c.course_name, AVG(CASE 
    WHEN e.grade = 'A' THEN 4
    WHEN e.grade = 'B' THEN 3
    WHEN e.grade = 'C' THEN 2
    WHEN e.grade = 'D' THEN 1
    ELSE 0
END) AS avg_grade 
FROM enrollments e
JOIN courses c ON e.course_id = c.course_id
WHERE c.course_name = 'Database Systems';

-- 5. Find the Courses with More than 3 Students Enrolled
SELECT c.course_name, COUNT(e.student_id) AS num_students 
FROM enrollments e
JOIN courses c ON e.course_id = c.course_id
GROUP BY e.course_id
HAVING COUNT(e.student_id) > 3;

-- 6. Get the List of Instructors for a Specific Course
SELECT i.first_name, i.last_name FROM instructors i
JOIN course_instructors ci ON i.instructor_id = ci.instructor_id
JOIN courses c ON ci.course_id = c.course_id
WHERE c.course_name = 'Database Systems';

-- 7. Find the Course with the Most Enrollments
SELECT c.course_name, COUNT(e.student_id) AS num_students
FROM enrollments e
JOIN courses c ON e.course_id = c.course_id
GROUP BY e.course_id
ORDER BY num_students DESC
LIMIT 1;

-- 8. List Students Who Have Completed All Their Courses
SELECT s.student_id, s.first_name, s.last_name
FROM students s
WHERE NOT EXISTS (
    SELECT 1 FROM enrollments e
    WHERE e.student_id = s.student_id AND e.grade IS NULL
);

-- 9. Update Student Information
UPDATE students SET email = 'amit_new@example.com' WHERE student_id = 1;

-- 10. Delete Students Who Haven't Enrolled in Any Courses
SET SQL_SAFE_UPDATES = 0;
DELETE FROM students WHERE student_id NOT IN (SELECT DISTINCT student_id FROM enrollments);
SET SQL_SAFE_UPDATES = 1;

-- 11. List All Students, Their Enrolled Courses, and Their Grades
SELECT s.first_name, s.last_name, c.course_name, e.grade
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id;

-- 12. Find the Total Credits of Courses a Student is Enrolled In
SELECT s.student_id, s.first_name, s.last_name, SUM(c.credits) AS total_credits
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id
WHERE s.student_id = 1
GROUP BY s.student_id;

-- 13. Top 3 Students by Highest Average Grade
SELECT s.student_id, s.first_name, s.last_name, 
       AVG(CASE 
           WHEN e.grade = 'A' THEN 4
           WHEN e.grade = 'B' THEN 3
           WHEN e.grade = 'C' THEN 2
           WHEN e.grade = 'D' THEN 1
           ELSE 0
       END) AS avg_grade
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
GROUP BY s.student_id
ORDER BY avg_grade DESC
LIMIT 3;
