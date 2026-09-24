DROP DATABASE IF EXISTS Bank ;
CREATE DATABASE Bank;
USE Bank;

CREATE TABLE branch (
    branch_name varchar(20),
    branch_city varchar(20),
    assets numeric(10, 2),
    PRIMARY KEY(branch_name)
);

CREATE TABLE customer (
    ID numeric(5, 0),
    customer_name varchar(20),
    customer_street varchar(20),
    customer_city varchar(20),
    PRIMARY KEY(ID)
);

CREATE TABLE loan (
    loan_number numeric(8, 0),
    branch_name varchar(20),
    amount int,
    PRIMARY KEY(loan_number),
    FOREIGN KEY(branch_name) REFERENCES branch(branch_name)
);

CREATE TABLE borrower (
    ID numeric(5, 0),
    loan_number numeric(8, 0),
    PRIMARY KEY(ID, loan_number),
    FOREIGN KEY(ID) REFERENCES customer(ID),
    FOREIGN KEY(loan_number) REFERENCES loan(loan_number)
);

CREATE TABLE account (
    account_number numeric(5, 0),
    branch_name varchar(20),
    balance int,
    PRIMARY KEY(account_number),
    FOREIGN KEY(branch_name) REFERENCES branch(branch_name)
);

CREATE TABLE depositor (
    ID numeric(5, 0),
    account_number numeric(5, 0),
    PRIMARY KEY(ID, account_number),
    FOREIGN KEY(account_number) REFERENCES account(account_number)
);

-- Branch Data
INSERT INTO branch (branch_name, branch_city, assets) VALUES 
('Downtown', 'Brooklyn', 9000000),
('Uptown', 'Brooklyn', 5000000),
('Central', 'Harrison', 3000000);

-- Customer Data
INSERT INTO customer (ID, customer_name, customer_street, customer_city) VALUES 
(12345, 'Alice Smith', 'Oak St', 'Harrison'),
(67890, 'Bob Jones', 'Oak St', 'Harrison'),
(11111, 'Charlie Brown', 'Pine St', 'Brooklyn');

-- Account Data
INSERT INTO account (account_number, branch_name, balance) VALUES 
(101, 'Downtown', 500),
(102, 'Uptown', 1200),
(103, 'Central', 850);

-- Depositor Data
INSERT INTO depositor (ID, account_number) VALUES 
(12345, 103), 
(11111, 101), 
(11111, 102); 

-- Loan Data
INSERT INTO loan (loan_number, branch_name, amount) VALUES 
(11, 'Downtown', 10000),
(12, 'Central', 5000);

-- Borrower Data
INSERT INTO borrower (ID, loan_number) VALUES 
(67890, 12),
(11111, 11);


