IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Insert_Event_Employees]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Insert_Event_Employees]  
(  
     @EventId  bigint,  
  @EmployeeId   bigint=0,  
  @Flag bigint=0  
   
   
)  
As  
  
Begin  
if(@Flag=0)  
begin  
 Insert into Tbl_Event_Staff(EventID, OtherStaff)values(@EventId,@EmployeeId)  
end  
if(@Flag=1)  
Begin  
  
Insert into Tbl_Marketing_ManangerApproval(Event_Id, Approval_Status,Approval_Remark,Reject_Remark)values(@EventId,0,null,null)  
Select SCOPE_IDENTITY()   
End  
if(@Flag=2)  
Begin  
  
Insert into Tbl_Pso_Approval(Event_Id, Approval_Status,Approval_Remark,Reject_Remark)values(@EventId,0,null,null)  
Select SCOPE_IDENTITY()  
End  
if(@Flag=3)  
Begin  
  
Insert into Tbl_Director_Approvals(Event_Id, Approval_Status,Approval_Remark,Reject_Remark)values(@EventId,0,null,null)  
Select SCOPE_IDENTITY()  
End  
if(@Flag=4)  
Begin  
  
Insert into Tbl_MD_Approval(Event_Id, Approval_Status,Approval_Remark,Reject_Remark)values(@EventId,0,null,null)  
  
End  
if(@Flag=5)  
Begin  
  
Update Tbl_Marketing_ManangerApproval set  Approval_Status=1 where Event_Id=@EventId  
End  
  
if(@Flag=6)  
Begin  
  
Update Tbl_Marketing_ManangerApproval set  Approval_Status=1 where Event_Id=@EventId  
Update Tbl_Pso_Approval set  Approval_Status=1 where Event_Id=@EventId  
  
End  
  
   
   
End   ');
END;
