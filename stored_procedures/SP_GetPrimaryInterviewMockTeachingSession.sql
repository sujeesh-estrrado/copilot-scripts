IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetPrimaryInterviewMockTeachingSession]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[SP_GetPrimaryInterviewMockTeachingSession]
(
    @Schedule_Id BIGINT
)
AS
BEGIN
    SELECT
        P.[Requested_By],
        P.[Designation],
        E.Dept_Designation_Name,
        J.[Application_No],
        CONVERT(VARCHAR(50), P.[Interview_Date], 103) AS [Interview_Date],
        P.[Start_Time],
        P.[End_Time],
        P.Assessor1,
        P.Assessor2,
        P.[Block_Id_Teach],
        P.[Vennu_Id_Teach],
        P.[VenueApproval_Teach],
        R.Room_Name,
        ''Approved'' AS HRApproval,
        CONCAT(E1.[Employee_FName], '' '', E1.[Employee_LName]) AS Assessor1,
        CONCAT(E2.[Employee_FName], '' '', E2.[Employee_LName]) AS Assessor2,
        J.Applicant_Name,
        CONCAT(E3.[Employee_FName], '' '', E3.[Employee_LName]) AS [Lead_Assessor]
    FROM
        [dbo].[Tbl_HRMS_MockTeaching_Session] P
        INNER JOIN [dbo].[Tbl_Emp_DeptDesignation] E 
            ON E.[Dept_Designation_Id] = P.[Designation]
        INNER JOIN [dbo].[Tbl_JobApplication_Deatils] J 
            ON J.Job_Id = P.[Application_No]
        INNER JOIN [dbo].[Tbl_Employee] E1 
            ON E1.[Employee_Id] = P.Assessor1
        INNER JOIN [dbo].[Tbl_Employee] E2 
            ON E2.[Employee_Id] = P.Assessor2
        INNER JOIN [dbo].[Tbl_Employee] E3 
            ON E3.[Employee_Id] = P.[Lead_Assessor]
        INNER JOIN Tbl_Room R 
            ON R.Room_Id = P.[Vennu_Id_Teach]
    WHERE
        [Schedule_Id] = @Schedule_Id
END
');
END;