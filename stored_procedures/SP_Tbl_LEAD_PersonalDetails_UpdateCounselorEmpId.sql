IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_LEAD_PersonalDetails_UpdateCounselorEmpId]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Tbl_LEAD_PersonalDetails_UpdateCounselorEmpId]    
        (    
            @CounselorEmployeeId bigint,    
            @CandidateId bigint
        )    
        AS    
        BEGIN
            DECLARE @prevCounselorEmployeeId bigint = -1,
                    @leadCreateDtim datetime,
                    @curDtim datetime,
                    @ID bigint

            IF NOT EXISTS (
                SELECT Candidate_Id 
                FROM Tbl_Lead_Personal_Det
                WHERE Candidate_Id = ISNULL(@CandidateId, -1)
            )
            BEGIN
                -- Update Tbl_Lead_Personal_Det SET CounselorEmployee_id = NULL WHERE Candidate_Id = -1
                RETURN
            END

            SELECT @curDtim = GETDATE()

            SELECT 
                @prevCounselorEmployeeId = ISNULL(CounselorEmployee_id, -1),
                @leadCreateDtim = create_date
            FROM Tbl_Lead_Personal_Det
            WHERE Candidate_Id = @CandidateId

            IF ISNULL(@CounselorEmployeeId, -1) <> @prevCounselorEmployeeId
            BEGIN
                IF NOT EXISTS (
                        SELECT leadAssignID 
                        FROM Tbl_LeadAssign
                        WHERE Candidate_Id = @CandidateId
                    ) AND @prevCounselorEmployeeId > 0
                BEGIN
                    INSERT INTO Tbl_LeadAssign(Candidate_Id, CounselorEmployee_id, startDtim, isLatest)
                    VALUES (@CandidateId, @prevCounselorEmployeeId, @leadCreateDtim, 1)
                END

                UPDATE Tbl_Lead_Personal_Det 
                SET CounselorEmployee_id = @CounselorEmployeeId    
                WHERE Candidate_Id = @CandidateId

                UPDATE Tbl_LeadAssign 
                SET endDtim = @curDtim
                WHERE Candidate_Id = @CandidateId 
                  AND isLatest = 1 
                  AND endDtim IS NULL

                IF ISNULL(@CounselorEmployeeId, -1) > 0
                BEGIN
                    INSERT INTO Tbl_LeadAssign(Candidate_Id, CounselorEmployee_id, startDtim, isLatest)
                    VALUES (@CandidateId, @CounselorEmployeeId, @curDtim, 1)
                    SET @ID = SCOPE_IDENTITY()

                    UPDATE Tbl_LeadAssign 
                    SET isLatest = 0 
                    WHERE Candidate_Id = @CandidateId 
                      AND leadAssignID <> @ID
                END

                EXEC SP_Tbl_LEADAssign_UpdateIsPrev @CandidateId
            END
        END
    ')
END
