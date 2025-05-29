IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GET_SUBJECTBYEMPLOYEE_ByBatchId]')
    AND type = N'P'
)
BEGIN
    EXEC('
   CREATE procedure [dbo].[SP_GET_SUBJECTBYEMPLOYEE_ByBatchId]     
(@Duration_Mapping_Id bigint,@Employee_Id bigint)        
        
AS BEGIN        
        
SELECT distinct  S.Subject_Name+'' - ''+ S.Subject_Code as Subject_Name,S.Subject_Id,CT.Semster_Subject_Id,SS.Duration_Mapping_Id,    
 S.Subject_Code    
 FROM dbo.Tbl_Class_TimeTable CT        
INNER JOIN dbo.Tbl_Semester_Subjects SS ON CT.Semster_Subject_Id=SS.Semester_Subject_Id        
INNER JOIN dbo.Tbl_Department_Subjects DS ON DS.Department_Subject_Id=SS.Department_Subjects_Id        
INNER JOIN dbo.Tbl_Subject S ON S.Subject_Id=DS.Subject_Id    
  
          
Inner Join Tbl_Course_Duration_Mapping DM On SS.Duration_Mapping_Id=DM.Duration_Mapping_Id                
Inner Join Tbl_Course_Duration_PeriodDetails CP On DM.Duration_Period_Id=CP.Duration_Period_Id                
Inner Join Tbl_Course_Batch_Duration B On Cp.Batch_Id=B.Batch_Id                
Inner Join Tbl_Course_Semester SE On CP.Semester_Id=SE.Semester_Id                
Inner Join Tbl_Course_Department CD On CD.Department_Id=DM.Course_Department_Id               
Inner Join Tbl_Course_Category CC On CC.Course_Category_Id=CD.Course_Category_Id              
Inner Join Tbl_Department D on CD.Department_Id=D.Department_Id          
        
WHERE SS.Duration_Mapping_Id=@Duration_Mapping_Id   and CT.Employee_Id=@Employee_Id     
        
END 
    ')
END;
