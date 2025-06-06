-- Check if the stored procedure [dbo].[Proc_Insert_Menu] exists, if not, create it
IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Insert_Menu]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Proc_Insert_Menu]
        (
            @menu_Name VARCHAR(150),
            @menu_dtTime DATETIME,
            @menu_ParentId BIGINT,
            @menu_ToPage VARCHAR(50),
            @menu_ImageName VARCHAR(50),
            @menu_color VARCHAR(50),
            @menu_description VARCHAR(100)
        )
        AS
        BEGIN
            -- Insert a new Menu entry into tbl_Menu table
            INSERT INTO tbl_Menu (menu_Name, menu_dtTime, menu_ParentId, menu_ToPage, menu_ImageName, menu_color, menu_description)
            VALUES (@menu_Name, @menu_dtTime, @menu_ParentId, @menu_ToPage, @menu_ImageName, @menu_color, @menu_description);
        END
    ')
END
