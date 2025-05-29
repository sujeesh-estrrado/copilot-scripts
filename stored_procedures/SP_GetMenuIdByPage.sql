IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetMenuIdByPage]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_GetMenuIdByPage] 
@menu_ToPage varchar(50)
As
Begin
Select menu_ParentId From tbl_Menu Where menu_ToPage like @menu_ToPage
End
');
END;