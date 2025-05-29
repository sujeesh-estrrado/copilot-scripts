IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Submit_interest_validation]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Sp_Submit_interest_validation]
@interestLevelName varchar(50) = ''''

as
begin
    --  select count (*) AS LeadStatusCount from Tbl_Interest_level_Master where Interest_level_Name = @interestLevelName
	SELECT COUNT(*) AS LeadStatusCount 
FROM Tbl_Interest_Level_Master 
WHERE Interest_level_Name = @InterestLevelName 
AND Interest_level_DelStatus = 0; 
 end
');
END;
