IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Move_Delete_Lead_status]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Move_Delete_Lead_status]
@newstatusID int = 0,
@oldstatusID int = 0,
@leadstatusID INT = 0

as
begin


 
		UPDATE  Tbl_Lead_Status_Master
        SET Lead_Status_DelStatus = 1
        WHERE Lead_Status_Id = @leadstatusID;
		update Tbl_Lead_Personal_Det set LeadStatus_Id = @newstatusID
		where LeadStatus_Id = @leadstatusID;
 

 -----TO UPDATE THE LEAD STATUS IN FOLLOW UP IN APPLICATION LIST

		update Tbl_FollowUp_Detail set LeadStatus_Id = @newstatusID
		where LeadStatus_Id = @leadstatusID;
 
        update Tbl_FollowUpLead_Detail set LeadStatus_Id = @newstatusID
		where LeadStatus_Id = @leadstatusID;

end
');
END;
