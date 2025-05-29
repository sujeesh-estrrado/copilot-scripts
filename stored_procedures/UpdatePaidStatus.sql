IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[UpdatePaidStatus]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[UpdatePaidStatus]

(@Id bigint)

as begin

update dbo.Tbl_Refund_Approval set PaidStatus=1 where Refund_Approval_Id=@Id

end
   ')
END;
