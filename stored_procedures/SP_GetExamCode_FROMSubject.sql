IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetExamCode_FROMSubject]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_GetExamCode_FROMSubject]  --17
      
(@SubjectId bigint)      
      
AS BEGIN      
      
select distinct (ExamCode) as ExamCode from Tbl_StudentExamSubjectsChild where SubjectId=@SubjectId    
--select distinct(A.Exam_Code_final) as ExamCode from Tbl_Exam_Code_Child A  
--inner join Tbl_Exam_Code_Master B on B.Exam_Code_Master_Id=B.Exam_Code_Master_Id  
--WHERe B.Subject_Id=@SubjectId
END  
    
    ')
END;
