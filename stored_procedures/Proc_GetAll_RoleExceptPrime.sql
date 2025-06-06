-- Check if the stored procedure [dbo].[Proc_GetAll_RoleExceptPrime] exists, if not, create it
IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetAll_RoleExceptPrime]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Proc_GetAll_RoleExceptPrime]
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
                AND Is_PrimeAuthority = 0
            ORDER BY 
                role_Name
        END
    ')
END
