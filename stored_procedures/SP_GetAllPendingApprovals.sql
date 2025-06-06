IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAllPendingApprovals]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_GetAllPendingApprovals]
AS
BEGIN
select Payment_Details_Particulars,count(a.Approval_Id) as ''PendingApproval''
from dbo.Tbl_Payment_Approval_List a
Inner Join Tbl_Payment_Details d
On a.Approval_Id=d.Approval_Id
where Approval_Status=0  and Approval_Del_Status=0 
Group By  Payment_Details_Particulars
END

   ')
END;
