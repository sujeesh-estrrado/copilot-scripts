IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_check_OfferLetter]')
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[SP_check_OfferLetter]
    @CourseId INT,
    @SlotId INT,
    @CandidateId INT
AS
BEGIN
    SELECT * FROM tbl_Modular_OfferLetter 
    WHERE CourseId = @CourseId 
    AND SlotId = @SlotId 
    AND CandidateId = @CandidateId
    AND Del_Status = 0
END;
    ')
END