IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_Teachers_By_SubjectId]')
    AND type = N'P'
)
BEGIN
    EXEC(N'
    
          
 CREATE procedure [dbo].[SP_Get_Teachers_By_SubjectId] --64     
@Subject_Id bigint      
AS      
BEGIN      
 Select       
 Distinct SH.Employee_Id,      
 Employee_FName+'' ''+Employee_LName As EmployeeName ,    
D.Department_name     
 From Tbl_Subject_Hours_PerWeek SH      
 Inner Join Tbl_Semester_Subjects SS On SH.Semester_Subject_Id=SS.Semester_Subject_Id      
 Inner Join Tbl_Department_Subjects DS On DS.Department_Subject_Id=SS.Department_Subjects_Id      
 Inner Join Tbl_Subject S On S.Subject_Id=DS.Subject_Id      
 Inner Join Tbl_Employee E on E.Employee_Id=SH.Employee_Id    
 INNER JOIN dbo.Tbl_Emp_CourseDepartment_Allocation ECA ON ECA.Employee_Id=E.Employee_Id  
INNER JOIN dbo.Tbl_Employee_Official EO on EO.Employee_Id=E.Employee_Id    
INNER JOIN dbo.Tbl_Course_Department CD ON CD.Course_Department_Id=ECA.Allocated_CourseDepartment_Id  
INNER JOIN Tbl_Department D on D.Department_Id=CD.Department_Id    
 Where S.Subject_Id=@Subject_Id      
END
    ');
END;
