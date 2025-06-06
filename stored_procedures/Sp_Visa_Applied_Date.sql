IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Visa_Applied_Date]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        
CREATE PROCEDURE [dbo].[Sp_Visa_Applied_Date] 
    @Candidate_Id BIGINT
AS
BEGIN
    SET NOCOUNT ON;

 --   SELECT Applied_Date AS Visa_Applied_Date
 --   FROM Tbl_Visa_ISSO
 --   WHERE Candidate_Id = @Candidate_Id
    --AND Visa_Status = ''Applied'';
    SELECT MAX(Applied_Date) AS Visa_Applied_Date
FROM Tbl_Visa_ISSO
WHERE Candidate_Id = @Candidate_Id
AND Visa_Status = ''Applied'';


END;
    ')
END
