IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetJobApplicationList]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[SP_GetJobApplicationList]
(
    @SearchKeyWord VARCHAR(MAX),
    @PageSize BIGINT,
    @CurrentPage BIGINT
)
AS
BEGIN
    SELECT 
        J.[Job_Id],
        J.[Application_No],
        CONVERT(VARCHAR(50), J.[Application_Date], 103) AS [Application_Date],
        J.[Revision_No],
        J.[Position_Applied],
        J.[Type_Of_Position],
        J.[Date_Of_Availability],
        J.[Notice_Period],
        J.[Applicant_Name],
        J.[Applicant_Img],
        J.[Ic_Passport_No],
        J.[Country],
        J.[Employment_Pass_No],
        J.[Date_of_Birth],
        J.[Gender],
        J.[Applicant_Address],
        J.[Applicant_Mailing_Address],
        J.[Aplicant_Email_Address],
        J.[Applicant_Contact_Number],
        J.[Applicat_Mobile_Number],
        J.[Emergency_Contact_Name],
        J.[Emergency_RelationShip],
        J.[Emergency_Contact_Number],
        J.[Married_Spouse_Name],
        J.[Married_Spouse_Country],
        J.[Married_Spouse_Occupation],
        J.[Married_Spouse_Contact_No],
        J.[Number_of_Children],
        J.[Employee_Expected_Salary],
        J.[Reference_Check],
        J.[VerificationOfCertificate],
        J.[Information_Checck],
        J.[Status_Of_Application],
        J.[Hired_On_Date],
        J.[Management_Approval],
        P.[Dept_Designation_Name] AS role_Name
    FROM [dbo].[Tbl_JobApplication_Deatils] J
    LEFT JOIN [dbo].[Tbl_Emp_DeptDesignation] P ON P.Dept_Designation_Id = J.Position_Applied
    WHERE J.Del_status = 0 
    AND (
        (J.[Application_No] LIKE ''%'' + @SearchKeyWord + ''%'')
        OR (J.[Applicant_Name] LIKE ''%'' + @SearchKeyWord + ''%'')
        OR (J.[Type_Of_Position] LIKE ''%'' + @SearchKeyWord + ''%'')
        OR (P.[Dept_Designation_Name] LIKE ''%'' + @SearchKeyWord + ''%'')
        OR (J.[Status_Of_Application] LIKE ''%'' + @SearchKeyWord + ''%'')
    )
    ORDER BY J.Job_Id DESC
    OFFSET @PageSize * (@CurrentPage - 1) ROWS
    FETCH NEXT @PageSize ROWS ONLY
    OPTION (RECOMPILE);
END
');
END;