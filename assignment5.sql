USE University;

-- Question 1

SELECT MAX(Enrollments) AS Max_Enrollment, MIN(Enrollments) AS Min_Enrollment
FROM (
    SELECT sec_id, course_id, semester, year, COUNT(ID) AS Enrollments
    FROM takes
    GROUP BY sec_id, course_id, semester, year
    ORDER BY COUNT(ID) DESC
) AS section_enrollments;

-- Question 2

SELECT sec_id, course_id, semester, year, COUNT(*) AS Enrollments
FROM takes
GROUP BY sec_id, course_id, semester, year
HAVING COUNT(*) = (
    SELECT MAX(Enrollments)
    FROM (
        SELECT COUNT(*) AS Enrollments
        FROM takes
        GROUP BY sec_id, course_id, semester, year
    ) AS section_enrollments
);

-- Question 3

-- Part 1
SELECT s.course_id, s.sec_id, s.semester, s.year, (
    SELECT COUNT(*)
    FROM takes t
    WHERE t.course_id = s.course_id
        AND t.sec_id = s.sec_id
        AND t.semester = s.semester
        AND t.year = s.year
    ) AS Enrollments
FROM section s;

-- Part 2
SELECT course_id, sec_id, semester, year,
       COUNT(ID) AS Enrollments
FROM section NATURAL LEFT OUTER JOIN takes
GROUP BY course_id, sec_id, semester, year;

-- Question 4

SELECT course_id
FROM course 
WHERE course_id LIKE "CS-1%";

-- Question 5

-- Part 1
SELECT DISTINCT T.ID
FROM teaches T
WHERE NOT EXISTS (
    (
        SELECT course_id
        FROM course
        WHERE course_id LIKE 'CS-1%'
    ) EXCEPT (
        SELECT course_id
        FROM teaches T2
        WHERE T2.ID = T.ID
    )
);

-- Part 2
SELECT ID
FROM (SELECT DISTINCT ID, course_id FROM teaches) AS T
WHERE course_id IN (SELECT course_id FROM course WHERE course_id LIKE 'CS-1%')
GROUP BY ID
HAVING COUNT(DISTINCT course_id) = (
    SELECT COUNT(*) FROM course WHERE course_id LIKE 'CS-1%'
);

-- Question 6

INSERT IGNORE INTO student(ID, name, dept_name, tot_cred)
SELECT ID, name, dept_name, 0
FROM instructor;

-- Question 7

DELETE FROM student WHERE ID IN (
    SELECT ID
    FROM instructor
);

-- Question 8

UPDATE student
SET tot_cred = (
    SELECT COALESCE(SUM(credits), 0)
    FROM takes NATURAL JOIN course 
    WHERE student.ID = takes.ID 
    AND takes.grade IS NOT NULL 
    AND takes.grade <> 'F'
);

-- Question 9

UPDATE instructor
SET salary = 10000 * (
    SELECT COUNT(course_id)
    FROM teaches
    WHERE instructor.ID = teaches.ID
);

-- Question 10

SELECT ID
FROM teaches
GROUP BY ID
HAVING COUNT(*) > (
    SELECT AVG(section_count)
    FROM (
        SELECT ID, COUNT(*) AS section_count
        FROM teaches
        GROUP BY ID
    ) AS instructor_sections
);
