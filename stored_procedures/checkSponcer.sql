IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[checkSponcer]') 
    AND type = N'P'
)
BEGIN
    EXEC('
create PROCEDURE [dbo].[checkSponcer] 
   @SponcerID varchar(50)
AS    
BEGIN 
IF EXISTS (SELECT 1 FROM ref_sponsor WHERE SponcerID = @SponcerID AND Delstatus = 0)
    SELECT 1 AS Result
ELSE
    SELECT 0 AS Result

end
    ')
END;
