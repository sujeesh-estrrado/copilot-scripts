IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_VALIDATE_ICPASSPORT]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[SP_VALIDATE_ICPASSPORT]
     @Passport nvarchar(50),
     @CanId BIGINT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @CandidateID int;

    SELECT  @CandidateID = Candidate_Id FROM Tbl_Candidate_Personal_Det WHERE AdharNumber = @Passport;
    IF(@CanId <> @CandidateId)
        BEGIN
        IF @CandidateID IS NOT NULL
        BEGIN

        select * from Tbl_Candidate_Personal_Det where AdharNumber = @Passport and Candidate_Id = @CandidateID;

        END

        ELSE

        BEGIN

        select * from Tbl_Candidate_Personal_Det where AdharNumber = @Passport ;

        END
    END
END;

    ')
END
