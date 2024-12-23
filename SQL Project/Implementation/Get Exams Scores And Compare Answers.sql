--Get Student Score 
CREATE FUNCTION f_ShowStudentScore (@StudentId INT)
RETURNS TABLE
AS
RETURN
(
    SELECT Title, Score, Status
    FROM Exam
    WHERE studentID = @StudentId
);
--compare Student Answer
CREATE FUNCTION f_ShowExamCorrection (@ExamId INT)
RETURNS TABLE
AS
RETURN
(
    SELECT text, correctAnswer,eque.studentAnswer
    FROM Question que
 inner join 
 Exam_Question eque on eque.questionID=Que.ID 
 where eque.examID=@ExamId

);
