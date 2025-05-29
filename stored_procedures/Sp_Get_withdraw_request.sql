IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_withdraw_request]')
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Sp_Get_withdraw_request]
            @Candidate_Id BIGINT
        AS
        BEGIN
            SELECT * 
            FROM Tbl_Student_Tc_request 
            WHERE Candidate_id = @Candidate_Id 
              AND Delete_status = 0 
              AND (request_type = ''Withdraw'' OR request_type = ''Defer'' OR request_type = ''Termination'');
        END
    ')
END
GO
