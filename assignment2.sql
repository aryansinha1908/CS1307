USE University;
-- Question 1
SELECT name FROM instructor WHERE dept_name = 'Biology';

-- Question 2
SELECT course_id FROM course WHERE dept_name = 'Comp. Sci.' AND credits = 3;

-- Question 3
SELECT c.course_id, c.title FROM takes AS t, course AS c WHERE t.course_id = c.course_id AND t.ID = '12345';

-- Question 4
SELECT sum(credits) FROM takes AS t, course AS c WHERE t.course_id = c.course_id AND t.ID = '12345';

-- Question 5
SELECT ID, sum(credits) FROM takes AS t, course AS c WHERE t.course_id = c.course_id GROUP BY ID;

-- Question 6
SELECT s.name FROM takes AS t, course AS c, student AS s WHERE t.course_id = c.course_id AND c.dept_name = 'Comp. Sci.' AND s.ID = t.ID;

-- Question 7
(SELECT i.ID FROM instructor AS i) EXCEPT (SELECT i.ID FROM instructor AS i, teaches AS t WHERE i.ID = t.ID);

-- Question 8
(SELECT i.ID, i.name FROM instructor AS i) EXCEPT (SELECT i.ID, i.name FROM instructor AS i, teaches AS t WHERE i.ID = t.ID);

-- Question 9
DROP DATABASE IF EXISTS Movies;
CREATE DATABASE Movies;
USE Movies;

CREATE TABLE actors (
    AID numeric(5, 0),
    name varchar(100),
    PRIMARY KEY(AID)
);

CREATE TABLE movies (
    MID numeric(5, 0),
    title varchar(100),
    PRIMARY KEY(MID)
);

CREATE TABLE actor_role (
    MID numeric(5, 0),
    AID numeric(5, 0),
    rolename varchar(100),
    PRIMARY KEY(MID, AID, rolename),
    FOREIGN KEY(AID) REFERENCES actors(AID),
    FOREIGN KEY(MID) REFERENCES movies(MID)
);

-- Question 10
INSERT INTO actors (AID, name) VALUES
(1, 'Charlie Chaplin'),
(2, 'Robert Downey Jr.'),
(3, 'Cillian Murphy'),
(4, 'Aryan Sinha');

INSERT INTO movies (MID, title) VALUES
(101, 'Modern Times'),
(102, 'The Great Dictator'),
(103, 'Oppenheimer'),
(104, 'Iron Man');

INSERT INTO actor_role (MID, AID, rolename) VALUES
(101, 1, 'A Factory Worker / The Tramp'),
(102, 1, 'Adenoid Hynkel / Jewish Barber'),
(103, 3, 'J. Robert Oppenheimer'),
(103, 2, 'Lewis Strauss'),
(104, 2, 'Tony Stark / Iron Man');

-- Question 11
SELECT m.title, count(DISTINCT r.MID) AS roles FROM movies as m, actors as a, actor_role as r WHERE a.name = "Charlie Chaplin" AND r.AID = a.AID AND m.MID = r.MID GROUP BY m.title;

-- Question 12
(SELECT name FROM actors) EXCEPT (SELECT a.name FROM actors as a, actor_role as r WHERE a.AID = r.AID);

-- Question 13
SELECT a.name , m.title FROM actors AS a, actor_role AS r, movies AS m WHERE a.AID = r.AID AND r.MID = m.MID
UNION ALL
SELECT a.name , NULL FROM actors AS a WHERE a.AID NOT IN (SELECT DISTINCT AID FROM actor_role);
