-- Check if the stored procedure [dbo].[Proc_GetAll_Purchase_Request_Approval_By_Role_Wise] exists, if not, create it
IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetAll_Purchase_Request_Approval_By_Role_Wise]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Proc_GetAll_Purchase_Request_Approval_By_Role_Wise]
        (
            @Role_Id bigint
        )
        AS
        BEGIN
            SELECT DISTINCT 
                pr.Purchase_Request_Code,
                pr.Purchase_Request_Date,
                u.user_Id,
                u.user_name,
                pra.Approval_Role_Id,
                --pr.Purchase_Request_Id,
                pr.Request_Status,
                pra.Status,
                r.role_Name AS Approval_Role_Name,
                pra.Status_Remarks,
                ISNULL(pr.Dept_Name, '''') AS Dept_Name
            FROM dbo.Tbl_Purchase_Request pr
            LEFT JOIN Purchase_Request_Approval pra 
                ON pr.Purchase_Request_Code = pra.Purchase_Request_Code
            LEFT JOIN dbo.Tbl_User u 
                ON pr.Requested_User_Id = u.user_Id
            LEFT JOIN dbo.tbl_Role r 
                ON r.role_Id = pra.Approval_Role_Id
            WHERE pra.Approval_Role_Id = @Role_Id
            AND pr.Approval_Delete_Status = ''SAVED''
            ORDER BY pr.Purchase_Request_Code ASC
        END
    ')
END
