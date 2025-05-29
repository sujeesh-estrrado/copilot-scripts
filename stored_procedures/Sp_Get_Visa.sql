IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_Verified_By]')
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE PROCEDURE [dbo].[Sp_Get_Verified_By]
        @candidate_id BIGINT
    AS
    BEGIN
        SELECT 
            al.candidate_id,
            CONCAT(
                ISNULL(emp.Employee_FName, ''''), '' '', 
                ISNULL(emp.Employee_LName, ''''), '' - '', 
                FORMAT(al.Verified_date, ''yyyy-MM-dd HH:mm:ss'')
            ) AS Verified_by,
            al.Offerletter_status
        FROM dbo.tbl_approval_log al
        INNER JOIN dbo.Tbl_Candidate_Personal_Det cpd 
            ON cpd.Candidate_Id = al.candidate_id
        INNER JOIN dbo.Tbl_Employee_User eu
            ON eu.User_Id = al.Verified_by
        INNER JOIN dbo.Tbl_Employee emp
            ON eu.Employee_Id = emp.Employee_Id
        WHERE al.candidate_id = @candidate_id;
    END
    ')
END
GO
