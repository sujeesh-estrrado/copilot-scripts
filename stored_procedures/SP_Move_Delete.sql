IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Move_Delete]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Move_Delete]
@newstatusID int = '''',
@oldstatusID int = '''',
  @leadstatusId INT = ''''

as
begin


update Tbl_Lead_Personal_Det set LeadStatus_Id = @newstatusID
where LeadStatus_Id = @oldstatusID;

	  UPDATE Tbl_Lead_Status_Master
        SET Lead_Status_DelStatus = 1
        WHERE Lead_Status_Id = @leadstatusId;
end

'
)
END;
