IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_request_tc_faculty]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[Sp_request_tc_faculty]
(
    @Candidate_Id BIGINT,
    @type VARCHAR(50),
    @remark VARCHAR(MAX),
    @Faculty BIGINT,
    @flag BIGINT
)
AS
BEGIN
    IF (@flag = 0)
    BEGIN
        IF NOT EXISTS (
            SELECT * FROM Tbl_Student_Tc_request 
            WHERE Candidate_id = @Candidate_Id 
              AND Delete_status = 0 
              AND Request_type = @type
        )
        BEGIN
            INSERT INTO Tbl_Student_Tc_request (
                Candidate_id,
                Create_date,
                faculty_remark,
                Request_type,
                Faculty_id,
                Request_status,
                Delete_status
            ) 
            VALUES (
                @Candidate_Id,
                GETDATE(),
                @remark,
                @type,
                @Faculty,
                ''Pending'',
                0
            );
        END
    END
    
    IF (@flag = 5) -- Reject request
    BEGIN
        UPDATE Tbl_Student_Tc_request 
        SET Faculty_remark = @remark,
            Delete_status = 1,
            Request_status = ''Rejected'' 
        WHERE Candidate_id = @Candidate_Id 
          AND Delete_status = 0 
          AND Request_type = @type;
    END
    ELSE IF (@flag NOT IN (0,3,5)) -- Default update for other flags
    BEGIN
        UPDATE Tbl_Student_Tc_request 
        SET Faculty_remark = @remark 
        WHERE Candidate_id = @Candidate_Id 
          AND Delete_status = 0 
          AND Request_type = @type;
    END
    
    IF (@flag = 3) -- Handle termination request
    BEGIN
        IF EXISTS (
            SELECT * FROM Tbl_Student_Tc_request 
            WHERE Candidate_id = @Candidate_Id 
              AND Delete_status = 0 
              AND Request_type != ''Termination''
        )
        BEGIN
            -- Reject existing non-termination requests
            UPDATE Tbl_Student_Tc_request 
            SET Faculty_remark = ''rejected due to termination requested'',
                Delete_status = 1,
                Request_status = ''Rejected'' 
            WHERE Candidate_id = @Candidate_Id 
              AND Delete_status = 0;
            
            -- Insert new termination request
            INSERT INTO Tbl_Student_Tc_request (
                Candidate_id,
                Create_date,
                faculty_remark,
                Request_type,
                Faculty_id,
                Request_status,
                Delete_status
            ) 
            VALUES (
                @Candidate_Id,
                GETDATE(),
                @remark,
                @type,
                @Faculty,
                ''Pending'',
                0
            );
        END
        ELSE
        BEGIN
            -- Insert new termination request if no existing requests
            INSERT INTO Tbl_Student_Tc_request (
                Candidate_id,
                Create_date,
                faculty_remark,
                Request_type,
                Faculty_id,
                Request_status,
                Delete_status
            ) 
            VALUES (
                @Candidate_Id,
                GETDATE(),
                @remark,
                @type,
                @Faculty,
                ''Pending'',
                0
            );
        END
    END
END
');
END;