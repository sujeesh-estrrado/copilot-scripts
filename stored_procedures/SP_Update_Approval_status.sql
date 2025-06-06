IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Update_Approval_status]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[SP_Update_Approval_status]
(
     @Event_Id bigint,
     @Manager_ApprovalStatus bigint,
     @Pso_ApprovalStatus bigint,
     @Director_ApprovalStatus bigint
    
)
As

Begin

    update Tbl_Event_Details set MarketingMangerApproval_ID=@Manager_ApprovalStatus,PsoApproval_ID=@Pso_ApprovalStatus,DirectorApproval_ID=@Director_ApprovalStatus
    where Event_Id=@Event_Id
    
End
    ')
END
