IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Delete_Sms_Template]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[Sp_Delete_Sms_Template]
(@Template_id bigint)
As
Begin

Delete from Tbl_Sms_Template where Template_id=@Template_id


End
    ')
END
