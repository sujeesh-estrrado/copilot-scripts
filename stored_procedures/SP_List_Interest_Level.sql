IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_List_Interest_Level]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_List_Interest_Level]
as
begin
select InterestLevel_id,Interest_level_Name from Tbl_Interest_level_Master
end
'
)
END;
