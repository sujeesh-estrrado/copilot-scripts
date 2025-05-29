IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_InterviewSchedule_Details]')
    AND type = N'P'
)
BEGIN
    EXEC('
   CREATE procedure [dbo].[SP_Get_InterviewSchedule_Details] --10,2  
@Schedule_Id BIGINT,@Flag BIGINT  
AS  
BEGIN  
IF(@Flag=1)  
 BEGIN  
 SELECT   
 [ID] AS Schedule_Id,[Schedule_Number],[Schedule_Creation_Date],[Department_Id],[Job_Position]   
 FROM [dbo].[Tbl_HRMS_Interview_Schedule]   
 WHERE [ID]=@Schedule_Id  
 END  
IF(@Flag=2)  
 BEGIN  
 SELECT   
 P.[Schedule_Id],P.[Requested_By],P.[Designation],P.[Application_No] AS Job_Id,CONVERT(VARCHAR(100),P.[Interview_Date],103) AS [Interview_Date],P.[Start_Time],P.[End_Time],P.[Interviewer1],P.[Interviewer2]  
 ,P.[Block_Id],P.[Venue_Id],P.[VenueStatus],P.[HRApproval]  
 ,J.Applicant_Name,J.Application_No  
 ,e.Employee_FName+'' ''+e.Employee_LName+'' '' as [Employee_Name],R.role_Name  
 FROM [dbo].[Tbl_HRMS_Primary_Interview_Details] P  
 LEFT JOIN [dbo].[Tbl_JobApplication_Deatils] J ON J.Job_Id=P.[Application_No]  
 LEFT JOIN [dbo].[Tbl_Employee] E ON E.Employee_Id=P.[Requested_By]  
 LEFT JOIN [dbo].[Tbl_RoleAssignment] RA ON RA.employee_id=E.Employee_Id  
 LEFT JOIN [dbo].[tbl_Role] R ON R.role_Id=RA.role_id  
 WHERE P.[Schedule_Id]=@Schedule_Id  
 END  
IF(@Flag=3)  
 BEGIN  
 SELECT   
 T.[ID],T.Schedule_Id,T.Requested_By,T.Designation,T.Application_No AS Job_Id,CONVERT(VARCHAR(100),T.[Interview_Date],103) AS [Interview_Date],T.Start_Time,T.End_Time,T.Lead_Assessor,T.Assessor1,T.Assessor2  
 ,T.Block_Id_Teach,T.Vennu_Id_Teach,T.VenueApproval_Teach,T.Interview_Type,T.Interview_Status  
 ,J.Applicant_Name,J.Application_No  
 ,e.Employee_FName+'' ''+e.Employee_LName+'' '' as [Employee_Name],R.role_Name  
 FROM [dbo].[Tbl_HRMS_MockTeaching_Session] T  
 LEFT JOIN [dbo].[Tbl_JobApplication_Deatils] J ON J.Job_Id=T.[Application_No]  
 LEFT JOIN [dbo].[Tbl_Employee] E ON E.Employee_Id=T.[Requested_By]  
 LEFT JOIN [dbo].[Tbl_RoleAssignment] RA ON RA.employee_id=E.Employee_Id  
 LEFT JOIN [dbo].[tbl_Role] R ON R.role_Id=RA.role_id  
 WHERE T.[Schedule_Id]=@Schedule_Id   
 END  
END  
    ')
END
