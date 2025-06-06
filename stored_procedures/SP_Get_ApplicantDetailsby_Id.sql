IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_ApplicantDetailsby_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Get_ApplicantDetailsby_Id] 
        @Job_Id BIGINT
        AS
        BEGIN
            BEGIN TRAN
                SELECT 
                    J.[Applicant_Name],
                    CONCAT(E.[Employee_FName], E.[Employee_LName]) AS [Interviewer1],
                    CONCAT(E1.[Employee_FName], E1.[Employee_LName]) AS [Interviewer2]    
                FROM 
                    [dbo].[Tbl_JobApplication_Deatils] J  
                LEFT JOIN 
                    [dbo].[Tbl_HRMS_Primary_Interview_Details] H ON H.Application_No = J.Job_Id  
                LEFT JOIN 
                    [dbo].[Tbl_Employee] E ON E.Employee_Id = H.Interviewer1  
                LEFT JOIN 
                    [dbo].[Tbl_Employee] E1 ON E1.Employee_Id = H.Interviewer2  
                WHERE 
                    J.Job_Id = @Job_Id
            COMMIT
        END
    ')
END
