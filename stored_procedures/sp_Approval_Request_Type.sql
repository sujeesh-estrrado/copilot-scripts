IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Approval_Request_Type]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[sp_Approval_Request_Type]
        (
            @flag bigint = 0,
            @roleid bigint = 0
        )
        AS
        BEGIN
            IF (@flag = 0)
            BEGIN
                SELECT * 
                FROM Approval_Request_Type 
                WHERE [Types] != ''OnlinePayment'';
            END

            IF (@flag = 1)
            BEGIN
                SELECT DISTINCT 
                    AR.Id,
                    AR.Types,
                    FM.id AS MasterId,
                    FM.Type,
                    FM.FinanceAccess
                FROM 
                    Approval_Request_Type AR
                LEFT JOIN 
                    tbl_FinanceAccessMaster FM ON AR.Id = FM.Type
                LEFT JOIN 
                    tbl_FinanceUserRole FR ON FR.MenuID = FM.id
                WHERE 
                    AR.Types != ''OnlinePayment'' 
                    AND FR.status = 1 
                    AND FR.RoleID = @roleid;
            END
        END
    ')
END
