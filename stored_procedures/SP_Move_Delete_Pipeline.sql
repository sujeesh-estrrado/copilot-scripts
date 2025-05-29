IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Move_Delete_Pipeline]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Move_Delete_Pipeline] 
@newstatusID int = 0,
@oldstatusID int = 0,
@Pipeline_Id INT = 0

AS
BEGIN

	  UPDATE  Tbl_Pipeline_Settings
      SET Delete_Status = 1
      WHERE Pipeline_Id = @Pipeline_Id;

	 -- update tbl_Lead_Status_Maping set Lead_Status_Del=1 WHERE Pipeline_Id = @Pipeline_Id;
 
		SET IDENTITY_INSERT Tbl_Pipeline_Settings ON;

INSERT INTO tbl_Lead_Status_Maping(Pipeline_Id, Lead_Satus_Id)
VALUES(@newstatusID,@oldstatusID)

SET IDENTITY_INSERT Tbl_Pipeline_Settings OFF;

end
');
END;
