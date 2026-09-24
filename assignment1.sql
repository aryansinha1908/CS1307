DROP DATABASE IF EXISTS University;
CREATE DATABASE University;
USE University;

CREATE TABLE classroom (
    building varchar(15),
    room_number varchar(7),
    capacity numeric(4, 0),
    PRIMARY KEY(building, room_number)
);

CREATE TABLE department (
    dept_name varchar(15),
    building varchar(15),
    budget numeric(12, 2) CHECK (budget > 0),
    PRIMARY KEY(dept_name)
);

CREATE TABLE course (
    course_id varchar(8),
    title varchar(50),
    dept_name varchar(15),
    credits numeric(2, 0) CHECK (credits >= 0),
    PRIMARY KEY(course_id),
    FOREIGN KEY(dept_name) REFERENCES department(dept_name) ON DELETE SET NULL
);

CREATE TABLE instructor (
    ID varchar(5),
    name varchar(20) NOT NULL,
    dept_name varchar(15),
    salary numeric(8, 2),
    PRIMARY KEY(ID),
    FOREIGN KEY(dept_name) REFERENCES department(dept_name) ON DELETE SET NULL
);

CREATE TABLE section (
    course_id varchar(8),
    sec_id varchar(8),
    semester varchar(6) CHECK (semester IN ('Fall', 'Winter', 'Spring', 'Summer')),
    year numeric(4, 0) CHECK (year > 1701 AND year < 2100),
    building varchar(15),
    room_number varchar(7),
    time_slot_id varchar(4),
    PRIMARY KEY(course_id, sec_id, semester, year),
    FOREIGN KEY(course_id) REFERENCES course(course_id) ON DELETE CASCADE, 
    FOREIGN KEY(building, room_number) REFERENCES classroom(building, room_number) ON DELETE SET NULL
);

CREATE TABLE teaches (
    ID varchar(5),
    course_id varchar(8),
    sec_id varchar(8),
    semester varchar(6),
    year numeric(4, 0),
    PRIMARY KEY(ID, course_id, sec_id, semester, year),
    FOREIGN KEY(course_id, sec_id, semester, year) REFERENCES section(course_id, sec_id, semester, year) ON DELETE CASCADE,
    FOREIGN KEY(ID) REFERENCES instructor(ID) ON DELETE CASCADE
);

CREATE TABLE student (
    ID varchar(5),
    name varchar(20) NOT NULL,
    dept_name varchar(15),
    tot_cred numeric(3, 0) CHECK (tot_cred >= 0),
    PRIMARY KEY(ID),
    FOREIGN KEY(dept_name) REFERENCES department(dept_name) ON DELETE SET NULL
);

CREATE TABLE takes (
    ID varchar(5),
    course_id varchar(8),
    sec_id varchar(8),
    semester varchar(6),
    year numeric(4, 0),
    grade varchar(2),
    PRIMARY KEY(ID, course_id, sec_id, semester, year),
    FOREIGN KEY(course_id, sec_id, semester, year) REFERENCES section(course_id, sec_id, semester, year) ON DELETE CASCADE,
    FOREIGN KEY(ID) REFERENCES student(ID) ON DELETE CASCADE
);

CREATE TABLE advisor (
    s_ID varchar(5),
    i_ID varchar(5),
    PRIMARY KEY(s_ID),
    FOREIGN KEY(i_ID) REFERENCES instructor(ID) ON DELETE SET NULL,
    FOREIGN KEY(s_ID) REFERENCES student(ID) ON DELETE CASCADE
);

CREATE TABLE prereq (
    course_id varchar(8),
    prereq_id varchar(8),
    PRIMARY KEY(course_id, prereq_id),
    FOREIGN KEY(course_id) REFERENCES course(course_id) ON DELETE CASCADE,
    FOREIGN KEY(prereq_id) REFERENCES course(course_id)
);

CREATE TABLE timeslot (
    time_slot_id varchar(4),
    day varchar(1) CHECK (day IN ('M', 'T', 'W', 'R', 'F', 'S', 'U')),
    start_time time,
    end_time time,
    PRIMARY KEY(time_slot_id, day, start_time)
);

INSERT INTO classroom(building, room_number, capacity) VALUES
('Packard', '101', 50),
('Painter', '514', 10),
('Taylor', '3128', 70),
('Watson', '100', 30),
('Watson', '120', 50);

INSERT INTO department(dept_name, building, budget) VALUES
('Biology', 'Watson', 90000),
('Comp. Sci.', 'Taylor', 100000),
('Elec. Eng.', 'Taylor', 85000),
('Finance', 'Painter', 120000),
('History', 'Painter', 50000),
('Music', 'Packard', 80000),
('Physics', 'Watson', 70000);

INSERT INTO course(course_id, title, dept_name, credits) VALUES  
('BIO-101', 'Intro. to Biology', 'Biology', 4),
('BIO-301', 'Genetics', 'Biology', 4),
('BIO-399', 'Computational Biology', 'Biology', 3),
('CS-101', 'Intro. to Computer Science', 'Comp. Sci.', 4),
('CS-190', 'Game Design', 'Comp. Sci.', 4),
('CS-315', 'Robotics', 'Comp. Sci.', 3),
('CS-319', 'Image Processing', 'Comp. Sci.', 3),
('CS-347', 'Database System Concepts', 'Comp. Sci.', 3),
('EE-181', 'Intro. to Digital Systems', 'Elec. Eng.', 3),
('FIN-201', 'Investment Banking', 'Finance', 3),
('HIS-351', 'World History', 'History', 3),
('MU-199', 'Music Video Production', 'Music', 3),
('PHY-101', 'Physical Principles', 'Physics', 4);

INSERT INTO instructor(ID, name, dept_name, salary) VALUES
(10101, 'Srinivasan', 'Comp. Sci.', 65000),
(12121, 'Wu','Finance', 90000),
(15151, 'Mozart', 'Music', 40000),
(22222, 'Einstein', 'Physics', 95000),
(32343, 'El Said', 'History', 60000),
(33456, 'Gold', 'Physics', 87000),
(45565, 'Katz', 'Comp. Sci.', 75000),
(58583, 'Califieri', 'History', 62000),
(76543, 'Singh', 'Finance', 80000),
(76766, 'Crick', 'Biology', 72000),
(83821, 'Brandt', 'Comp. Sci.', 92000),
(98345, 'Kim', 'Elec. Eng.', 80000);

INSERT INTO section(course_id, sec_id, semester, year, building, room_number, time_slot_id) VALUES
('BIO-101', 1, 'Summer', 2017, 'Painter', 514, 'B'),
('BIO-301', 1, 'Summer', 2018, 'Painter', 514, 'A'),
('CS-101', 1, 'Fall', 2017, 'Packard', 101, 'H'),
('CS-101', 1, 'Spring', 2018, 'Packard', 101, 'F'),
('CS-190', 1, 'Spring', 2017, 'Taylor', 3128, 'E'),
('CS-190', 2, 'Spring', 2017, 'Taylor', 3128, 'A'),
('CS-315', 1, 'Spring', 2018, 'Watson', 120, 'D'),
('CS-319', 1, 'Spring', 2018, 'Watson', 100, 'B'),
('CS-319', 2, 'Spring', 2018, 'Taylor', 3128, 'C'),
('CS-347', 1, 'Fall', 2017, 'Taylor', 3128, 'A'),
('EE-181', 1, 'Spring', 2017, 'Taylor', 3128, 'C'),
('FIN-201', 1, 'Spring', 2018, 'Packard', 101, 'B'),
('HIS-351', 1, 'Spring', 2018, 'Painter', 514, 'C'),
('MU-199', 1, 'Spring', 2018, 'Packard', 101, 'D'),
('PHY-101', 1, 'Fall', 2017, 'Watson', 100, 'A');

INSERT INTO teaches(ID, course_id, sec_id, semester, year) VALUES
('10101', 'CS-101', 1, 'Fall', 2017),
('10101', 'CS-315', 1, 'Spring', 2018),
('10101', 'CS-347', 1, 'Fall', 2017),
('12121', 'FIN-201', 1, 'Spring', 2018),
('15151', 'MU-199', 1, 'Spring', 2018),
('22222', 'PHY-101', 1, 'Fall', 2017),
('32343', 'HIS-351', 1, 'Spring', 2018),
('45565', 'CS-101', 1, 'Spring', 2018),
('45565', 'CS-319', 1, 'Spring', 2018),
('76766', 'BIO-101', 1, 'Summer', 2017),
('76766', 'BIO-301', 1, 'Summer', 2018),
('83821', 'CS-190', 1, 'Spring', 2017),
('83821', 'CS-190', 2, 'Spring', 2017),
('83821', 'CS-319', 2, 'Spring', 2018),
('98345', 'EE-181', 1, 'Spring', 2017);

INSERT INTO student(ID, name, dept_name, tot_cred) VALUES
('00128', 'Zhang', 'Comp. Sci.', 102),
('12345', 'Shankar', 'Comp. Sci.', 32),
('19991', 'Brandt', 'History', 80),
('23121', 'Chavez', 'Finance', 110),
('44553', 'Peltier', 'Physics', 56),
('45678', 'Levy', 'Physics', 46),
('54321', 'Williams', 'Comp. Sci.', 54),
('55739', 'Sanchez', 'Music', 38),
('70557', 'Snow', 'Physics', 0),
('76543', 'Brown', 'Comp. Sci.', 58),
('76653', 'Aoi', 'Elec. Eng.', 60),
('98765', 'Bourikas', 'Elec. Eng.', 98),
('98988', 'Tanaka', 'Biology', 120);

INSERT INTO takes (ID, course_id, sec_id, semester, year, grade) VALUES
('00128', 'CS-101', '1', 'Fall', 2017, 'A'),
('00128', 'CS-347', '1', 'Fall', 2017, 'A-'),
('12345', 'CS-101', '1', 'Fall', 2017, 'C'),
('12345', 'CS-190', '2', 'Spring', 2017, 'A'),
('12345', 'CS-315', '1', 'Spring', 2018, 'A'),
('12345', 'CS-347', '1', 'Fall', 2017, 'A'),
('19991', 'HIS-351', '1', 'Spring', 2018, 'B'),
('23121', 'FIN-201', '1', 'Spring', 2018, 'C+'),
('44553', 'PHY-101', '1', 'Fall', 2017, 'B-'),
('45678', 'CS-101', '1', 'Fall', 2017, 'F'),
('45678', 'CS-101', '1', 'Spring', 2018, 'B+'),
('45678', 'CS-319', '1', 'Spring', 2018, 'B'),
('54321', 'CS-101', '1', 'Fall', 2017, 'A-'),
('54321', 'CS-190', '2', 'Spring', 2017, 'B+'),
('55739', 'MU-199', '1', 'Spring', 2018, 'A-'),
('76543', 'CS-101', '1', 'Fall', 2017, 'A'),
('76543', 'CS-319', '2', 'Spring', 2018, 'A'),
('76653', 'EE-181', '1', 'Spring', 2017, 'C'),
('98765', 'CS-101', '1', 'Fall', 2017, 'C-'),
('98765', 'CS-315', '1', 'Spring', 2018, 'B'),
('98988', 'BIO-101', '1', 'Summer', 2017, 'A'),
('98988', 'BIO-301', '1', 'Summer', 2018, NULL);

INSERT INTO advisor (s_ID, i_ID) VALUES
('00128', '45565'),
('12345', '10101'),
('23121', '76543'),
('44553', '22222'),
('76543', '45565'),
('76653', '98345'),
('98765', '98345');

INSERT INTO timeslot (time_slot_id, day, start_time, end_time) VALUES
('A', 'M', '08:00:00', '08:50:00'),
('A', 'W', '08:00:00', '08:50:00'),
('A', 'F', '08:00:00', '08:50:00'),
('B', 'M', '09:00:00', '09:50:00'),
('B', 'W', '09:00:00', '09:50:00'),
('B', 'F', '09:00:00', '09:50:00'),
('C', 'M', '11:00:00', '11:50:00'),
('C', 'W', '11:00:00', '11:50:00'),
('C', 'F', '11:00:00', '11:50:00'),
('D', 'M', '13:00:00', '13:50:00'),
('D', 'W', '13:00:00', '13:50:00'),
('D', 'F', '13:00:00', '13:50:00'),
('E', 'T', '10:30:00', '11:45:00'),
('E', 'R', '10:30:00', '11:45:00'),
('F', 'T', '14:30:00', '15:45:00'),
('F', 'R', '14:30:00', '15:45:00'),
('G', 'M', '16:00:00', '16:50:00'),
('G', 'W', '16:00:00', '16:50:00'),
('G', 'F', '16:00:00', '16:50:00'),
('H', 'W', '10:00:00', '12:30:00');

INSERT INTO prereq (course_id, prereq_id) VALUES
('BIO-301', 'BIO-101'),
('BIO-399', 'BIO-101'),
('CS-190', 'CS-101'),
('CS-315', 'CS-101'),
('CS-319', 'CS-101'),
('CS-347', 'CS-101'),
('EE-181', 'PHY-101');

SELECT * FROM classroom;
SELECT * FROM department;
SELECT * FROM course;
SELECT * FROM instructor;
SELECT * FROM section;
SELECT * FROM teaches;
SELECT * FROM student;
SELECT * FROM takes;
SELECT * FROM advisor;
SELECT * FROM timeslot;
SELECT * FROM prereq;
