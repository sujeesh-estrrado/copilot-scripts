IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Update_Menu]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[Proc_Update_Menu](@menu_Id int,@menu_Name varchar(150),
                    @menu_dtTime datetime)

AS

BEGIN

    UPDATE [dbo].[tbl_Menu]
        SET    menu_Name                = @menu_Name  ,
               menu_dtTime              = @menu_dtTime
        WHERE  menu_Id = @menu_Id

END
    ')
END
