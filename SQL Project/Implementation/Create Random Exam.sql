-- CreateRandomExam PROCDURE

CREATE PROCEDURE sp_CreateRandomExam 
    @studentid INT,
    @couresid INT,
	@titleExam  varchar(100),
	@msqQuestions INT,
	@TFQuestions INT
WITH ENCRYPTION
AS
BEGIN
	
    DECLARE @examID INT;

    BEGIN TRANSACTION;
    BEGIN TRY
        -- Check if student is enrolled in the course
        IF NOT EXISTS (
            SELECT 1 
            FROM Enrollment 
            WHERE studentid = @studentid AND courseID = @couresid
        )
        BEGIN
            PRINT 'Error: Student is not enrolled in the Course';
            ROLLBACK TRANSACTION;
            RETURN;
        END;

        -- Create a new exam and retrieve the generated ID
        INSERT INTO Exam (Title, date, duration,Totalmark,   Status, studentID)
        VALUES (@titleExam, GETDATE(), '00:45:00',0,   Null, @studentid);
		-- retrieve last inserted examid
        SET @examID = SCOPE_IDENTITY();
		
		
		 
        --Insert random MCQ questions
        INSERT INTO Exam_Question (examID, questionID, studentAnswer)
        SELECT TOP(@msqQuestions) @examID, ID, NULL
        FROM Question
        WHERE type = 'MCQ'
        ORDER BY NEWID();

        --Insert random T&F questions
        INSERT INTO Exam_Question (examID, questionID, studentAnswer)
        SELECT TOP (@TFQuestions) @examID, ID, NULL
        FROM Question
        WHERE type = 'T&F'
        ORDER BY NEWID();

        --Update TotalMark 
        UPDATE Exam
        SET Totalmark = (SELECT SUM(qdegree) 
                         FROM Question Q
                         JOIN Exam_Question EQ
						 ON Q.ID=EQ.questionID
						 WHERE EQ.examID = @examID
						 )
        WHERE ID = @examID;

        -- Commit the transaction
        COMMIT TRANSACTION;

        -- Return the Exam ID
        SELECT @examID AS ExamID;

    END TRY
    BEGIN CATCH
        -- Rollback on error
        ROLLBACK TRANSACTION;
        PRINT 'Error: ' + ERROR_MESSAGE();
        THROW;  -- throws the error 
    END CATCH
END;
