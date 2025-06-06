IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Check_counselor_mapping]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Sp_Check_counselor_mapping]
            @Student_id BIGINT = 0
        AS
        BEGIN
            -- Select Counselor_id and Counselling_Status based on Student_id and conditions
            SELECT Counselor_id, Counselling_Status 
            FROM Tbl_Student_Tc_request 
            WHERE Candidate_id = @Student_id 
                AND Request_type = ''Withdraw'' 
                AND Delete_status = 0;
        END
    ')
END
