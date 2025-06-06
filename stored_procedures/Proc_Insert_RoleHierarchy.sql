-- Check if the stored procedure [dbo].[Proc_Insert_RoleHierarchy] exists, if not, create it
IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Insert_RoleHierarchy]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Proc_Insert_RoleHierarchy]
        (
            @role_Id INT,
            @reporting_role_Id INT,
            @role_hierarchy_DelStatus BIT
        )
        AS
        BEGIN
            -- Start a transaction
            BEGIN TRAN;

            -- Check if the role hierarchy record exists; if not, insert it
            IF NOT EXISTS (
                SELECT * 
                FROM Tbl_Role_hierarchy 
                WHERE role_Id = @role_Id 
                    AND reporting_role_Id = @reporting_role_Id  
                    AND role_hierarchy_DelStatus = 0
            )
            BEGIN
                -- Insert new role hierarchy record
                INSERT INTO Tbl_Role_hierarchy (role_Id, reporting_role_Id, role_hierarchy_DelStatus)
                VALUES (@role_Id, @reporting_role_Id, @role_hierarchy_DelStatus);
            END

            -- Commit the transaction
            COMMIT TRAN;
        END
    ')
END
