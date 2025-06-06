-- Check if the stored procedure [dbo].[Proc_Insert_Role] exists, if not, create it
IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Insert_Role]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Proc_Insert_Role]
        (
            @role_Name VARCHAR(50),
            @role_status BIT,
            @role_dtTime DATETIME,
            @role_DeleteStatus BIT,
            @Is_Authority BIT,
            @Is_PrimeAuthority BIT,
            @Approval_limit_amount VARCHAR(50)
        )
        AS
        BEGIN
            -- Check if the role already exists
            IF EXISTS (
                SELECT *
                FROM tbl_Role
                WHERE role_Name = @role_Name
                    AND role_DeleteStatus = 0
            )
            BEGIN
                RAISERROR (
                    ''Role already exists.'', -- Message text.
                    16, -- Severity.
                    1  -- State.
                );
            END
            ELSE
            BEGIN
                -- Insert the new role
                INSERT INTO tbl_Role
                (
                    role_Name,
                    role_status,
                    role_dtTime,
                    role_DeleteStatus,
                    Is_Authority,
                    Is_PrimeAuthority,
                    Approval_limit_amount
                )
                VALUES
                (
                    @role_Name,
                    @role_status,
                    @role_dtTime,
                    @role_DeleteStatus,
                    @Is_Authority,
                    @Is_PrimeAuthority,
                    @Approval_limit_amount
                );
            END
        END
    ')
END
