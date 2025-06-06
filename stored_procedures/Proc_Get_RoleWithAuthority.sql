IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Get_RoleWithAuthority]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Proc_Get_RoleWithAuthority]
        (@id INT)
        AS
        BEGIN
            SELECT  
                role_Id,
                role_Name,
                role_status,
                Is_Authority,
                Is_PrimeAuthority,
                Approval_limit_amount,
                role_dtTime
            FROM 
                [dbo].[tbl_Role] 
            WHERE 
                role_DeleteStatus = 0 
            AND 
                Is_Authority = 1 
            AND 
                role_Id <> @id
            ORDER BY 
                role_Name
        END
    ')
END
