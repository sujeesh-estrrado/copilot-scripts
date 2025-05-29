IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Insert_Exam_InternalMarks]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Insert_Exam_InternalMarks] 
(@Semester_Subject_Id bigint,
@Total_Marks float,@Min_Marks float)
    
AS
BEGIN
IF NOT EXISTS(Select * from Tbl_Exam_Internal_Marks Where Semester_Subject_Id=@Semester_Subject_Id)
Begin
INSERT INTO Tbl_Exam_Internal_Marks (Semester_Subject_Id,Total_Marks,Min_Marks) VALUES (@Semester_Subject_Id,@Total_Marks,@Min_Marks)

SELECT @@IDENTITY
End
ELSE
Begin
UPDATE Tbl_Exam_Internal_Marks
SET
Semester_Subject_Id=@Semester_Subject_Id,
Total_Marks=@Total_Marks,
Min_Marks=@Min_Marks
OUTPUT INSERTED.Exam_InternalMarks_Id
Where Semester_Subject_Id=@Semester_Subject_Id
--Select Exam_InternalMarks_Id from Tbl_Exam_Internal_Marks Where Semester_Subject_Id=@Semester_Subject_Id
End
END 
    ')
END;
