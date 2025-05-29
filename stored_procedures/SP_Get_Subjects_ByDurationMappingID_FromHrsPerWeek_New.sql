IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_Subjects_ByDurationMappingID_FromHrsPerWeek_New]')
    AND type = N'P'
)
BEGIN
    EXEC(N'
    create procedure [dbo].[SP_Get_Subjects_ByDurationMappingID_FromHrsPerWeek_New]    
(@Duration_Mapping_Id bigint)      
AS        
BEGIN        
Select         
 SS.Semester_Subject_Id,        
 SS.Duration_Mapping_Id,        
 SS.Department_Subjects_Id,        
 CDP.Batch_Id,        
 CDP.Semester_Id,        
 CDM.Course_Department_Id ,      
 S.Subject_Name as SubjectName,      
 ISNULL(Employee_Id ,0) As Employee_Id,  
 ISNULL(Is_Continuous,0) As Is_Continuous,  
 ISNULL(Allowed_ContinuousHours,0) As Allowed_ContinuousHours  
 FROM Tbl_Semester_Subjects SS        
 INNER JOIN Tbl_Course_Duration_Mapping CDM On SS.Duration_Mapping_Id=CDM.Duration_Mapping_Id        
 INNER JOIN Tbl_Course_Duration_PeriodDetails CDP On CDM.Duration_Period_Id=CDP.Duration_Period_Id        
 INNER JOIN Tbl_Department_Subjects DS On SS.Department_Subjects_Id=DS.Department_Subject_Id      
 INNER JOIN Tbl_Subject S on DS.Subject_Id=S.Subject_Id      
 LEFT JOIN Tbl_Subject_Hours_PerWeek SP On SS.Semester_Subject_Id=SP.Semester_Subject_Id     
 Where SS.Semester_Subjects_Status=0 and SS.Duration_Mapping_Id=@Duration_Mapping_Id    
 and S.Parent_Subject_Id=0  
order by SubjectName 
END
    ');
END;
