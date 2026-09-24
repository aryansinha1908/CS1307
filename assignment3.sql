USE University;

-- Question 1

SELECT ID FROM student NATURAL LEFT OUTER JOIN takes WHERE course_id IS NULL;

-- Question 2

SELECT * FROM student NATURAL LEFT OUTER JOIN advisor WHERE i_ID IS NULL;

-- Question 3

-- 3 A
INSERT IGNORE INTO course(course_id, title, dept_name, credits) VALUES
('CS-001', 'Weekly Seminar', 'Comp. Sci.', 0);

SELECT * FROM course;

-- 3 B
INSERT IGNORE INTO section(course_id, sec_id, semester, year, building, room_number, time_slot_id) VALUES
('CS-001', 1, 'Fall', 2017, NULL, NULL, NULL);

SELECT * FROM section;

-- 3 C 
INSERT IGNORE INTO takes (ID, course_id, sec_id, semester, year)
SELECT DISTINCT student.ID, 'CS-001', 1, 'Fall', 2017
FROM student, section
WHERE student.dept_name = 'Comp. Sci.';

SELECT * FROM takes;

-- 3 D
DELETE FROM takes WHERE ID = '12345';

SELECT * FROM takes;

-- 3 E 

DELETE FROM section WHERE course_id = 'CS-001';
DELETE FROM course WHERE course_id = 'CS-001';

SELECT * FROM takes;
SELECT * FROM section;

-- 3 F
DELETE FROM takes WHERE course_id IN
(
    SELECT course_id 
    FROM course 
    WHERE LOWER(title) LIKE '%advanced%'
);

-- Question 4

SELECT d1.dept_name FROM department AS d1, department AS d2 WHERE d1.dept_name != 'Philosophy' AND d2.dept_name = 'Philosophy' AND d1.budget > d2.budget;

-- Question 5

SELECT course_id, ID FROM takes GROUP BY ID, course_id HAVING count(*) >= 3 ORDER BY course_id;


-- Question 7

SELECT ID, name FROM student WHERE dept_name = 'History' AND LOWER(name) LIKE 'd%'
AND ID NOT IN (
    SELECT takes.ID
    FROM takes
    JOIN course ON takes.course_id = course.course_id
    WHERE course.dept_name = 'Music'
    GROUP BY takes.ID
    HAVING COUNT(takes.course_id) >= 5
);

-- Question 8

WITH enrollment AS (
    SELECT course_id, sec_id, year, semester, COUNT(*) AS num
    FROM takes
    GROUP BY course_id, sec_id, year, semester
)
SELECT course_id, sec_id, year, semester, num
FROM enrollment
WHERE num = (
    SELECT MAX(num) FROM enrollment
);

-- Question 9

SELECT i.ID, i.name
FROM instructor AS i
WHERE NOT EXISTS (
    SELECT *
    FROM teaches AS t
    JOIN takes AS tk
    ON t.course_id = tk.course_id
    AND t.sec_id = tk.sec_id
    AND t.semester = tk.semester
    AND t.year = tk.year
    WHERE t.ID = i.ID
    AND tk.grade = 'A'
);

-- Question 10

SELECT i.ID, i.name
FROM instructor AS i
WHERE EXISTS (
    SELECT *
    FROM teaches AS t
    JOIN takes AS tk
    ON t.course_id = tk.course_id
    AND t.sec_id = tk.sec_id
    AND t.semester = tk.semester
    AND t.year = tk.year
    WHERE t.ID = i.ID
    AND tk.grade IS NOT NULL
)
AND NOT EXISTS (
    SELECT *
    FROM teaches AS t
    JOIN takes AS tk
    ON t.course_id = tk.course_id
    AND t.sec_id = tk.sec_id
    AND t.semester = tk.semester
    AND t.year = tk.year
    WHERE t.ID = i.ID
    AND tk.grade = 'A'
);
