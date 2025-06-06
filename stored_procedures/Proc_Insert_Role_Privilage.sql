-- Check if the stored procedure [dbo].[Proc_Insert_Role_Privilage] exists, if not, create it
IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Insert_Role_Privilage]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Proc_Insert_Role_Privilage]
        (
            @role_Id INT,
            @menu_Id INT,
            @Save_Status BIT,
            @Update_Status BIT,
            @Delete_Status BIT,
            @View_Status BIT
        )
        AS
        BEGIN
            -- Check if the role and menu already exist in the Tbl_Role_Privilage table
            IF EXISTS (
                SELECT * 
                FROM Tbl_Role_Privilage 
                WHERE role_Id = @role_Id 
                    AND Menu_Id = @menu_Id
            )
            BEGIN
                -- Update existing record
                UPDATE Tbl_Role_Privilage 
                SET 
                    Save_Status = @Save_Status,
                    Update_Status = @Update_Status,
                    Delete_Status = @Delete_Status,
                    View_Status = @View_Status
                WHERE role_Id = @role_Id 
                    AND Menu_Id = @menu_Id;
            END
            ELSE
            BEGIN
                -- Insert new record
                INSERT INTO Tbl_Role_Privilage
                (
                    role_Id,
                    Menu_Id,
                    Save_Status,
                    Update_Status,
                    Delete_Status,
                    View_Status
                )
                VALUES
                (
                    @role_Id,
                    @menu_Id,
                    @Save_Status,
                    @Update_Status,
                    @Delete_Status,
                    @View_Status
                );
            END
        END
    ')
END
