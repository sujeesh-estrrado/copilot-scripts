IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_Old_VisaNum]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[Sp_Get_Old_VisaNum]
    @candidate_id BIGINT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT top 1  New 
    FROM Tbl_Visa_Log
    WHERE Candidate_Id = @candidate_id 
      AND Log_Details LIKE ''%Visa%'' and (New is not null and New!='''') -- Ensures "visa" exists in the log details
    ORDER BY Log_Id DESC; -- Gets the latest entry
END;
   ')
END;
