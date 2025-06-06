IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_student_appeal]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Sp_student_appeal]
        @flag BIGINT = 0, 
        @id BIGINT = 0, 
        @candidate_id BIGINT = 0, 
        @remark VARCHAR(MAX) = '''', 
        @status BIT = 0, 
        @employee_id BIGINT
        AS
        BEGIN
            IF (@flag = 1)
            BEGIN
                -- If not exists (uncomment the next block if needed)
                -- IF NOT EXISTS (SELECT * FROM tbl_student_appeal WHERE candidate_id = @candidate_id AND delete_status = 0)
                -- BEGIN

                    INSERT INTO tbl_student_appeal 
                    (candidate_id, Create_date, created_by, delete_status, appeal_status, Request_id) 
                    VALUES 
                    (@candidate_id, GETDATE(), @employee_id, 0, 0, 
                        (SELECT tc_request_id 
                         FROM Tbl_Student_Tc_request 
                         WHERE Candidate_id = @candidate_id 
                           AND Request_type = ''Termination'' 
                           AND delete_status = 0));

                -- END
            END

            IF (@flag = 2)
            BEGIN
                SELECT * 
                FROM tbl_student_appeal 
                WHERE candidate_id = @candidate_id 
                  AND delete_status = 0;
            END

            IF (@flag = 3)
            BEGIN
                UPDATE tbl_student_appeal 
                SET Student_remark = @remark, 
                    appeal_status = 1, 
                    appeal_date = GETDATE() 
                WHERE candidate_id = @candidate_id 
                  AND delete_status = 0;
            END
        END
    ')
END
