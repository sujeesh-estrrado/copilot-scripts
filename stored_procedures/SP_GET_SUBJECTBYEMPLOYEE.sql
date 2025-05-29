IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GET_SUBJECTBYEMPLOYEE]')
    AND type = N'P'
)
BEGIN
    EXEC('
   create procedure [dbo].[SP_GET_SUBJECTBYEMPLOYEE] --39    
(@Duration_Mapping_Id bigint)    
    
AS BEGIN    
    
SELECT distinct  S.Subject_Name+''-''+ S.Subject_Code as Subject_Name,S.Subject_Id,CT.Semster_Subject_Id,SS.Duration_Mapping_Id,
 S.Subject_Code
 FROM dbo.Tbl_Class_TimeTable CT    
INNER JOIN dbo.Tbl_Semester_Subjects SS ON CT.Semster_Subject_Id=SS.Semester_Subject_Id    
INNER JOIN dbo.Tbl_Department_Subjects DS ON DS.Department_Subject_Id=SS.Department_Subjects_Id    
INNER JOIN dbo.Tbl_Subject S ON S.Subject_Id=DS.Subject_Id    
    
WHERE SS.Duration_Mapping_Id=@Duration_Mapping_Id    
    
END    
    
--SELECT  * FROM dbo.Tbl_Class_TimeTable WHERE Employee_Id=39    
--SELECT * FROM dbo.Tbl_Semester_Subjects WHERE Semester_Subject_Id=28    
--SELECT * FROM dbo.Tbl_Department_Subjects WHERE Department_Subject_Id=18    
--SELECT * FROM dbo.Tbl_Subject WHERE Subject_Id=10 


    ')
END;
