
-- CSE3153 Final Project
-- Student Course Registration System
-- This will create the database and add sample information.

USE master;
GO

-- #1 This will remove the project database if it already exists.
IF DB_ID('CampusRegistrationDB') IS NOT NULL
BEGIN
    ALTER DATABASE CampusRegistrationDB
    SET SINGLE_USER WITH ROLLBACK IMMEDIATE;

    DROP DATABASE CampusRegistrationDB;
END;
GO

-- #2 This will create the database for the final project.
CREATE DATABASE CampusRegistrationDB;
GO

-- #3 This will switch to the new database.
USE CampusRegistrationDB;
GO

-- #4 This will create the Kennesaw schema.
CREATE SCHEMA Kennesaw;
GO

-- #5 This will create the academic department table.
CREATE TABLE Kennesaw.AcademicDepartment (
    dept_id INT IDENTITY(1,1) PRIMARY KEY,
    dept_name VARCHAR(100) NOT NULL UNIQUE,
    building VARCHAR(100) NOT NULL
);
GO

-- #6 This will create the student table.
CREATE TABLE Kennesaw.Student (
    student_id INT IDENTITY(1001,1) PRIMARY KEY,
    first_name VARCHAR(60) NOT NULL,
    last_name VARCHAR(60) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    dept_id INT NOT NULL,
    CONSTRAINT FK_Student_Department FOREIGN KEY (dept_id)
        REFERENCES Kennesaw.AcademicDepartment(dept_id)
);
GO

-- #7 This will create the teacher table.
CREATE TABLE Kennesaw.Teacher (
    teacher_id INT IDENTITY(1,1) PRIMARY KEY,
    teacher_name VARCHAR(120) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    dept_id INT NOT NULL,
    CONSTRAINT FK_Teacher_Department FOREIGN KEY (dept_id)
        REFERENCES Kennesaw.AcademicDepartment(dept_id)
);
GO

-- #8 This will create the course table.
CREATE TABLE Kennesaw.Course (
    course_id INT IDENTITY(1,1) PRIMARY KEY,
    course_code VARCHAR(15) NOT NULL UNIQUE,
    course_title VARCHAR(120) NOT NULL,
    credit_hours INT NOT NULL CHECK (credit_hours BETWEEN 1 AND 6),
    dept_id INT NOT NULL,
    teacher_id INT NOT NULL,
    CONSTRAINT FK_Course_Department FOREIGN KEY (dept_id)
        REFERENCES Kennesaw.AcademicDepartment(dept_id),
    CONSTRAINT FK_Course_Teacher FOREIGN KEY (teacher_id)
        REFERENCES Kennesaw.Teacher(teacher_id)
);
GO

-- #9 This will create the registration table.
CREATE TABLE Kennesaw.Registration (
    registration_id INT IDENTITY(1,1) PRIMARY KEY,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    registered_on DATE NOT NULL DEFAULT CAST(GETDATE() AS DATE),
    status VARCHAR(15) NOT NULL DEFAULT 'Registered',
    CONSTRAINT CK_Registration_Status
        CHECK (status IN ('Registered', 'Completed', 'Dropped')),
    CONSTRAINT UQ_Registration_Student_Course
        UNIQUE (student_id, course_id),
    CONSTRAINT FK_Registration_Student FOREIGN KEY (student_id)
        REFERENCES Kennesaw.Student(student_id),
    CONSTRAINT FK_Registration_Course FOREIGN KEY (course_id)
        REFERENCES Kennesaw.Course(course_id)
);
GO

-- #10 This will add three academic departments.
INSERT INTO Kennesaw.AcademicDepartment (dept_name, building)
VALUES
    ('Computer Science', 'Technology Hall'),
    ('Business Administration', 'Commerce Hall'),
    ('Mathematics', 'Science Center');
GO

-- #11 This will add four students.
INSERT INTO Kennesaw.Student (first_name, last_name, email, dept_id)
VALUES
    ('Maya', 'Brooks', 'maya.brooks@campus.example', 1),
    ('Ethan', 'Reed', 'ethan.reed@campus.example', 1),
    ('Sofia', 'Turner', 'sofia.turner@campus.example', 2),
    ('Leo', 'Morgan', 'leo.morgan@campus.example', 3);
GO

-- #12 This will add three teachers.
INSERT INTO Kennesaw.Teacher (teacher_name, email, dept_id)
VALUES
    ('Nina Carter', 'nina.carter@campus.example', 1),
    ('Daniel Ortiz', 'daniel.ortiz@campus.example', 2),
    ('Priya Shah', 'priya.shah@campus.example', 3);
GO

-- #13 This will add four courses.
INSERT INTO Kennesaw.Course
(course_code, course_title, credit_hours, dept_id, teacher_id)
VALUES
    ('CSC101', 'Programming Basics', 3, 1, 1),
    ('CSC205', 'Database Fundamentals', 3, 1, 1),
    ('BUS110', 'Introduction to Business', 3, 2, 2),
    ('MAT150', 'Applied Statistics', 3, 3, 3);
GO

-- #14 This will add five course registrations.
INSERT INTO Kennesaw.Registration
(student_id, course_id, registered_on, status)
VALUES
    (1001, 1, '2026-08-24', 'Registered'),
    (1001, 2, '2026-08-24', 'Registered'),
    (1002, 1, '2026-08-25', 'Registered'),
    (1003, 3, '2026-08-25', 'Completed'),
    (1004, 4, '2026-08-26', 'Registered');
GO

-- #15 This will show the information from all five tables.
SELECT * FROM Kennesaw.AcademicDepartment;
SELECT * FROM Kennesaw.Student;
SELECT * FROM Kennesaw.Teacher;
SELECT * FROM Kennesaw.Course;
SELECT * FROM Kennesaw.Registration;
GO

-- #16 This will show students and the courses they registered for.
SELECT
    s.student_id,
    s.first_name,
    s.last_name,
    c.course_code,
    c.course_title,
    r.status
FROM Kennesaw.Registration AS r
INNER JOIN Kennesaw.Student AS s
    ON r.student_id = s.student_id
INNER JOIN Kennesaw.Course AS c
    ON r.course_id = c.course_id
ORDER BY s.student_id, c.course_code;
GO
