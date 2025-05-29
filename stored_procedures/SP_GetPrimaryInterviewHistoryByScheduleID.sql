IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetPrimaryInterviewHistoryByScheduleID]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[SP_GetPrimaryInterviewHistoryByScheduleID]
(
    @Schedule_Id BIGINT,
    @flag BIGINT = 0
)
AS
BEGIN
    IF (@flag = 0)
    BEGIN
        SELECT
            P.[Requested_By],
            P.[Designation],
            E.Dept_Designation_Name,
            J.Application_No,
            CONVERT(VARCHAR(50), P.[Interview_Date], 103) AS [Interview_Date],
            P.[Start_Time],
            P.[End_Time],
            P.[Interviewer1],
            P.[Interviewer2],
            P.[Block_Id],
            P.[Venue_Id],
            P.[VenueStatus],
            R.Room_Name,
            ''Approved'' AS HRApproval,
            CONCAT(E1.[Employee_FName], '' '', E1.[Employee_LName]) AS Interviewer1,
            CONCAT(E2.[Employee_FName], '' '', E2.[Employee_LName]) AS Interviewer2,
            J.Applicant_Name
        FROM
            [dbo].[Tbl_HRMS_Primary_Interview_Details] P
            INNER JOIN [dbo].[Tbl_Emp_DeptDesignation] E ON E.[Dept_Designation_Id] = P.[Designation]
            INNER JOIN [dbo].[Tbl_JobApplication_Deatils] J ON J.Job_Id = P.[Application_No]
            INNER JOIN [dbo].[Tbl_Employee] E1 ON E1.[Employee_Id] = P.[Interviewer1]
            INNER JOIN [dbo].[Tbl_Employee] E2 ON E2.[Employee_Id] = P.[Interviewer2]
            INNER JOIN Tbl_Room R ON R.Room_Id = P.[Venue_Id]
        WHERE
            [Schedule_Id] = @Schedule_Id
    END
    
    IF (@flag = 1)
    BEGIN
        SELECT
            P.[Requested_By],
            P.[Designation],
            E.Dept_Designation_Name,
            J.Application_No,
            CONVERT(VARCHAR(50), P.[Interview_Date], 103) AS [Interview_Date],
            P.[Start_Time],
            P.[End_Time],
            P.[Interviewer1],
            P.[Interviewer2],
            P.[Block_Id],
            P.[Venue_Id],
            P.[Venue_Approval] AS [VenueStatus],
            R.Room_Name,
            ''Approved'' AS HRApproval,
            CONCAT(E1.[Employee_FName], '' '', E1.[Employee_LName]) AS Interviewer1,
            CONCAT(E2.[Employee_FName], '' '', E2.[Employee_LName]) AS Interviewer2,
            J.Applicant_Name
        FROM
            [dbo].[Tbl_HRMS_Second_Interview_Details] P
            INNER JOIN [dbo].[Tbl_Emp_DeptDesignation] E ON E.[Dept_Designation_Id] = P.[Designation]
            INNER JOIN [dbo].[Tbl_JobApplication_Deatils] J ON J.Job_Id = P.[Application_No]
            INNER JOIN [dbo].[Tbl_Employee] E1 ON E1.[Employee_Id] = P.[Interviewer1]
            INNER JOIN [dbo].[Tbl_Employee] E2 ON E2.[Employee_Id] = P.[Interviewer2]
            INNER JOIN Tbl_Room R ON R.Room_Id = P.[Venue_Id]
        WHERE
            [Schedule_Id] = @Schedule_Id
    END
END
');
END;