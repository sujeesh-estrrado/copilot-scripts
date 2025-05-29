IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Delete_Docket]') 
    AND type = N'P'
)
BEGIN
    EXEC('
create procedure [dbo].[Sp_Delete_Docket]
@Docket_Id bigint=0
as
 begin

 update Tbl_ExamDocket set Delete_Status=1 where Docket_Id=@Docket_Id
 end
    ')
END;
