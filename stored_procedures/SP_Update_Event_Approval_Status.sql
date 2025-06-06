IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Update_Event_Approval_Status]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[SP_Update_Event_Approval_Status]      
(      
     @EventId  bigint=0,      
  @Remark varchar(max),      
  @Flag bigint=0      
)      
as      
      
begin      
if(@Flag=0)      
begin      
update Tbl_Marketing_ManangerApproval set Approval_Status=1,Approval_Remark=@Remark where Event_Id=@EventId      
end      
if(@Flag=1)      
begin      
update Tbl_Marketing_ManangerApproval set Approval_Status=2,Reject_Remark=@Remark where Event_Id=@EventId      
end      
if(@Flag=2)      
begin      
update Tbl_Pso_Approval set Approval_Status=1,Approval_Remark=@Remark where Event_Id=@EventId      
end      
if(@Flag=3)      
begin      
update Tbl_Pso_Approval set Approval_Status=2,Reject_Remark=@Remark where Event_Id=@EventId      
end      
      
if(@Flag=4)      
begin      
update Tbl_Director_Approvals set Approval_Status=1,Approval_Remark=@Remark where Event_Id=@EventId      
end      
      
if(@Flag=5)      
begin      
update Tbl_Director_Approvals set Approval_Status=2,Reject_Remark=@Remark where Event_Id=@EventId      
update Tbl_Event_Details set Del_Status=1 where Event_Id=@EventId      
end      
if(@Flag=6)      
begin      
update Tbl_Director_Approvals set Approval_Status=3,Approval_Remark=@Remark where Event_Id=@EventId      
end      
if(@Flag=7)      
begin      
update Tbl_MD_Approval set Approval_Status=1,Approval_Remark=@Remark where Event_Id=@EventId      
end      
if(@Flag=8)      
begin      
update Tbl_MD_Approval set Approval_Status=2,Approval_Remark=@Remark where Event_Id=@EventId      
update Tbl_Event_Details set Del_Status=1 where Event_Id=@EventId      
end      
 if(@Flag=9)      
begin      
update Tbl_Budget_Approvals set MarketingManagerApproval=1,MarketingManagerApproval_Remark=@Remark where Event_Id=@EventId      
      
end      
 if(@Flag=10)      
begin      
update Tbl_Budget_Approvals set PsoApproval=1,PsoApproval_Remark=@Remark where Event_Id=@EventId      
      
end      
 if(@Flag=11)      
begin      
update Tbl_Budget_Approvals set DirectorApproval=1,DirectorApproval_Remark=@Remark where Event_Id=@EventId      
      
end      
 if(@Flag=12)      
begin      
update Tbl_Budget_Approvals set DirectorApproval=3,DirectorApproval_Remark=@Remark where Event_Id=@EventId      
      
end      
 if(@Flag=13)      
begin      
update Tbl_Budget_Approvals set MD_Approval=1,MD_ApprovalRemark=@Remark where Event_Id=@EventId      
      
end      
 if(@Flag=14)      
begin      
update Tbl_Budget_Approvals set MarketingManagerApproval=2,MarketingManagerReject_Remark=@Remark where Event_Id=@EventId      
end      
 if(@Flag=15)      
begin      
update Tbl_Budget_Approvals set PsoApproval=2,PsoReject_Remark=@Remark where Event_Id=@EventId      
      
end      
if(@Flag=16)      
begin      
update Tbl_Budget_Approvals set DirectorApproval=2,DirectorReject_Remark=@Remark ,MarketingManagerApproval=0,PsoApproval=0 where Event_Id=@EventId      
    
end      
if(@Flag=17)      
begin      
update Tbl_Budget_Approvals set MD_Approval=2,MD_RejectRemark=@Remark,MarketingManagerApproval=0,PsoApproval=0,DirectorApproval=0 where Event_Id=@EventId      
    
end      
if(@Flag=18)      
begin      
update Tbl_Budget_Approvals set MD_Approval=0,MD_RejectRemark='''', MarketingManagerApproval=2,MarketingManagerApproval_Remark='''',      
PsoApproval=0,PsoApproval_Remark='''',DirectorApproval=0,DirectorApproval_Remark='''' where Event_Id=@EventId      
      
end   

 if(@Flag=19)      
begin      
update Tbl_Budget_Approvals set MarketingManagerApproval=1,PsoApproval=1,MarketingManagerApproval_Remark=@Remark where Event_Id=@EventId      
      
end 
       
      
End   
    ')
END
