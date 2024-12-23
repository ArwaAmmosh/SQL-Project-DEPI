--retrieve exam questions
CREATE PROCEDURE SP_GetExamQuestions
    @ExamID INT
AS
BEGIN
    BEGIN TRY
        SELECT 
            Q.ID AS QuestionID,
            Q.text AS QuestionText,
            Q.type AS QuestionType,
            QO.option1 AS A,   QO.option2 AS B,
            ISNULL(QO.option3, '-') AS C, ISNULL(QO.option4, '-') AS D
        FROM Exam_Question EQ
        INNER JOIN Question Q ON EQ.questionID = Q.ID
        INNER JOIN Quest_Options QO ON Q.ID = QO.questionID
        WHERE EQ.examID = @ExamID;

        PRINT 'Questions for Exam ID: ' + CAST(@ExamID AS VARCHAR);
    END TRY
    BEGIN CATCH
        PRINT 'Error Message: ' + ERROR_MESSAGE();
    END CATCH
END;

---------------------------------
--Procedure: Submit Student Answers
CREATE PROCEDURE SubmitStudentAnswer
    @ExamID INT,
    @QuestionID INT,
    @StudentAnswer NVARCHAR(255)
AS
BEGIN
   
    -- Update the student's answer in the Exam_Question table
    UPDATE Exam_Question
    SET studentAnswer = @StudentAnswer
    WHERE examID = @ExamID AND questionID = @QuestionID;

    PRINT 'Answer submitted for Exam ID: ' + CAST(@ExamID AS VARCHAR) + 
          ', Question ID: ' + CAST(@QuestionID AS VARCHAR);
END;
