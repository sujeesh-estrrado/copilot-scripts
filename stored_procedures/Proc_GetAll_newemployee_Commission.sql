-- Check if the stored procedure [dbo].[Proc_GetAll_newemployee_Commission] exists, if not, create it
IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetAll_newemployee_Commission]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Proc_GetAll_newemployee_Commission]
        AS
        BEGIN
            SELECT DISTINCT 
                UPPER(CONCAT(Employee_FName, '' '', Employee_LName)) AS Employee_Name,
                Employee_Id 
            FROM dbo.Tbl_Employee 
            INNER JOIN dbo.Tbl_Candidate_Personal_Det 
                ON Tbl_Employee.Employee_Id = dbo.Tbl_Candidate_Personal_Det.CounselorEmployee_id
            WHERE Employee_Status = 0
            ORDER BY Employee_Name ASC
        END
    ')
END
