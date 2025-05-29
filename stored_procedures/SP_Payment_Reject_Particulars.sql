IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Payment_Reject_Particulars]') 
    AND type = N'P'
)
BEGIN
    EXEC('

CREATE procedure [dbo].[SP_Payment_Reject_Particulars]             
@Approval_Id bigint        
AS           
BEGIN          
        
 Update Tbl_Payment_Approval_List Set Approval_Status=2,          
  Approval_Date=getdate()          
Where Approval_Id=@Approval_Id         
END

    ')
END;
