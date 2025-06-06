IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Edit_request_Student]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Sp_Edit_request_Student]
        @Candidate_id BIGINT = 0,
        @flag BIGINT = 0,
        @remark VARCHAR(MAX) = ''''
        AS
        BEGIN
            IF (@flag = 0)
            BEGIN
                UPDATE Tbl_Student_NewApplication
                SET Edit_request = 1, Edit_request_remark = @remark
                WHERE Candidate_Id = @Candidate_id;
            END
            ELSE IF (@flag = 1)
            BEGIN
                UPDATE Tbl_Student_NewApplication
                SET Edit_status = 1, Edit_request = 0, Editable = 1
                WHERE Candidate_Id = @Candidate_id;
            END
        END
    ')
END
