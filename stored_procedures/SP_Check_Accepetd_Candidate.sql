IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Check_Accepetd_Candidate]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Check_Accepetd_Candidate]
            @id BIGINT,
            @flag BIGINT = 0
        AS
        BEGIN
            IF(@flag = 0)
            BEGIN
                -- Select Offerletter status for the given candidate ID
                SELECT L.Offerletter_status
                FROM dbo.tbl_approval_log L
                INNER JOIN dbo.Tbl_Candidate_Personal_Det 
                    ON L.candidate_id = dbo.Tbl_Candidate_Personal_Det.Candidate_Id
                WHERE dbo.Tbl_Candidate_Personal_Det.Candidate_Id = @id 
                    AND L.delete_status = 0;
            END

            IF(@flag = 1)
            BEGIN
                -- Delete from tbl_approval_log and Tbl_Offerlettre where candidate_id matches
                DELETE FROM tbl_approval_log WHERE candidate_id = @id;
                DELETE FROM Tbl_Offerlettre WHERE candidate_id = @id;
            END
        END
    ')
END
