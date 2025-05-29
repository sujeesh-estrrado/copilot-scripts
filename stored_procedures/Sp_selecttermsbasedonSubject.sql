IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_selecttermsbasedonSubject]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Sp_selecttermsbasedonSubject] --2305 
(@SubjectID bigint)   
as    
begin    
Select distinct  Exam_Term,Assessment_Code from dbo.Tbl_Exam_Code_Master where (Subject_Id=@SubjectID or @SubjectID=0)   
    
end

    ')
END;
