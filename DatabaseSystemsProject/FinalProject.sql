
-- CSE3153 Final Project
-- Phone Book / Address Book System
-- This script creates the database and adds sample information.

USE master;
GO

-- #1 This will remove the project database if it already exists.
IF DB_ID('PhoneBookDB') IS NOT NULL
BEGIN
    ALTER DATABASE PhoneBookDB
    SET SINGLE_USER WITH ROLLBACK IMMEDIATE;

    DROP DATABASE PhoneBookDB;
END;
GO

-- #2 This will create the phone book database.
CREATE DATABASE PhoneBookDB;
GO

-- #3 This will switch to the new database.
USE PhoneBookDB;
GO

-- #4 This will create the Kennesaw schema.
CREATE SCHEMA Kennesaw;
GO

-- #5 This will create the individual table.
CREATE TABLE Kennesaw.Individual (
    individual_id INT IDENTITY(1001,1) PRIMARY KEY,
    first_name VARCHAR(60) NOT NULL,
    last_name VARCHAR(60) NOT NULL
);
GO

-- #6 This will create the phone number table.
CREATE TABLE Kennesaw.PhoneNumber (
    phone_id INT IDENTITY(1,1) PRIMARY KEY,
    individual_id INT NOT NULL,
    phone_number VARCHAR(20) NOT NULL,
    phone_type VARCHAR(20) NOT NULL,
    CONSTRAINT FK_PhoneNumber_Individual
        FOREIGN KEY (individual_id)
        REFERENCES Kennesaw.Individual(individual_id)
);
GO

-- #7 This will create the address table.
CREATE TABLE Kennesaw.Address (
    address_id INT IDENTITY(1,1) PRIMARY KEY,
    street_address VARCHAR(150) NOT NULL,
    city VARCHAR(80) NOT NULL,
    state_code CHAR(2) NOT NULL,
    zip_code VARCHAR(10) NOT NULL
);
GO

-- #8 This will create the individual address table.
CREATE TABLE Kennesaw.IndividualAddress (
    individual_address_id INT IDENTITY(1,1) PRIMARY KEY,
    individual_id INT NOT NULL,
    address_id INT NOT NULL,
    CONSTRAINT FK_IndividualAddress_Individual
        FOREIGN KEY (individual_id)
        REFERENCES Kennesaw.Individual(individual_id),
    CONSTRAINT FK_IndividualAddress_Address
        FOREIGN KEY (address_id)
        REFERENCES Kennesaw.Address(address_id),
    CONSTRAINT UQ_IndividualAddress
        UNIQUE (individual_id, address_id)
);
GO

-- #9 This will create the email address table.
CREATE TABLE Kennesaw.EmailAddress (
    email_id INT IDENTITY(1,1) PRIMARY KEY,
    individual_id INT NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    CONSTRAINT FK_EmailAddress_Individual
        FOREIGN KEY (individual_id)
        REFERENCES Kennesaw.Individual(individual_id)
);
GO

-- #10 This will add four individuals.
INSERT INTO Kennesaw.Individual (first_name, last_name)
VALUES
    ('Maya', 'Brooks'),
    ('Ethan', 'Reed'),
    ('Sofia', 'Turner'),
    ('Leo', 'Morgan');
GO

-- #11 This will add five phone numbers.
INSERT INTO Kennesaw.PhoneNumber
(individual_id, phone_number, phone_type)
VALUES
    (1001, '470-555-0101', 'Mobile'),
    (1001, '678-555-0102', 'Home'),
    (1002, '404-555-0103', 'Mobile'),
    (1003, '770-555-0104', 'Mobile'),
    (1004, '678-555-0105', 'Work');
GO

-- #12 This will add four addresses.
INSERT INTO Kennesaw.Address
(street_address, city, state_code, zip_code)
VALUES
    ('101 Oak Street', 'Kennesaw', 'GA', '30144'),
    ('202 Pine Avenue', 'Marietta', 'GA', '30060'),
    ('303 Maple Drive', 'Atlanta', 'GA', '30303'),
    ('404 Cedar Lane', 'Smyrna', 'GA', '30080');
GO

-- #13 This will connect individuals to addresses.
INSERT INTO Kennesaw.IndividualAddress
(individual_id, address_id)
VALUES
    (1001, 1),
    (1002, 2),
    (1003, 3),
    (1004, 4);
GO

-- #14 This will add four email addresses.
INSERT INTO Kennesaw.EmailAddress (individual_id, email)
VALUES
    (1001, 'maya.brooks@example.com'),
    (1002, 'ethan.reed@example.com'),
    (1003, 'sofia.turner@example.com'),
    (1004, 'leo.morgan@example.com');
GO

-- #15 This will show the information from all five tables.
SELECT * FROM Kennesaw.Individual;
SELECT * FROM Kennesaw.PhoneNumber;
SELECT * FROM Kennesaw.Address;
SELECT * FROM Kennesaw.IndividualAddress;
SELECT * FROM Kennesaw.EmailAddress;
GO

-- #16 This will show names, phone numbers, addresses, and emails.
SELECT
    i.individual_id,
    i.first_name,
    i.last_name,
    p.phone_number,
    p.phone_type,
    a.street_address,
    a.city,
    a.state_code,
    a.zip_code,
    e.email
FROM Kennesaw.Individual AS i
INNER JOIN Kennesaw.PhoneNumber AS p
    ON i.individual_id = p.individual_id
INNER JOIN Kennesaw.IndividualAddress AS ia
    ON i.individual_id = ia.individual_id
INNER JOIN Kennesaw.Address AS a
    ON ia.address_id = a.address_id
INNER JOIN Kennesaw.EmailAddress AS e
    ON i.individual_id = e.individual_id
ORDER BY i.last_name, i.first_name;
GO
