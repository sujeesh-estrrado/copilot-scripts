IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Status_Reject_Check]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Sp_Status_Reject_Check] 
    @Candidate_Id BIGINT
AS
BEGIN
    SET NOCOUNT ON; 
   
    IF NOT EXISTS (
        SELECT 1 FROM Tbl_Visa_ISSO
        WHERE Candidate_Id = @Candidate_Id AND Visa_Status = ''Pending'' AND Del_Status IN (0,1)
    )
    BEGIN  
        SELECT *  
        FROM Tbl_Visa_ISSO
        WHERE Candidate_Id = @Candidate_Id AND Visa_Status = ''Rejected'' AND Del_Status = 1;
    END


END
    ')
END
