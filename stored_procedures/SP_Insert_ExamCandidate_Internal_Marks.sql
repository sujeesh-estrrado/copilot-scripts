IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Insert_ExamCandidate_Internal_Marks]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Insert_ExamCandidate_Internal_Marks]
(@Exam_InternalMarks_Id bigint,
@Candidate_Id bigint,
@Internal_Marks float)
    
AS
BEGIN
IF NOT EXISTS(Select * from Tbl_Exam_Candidate_Internal_Marks Where Exam_InternalMarks_Id=@Exam_InternalMarks_Id and 
Candidate_Id=@Candidate_Id)

INSERT INTO Tbl_Exam_Candidate_Internal_Marks(Exam_InternalMarks_Id,Candidate_Id,Internal_Marks) 
VALUES (@Exam_InternalMarks_Id,@Candidate_Id,@Internal_Marks)
ELSE
UPDATE Tbl_Exam_Candidate_Internal_Marks
SET 
Internal_Marks=@Internal_Marks
WHERE Exam_InternalMarks_Id=@Exam_InternalMarks_Id and 
Candidate_Id=@Candidate_Id
END
    ')
END;
