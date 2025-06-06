IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[UpdateCandidateVerification]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[UpdateCandidateVerification]
    @UserId BIGINT
AS
BEGIN
    -- Update the Candidate Verification column
    UPDATE [Elvis_SevenSkies_DEV].[dbo].[Tbl_Candidate_Personal_Det]
    SET VerifiedBy = CASE
                        WHEN eu.User_Id = 1 THEN ''admin''
                        ELSE e.Employee_FName + '' '' + e.Employee_LName
                     END
    FROM [Elvis_SevenSkies_DEV].[dbo].[Tbl_Candidate_Personal_Det] cpd
    INNER JOIN [Elvis_SevenSkies_DEV].[dbo].[Tbl_Employee_User] eu
        ON cpd.CounselorEmployee_id = eu.Employee_Id
    INNER JOIN [Elvis_SevenSkies_DEV].[dbo].[Tbl_Employee] e
        ON eu.Employee_Id = e.Employee_Id
    WHERE eu.User_Id = @UserId;
END
    ')
END;
