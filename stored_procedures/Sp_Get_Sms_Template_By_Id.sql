IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_Sms_Template_By_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE procedure [dbo].[Sp_Get_Sms_Template_By_Id] 
(@Template_id bigint)
As
Begin

Select * from Tbl_Sms_Template where Template_id=@Template_id

End	');
END;
