IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_Schedule_Details]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Get_Schedule_Details] --1,1    
(    
@flag bigint=0,    
@Schedule_Id bigint    
 )     
AS      
BEGIN      
if(@flag=0)    
begin    
 SELECT distinct S.[ID] as Schedule_Id,S.[Schedule_Number] as Schedule_No,convert(varchar(50),S.[Schedule_Creation_Date],103 ) as [Schedule_Creation_Date]      
 ,S.[Department_Id],S.[Job_Position],D.[Department_Name],r.Dept_Designation_Name,R.Dept_Designation_Id        
 ,SP.[Start_Time] as [Start_Date],SP.[End_Time] as [End_Date],SP.[Interview_Type],SP.[Interview_Status]      
 FROM [dbo].[Tbl_HRMS_Interview_Schedule] S      
  LEFT JOIN [dbo].[Tbl_Department] D ON D.Department_Id=S.Department_Id      
  LEFT JOIN [dbo].[Tbl_Emp_DeptDesignation] R ON R.Dept_Designation_Id=S.[Job_Position]      
  LEFT JOIN [dbo].[Tbl_HRMS_Primary_Interview_Details] SP ON SP.[Schedule_Id]=S.[ID]      
 WHERE S.[Del_Status]=0 and S.[ID]=@Schedule_Id    
 end    
 if(@flag=1)    
begin    
 SELECT J.Job_Id,J.Applicant_Name,J.Application_No, (CASE WHEN T.[Availability_Status_Interviewer]=0 THEN ''Waiting For Approval'' WHEN T.[Availability_Status_Interviewer]=1 THEN ''Approved'' END) AS Approval_Status    
         FROM Tbl_HRMS_Primary_Interview_Details S     
         LEFT JOIN [dbo].[Tbl_Emp_DeptDesignation] R ON R.Dept_Designation_Id=S.Designation    
   LEFT JOIN Tbl_JobApplication_Deatils J ON J.Job_Id=S.Application_No    
   LEFT JOIN [dbo].[Tbl_HRMS_Third_Interview_Details] T ON T.Schedule_Id=S.Schedule_Id    
         WHERE [Interview_Type]=''Second Interview'' AND S.Schedule_Id=@Schedule_Id    
     
 end   
 if(@flag=2)  
 begin  
  
 select ID,Schedule_Number from Tbl_HRMS_Interview_Schedule   
 end  
  
        
END 

						 ');
END;
