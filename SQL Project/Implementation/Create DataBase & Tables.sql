--CREATE DATABASE Examination
CREATE DATABASE Examination;
-- Create the Instructor table
CREATE TABLE Instructor (
    instructorID INT PRIMARY KEY,
    Fname VARCHAR(50) not null,
    Lname VARCHAR(50),
    email VARCHAR(100)not null,
    password VARCHAR(100) not null,
    Phone_number VARCHAR(15)
);
-- Create the Student table
CREATE TABLE Student (
    studentID INT PRIMARY KEY ,
    Fname VARCHAR(50) not null,
    Lname VARCHAR(50) ,
    email VARCHAR(100) not null,
    Password VARCHAR(100) not null,
    Phone_number VARCHAR(15)
);


-- Create the Course table
CREATE TABLE Course (
    ID INT PRIMARY KEY identity (1,1),
    title VARCHAR(100) not null,
    description TEXT,
    hours INT not null
);

-- Create the Enrollment table
CREATE TABLE Enrollment (
    studentID INT,
    courseID INT,
    PRIMARY KEY (studentID, courseID),
    FOREIGN KEY (studentID) REFERENCES Student(studentID),
    FOREIGN KEY (courseID) REFERENCES Course(ID)
);

-- Create the Teaches table
CREATE TABLE Teaches (
    instructorID INT,
    courseID INT,
    PRIMARY KEY (instructorID, courseID),
    FOREIGN KEY (instructorID) REFERENCES Instructor(instructorID),
    FOREIGN KEY (courseID) REFERENCES Course(ID)
);

-- Create the Exam table
CREATE TABLE Exam (
    ID INT PRIMARY KEY IDENTITY(1,1),
    Title VARCHAR(100),
    date DATE,
    duration TIME,
    score int,
    Totalmark INT not null,
    Status VARCHAR(20)  CHECK ( Status IN ('Pass', 'Fail')),
    studentID INT,
    FOREIGN KEY (studentID) REFERENCES Student(studentID)
);

-- Create the Question table
CREATE TABLE Question (
    ID INT PRIMARY KEY IDENTITY(1,1),
    text nvarchar(max),
    correctAnswer nVARCHAR(255),
    type VARCHAR(50) CHECK ( type IN ('MCQ', 'T&F')),
    qdegree INT not null,
    courseID INT,
    FOREIGN KEY (courseID) REFERENCES Course(ID)
);

-- Create the Exam_Question table
CREATE TABLE Exam_Question (
    questionID INT,
    examID INT,
    studentAnswer nVARCHAR(255),
    PRIMARY KEY (questionID, examID),
    FOREIGN KEY (questionID) REFERENCES Question(ID),
    FOREIGN KEY (examID) REFERENCES Exam(ID)
);

-- Create the Quest_Options table
CREATE TABLE Quest_Options (
    questionID INT,
    option1 VARCHAR(255),
    option2 VARCHAR(255),
    option3 VARCHAR(255),
    option4 VARCHAR(255),
    PRIMARY KEY (questionID),
    FOREIGN KEY (questionID) REFERENCES Question(ID)
);



