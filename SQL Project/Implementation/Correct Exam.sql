CREATE PROCEDURE CorrectStudentExam
    @ExamID INT,
    @CalculatedScore FLOAT OUTPUT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        --  Validate ExamID exists using COUNT
        DECLARE @ExamCount INT;
        SELECT @ExamCount = COUNT(1)
        FROM Exam
        WHERE ID = @ExamID;

        IF @ExamCount = 0
        BEGIN
            RAISERROR ('Invalid Exam ID. Please provide a valid Exam ID.', 16, 1);
            RETURN;
        END


        --  Get Totalmark for the exam
        DECLARE @TotalMark FLOAT;
        --  Calculate the score based on student answers
        SELECT @CalculatedScore = 
            ISNULL(SUM(
                CASE 
                    WHEN EQ.studentAnswer = Q.correctAnswer THEN Q.qdegree -- Correct Answer: Add the question degree
                    ELSE 0 -- Incorrect Answer: Add 0
                END
            ), 0)
        FROM Exam_Question EQ
        INNER JOIN Question Q ON EQ.questionID = Q.ID
        WHERE EQ.examID = @ExamID;

     

        --  Update the Exam table with the calculated score
        UPDATE Exam
        SET score = @CalculatedScore, 
            Status = 'Completed',
            date = GETDATE() -- Adding timestamp for completion time
        WHERE ID = @ExamID;

        COMMIT TRANSACTION;

        PRINT 'Exam corrected successfully.';
        PRINT 'Total Score: ' + CAST(@CalculatedScore AS NVARCHAR(10)) + ' out of ' + CAST(@TotalMark AS NVARCHAR(10));
    END TRY
    BEGIN CATCH
        -- Rollback the transaction on error
        ROLLBACK TRANSACTION;
        PRINT 'Error: ' + ERROR_MESSAGE();
    END CATCH;
END;
