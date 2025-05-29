IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Insert_Budget_Approval]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[Sp_Insert_Budget_Approval] 
	(
	@Event_Id bigint
	
	)
AS
BEGIN
insert into Tbl_Budget_Approvals 
(
Event_Id,
MarketingManagerApproval,
MarketingManagerApproval_Remark,
MarketingManagerReject_Remark,
PsoApproval,
PsoApproval_Remark,
PsoReject_Remark,
DirectorApproval,
DirectorApproval_Remark,
DirectorReject_Remark,
MD_Approval,
MD_ApprovalRemark,
MD_RejectRemark) 
values(

@Event_Id,
0,
null,null,
0,
null,null,
0,
null,null,
0,
null,null)


END');
END;
