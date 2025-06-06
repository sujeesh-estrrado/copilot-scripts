IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetAll_Menu]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Proc_GetAll_Menu]
        AS
        BEGIN
            SELECT
                menu_Id,
                menu_Name,
                menu_dtTime,
                menu_ImageName,
                menu_color,
                menu_ParentId,
                menu_ToPage
            FROM [dbo].[tbl_Menu]
            ORDER BY menu_DisplayOrder
        END
    ')
END
