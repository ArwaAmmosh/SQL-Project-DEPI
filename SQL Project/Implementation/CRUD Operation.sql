  --crud operation for student 
  --1-Add
CREATE PROCEDURE sp_AddStudent
    @studentId INT,
    @fName VARCHAR(50),
    @lName VARCHAR(50),
    @email VARCHAR(100),
    @password VARCHAR(100),
    @phone VARCHAR(15)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        IF EXISTS (SELECT 1 FROM Student WHERE studentID = @studentId)
        BEGIN
            SELECT 'Error: Student already exists' AS Message;
            ROLLBACK TRANSACTION; 
            RETURN;
        END

        INSERT INTO Student (studentID, Fname, Lname, email, password, phone_number)
        VALUES (@studentId, @fName, @lName, @email, @password, @phone);

        SELECT 'Done! Student added successfully' AS Message;

        COMMIT TRANSACTION; 
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;

        DECLARE @ErrorMessage NVARCHAR(4000);
        SET @ErrorMessage = ERROR_MESSAGE();
        SELECT 'Error: ' + @ErrorMessage AS ErrorMessage;
    END CATCH
END;

  --2-Delete
CREATE PROCEDURE sp_DeleteStudent
    @studentId INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        IF NOT EXISTS (SELECT 1 FROM Student WHERE studentID = @studentId)
        BEGIN
            SELECT 'Error: Student not found' AS Message;
            ROLLBACK TRANSACTION;
            RETURN;
        END

        DELETE FROM Student WHERE studentID = @studentId;
        SELECT 'Deleted! Student removed successfully' AS Message;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;

        SELECT 'Error: ' + ERROR_MESSAGE() AS ErrorMessage;
    END CATCH
END;

  --3-Read
CREATE PROCEDURE sp_ReadStudent
    @studentId INT
AS
BEGIN
    SELECT Fname, Lname, email, phone_number
    FROM Student
    WHERE studentID = @studentId;
END;

  --crud operation for instructor
   --1-Add
CREATE PROCEDURE sp_AddInsturctor
    @instructorId INT,
    @fName VARCHAR(50),
    @lName VARCHAR(50),
    @email VARCHAR(100),
    @password VARCHAR(100),
    @phone VARCHAR(15)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        IF EXISTS (SELECT 1 FROM Instructor WHERE instructorID = @instructorId)
        BEGIN
            SELECT 'Error: Instructor already exists' AS Message;
            ROLLBACK TRANSACTION;
            RETURN;
        END

        INSERT INTO Instructor (instructorID, Fname, Lname, email, password, phone_number)
        VALUES (@instructorId, @fName, @lName, @email, @password, @phone);

        SELECT 'Done! Instructor added successfully' AS Message;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;

        SELECT 'Error: ' + ERROR_MESSAGE() AS ErrorMessage;
    END CATCH
END;

  --2-Delete
CREATE PROCEDURE sp_DeleteInstructor
    @instructorId INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        IF NOT EXISTS (SELECT 1 FROM Instructor WHERE instructorID = @instructorId)
        BEGIN
            SELECT 'Error: Instructor not found' AS Message;
            ROLLBACK TRANSACTION;
            RETURN;
        END

        DELETE FROM Instructor WHERE instructorID = @instructorId;
        SELECT 'Deleted! Instructor removed successfully' AS Message;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;

        SELECT 'Error: ' + ERROR_MESSAGE() AS ErrorMessage;
    END CATCH
END;

  --3-Read
CREATE PROCEDURE sp_ReadInstructor
    @instructorId INT
AS
BEGIN
    SELECT Fname, Lname, email, phone_number
    FROM Instructor
    WHERE instructorID = @instructorId;
END;

--crud operation for Course
   --1-Add
CREATE PROCEDURE sp_AddCourse
    @courseName VARCHAR(100),
    @courseDescription TEXT,
    @courseHours INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        IF EXISTS (SELECT 1 FROM Course WHERE title = @courseName)
        BEGIN
            SELECT 'Error: Course already exists' AS Message;
            ROLLBACK TRANSACTION;
            RETURN;
        END

        INSERT INTO Course (title, description, hours)
        VALUES (@courseName, @courseDescription, @courseHours);

        SELECT 'Done! Course added successfully' AS Message;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;

        SELECT 'Error: ' + ERROR_MESSAGE() AS ErrorMessage;
    END CATCH
END;


  --2-Delete
CREATE PROCEDURE sp_DeleteCourse
    @courseId INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION

        DELETE FROM Course WHERE ID = @courseId;
	    SELECT 'Deleted!' AS Message;
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION
        DECLARE @ErrorMessage NVARCHAR(4000)
        DECLARE @ErrorSeverity INT
        DECLARE @ErrorState INT

        SELECT 
            @ErrorMessage = 'Error : Cannot Be Deleted',
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState = ERROR_STATE()

        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState)
    END CATCH
END;

  --3-Read
CREATE PROCEDURE sp_ReadCourse 
    @coursename NVARCHAR(100)
AS
BEGIN
    BEGIN TRY
        IF EXISTS (SELECT 1 FROM Course WHERE title = @coursename)
        BEGIN
            SELECT title, description, hours
            FROM Course
            WHERE title = @coursename;
        END
        ELSE
        BEGIN
            SELECT 'Course not found' AS Message;
        END
    END TRY
    BEGIN CATCH
        SELECT 'An error occurred: ' + ERROR_MESSAGE() AS Message;
    END CATCH
END;


--enrollment
--1-enroll
CREATE PROCEDURE sp_EnrollCourse 
    @studentId INT,
    @coursename NVARCHAR(100)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        IF NOT EXISTS (SELECT 1 FROM Course WHERE title = @coursename)
        BEGIN
            SELECT 'Error: Course not found' AS Message;
            ROLLBACK TRANSACTION;
            RETURN;
        END

        DECLARE @courseId INT;
        SELECT @courseId = ID FROM Course WHERE title = @coursename;

        IF EXISTS (SELECT 1 FROM Enrollment WHERE studentID = @studentId AND courseID = @courseId)
        BEGIN
            SELECT 'Error: Student already enrolled in this course' AS Message;
            ROLLBACK TRANSACTION;
            RETURN;
        END

        INSERT INTO Enrollment (studentID, courseID)
        VALUES (@studentId, @courseId);

        SELECT 'Done! Student enrolled successfully' AS Message;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;

        SELECT 'Error: ' + ERROR_MESSAGE() AS ErrorMessage;
    END CATCH
END;

--2-discharge student from course
CREATE PROCEDURE sp_Dicharge 
    @studentId INT,
    @coursename NVARCHAR(100)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        IF EXISTS (SELECT 1 FROM Course WHERE title = @coursename)
        BEGIN
            DECLARE @courseId INT;

            SELECT @courseId = ID FROM Course WHERE title = @coursename;

            IF EXISTS (SELECT 1 FROM Enrollment WHERE studentID = @studentId AND courseID = @courseId)
            BEGIN
                DELETE FROM Enrollment WHERE studentID = @studentId AND courseID = @courseId;
                SELECT 'Student successfully discharged from the course' AS Message;
            END
            ELSE
            BEGIN
                SELECT 'Student is not enrolled in this course' AS Message;
            END
        END
        ELSE
        BEGIN
            SELECT 'Course not found' AS Message;
        END

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT 'An error occurred: ' + ERROR_MESSAGE() AS Message;
    END CATCH
END;

--TEACHES
--1-Add teacher
CREATE PROCEDURE sp_Teaches 
    @instructorId INT,
    @coursename NVARCHAR(100)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        IF NOT EXISTS (SELECT 1 FROM Course WHERE title = @coursename)
        BEGIN
            SELECT 'Error: Course not found' AS Message;
            ROLLBACK TRANSACTION;
            RETURN;
        END

        DECLARE @courseId INT;
        SELECT @courseId = ID FROM Course WHERE title = @coursename;

        IF EXISTS (SELECT 1 FROM Teaches WHERE instructorID = @instructorId AND courseID = @courseId)
        BEGIN
            SELECT 'Error: Instructor already assigned to this course' AS Message;
            ROLLBACK TRANSACTION;
            RETURN;
        END

        INSERT INTO Teaches (instructorID, courseID)
        VALUES (@instructorId, @courseId);

        SELECT 'Done! Instructor assigned successfully' AS Message;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;

        SELECT 'Error: ' + ERROR_MESSAGE() AS ErrorMessage;
    END CATCH
END;

--2-discharge teacher for course
CREATE PROCEDURE sp_DischargeTeacher 
    @instructorId INT,
    @coursename NVARCHAR(100)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        IF EXISTS (SELECT 1 FROM Course WHERE title = @coursename)
        BEGIN
            DECLARE @courseId INT;

            SELECT @courseId = ID FROM Course WHERE title = @coursename;

            IF EXISTS (SELECT 1 FROM Teaches WHERE instructorID = @instructorId AND courseID = @courseId)
            BEGIN
                DELETE FROM Teaches 
                WHERE instructorID = @instructorId AND courseID = @courseId;

                SELECT 'Deleted Successfully!' AS Message;
            END
            ELSE
            BEGIN
                SELECT 'Instructor is not assigned to this course' AS Message;
            END
        END
        ELSE
        BEGIN
            SELECT 'Course not found' AS Message;
        END

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT 'An error occurred: ' + ERROR_MESSAGE() AS Message;
    END CATCH
END;
--Question 
--1-Add
CREATE PROCEDURE sp_AddQuestions 
    @CourseName NVARCHAR(50),
    @question NVARCHAR(MAX),
    @type VARCHAR(50),
    @qdegree INT,
    @correctAnswer VARCHAR(100),
    @option1 VARCHAR(100),
    @option2 VARCHAR(100),    
    @option3 VARCHAR(100) = NULL,    
    @option4 VARCHAR(100) = NULL
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        IF NOT EXISTS (SELECT 1 FROM Course WHERE title = @CourseName)
        BEGIN
            SELECT 'Course not found' AS Message;
            ROLLBACK TRANSACTION;
            RETURN;
        END

        DECLARE @courseId INT;
        SELECT @courseId = ID FROM Course WHERE title = @CourseName;

        INSERT INTO Question (text, correctAnswer, type, qdegree, courseID)
        VALUES (@question, @correctAnswer, @type, @qdegree, @courseId);

        DECLARE @questionId INT;
		SELECT @questionId = ID FROM Question WHERE text = @question;

        INSERT INTO Quest_Options (questionID, option1, option2, option3, option4)
        VALUES (@questionId, @option1, @option2, @option3, @option4);

        SELECT 'Added Successfully!' AS Message;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT 'An error occurred: ' + ERROR_MESSAGE() AS Message;
    END CATCH
END;
