IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Delete_Menu]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[Proc_Delete_Menu](@menu_Id int)

AS
Set NoCount ON

BEGIN

    DELETE FROM [dbo].[tbl_Menu]
        
        WHERE  menu_Id = @menu_Id

END
    ')
END
