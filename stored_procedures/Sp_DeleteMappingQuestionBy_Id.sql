IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_DeleteMappingQuestionBy_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
create procedure [dbo].[Sp_DeleteMappingQuestionBy_Id]
@Permanent_FormId bigint
as
begin
delete tbl_PermanentFormMapping where Permanent_FormId=@Permanent_FormId

end
   ')
END;
