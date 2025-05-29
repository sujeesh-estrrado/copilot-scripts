IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[usp_Insert_Modular_OfferLetter]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[usp_Insert_Modular_OfferLetter]
    @CandidateId INT,
    @CourseId INT,
    @SlotId INT 
AS
BEGIN
    INSERT INTO tbl_Modular_OfferLetter (CandidateId, CourseId, SlotId, Del_Status)
    VALUES (@CandidateId, @CourseId, @SlotId, 0);
     
    SELECT SCOPE_IDENTITY() AS InsertedId;   
END
    ')
END;
