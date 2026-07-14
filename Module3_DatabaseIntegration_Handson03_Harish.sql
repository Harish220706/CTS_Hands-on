USE college_db;

SELECT s.student_id,
       s.first_name,
       s.last_name,
       COUNT(e.course_id) AS total_courses
FROM students s
JOIN enrollments e
ON s.student_id = e.student_id
GROUP BY s.student_id, s.first_name, s.last_name
HAVING COUNT(e.course_id) >
(
    SELECT AVG(course_count)
    FROM
    (
        SELECT COUNT(*) AS course_count
        FROM enrollments
        GROUP BY student_id
    ) AS avg_table
);
SELECT c.course_name
FROM courses c
WHERE NOT EXISTS
(
    SELECT *
    FROM enrollments e
    WHERE e.course_id = c.course_id
    AND e.grade <> 'A'
);
SELECT p.*
FROM professors p
WHERE salary =
(
    SELECT MAX(salary)
    FROM professors
    WHERE department_id = p.department_id
);
SELECT *
FROM
(
    SELECT department_id,
           AVG(salary) AS avg_salary
    FROM professors
    GROUP BY department_id
) AS dept_avg
WHERE avg_salary > 85000;
CREATE VIEW vw_student_enrollment_summary AS
SELECT
    s.student_id,
    CONCAT(s.first_name,' ',s.last_name) AS student_name,
    d.dept_name,
    COUNT(e.course_id) AS total_courses,
    ROUND(
        AVG(
            CASE
                WHEN e.grade='A' THEN 4
                WHEN e.grade='B' THEN 3
                WHEN e.grade='C' THEN 2
                WHEN e.grade='D' THEN 1
                WHEN e.grade='F' THEN 0
            END
        ),2
    ) AS GPA
FROM students s
LEFT JOIN departments d
ON s.department_id=d.department_id
LEFT JOIN enrollments e
ON s.student_id=e.student_id
GROUP BY s.student_id,s.first_name,s.last_name,d.dept_name;
CREATE VIEW vw_course_stats AS
SELECT
    c.course_name,
    c.course_code,
    COUNT(e.enrollment_id) AS total_enrollments,
    ROUND(
        AVG(
            CASE
                WHEN e.grade='A' THEN 4
                WHEN e.grade='B' THEN 3
                WHEN e.grade='C' THEN 2
                WHEN e.grade='D' THEN 1
                WHEN e.grade='F' THEN 0
            END
        ),2
    ) AS avg_gpa
FROM courses c
LEFT JOIN enrollments e
ON c.course_id=e.course_id
GROUP BY c.course_id,c.course_name,c.course_code;
SELECT *
FROM vw_student_enrollment_summary
WHERE GPA > 3.0;
UPDATE vw_student_enrollment_summary
SET student_name='Test Student'
WHERE student_id=1;

Error:
The target table of the UPDATE is not updatable.
DROP VIEW vw_student_enrollment_summary;
DROP VIEW vw_course_stats;
CREATE VIEW vw_student_enrollment_summary AS
SELECT
    student_id,
    first_name,
    last_name,
    enrollment_year
FROM students
WHERE enrollment_year >= 2022
WITH CHECK OPTION;
DELIMITER $$

CREATE PROCEDURE sp_enroll_student(
    IN p_student_id INT,
    IN p_course_id INT,
    IN p_enrollment_date DATE
)
BEGIN

    IF EXISTS(
        SELECT *
        FROM enrollments
        WHERE student_id=p_student_id
        AND course_id=p_course_id
    )
    THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT='Student already enrolled in this course';
    ELSE
        INSERT INTO enrollments(
            student_id,
            course_id,
            enrollment_date
        )
        VALUES(
            p_student_id,
            p_course_id,
            p_enrollment_date
        );
    END IF;

END $$

DELIMITER ;
CALL sp_enroll_student(1,3,'2024-01-10');
CALL sp_enroll_student(1,3,'2024-01-10');
Student already enrolled in this course
CREATE TABLE department_transfer_log
(
    transfer_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT,
    old_department INT,
    new_department INT,
    transfer_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
DELIMITER $$

CREATE PROCEDURE sp_transfer_student(
    IN p_student_id INT,
    IN p_new_department INT
)
BEGIN

    DECLARE old_dept INT;

    START TRANSACTION;

    SELECT department_id
    INTO old_dept
    FROM students
    WHERE student_id=p_student_id;

    UPDATE students
    SET department_id=p_new_department
    WHERE student_id=p_student_id;

    INSERT INTO department_transfer_log(
        student_id,
        old_department,
        new_department
    )
    VALUES(
        p_student_id,
        old_dept,
        p_new_department
    );

    COMMIT;

END $$

DELIMITER ;
CALL sp_transfer_student(1,2);
START TRANSACTION;

UPDATE students
SET department_id=999
WHERE student_id=2;

ROLLBACK;
SELECT *
FROM students
WHERE student_id=2;
START TRANSACTION;
INSERT INTO enrollments
(student_id,course_id,enrollment_date,grade)
VALUES
(9,1,'2024-01-01','A');
SAVEPOINT first_insert;
ROLLBACK TO first_insert;
COMMIT;
SELECT *
FROM enrollments
WHERE student_id=9;
EXPLAIN FORMAT=JSON
SELECT s.first_name,
       s.last_name,
       c.course_name
FROM enrollments e
JOIN students s
ON s.student_id=e.student_id
JOIN courses c
ON c.course_id=e.course_id
WHERE s.enrollment_year=2022;
EXPLAIN
SELECT s.first_name,
       s.last_name,
       c.course_name
FROM enrollments e
JOIN students s
ON s.student_id=e.student_id
JOIN courses c
ON c.course_id=e.course_id
WHERE s.enrollment_year=2022;
CREATE INDEX idx_students_enrollment_year
ON students(enrollment_year);
CREATE UNIQUE INDEX idx_unique_enrollment
ON enrollments(student_id,course_id);
EXPLAIN
SELECT s.first_name,
       s.last_name,
       c.course_name
FROM enrollments e
JOIN students s
ON s.student_id=e.student_id
JOIN courses c
ON c.course_id=e.course_id
WHERE s.enrollment_year=2022;
CREATE INDEX idx_grade_student
ON enrollments(grade,student_id);
