IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Candidate_PersonalDetails_UpdateCounselorEmpId]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Tbl_Candidate_PersonalDetails_UpdateCounselorEmpId]
            @CounselorEmployeeId BIGINT,
            @CandidateId BIGINT,
            @flag BIGINT = 0
        AS
        BEGIN
            IF (@flag = 0)
            BEGIN
                UPDATE Tbl_Candidate_Personal_Det
                SET CounselorEmployee_id = @CounselorEmployeeId
                WHERE Candidate_Id = @CandidateId;
            END

            IF (@flag = 1)
            BEGIN
                UPDATE Tbl_Student_NewApplication
                SET CounselorEmployee_id = @CounselorEmployeeId
                WHERE Candidate_Id = @CandidateId;
            END
        END
    ')
END
