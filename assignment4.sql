
-- Question 1
DROP DATABASE IF EXISTS Bank;
CREATE DATABASE Bank;
USE Bank;

CREATE TABLE branch (
    branch_name VARCHAR(20),
    branch_city VARCHAR(20),
    assets NUMERIC(10, 2),
    PRIMARY KEY (branch_name)
);

CREATE TABLE customer (
    ID NUMERIC(5, 0),
    customer_name VARCHAR(20),
    customer_street VARCHAR(20),
    customer_city VARCHAR(20),
    PRIMARY KEY (ID)
);

CREATE TABLE loan (
    loan_number NUMERIC(8, 0),
    branch_name VARCHAR(20),
    amount INT,
    PRIMARY KEY (loan_number),
    FOREIGN KEY (branch_name) REFERENCES branch(branch_name)
);

CREATE TABLE borrower (
    ID NUMERIC(5, 0),
    loan_number NUMERIC(8, 0),
    PRIMARY KEY (ID, loan_number),
    FOREIGN KEY (ID) REFERENCES customer(ID),
    FOREIGN KEY (loan_number) REFERENCES loan(loan_number)
);

CREATE TABLE account (
    account_number NUMERIC(5, 0),
    branch_name VARCHAR(20),
    balance INT,
    PRIMARY KEY (account_number),
    FOREIGN KEY (branch_name) REFERENCES branch(branch_name)
);

CREATE TABLE depositor (
    ID NUMERIC(5, 0),
    account_number NUMERIC(5, 0),
    PRIMARY KEY (ID, account_number),
    FOREIGN KEY (ID) REFERENCES customer(ID),
    FOREIGN KEY (account_number) REFERENCES account(account_number)
);

INSERT INTO branch (branch_name, branch_city, assets) VALUES
('Downtown', 'Brooklyn', 9000000),
('Uptown', 'Brooklyn', 5000000),
('Central', 'Harrison', 3000000);

INSERT INTO customer (ID, customer_name, customer_street, customer_city) VALUES
(12345, 'Alice Smith', 'Oak St', 'Harrison'),
(67890, 'Bob Jones', 'Oak St', 'Harrison'),
(11111, 'Charlie Brown', 'Pine St', 'Brooklyn');

INSERT INTO account (account_number, branch_name, balance) VALUES
(101, 'Downtown', 500),
(102, 'Uptown', 1200),
(103, 'Central', 850);

INSERT INTO depositor (ID, account_number) VALUES
(12345, 103),
(11111, 101),
(11111, 102);

INSERT INTO loan (loan_number, branch_name, amount) VALUES
(11, 'Downtown', 10000),
(12, 'Central', 5000);

INSERT INTO borrower (ID, loan_number) VALUES
(67890, 12),
(11111, 11);


-- Q1(a)
SELECT ID
FROM customer
WHERE ID IN (
    SELECT ID
    FROM depositor
)
AND ID NOT IN (
    SELECT ID
    FROM borrower
);


-- Q1(b)
SELECT ID
FROM customer
WHERE customer_street = (
    SELECT customer_street
    FROM customer
    WHERE ID = 12345
)
AND customer_city = (
    SELECT customer_city
    FROM customer
    WHERE ID = 12345
)
AND ID <> 12345;


-- Q1(c)
SELECT DISTINCT a.branch_name
FROM customer AS c
JOIN depositor AS d ON c.ID = d.ID
JOIN account AS a ON d.account_number = a.account_number
WHERE c.customer_city = 'Harrison';


-- Question 2

DROP DATABASE IF EXISTS Employee;
CREATE DATABASE Employee;
USE Employee;

CREATE TABLE employee (
    ID NUMERIC(5),
    person_name VARCHAR(20),
    street VARCHAR(50),
    city VARCHAR(50),
    PRIMARY KEY (ID)
);

CREATE TABLE company (
    company_name VARCHAR(50),
    city VARCHAR(50),
    PRIMARY KEY (company_name, city)
);

CREATE TABLE works (
    ID NUMERIC(5),
    company_name VARCHAR(50),
    salary INT,
    PRIMARY KEY (ID),
    FOREIGN KEY (ID) REFERENCES employee(ID),
    FOREIGN KEY (company_name) REFERENCES company(company_name)
);

CREATE TABLE manages (
    ID NUMERIC(5),
    manager_id NUMERIC(5),
    PRIMARY KEY (ID),
    FOREIGN KEY (manager_id) REFERENCES employee(ID)
);

INSERT INTO company (company_name, city) VALUES
('First Bank Corporation', 'New York'),
('Small Bank Corporation', 'Chicago'),
('Small Bank Corporation', 'New York');

INSERT INTO employee (ID, person_name, street, city) VALUES
(12345, 'Eve Davis', 'Main St', 'Oldtown'),
(84324, 'John Doe', '1st Ave', 'New York'),
(32145, 'Mary Major', '2nd Ave', 'Chicago'),
(87193, 'Richard Roe', '1st Ave', 'New York');

INSERT INTO works (ID, company_name, salary) VALUES
(12345, 'First Bank Corporation', 105000),
(84324, 'First Bank Corporation', 9500),
(32145, 'Small Bank Corporation', 60000),
(87193, 'First Bank Corporation', 15000);

INSERT INTO manages (ID, manager_id) VALUES
(84324, 12345),
(87193, 12345);


-- Q2(a)
SELECT employee.ID, person_name AS Name, city
FROM employee
JOIN works ON employee.ID = works.ID
WHERE company_name = 'First Bank Corporation';

-- Q2(b)
SELECT employee.ID, person_name AS Name, city
FROM employee
JOIN works ON employee.ID = works.ID
WHERE company_name = 'First Bank Corporation' AND salary > 10000;

-- Q2(c)
SELECT employee.ID
FROM employee
JOIN works ON employee.ID = works.ID
WHERE works.company_name <> 'First Bank Corporation';

-- Q2(d)
SELECT employee.ID
FROM employee
JOIN works ON employee.ID = works.ID
WHERE works.salary > ALL (
    SELECT salary
    FROM works
    WHERE company_name = 'Small Bank Corporation'
);

-- Q2(e)
SELECT c.company_name
FROM company AS c
WHERE NOT EXISTS (
    SELECT s.city
    FROM company AS s
    WHERE s.company_name = 'Small Bank Corporation'
      AND NOT EXISTS (
          SELECT *
          FROM company AS c2
          WHERE c2.company_name = c.company_name
            AND c2.city = s.city
      )
);

-- Q2(f)
SELECT company_name
FROM works
GROUP BY company_name
HAVING COUNT(*) = (
    SELECT MAX(emp_count)
    FROM (
        SELECT COUNT(*) AS emp_count
        FROM works
        GROUP BY company_name
    ) AS counts
);


-- Q2(g)
SELECT company_name
FROM works
GROUP BY company_name
HAVING AVG(salary) > (
    SELECT AVG(salary)
    FROM works
    WHERE company_name = 'First Bank Corporation'
);

-- Question 3

-- Q3(a)
UPDATE employee
SET city = 'Newton'
WHERE ID = 12345;

-- Q3(b)
UPDATE works AS w
JOIN manages AS m ON w.ID = m.manager_id
SET w.salary = CASE
    WHEN w.salary * 1.10 > 100000 THEN w.salary * 1.03
    ELSE w.salary * 1.10
END
WHERE w.company_name = 'First Bank Corporation';

-- Question 4

USE Bank;

-- Q4(a)
SELECT d.ID
FROM depositor AS d
JOIN account AS a ON d.account_number = a.account_number
JOIN branch AS b ON a.branch_name = b.branch_name
WHERE b.branch_city = 'Brooklyn'
GROUP BY d.ID
HAVING COUNT(DISTINCT b.branch_name) = (
    SELECT COUNT(*)
    FROM branch
    WHERE branch_city = 'Brooklyn'
);

-- Q4(b)
SELECT SUM(amount) AS total_loan_amount
FROM loan;

-- Q4(c)
SELECT branch_name
FROM branch
WHERE assets > SOME (
    SELECT assets
    FROM branch
    WHERE branch_city = 'Brooklyn'
);

-- Question 5

USE Employee;

-- Q5(a)
SELECT e.ID, e.person_name
FROM employee e
JOIN works w ON e.ID = w.ID
JOIN company c ON w.company_name = c.company_name
WHERE e.city = c.city;

-- Q5(b)
SELECT e.ID, e.person_name
FROM employee e
JOIN manages m ON e.ID = m.ID
JOIN employee mgr ON m.manager_id = mgr.ID
WHERE e.city = mgr.city AND e.street = mgr.street;

-- Q5(c)
SELECT e.ID, e.person_name
FROM employee e
JOIN works w ON e.ID = w.ID
WHERE w.salary > (
    SELECT AVG(w2.salary)
    FROM works w2
    WHERE w2.company_name = w.company_name
);

-- Q5(d)
SELECT company_name
FROM works
GROUP BY company_name
HAVING SUM(salary) <= ALL (
    SELECT SUM(salary)
    FROM works
    GROUP BY company_name
);

-- Question 6

-- Q6(a)
UPDATE works
SET salary = salary * 1.10
WHERE company_name = 'First Bank Corporation';

-- Q6(b)
UPDATE works
SET salary = salary * 1.10
WHERE company_name = 'First Bank Corporation'
AND ID IN (
    SELECT manager_id
    FROM manages
);

-- Q6(c)
DELETE FROM works
WHERE company_name = 'Small Bank Corporation';

--
-- -- QUESTION 7
--
-- -- Q7(a)
-- SELECT SUM(c.credits * gp.points) AS total_grade_points
-- FROM takes t
-- JOIN course c ON t.course_id = c.course_id
-- JOIN grade_points gp ON t.grade = gp.grade
-- WHERE t.ID = '12345';
--
-- -- Q7(b)
-- SELECT SUM(c.credits * gp.points) / SUM(c.credits) AS GPA
-- FROM takes t
-- JOIN course c ON t.course_id = c.course_id
-- JOIN grade_points gp ON t.grade = gp.grade
-- WHERE t.ID = '12345';
--
-- -- Q7(c)
-- SELECT t.ID, SUM(c.credits * gp.points) / SUM(c.credits) AS GPA
-- FROM takes t
-- JOIN course c ON t.course_id = c.course_id
-- JOIN grade_points gp ON t.grade = gp.grade
-- GROUP BY t.ID;
--
-- -- Q7(d)
-- SELECT t.ID, SUM(c.credits * gp.points) / SUM(c.credits) AS GPA
-- FROM takes t
-- JOIN course c ON t.course_id = c.course_id
-- JOIN grade_points gp ON t.grade = gp.grade
-- WHERE t.grade IS NOT NULL
-- GROUP BY t.ID;
