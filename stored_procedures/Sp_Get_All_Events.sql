IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_All_Events]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Sp_Get_All_Events] 
        @Emp_ID BIGINT = 0
        AS
        BEGIN
            SELECT DISTINCT 
                ED.Event_Id,
                ED.EventName
            FROM 
                Tbl_Event_Details ED
            LEFT JOIN Tbl_Director_Approvals DA ON DA.Event_ID = ED.Event_ID
            LEFT JOIN Tbl_MD_Approval MA ON MA.Event_Id = ED.Event_Id
            LEFT JOIN Tbl_Marketing_ManangerApproval MMA ON MMA.Event_Id = ED.Event_Id
            WHERE 
                (MMA.Approval_Status = 1 OR DA.Approval_Status = 1 OR MA.Approval_Status = 1)
                AND (ED.EventLeader = @Emp_ID OR @Emp_ID = 0)
        END
    ')
END
