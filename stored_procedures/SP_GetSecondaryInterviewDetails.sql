IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetSecondaryInterviewDetails]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_GetSecondaryInterviewDetails] --1,1  
 @ScheduleID bigint,  
 @Job_Id bigint  
AS  
BEGIN  
 SELECT  
  S.Schedule_Id,I.Department_Id,I.Job_Position,J.Applicant_Name,E.Dept_Designation_Name,  
  CONCAT(E1.[Employee_FName],E1.[Employee_LName]) AS SecondaryInterviewer1,    
  CONCAT(E2.[Employee_FName],E2.[Employee_LName]) AS SecondaryInterviewer2,D.[Department_Name],  
  S.Interview_Date,S.Start_Time,S.Venue_Id,R.Room_Name  
 FROM  
  [dbo].[Tbl_HRMS_Second_Interview_Details] S  
  INNER JOIN Tbl_JobApplication_Deatils J on J.Job_Id=S.Application_No  
  INNER JOIN [dbo].[Tbl_Emp_DeptDesignation] E ON E.[Dept_Designation_Id]=S.[Designation]  
  INNER JOIN [dbo].[Tbl_HRMS_Interview_Schedule] I ON S.Schedule_Id=I.ID  
  INNER JOIN [dbo].[Tbl_Department] D ON D.[Department_Id]=I.Department_Id  
  INNER JOIN [dbo].[Tbl_Employee] E1 ON E1.[Employee_Id]=S.[Interviewer1]    
  INNER JOIN [dbo].[Tbl_Employee] E2 ON E2.[Employee_Id]=S.[Interviewer2]  
  INNER JOIN Tbl_Room    R  ON R.Room_Id = S.[Venue_Id]    
 WHERE  
  S.Schedule_Id=@ScheduleID AND S.[Application_No]=@Job_Id  
    
  
  
END
');
END;