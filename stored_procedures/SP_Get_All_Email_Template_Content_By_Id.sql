IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_All_Email_Template_Content_By_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
      CREATE procedure [dbo].[SP_Get_All_Email_Template_Content_By_Id]   
@Email_Template_Id bigint
As begin
select * from Tbl_Email_Template where Email_Template_Id=@Email_Template_Id and Email_Status = 0

END
    ')
END
