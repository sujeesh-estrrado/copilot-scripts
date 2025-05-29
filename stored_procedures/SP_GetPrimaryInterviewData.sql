IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetPrimaryInterviewData]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_GetPrimaryInterviewData] --1    
 @Schedule_Id bigint    
AS    
BEGIN    
 SELECT    
  I.Job_Position,I.Department_Id,E.Dept_Designation_Name as Designation,  
  I.Schedule_Creation_Date,D.[Department_Name]    
  FROM    
   [dbo].[Tbl_HRMS_Primary_Interview_Details] P     
   INNER JOIN [dbo].[Tbl_HRMS_Interview_Schedule] I ON I.ID=P.Schedule_Id    
   INNER JOIN [dbo].[Tbl_Emp_DeptDesignation] E ON E.[Dept_Designation_Id]=I.Job_Position    
   INNER JOIN [dbo].[Tbl_Department] D ON D.[Department_Id]=I.Department_Id    
 WHERE    
  P.Schedule_Id=@Schedule_Id AND P.Del_Status=0 AND P.Interview_Type=''FIRST INTERVIEW''   
END
');
END;