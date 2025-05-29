IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Delete_Sms_Group]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Sp_Delete_Sms_Group]
(@Group_id bigint)
As
Begin

Delete from Tbl_Sms_Group where Group_id=@Group_id


End

   ')
END;
