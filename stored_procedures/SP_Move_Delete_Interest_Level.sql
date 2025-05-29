IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Move_Delete_Interest_Level]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Move_Delete_Interest_Level]
@newstatusID int = 0,
@oldstatusID int = 0,
@interestlevelID INT = 0

AS
BEGIN


--update Tbl_Lead_Personal_Det set LeadStatus_Id = @newstatusID
--where LeadStatus_Id = @oldstatusID;
 
	  UPDATE  Tbl_Interest_level_Master
      SET Interest_level_DelStatus = 1
      WHERE InterestLevel_ID = @interestlevelID;
 
		
INSERT INTO Tbl_Interest_level_Mapping (InterestLevel_ID, Lead_Status_Id, CreatedDate)
VALUES(@newstatusID,@oldstatusID,GETDATE())
--SELECT @newstatusID, Lead_Status_Id, GETDATE()
--FROM Tbl_Interest_level_Mapping
--WHERE InterestLevel_ID = @interestlevelID;




END
');
END;
