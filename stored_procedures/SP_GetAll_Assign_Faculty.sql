IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAll_ApprovedPurchase_Requests]')
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE PROCEDURE [dbo].[SP_GetAll_ApprovedPurchase_Requests]
    AS
    BEGIN
        SELECT DISTINCT 
            pr.Purchase_Request_Code,
            pr.Requested_User_Id,
            pr.Purchase_Request_Date,
            pr.Status_Remarks,
            pr.Request_Status,
            u.user_name
        FROM dbo.Tbl_Purchase_Request pr
        LEFT JOIN dbo.Tbl_User u ON pr.Requested_User_Id = u.user_Id
        LEFT JOIN dbo.tbl_Role r ON r.role_Id = u.role_Id
        WHERE pr.Request_Status = ''Approved''
    END
    ')
END
GO
