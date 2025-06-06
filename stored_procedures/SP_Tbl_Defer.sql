IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Defer]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Tbl_Defer]
            @candidateid BIGINT = 0,
            @deferid BIGINT = 0,
            @Dateofreturn DATETIME = NULL,
            @flag BIGINT = 0,
            @intakeid BIGINT = 0
        AS
        BEGIN
            IF (@flag = 1)
            BEGIN
                INSERT INTO Tbl_Defer_Status(Candidate_ID, Date_Of_Return, Status, delete_status, intakeid)
                VALUES (@candidateid, @Dateofreturn, 0, 0, @intakeid);
            END

            IF (@flag = 2) -- select details using candidateid
            BEGIN
                SELECT * 
                FROM Tbl_Defer_Status D
                LEFT JOIN tbl_course_batch_duration C ON C.batch_id = D.intakeid
                WHERE D.Candidate_ID = @candidateid;
            END

            IF (@flag = 3)
            BEGIN
                UPDATE dbo.Tbl_Candidate_Personal_Det
                SET 
                    Active_Status = ''Incative'', 
                    [Status] = ''Incative'', 
                    active = 5,
                    Candidate_DelStatus = 1
                WHERE Candidate_Id = @Candidateid;

                UPDATE Tbl_Student_Tc_request
                SET 
                    Delete_status = 1,
                    Final_Approval_date = GETDATE()
                WHERE Candidate_id = @Candidateid
                    AND Request_type = ''Defer''
                    AND Delete_status = 0;
            END
        END
    ')
END
