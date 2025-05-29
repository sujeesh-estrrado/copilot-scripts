IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_InterviewDetailsByDept_JobPosition]')
    AND type = N'P'
)
BEGIN
    EXEC('
   CREATE procedure [dbo].[SP_Get_InterviewDetailsByDept_JobPosition]  --18,0,2  
@Department_Id bigint,  
@Position_id bigint,  
@Flag varchar(100)  
AS  
BEGIN  
 IF(@Flag=1)  
 BEGIN  
  SELECT [Job_Id],[Application_No],[Applicant_Name] FROM [dbo].[Tbl_JobApplication_Deatils] WHERE [Department_Id]=@Department_Id AND  [Position_Applied]=@Position_id  
  AND [Status_Of_Application]=''Shortlisted'' AND [Del_status]=0  
 END  
 IF(@Flag=2)  
 BEGIN  
  SELECT E.[Employee_Id],E.[Employee_FName] FROM [dbo].[Tbl_Employee] E  
  LEFT JOIN [dbo].[Tbl_Faculty_Department_Mapping] F ON F.[employeeid]=E.[Employee_Id]  
  WHERE F.facultyid=@Department_Id AND E.Employee_Status=0  
 END  
END
    ')
END
