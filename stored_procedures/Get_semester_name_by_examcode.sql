-- Create Get_semester_name_by_examcode procedure if it does not exist
IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Get_semester_name_by_examcode]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       
 CREATE procedure [dbo].[Get_semester_name_by_examcode] 
@CANDIDATE_ID bigint


as
begin

SELECT Semester_Code as Sem_Number FROM [dbo].[Tbl_Student_Semester] ss
INNER JOIN dbo.Tbl_Course_Duration_Mapping CDM ON CDM.Duration_Mapping_Id=ss.Duration_Mapping_Id                    
INNER JOIN dbo.Tbl_Course_Duration_PeriodDetails CDP ON CDP.Duration_Period_Id=CDM.Duration_Period_Id                    
INNER JOIN dbo.Tbl_Course_Batch_Duration CBD ON CBD.Batch_Id=CDP.Batch_Id  
INNER JOIN dbo.Tbl_Course_Semester CS ON CS.Semester_Id=CDP.Semester_Id   

 WHERE ss.CANDIDATE_ID=@CANDIDATE_ID and  ss.[Student_Semester_Current_Status]=1
--AND ExamCode=@ExamCode
end 

--======================================
    ')
END;
