IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_Sms_Group_By_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Sp_Get_Sms_Group_By_Id] 
(@Group_id bigint)
As
Begin

Select * from Tbl_Sms_Group where Group_id=@Group_id

End


   ')
END;
