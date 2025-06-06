IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Status_Check]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        
CREATE PROCEDURE [dbo].[Sp_Status_Check] 
    @Candidate_Id BIGINT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *  
    FROM Tbl_Visa_ISSO
    WHERE Candidate_Id = @Candidate_Id AND Visa_Status IN( ''Applied'');

END
    ')
END
