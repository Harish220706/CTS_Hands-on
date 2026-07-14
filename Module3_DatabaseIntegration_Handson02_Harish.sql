USE college_db;

-- =====================================================
-- Task 1 : Insert, Update and Delete Data
-- =====================================================

-- 15. Insert Sample Data

INSERT INTO departments (dept_name, hod_name, budget)
VALUES
('Computer Science','Dr. Ramesh Kumar',850000.00),
('Electronics','Dr. Priya Nair',620000.00),
('Mechanical','Dr. Suresh Iyer',540000.00),
('Civil','Dr. Ananya Sharma',430000.00);

INSERT INTO students
(first_name,last_name,email,date_of_birth,department_id,enrollment_year)
VALUES
('Arjun','Mehta','arjun.mehta@college.edu','2003-04-12',1,2022),
('Priya','Suresh','priya.suresh@college.edu','2003-07-25',1,2022),
('Rohan','Verma','rohan.verma@college.edu','2002-11-08',2,2021),
('Sneha','Patel','sneha.patel@college.edu','2004-01-30',3,2023),
('Vikram','Das','vikram.das@college.edu','2003-09-14',1,2022),
('Kavya','Menon','kavya.menon@college.edu','2002-05-17',2,2021),
('Aditya','Singh','aditya.singh@college.edu','2004-03-22',4,2023),
('Deepika','Rao','deepika.rao@college.edu','2003-08-09',1,2022);

INSERT INTO courses
(course_name,course_code,credits,department_id)
VALUES
('Data Structures & Algorithms','CS101',4,1),
('Database Management Systems','CS102',3,1),
('Object Oriented Programming','CS103',4,1),
('Circuit Theory','EC101',3,2),
('Thermodynamics','ME101',3,3);

INSERT INTO enrollments
(student_id,course_id,enrollment_date,grade)
VALUES
(1,1,'2022-07-01','A'),
(1,2,'2022-07-01','B'),
(2,1,'2022-07-01','B'),
(2,3,'2022-07-01','A'),
(3,4,'2021-07-01','A'),
(4,5,'2023-07-01',NULL),
(5,1,'2022-07-01','C'),
(5,2,'2022-07-01','A'),
(6,4,'2021-07-01','B'),
(7,5,'2023-07-01',NULL),
(8,1,'2022-07-01','A'),
(8,3,'2022-07-01','B');

INSERT INTO professors
(prof_name,email,department_id,salary)
VALUES
('Dr. Anand Krishnan','anand.k@college.edu',1,95000),
('Dr. Meena Pillai','meena.p@college.edu',1,88000),
('Dr. Sunil Rajan','sunil.r@college.edu',2,82000),
('Dr. Latha Gopal','latha.g@college.edu',3,79000),
('Dr. Kartik Bose','kartik.b@college.edu',4,76000);

-- 16. Insert two additional students

INSERT INTO students
(first_name,last_name,email,date_of_birth,department_id,enrollment_year)
VALUES
('Ananya','G','ananya.g@college.edu','2004-02-20',1,2022),
('Rahul','Kumar','rahul.kumar@college.edu','2003-10-15',2,2022);

-- 17. Update grade

UPDATE enrollments
SET grade='B'
WHERE student_id=5
AND course_id=1;

-- 18. Preview NULL grades

SELECT *
FROM enrollments
WHERE grade IS NULL;

SET SQL_SAFE_UPDATES=0;

DELETE FROM enrollments
WHERE grade IS NULL;

SET SQL_SAFE_UPDATES=1;

-- 19. Verify row counts

SELECT COUNT(*) AS Total_Departments FROM departments;
SELECT COUNT(*) AS Total_Students FROM students;
SELECT COUNT(*) AS Total_Courses FROM courses;
SELECT COUNT(*) AS Total_Enrollments FROM enrollments;
SELECT COUNT(*) AS Total_Professors FROM professors;

-- =====================================================
-- Task 2 : Single Table Queries
-- =====================================================

-- 20

SELECT *
FROM students
WHERE enrollment_year=2022
ORDER BY last_name;

-- 21

SELECT *
FROM courses
WHERE credits>3
ORDER BY credits DESC;

-- 22

SELECT *
FROM professors
WHERE salary BETWEEN 80000 AND 95000;

-- 23

SELECT *
FROM students
WHERE email LIKE '%@college.edu';

-- 24

SELECT enrollment_year,
COUNT(*) AS total_students
FROM students
GROUP BY enrollment_year;

-- =====================================================
-- Task 3 : Multi Table Joins
-- =====================================================

-- 25

SELECT
CONCAT(s.first_name,' ',s.last_name) AS student_name,
d.dept_name
FROM students s
JOIN departments d
ON s.department_id=d.department_id;

-- 26

SELECT
CONCAT(s.first_name,' ',s.last_name) AS student_name,
c.course_name
FROM enrollments e
JOIN students s
ON e.student_id=s.student_id
JOIN courses c
ON e.course_id=c.course_id;

-- 27

SELECT s.*
FROM students s
LEFT JOIN enrollments e
ON s.student_id=e.student_id
WHERE e.student_id IS NULL;

-- 28

SELECT
c.course_name,
COUNT(e.enrollment_id) AS total_students
FROM courses c
LEFT JOIN enrollments e
ON c.course_id=e.course_id
GROUP BY c.course_name;

-- 29

SELECT
d.dept_name,
p.prof_name,
p.salary
FROM departments d
LEFT JOIN professors p
ON d.department_id=p.department_id;

-- =====================================================
-- Task 4 : Aggregate Functions
-- =====================================================

-- 30

SELECT
c.course_name,
COUNT(e.enrollment_id) AS enrollment_count
FROM courses c
LEFT JOIN enrollments e
ON c.course_id=e.course_id
GROUP BY c.course_name;

-- 31

SELECT
d.dept_name,
ROUND(AVG(p.salary),2) AS average_salary
FROM departments d
LEFT JOIN professors p
ON d.department_id=p.department_id
GROUP BY d.dept_name;

-- 32

SELECT
dept_name,
budget
FROM departments
WHERE budget>600000;

-- 33

SELECT
grade,
COUNT(*) AS total_students
FROM enrollments e
JOIN courses c
ON e.course_id=c.course_id
WHERE c.course_code='CS101'
GROUP BY grade;

-- 34

SELECT
d.dept_name,
COUNT(e.enrollment_id) AS total_enrollments
FROM departments d
JOIN students s
ON d.department_id=s.department_id
JOIN enrollments e
ON s.student_id=e.student_id
GROUP BY d.dept_name
HAVING COUNT(e.enrollment_id)>2;