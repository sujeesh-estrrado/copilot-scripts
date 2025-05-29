IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Get_SubMenuCount]')
    AND type = N'P'
)
BEGIN
    EXEC(N'
    create procedure [dbo].[sp_Get_SubMenuCount]
@menu_Id  int
AS
BEGIN

select count(menu_Id) from Tbl_Menu WHERE menu_ParentId=@menu_Id


END

    ');
END;
