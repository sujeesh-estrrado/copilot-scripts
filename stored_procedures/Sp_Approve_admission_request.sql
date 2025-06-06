IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Approve_admission_request]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Sp_Approve_admission_request]
        (
            @candidateid bigint,
            @userid bigint,
            @remark varchar(max),
            @flag bigint = 0
        )
        AS
        BEGIN
            IF (@flag = 0)
            BEGIN
                UPDATE Tbl_admission_approval_request 
                SET 
                    Remark = @remark,
                    Approved_By = @userid,
                    Verification_status = ''Approved''
                WHERE 
                    candidate_id = @candidateid;
            END
            ELSE
            BEGIN
                IF (NOT EXISTS (SELECT * FROM Tbl_admission_approval_request WHERE candidate_id = @candidateid AND Verification_status = ''Rejected''))
                BEGIN
                    UPDATE Tbl_admission_approval_request 
                    SET 
                        Remark = @remark,
                        Approved_By = @userid,
                        Verification_status = ''Rejected''
                    WHERE 
                        candidate_id = @candidateid;
                END
            END
        END
    ')
END
