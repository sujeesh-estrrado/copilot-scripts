IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_GetAllInterestLevelMaster]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[Sp_GetAllInterestLevelMaster]
as
begin

select InterestLevel_ID as InterestLevelID,
Interest_level_Name as InterestlevelName from Tbl_Interest_level_Master where Interest_level_DelStatus=0
end'
)
END;
